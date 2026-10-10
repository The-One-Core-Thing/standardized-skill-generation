# 测试用例：SQL 注入场景

> 测试 ID：case-01-sql-injection
> 目的：验证 Skill 能正确识别 SQL 注入并标记为 Critical
> 维度覆盖：安全（主） / 正确性（次）

---

## 输入

**用户消息**："帮我 review 下面这段代码"

**附加 context**：无（故意不给 context，测试 Skill 在缺乏上下文时的判断）

**待审查代码（Python / Flask）**：

```python
from flask import Flask, request, jsonify
import sqlite3

app = Flask(__name__)

@app.route("/search")
def search():
    keyword = request.args.get("q")
    conn = sqlite3.connect("app.db")
    cursor = conn.cursor()
    sql = "SELECT id, title FROM articles WHERE title LIKE '%" + keyword + "%' ORDER BY created_at DESC"
    cursor.execute(sql)
    rows = cursor.fetchall()
    return jsonify([{"id": r[0], "title": r[1]} for r in rows])

@app.route("/article/<id>")
def article(id):
    conn = sqlite3.connect("app.db")
    cursor = conn.cursor()
    cursor.execute(f"SELECT * FROM articles WHERE id = {id}")
    row = cursor.fetchone()
    return jsonify(row) if row else ("", 404)
```

---

## 验证项（Skill 必须命中）

### 必须识别（Critical）
1. ✅ `/search` 中字符串拼接 `keyword` 构造 LIKE SQL 注入（SEC-001）
2. ✅ `/article/<id>` 中 f-string 拼接 `id` 注入（SEC-001）

### 应该识别（Major）
3. ✅ `sqlite3.connect` 未关闭（COR-002）
4. ✅ `cursor.execute` 错误未处理（COR-001）

### 可识别（Minor / Nit）
- 无强制要求

### 必须避免的失败模式
- ❌ 不要遗漏 `/article/<id>` 的注入（f-string 形式比 `+` 更隐蔽，是常见漏检点）
- ❌ 不要把 SQL 注入降级为 Major
- ❌ 不要给出修复 patch，只给建议片段
- ❌ 不要评价代码作者
- ❌ 不要超过 15 条总反馈（本场景应在 4-6 条之内）

### 严重度排序
- Critical 必须排在最前
- 行动项 Top 3 必须包含"参数化查询"

---

## 期望输出

见同名文件 `tests/expected/test-sql-injection-expected.md`
