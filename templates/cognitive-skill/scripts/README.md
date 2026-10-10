# scripts/ — 辅助脚本

## 用途

存放认知建模与校准过程的辅助脚本：素材采集、词频分析、风格打分、批量回归。
原则：脚本用于**降低主观判断的成本**，而非取代认知本身。

## 应该放什么

- **素材采集**：批量抓取 / 整理一手语料（带来源溯源）
- **风格度量**：基于 `configs/style-rubric.yaml` 给输出打分
- **词频分析**：统计输出与目标语料的词频偏差
- **批量回归**：跑过 `tests/cases/` 全量样本，输出风格一致性报告

## 命名规则

- 入口脚本动词命名：`collect.py`、`score.py`、`analyze.py`
- 子工具放 `helpers/`：`helpers/tokenize-zh.py`
- 优先 Python（NLP 生态丰富）；脚本顶部写明依赖

## 示例

```
scripts/
├── collect-quotes.py          # 从给定 URL 列表抓取语料
├── score-style.py             # 按 rubric 给一段输出打分
├── compare-vocabulary.py      # 对比输出与基线的词频差异
└── helpers/
    ├── tokenize-zh.py         # 中文分词工具
    └── load-rubric.py         # 加载评分维度
```
