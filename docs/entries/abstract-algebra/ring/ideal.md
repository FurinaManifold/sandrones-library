---
id: abstract-algebra.ring.ideal
family: abstract-algebra.ring
variant: rotman
kind: theorem
state: verified
title: 理想与商环
summary: 从左右吸收的集合定义出发构造双边理想、商同余、商环运算、自然投影与泛性质
premises: [abstract-algebra.ring.def]
mathlib: [Ideal, Quotient, RingHom.ker, RingHom.range]
provenance:
  source_type: book
  ref: Rotman, Advanced Modern Algebra, Ch 1（理想与商环）
---

# 动机

理想是使环能够取商的子结构。仅仅把元素按“差属于某个集合”分组还不够：必须先证明这是
等价关系，再证明加法、乘法和取负与代表元选择无关，才能在等价类上得到真正的环。本库把
这条构造链完整写出，而不是把 Mathlib 的 `Ideal.Quotient` 当作商环的定义。

# 直觉

左理想吸收左乘，右理想吸收右乘；双边理想同时满足两种吸收。给定双边理想 `I`，规定
`x ≡ y (mod I)` 当且仅当 `x - y ∈ I`。等价类组成 `R/I`，自然投影把 `x` 送到其等价类。
双边吸收恰好保证代表元相乘后所得等价类不变。若环同态 `f : R → S` 在 `I` 上为零，
那么 `f` 只依赖于等价类，因而唯一地下降为 `R/I → S`。

# 陈述（自然语言）

1. 左、右、双边理想分别由加法封闭、取负封闭、含零及相应方向的乘法吸收定义。
2. 任意集合生成的双边理想是包含该集合的最小双边理想；理想和与理想积仍是双边理想。
3. 模双边理想的关系 `x - y ∈ I` 是等价关系，并与加法、乘法、取负相容。
4. 商集继承零、一、加、乘、负运算并满足环公理；自然投影是环同态，其核恰为 `I`。
5. 每个在 `I` 上为零的环同态唯一地经自然投影分解，这就是商环的泛性质。

# 陈述（Lean 对照）

- `LeftIdealSet`、`RightIdealSet`、`TwoSidedIdealSet`：教材定义层的三种理想谓词。
- `generatedTwoSidedIdeal`、`idealSetSum`、`idealSetProduct`：生成理想、理想和与理想积。
- `idealCongruent`、`idealCongruent_equivalence`：模理想同余及其等价性。
- `quotientRingSet`、`quotientRingProjection`：商集与自然投影。
- `idealCongruent_add`、`idealCongruent_mul`、`idealCongruent_neg`：运算的代表元相容性。
- `quotientRingSet_ringAxioms`：商集上的具名运算满足 `RingAxioms`。
- `quotientRingProjection_is_ringHomomorphism`、`quotientRingProjection_kernel`：投影同态及其核。
- `quotientRingSetLift`、`quotientRingSet_universal_property`：下降映射与唯一分解。
- `twoSidedIdealSet_iff_exists_ideal`、`idealSetSum_eq_mathlib_sup`、
  `idealSetProduct_eq_mathlib_mul`：与 Mathlib 承载及运算的兼容桥。

# 思维脉络（thinking trace）

构造顺序不能颠倒。先由理想的加法封闭和取负封闭证明同余关系的反身、对称和传递；再分别
证明加法、乘法、取负保持同余。只有这些“良定义”引理通过后，才能用 `Quotient.map` 定义
商集运算。环公理在代表元上化回原环计算。最后自然投影的核由
`[x] = [0] ↔ x - 0 ∈ I` 得到；泛性质则用商类型的提升原则构造，并用投影满射证明唯一性。

# 自然语言 ↔ Lean 映射

| 数学语言 | Lean 接口 |
|---|---|
| `x ≡ y (mod I)` | `idealCongruent I x y` |
| 商环 `R/I` | `quotientRingSet I hI` |
| 自然投影 `π : R → R/I` | `quotientRingProjection I hI` |
| `π(x)=π(y) ↔ x-y∈I` | `quotientRingProjection_eq_iff` |
| `ker π = I` | `quotientRingProjection_kernel` |
| 由 `f(I)=0` 得到下降映射 | `quotientRingSetLift I hI f hf` |
| 商环的存在唯一分解 | `quotientRingSet_universal_property` |

# 依赖（人话版）

教材定义层只依赖集合、环运算、本库 `RingAxioms` 与 Lean 的通用商类型。Mathlib `Ideal`
以及 `Ideal.Quotient` 只出现在兼容定理中，用于复用生态中的格、核、值域和已有计算结果；
它们不承担本库核心概念的定义。

# 应用与陷阱

- 非交换环中必须使用双边理想才能定义商环乘法；单侧理想不足以保证乘法良定义。
- 理想积不是单纯的集合 `{x*y}`，而是所有两两乘积生成的双边理想。
- “映射在 `I` 上为零”是下降映射良定义的关键条件，不能只验证生成元而不补闭包论证。
- `RingHom.ker f` 的结果已经是 `Ideal R`，兼容层中不要再调用不存在的 `.toIdeal`。
- `Ideal.Quotient` 是 Mathlib 兼容实现；教材主接口应优先使用 `quotientRingSet`。
