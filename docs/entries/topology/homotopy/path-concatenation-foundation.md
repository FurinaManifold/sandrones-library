---
id: topology.homotopy.path-concatenation-foundation
family: topology.homotopy
variant: half-interval-gluing
kind: definition
state: verified
title: 道路拼接
summary: 用单位区间左右半段的线性缩放拼接具有公共端点的两条道路
premises: [topology.foundation.real-line, topology.homotopy.path-definition-foundation]
mathlib: []
provenance:
  source_type: book
  ref: "Hatcher, Algebraic Topology, Section 1.1"
---

# 动机

道路拼接是道路连通、基本群乘法和道路同伦的基础运算。这里必须从本库单位区间与本库连续性直接构造，不能借用 Mathlib 的道路拼接。

# 直觉

在参数区间前一半以两倍速度走完第一条道路，在后一半以两倍速度走完第二条道路。两段在中点分别到达第一条道路终点和第二条道路起点，而这两个点按类型就是同一个公共端点。

# 陈述（自然语言）

若 `γ` 是从 `a` 到 `b` 的道路，`δ` 是从 `b` 到 `c` 的道路，则分段函数在中点粘合为连续函数，并定义从 `a` 到 `c` 的拼接道路。

# 陈述（Lean 对照）

```lean
theorem Path.continuous_transFun (γ : Path τ a b) (δ : Path τ b c) :
  Continuous unitInterval τ (Path.transFun γ δ)
def Path.trans (γ : Path τ a b) (δ : Path τ b c) : Path τ a c
```

# 思维脉络（thinking trace）

先构造左右半区参数 `2t` 与 `2t-1`。连续性证明使用 `continuous_from_unitInterval_iff`：中点之外选择同时不跨越中点且缩放后仍落入原道路连续性半径的邻域；在中点分别取得第一条道路终点和第二条道路起点处的半径，再取两者一半的最小值。公共端点保证两侧像都落入同一个开集。

# 自然语言 ↔ Lean 映射

“左右半区缩放”对应 `UnitInterval.leftDouble/rightDouble`；“分段函数”对应 `Path.transFun`；“中点粘合连续”对应 `Path.continuous_transFun`；“拼接道路”对应 `Path.trans`；左右半区上的直接取值规则对应 `Path.trans_apply_of_le/not_le`。

# 依赖（人话版）

依赖本库 `Path` 的端点字段和本库单位区间 ε 连续性判据。`linarith` 与 `norm_num` 只核验实数线性不等式和常数等式，不提供拓扑定义、连续性定理或道路结构。本条没有 Mathlib bridge，也没有 Mathlib `Path.trans`。

# 应用与陷阱

该拼接选择固定的二倍速参数化，因此与常值道路拼接通常不是严格相等，结合律也不应直接声明为函数相等；这些性质需要后续重新参数化或道路同伦理论。
