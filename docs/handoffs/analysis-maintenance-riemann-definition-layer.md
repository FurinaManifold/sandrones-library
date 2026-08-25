# Analysis maintenance handoff：一元 Riemann 教材定义层

- 基线：Main `9572873`
- Entry：`real-analysis.riemann.def`
- 影响等级：M0；修复 Entry 漏挂并澄清既有两层可积性接口。

## 定义链与归属

| 概念 | 本库定义 | 角色 | 首个真实使用者 |
|---|---|---|---|
| 分划 | `DarbouxPartition` | 严格递增端点数据和证明 | `lowerSum`、`upperSum`、`uniformPartition` |
| Darboux 和 | `lowerSum`、`upperSum` | 子区间下确界／上确界加权和 | `RiemannIntegrable`、`riemannIntegral` |
| 间隙可积性 | `RiemannIntegrable` | 上下和差可任意小 | 连续可积、Lebesgue 判据 |
| 标准有界可积性 | `RiemannIntegrableWithBound` | `BoundedOn ∧ RiemannIntegrable` | 一般数值桥和 Lebesgue 判据 |
| 积分值 | `riemannIntegral` | 所有 Darboux 下和的上确界 | 代数、FTC、换元和数值桥 |

`RiemannIntegrable` 没有静默包含有界性；需要标准教材假设的下游使用组合接口。这是既有兼容边界，
本窗不破坏性重定义。Mathlib 的 `IntervalIntegrable`、Lebesgue 区间积分只位于具名比较桥或证明后端。

## Entry 修复

原源码首个 `real-analysis.riemann.def` 标记位于 `RiemannIntegrable` 前，导致分划和两种 Darboux 和
不受声明映射覆盖。本窗把同一 Entry 的前置标记补到 `DarbouxPartition`，不跨文件合并 Entry。
`RiemannIntegrableWithBound` 属于既有 Lebesgue 判据文件及其 Entry，不强行归入本定义文件。

## 验证

- `Riemann`、`RiemannCriterion`、`RiemannIntegralBridge` 定向构建通过；七项定义链聚合 `#check` 通过。
- Entry 映射现覆盖 39 个声明并包含此前漏掉的三个核心声明；audit 与公理审计一致。
- 禁用占位扫描与 `git diff --check` 通过。
