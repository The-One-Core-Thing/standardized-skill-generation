# scripts/ — 辅助脚本

## 用途

存放支撑流程执行的可执行脚本：环境检查、数据预处理、结果校验、批量操作。
原则：**SKILL.md 描述「做什么」，scripts/ 实现「怎么做」中可复用的部分**。

## 应该放什么

- **环境准备**：依赖检查、目录初始化、凭证校验
- **流程辅助**：流程中需要重复执行的小工具（如等待健康检查、轮询状态）
- **校验脚本**：检查输入格式、输出完整性
- **后处理**：清理临时文件、打包产物、上传日志

## 命名规则

- 入口脚本用动词命名：`setup.sh`、`validate.sh`、`cleanup.sh`
- 子工具放在 `helpers/` 下：`helpers/wait-for-healthy.sh`
- 跨平台优先 Python / Node；shell 脚本注明平台依赖
- 所有脚本第一行写 shebang，注释里说明用途与参数

## 示例

```
scripts/
├── setup.sh                   # 检查 kubectl、helm、jq 是否安装
├── validate-input.py          # 校验输入 YAML 是否符合 schema
├── cleanup.sh                 # 清理临时部署目录
└── helpers/
    ├── wait-for-rollout.sh    # 轮询 rollout 状态
    └── diff-manifests.py      # 对比变更前后清单
```
