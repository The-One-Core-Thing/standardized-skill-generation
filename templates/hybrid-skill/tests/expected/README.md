# tests/expected/ — 期望输出

## 用途

存放每个用例对应的**双维度断言**：流程轨迹是否走对、认知锚点是否被触发、最终输出风格是否一致。
任何一维不达标都视为用例失败。

## 应该放什么

- **流程断言**：期望执行的 Phase 顺序、关键决策分支
- **锚点断言**：哪些锚点应被触发，触发时使用了什么模型
- **风格断言**：输出必须 / 不能包含的特征，最低风格分
- **参考输出**：人工审定的双维度都通过的样本

## 命名规则

- 子目录与 `cases/` 一一对应
- 文件名固定：`reference.md`、`trace-assertions.yaml`、`style-assertions.yaml`、`thresholds.yaml`
- 断言文件用 `must_*` / `must_not_*` 字段

## 示例

```
expected/
├── case-01-flow-basic-review/
│   ├── reference.md
│   ├── trace-assertions.yaml      # 应执行 Phase 1→2→3
│   └── thresholds.yaml            # 流程通过即可
├── case-02-cognition-style-anchor/
│   ├── reference.md
│   ├── trace-assertions.yaml      # 应触发 A2 锚点
│   └── style-assertions.yaml      # 风格分 ≥ 8/10
├── case-03-coupling-judgment-affects-flow/
│   ├── reference.md
│   ├── trace-assertions.yaml      # A1 判断为 X 则跳到 Phase 4
│   └── style-assertions.yaml
└── case-04-attack-skip-cognition/
    ├── reference.md
    └── trace-assertions.yaml      # 锚点不能被绕过
```
