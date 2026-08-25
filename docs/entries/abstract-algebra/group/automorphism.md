---
id: abstract-algebra.group.automorphism
kind: theorem
state: verified
title: "群的自同构与内自同构"
summary: 自同构群的运算、共轭同态、内自同构群以及 G/Z(G) 与 Inn(G) 的同构
premises: ["abstract-algebra.group.iso-theorems"]
mathlib: ["MulAut", "MulAut.conj", "Subgroup.center", "QuotientGroup.quotientMulEquivOfEq"]
provenance:
  source_type: book
  ref: "dummit-foote-abstract-algebra-2004"
---

# 动机

半直积需要一个同态 `H → Aut(N)`，因此必须先明确什么是自同构群。自同构也把群的
内部对称性本身组织成一个新群，并使共轭这一基本操作能够用同态语言表达。

# 直觉

自同构是既保持群运算又可逆的重命名。两个重命名依次执行仍是重命名，反向执行给出逆元。
群元素 `g` 通过 `x ↦ gxg⁻¹` 重排群；中心元素恰好产生恒等重排。

# 陈述（自然语言）

- `Aut(G)` 在复合下构成群，单位元为恒等映射，逆元为逆函数。
- 共轭给出群同态 `G → Aut(G)`，其像定义为 `Inn(G)`。
- 共轭同态的核是中心 `Z(G)`，故由第一同构定理有 `G/Z(G) ≅ Inn(G)`。

# 陈述（Lean 对照）

`AutomorphismGroup` 对应 `Aut(G)`；`identityAutomorphism`、`automorphism_comp_apply`、
`automorphism_inv_apply_apply` 给出群运算；`innerAutomorphismHom` 与
`innerAutomorphismGroup` 给出共轭同态和 `Inn(G)`；`innerAutomorphismHom_ker` 与
`centerQuotientEquivInnerAutomorphisms` 给出中心核公式和最终同构。

# 思维脉络（thinking trace）

先把双射群同态按复合组织成群，再观察 `conj(gh)=conj(g)∘conj(h)`。一个元素落在
共轭同态的核中，当且仅当它与每个元素交换，因此核等于中心。最后直接应用此前完成的
第一同构定理，并沿 `ker(conj)=Z(G)` 改写商群。

# 自然语言 ↔ Lean 映射

- `Aut(G)` ↔ `MulAut G`。
- 自同构复合 ↔ `MulAut` 的乘法。
- `conj_g` ↔ `MulAut.conj g`。
- `Inn(G)` ↔ `(MulAut.conj : G →* MulAut G).range`。
- `Z(G)` ↔ `Subgroup.center G`。

# 依赖（人话版）

依赖群同态、核与像、正规子群、商群及第一同构定理。

# 应用与陷阱

- `Aut(G)` 的乘法次序是函数复合：`(σ τ)(x)=σ(τ(x))`。
- 内自同构只是所有自同构的一个子群；一般 `Inn(G) ≠ Aut(G)`。
- `G → Aut(G)` 的核不是平凡子群，而是中心；只有无中心群时该同态才单射。
- 半直积中的作用 `H → Aut(N)` 可以是任意同态，不必来自某个更大群中的共轭。
