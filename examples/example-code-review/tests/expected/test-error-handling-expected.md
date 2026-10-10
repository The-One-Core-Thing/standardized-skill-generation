# 期望输出：test-error-handling

> 这是 `tests/cases/test-error-handling.md` 的标准答案输出。
> 重点验证 Skill 能区分"错误吞没"与"有意 swallow"，并对不确定情形用问句。

---

## Code Review 报告

> 审查对象：用户提交的 Go 代码片段
> 审查范围：单文件（约 45 行）
> 审查日期：YYYY-MM-DD
> 审查者：code-review-assistant v1.0.0

---

**结论**：⚠️ 修改后合并
**一句话总结**：错误处理过于乐观，脏数据会静默落入结果。

---

## 🟡 Major（4 项）

### 1. [ImportCSV:17] os.Open 错误被丢弃 + 文件未关闭
- **维度**：正确性
- **问题**：`f, _ := os.Open(path)` 把 err 丢弃，文件不存在时 `f` 为 nil，下一行 `csv.NewReader(f)` 会触发 nil 读；同时 f 未 `Close`
- **建议**：检查 err 并 defer Close
  ```go
  f, err := os.Open(path)
  if err != nil {
      return nil, fmt.Errorf("open csv: %w", err)
  }
  defer f.Close()
  ```

### 2. [ImportCSV:21-23] 循环退出条件混淆 io.EOF 与真正错误
- **维度**：正确性
- **问题**：`if err != nil { break }` 不区分 `io.EOF` 与解析错误，CSV 中间一行格式坏掉会导致整个文件被截断且不报错
- **建议**：仅在 EOF 时退出，其他错误向上抛
  ```go
  row, err := reader.Read()
  if errors.Is(err, io.EOF) { break }
  if err != nil { return nil, err }
  ```

### 3. [ImportCSV:25-26] strconv 错误被丢弃，脏数据落入结果
- **维度**：正确性
- **问题**：`Atoi` / `ParseFloat` 解析失败时返回零值且 err 被忽略，结果 slice 中会出现 ID=0 / Score=0 的"看起来正常"的脏数据
- **建议**：解析失败时跳过该行 + 记录行号；或累计错误向调用方返回

### 4. [ImportCSV:15] 函数签名不返回 error
- **维度**：可维护性 / 正确性
- **问题**：`ImportCSV(path string) []Record` 让调用方无法区分"文件不存在"、"全部解析失败"和"空文件"
- **建议**：改为 `(records []Record, err error)`，让上层（批处理框架）决定是否重试或告警

---

## 🟢 Minor（1 项）

- [Record:14] `Score float64` 用 float 表示分数，如果业务涉及金额或精确比较，建议改用 `int64`（分）或 decimal；当前业务是分数，可保留

---

## ❓ Questions（不确定项）

- [ImportCSV:30-32] `row[0]` / `row[1]` / `row[2]` 直接按下标访问，CSV 实际列数不足 3 时会 panic — 上游是否保证列数？建议至少 `if len(row) < 3 { continue }`
- [PrintRecord:42] `recover` 中静默吞掉 panic 已有注释说明是有意为之；问题是否应该至少 log 一行（带行号），方便事后排查坏数据？目前完全静默，发现"漏数据"几乎不可能

---

## 行动项 Top 3

1. 修正错误处理：分清 io.EOF / 解析错误 / 业务异常，让坏数据不静默通过
2. 把 `ImportCSV` 改为返回 `(records, error)`，给上游决策权
3. `recover` 至少补一行带行号的 log，避免完全静默

---

## 审查覆盖说明

- ✅ 已扫描维度：正确性 / 安全 / 可维护性 / 性能
- ⚠️ 未覆盖范围：调用方批处理框架的重试策略、CSV 数据来源是否可信
- 🔍 建议补充验证：补单测覆盖"文件不存在 / 列数不足 / 解析失败"三类用例

---

<!--
判定要点（用于人工核对）：
- [ ] 必须识别错误吞没（Major 1, 2, 3）
- [ ] 必须把 PrintRecord 的 recover 视为"有意 swallow"，不报为错误吞没（关键反例）
- [ ] 列数不足问题必须以 Question 形式输出，不是断言
- [ ] 利用 context 提示（"批处理任务"）调整严重度判断
- [ ] 不建议更换 CSV 库（越界）
- [ ] 反馈总数 ≤ 15
-->
