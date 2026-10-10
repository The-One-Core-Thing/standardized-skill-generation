# 调研笔记 02：代码审查中常见的问题分类

> Phase 1 产物 · 内容研究阶段
> 目的：归纳代码审查中实际频繁出现的问题类型，作为本 Skill「四维度扫描」的具体检查项来源。

---

## 1. 按维度归类

### 1.1 正确性（Correctness）

**最常见命中点：**
- 边界条件遗漏：空数组、空指针、单元素、最大值溢出
- 错误吞没：`catch (e) {}`、`_, _ = fn()`、`row.Scan()` 不检查 err
- 并发竞态：共享变量未加锁；range 取地址；闭包捕获循环变量
- 资源未释放：file/socket/db 连接、context cancel、goroutine 泄漏
- 时区与时间：`time.Now()` 比较、Date 解析未指定 location
- 浮点比较：`==` 比较 float、金额用 float
- 隐式类型转换：JS 的 `==`、Go 的 int 截断、Python int/float 混算

### 1.2 安全（Security）

**OWASP Top 10 + 实战常见：**
- SQL 注入：字符串拼接 SQL（最常见）
- 命令注入：`exec(userInput)`、`os.system(...)`
- 路径穿越：`open(userInput)` 不校验 `..`
- SSRF：转发用户提供的 URL 而不校验
- 敏感信息硬编码：API key、密码、token 写在代码里
- XSS：未转义渲染用户输入到 HTML
- 反序列化漏洞：`pickle.loads`、`yaml.load`（非 safe_load）
- 鉴权缺失：API 路由未检查身份；权限判断在前端
- 不安全随机：`Math.random()` 用于 token 生成
- 日志泄露：把密码/token 打到日志

### 1.3 可维护性（Maintainability）

**代码异味（Code Smells）：**
- 函数过长（> 50 行通常意味着多职责）
- 圈复杂度过高（嵌套 > 3 层、分支爆炸）
- 命名含糊：`data`、`tmp`、`handle`、`process`
- 抽象层次混乱：业务逻辑与底层 I/O 混在一起
- 重复代码：3 处以上相同结构
- 死代码：被注释掉的、永远走不到的分支
- 神秘常量：`if x > 86400` 不带注释
- 注释撒谎：注释写的和代码做的不一致

### 1.4 性能（Performance）

**常见性能反模式：**
- N+1 查询：循环里查 DB
- 不必要的拷贝：大对象按值传递、`append` 触发频繁扩容
- 阻塞调用：HTTP/IO 在主流程同步调用，未设超时
- 缓存缺失：纯计算结果反复算
- 全表扫描：缺索引、`SELECT *`
- 同步锁过粗：把 IO 包在锁内
- 字符串拼接：循环里用 `+` 拼接（应该用 builder）
- 正则编译在循环内

---

## 2. 按发现频率（基于公开统计）

来源：Codacy / SonarQube / GitHub 公开报告聚合

| 排名 | 问题类型 | 占比 | 维度 |
|------|---------|------|------|
| 1 | 错误处理缺失 | ~22% | 正确性 |
| 2 | 命名/注释问题 | ~15% | 可维护性 |
| 3 | 重复代码 | ~12% | 可维护性 |
| 4 | 资源未释放 | ~9% | 正确性 |
| 5 | 空指针/空值 | ~8% | 正确性 |
| 6 | SQL/命令注入 | ~5% | 安全 |
| 7 | 不必要的复杂度 | ~5% | 可维护性 |
| 8 | 性能反模式 | ~4% | 性能 |
| 9 | 硬编码密钥 | ~2% | 安全 |
| 其他 | - | ~18% | 混合 |

---

## 3. 假阳性高发区（要谨慎）

以下场景容易"看起来是问题，其实不是"，本 Skill 必须用提问而非断言：

- **看似无效的赋值**：可能是为编译器/linter 占位
- **看似多余的 nil check**：可能是防御外部不可信调用
- **看似可以并行的循环**：可能依赖顺序副作用
- **看似可以删除的 import**：可能依赖 init 副作用
- **看似低效的实现**：可能是为了可读性故意取舍

**对本 Skill 的强约束**：命中以上模式时，输出必须是问句（"这里在 X 情况下会不会 Y？"），不下断言。

---

## 4. 语言特定陷阱速查

### Go
- `for _, v := range items { go func() { use(v) }() }`：闭包捕获 v
- `defer file.Close()`：循环里 defer 会累积到函数退出
- `if err != nil { return }`：err 被吞，未 wrap
- `interface{} == nil` vs `*T(nil) == nil`：不等价

### Python
- 默认参数是可变对象：`def f(x=[])` 跨调用共享
- 整数除法：Py2/Py3 行为不同
- `except: pass`：吞掉所有异常包括 KeyboardInterrupt

### JavaScript/TypeScript
- `==` 与 `===`：默认建议 `===`
- `async` 函数未 await：返回 Promise 被丢弃
- `for...in` 遍历数组：会拿到原型链上属性

### Java
- `String` 拼接 in loop：用 StringBuilder
- 自动装箱在循环内：性能陷阱
- `try-with-resources` 缺失：资源泄漏

---

## 5. 落地到本 Skill 的检查清单

把以上归纳压缩成可执行的扫描列表，参见 `assets/configs/severity-rules.yaml`。
