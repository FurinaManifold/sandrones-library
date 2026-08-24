/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.NumberTheory.Elementary.Congruence
import Mathlib.Data.Nat.Totient
import Mathlib.NumberTheory.PowModTotient

/-!
# Euler φ 函数与 Fermat–Euler 定理

Euler φ 函数计数模 `n` 的可逆剩余类。由有限单位群中元素的幂性质得到 Euler 定理，
再把模数专门化为素数，依次推出 Fermat 小定理的既约形式与无条件形式。
-/

namespace SandronesLibrary.NumberTheory.Elementary

/-- `φ(n)` 等于剩余环 `ZMod n` 的单位数。
> **Entry**: number-theory.elementary.totient
-/
theorem reduced_residue_card (n : ℕ) [NeZero n] :
    Fintype.card (ZMod n)ˣ = n.totient := by
  exact ZMod.card_units_eq_totient n

/-- **Euler 定理**：若 `a,n` 互素，则 `a ^ φ(n) ≡ 1 (mod n)`。
> **Entry**: number-theory.elementary.fermat-euler
-/
theorem euler_theorem {a n : ℕ} (h : a.Coprime n) :
    a ^ n.totient ≡ 1 [MOD n] := by
  exact Nat.ModEq.pow_totient h

/-- **Fermat 小定理（既约形式）**：素数 `p` 不整除 `a` 时，`a^(p-1) ≡ 1 (mod p)`。
> **Entry**: number-theory.elementary.fermat-euler
-/
theorem fermat_little_theorem_of_not_dvd {a p : ℕ} (hp : p.Prime) (hpa : ¬p ∣ a) :
    a ^ (p - 1) ≡ 1 [MOD p] := by
  have hcop : a.Coprime p := Nat.coprime_comm.mp (hp.coprime_iff_not_dvd.mpr hpa)
  simpa [Nat.totient_prime hp] using euler_theorem hcop

/-- **Fermat 小定理（无条件形式）**：对任意自然数 `a`，都有 `a^p ≡ a (mod p)`。
> **Entry**: number-theory.elementary.fermat-euler
-/
theorem fermat_little_theorem (a : ℕ) {p : ℕ} (hp : p.Prime) :
    a ^ p ≡ a [MOD p] := by
  by_cases hpa : p ∣ a
  · have ha0 : a ≡ 0 [MOD p] := Nat.modEq_zero_iff_dvd.mpr hpa
    have h0a : 0 ^ p ≡ a [MOD p] := by
      simpa [zero_pow hp.ne_zero] using ha0.symm
    exact (ha0.pow p).trans h0a
  · have h := (fermat_little_theorem_of_not_dvd hp hpa).mul_right a
    simpa [← pow_succ, Nat.sub_add_cancel hp.one_le] using h

end SandronesLibrary.NumberTheory.Elementary
