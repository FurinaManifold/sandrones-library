---
id: analysis.continuity.inverse
family: analysis.continuity
variant: rudin
kind: theorem
state: verified
title: 反函数连续
summary: 严格单调函数 f 的反函数在值域上连续（教材 ε-δ，不用序拓扑）
premises: []
mathlib: [StrictMono.orderIso, OrderIso.lt_iff_lt, OrderIso.apply_symm_apply, Subtype.dist_eq]
provenance:
  source_type: book
  ref: Rudin, Principles of Mathematical Analysis, Thm 4.17（反函数连续）
---

# analysis.continuity.inverse

- **家族**: `analysis.continuity`
- **变体**: rudin（Rudin《Principles of Mathematical Analysis》）
- **状态**: verified
- **一句话**: 严格单调函数的反函数在值域上连续。

## 直觉

严格单调函数 f 是一一对应到其值域，反函数 g 也严格单调。对 y₀=f(x₀)、ε>0，
取 δ = min(y₀−f(x₀−ε), f(x₀+ε)−y₀) > 0，则 |y−y₀|<δ ⟹ f(x₀−ε)<y<f(x₀+ε)，
由 g 保序得 x₀−ε < g y < x₀+ε，即 g 在 y₀ 连续。

## 陈述（教材记号）

`f` 严格单调 ⟹ 反函数 `g`（定义在值域上）连续。
`mono_inv hf` 是 f 在值域上的反函数，`Continuous (mono_inv hf)`。

## 依赖（人话版）

前提：无（只用严格单调）；证明内部用 mathlib 的 `StrictMono.orderIso`
（严格单调函数的序同构）、`OrderIso.lt_iff_lt`（保序）、`OrderIso.apply_symm_apply`（f(g y)=y）、
`Subtype.dist_eq`（值域子类型度量继承）。

## 应用与陷阱

- 大一新生的烦恼是"序拓扑子类型实例"这种抽象——这里绕开它，直接用教材 ε-δ 证明。
- 反函数定义在**值域子类型** `↑(Set.range f)` 上；子类型比较 = 底层比较，
  子类型度量 = 父空间度量（`Subtype.dist_eq`）。
