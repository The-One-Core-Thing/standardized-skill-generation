# phases/ — 分阶段执行指令

## 说明

Cognitive 类 Skill 通常不需要 phases/，因为它的核心是决策框架而非固定流程。

如果你的认知型 Skill 确实有多阶段流程（比如"先收集信息 → 再分析 → 最后给建议"），且每阶段超过 50 行，可以用 phases/ 拆分。

## 命名规范

- 文件名：`XX-phase-name.md`（如 `00-gather-context.md`）
- 每个文件开头标注：输入、前置条件、执行步骤、输出、完成条件

## 与 SKILL.md 的关系

- SKILL.md 保留流程总览和阶段编排
- phases/ 存放详细执行逻辑
- 跳转/回退逻辑在 SKILL.md 定义，不分散到 phase 文件
