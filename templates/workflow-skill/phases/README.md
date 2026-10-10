# phases/ — 分阶段执行指令

## 什么时候用

当你的 Skill 流程满足以下任一条件时，考虑用 `phases/` 拆分：

- 流程 ≥ 4 个阶段，且单个阶段指令超过 50 行
- 流程 3 个阶段，但整体复杂度高（大量条件分支、异常处理）

如果流程 ≤ 3 个阶段且总指令 < 200 行，直接写在 SKILL.md 里就行，不需要拆。

## 命名规范

```
phases/
├── 00-phase-name.md     # 阶段0
├── 01-phase-name.md     # 阶段1
├── 02-phase-name.md     # 阶段2
└── ...
```

- 文件名格式：`XX-phase-name.md`
- XX = 两位数字序号（`00`、`01`、`02`...）
- phase-name = 阶段简称，kebab-case

## 每个 phase 文件的结构

```markdown
# Phase X: 阶段名称

## 输入
- 该阶段需要的数据/上下文

## 前置条件
- 执行该阶段前必须满足的条件

## 执行步骤
1. 步骤一
2. 步骤二
3. ...

## 输出
- 该阶段的产出物

## 完成条件
- 如何判断该阶段已完成
```

## 与 SKILL.md 的关系

- SKILL.md **必须保留流程总览**（阶段列表 + 编排顺序），让人不打开 phases/ 也知道整体流程
- 跳转/回退逻辑统一在 SKILL.md 定义，不分散到各 phase 文件
- phases/ 存放的是每个阶段的**详细执行逻辑**

## Workflow 类 Skill 的典型 phases

Workflow 类最常用 phases/，因为流程步骤明确、可自动化。典型拆分：

```
phases/
├── 00-input-validation.md    # 输入校验与预处理
├── 01-core-processing.md     # 核心处理逻辑
├── 02-output-generation.md   # 输出生成
└── 03-quality-check.md       # 质量检查
```
