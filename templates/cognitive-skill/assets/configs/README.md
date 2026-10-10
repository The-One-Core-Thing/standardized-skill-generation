# assets/configs/ — 配置文件

## 用途

存放认知风格的**可量化参数**：风格评分维度、词频权重、禁忌词库、校准基线。
让 Skill 的「认知一致性」可被检测、可被回归。

## 应该放什么

- **风格评分维度**：评估输出是否「像」目标风格的打分项与权重
- **词频 / 句式偏好**：高频词、应避免词的清单（含权重）
- **禁忌清单**：不该出现的概念、口吻、视角（避免人格漂移）
- **校准基线**：标准答案在各维度上的得分基线

## 命名规则

- 评分维度：`style-rubric.yaml`
- 词库：`vocabulary-prefer.yaml` / `vocabulary-avoid.yaml`
- 禁忌：`taboos.yaml`
- 基线：`baseline-<风格名>.yaml`

## 示例

```
configs/
├── style-rubric.yaml         # 6 个风格维度 + 权重
├── vocabulary-prefer.yaml    # 高频偏好词
├── vocabulary-avoid.yaml     # 应避免的现代词 / 套话
├── taboos.yaml               # 禁止的视角和口吻
└── baseline-feynman.yaml     # 基线得分参照
```
