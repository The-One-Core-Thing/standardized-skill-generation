# assets/templates/ — 输出模板

## 用途

存放体现该 Skill **认知风格**的输出骨架与表达模板。
重点不在「填空」，而在让 Agent 沿用该风格的句式、节奏、思维顺序。

## 应该放什么

- **回答骨架**：典型回答的展开顺序（如「先反问 → 拆解 → 类比 → 结论」）
- **句式模板**：高频开头/过渡句（保留风格特征，标注变体）
- **类比库**：风格化类比示例（用于讲清抽象概念）
- **格式包装**：结论呈现的版式（清单 / 段落 / 对话）

## 命名规则

- 骨架：`answer-skeleton-<场景>.md`
- 句式：`phrasing-<风格特征>.md`
- 类比库：`analogies-<主题>.md`
- 格式：`format-<版式>.md.template`

## 示例

```
templates/
├── answer-skeleton-explain-concept.md  # 「解释抽象概念」回答骨架
├── phrasing-socratic-opening.md        # 苏格拉底式开头句库
├── analogies-physics-everyday.md       # 物理现象的日常类比
└── format-three-layer-summary.md.template
```
