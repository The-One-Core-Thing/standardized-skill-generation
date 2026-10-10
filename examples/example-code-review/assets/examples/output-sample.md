# 输出示例：审查报告样例

> 这是 `input-sample.md` 中代码经过 code-review-assistant 审查后应得到的报告样例。
> 用作 Skill 输出格式的"标准答案"参考。

---

## Code Review 报告

> 审查对象：`handlers/user.go`
> 审查范围：单文件（行数 47）
> 审查日期：2026-05-24
> 审查者：code-review-assistant v1.0.0

---

**结论**：❌ 需要重做
**一句话总结**：存在多处 SQL 注入、硬编码密码与鉴权缺失，必须整体重写后再合。

---

## 🔴 Critical（6 项）

### 1. [handlers/user.go:23] SQL 注入：GetUser 中 id 直接拼接
- **维度**：安全
- **问题**：`db.Query("... WHERE id = " + id)` 把请求参数拼进 SQL，攻击者可构造 `id=1 OR 1=1` 拖库
- **建议**：用参数化查询
  ```go
  rows, err := db.Query("SELECT id, name FROM users WHERE id = ?", id)
  ```

### 2. [handlers/user.go:43] SQL 注入：UpdateUser 中 id 与 body 直接拼接
- **维度**：安全
- **问题**：`fmt.Sprintf("UPDATE ... name='%s' WHERE id='%s'", body, id)` 同时拼接两个用户输入，且未校验 body
- **建议**：参数化 + 限制 body 长度
  ```go
  if len(body) > 64 { http.Error(w, "name too long", 400); return }
  _, err := db.Exec("UPDATE users SET name=? WHERE id=?", string(body), id)
  ```

### 3. [handlers/user.go:12] 硬编码数据库密码
- **维度**：安全
- **问题**：`DB_PASSWORD = "p@ssw0rd-prod-2025"` 写在源码里，进入 Git 历史就等于泄漏，且无法轮换
- **建议**：从环境变量读取并立刻轮换密码
  ```go
  dbPassword := os.Getenv("DB_PASSWORD")
  if dbPassword == "" { log.Fatal("DB_PASSWORD not set") }
  ```

### 4. [handlers/user.go:38] 路径穿越：日志路径拼接 id
- **维度**：安全
- **问题**：`os.OpenFile("/var/log/app/"+id+".log", ...)`，`id=../../etc/passwd` 可写入任意文件
- **建议**：白名单校验或用 hash 后的固定文件名
  ```go
  if !regexp.MustCompile(`^[a-zA-Z0-9_-]{1,32}$`).MatchString(id) {
      http.Error(w, "invalid id", 400); return
  }
  ```

### 5. [handlers/user.go:21,33] 两个 handler 鉴权缺失
- **维度**：安全
- **问题**：`GetUser` / `UpdateUser` 都未校验调用者身份，任意访问者可读改任意用户
- **建议**：在路由层加鉴权中间件，或在 handler 内校验 `r.Context()` 中的用户身份

### 6. [handlers/user.go:29] 日志泄露密码
- **维度**：安全
- **问题**：`log.Printf("... pwd=%s ...", DB_PASSWORD)` 把密码打到日志，日志聚合系统会进一步扩散
- **建议**：移除该日志字段；如已上线，立刻轮换密码并清理历史日志

---

## 🟡 Major（5 项）

### 7. [handlers/user.go:22,24,26] 错误全部被忽略
- **维度**：正确性
- **问题**：`sql.Open` / `db.Query` / `rows.Scan` 的 err 都用 `_` 丢弃，DB 故障时 handler 会以错误状态继续执行并返回脏数据
- **建议**：每处 err 都检查并提前返回
  ```go
  rows, err := db.Query(...)
  if err != nil { http.Error(w, "internal", 500); return }
  defer rows.Close()
  ```

### 8. [handlers/user.go:22,42] sql.Open 未关闭、未复用
- **维度**：正确性 / 性能
- **问题**：每次请求都新建一个 `*sql.DB`，且未 `Close`，连接会持续累积；`*sql.DB` 本身就是连接池，应作为全局变量
- **建议**：使用项目已有的 `db.Pool`，handler 中直接 `db.Pool.QueryContext(ctx, ...)`

### 9. [handlers/user.go:43-45] 循环 100 次执行同一 UPDATE
- **维度**：性能 / 正确性
- **问题**：循环里执行同一条 SQL 100 次，看不出业务意图。如果是想"重试"，应该有失败判断；如果是误写，会造成不必要负载
- **建议**：删掉循环改为单次执行；如需重试用 backoff 库

### 10. [handlers/user.go:31] XSS：响应未转义
- **维度**：安全
- **问题**：`fmt.Fprintf(w, "<h1>User: %s</h1>", u.Name)` 直接把数据库字段拼进 HTML，攻击者把 name 设成 `<script>...</script>` 可在管理界面执行 JS
- **建议**：用 `html/template` 或 `template.HTMLEscapeString(u.Name)`

### 11. [handlers/user.go:38] 文件句柄未关闭
- **维度**：正确性
- **问题**：`os.OpenFile` 返回的 `f` 未 `defer f.Close()`，长期运行会耗尽 fd
- **建议**：`defer f.Close()` + 检查 OpenFile 的 err

---

## 🟢 Minor（1 项）

- [handlers/user.go:12] `DB_PASSWORD` 全大写不符合 Go 命名约定 → 改为 `dbPassword`（包级私有）或读环境变量后用局部变量

---

## ❓ Questions（不确定项）

- [handlers/user.go:38] `UpdateUser` 把请求 body 写入 `/var/log/app/<id>.log` 这个设计意图是什么？是审计日志、用户文件存储，还是误用？不同意图下的修复方案完全不同，请补充 context。
- [handlers/user.go:43] 循环 100 次是有意为之（重试 / 压测）还是误写？

---

## 行动项 Top 3

1. 立即处理所有 SQL 注入与硬编码密码，密码须当场轮换
2. 在路由层补齐鉴权中间件，并补完所有 err 检查
3. 改用全局 `db.Pool` 并修复资源泄漏（DB / 文件句柄）

---

## 审查覆盖说明

- ✅ 已扫描维度：正确性 / 安全 / 可维护性 / 性能
- ⚠️ 未覆盖范围：路由注册、调用方代码、`db.Pool` 初始化逻辑（未提供）
- 🔍 建议补充验证：补 handler 单测覆盖鉴权失败、注入 payload；上线前做一次专业安全审计
