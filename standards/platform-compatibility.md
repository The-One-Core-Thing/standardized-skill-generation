# 跨平台适配指南

将标准 SKILL.md 部署到不同 AI 编程平台的具体方法。

---

## 平台总览

| 平台 | 配置位置 | 格式要求 | 多文件支持 | 自动触发 |
|------|---------|---------|-----------|---------|
| Qoder / Qoder Work | `.qoder/skills/` | SKILL.md 标准格式 | ✅ | ✅ description 匹配 |
| Cursor | `.cursor/rules/` | .mdc 或 .md | ✅ | ✅ frontmatter 匹配 |
| Windsurf | `.windsurfrules` | 单文件 Markdown | ❌ | ✅ 全局加载 |
| Claude Code | `.claude/skills/` | SKILL.md | ✅ | ✅ |
| Gemini CLI | 项目配置目录 | Markdown | 待确认 | 待确认 |
| GitHub Copilot | `.github/copilot-instructions.md` | Markdown | ❌ | ✅ 全局加载 |

---

## Qoder / Qoder Work

**配置位置：** `.qoder/skills/skill-name/SKILL.md`

**安装步骤：**
1. 在项目根目录创建 `.qoder/skills/` 目录
2. 每个 Skill 一个子目录，包含 `SKILL.md`
3. 无需额外配置，放入即生效

**格式要求：**
- 标准 SKILL.md 格式，无需转换
- YAML frontmatter 中的 `description` 用于自动触发匹配

**注意事项：**
- `description` 字段质量直接影响触发准确度
- 支持 `/command` 斜杠命令触发
- 支持 `scripts/` 目录下的辅助脚本

**已知限制：**
- 无

**转换方法：** 无需转换，这是标准格式的原生平台。

---

## Cursor

**配置位置：** `.cursor/rules/skill-name.mdc` 或 `.cursor/rules/skill-name.md`

**安装步骤：**
1. 创建 `.cursor/rules/` 目录
2. 每个 Skill 创建一个 `.mdc` 或 `.md` 文件
3. 确保 frontmatter 包含 `description` 字段

**格式要求：**
```yaml
---
description: 触发条件描述，Cursor 用此字段判断何时激活规则
globs: ["*.ts", "*.tsx"]  # 可选，限定文件范围
alwaysApply: false         # 可选，是否全局生效
---

# 规则正文（Markdown）
```

**注意事项：**
- `description` 是触发的关键，必须包含清晰的激活条件
- `globs` 可限定规则生效的文件类型
- `alwaysApply: true` 会让规则始终加载（慎用）

**已知限制：**
- 不支持 `scripts/` 目录
- 单文件模式，不支持子目录结构
- `.mdc` 格式本质是 Markdown，但扩展名不同

**转换方法：**
```bash
# 从标准 SKILL.md 转换
1. 复制 SKILL.md 内容
2. 重命名为 skill-name.mdc
3. 确保 frontmatter 保留 description 字段
4. 删除 name/version 等 Cursor 不识别的字段（保留不影响，但无效果）
5. 如需限定文件范围，添加 globs 字段
```

---

## Windsurf

**配置位置：** 项目根目录 `.windsurfrules` 文件

**安装步骤：**
1. 在项目根目录创建 `.windsurfrules` 文件
2. 将所有规则合并写入该文件

**格式要求：**
- 纯 Markdown，无 frontmatter
- 所有规则在一个文件中，用标题分隔

**注意事项：**
- 单文件模式，所有 Skill 需合并
- 始终全局加载，无条件触发机制
- 建议用 `## Skill: skill-name` 标题分隔不同 Skill

**已知限制：**
- 不支持按条件触发
- 不支持多文件 / 目录结构
- 文件过大时可能影响性能
- 无 frontmatter 支持

**转换方法：**
```bash
# 合并多个 SKILL.md 到单文件
1. 创建 .windsurfrules
2. 对每个 Skill：
   a. 去掉 YAML frontmatter
   b. 用 ## 标题标记 Skill 名称
   c. 保留正文内容
   d. 追加到 .windsurfrules
3. 用 --- 分隔不同 Skill 段落
```

---

## Claude Code

**配置位置：** `.claude/skills/skill-name/SKILL.md`

**安装步骤：**
1. 创建 `.claude/skills/` 目录
2. 每个 Skill 一个子目录
3. 放入 `SKILL.md` 文件

**格式要求：**
- 标准 SKILL.md 格式
- 原生支持 YAML frontmatter

**注意事项：**
- 与标准格式完全兼容
- 支持 `description` 自动触发

**已知限制：**
- 无明显限制

**转换方法：** 无需转换，直接使用标准格式。

---

## Gemini CLI

**配置位置：** 项目配置目录（具体路径待官方确认）

**安装步骤：**
1. 参照 Gemini CLI 文档配置
2. 放入 Markdown 格式的规则文件

**格式要求：**
- Markdown 格式
- 具体结构待确认

**注意事项：**
- 平台较新，规范可能变化
- 建议关注官方文档更新

**已知限制：**
- 具体限制待确认

**转换方法：** 保留 Markdown 正文，frontmatter 兼容性待验证。

---

## GitHub Copilot

**配置位置：** `.github/copilot-instructions.md`

**安装步骤：**
1. 创建 `.github/` 目录（如不存在）
2. 创建 `copilot-instructions.md` 文件
3. 将规则写入该文件

**格式要求：**
- 纯 Markdown，无 frontmatter
- 单文件，所有指令合并

**注意事项：**
- 单文件模式，类似 Windsurf
- 全局生效，无条件触发
- 文件名固定，不可更改
- 建议保持简洁，Copilot 对长指令的遵循度会下降

**已知限制：**
- 不支持多文件
- 不支持条件触发
- 对复杂指令的遵循不如专用平台
- 无 YAML frontmatter 支持

**转换方法：**
```bash
# 合并到单文件
1. 创建 .github/copilot-instructions.md
2. 对每个 Skill：
   a. 去掉 YAML frontmatter
   b. 用 ## 标题标记
   c. 精简内容（建议保留核心规则，去掉元信息）
   d. 追加到文件
3. 总长度建议控制在合理范围内
```

---

## 转换决策树

```
标准 SKILL.md
├── Qoder / Claude Code → 直接使用，无需转换
├── Cursor → 重命名 .mdc，保留 description，可加 globs
├── Windsurf / Copilot → 去 frontmatter，合并到单文件
├── Gemini → 基本兼容，关注官方更新
```

---

## 注意事项汇总

1. **始终维护标准格式为 source of truth**，平台特定版本从标准格式生成
2. 单文件平台（Windsurf、Copilot）需要取舍——优先保留核心规则
3. 条件触发依赖 `description` 质量，写好触发描述是跨平台通用的关键
4. 定期检查各平台规范更新，及时调整转换策略
