---
id: abstract-algebra.ring.quotient
family: abstract-algebra.ring
variant: rotman
kind: theorem
state: verified
title: 商环及其泛性质
summary: 从模双边理想同余构造商环、自然投影、投影核与唯一下降映射
premises: [abstract-algebra.ring.ideal]
mathlib: [Quotient]
provenance:
  source_type: book
  ref: Rotman, Advanced Modern Algebra, Ch 1（商环）
---

# 动机

把环元素按模理想同余分组时，必须证明等价类运算不依赖代表元。完成这一步后，商环才是
真正定义出来的对象，而不只是一个借用 Mathlib `Ideal.Quotient` 的已有名称。

# 直觉

给定双边理想 `I`，规定 `x` 与 `y` 同余当且仅当 `x-y∈I`。等价类组成 `R/I`，自然投影
把元素送到其等价类。双边吸收保证乘法也能下降。任何在 `I` 上为零的环同态只依赖等价类，
因而唯一地经商投影分解。

# 陈述（自然语言）

模双边理想关系是等价关系，并且与加法、乘法和取负相容。商集继承零、一、加法、乘法和
取负并满足全部环公理。自然投影是环同态，其核恰为原理想。每个在原理想上为零的环同态，
存在唯一的商环环同态使投影三角交换。

# 陈述（Lean 对照）

- `idealCongruent`、`idealCongruent_equivalence`：模理想同余及等价性。
- `idealCongruenceSetoid`、`quotientRingSet`、`quotientRingProjection`：商集与投影。
- `idealCongruent_add`、`idealCongruent_mul`、`idealCongruent_neg`：代表元相容性。
- `quotientAdd`、`quotientMul`、`quotientNeg`、`quotientZero`、`quotientOne`：商运算。
- `quotientRingSet_ringAxioms`：商集满足本库环公理。
- `quotientRingProjection_is_ringHomomorphism`、`quotientRingProjection_kernel`：投影及核。
- `quotientRingSetLift`、`quotientRingSet_universal_property`：下降映射与存在唯一泛性质。

# 思维脉络（thinking trace）

先证明“差属于理想”具有自反、对称与传递性，再分别证明三种运算保持同余。随后用
`Quotient.map` 和 `Quotient.map₂` 定义运算，并通过商类型归纳把环公理化回代表元上的原环
公理。投影核由 `[x]=[0]` 的判等准则得到；泛性质则由 `Quotient.lift` 构造，并利用每个商类
都有代表元证明唯一性。

# 自然语言 ↔ Lean 映射

| 数学语言 | Lean 接口 |
|---|---|
| `x≡y (mod I)` | `idealCongruent I x y` |
| 商环底层集合 `R/I` | `quotientRingSet I hI` |
| 自然投影 `π` | `quotientRingProjection I hI` |
| `π(x)=π(y) ↔ x-y∈I` | `quotientRingProjection_eq_iff` |
| `ker π=I` | `quotientRingProjection_kernel` |
| 下降映射 | `quotientRingSetLift I hI f hf hker` |
| 存在唯一分解 | `quotientRingSet_universal_property` |

# 依赖（人话版）

本条目依赖 `abstract-algebra.ring.ideal` 提供双边理想，依赖本库 `RingAxioms` 与
`RingHomomorphism` 描述环和环同态。实现只使用 Lean 通用 `Quotient`；Mathlib
`Ideal.Quotient` 不承担教材定义。

# 应用与陷阱

- 乘法良定义需要双边吸收，单侧理想不能直接构造商环。
- 必须先证明代表元相容性，再注册商集运算实例。
- “在 `I` 上为零”是下降映射良定义的必要条件。
- `Quotient.sound` 是商类型的逻辑公理依赖，不是未证明的项目公理。
