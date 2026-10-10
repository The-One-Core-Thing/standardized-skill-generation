# sources/ — 一手素材

## 用途

存放调研过程中采集的原始资料，保证 Skill 的设计可溯源、可复核。
重点：**只放原文，不做加工**，加工后的笔记放 `research/`。

## 应该放什么

- 官方文档摘录、规范片段（如 RFC、API spec）
- 工具/命令的原始输出样本（如 `--help` 文本、错误日志样本）
- 团队内部的流程手册、运维 runbook
- 链接归档（用 markdown 列出 URL + 抓取日期）

## 命名规则

- 使用 kebab-case + 来源标签
- 推荐前缀：`spec-`、`doc-`、`runbook-`、`sample-`、`links-`
- 带版本/日期的资料后缀加日期：`-YYYY-MM-DD`

## 示例

```
sources/
├── spec-openapi-3.1.md          # OpenAPI 规范摘录
├── doc-k8s-rolling-update.md    # K8s 官方滚动更新文档片段
├── sample-deploy-error-log.txt  # 真实失败日志样本
├── runbook-prod-deploy-2025.md  # 团队部署手册
└── links-2025-05-24.md          # 参考链接列表
```
