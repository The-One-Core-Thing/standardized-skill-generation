# Sources：一手素材与引用来源

本目录用于归档 Phase 1（内容研究）阶段引用过的一手素材、文档摘录与外部资料链接。
当 Skill 内容被质疑、需要溯源、或要更新到新版方法论时，从这里查起。

---

## 引用清单

### 方法论类

| 编号 | 标题 | 来源 | 用途 |
|------|------|------|------|
| M1 | Google Code Review Developer Guide | https://google.github.io/eng-practices/review/ | `research/01-review-methodologies.md` 第 1 节 |
| M2 | Microsoft Code-with-Engineering Playbook · Code Reviews | https://microsoft.github.io/code-with-engineering-playbook/code-reviews/ | `research/01-review-methodologies.md` 第 2 节 |
| M3 | Trisha Gee · Code Review Best Practices | JetBrains Blog, 2020 | `research/01-review-methodologies.md` 第 3 节 |
| M4 | SmartBear · Best Kept Secrets of Peer Code Review | 2006 Cisco 案例研究 | `research/01-review-methodologies.md` 第 4 节；500 行上限依据 |
| M5 | Atlassian · How to do Code Reviews Like a Human | https://www.atlassian.com/blog/git/code-review-best-practices | 沟通语气取舍参考 |

### 安全类

| 编号 | 标题 | 来源 | 用途 |
|------|------|------|------|
| S1 | OWASP Top 10 (2021) | https://owasp.org/Top10/ | `research/02-common-issues.md` 安全维度清单 |
| S2 | CWE Top 25 Most Dangerous Software Weaknesses | https://cwe.mitre.org/top25/ | 安全分级依据 |
| S3 | Google Cloud · Secure Coding Guidelines | 内部公开摘录 | 硬编码密钥、不安全反序列化 |

### 工具类

| 编号 | 标题 | 来源 | 用途 |
|------|------|------|------|
| T1 | golangci-lint 文档 | https://golangci-lint.run/ | `research/03-tool-comparison.md` Go 部分 |
| T2 | SonarQube Rules Catalog | https://rules.sonarsource.com/ | 严重度分级阈值参考 |
| T3 | Semgrep Registry | https://semgrep.dev/explore | 模式库对比 |
| T4 | CodeRabbit 公开文档 | https://docs.coderabbit.ai/ | `research/03-tool-comparison.md` 第 4 节 |

### 数据来源

| 编号 | 标题 | 来源 | 用途 |
|------|------|------|------|
| D1 | Codacy 2023 Code Quality Report | Codacy Blog | `research/02-common-issues.md` 第 2 节频率统计 |
| D2 | GitHub Octoverse Report | https://octoverse.github.com/ | PR 规模、审查时间数据 |

---

## 归档规范

如未来要把"网页摘录"或"PDF 文档"实际放进本目录：

- 文件命名：`<编号>-<短描述>.<ext>`，如 `M1-google-eng-practices-review.md`
- 网页摘录用 Markdown，注明：抓取 URL、抓取日期、原作者
- PDF 直接放原文件，并配同名 `.notes.md` 写摘要
- 受版权限制不能放原文的，仅放链接 + 摘要 + 引用片段（合理使用范围）

---

## 当前状态

本示例 Skill 当前未在仓库中实际归档外部素材原文，仅以本 README 形式记录引用清单。
真实生产 Skill 应至少保留摘录或快照（防原始链接失效）。
