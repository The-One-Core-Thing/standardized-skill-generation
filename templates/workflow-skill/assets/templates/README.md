# assets/templates/ — 输出模板

## 用途

存放 Skill 执行过程中产出的**结构化输出模板**，包括命令模板、报告骨架、PR 描述等。
让 Agent 不必每次重复构造格式，直接填充即可。

## 应该放什么

- **命令模板**：可参数化的 shell / 工具调用模板（保留 `{{var}}` 占位符）
- **报告模板**：流程产物的骨架（如部署报告、回滚记录）
- **通知模板**：发送给人/系统的消息格式（如 Slack、邮件）
- **配置片段**：注入到目标系统的配置块

## 命名规则

- 命令/脚本类：`<动作>-<目标>.<ext>.template`
- 报告类：`<场景>-report.md.template`
- 通知类：`notify-<渠道>.<ext>.template`
- 模板文件统一加 `.template` 后缀，避免被误执行

## 示例

```
templates/
├── deploy-rollback.sh.template       # 回滚命令模板
├── pr-deploy-summary.md.template     # PR 部署总结模板
├── notify-slack-success.json.template
└── k8s-canary-config.yaml.template
```
