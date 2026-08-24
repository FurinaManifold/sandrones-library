---
id: settheory.cardinal.konig-theorem
kind: theorem
state: verified
title: "König 定理：逐坐标的严格不等式不能在和与积之间消失"
premises: ["settheory.cardinal.addition", "settheory.cardinal.multiplication"]
mathlib: ["Cardinal.sum_lt_prod", "Cardinal.lt_power_cof_ord"]
provenance: {source_type: book, ref: "Thomas Jech, Set Theory, Chapter 5: König's Theorem"}
---

# 动机

基数和表示“选择一个坐标再取该坐标中的元素”，基数积表示“同时为每个坐标选择元素”。当每个坐标右侧都严格更大时，局部余量能否在整体比较中消失？König 定理回答不能。

# 直觉

设第 `i` 组只有 `κᵢ` 个候选，而第 `i` 坐标有 `λᵢ` 个取值，且 `κᵢ<λᵢ`。第 `i` 组不可能用尽该坐标，于是挑一个遗漏值。对每个坐标同时这样挑，组成的新函数会逃离每一组。这是 Cantor 对角线法的多坐标版本。

# 陈述（自然语言）

若对每个指标 `i` 都有 `κᵢ<λᵢ`，则所有 `κᵢ` 的基数和严格小于所有 `λᵢ` 的基数积。另一个公开推论说：无限基数 `c` 严格小于 `c` 的 `cf(c)` 次幂。

# 陈述（Lean 对照）

```lean
theorem konig_theorem (κ μ : ι → Cardinal)
    (h : ∀ i, κ i < μ i) :
    Cardinal.sum κ < Cardinal.prod μ

theorem cardinal_lt_power_cofinality (hc : Cardinal.aleph0 ≤ c) :
    c < c ^ CardinalCofinality c
```

证明分别调用 `Cardinal.sum_lt_prod` 与 `Cardinal.lt_power_cof_ord`；这两个 mathlib 名称是证明后端，本库定理是供课程和后续条目依赖的公开接口。

# 思维脉络（thinking trace）

把和的元素按其标签 `i` 分组。若它们试图覆盖积中的全部函数，第 `i` 组在第 `i` 坐标至多出现 `κᵢ` 个值。严格不等式保证可选一个遗漏值；选择所有遗漏值形成对角函数，并在其标签对应坐标上区别于每个被列对象。形式化复用后端定理，避免重新展开依赖函数编码。

# 自然语言 ↔ Lean 映射

- 带标签不交并的大小 ↔ `Cardinal.sum κ`。
- 所有选择函数的大小 ↔ `Cardinal.prod μ`。
- 每坐标严格余量 ↔ `h : ∀ i, κ i < μ i`。
- 多坐标对角结论 ↔ `konig_theorem`。
- 共尾性幂推论 ↔ `cardinal_lt_power_cofinality`。

# 依赖（人话版）

需要理解基数和、不交并、基数积与依赖函数空间。共尾性推论还需要基数共尾性，并要求 `c` 无限。Lean 的主要组合论证明由 mathlib 提供，本库没有把它冒充为从零重建。

# 应用与陷阱

该定理是共尾性与基数幂的重要工具。每个坐标都必须严格小于；仅有 `≤` 时可能没有遗漏值。结论比较的是无限基数和与依赖积，不是普通有限算术，也不要和图论的 König 定理混淆。
