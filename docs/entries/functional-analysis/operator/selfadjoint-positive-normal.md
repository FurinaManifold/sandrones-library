---
id: functional-analysis.operator.selfadjoint-positive-normal
family: functional-analysis.operator
variant: selfadjoint-positive-normal
kind: theorem
state: staging
title: 有界自伴、正、正规与酉算子的关系
summary: 在完备内积空间上以 Mathlib 的 IsSelfAdjoint、ContinuousLinearMap.IsPositive、IsStarNormal 与 unitary 子群为正式承载，证明“正 ⟹ 自伴 ⟹ 正规”“酉 ⟹ 正规”以及幂等算子自伴当且仅当正规的关系链与各项展开刻画
premises: [functional-analysis.hilbert.adjoint, functional-analysis.hilbert.unitary]
mathlib: [IsSelfAdjoint, ContinuousLinearMap.IsPositive, IsStarNormal, unitary, ContinuousLinearMap.star_eq_adjoint, ContinuousLinearMap.isSelfAdjoint_iff_isSymmetric, ContinuousLinearMap.isPositive_iff', ContinuousLinearMap.isStarNormal_iff_norm_eq_adjoint, IsStarNormal.ker_adjoint_eq_ker, IsStarNormal.orthogonal_range, isStarNormal_of_mem_unitary, Unitary.star_eq_inv, Unitary.linearIsometryEquiv, IsIdempotentElem.isSelfAdjoint_iff_isStarNormal]
provenance:
  source_type: book
  ref: "buehler-salamon-functional-analysis-2018"
---

# 动机

Bühler–Salamon《Functional Analysis》第 5 章在 Hilbert 空间上同时使用四类有界算子：自伴算子、
正算子、正规算子与酉算子。紧自伴谱定理（本库 `functional-analysis.hilbert.compact-selfadjoint-spectral`）
只用到“自伴”这一条，但教材在进入谱理论前先刻画这些算子类之间的**蕴含关系**，因为后续的
谱映射、函数演算与投影值测度都要按算子类别分层陈述。本条目补齐这一层关系，并把每个算子类
落到 Mathlib 已经稳定的接口上，不重造平行的算子类结构。

# 教材定义与正式承载

设 `𝕜` 为 `RCLike`（`ℝ` 或 `ℂ`），`E` 为完备内积空间，研究 `E →L[𝕜] E` 上的有界算子。
Mathlib 在 `E →L[𝕜] E` 上以伴随为对合 `star`（`ContinuousLinearMap.star_eq_adjoint`：`star T = T†`），
四类算子的正式承载如下。

| 教材概念 | 教材定义（量词） | Lean 正式承载 | 类型类假设 | Mathlib 角色 |
|---|---|---|---|---|
| 自伴算子 | `T = T*` | `IsSelfAdjoint T`（即 `star T = T`） | `Star`；此处 `star = 伴随` | 语义一致的正式承载 |
| 正算子 | `T = T*` 且 `∀ x, ⟪T x, x⟫ ≥ 0` | `ContinuousLinearMap.IsPositive T` | `RCLike 𝕜`；`CompleteSpace E` 用于自伴等价 | 语义一致的正式承载 |
| 正规算子 | `T T* = T* T` | `IsStarNormal T`（`Commute (star T) T`） | `Mul`、`Star`；此处为算子复合与伴随 | 语义一致的正式承载 |
| 酉算子 | 等距满射 ⇔ `U* U = U U* = 1` | `unitary (E →L[𝕜] E)` 子群；与 `E ≃ₗᵢ[𝕜] E` 同构 | `Monoid`、`StarMul` | 语义一致的正式承载（代数侧） |
| 幂等算子 | `T² = T` | `IsIdempotentElem T` | `Mul` | 语义一致的正式承载 |

**与教材的差异与边界。** `ContinuousLinearMap.IsPositive` 的定义是“对称 + 二次型实部非负”
（`isPositive_def'`），在完备空间上与教材“自伴 + 二次型非负”等价（`isPositive_iff'`）；本条目采用
后者作为公开刻画。这里的“正”是赋范空间算子上的二次型非负性，不是一般 `CStarAlgebra` 中
`0 ≤ a` 的元素偏序；在 `E →L[𝕜] E` 上两者一致，但本条目只使用前者，不使用任何 C⋆-代数结构。
`unitary (E →L[𝕜] E)` 是代数子群，`Unitary.linearIsometryEquiv` 证明它与教材的“等距满射”
（`LinearIsometryEquiv`）是同一类算子；F3.5 的 `functional-analysis.hilbert.unitary` 已为该载体
建立教材解释，本条目只做连接，不重复定义。

# 陈述（自然语言）

- **自伴刻画**：`T` 自伴（`IsSelfAdjoint`，在 `E →L[𝕜] E` 上即 `T† = T`）当且仅当对任意
  `x, y` 都有 `⟪T x, y⟫ = ⟪x, T y⟫`。
- **正算子的等价刻画**：`T` 正，当且仅当 `T` 自伴且对每个 `x` 有 `⟪T x, x⟫ ≥ 0`。
- **关系链**：正算子必自伴；自伴算子必正规；正算子必正规。
- **正规刻画**：`T` 正规当且仅当 `T† T = T T†`，当且仅当对每个 `x` 有 `‖T x‖ = ‖T† x‖`。
  正规算子的核与 `T†` 的核相同，且其值域与核正交。
- **酉与正规**：`U` 酉则 `U` 正规；酉元素的伴随等于其群逆。
- **酉的等距性**：酉元素（`unitary` 子群）在 `E ≃ₗᵢ[𝕜] E` 的对应下保持内积与范数
  （Mathlib `Unitary.inner_map_map`／`Unitary.norm_map`，并由 F3.5 承载）。
- **自伴且酉**：若 `U` 同时自伴且酉，则 `U² = 1`。
- **幂等特例**：对幂等算子 `T`，`T` 自伴当且仅当 `T` 正规。

# 陈述（Lean 对照）

| 自然语言 | Lean 声明 |
|---|---|
| 自伴 ⇔ 内积可转移（承载即 `T† = T`） | `isSelfAdjoint_iff_inner_symm` |
| 正 ⇔ 自伴 + 二次型非负 | `isPositive_iff_selfAdjoint_inner_nonneg` |
| 正 ⟹ 自伴 | `positive_isSelfAdjoint` |
| 正规 ⇔ 与伴随可交换 | `isStarNormal_iff_adjoint_commute` |
| 正规 ⇔ `T` 与 `T†` 范数一致 | `isStarNormal_iff_norm_adjoint` |
| 正规 ⟹ 核与伴随核相同 | `isStarNormal_ker_adjoint` |
| 正规 ⟹ 值域正交于核 | `isStarNormal_range_orthogonal_ker` |
| 自伴 ⟹ 正规 | `selfAdjoint_isStarNormal` |
| 正 ⟹ 正规 | `positive_isStarNormal` |
| 幂等：自伴 ⇔ 正规 | `idempotent_selfAdjoint_iff_isStarNormal` |
| 酉 ⟹ 正规 | `unitary_isStarNormal` |
| 酉元素的伴随 = 逆 | `unitary_adjoint_eq_inv` |
| 自伴且酉 ⟹ `U² = 1` | `isSelfAdjoint_unitary_mul_self` |
| 线性等距等价是酉元素 | `linearIsometryEquiv_mem_unitary` |

酉元素的等距性没有另设本库定理：`unitary` 子群与 `E ≃ₗᵢ[𝕜] E` 的 `≃*` 对应由 Mathlib
`Unitary.linearIsometryEquiv` 给出，等距性由 `Unitary.inner_map_map`、`Unitary.norm_map`
承载；F3.5 的 `unitary_inner_map_map`、`unitary_norm_map` 已为 `LinearIsometryEquiv` 载体
建立了教材解释。

# 思维脉络

教材把四类算子并列，但证明依赖链是单向的：正算子的定义里含自伴，自伴算子与其伴随显然交换，
酉算子由 `U* U = 1` 立即得到 `U` 与 `U*` 交换。于是“正 ⟹ 自伴 ⟹ 正规”与“酉 ⟹ 正规”是两条
独立的入口，最终都落到正规算子这一层。正规算子的价值在于它**蕴含**核与伴随核一致
（`isStarNormal_ker_adjoint`）；对正规算子，值域的正交补恰是核（`isStarNormal_range_orthogonal_ker`），
这是后续谱测度与函数演算的共同起点。（反向不成立：核与伴随核一致并不推出正规；本条目只证蕴含。）

幂等情形是唯一的“反向”命题：一般地自伴比正规强，但对幂等算子两者等价
（`IsIdempotentElem.isSelfAdjoint_iff_isStarNormal`）。这正是正交投影与一般幂等投影的分界，
也是教材区分 `IsStarProjection` 与普通 `IsIdempotentElem` 的依据。

# 证明思路（教材语言）

- **自伴 ⇔ 伴随等于自身**：`IsSelfAdjoint T` 在 `E →L[𝕜] E` 上就是 `star T = T`，而
  `star T = T†`（`ContinuousLinearMap.star_eq_adjoint`），直接改写即得。
- **自伴 ⇔ 内积转移**：`ContinuousLinearMap.isSelfAdjoint_iff_isSymmetric` 把自伴性归约到
  `LinearMap.IsSymmetric`，后者逐字就是 `∀ x y, ⟪T x, y⟫ = ⟪x, T y⟫`。
- **正 ⇔ 自伴 + 非负**：`ContinuousLinearMap.isPositive_iff'` 把 `IsPositive` 展开为
  `IsSelfAdjoint ∧ ∀ x, 0 ≤ ⟪T x, x⟫`；对称性在完备内积空间上与自伴性一致，这一步不需要
  `IsPositive` 本身的定义展开。
- **正规 ⇔ 与伴随交换**：`isStarNormal_iff` 把 `IsStarNormal T` 写成 `Commute (star T) T`，
  再用 `star T = T†` 改写为 `T† T = T T†`；反向直接由交换性构造 `IsStarNormal`。
- **正规 ⇔ 范数一致**：Mathlib 已证 `ContinuousLinearMap.isStarNormal_iff_norm_eq_adjoint`
  （证明体经 `star T = T†` 把 `(T†T - TT†)` 的对称性与二次型联系，再由范数平方转写）。
- **核与值域**：`IsStarNormal.ker_adjoint_eq_ker` 由范数刻画逐点推出；
  `IsStarNormal.orthogonal_range` 把它与值域正交补相等组装起来。
- **酉 ⟹ 正规**：`isStarNormal_of_mem_unitary` 直接由 `U* U = U U* = 1` 得到交换性。
- **伴随 = 逆**：在 `unitary` 子群中 `star U = U⁻¹`（`Unitary.star_eq_inv`），再经
  `star = 伴随` 改写为 `U† = U⁻¹`；这里逆是群逆，其承载与 `U†` 相同。
- **等距性**：`Unitary.inner_map_map`、`Unitary.norm_map` 由 `unitary` 子群元素与
  `LinearIsometryEquiv` 的 `≃*` 对应（`Unitary.linearIsometryEquiv`）给出。
- **自伴且酉 ⟹ 对合**：酉给出 `U * U* = 1`，自伴给出 `U* = U`，代入即 `U * U = 1`。
- **幂等特例**：`IsIdempotentElem.isSelfAdjoint_iff_isStarNormal` 是 Mathlib 已有定理，
  本条目只做公开出口，不重证。

# 依赖

库内前提（`premises`）：

- `functional-analysis.hilbert.adjoint`：提供 `E →L[𝕜] E` 上伴随的教材解释与
  `star = 伴随` 的语境；本条目在其上用 Mathlib 的一般 `RCLike` 伴随接口。
- `functional-analysis.hilbert.unitary`：提供 `LinearIsometryEquiv` 作为酉算子的教材承载；
  `linearIsometryEquiv_mem_unitary` 显式连接该承载与 `unitary` 子群。

使用的 Mathlib 名称（本节已逐项说明角色）：`IsSelfAdjoint`、`ContinuousLinearMap.IsPositive`、
`IsStarNormal`、`unitary`、`ContinuousLinearMap.star_eq_adjoint`、
`ContinuousLinearMap.isSelfAdjoint_iff_isSymmetric`、`ContinuousLinearMap.isPositive_iff'`、
`ContinuousLinearMap.isStarNormal_iff_norm_eq_adjoint`、`IsStarNormal.ker_adjoint_eq_ker`、
`IsStarNormal.orthogonal_range`、`isStarNormal_of_mem_unitary`、`Unitary.star_eq_inv`、
`Unitary.linearIsometryEquiv`、`IsIdempotentElem.isSelfAdjoint_iff_isStarNormal`。其中前四者是
语义一致的正式公开承载；其余是复用的刻画与桥。本条目**没有**新增 `def` 或 `structure`。

# 诚实边界

本条目只处理**有界**算子，且要求 `CompleteSpace E`；不涉及无界算子（F7）、连续函数演算（F6.8）
或谱测度（F6.9）。正规算子的“核与伴随核一致”被证明，但本条目**没有**证明正规算子的谱定理或
正交对角化；连续函数演算与投影值测度仍按 ROADMAP 冻结。`IsPositive` 使用的是赋范算子上的
二次型非负性，未引入 C⋆-代数的元素偏序，故与 `CStarAlgebra` 的 `0 ≤ a` 的关系不在本条目范围。

本条目是随新模块提交的课程文档**初稿**，前端 matter 与八段结构由 Main 在集成时统一；它尚未
登记进 `index/registry.json`，`state` 记为 `staging`，不代表已进入 Main 教材或全局构建。
