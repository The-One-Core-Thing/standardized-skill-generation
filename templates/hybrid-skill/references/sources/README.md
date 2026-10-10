# sources/ — 一手素材（流程 + 认知）

## 用途

存放 Hybrid Skill 设计的**双类原始资料**：流程类（spec、runbook）与认知类（transcript、原著）。
原则：原文原状归档，加工放 `research/`，做好来源类型标记。

## 应该放什么

- **流程类素材**：官方文档、规范、运维手册、命令样本
- **认知类素材**：访谈 / 演讲 transcript、原著摘录、语录
- **混合类素材**：包含流程描述与价值判断的资料（如架构评审报告原文）
- **链接归档**：URL + 抓取日期 + 类型标签

## 命名规则

- 流程类前缀：`spec-`、`doc-`、`runbook-`、`sample-`
- 认知类前缀：`transcript-`、`book-`、`talk-`、`article-`
- 混合类前缀：`mixed-`
- 必须带日期 / 来源标识

## 示例

```
sources/
├── spec-code-review-checklist-google.md    # Google CR checklist 原文
├── runbook-arch-review-process.md          # 团队评审流程手册
├── transcript-fowler-on-design-2018.md     # Martin Fowler 演讲
├── book-clean-architecture-ch7.md          # 原著章节
├── mixed-amazon-pr-faq-template.md         # 流程 + 写作风格
└── links-2025-05-24.md
```
