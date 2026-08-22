---
id: topology.space.closure
kind: theorem-family
state: verified
title: "内部、闭包与边界"
premises: ["topology.space.def", "topology.space.neighborhood"]
mathlib: ["interior", "closure", "frontier", "mem_closure_iff"]
provenance:
  source_type: book
  ref: "点集拓扑：内部、闭包与边界"
---

# 定义

- `interior s` 是 `s` 所含全部开集的并，即 `s` 中最大的开集；
- `closure s` 是包含 `s` 的全部闭集之交，即包含 `s` 的最小闭集；
- `frontier s = closure s \ interior s` 是集合的边界。

# 基本性质

本条目给出内部与闭包的极值性质、单调性、开闭判据、补集对偶，以及闭包的邻域
刻画：一点属于 `closure s`，当且仅当它的每个开邻域都与 `s` 相交。

边界同时满足

`frontier s = closure s ∩ closure sᶜ`，

因此是闭集，并且集合与补集具有相同边界。闭包可分解为内部与边界之并，也可分解
为原集合与边界之并。

# 后续用途

Jordan 可测区域以“有界且边界零体积”定义；闭包、边界和邻域接口也是紧致性、连通性、
流形边界及微分形式积分的共同前置。
