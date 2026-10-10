# Skill 目录结构指南

这篇文档告诉你：每个目录/文件干什么、怎么用、哪些坑要避开。

---

## 一、总体目录结构概览

```
my-skill/
├── SKILL.md              # 核心指令文件，Skill 的入口和大脑
├── references/           # 研究资料和设计决策（为什么这么做）
│   ├── research/         #   调研笔记（方法论、竞品分析等）
│   ├── sources/          #   一手素材（文档摘录、访谈记录等）
│   └── decisions.md      #   设计决策记录（选了什么、放弃了什么）
├── assets/               # Skill 执行时用到的静态资源
│   ├── templates/        #   输出模板（报告格式、代码骨架等）
│   ├── configs/          #   配置文件（规则集、阈值、白名单等）
│   └── examples/         #   输入输出示例（好坏对比）
├── scripts/              # 辅助脚本（环境准备、数据处理等）
│   ├── setup.sh          #   环境初始化
│   └── helpers/          #   工具脚本集合
├── phases/               # 分阶段执行指令（复杂流程拆分）
│   ├── 00-init.md        #   阶段0：初始化/需求确认
│   ├── 01-research.md    #   阶段1：内容研究
│   └── ...
└── tests/                # 验证用例（确认 Skill 正常工作）
    ├── cases/            #   测试输入
    └── expected/         #   期望输出
```

**速查表：**

| 目录/文件 | 必要性 | 一句话说明 |
|-----------|:------:|-----------|
| `SKILL.md` | 必需 | 没它就不是 Skill |
| `references/` | 推荐 | 让 Skill 可溯源、可维护 |
| `assets/` | 可选 | 执行时引用的模板/配置/示例 |
| `scripts/` | 可选 | 自动化辅助，减少重复劳动 |
| `phases/` | 可选 | 复杂流程的分阶段执行指令 |
| `tests/` | 推荐 | 回归验证，确保改了不坏 |

---

## 二、各目录详解

---

### `SKILL.md`（核心指令文件）

| 项目 | 内容 |
|------|------|
| **用途** | Skill 的唯一入口，Agent 通过它发现、加载、执行 Skill |
| **包含内容** | YAML Frontmatter（name/description/version）+ Markdown 正文（流程/规则/约束） |
| **命名规范** | 固定 `SKILL.md`，全大写，不可改名 |

**注意事项：**
- 文件必须以 `---` 开头的 YAML Frontmatter 起始，否则部分平台无法识别
- 单文件不超过 500 行——超了就拆子文件
- `description` 字段里要写触发词，这是 Agent 自动匹配的关键
- 不要写 Agent 本来就会的东西（比如"怎么写 for 循环"）

**示例片段：**

```yaml
---
name: code-review-assistant
description: |
  对代码执行结构化审查，按四维度产出反馈。
  触发词：「review 代码」「/review」「帮我审查」
version: 1.0.0
compatibility: [qoder, cursor, claude-code]
---
```

---

### `README.md`（项目介绍）

| 项目 | 内容 |
|------|------|
| **用途** | 给人看的项目说明，不影响 Skill 执行 |
| **包含内容** | 项目背景、使用方法、目录说明、贡献指南 |
| **命名规范** | 固定 `README.md`，大写 |

**注意事项：**
- 这是给人看的，不是给 Agent 看的——Agent 只读 `SKILL.md`
- 不要把执行逻辑写在 README 里，那属于 SKILL.md 的职责
- 如果你的 Skill 非常简单（只有 SKILL.md），README 可以省略

---

### `references/research/`（调研产物）

| 项目 | 内容 |
|------|------|
| **用途** | 存放生成 Skill 过程中的调研笔记，记录"怎么来的" |
| **包含内容** | 方法论研究、竞品分析、领域知识梳理、工具对比等 |
| **命名规范** | kebab-case + `.md`，用描述性名称 |

**注意事项：**
- 这是过程产物，不是 Skill 执行时需要读的文件
- 按主题拆分文件，别搞一个巨大的 `notes.md`
- 如果有编号需求，用 `01-`、`02-` 前缀（仅 research 允许编号，其他目录不推荐）

**示例文件：**
```
references/research/
├── 01-review-methodologies.md    # 代码审查方法论调研
├── 02-common-issues.md           # 常见代码问题分类
└── 03-tool-comparison.md         # 审查工具对比
```

---

### `references/sources/`（一手素材）

| 项目 | 内容 |
|------|------|
| **用途** | 存放原始信息来源——文档摘录、访谈记录、规范原文等 |
| **包含内容** | PDF、文档截取、链接归档、transcript |
| **命名规范** | 描述性命名，附日期或版本号：`interview-2025-01.md`、`spec-v2.pdf` |

**注意事项：**
- 跟 `research/` 的区别：`sources/` 放**原始材料**，`research/` 放**你的分析笔记**
- 大文件（PDF、视频 transcript）如果太大，放链接+摘要即可
- 不要把自己写的分析文档放这里

**示例文件：**
```
references/sources/
├── owasp-top-10-2024.md          # OWASP 安全清单摘录
├── google-code-review-guide.md   # Google 代码审查指南节选
└── README.md                     # 来源说明和归档规则
```

---

### `references/decisions.md`（设计决策记录）

| 项目 | 内容 |
|------|------|
| **用途** | 记录关键设计选择：选了什么、为什么选、放弃了什么 |
| **包含内容** | 决策条目，每条包含背景、选项、选择、理由 |
| **命名规范** | 固定 `decisions.md`，单文件 |

**注意事项：**
- 这不是 changelog——不记录"改了什么"，记录"为什么这么设计"
- 每个决策给编号（D1、D2...），方便在 SKILL.md 里引用
- 别事后补写，在做决定的时候就记

**示例内容：**

```markdown
## D1: 审查维度选择四维而非六维

**背景：** 需要确定代码审查覆盖哪些维度
**选项：**
- A: 6 维（加上测试覆盖率、文档完整性）
- B: 4 维（正确性、安全、可维护性、性能）

**选择：** B
**理由：** 测试和文档属于独立 Skill 的职责，混在审查里会模糊焦点
```

---

### `assets/templates/`（输出模板）

| 项目 | 内容 |
|------|------|
| **用途** | 定义 Skill 输出的固定格式骨架 |
| **包含内容** | 报告模板、代码模板、邮件模板等 |
| **命名规范** | `<用途>-template.<ext>`，如 `review-report.md`、`pr-description.md` |

**注意事项：**
- 模板里用占位符标注可变部分（如 `{{变量名}}`）
- 不要把示例数据写死在模板里——那是 `examples/` 的事
- SKILL.md 里通过相对路径引用模板：`[模板](assets/templates/review-report.md)`

**示例文件：**
```
assets/templates/
└── review-report.md    # 代码审查报告模板，含标题/结论/问题列表骨架
```

---

### `assets/configs/`（配置文件）

| 项目 | 内容 |
|------|------|
| **用途** | 存放 Skill 执行时依赖的规则集、阈值、映射表等 |
| **包含内容** | YAML/JSON/TOML 格式的配置数据 |
| **命名规范** | 按内容命名 + 标准扩展名：`severity-rules.yaml`、`thresholds.json` |

**注意事项：**
- 配置和模板的区别：配置是**数据**（规则、阈值），模板是**格式**（输出骨架）
- 用 YAML 优先（可读性好），JSON 次之
- 配置里加注释说明每个字段含义

**示例文件：**
```yaml
# assets/configs/severity-rules.yaml
severity_mapping:
  sql_injection: critical
  xss: critical
  unused_variable: minor
  missing_error_check: major
```

---

### `assets/examples/`（输入输出示例）

| 项目 | 内容 |
|------|------|
| **用途** | 展示 Skill 的典型输入和期望输出，帮助理解"什么算好的结果" |
| **包含内容** | 输入样例、输出样例、好坏对比 |
| **命名规范** | `input-sample.md`、`output-sample.md`、`good-example.md`、`bad-example.md` |

**注意事项：**
- 跟 `tests/` 的区别：`examples` 是**展示用的**（写在文档里给人看），`tests` 是**验证用的**（跑回归测试）
- 示例要真实，别用 `foo/bar/baz` 这种无意义内容
- 好坏对比一起放，标注清楚哪个好哪个坏

**示例文件：**
```
assets/examples/
├── input-sample.md     # 一段有 bug 的 Go 代码
└── output-sample.md    # 对应的审查报告输出
```

---

### `scripts/`（辅助脚本）

| 项目 | 内容 |
|------|------|
| **用途** | 放辅助自动化脚本，减少 Agent 和用户的重复劳动 |
| **包含内容** | 环境检查、数据预处理、格式转换、批量操作等 |
| **命名规范** | 入口脚本动词命名：`setup.sh`、`validate.sh`；工具脚本放 `helpers/` 下，kebab-case |

**注意事项：**
- 放什么：环境初始化、数据提取、格式校验、批处理
- 不放什么：Skill 的核心逻辑（那属于 SKILL.md）、第三方工具的安装脚本
- 优先用跨平台语言（Python/Node），如果用 shell 脚本要注明兼容性（bash/zsh/Windows）
- 认知类 Skill 通常不需要 scripts 目录

**示例文件：**
```
scripts/
├── setup.sh               # 检查依赖是否安装
└── helpers/
    └── extract-diff.sh    # 从 git 仓库提取 diff 的工具
```

---

### `phases/`—分阶段执行指令

| 项目 | 说明 |
|------|------|
| **用途** | 把 SKILL.md 里过长的执行流程拆成独立文件，每个 phase 专注一个阶段 |
| **包含内容** | 每阶段一个 `.md` 文件 |
| **命名规范** | `XX-phase-name.md`（如 `00-init.md`、`01-research.md`） |

**注意事项：**
- SKILL.md 里必须保留流程总览，不能删掉让人只看 phases
- 跳转/回退逻辑统一在 SKILL.md，不要分散到各 phase 文件
- 每个 phase 文件开头写清楚输入/输出/前置条件
- 如果你的流程 ≤ 3 个阶段，别用这个目录，直接写 SKILL.md 里

**示例文件：**
```
phases/
├── 00-init.md          # 阶段0：初始化/需求确认
├── 01-research.md      # 阶段1：内容研究
├── 02-validate.md      # 阶段2：验证筛选
└── 03-output.md        # 阶段3：输出交付
```

---

### `tests/cases/`（测试输入）

| 项目 | 内容 |
|------|------|
| **用途** | 存放测试用例的输入数据 |
| **包含内容** | 每个用例一个文件，模拟真实的 Skill 输入 |
| **命名规范** | `test-<场景描述>.md` 或 `case-<编号>-<描述>.md` |

**注意事项：**
- 用例覆盖：至少包含一个正常场景 + 一个边界场景
- 文件名要能看出测试什么——`test-01.md` 没有信息量，`test-sql-injection.md` 才有意义
- `cases/` 和 `expected/` 下的文件名要一一对应

**示例文件：**
```
tests/cases/
├── test-error-handling.md     # 测试：错误处理缺失的代码
└── test-sql-injection.md      # 测试：含 SQL 注入的代码
```

---

### `tests/expected/`（期望输出）

| 项目 | 内容 |
|------|------|
| **用途** | 存放对应测试用例的期望输出结果 |
| **包含内容** | Skill 处理对应 case 后应该产出的内容 |
| **命名规范** | 与 cases 对应：`test-<场景描述>-expected.md` |

**注意事项：**
- 期望输出不要求字面完全一致，但结构和关键判断必须匹配
- 加注释标注"哪些是必须出现的关键点"
- 如果输出格式复杂，可以只写关键字段的期望值

**示例文件：**
```
tests/expected/
├── test-error-handling-expected.md    # 应识别出 error 未处理
└── test-sql-injection-expected.md     # 应标记为 Critical 安全问题
```

---

## 三、目录使用规则

### 必需 vs 推荐 vs 可选

| 级别 | 含义 | 判断条件 |
|------|------|---------|
| **必需** | 缺了就不是 Skill | 只有 `SKILL.md` |
| **推荐** | 复杂 Skill 应该有 | `references/`（有设计权衡时）、`tests/`（规则多/需长期维护时） |
| **可选** | 按需创建 | `assets/`（有固定输出格式时）、`scripts/`（有自动化需求时）、`phases/`（流程复杂时） |

**核心原则：不创建空目录。**

没有内容就不建目录。别搞一堆空的 `README.md` 占位——要么有真东西，要么直接省略。

---

### 不同类型 Skill 的重点目录

| 目录 | Workflow 类 | Cognitive 类 | Hybrid 类 |
|------|:-----------:|:------------:|:---------:|
| `SKILL.md` | ✅ 必需 | ✅ 必需 | ✅ 必需 |
| `references/research/` | 流程最佳实践 | 心智模型研究 | 两者都有 |
| `references/decisions.md` | 流程分支选择 | 框架取舍 | 关键节点决策 |
| `assets/templates/` | ⭐ 重点（固定输出格式） | 少用 | 视输出而定 |
| `assets/configs/` | ⭐ 重点（规则表/阈值） | 少用 | 视需要 |
| `assets/examples/` | 输入输出对照 | ⭐ 重点（好坏对比） | 两者都有 |
| `scripts/` | ⭐ 常用（环境/数据处理） | 基本不用 | 视需要 |
| `tests/` | ⭐ 重点（回归验证） | 推荐（风格检验） | 推荐 |

**总结：**
- **Workflow 类**重点在 `templates` + `configs` + `scripts` + `tests`（流程精确、可自动化验证）
- **Cognitive 类**重点在 `examples` + `research`（示例驱动理解，研究驱动深度）
- **Hybrid 类**两边都沾，看具体哪部分更重就侧重哪边

---

## 四、常见问题 FAQ

### Q: references 和 assets 的区别是什么？

| | `references/` | `assets/` |
|--|---------------|-----------|
| **角色** | 背景资料（"为什么这么设计"） | 执行资源（"执行时用到的东西"） |
| **使用时机** | Skill 维护/溯源时翻看 | Skill 每次执行时引用 |
| **影响执行** | 不影响——删了 Skill 照样跑 | 影响——模板/配置缺失会出错 |

一句话：`references` 是给维护者看的历史档案，`assets` 是给 Agent 用的执行依赖。

---

### Q: tests 不是必须的吗？

不是必须，是**推荐**。

- 简单 Skill（< 20 条规则、一次性使用）→ 可以不写
- 复杂 Skill（规则多、长期维护、多人协作）→ 强烈建议写

没 tests 的风险：改了规则不知道有没有破坏已有行为，只能靠人肉验证。

---

### Q: scripts 放什么不放什么？

**放：**
- 环境检查（`setup.sh` — 确认依赖已安装）
- 数据提取（`extract-diff.sh` — 从 git 拉 diff）
- 格式校验（`validate.sh` — 检查输出符合规范）
- 批处理（`batch-review.py` — 批量处理多个文件）

**不放：**
- Skill 的核心执行逻辑（那是 SKILL.md 的事）
- 第三方工具的安装程序（让用户自己装）
- 与 Skill 无关的通用工具

---

### Q: phases/ 和 scripts/ 有什么区别？

`phases/` 放的是给 Agent 读的执行指令（Markdown），`scripts/` 放的是可执行的代码脚本（`.sh`/`.py` 等）。一个是“怎么想”，一个是“怎么跑”。

---

### Q: 我的 Skill 很简单，只需要 SKILL.md 行不行？

完全可以。

最小合法 Skill 就是一个文件：

```
my-simple-skill/
└── SKILL.md
```

只要 SKILL.md 包含完整的 YAML Frontmatter + 执行逻辑 + 约束，它就是一个合格的 Skill。

**判断标准：** 规则 ≤ 20 条、不需要模板/配置/示例文件 → 单文件足够。

别为了"看起来专业"而硬凑目录结构，空目录比没目录更糟。

---

### Q: 文件命名到底用什么规则？

| 类型 | 规则 | 示例 |
|------|------|------|
| Skill 文件夹 | kebab-case | `code-review-assistant/` |
| 核心文件 | 固定大写 | `SKILL.md`、`README.md` |
| 其他文件 | kebab-case + 扩展名 | `severity-rules.yaml` |
| 模板文件 | `<用途>-template.<ext>` | `review-report.md` |
| 测试用例 | `test-<场景>.md` | `test-sql-injection.md` |
| 期望输出 | 对应 case + `-expected` | `test-sql-injection-expected.md` |

**禁止：** camelCase、PascalCase、下划线分隔、中文文件名。
