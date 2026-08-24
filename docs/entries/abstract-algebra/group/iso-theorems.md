---
id: abstract-algebra.group.iso-theorems
kind: theorem
state: verified
title: "群的第二、第三同构定理与对应定理"
summary: 第二同构定理、第三同构定理、子群保序对应及正规性保持
premises: ["abstract-algebra.group.hom"]
mathlib: ["QuotientGroup.quotientInfEquivProdNormalQuotient", "QuotientGroup.quotientQuotientEquivQuotient", "QuotientGroup.comapMk'OrderIso"]
provenance:
  source_type: book
  ref: "Rotman, An Introduction to the Theory of Groups, Ch 2（同构定理）"
---

# 动机

第一同构定理说明一个同态会把它的核商掉。本条目进一步回答三个自然问题：两个子群
如何借助商群比较；连续做两次商是否等于一次商；商群的子群怎样在原群中识别。

# 直觉

若 `N` 正规，`H` 中落入 `N` 的部分恰为 `H ∩ N`，所以把这部分商掉后，剩余信息
与 `HN` 在模 `N` 后的信息相同。若 `N ≤ M`，先忘掉 `N`、再忘掉 `M/N`，恰好
等于一次忘掉 `M`。最后，商映射的原像把 `G/N` 的子群拉回为恰好包含 `N` 的子群。

# 陈述（自然语言）

- 第二同构定理：`H/(H∩N) ≅ (HN)/N`。
- 第三同构定理：若 `N ≤ M`，则 `(G/N)/(M/N) ≅ G/M`。
- 对应定理：`G/N` 的子群与 `G` 中包含 `N` 的子群保序一一对应；正规子群彼此对应。

# 陈述（Lean 对照）

- `secondIsomorphism`：第二同构的显式乘法同构。
- `thirdIsomorphism`、`thirdIsomorphism_apply_mk_mk`：第三同构及 `xN ↦ xM` 公式。
- `subgroupCorrespondence`：子群之间的 `OrderIso`。
- `subgroupCorrespondence_apply`、`subgroupCorrespondence_symm_apply`：原像与像公式。
- `subgroupCorrespondence_normal_forward/backward`：正规性双向保持。

# 思维脉络（thinking trace）

第二同构由 `H → HN/N` 的自然同态应用第一同构定理得到，其核为 `H∩N`。第三同构
使用自然映射 `G/N → G/M`，其核为 `M/N`。对应定理则利用商映射满射：取原像和取像
互为逆操作，并且二者都保持子群包含关系。

# 自然语言 ↔ Lean 映射

- `H ∩ N` ↔ `N.subgroupOf H`；`HN` ↔ `H ⊔ N`（`N` 正规时）。
- `M/N` ↔ `M.map (QuotientGroup.mk' N)`。
- “包含 N 的子群” ↔ 子类型 `{H : Subgroup G // N ≤ H}`。
- “保序一一对应” ↔ `OrderIso`；群同构 ↔ `MulEquiv`。

# 依赖（人话版）

依赖群同态、正规子群、商群以及第一同构定理。实现层调用 mathlib 的三个规范构造，
但本条目补出了教材需要的代表元公式与正规性保持接口。

# 应用与陷阱

- 第二同构右端不是整个 `G/N`，而是 `HN/N`。
- 第三同构必须有 `N ≤ M`，否则 `M/N` 无法定义为预期的商子群。
- 对应定理是保序同构，不只是集合之间存在某个双射。
- `H ⊔ N` 是子群格的上确界；只有在正规性条件下才可直接按集合乘积 `HN` 理解。
