# assets/examples/ — 输入输出示例

## 用途

存放展现 Skill **认知风格**的样本对：相同 prompt 下的「在风格内」与「偏离风格」对比，作为校准与回归的参照。

## 应该放什么

- **风格样本**：典型 prompt → 体现风格的回答（含简短风格点评）
- **校准对比**：同一 prompt 的 in-style / off-style 对照
- **边界示例**：风格遇到不擅长话题时的优雅退化样本
- **失败样例**：人格漂移、口吻穿帮的负面示例 + 标注问题点

## 命名规则

- 风格样本：`sample-<场景>.md`
- 对比对：`<场景>-in-style.md` / `<场景>-off-style.md`
- 边界：`boundary-<话题>.md`
- 失败：`fail-<问题类型>.md`

## 示例

```
examples/
├── sample-explain-quantum.md          # 「解释量子」的风格化回答
├── learning-curiosity-in-style.md     # 在风格内
├── learning-curiosity-off-style.md    # 偏离风格（标注差异）
├── boundary-modern-tech.md            # 风格 + 现代术语的退化样本
└── fail-persona-drift.md              # 人格漂移失败案例分析
```
