# assets/configs/ — 配置文件

## 用途

存放 Skill 运行时读取的**外部化配置**：规则集、阈值、白名单/黑名单、环境参数。
原则：**逻辑放 SKILL.md，数据放 configs/**，方便不改主文件就调参。

## 应该放什么

- **规则集**：流程中的判定规则（如「文件超过 X 行触发警告」）
- **阈值表**：数值边界（如超时时间、重试次数、并发上限）
- **白/黑名单**：允许/禁止的目标列表（如可部署环境、跳过的目录）
- **环境配置**：不同环境的差异参数（dev / staging / prod）

## 命名规则

- 单一规则集：`<主题>.yaml` / `<主题>.json`
- 阈值表：`thresholds-<场景>.yaml`
- 名单：`allowlist-<对象>.yaml` / `blocklist-<对象>.yaml`
- 环境差异：`env-<环境名>.yaml`

## 示例

```
configs/
├── deploy-rules.yaml          # 部署阶段判定规则
├── thresholds-canary.yaml     # 灰度阶段流量阈值
├── allowlist-prod-clusters.yaml
└── env-staging.yaml
```
