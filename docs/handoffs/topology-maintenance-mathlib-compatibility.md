# 拓扑 Mathlib 兼容桥 handoff

## 批次

- 分支：`codex/topology-foundations`。
- RFC：`docs/maintenance/topology-mathlib-reuse-migration.md`。
- 等级／阶段：M2 阶段 A，兼容桥；旧接口不删除，新课程承载不改变。
- 源码：`SandronesLibrary/Topology/MathlibCompatibility.lean`。
- 条目：`docs/entries/topology/foundation/mathlib-compatibility.md`。
- 建议 Registry id：`topology.foundation.mathlib-compatibility`。

## 语义链

| 教材语义 | 正式承载 | 旧接口 | 兼容性质 | 使用边界 | Entry |
|---|---|---|---|---|---|
| 开集公理给出的拓扑 | `TopologicalSpace X` | `TextbookTopology X` | `isOpen_fromMathlib` | 证明转换不改变开集 | `topology.foundation.mathlib-compatibility` |
| 两种结构完全等价 | `TopologicalSpace X` | `TextbookTopology X` | 两条往返定理、`equivMathlib` | 只迁移旧声明 | `topology.foundation.mathlib-compatibility` |

Mathlib 的 `TopologicalSpace` 与 `IsOpen` 是语义一致且已解释的正式公开承载；
`TextbookTopology` 只作为冻结的兼容桥一侧。没有私有高层证明后端或公开例外。

## Main 建议

- 顶层 import：本批不建议加入课程顶层；仅后续迁移模块按需导入。
- Registry：登记为 `bridge`／staging，不能描述成新拓扑定义。
- RADAR：登记 `TopologicalSpace.ext` 用于证明结构往返，不把 `TopologicalSpace` 标为挂靠缺口。
- ROADMAP：M2 阶段 A 兼容桥完成；A1 教材条目迁移仍未开始。
- 共有文件均未由学科分支修改。

## 验收与边界

- 临时框架先用两个待证明孔验证组装，再逐项完成；正式源码无占位。
- 下一步需要构建目标模块、聚合检查五个声明、公理与 Entry 映射审计。
- 尚未迁移任何旧道路、同伦或基本群公开签名；旧 API 使用计数没有下降。
