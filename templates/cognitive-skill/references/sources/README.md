# sources/ — 一手素材

## 用途

存放认知建模的**原始语料**：访谈、演讲、原著摘录、邮件原文等。
原则：保留原文与上下文，不做删改解读，解读结果放 `research/`。

## 应该放什么

- **访谈 / 演讲 transcript**：人物原话（标注时间戳和场合）
- **原著 / 论文摘录**：核心段落原文 + 引用元信息
- **真实对话样本**：邮件、推文、博客原文截取
- **多源交叉素材**：同一观点在多个来源的不同表述（用于三重验证）

## 命名规则

- 使用 kebab-case + 来源类型前缀
- 推荐前缀：`transcript-`、`book-`、`article-`、`tweet-`、`talk-`
- 必须带日期 / 来源标识：`-YYYY-MM-DD` 或 `-<刊物>`

## 示例

```
sources/
├── transcript-feynman-caltech-1974.md   # 演讲全文
├── book-surely-youre-joking-ch3.md      # 自传第 3 章节选
├── article-physics-today-1985.md        # 原始论文片段
├── talk-ted-on-curiosity-2010.md
└── crosscheck-curiosity-quotes.md       # 三个来源对「好奇心」的原话
```
