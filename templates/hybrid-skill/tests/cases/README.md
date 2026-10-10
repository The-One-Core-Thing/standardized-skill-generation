# tests/cases/ — 测试输入

## 用途

存放兼顾**流程正确性**与**认知一致性**双维度的测试输入。
每个用例都需要明确：检测的是流程行为、认知风格，还是两者衔接。

## 应该放什么

- **流程主测**：覆盖关键分支与异常路径的输入
- **认知主测**：触发风格判断的输入（在锚点位置考验风格）
- **耦合测试**：检测「流程 → 认知 → 流程」回路的输入
- **诱导测试**：诱导流程跳过认知 / 认知架空流程的输入

## 命名规则

- 用例命名：`case-<编号>-<主测维度>-<场景>/`
- 主测维度标签：`flow` / `cognition` / `coupling` / `attack`
- 每个用例含 `input.<ext>` + `meta.yaml`（注明检测维度、应触发的锚点）

## 示例

```
cases/
├── case-01-flow-basic-review/
│   ├── input.md
│   └── meta.yaml              # 主测：流程 happy path
├── case-02-cognition-style-anchor/
│   ├── input.md
│   └── meta.yaml              # 主测：A2 锚点风格表达
├── case-03-coupling-judgment-affects-flow/
│   ├── input.md
│   └── meta.yaml              # 锚点判断应改变后续 Phase
└── case-04-attack-skip-cognition/
    ├── input.md
    └── meta.yaml              # 应识别并仍调用认知
```
