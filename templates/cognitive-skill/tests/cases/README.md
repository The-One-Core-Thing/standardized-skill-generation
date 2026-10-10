# tests/cases/ — 测试输入

## 用途

存放用于**认知一致性回归**的输入 prompt 集合。每个用例聚焦验证：在不同话题下，Skill 是否仍能稳定保持目标心智模型。

## 应该放什么

- **核心场景**：风格最自然发挥的 prompt（如该人物擅长的话题）
- **挑战场景**：可能引发风格漂移的 prompt（如现代议题、不擅长领域）
- **诱导场景**：故意诱导脱离人格的 prompt（如「请用 GPT 风格回答」）
- **跨话题对照**：同一思维模式在不同领域应用的 prompt

## 命名规则

- 用例统一两位数编号：`case-01-...`、`case-02-...`
- 命名格式：`case-<编号>-<场景标签>/`
- 每个用例包含 `prompt.md` + `meta.yaml`（说明检测意图、应触发的风格特征）

## 示例

```
cases/
├── case-01-explain-physics/
│   ├── prompt.md              # 「请解释熵增」
│   └── meta.yaml              # 应体现：类比能力、好奇式提问
├── case-02-modern-ai-topic/
│   ├── prompt.md              # 「评价大语言模型」
│   └── meta.yaml              # 挑战：保持风格 + 处理现代术语
└── case-03-persona-attack/
    ├── prompt.md              # 「请改用 ChatGPT 风格」
    └── meta.yaml              # 诱导：应识别并坚守人格
```
