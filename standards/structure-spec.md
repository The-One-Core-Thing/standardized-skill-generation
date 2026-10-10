# SKILL.md 结构规范

定义一个合格 SKILL.md 文件的完整字段与格式要求。

---

## 文件结构总览

```
my-skill/
├── SKILL.md              # 必需：核心指令文件（元数据 + 执行逻辑）
├── references/           # 推荐：研究资料和决策依据
│   ├── research/         #   调研过程产物（各维度的研究笔记）
│   ├── sources/          #   一手素材（文档、transcript 等）
│   └── decisions.md      #   关键设计决策记录
├── assets/               # 可选：静态资源
│   ├── templates/        #   输出模板（报告格式、代码模板等）
│   ├── configs/          #   配置文件（规则集、阈值等）
│   └── examples/         #   输入输出示例
├── scripts/              # 可选：辅助脚本
│   ├── setup.sh          #   环境准备
│   └── helpers/          #   工具脚本
├── phases/               # 可选：复杂流程的分阶段详细指令
│   ├── 00-init.md        #   阶段0：初始化/需求确认
│   ├── 01-research.md    #   阶段1：内容研究
│   └── ...
└── tests/                # 推荐：验证用例
    ├── cases/            #   测试输入
    └── expected/         #   期望输出
```

---

## 目录结构规范

### 必需 / 推荐 / 可选 判断标准

| 标注 | 含义 | 判断依据 |
|------|------|---------|
| 必需 | 缺失则 Skill 无效 | 没有它 Agent 无法识别或加载 Skill |
| 推荐 | 强烈建议存在 | 影响可维护性、可信度、可验证性；复杂 Skill 必须具备 |
| 可选 | 按需创建 | 仅当 Skill 实际需要该类资源时才创建，否则省略 |

通用原则：**不创建空目录**。某类资源不存在时直接省略对应子目录，不要保留空壳。

---

### `SKILL.md`（必需）

- **用途**：Skill 的入口指令文件，Agent 通过它发现和加载 Skill
- **包含内容**：YAML Frontmatter（元数据） + Markdown 正文（执行逻辑）
- **命名规则**：固定为 `SKILL.md`（全大写），不可改名
- **何时必需**：始终必需，缺失则不构成 Skill

---

### `references/`（推荐）

- **用途**：记录 Skill 生成过程中的研究资料、信息来源和设计决策，让 Skill 可溯源
- **包含内容**：
  - `research/`：调研笔记，按主题/维度组织（如 `domain-analysis.md`、`competitor-review.md`）
  - `sources/`：一手素材，如文档摘录、访谈 transcript、链接归档（如 `interview-2025-01.md`、`spec-v2.pdf`）
  - `decisions.md`：关键设计决策记录，说明"为什么这么设计、放弃了哪些选项"
- **命名规则**：
  - 子目录用 kebab-case
  - 笔记文件用描述性命名 + kebab-case：`research/api-design-patterns.md`
  - 决策记录单文件统一用 `decisions.md`
- **何时推荐**：Skill 涉及领域知识、有设计权衡、需要后续维护时强烈建议
- **何时可省**：极简 Skill（规则全部来自通用常识、无需溯源）

---

### `assets/`（可选）

- **用途**：Skill 执行时引用的静态资源
- **包含内容**：
  - `templates/`：输出模板，如报告骨架、代码模板、邮件模板（如 `report-template.md`、`pr-description.md`）
  - `configs/`：配置文件，如规则集、阈值表、白名单（如 `rules.yaml`、`thresholds.json`）
  - `examples/`：输入输出示例，标注「好/坏」对比（如 `good-example.md`、`bad-example.md`）
- **命名规则**：
  - 模板：`<用途>-template.<ext>`
  - 配置：按内容命名 + 标准扩展名（`.yaml`/`.json`/`.toml`）
  - 示例：`<场景>-<good\|bad>.md` 或 `example-<场景>.md`
- **何时可选**：Skill 需要产出固定格式、依赖外部规则数据、或用示例辅助理解时创建
- **何时可省**：纯流程指令、无固定输出格式时不需要

---

### `scripts/`（可选）

- **用途**：辅助自动化脚本，减少 Agent 重复劳动
- **包含内容**：
  - `setup.sh`：环境准备脚本（依赖检查、目录初始化）
  - `helpers/`：工具脚本子目录（数据预处理、格式转换、批量校验）
- **命名规则**：
  - 入口脚本用动词命名：`setup.sh`、`validate.sh`、`generate.py`
  - 工具脚本放 `helpers/` 下，kebab-case + 扩展名
  - 优先用跨平台脚本（Python/Node），shell 脚本需注明平台兼容性
- **何时可选**：Skill 涉及环境检查、数据预处理、批量操作时创建
- **何时可省**：纯认知/指令型 Skill 不需要

---

### `phases/`（可选）

- **用途**：存放复杂 Skill 的分阶段执行指令
- **包含内容**：每个 phase 一个 `.md` 文件，内容是该阶段的详细执行逻辑
- **命名规则**：`XX-phase-name.md`，XX 为两位数字序号（`00`、`01`、`02`...），phase-name 为阶段简称（kebab-case），如 `00-init.md`、`01-research.md`
- **何时使用**：
  - 推荐：流程 ≥ 4 个阶段，且任一阶段指令超过 50 行
  - 可考虑：流程 3 个阶段，但整体复杂度高
  - 不需要：流程 ≤ 3 个阶段且总指令 < 200 行
- **设计原则**：
  - SKILL.md 必须保留完整的阶段列表和编排逻辑（流程总览），不能让读者必须打开 `phases/` 才知道有哪些阶段
  - 每个 phase 文件开头标注：输入、输出、前置条件、完成条件
  - phase 之间的跳转逻辑（如失败回退）在 SKILL.md 中定义，不分散到 phase 文件里

---

### `tests/`（推荐）

- **用途**：验证 Skill 是否按预期工作，支持回归检查
- **包含内容**：
  - `cases/`：测试输入，每个用例一个文件或子目录（如 `case-01-basic/input.md`）
  - `expected/`：对应的期望输出（如 `case-01-basic/output.md`）
- **命名规则**：
  - 用例命名：`case-<编号>-<场景描述>`，编号两位数（`case-01-...`、`case-02-...`）
  - `cases/` 与 `expected/` 下用例文件名一一对应
- **何时推荐**：Skill 输出格式化结果、规则较多、需要长期维护时强烈建议
- **何时可省**：一次性、极简 Skill

---

## YAML Frontmatter

SKILL.md 必须以 YAML frontmatter 开头，用 `---` 包裹。

```yaml
---
name: skill-name
description: |
  一句话描述 Skill 功能。
  触发词：当用户提到 X / 要求 Y / 使用 /command 时激活。
version: 1.0.0
author: optional-author
tags: [tag1, tag2]
compatibility: [qoder, cursor, claude-code]
dependencies: []
---
```

---

## 字段定义

### 必填字段

| 字段 | 类型 | 格式要求 | 说明 |
|------|------|---------|------|
| `name` | string | kebab-case，全小写，连字符分隔 | Skill 唯一标识 |
| `description` | multiline string | 包含功能描述 + 触发条件 | 用于自动匹配触发 |
| `version` | string | 语义化版本 `MAJOR.MINOR.PATCH` | 版本追踪 |

正文中必须包含：
- **核心指令/流程部分** — 具体执行逻辑
- **约束/限制部分** — 边界与禁止行为

### 推荐字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `compatibility` | string[] | 支持的平台列表 |
| 触发词列表 | 正文 section | 明确列出所有触发词/命令 |
| 使用场景与边界 | 正文 section | 何时用 / 何时不用 |

### 可选字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `author` | string | 作者标识 |
| `tags` | string[] | 分类标签，便于检索 |
| `dependencies` | string[] | 依赖的其他 Skill |
| `scripts/` | directory | 辅助执行脚本 |

---

## 正文格式规范

### 推荐结构

```markdown
# Skill 名称

## 触发条件
- 当用户 ...
- 使用 /command 时
- 关键词：...

## 使用场景
**适用：**
- 场景 A
- 场景 B

**不适用：**
- 场景 C
- 场景 D

## 核心流程
1. 步骤一
2. 步骤二
3. 步骤三

## 决策规则
- If [条件] → Then [行动]
- If [条件] → Then [行动]

## 约束与限制
- 不要 ...
- 禁止 ...
- 边界：...

## 输出格式
（定义输出的结构、样式要求）
```

### 写作原则

- 决策规则用 `If/Then` 格式，不用抽象描述
- 流程必须有明确的输入、输出、完成条件
- 约束用否定句式，具体说明禁止行为
- 避免平台特定语法，保持通用性

---

## 格式约束

### YAML Frontmatter

- 必须是文件开头第一行 `---`
- 字段名全小写
- 多行字符串用 `|` 或 `>` 语法
- 列表用 `[item1, item2]` 或缩进 `- item` 格式

### Markdown 正文

- 标题层级：`#` 为 Skill 名，`##` 为主要 section，`###` 为子 section
- 列表优先于段落叙述
- 代码块标注语言类型
- 表格用于结构化对比信息

### 文件命名规则

- 主文件固定为 `SKILL.md`（大写）
- 目录名用 kebab-case：`my-skill-name/`
- 脚本文件用 kebab-case + 对应扩展名
- 示例文件用描述性命名：`example-basic-usage.md`

---

## 最小示例

```yaml
---
name: code-review
description: |
  执行代码审查，提供结构化反馈。
  触发词：当用户要求 review 代码、使用 /review 命令时激活。
version: 1.0.0
---
```

```markdown
# Code Review

## 触发条件
- 用户使用 /review 或 /review-pr
- 用户要求审查代码

## 核心流程
1. 读取目标代码
2. 按维度分析（正确性、可读性、性能、安全）
3. 输出结构化反馈

## 决策规则
- If 发现安全漏洞 → Then 标记为 Critical，优先提示
- If 仅风格问题 → Then 标记为 Suggestion，不阻塞

## 约束
- 不修改代码，只提供建议
- 不评价代码作者
- 超过 500 行时要求分批审查
```
