/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.NumberTheory.Elementary.Divisibility
import Mathlib.Data.Nat.Factorization.Basic

/-!
# 算术基本定理

自然数 `n` 的 `factorization` 记录每个素数在 `n` 中的指数。本文件给出算术基本定理的
两个教材式接口：素因子幂的乘积重构原数，以及非零自然数由全部素因子指数唯一决定。
-/

namespace SandronesLibrary.NumberTheory.Elementary

/-- **素因子分解的存在性（重构形式）**：非零自然数等于其所有素因子幂之积。
> **Entry**: number-theory.elementary.prime-factorization
-/
theorem prime_factorization_reconstructs {n : ℕ} (hn : n ≠ 0) :
    n.factorization.prod (fun p e ↦ p ^ e) = n := by
  exact Nat.prod_factorization_pow_eq_self hn

/-- **素因子分解的唯一性**：两个非零自然数若每个素因子的指数都相同，则两数相等。
> **Entry**: number-theory.elementary.prime-factorization
-/
theorem eq_of_prime_factorization_eq {m n : ℕ} (hm : m ≠ 0) (hn : n ≠ 0)
    (h : ∀ p : ℕ, m.factorization p = n.factorization p) : m = n := by
  exact Nat.eq_of_factorization_eq hm hn h

end SandronesLibrary.NumberTheory.Elementary
