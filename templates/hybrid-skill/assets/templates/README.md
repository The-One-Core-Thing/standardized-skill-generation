# assets/templates/ — 输出模板（流程 + 认知）

## 用途

存放两类模板：
- **流程模板**：流程产物的结构化骨架（命令、报告、清单）
- **认知模板**：体现判断风格的句式、点评骨架、推理路径示例

通过命名前缀区分，方便 Agent 在不同阶段引用对应模板。

## 应该放什么

- **flow- 前缀**：命令模板、报告骨架、流程产物
- **cognition- 前缀**：判断点评骨架、风格句式、推理路径模板
- **handoff- 前缀**：流程→认知 / 认知→流程的衔接模板
- 模板文件统一加 `.template` 后缀

## 命名规则

- `flow-<动作>-<目标>.<ext>.template`
- `cognition-<场景>-skeleton.md.template`
- `handoff-<上游>-to-<下游>.md.template`

## 示例

```
templates/
├── flow-review-report.md.template          # 审查产出报告骨架
├── flow-pr-comment.md.template             # PR 评论命令模板
├── cognition-architecture-critique.md.template
├── cognition-tradeoff-reasoning.md.template
└── handoff-review-result-to-decision.md.template
```
