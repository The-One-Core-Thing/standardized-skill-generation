# Code Review 报告

> 审查对象：`{{ target }}`
> 审查范围：`{{ scope }}`（文件数 {{ file_count }} / 行数 {{ line_count }}）
> 审查日期：{{ date }}
> 审查者：code-review-assistant v{{ version }}

---

**结论**：{{ verdict }} <!-- ✅ 可合并 / ⚠️ 修改后合并 / ❌ 需要重做 -->
**一句话总结**：{{ summary }} <!-- ≤30 字 -->

---

## 🔴 Critical（{{ critical_count }} 项）

<!--
每条按以下格式填写。无 Critical 时整个 section 删除，不要写"无"。
-->

### 1. [{{ file }}:{{ line }}] {{ title }}
- **维度**：{{ dimension }}  <!-- 安全 / 正确性 / 可维护性 / 性能 -->
- **问题**：{{ description }}
- **建议**：{{ suggestion }}
  ```{{ language }}
  {{ example_code }}
  ```

### 2. ...

---

## 🟡 Major（{{ major_count }} 项）

### 1. [{{ file }}:{{ line }}] {{ title }}
- **维度**：{{ dimension }}
- **问题**：{{ description }}
- **建议**：{{ suggestion }}

### 2. ...

---

## 🟢 Minor（{{ minor_count }} 项）

> Minor 可合并简写为列表，每条仍需位置 + 一句话问题 + 一句话建议

- [{{ file }}:{{ line }}] {{ short_problem }} → {{ short_suggestion }}
- [{{ file }}:{{ line }}] {{ short_problem }} → {{ short_suggestion }}

---

## 💡 Nit（{{ nit_count }} 项，可选）

- {{ nit_item }}
- {{ nit_item }}

---

## ❓ Questions（不确定项）

> 不能 100% 判定是否是 bug 时，以问句形式列出，由作者判断。

- [{{ file }}:{{ line }}] 这里在 {{ scenario }} 情况下会不会 {{ consequence }}？
- ...

---

## 行动项 Top 3

1. {{ action_1 }}
2. {{ action_2 }}
3. {{ action_3 }}

---

## 审查覆盖说明

- ✅ 已扫描维度：正确性 / 安全 / 可维护性 / 性能
- ⚠️ 未覆盖范围：{{ uncovered }} <!-- 如：跨文件依赖、运行时性能、未提供的外部模块 -->
- 🔍 建议补充验证：{{ verification_needed }} <!-- 如：补单测、跑性能压测、专业安全审计 -->

---

<!--
模板使用说明：
1. 全部 {{ ... }} 占位符替换为真实内容
2. 没有内容的 section 整段删除（不要保留"无 / N/A"）
3. 严重度从高到低排序，section 顺序固定不可调换
4. 每条反馈必须包含「位置 / 问题 / 建议」三要素，缺一律删除
5. 报告总条目（Critical+Major+Minor）≤ 15，超出时声明截断
-->
