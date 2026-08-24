---
id: abstract-algebra.group.cyclic
kind: theorem
state: verified
title: "循环群与元素阶"
premises: ["abstract-algebra.group.def", "abstract-algebra.group.coset"]
mathlib: ["Subgroup.zpowers", "Subgroup.mem_zpowers_iff", "Nat.card_zpowers", "isCyclic_iff_exists_zpowers_eq_top", "Subgroup.le_zpowers_iff", "zpowers_eq_top_of_prime_card", "zmodMulEquivOfGenerator", "zmodCyclicMulEquiv", "mulEquivOfCyclicCardEq"]
provenance:
  source_type: book
  ref: "Rotman, An Introduction to the Theory of Groups, Ch 2（循环群）"
---

# 动机

循环群是最接近整数加法的群：选定一个元素 g 后，群中每个元素都由反复乘 g 或 g⁻¹
得到。它既是一般群论的第一个完整分类例子，也是元素阶、Lagrange 定理和商群计算的
基本试验场。

# 直觉

`⟨g⟩` 收集所有整数次幂 `gⁿ`。如果 `⟨g⟩ = G`，则 g 是生成元，G 是循环群。
有限情形中，幂序列第一次回到单位元所需的步数就是 `orderOf g`，也恰是 `⟨g⟩`
的元素个数。因此 g 生成有限群 G 当且仅当它的阶达到 |G|。

循环群的子群不会产生新的复杂结构：`⟨g⟩` 的每个子群都由某个 `gⁿ` 生成。
特别地，若 |G| 是素数，则非单位元的阶不可能是 1，只能是 |G|，所以它生成全群。

# 陈述（自然语言）

- 循环子群的元素恰是生成元的整数次幂。
- `|⟨g⟩| = ord(g)`。
- G 循环当且仅当存在 g 使 `⟨g⟩ = G`。
- 循环群的每个子群仍循环，并形如 `⟨gⁿ⟩`。
- 素数阶群的每个非单位元都是生成元。
- 指定生成元 g 后，存在唯一的标准同构把 `1 mod n` 送到 g，并把 k 送到 `g^k`。
- 每个循环群都与 `Multiplicative (ZMod |G|)` 同构；同阶循环群彼此同构。

# 陈述（Lean 对照）

`cyclicSubgroup`、`mem_cyclicSubgroup_iff`、`cyclicSubgroup_card`、
`cyclic_iff_exists_generator`、`generator_order_eq_group_card`、
`subgroup_of_cyclic_is_cyclic`、`subgroup_of_cyclic_eq_cyclicSubgroup`、
`prime_card_group_generated_by_nonidentity`。
`zmodEquivOfGenerator`、`zmodEquivOfGenerator_apply_intCast`、
`zmodEquivOfGenerator_apply_one`、`cyclicGroupEquivZMod`、
`cyclicGroupsEquivOfCardEq`、`primeCardGroupsEquiv`。

# 思维脉络（thinking trace）

先把生成子群具体化为 `Subgroup.zpowers g`，再把抽象的 `IsCyclic G` 转换成
“某个循环子群等于顶子群”。子群分类由 `H ≤ ⟨g⟩` 出发，取 H 中最小的正幂指数；
mathlib 的 `Subgroup.le_zpowers_iff` 封装了这一经典论证。素数阶结论则把 Lagrange
的整除信息应用到 `⟨g⟩`。

分类阶段固定生成元 g，定义 `[k] ↦ g^k`。`g^n=1` 保证它不依赖整数代表元，生成性给
满射，而 `ord(g)=n` 给单射。忘掉指定生成元后，通过选择一个生成元得到非规范同构。

# 自然语言 ↔ Lean 映射

- `⟨g⟩` ↔ `cyclicSubgroup g` / `Subgroup.zpowers g`
- `g` 的阶 ↔ `orderOf g`
- G 是循环群 ↔ `IsCyclic G`
- G 的阶 ↔ `Nat.card G`，有限类型上也可写 `Fintype.card G`
- 加法循环群 `Z/nZ` 的乘法记法 ↔ `Multiplicative (ZMod n)`

# 依赖（人话版）

依赖子群与 Lagrange 定理。底层复用 `Subgroup.mem_zpowers_iff`、`Nat.card_zpowers`、
`isCyclic_iff_exists_zpowers_eq_top`、`Subgroup.le_zpowers_iff` 和素数阶群接口。
分类部分使用 `zmodMulEquivOfGenerator` 与 `zmodCyclicMulEquiv`。

# 应用与陷阱

- 群的乘法记号下必须使用整数幂 `g ^ (n : ℤ)` 才能同时表达正幂和负幂。
- `orderOf g = 0` 表示 g 为无限阶，不表示单位元；单位元的阶是 1。
- “循环群的子群唯一”是错误的；正确说法是每个子群仍循环。有限循环群中每个群阶因子
  对应唯一子群；本条目的 `⟨gⁿ⟩` 形状定理是这一分类的核心。
- `ZMod n` 使用加法群结构；为了与乘法记号的 G 做群同构，需要包一层 `Multiplicative`。
- `ZMod 0` 在 mathlib 中表示整数，因此统一的分类陈述也覆盖无限循环群。
