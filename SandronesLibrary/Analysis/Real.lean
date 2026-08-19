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

end Analysis.Real

end SandronesLibrary
