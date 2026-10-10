# assets/configs/ — 配置文件

## 用途

存放双类配置：
- **流程配置**：规则集、阈值、白名单（决定流程怎么走）
- **认知配置**：风格评分维度、价值取向参数、锚点触发阈值（决定怎么判断）

让流程行为与认知风格都能被外部化、可调参。

## 应该放什么

- **flow- 前缀**：流程规则、阈值、目标白/黑名单
- **cognition- 前缀**：风格 rubric、词频偏好、禁忌
- **anchors- 前缀**：认知锚点的触发条件与启用开关
- **mapping- 前缀**：流程阶段 ↔ 认知模型的映射表

## 命名规则

- 单一职责一文：`<类型前缀>-<主题>.yaml`
- 锚点配置：`anchors-<场景>.yaml`
- 映射表：`mapping-phase-to-model.yaml`

## 示例

```
configs/
├── flow-review-rules.yaml          # 流程判定规则
├── flow-thresholds.yaml            # 阈值表
├── cognition-style-rubric.yaml     # 风格评分维度
├── cognition-taboos.yaml           # 风格禁忌
├── anchors-design-review.yaml      # 锚点触发条件
└── mapping-phase-to-model.yaml     # Phase ↔ 认知模型映射
```
