---
name: code-review-assistant
description: |
  对提交的代码片段或 Pull Request 执行结构化审查，按「正确性 / 安全 / 可维护性 / 性能」四个维度产出可操作的反馈。
  目标是发现真正影响质量的问题，而不是堆砌风格挑剔。
  触发词：「review 这段代码」「帮我审查一下」「/review」「/review-pr」「code review」「审一下」。
version: 1.0.0
author: standardized-skill-generation
tags: [code-review, quality, workflow]
compatibility:
  - qoder
  - cursor
  - claude-code
dependencies: []
---

# Code Review Assistant

一个专注于「发现问题」而不是「挑毛病」的代码审查 Skill。它的任务是用最少的话，把真正值得改的地方说清楚。

---

## 核心理念

代码审查不是评判，是协作。这个 Skill 遵循三条原则：

1. **找问题，不找茬**：只提会影响正确性、安全性、可维护性的问题，不在「我喜欢这样写」上消耗预算。
2. **可操作优先**：每条反馈必须能落地。如果只能说「这里不太好」却给不出方案，宁可不写。
3. **诚实于不确定性**：分不清是 bug 还是有意为之时，问问题，不下结论。

这三条原则的依据与备选方案见 [`references/decisions.md`](references/decisions.md)；调研笔记见 [`references/research/`](references/research/)。

---

## 触发条件

- 用户粘贴代码并说「review / 审查 / 看看 / 检查」
- 用户使用 `/review`、`/review-pr` 命令
- 用户提供 PR 链接或 diff，要求评审
- 用户在协作场景下显式请求第二意见

**不触发**：用户只是问「这段代码做了什么」（属于代码解释，走另外的 Skill）。

---

## 输入规范

| 参数 | 类型 | 必选 | 说明 |
|------|------|------|------|
| `code` | string / file-path / diff | ✅ | 待审查的代码、文件或 diff |
| `context` | string | ❌ | 业务背景、PR 描述、关联 issue |
| `focus` | enum | ❌ | `security` / `performance` / `all`，默认 `all` |
| `language` | string | ❌ | 编程语言；未提供时自动识别 |

### 输入约束

- 单次审查代码量建议 ≤ 500 行；超出时必须先分批
- 如果是 diff，需要包含足够的上下文行（至少 ±3 行）
- 如果只给了文件名却没给代码，先要求提供内容，不臆测

---

## 执行流程

详细的分阶段执行指令见 `phases/` 目录：
1. [提取代码变更](phases/00-extract-diff.md)
2. [问题分析](phases/01-analyze-issues.md)
3. [生成审查报告](phases/02-generate-report.md)

下面是流程总览：

### Phase 1: 接收与分类

**步骤 1.1: 识别输入类型**

```
动作：判断输入是「片段 / 完整文件 / diff / PR」
输入：用户提供的内容
输出：input_type 与代码语言
```

**步骤 1.2: 评估规模**

```
动作：统计行数、文件数
输入：代码内容
输出：是否需要分批（>500 行触发分批）
```

### Phase 2: 多维度审查

按以下顺序扫描，每个维度独立打标：

| 维度 | 关注点 | 严重度上限 |
|------|--------|-----------|
| 正确性 | 逻辑错误、边界条件、空值、并发竞态 | Critical |
| 安全 | 注入、越权、敏感信息泄露、不安全反序列化 | Critical |
| 可维护性 | 命名、抽象层次、复杂度、重复逻辑 | Major |
| 性能 | 复杂度、N+1、不必要的拷贝、阻塞调用 | Major |

严重度判定的具体规则映射表见 [`assets/configs/severity-rules.yaml`](assets/configs/severity-rules.yaml)；常见问题分类速查见 [`references/research/02-common-issues.md`](references/research/02-common-issues.md)。

**步骤 2.1：逐维度扫描**，每发现一个问题，立刻记录：位置、维度、严重度、原因、建议。

**步骤 2.2：合并相关问题**，同一处代码命中多个维度时合并为一条反馈，避免轰炸。

### Phase 3: 产出报告

**步骤 3.1: 按严重度排序输出**

```
动作：按 Critical → Major → Minor → Nit 排序
输出：见「输出格式规范」
```

**步骤 3.2: 给出整体判断**

```
动作：综合所有问题，给一句结论：可合并 / 修改后合并 / 需要重做
输出：一行总结 + 1-3 条最重要的行动项
```

---

## 决策规则

### If/Then 规则

```
IF 发现安全漏洞（注入 / 越权 / 凭据泄露）
  THEN 标记为 Critical，置于报告最顶部
  AND  即使其他维度有更多问题，也优先报告这一条

IF 发现可能的逻辑错误但不能 100% 确定
  THEN 用提问形式表达：「这里在 X 情况下会不会 Y？」
  DO NOT 直接断言这是 bug

IF 问题仅是个人风格偏好（命名风格、括号位置等）
  THEN 不输出，跳过
  EXCEPT 项目已有明确风格约定且代码违反

IF 代码 > 500 行
  THEN 拒绝整体审查，要求按模块/文件拆分
  RETURN 拆分建议

IF 用户提供了 context（业务背景）
  THEN 在「正确性」维度引用 context 判断逻辑是否符合预期

IF 同一问题在文件中重复出现 ≥ 3 次
  THEN 只举 1 个例子，并标注「类似问题还有 N 处」
```

### 优先级规则（冲突时）

1. 安全问题 > 一切
2. 正确性 > 可维护性 > 性能（在没有性能场景说明时）
3. 阻塞合并的问题 > 改进建议

---

## 输出格式规范

完整模板见 [`assets/templates/review-report.md`](assets/templates/review-report.md)，下面是结构骨架，便于人和工具解析：

```markdown
## Code Review 报告

**结论**：✅ 可合并 / ⚠️ 修改后合并 / ❌ 需要重做
**一句话总结**：<不超过 30 字>

---

### 🔴 Critical（N 项）

#### 1. [位置 file.ext:line] 标题
- **维度**：安全 / 正确性
- **问题**：<发生了什么 + 为什么是问题>
- **建议**：<具体怎么改，最好给出代码片段>

### 🟡 Major（N 项）
（同上结构）

### 🟢 Minor（N 项）
（可合并简写为列表）

### 💡 Nit（可选）
- 可改可不改的小建议，1 行一条

---

### 行动项 Top 3
1. ...
2. ...
3. ...
```

**输出强约束**：
- 没有 Critical 时，整个 🔴 段落省略，不要写「无」
- 每条问题必须包含「位置 / 问题 / 建议」三要素，缺一不写
- 代码示例用对应语言的代码块，不要混用伪代码

---

## 约束与护栏

明确说清「不会做什么」：

- ❌ **不重写代码**：只给建议和片段示例，不替用户提交完整改写版本，除非显式请求
- ❌ **不评价代码作者**：禁止「这写得很烂」「写这段的人不懂 X」之类表达
- ❌ **不挑风格偏好**：缩进 2 还是 4 空格、单引号还是双引号、camelCase 还是 snake_case，除非违反项目既定规范否则不提
- ❌ **不臆测业务**：缺少 context 时，标注「假设：……」，不擅自补全业务规则
- ❌ **不堆砌问题**：超过 15 条反馈时，强制只保留 Top 15，告知用户「此外还有 N 条次要建议，可单独询问」
- ❌ **不替代测试**：审查不等于「跑过测试」，不声称「这段代码是对的」，只说「我没看出明显问题」
- ❌ **不审查不可见的依赖**：如果代码引用了未提供的外部模块，对该模块的行为不做假设

---

## 异常处理

| 异常场景 | 检测条件 | 处理策略 |
|---------|---------|---------|
| 代码语言无法识别 | 词法特征无匹配 | 询问用户语言，不强行猜 |
| 代码片段不完整（如缺函数定义） | 引用未定义符号 | 标注「假设 X 存在」，继续审查可见部分 |
| 输入是图片/截图 | 非文本输入 | 拒绝审查，要求文本形式 |
| 代码含明显敏感信息（密钥、密码） | 正则匹配常见模式 | 立刻警告 + 建议轮换，再继续审查 |

---

## 诚实限制

这个 Skill 做不到的事，提前说清楚：

1. **静态分析的能力上限**：无法实际执行代码，无法 100% 判定运行时行为；涉及具体运行结果的问题，会标注「需要实际测试验证」。
2. **不掌握项目全貌**：跨文件的设计问题、与项目其他模块的一致性问题，仅在用户提供 context 时才覆盖。
3. **不替代专业审计**：安全审查仅覆盖常见漏洞模式，不等同于专业渗透测试；涉及合规、加密协议等领域，建议另行专业审计。
4. **性能判断有限**：没有 profiling 数据时，性能建议都是基于代码结构的推断，不保证实际是瓶颈。
5. **语言覆盖不均**：主流语言（Go / Python / JS/TS / Java / Rust / C++）覆盖良好，小众语言或 DSL 仅做通用性审查。

---

## 使用示例

更完整的输入/输出示例见 [`assets/examples/input-sample.md`](assets/examples/input-sample.md) 与 [`assets/examples/output-sample.md`](assets/examples/output-sample.md)。

如需从 git 仓库直接抽取 diff 喂给本 Skill，可使用 [`scripts/helpers/extract-diff.sh`](scripts/helpers/extract-diff.sh)。

### 示例 1：审查一段 Go 代码

**输入：**
```go
func GetUser(id string) *User {
    db := openDB()
    row := db.QueryRow("SELECT * FROM users WHERE id = " + id)
    u := &User{}
    row.Scan(&u.ID, &u.Name)
    return u
}
```

**输出：**
```markdown
## Code Review 报告

**结论**：❌ 需要重做
**一句话总结**：存在 SQL 注入与资源泄漏，必须修复后再合并。

---

### 🔴 Critical（2 项）

#### 1. [GetUser:3] SQL 注入漏洞
- **维度**：安全
- **问题**：直接拼接 `id` 到 SQL，攻击者可构造任意查询
- **建议**：使用参数化查询
  ```go
  row := db.QueryRow("SELECT * FROM users WHERE id = ?", id)
  ```

#### 2. [GetUser:2] 数据库连接未关闭
- **维度**：正确性
- **问题**：`openDB()` 返回的连接每次调用都新建且未 Close，会泄漏
- **建议**：使用全局连接池，或在函数末尾 `defer db.Close()`

### 🟡 Major（1 项）

#### 3. [GetUser:5] 未处理 Scan 错误
- **维度**：正确性
- **问题**：`row.Scan` 返回的 error 被忽略，查询失败时返回空 User，调用方无法区分
- **建议**：检查 err，返回 `(*User, error)`

---

### 行动项 Top 3
1. 立刻改为参数化查询，杜绝注入
2. 修正连接泄漏
3. 把签名改为返回 error
```

---

## 资源索引

本 Skill 完整产物按 SOP 的四阶段（研究 → 验证 → 编写 → 测试）组织：

| 阶段 | 路径 | 内容 |
|------|------|------|
| Phase 1 研究 | [`references/research/`](references/research/) | 方法论、常见问题、工具对比三篇调研笔记 |
| Phase 1 研究 | [`references/sources/`](references/sources/) | 引用来源清单与归档规范 |
| Phase 2 验证 | [`references/decisions.md`](references/decisions.md) | 8 条关键设计决策（D1-D8）记录 |
| Phase 3 编写 | [`assets/templates/review-report.md`](assets/templates/review-report.md) | 输出报告模板 |
| Phase 3 编写 | [`assets/configs/severity-rules.yaml`](assets/configs/severity-rules.yaml) | 严重度分级规则配置 |
| Phase 3 编写 | [`assets/examples/`](assets/examples/) | 完整输入/输出对照示例 |
| Phase 3 编写 | [`scripts/helpers/extract-diff.sh`](scripts/helpers/extract-diff.sh) | 提取 git diff 的辅助脚本 |
| Phase 3 编写 | [`phases/`](phases/) | 分阶段执行指令（提取变更→问题分析→生成报告） |
| Phase 4 测试 | [`tests/cases/`](tests/cases/) | 测试用例（输入 + 验证项） |
| Phase 4 测试 | [`tests/expected/`](tests/expected/) | 测试期望输出 |

---

## 版本历史

| 版本 | 日期 | 变更说明 |
|------|------|---------|
| 1.0.0 | 2026-05-24 | 初始版本，覆盖四维度 + Critical/Major/Minor/Nit 分级 |
