# phases/ — 分阶段执行指令

## 说明

Hybrid 类 Skill 有流程骨架但关键节点需要判断，当流程阶段多（≥ 4）或单阶段指令超过 50 行时，用 phases/ 拆分。

## 命名规范

- 文件名：`XX-phase-name.md`（如 `00-init.md`、`01-analyze.md`）
- 每个文件开头标注：输入、前置条件、执行步骤、输出、完成条件

## 与 SKILL.md 的关系

- SKILL.md 保留流程总览和阶段编排
- phases/ 存放详细执行逻辑
- 跳转/回退逻辑在 SKILL.md 定义，不分散到 phase 文件
- 决策节点的 If/Then 规则可以放在对应 phase 文件中，但 SKILL.md 要有摘要
