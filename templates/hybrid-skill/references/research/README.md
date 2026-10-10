# research/ — 流程 + 认知双线调研

## 用途

记录 Hybrid Skill 设计中**两条线索的调研**：
- 线 A：流程层 —— 步骤怎么拆、工具怎么选
- 线 B：认知层 —— 心智模型、判断风格、价值取向
重点回答：流程的哪些节点需要认知介入？认知如何转化为可执行决策？

## 应该放什么

- **流程调研**：步骤拆分、工具选型、最佳实践（同 Workflow 类）
- **认知调研**：心智模型、人物风格、判断框架（同 Cognitive 类）
- **耦合点研究**：流程节点 ↔ 认知锚点的映射关系
- **认知转决策**：模糊认知如何落地为可执行的 If/Then 规则

## 命名规则

- 流程相关：`flow-`、`tool-`、`practice-` 前缀
- 认知相关：`persona-`、`framework-`、`pattern-` 前缀
- 耦合点：`coupling-<流程节点>-<认知锚点>.md`
- 转化：`translate-<认知主题>-to-rules.md`

## 示例

```
research/
├── flow-code-review-stages.md            # 审查流程拆解
├── persona-senior-architect-mindset.md   # 高级架构师的判断习惯
├── coupling-design-review-judgment.md    # 设计评审节点的判断介入点
└── translate-architectural-taste-to-rules.md
```
