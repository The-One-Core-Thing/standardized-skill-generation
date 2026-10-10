# research/ — 流程调研笔记

## 用途

记录设计该 Workflow Skill 时做的流程调研、工具对比、最佳实践分析。
重点回答：业界类似流程怎么拆？我们为什么这么拆？

## 应该放什么

- **流程调研**：业界同类流程的拆解和对比
- **工具/命令调研**：候选工具的能力、限制、踩坑记录
- **最佳实践对比**：标杆方案的优劣分析
- **风险与边界**：流程中已知的失败场景调研

## 命名规则

- 使用 kebab-case
- 文件名体现「主题 + 视角」，避免泛化命名
- 推荐前缀：`flow-`、`tool-`、`practice-`、`risk-`

## 示例

```
research/
├── flow-ci-cd-stages.md              # 主流 CI/CD 流程拆分对比
├── tool-jenkins-vs-github-actions.md # 工具选型对比
├── practice-blue-green-deploy.md     # 蓝绿部署最佳实践
└── risk-rollback-failure-modes.md    # 回滚失败模式调研
```
