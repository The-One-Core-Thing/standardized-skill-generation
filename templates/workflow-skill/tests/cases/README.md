# tests/cases/ — 测试输入

## 用途

存放用于回归验证的**端到端流程输入**。每个用例描述一个完整场景，重点是验证流程从输入到输出的完整正确性。

## 应该放什么

- **happy path**：典型成功路径输入
- **分支场景**：触发不同决策分支的输入（如 if/else 各分支）
- **异常输入**：触发回滚 / 重试 / 中断的输入
- **边界输入**：极大、极小、空值、并发场景

## 命名规则

- 用例统一两位数编号：`case-01-...`、`case-02-...`
- 命名格式：`case-<编号>-<场景描述>/`
- 每个用例一个目录，内含 `input.<ext>` 与 `meta.yaml`（描述用例意图、覆盖的分支）
- `cases/` 与 `expected/` 下子目录名必须一一对应

## 示例

```
cases/
├── case-01-basic-deploy/
│   ├── input.yaml             # 部署输入
│   └── meta.yaml              # 用例描述：覆盖 happy path
├── case-02-canary-rollback/
│   ├── input.yaml
│   └── meta.yaml              # 触发回滚分支
└── case-03-timeout-retry/
    ├── input.yaml
    └── meta.yaml              # 验证超时重试逻辑
```
