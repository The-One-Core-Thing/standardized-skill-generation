# tests/expected/ — 期望输出

## 用途

存放每个 prompt 用例对应的**风格一致性期望**：参考答案、应体现的风格特征、应避免的反模式、最低评分阈值。

## 应该放什么

- **参考答案**：人工审定的高质量风格化回答（一个或多个变体）
- **特征断言**：必须体现的风格特征清单（如「有反问句」「使用日常类比」）
- **反模式断言**：不能出现的特征（如「使用现代套话」「跳脱人格」）
- **评分门槛**：按 `style-rubric.yaml` 的最低通过分

## 命名规则

- 子目录与 `cases/` 一一对应
- 文件名固定：`reference.md`、`assertions.yaml`、`thresholds.yaml`
- `assertions.yaml` 用 `must_contain` / `must_not_contain` 字段

## 示例

```
expected/
├── case-01-explain-physics/
│   ├── reference.md           # 风格化参考答案
│   ├── assertions.yaml        # 必须包含：类比、反问
│   └── thresholds.yaml        # 风格分 ≥ 8/10
├── case-02-modern-ai-topic/
│   ├── reference.md
│   └── assertions.yaml        # 必须保持人格视角
└── case-03-persona-attack/
    ├── reference.md           # 应识别并坚守人格的样本
    └── assertions.yaml        # 不能出现「我是 ChatGPT」类自指
```
