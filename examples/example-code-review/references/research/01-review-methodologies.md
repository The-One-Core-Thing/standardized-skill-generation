# 调研笔记 01：主流代码审查方法论

> Phase 1 产物 · 内容研究阶段
> 目的：理解业界主流代码审查方法论的核心主张，为本 Skill 的「四维度 + 四级严重度」设计提供依据。

---

## 1. Google：Code Review Developer Guide

来源：`google.github.io/eng-practices/review/`

核心要点：
- **审查目的**：保证代码库长期健康，而非追求完美。
- **CL 大小**：单次审查的 CL（changelist）应小，理想 < 200 行；超过 400 行应拆分。
- **审查关注点（按优先级）**：
  1. Design：方案本身是否合理
  2. Functionality：实际是否如描述工作
  3. Complexity：是否过度设计
  4. Tests：是否有充分测试
  5. Naming / Comments / Style / Documentation
- **核心信条**："In general, reviewers should favor approving a CL once it is in a state where it definitely improves the overall code health of the system, even if the CL isn't perfect."
  - 直译：只要这次改动让代码库更好，就该批准——哪怕不完美。
- **冲突处理**：作者与审查者意见不合时，先离线对齐，避免在评论区耗时拉锯。

对本 Skill 的启发：
- 「找问题不找茬」原则直接对应 Google「improves overall code health」的标准
- 单次 ≤ 500 行的限制（本 Skill 略高于 Google 400 行）借鉴自 CL 大小建议
- 「Design > Tests > Style」的优先级映射到本 Skill「正确性 > 可维护性 > 风格」

---

## 2. Microsoft：Engineering Fundamentals - Code Reviews

来源：`microsoft.github.io/code-with-engineering-playbook/code-reviews/`

核心要点：
- **审查清单分两层**：
  - High-level：架构、抽象、依赖方向、错误处理策略
  - Low-level：命名、边界、空值、并发、资源释放
- **建议反馈分类标签**：`Nit`（吹毛求疵）/ `Suggestion`（建议）/ `Issue`（必须改）/ `Question`（澄清问题）
- **强调"Question"作为缓和工具**：当不确定是否是 bug 时，优先用问句而不是断言。

对本 Skill 的启发：
- 严重度分级直接借鉴：本 Skill `Critical / Major / Minor / Nit` 对应 `Issue(blocker) / Issue / Suggestion / Nit`
- 「不确定时用问句」写入了本 Skill 的决策规则（IF 不能 100% 确定 → THEN 用提问形式）

---

## 3. Thoughtworks / "Code Review Best Practices"（Trisha Gee）

来源：QCon talk + Jetbrains Blog

核心要点：
- 审查应在 **写代码后 24h 内** 进行，越拖越没人看
- 审查者一次专注时间 ≤ 60 分钟，超过会显著漏检
- **三类"反模式"**：
  1. Bike-shedding：把时间花在颜色/命名等小事
  2. Rubber-stamping：直接 LGTM 不看内容
  3. Nit-picking：每行都挑刺，淹没真问题

对本 Skill 的启发：
- "不挑风格偏好"约束直接来自反 Bike-shedding
- "超过 15 条强制 Top 15" 来自反 Nit-picking 的容量限制

---

## 4. SmartBear："Best Kept Secrets of Peer Code Review"

来源：SmartBear 2006 Cisco 案例研究（被广泛引用的经验数据）

关键数据：
- 单次审查 < 60 分钟，缺陷发现率 ≈ 70%；> 60 分钟降至 30% 以下
- 审查速率 < 500 LOC/小时 时缺陷发现率最高，> 1000 LOC/小时 几乎无效
- Author 在审查前自检（self-review）能减少 50% 的反馈量

对本 Skill 的启发：
- 500 行上限的硬性约束借鉴自该研究的 LOC/小时阈值
- 鼓励用户先自检（在「输入约束」中提示）

---

## 5. 共识与本 Skill 的取舍

| 议题 | 业界共识 | 本 Skill 立场 |
|------|---------|--------------|
| 审查目的 | 提升代码库健康，非追求完美 | 采纳 |
| 审查规模 | 单次 200-400 行 | 放宽到 500 行（AI 单轮上下文承受度更高） |
| 严重度分级 | 普遍 3-5 级 | 4 级（Critical/Major/Minor/Nit） |
| 风格问题 | 部分团队严格、部分宽松 | 默认跳过，除非违反项目既定规范 |
| 不确定的判断 | 用问句缓和 | 强制规则（IF 不能 100% 确定 → 提问） |

---

## 参考来源（详见 sources/）

1. Google Eng Practices - Code Review Developer Guide
2. Microsoft Code-with-Engineering Playbook
3. Trisha Gee "Code Review Best Practices" (JetBrains Blog, 2020)
4. SmartBear "Best Kept Secrets of Peer Code Review" (2006)
5. Atlassian "How to do Code Reviews Like a Human"
