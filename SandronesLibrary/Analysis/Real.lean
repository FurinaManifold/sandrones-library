/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

/-!
# Analysis / Real —— 实数系基础条目

本文件当前条目：

* **analysis.real.archimedean**（阿基米德性质）：对任意正实数 x 与实数 y，
  存在自然数 n 使得 n·x > y。实数系是阿基米德序域的直接推论。
* **analysis.real.ordered-field**（实数是有序域）：`ℝ` 是线性有序环
  （`IsStrictOrderedRing ℝ`；mathlib 4.33 已把 `LinearOrderedField` 类拆分）。
* **analysis.real.bounded-sets.bdd-above**（有上界集）：`BddAbove s` ⟺
  存在上界 M 使得每个 x ∈ s 满足 x ≤ M。
* **analysis.real.bounded-sets.subset**（子集继承有界）：`s ⊆ t` 且 `t` 有上界
  ⇒ `s` 有上界。
* **analysis.real.density**（有理数稠密）：任意两个实数之间夹着一个有理数。
* **analysis.real.sup**（确界原理/完备性）：非空有上界集的上确界存在，
  且 `sSup s` 正是其最小上界。
-/

namespace SandronesLibrary

namespace Analysis.Real

/--
> **Entry**: analysis.real.archimedean
> **一句话**: 对任意正实数 x 与实数 y，存在自然数 n 使得 n·x > y。
> **直觉**: 把"步长 x"放大 n 倍能超过任何给定的 y；等价地，整数 n 能超过 y/x。
> **依赖**: 无（直接使用 mathlib 的 `exists_nat_gt`，即 `Archimedean ℝ` 实例）
> **mathlib**: `exists_nat_gt`, `div_lt_iff₀`
-/
theorem archimedean_property (x y : ℝ) (hx : 0 < x) : ∃ n : ℕ, y < n * x := by
  -- 思路：目标是"放大步长 x 超过 y"，化为"整数超过比值 y/x"，
  -- 由实数的阿基米德性（Archimedean 类型类）保证整数可以任意大。
  -- Step 1: 用 exists_nat_gt 选一个 n : ℕ 使得 y/x < n（choose 取 witness，choose_spec 是其性质）。
  let n := (exists_nat_gt (y / x)).choose
  use n
  -- Step 2: 回到原来的不等式：y/x < n 且 x > 0 ⇔ y < n·x（乘正数不改变序方向）。
  exact (div_lt_iff₀ hx).mp (exists_nat_gt (y / x)).choose_spec

/-- 由阿基米德性质直接推出 `exists_nat_gt` 的整数倍形式（供后续条目复用）。 -/
theorem exists_nat_mul_gt (x y : ℝ) (hx : 0 < x) : ∃ n : ℕ, y < n * x :=
  archimedean_property x y hx

/--
> **Entry**: analysis.real.ordered-field
> **一句话**: 实数构成一个线性有序环（Field + 全序 + 序与运算相容）。
> **直觉**: 实数里加、乘、序三套结构和谐共处——和教材说的"实数是有序域"是同一件事。
> **依赖**: 无
> **mathlib**: `IsStrictOrderedRing ℝ`, `Field ℝ`, `ConditionallyCompleteLinearOrder ℝ`
-/
theorem real_ordered_field : IsStrictOrderedRing ℝ := by
  -- 思路：mathlib 4.33 已把 `LinearOrderedField` 类拆散成若干可组合的类：
  --   `Field ℝ`（域）、`LinearOrder ℝ`（全序）、`IsStrictOrderedRing ℝ`（序环相容）、
  --   `ConditionallyCompleteLinearOrder ℝ`（条件完备，提供 sSup/sInf）。
  -- 这里确认核心的"序环相容"结构存在。
  infer_instance

/--
> **Entry**: analysis.real.bounded-sets.bdd-above
> **一句话**: "集合有上界" 的定义展开：存在实数 M 使每个元素都不超过 M。
> **直觉**: BddAbove 就是"把所有元素摁在某个天花板 M 下面"。
> **依赖**: 无
> **mathlib**: `BddAbove`
-/
theorem bdd_above_iff (s : Set ℝ) : BddAbove s ↔ ∃ M : ℝ, ∀ x ∈ s, x ≤ M := by
  -- 思路：BddAbove 在 mathlib 里就是 `∃ a, ∀ b ∈ s, b ≤ a`，逐字展开即得。
  rfl

/--
> **Entry**: analysis.real.bounded-sets.subset
> **一句话**: 有上界集的子集仍然有上界：`s ⊆ t` 且 `t` 有上界 ⇒ `s` 有上界。
> **直觉**: 天花板对更大的集合有效，当然对小集合也有效——同一个 M 继续用。
> **依赖**: `analysis.real.bounded-sets.bdd-above`
> **mathlib**: `BddAbove.mono`
-/
theorem bdd_above_subset {s t : Set ℝ} (hst : s ⊆ t) (ht : BddAbove t) : BddAbove s := by
  -- 思路：t 有上界 M，s 的每个元素都在 t 里，所以都不超过 M。
  exact BddAbove.mono hst ht

/--
> **Entry**: analysis.real.density
> **一句话**: 有理数在实数中稠密：任意两个实数之间存在有理数。
> **直觉**: 无论两个实数贴得多近，总能塞进一个有理数——有理数是实数的"可数骨架"。
> **依赖**: 无
> **mathlib**: `exists_rat_btwn`
-/
theorem rational_dense (x y : ℝ) (hxy : x < y) : ∃ q : ℚ, x < (q : ℝ) ∧ (q : ℝ) < y := by
  -- 思路：教材用阿基米德性质构造分母 n 再取分子；mathlib 的 `exists_rat_btwn`
  -- 已把这个构造打包成多态版本（任意阿基米德序域），直接引用。
  exact exists_rat_btwn hxy

/--
> **Entry**: analysis.real.sup
> **一句话**: 确界原理（完备性）：非空有上界集必有上确界，`sSup s` 即其最小上界。
> **直觉**: 实数是"不露缝"的——任何被压住不放手的集合，都会碰到天花板本身。
>   这是 ℚ 没有的性质（{q | q² < 2} 在 ℚ 里没有上确界）。
> **依赖**: `analysis.real.bounded-sets.bdd-above`
> **mathlib**: `Real.isLUB_sSup`
-/
theorem sup_lub (s : Set ℝ) (hne : s.Nonempty) (hbdd : BddAbove s) : IsLUB s (sSup s) := by
  -- 思路：sSup 是"条件完备格"提供的最小上界算子；`IsLUB s (sSup s)` 正是
  -- "sSup 是 s 的上界，且是最小的上界"。这正是教科书的确界原理。
  exact Real.isLUB_sSup hne hbdd

end Analysis.Real

end SandronesLibrary
