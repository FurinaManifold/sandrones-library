---
id: abstract-algebra.group.sylow
kind: theorem
state: verified
title: "p 群、Sylow 子群定义与 Sylow 三定理"
summary: 自建 p 群与 Sylow 子群定义，以及 Cauchy 定理、Sylow 三定理、正规性判据和低阶群应用
premises: ["abstract-algebra.group.permutation"]
mathlib: ["IsPGroup", "Sylow", "exists_prime_orderOf_dvd_card'", "IsPGroup.exists_le_sylow", "Sylow.card_eq_multiplicity", "Sylow.isPretransitive_of_finite", "card_sylow_modEq_one", "Sylow.card_dvd_index"]
provenance:
  source_type: book
  ref: "Rotman, An Introduction to the Theory of Groups（Sylow 理论）"
---

# 定义

本库不把 Mathlib 的 `IsPGroup` 或 `Sylow` 当作公开教材概念。`IsPrimePowerGroup p G`
直接定义为：对每个 `g : G`，存在自然数 `k` 使 `g ^ (p ^ k) = 1`。当 `p` 为素数时，
这等价于每个元素的阶都是 `p` 的幂。

对子群 `P ≤ G`，`IsSylowSubgroup p P` 定义为两个条件：`P` 是 `p`-群；并且任何包含
`P` 的 `p`-子群 `Q` 都只能等于 `P`。因此 Sylow 子群就是关于包含关系极大的 `p`-子群。
`SylowSubgroup p G` 是所有满足这个谓词的普通子群组成的子类型。

# 动机

Lagrange 定理只说明子群阶必须整除群阶；Cauchy 与 Sylow 理论给出部分逆向结论，
把群阶的素因子和素数幂因子实现为元素阶与子群阶，并约束这些子群的相对位置和数量。

# 直觉

Sylow `p`-子群收集群阶中全部可用的 `p` 因子。它们可能不唯一，但彼此仅相差共轭；
其个数同时受整除条件和模 `p` 同余条件约束，常被迫等于一，从而产生正规子群。

# 陈述（自然语言）

Cauchy 定理给出阶为 `p` 的元素。每个 `p`-子群包含在 Sylow `p`-子群中，后者阶为
`p^{v_p(|G|)}`。所有 Sylow `p`-子群共轭；其个数 `nₚ` 整除指数且模 `p` 余一。
Sylow 子群唯一当且仅当正规。作为低阶应用，`p²` 阶群必交换。

# 陈述（Lean 对照）

`IsPrimePowerGroup`、`IsSylowSubgroup`、`SylowSubgroup`、
`isPrimePowerGroup_iff_mathlib`、`cauchy_theorem`、`sylow_exists`、
`pSubgroup_le_sylow`、`sylow_card`、
`sylow_conjugate`、`sylow_number_mod_prime`、`sylow_number_dvd_index`、
`sylow_normal_of_unique`、`sylow_unique_of_normal`、`prime_square_group_commutative`。

# 思维脉络（thinking trace）

Cauchy 定理先提供素数阶循环子群；极大化 `p`-子群得到 Sylow 子群。群以共轭作用在
Sylow 子群集合上，轨道—稳定子与 `p`-群不动点计数分别导出共轭性、整除和同余条件。

# 自然语言 ↔ Lean 映射

- `p`-群 ↔ `IsPrimePowerGroup p G`。
- `P` 是 Sylow `p`-子群 ↔ `IsSylowSubgroup p P`。
- 所有 Sylow `p`-子群组成的类型 ↔ `SylowSubgroup p G`。
- `v_p(|G|)` ↔ `(Nat.card G).factorization p`。
- Sylow 子群个数 `nₚ` ↔ `Nat.card (SylowSubgroup p G)`。
- `nₚ ≡ 1 (mod p)` ↔ `Nat.ModEq p nₚ 1`。

# 依赖（人话版）

依赖 Lagrange、元素阶、群作用、轨道—稳定子定理、共轭作用和有限基数算术。

# 应用与陷阱

- `P : SylowSubgroup p G` 的底层普通子群是 `P.1`，其 Sylow 性质证明是 `P.2`。
- Mathlib 的 `IsPGroup`、`Sylow` 只出现在私有表示桥与证明体中，不出现在公开主定理签名中。
- “所有 Sylow 子群共轭”不等于“它们都正规”；正规恰对应共轭轨道只有一个点。
- 第三定理必须同时使用整除与同余两个条件，仅凭其中一个通常不能确定 `nₚ`。
- `p²` 阶群交换，但不一定循环，例如 `C_p × C_p`。
