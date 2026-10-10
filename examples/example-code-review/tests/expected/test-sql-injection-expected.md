# 期望输出：test-sql-injection

> 这是 `tests/cases/test-sql-injection.md` 的标准答案输出。
> 用于人工对照 Skill 实际输出，判断是否符合预期。
> 注意：自然语言生成允许措辞差异，但**结构、严重度、要点**必须命中。

---

## Code Review 报告

> 审查对象：用户提交的 Python/Flask 代码片段
> 审查范围：单文件（约 22 行）
> 审查日期：YYYY-MM-DD
> 审查者：code-review-assistant v1.0.0

---

**结论**：❌ 需要重做
**一句话总结**：两处 SQL 注入必须在合并前修复。

---

## 🔴 Critical（2 项）

### 1. [search:11] SQL 注入：LIKE 子句拼接用户输入
- **维度**：安全
- **问题**：`keyword` 直接以 `'%' + ... + '%'` 形式拼接到 SQL，攻击者可通过 `q=' OR '1'='1` 拖库
- **建议**：使用参数化查询并保留 `%` 通配符
  ```python
  cursor.execute(
      "SELECT id, title FROM articles WHERE title LIKE ? ORDER BY created_at DESC",
      (f"%{keyword}%",),
  )
  ```

### 2. [article:18] SQL 注入：f-string 拼接 id
- **维度**：安全
- **问题**：`f"... WHERE id = {id}"` 把 URL 路径参数直接写入 SQL，与字符串拼接同样危险
- **建议**：参数化 + 类型校验
  ```python
  if not id.isdigit():
      return "", 400
  cursor.execute("SELECT * FROM articles WHERE id = ?", (int(id),))
  ```

---

## 🟡 Major（2 项）

### 3. [search:9, article:17] 数据库连接未关闭
- **维度**：正确性
- **问题**：`sqlite3.connect` 返回的连接每次请求新建，且未 `close()` / 未用 `with`，长时间运行会泄漏 fd
- **建议**：用 `with sqlite3.connect(...) as conn:` 或在请求结束统一关闭

### 4. [search:12, article:18] cursor.execute 错误未处理
- **维度**：正确性
- **问题**：execute / fetch 抛异常时直接传播为 500，未做日志记录、也未返回友好错误
- **建议**：包一层 try/except，记录错误并返回 500 + 通用错误体

---

## ❓ Questions（不确定项）

- [article:18] `id` 是否一定是数字？路由声明 `<id>` 默认为字符串，如果业务允许非数字 id，类型校验需要按业务规则改

---

## 行动项 Top 3

1. 立即将所有 SQL 改为参数化查询（`?` 占位 + tuple）
2. 用 `with` 语句管理连接，避免 fd 泄漏
3. 补 try/except，区分"无结果"与"查询失败"

---

## 审查覆盖说明

- ✅ 已扫描维度：正确性 / 安全 / 可维护性 / 性能
- ⚠️ 未覆盖范围：Flask 路由层鉴权、表结构与索引（未提供）
- 🔍 建议补充验证：补单测覆盖注入 payload；上线前用 sqlmap 扫一遍

---

<!--
判定要点（用于人工核对）：
- [ ] Critical 数量 = 2，且都是 SQL 注入
- [ ] f-string 注入（Critical 2）必须命中，这是最容易漏的点
- [ ] 参数化查询的代码示例必须给出
- [ ] 反馈总数 ≤ 15（本例约 4-5 条主反馈 + 1 条问句）
- [ ] 不出现"代码作者"评价
- [ ] 不出现完整修复 patch，只给片段
-->
