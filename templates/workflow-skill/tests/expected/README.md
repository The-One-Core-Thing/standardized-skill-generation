# tests/expected/ — 期望输出

## 用途

存放每个测试用例对应的**期望产出**：最终输出、关键中间状态、应触发的副作用记录。
对照 `cases/` 一一映射，验证流程的正确性与可重现性。

## 应该放什么

- **最终输出**：流程产出的报告/产物（如部署报告、变更摘要）
- **关键状态快照**：流程结束时系统应处于的状态描述
- **执行轨迹**：应触发的关键步骤序列（用于断言流程走对了分支）
- **告警/通知**：异常用例下应发出的通知内容

## 命名规则

- 子目录名必须与 `cases/` 完全一致
- 文件名固定：`output.<ext>`、`trace.yaml`、`notifications.md`
- 期望输出可包含字段级断言（标记 `<<must_match>>` / `<<ignore>>`）

## 示例

```
expected/
├── case-01-basic-deploy/
│   ├── output.md              # 期望的部署报告
│   └── trace.yaml             # 期望执行的 Phase 顺序
├── case-02-canary-rollback/
│   ├── output.md              # 回滚后状态报告
│   ├── trace.yaml             # 应触发回滚分支
│   └── notifications.md       # 应发送的回滚告警
└── case-03-timeout-retry/
    ├── output.md
    └── trace.yaml             # 应记录 3 次重试
```
