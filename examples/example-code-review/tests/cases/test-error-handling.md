# 测试用例：异常处理场景

> 测试 ID：case-02-error-handling
> 目的：验证 Skill 能识别错误吞没、资源泄漏、并区分"看似有问题"的合法写法
> 维度覆盖：正确性（主） / 可维护性（次）

---

## 输入

**用户消息**："/review"

**附加 context**："这是一个数据导入脚本，跑在批处理任务里，每天一次。"

**待审查代码（Go）**：

```go
package importer

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type Record struct {
	ID    int
	Name  string
	Score float64
}

func ImportCSV(path string) []Record {
	f, _ := os.Open(path)
	reader := csv.NewReader(f)

	var records []Record
	for {
		row, err := reader.Read()
		if err != nil {
			break
		}

		id, _ := strconv.Atoi(row[0])
		score, _ := strconv.ParseFloat(row[2], 64)

		records = append(records, Record{
			ID:    id,
			Name:  row[1],
			Score: score,
		})
	}

	return records
}

func PrintRecord(r Record) {
	defer func() {
		if r := recover(); r != nil {
			// intentionally swallow: 防止单条数据格式异常导致整个批处理中断
		}
	}()
	fmt.Printf("[%d] %s: %.2f\n", r.ID, r.Name, r.Score)
}
```

---

## 验证项（Skill 必须命中）

### 必须识别（Major / Critical）
1. ✅ `os.Open` 错误被丢弃 + `f` 未 Close（COR-001 + COR-002）
2. ✅ `for` 循环中 `err != nil { break }` 把 io.EOF 与真正错误一视同仁，会静默跳过坏数据（COR-001）
3. ✅ `strconv.Atoi / ParseFloat` 错误被丢弃，导致脏数据进入结果（COR-001）
4. ✅ 函数签名 `[]Record` 没有返回 error，调用方无法区分"空文件"和"导入失败"

### 应该用问句（不是断言）
5. ❓ `row[0]`、`row[1]`、`row[2]` 直接索引，CSV 列数不足时会 panic — Skill 应问"CSV 列数是否被上游保证？"

### 必须避免的失败模式
- ❌ 不要把 `PrintRecord` 中的 `recover` 当成错误吞没——已经在注释中说明是有意为之，这是 D5 决策的典型场景
- ❌ 不要把 context 里的"批处理任务"信息忽略——错误吞没在批处理 vs 在线服务的严重度不同
- ❌ 不要建议改用其他 CSV 库（超出审查范围，是设计建议而非 review）

### 加分项
- 在 Questions 部分提出 `recover` 的 swallow 策略是否应该至少 log 一行
- 在审查覆盖说明中提及"无法判断 CSV 输入是否可信"

---

## 期望输出

见 `tests/expected/test-error-handling-expected.md`
