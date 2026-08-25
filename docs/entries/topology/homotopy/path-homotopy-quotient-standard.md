---
id: topology.homotopy.path-homotopy-quotient-standard
family: topology.homotopy
variant: endpoint-relative-quotient
kind: definition
state: staging
title: 道路同伦商的标准承载
summary: 以 Mathlib Path.Homotopic.Quotient 承载端点固定道路同伦类，并把商类判等展开为连续正方形变形
premises: [topology.homotopy.path-homotopy-standard]
mathlib: [Path.Homotopic, Path.Homotopic.setoid, Path.Homotopic.Quotient, Path.Homotopic.Quotient.mk]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

道路拼接的单位律与结合律通常不在固定参数函数层严格成立，却在端点固定同伦后成立。因此基本群不能把原始环路直接当元素，而应先把道路按端点固定同伦取商。

# 直觉

一个道路同伦商类收集所有可以在保持起点、终点不动的条件下互相连续变形的道路。商类记住“如何从 `x` 走到 `y`”的同伦类型，但忘掉速度、停顿和可连续消除的绕行细节。

# 陈述（自然语言）

Mathlib 用 `Path.Homotopic` 作为 `Path x y` 上的等价关系，并以 `Path.Homotopic.Quotient x y` 作为商类型。两条道路的商类相等，当且仅当存在从第一条道路到第二条道路的连续正方形变形，且变形全过程固定 `x`、`y`。每个商类至少有一条道路代表。

# 陈述（Lean 对照）

```lean
theorem pathHomotopyQuotient_mk_eq_iff_exists_fixed_endpoint_deformation :
  Path.Homotopic.Quotient.mk p = Path.Homotopic.Quotient.mk q ↔
    ∃ F : unitInterval × unitInterval → X, Continuous F ∧
      (∀ s, F (0, s) = p s) ∧ (∀ s, F (1, s) = q s) ∧
      (∀ t, F (t, 0) = x) ∧ (∀ t, F (t, 1) = y)

theorem pathHomotopyQuotient_exists_representative
  (P : Path.Homotopic.Quotient x y) :
  ∃ p : Path x y, Path.Homotopic.Quotient.mk p = P
```

# 思维脉络（thinking trace）

Mathlib 的商判等定理先把两个 `mk` 相等化为 `p.Homotopic q`。该关系按定义是存在一个 `Path.Homotopy p q`；H1 已把后者完整展开为正方形连续性、两个时间切片和两条固定端点边界。代表存在性来自商映射的满射性。

# 自然语言 ↔ Lean 映射

“端点固定同伦”对应 `Path.Homotopic`；“按同伦取商”对应 `Path.Homotopic.Quotient`；“道路所在商类”对应 `Path.Homotopic.Quotient.mk`；“商类相等”对应 `pathHomotopyQuotient_mk_eq_iff_exists_fixed_endpoint_deformation`；“选择代表”对应 `pathHomotopyQuotient_exists_representative`。

# 依赖（人话版）

本条目只依赖已经集成的标准道路同伦承载。教材定位为 Hatcher 第 1.1 节。Mathlib 的关系、等价关系和商类型与教材语义一致，故直接复用；没有建立本库商结构，也不使用旧 `TextbookTopology` 同伦链。

# 应用与陷阱

商类相等不是道路作为函数严格相等。代表存在但不唯一；换代表必须用道路同伦证明结果良定义。本批只冻结商承载和判等，不开放基本群乘法、单位、逆、结合律、函子性或计算。`Path.Homotopic.Quotient.trans` 的商上运算存在于 Mathlib，但其群论解释属于后续受门控窗口。
