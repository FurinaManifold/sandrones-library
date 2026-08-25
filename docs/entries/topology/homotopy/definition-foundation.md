---
id: topology.homotopy.definition-foundation
family: topology.homotopy
variant: product-with-unit-interval
kind: definition
state: verified
title: 同伦与相对端点道路同伦
summary: 使用本库积拓扑和单位区间定义一般同伦及固定端点的道路同伦
premises: [topology.foundation.constructions, topology.foundation.real-line, topology.homotopy.path-definition-foundation]
mathlib: []
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

道路拼接的单位律和结合律通常不作为严格参数化函数相等成立，而应在相对端点同伦意义下成立。因此必须先建立库内同伦对象，才能继续基本群方向。

# 直觉

同伦给每个空间点增加一个从零到一的时间参数，零时刻是第一个映射，一时刻是第二个映射。道路同伦还要求道路的起点和终点在整个变形过程中保持固定。

# 陈述（自然语言）

一般同伦是定义在 `X × I` 上的连续映射，其两个端面分别等于 `f` 和 `g`。相对端点道路同伦是两条同端点道路之间的一般同伦，并在所有时间固定源点和目标点。每个连续映射及每条道路都有常值同伦。

# 陈述（Lean 对照）

```lean
structure Homotopy (τX : TextbookTopology X) (τY : TextbookTopology Y) (f g : X → Y)
def Homotopy.refl (hf : Continuous τX τY f) : Homotopy τX τY f f
def Homotopy.symm (F : Homotopy τX τY f g) : Homotopy τX τY g f
structure PathHomotopy (γ δ : Path τX a b)
def PathHomotopy.refl (γ : Path τX a b) : PathHomotopy γ γ
def PathHomotopy.symm (F : PathHomotopy γ δ) : PathHomotopy δ γ
```

# 思维脉络（thinking trace）

参数空间明确取本库 `product τX unitInterval`。常值同伦忽略时间坐标，底层函数是 `f ∘ Prod.fst`；其连续性由本库积投影连续性和本库连续复合得到。道路常值同伦再用道路自身的源点、目标点等式验证固定边界。逆同伦用 `UnitInterval.reflect` 翻转时间坐标，积映射连续性由 `continuous_prod_mk` 从两个坐标证明。

# 自然语言 ↔ Lean 映射

“时间参数变形”对应 `Homotopy.toFun`；“零与一时刻”对应 `at_zero/at_one`；“固定道路端点”对应 `PathHomotopy.source_fixed/target_fixed`；“常值同伦”对应两个命名空间中的 `refl`；“翻转时间”对应两个命名空间中的 `symm`。

# 依赖（人话版）

只依赖本库 `product`、`unitInterval`、`Continuous` 和 `Path`。没有使用 Mathlib `TopologicalSpace`、Mathlib 同伦、连续映射封装或 Mathlib 道路。

# 应用与陷阱

一般同伦只固定时间端面；道路同伦必须额外固定参数区间的两个端点。当前已经建立自反性和通过时间反射得到的对称性；时间粘合与传递性仍需二维分段连续性。
