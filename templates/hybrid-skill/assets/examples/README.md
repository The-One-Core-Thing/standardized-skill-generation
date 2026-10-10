# assets/examples/ — 输入输出示例

## 用途

存放展示 Hybrid Skill **流程正确 + 认知一致**双重特征的样本。
重点是端到端示例：从输入触发，经过流程各阶段，认知锚点如何介入并影响最终输出。

## 应该放什么

- **完整端到端**：input → trace（流程轨迹 + 锚点决策） → output
- **流程正确 / 认知偏差** 对比：流程跑对了但风格漂移的失败例
- **流程偏差 / 认知正确** 对比：判断对但走错分支的失败例
- **理想样本**：双重维度都通过的金标准样本

## 命名规则

- 端到端目录：`example-<场景>/`，含 `input.*`、`trace.yaml`、`output.md`、`commentary.md`
- `commentary.md` 标注「在哪个锚点做了什么判断、为什么」
- 对比对：`<场景>-flow-ok-cognition-bad.md` / `<场景>-flow-bad-cognition-ok.md`

## 示例

```
examples/
├── example-arch-review-happy/
│   ├── input.md
│   ├── trace.yaml             # 流程 + 锚点轨迹
│   ├── output.md
│   └── commentary.md          # 锚点判断点评
├── arch-review-flow-ok-cognition-bad.md   # 风格漂移失败例
└── arch-review-flow-bad-cognition-ok.md   # 流程错路失败例
```
