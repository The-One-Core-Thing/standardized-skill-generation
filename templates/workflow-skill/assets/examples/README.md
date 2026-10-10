# assets/examples/ — 输入输出示例

## 用途

存放真实输入样本与对应的输出示例，作为 Skill 行为的「活文档」。
重点放**端到端示例**：从输入到最终产出，全链路展示。

## 应该放什么

- **典型场景**：覆盖最常见 80% 用例的 input / output 对
- **边界场景**：极端输入（超大、空、嵌套等）的处理示例
- **good vs bad**：同一场景的「好示例」和「坏示例」对比，标注差异点
- **失败示例**：流程触发回滚 / 中断的输入与对应输出

## 命名规则

- 单文件示例：`example-<场景>.md`
- good/bad 对比：`<场景>-good.md` / `<场景>-bad.md`
- 含输入输出的子目录：`example-<场景>/{input,output}.<ext>`

## 示例

```
examples/
├── example-basic-deploy/
│   ├── input.yaml             # 部署描述
│   └── output.md              # 期望产出的部署报告
├── canary-rollback-good.md    # 灰度回滚正面示例
├── canary-rollback-bad.md     # 反面示例（说明哪里错了）
└── example-large-cluster.md   # 边界场景：50+ 节点
```
