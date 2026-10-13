---
id: examples.topology.spaces
kind: example
state: verified
title: 内部、闭包与边界的实直线计算例
summary: 开区间的闭包、闭区间的内部、开区间的边界，以及开集不必闭、闭集不必开的精确反例
premises: [topology.space.closure]
mathlib: [closure_Ioo, interior_Icc, frontier_Ioo, right_mem_Icc, left_mem_Icc, lt_irrefl]
provenance:
  source_type: book
  ref: "munkres-topology-2000"
---

# 动机

Wave E3 新登记的条目 `topology.space.closure` 给出内部、闭包与边界的抽象定义与极值性质。
抽象定义落回实直线时需要可核对的数值对象：`(0,1)` 的闭包是什么、`[0,1]` 的内部是什么、
`(0,1)` 的边界是什么。本 Entry 给出这组计算，并配两个把“开集／闭集”常用误认钉死的反例。

# 直觉

- 开区间丢掉端点，闭包把端点“补回来”：`closure (0,1) = [0,1]`。
- 闭区间本身是闭的，其内部要“抠掉”端点：`interior [0,1] = (0,1)`。
- 边界是“闭包减去内部”，对开区间正好是两个端点：`frontier (0,1) = {0,1}`。
- 因此开区间一般**不**等于自己的闭包（不闭），闭区间一般**不**等于自己的内部（不开）。

# 陈述（自然语言）

在实直线上：

1. `closure (0,1) = [0,1]`；
2. `interior [0,1] = (0,1)`；
3. `frontier (0,1) = {0,1}`；
4. `closure (0,1) ≠ (0,1)`（开集不必闭）；
5. `interior [0,1] ≠ [0,1]`（闭集不必开）。

# 陈述（Lean 对照）

```lean
theorem closure_Ioo_zero_one : closure (Ioo (0 : ℝ) 1) = Icc 0 1
theorem interior_Icc_zero_one : interior (Icc (0 : ℝ) 1) = Ioo 0 1
theorem frontier_Ioo_zero_one : frontier (Ioo (0 : ℝ) 1) = ({0, 1} : Set ℝ)

theorem closure_Ioo_ne_self : closure (Ioo (0 : ℝ) 1) ≠ Ioo 0 1
theorem interior_Icc_ne_self : interior (Icc (0 : ℝ) 1) ≠ Icc 0 1
```

# 思维脉络

计算 1–3 直接由稠密线性序上的标准结论给出：`closure_Ioo`（需左右端点不等）、
`interior_Icc`（需无最小／最大元，`ℝ` 满足）、`frontier_Ioo`（需左端点严格小于右端点）。

反例 4–5 不是简单否定，而是给出**满足一边、不满足另一边**的具体元素：`1 ∈ closure (0,1)`
（由 `right_mem_Icc`）但 `1 ∉ (0,1)`；`0 ∈ [0,1]`（由 `left_mem_Icc`）但 `0 ∉ interior [0,1]`。
把假定的“集合等于其闭包／内部”代回后，得到 `1 < 1` 或 `0 < 0`，由 `lt_irrefl` 矛盾。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 内部 | `interior s` |
| 闭包 | `closure s` |
| 边界 | `frontier s` |
| 开区间 `(0,1)` | `Ioo (0:ℝ) 1` |
| 闭区间 `[0,1]` | `Icc (0:ℝ) 1` |

# 依赖（人话版）

- `topology.space.closure`：本 Entry 直接实例化其中的 `interior`／`closure`／`frontier`
  定义与极值性质；计算例不重新定义任何拓扑概念。

# 应用与陷阱

- **应用**：闭包与内部是紧致性、连通性、Jordan 区域“边界零体积”等后续内容的共同前置；
  本 Entry 是它们最直观的实直线模型。
- **陷阱**：开集、闭集不是互斥概念，也不是互补关系。反例 4–5 只说明“开区间一般不闭、
  闭区间一般不开”；`∅` 与 `ℝ` 同时既开又闭。不要把本 Entry 的两个反例误读成
  “开 ⟹ 不闭”。
