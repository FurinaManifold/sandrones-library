---
id: abstract-algebra.group.product
kind: theorem
state: verified
title: "群的直积、内部直积与半直积"
premises: ["abstract-algebra.group.automorphism"]
mathlib: ["MulEquiv.prodComm", "MulEquiv.prodAssoc", "MonoidHom.noncommCoprod", "SemidirectProduct.mulEquivProd", "SemidirectProduct.mulEquivSubgroup"]
provenance:
  source_type: book
  ref: "dummit-foote-abstract-algebra-2004"
---

# 动机

直积把两个群并列组合；内部直积识别环境群中已经存在的两个独立因子；半直积则允许
一个因子通过自同构作用于另一个因子，从而描述非交换的分裂扩张。

# 直觉

直积中的两个坐标互不干扰。内部直积要求每个元素唯一写成 `hk` 且两个因子交换。
半直积仍有唯一坐标 `(n,g)`，但相乘时第二个左坐标会先被 `g` 的作用扭曲。

# 陈述（自然语言）

直积满足交换、结合的规范同构。逐元素交换且唯一分解的互补子群给出内部直积。
半直积乘法为 `(n₁,g₁)(n₂,g₂)=(n₁φ(g₁)n₂,g₁g₂)`；平凡作用退化为直积；
正规互补子群给出环境群的内部半直积分解。

# 陈述（Lean 对照）

对应 `directProductComm/Assoc`、`internalDirectProductEquiv`、
`semidirectProduct_mul/decomposition`、`trivialSemidirectProductEquiv` 与
`internalSemidirectProductEquiv`。

# 思维脉络（thinking trace）

先把坐标乘法证明为同态，再由唯一分解得到双射并升级为群同构。半直积中正规性保证
共轭作用留在左因子内，互补性则保证坐标乘法仍是双射。

# 自然语言 ↔ Lean 映射

- 自同构群 `Aut(N)` ↔ `MulAut N`。
- 半直积 `N ⋊φ G` ↔ `N ⋊[φ] G`。
- 唯一分解 ↔ `H.IsComplement' K`。
- 两子群逐元素交换 ↔ `∀ h k, Commute (h:G) (k:G)`。

# 依赖（人话版）

依赖群、子群、正规子群、群同构与互补子群的基本语言。

# 应用与陷阱

- `H.IsComplement' K` 记录的是乘法映射的双射性，不自动声称两个子群交换。
- 内部半直积只要求左因子正规；内部直积还需两因子逐元素交换。
- 半直积的底层类型虽是积类型，群乘法通常不是逐坐标乘法。
