# 输入示例：待审查代码片段

> 场景：某内部用户管理后台的 Go HTTP handler，由新人提交 PR
> 业务背景：根据 URL 查询参数中的 `id` 返回用户详情；同一 endpoint 也支持更新用户名
> 文件：`handlers/user.go`
> 提交目的：实现 GET / POST 两种方法
> 上下文提示：项目其他 handler 都已使用 `db.Pool` 全局连接池

```go
package handlers

import (
	"database/sql"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

var DB_PASSWORD = "p@ssw0rd-prod-2025"

type User struct {
	ID   string
	Name string
}

func GetUser(w http.ResponseWriter, r *http.Request) {
	id := r.URL.Query().Get("id")
	db, _ := sql.Open("mysql", "root:"+DB_PASSWORD+"@/app")
	rows, _ := db.Query("SELECT id, name FROM users WHERE id = " + id)

	u := &User{}
	for rows.Next() {
		rows.Scan(&u.ID, &u.Name)
	}
	log.Printf("user query: id=%s pwd=%s result=%+v", id, DB_PASSWORD, u)

	fmt.Fprintf(w, "<h1>User: %s</h1>", u.Name)
}

func UpdateUser(w http.ResponseWriter, r *http.Request) {
	body, _ := ioutil.ReadAll(r.Body)
	id := r.URL.Query().Get("id")

	f, _ := os.OpenFile("/var/log/app/"+id+".log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	f.Write(body)

	db, _ := sql.Open("mysql", "root:"+DB_PASSWORD+"@/app")
	for i := 0; i < 100; i++ {
		db.Exec(fmt.Sprintf("UPDATE users SET name='%s' WHERE id='%s'", string(body), id))
	}

	w.WriteHeader(200)
}
```

---

## 已知问题埋点（用于验证 Skill 输出）

> 这部分是测试时给的"答案"，真实使用时用户不会提供。

预期 Skill 应识别出（按严重度）：

**Critical**
1. SQL 注入：`GetUser` 中 `id` 直接拼接到 SQL（SEC-001）
2. SQL 注入：`UpdateUser` 中 `id`、`body` 直接拼接（SEC-001）
3. 硬编码数据库密码 `DB_PASSWORD`（SEC-005）
4. 路径穿越：`UpdateUser` 中 `id` 直接拼接到文件路径（SEC-003）
5. 鉴权缺失：两个 handler 都未做身份/权限校验（SEC-006）
6. 日志泄露密码：`log.Printf` 输出 `DB_PASSWORD`（SEC-009）

**Major**
7. 错误全部被忽略：`sql.Open` / `db.Query` / `rows.Scan` 的 err 全丢（COR-001）
8. 数据库连接每次新建未关闭：`sql.Open` 无 `defer db.Close()`（COR-002）
9. N+1 / 无意义循环：`UpdateUser` 中循环 100 次执行同一 UPDATE（PRF-001）
10. XSS：`fmt.Fprintf(w, "<h1>%s</h1>", u.Name)` 未转义（SEC-007）
11. 文件句柄未关闭：`os.OpenFile` 后未 `defer f.Close()`（COR-002）

**Minor / Nit**
- 命名 `DB_PASSWORD` 用全大写不符合 Go 命名规范（MNT-003）
- `for rows.Next()` 用于查 1 行有点过度（MNT-001）

**Questions（不确定）**
- `UpdateUser` 是否应允许写入任意路径文件？这个 handler 的设计意图是什么？

总计应输出反馈：约 11-13 条主要问题（Critical 6 + Major 5 + Minor 1-2），不超过 15 条上限。
