# scripts/ — 辅助脚本

## 用途

支撑 Hybrid Skill 的双类辅助：流程层的环境/数据准备，认知层的风格度量与回归。
原则：脚本承担**可自动化的部分**，认知判断主体仍由 SKILL.md 描述。

## 应该放什么

- **flow- 前缀**：环境检查、输入校验、数据预处理、产物清理
- **cognition- 前缀**：风格打分、词频对比、风格回归
- **eval- 前缀**：综合评估（同时检查流程正确性与认知一致性）
- 子工具放 `helpers/`

## 命名规则

- 入口脚本动词命名：`flow-validate.py`、`cognition-score.py`、`eval-all.py`
- 跨平台优先 Python；脚本顶部注明依赖与用法

## 示例

```
scripts/
├── flow-validate-input.py       # 校验输入符合流程 schema
├── flow-setup.sh                # 检查依赖工具
├── cognition-score-output.py    # 给输出按 rubric 打分
├── eval-end-to-end.py           # 综合评估：流程 trace + 风格分
└── helpers/
    ├── load-anchors.py
    └── diff-trace.py
```
