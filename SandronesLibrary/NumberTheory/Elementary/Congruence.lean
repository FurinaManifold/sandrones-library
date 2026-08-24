/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.NumberTheory.Elementary.Divisibility
import Mathlib.Data.ZMod.Basic

/-!
# 同余、剩余环与中国剩余定理

本文件把自然数同余和剩余环中的相等连接起来，集中给出同余对加法、乘法、乘方的相容性，
并以“共同解存在”和“剩余环同构”两种形式陈述互素模数的中国剩余定理。
-/

namespace SandronesLibrary.NumberTheory.Elementary

/-- 自然数模 `n` 同余，当且仅当它们在剩余环 `ZMod n` 中表示同一个元素。
> **Entry**: number-theory.elementary.congruence
-/
theorem modEq_iff_zmod_eq (n a b : ℕ) :
    a ≡ b [MOD n] ↔ (a : ZMod n) = (b : ZMod n) := by
  exact (ZMod.natCast_eq_natCast_iff a b n).symm

/-- 同余关系同时保持加法、乘法和自然数次幂。
> **Entry**: number-theory.elementary.congruence
-/
theorem modEq_add_mul_pow {n a b c d k : ℕ} (hab : a ≡ b [MOD n])
    (hcd : c ≡ d [MOD n]) :
    a + c ≡ b + d [MOD n] ∧ a * c ≡ b * d [MOD n] ∧ a ^ k ≡ b ^ k [MOD n] := by
  exact ⟨hab.add hcd, hab.mul hcd, hab.pow k⟩

/-- **中国剩余定理（存在形式）**：互素模数下，任意两个指定余数有共同解。
> **Entry**: number-theory.elementary.chinese-remainder
-/
theorem chinese_remainder_exists {m n a b : ℕ} (h : m.Coprime n) :
    ∃ x : ℕ, x ≡ a [MOD m] ∧ x ≡ b [MOD n] := by
  exact ⟨Nat.chineseRemainder h a b, (Nat.chineseRemainder h a b).property⟩

/-- **中国剩余定理（结构形式）**：模 `mn` 的剩余环同构于模 `m`、模 `n` 剩余环的直积。
> **Entry**: number-theory.elementary.chinese-remainder
-/
noncomputable def chineseRemainderEquiv {m n : ℕ} (h : m.Coprime n) :
    ZMod (m * n) ≃+* ZMod m × ZMod n :=
  ZMod.chineseRemainder h

end SandronesLibrary.NumberTheory.Elementary
