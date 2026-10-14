/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.SetTheory.HydraOrdinalAssignment
import SandronesLibrary.SetTheory.OrdinalPowerBridge
import Mathlib.SetTheory.Ordinal.CantorNormalForm

/-!
# SetTheory / HydraGeneralDescent —— 一般 Hydra 单步的序数下降

既有的 Hydra 下降链（`HydraOneLevelDescent` → `HydraSiblingDescent` →
`HydraParentSiblingDescent` → `HydraRightmostSpineDescent`）都只在「被砍的父分支在每一层都是最右孩子」
这一族证书上成立。本文件去掉这条限制：对**任意**合法 `Hydra.Step`（任意深度、头在其父内的任意位置、
任意左兄弟森林、任意阶段复制），结构序数赋值都严格下降。

关键在于换一个序数赋值。列表序求和 `forestOrdinal` 会让「头」的贡献 `ω^0 = 1` 被右侧无穷序数的后缀吸收，
所以一般位置砍头时它并不下降（本库旧赋值因此只能覆盖最右分支）。本文件改用**自然和**
（Hessenberg 和，`ordNadd`）：逐项系数相加的序数加法，它在每个自变量上严格单调，于是头项永远不被吸收。
mathlib 目前没有 `nadd`，因此这里用 `Ordinal.CNF.coeff`/`Ordinal.CNF.eval` 直接定义并证明所需的代数性质。

本文件**不**声称 Hydra 游戏终止（那需要把严格下降接到良基归纳上），也**不**改动任何已集成的
Goodstein／Hydra 状态文件；新增能力只在本文件内。
-/

namespace SandronesLibrary.SetTheory.HydraGeneralDescent

open SandronesLibrary.SetTheory
open SandronesLibrary.SetTheory.Ordinal
open SandronesLibrary.SetTheory.HydraOrdinalAssignment

universe u

noncomputable section

/-! ## 自然和（Hessenberg 和） -/

private theorem coeff_omega_lt (o e : Ordinal) :
    Ordinal.CNF.coeff Ordinal.omega0 o e < Ordinal.omega0 := by
  by_cases h : e ∈ List.map Prod.fst (Ordinal.CNF Ordinal.omega0 o)
  · obtain ⟨⟨e', c⟩, hc, he'⟩ := List.mem_map.mp h
    subst he'
    rw [Ordinal.CNF.coeff_of_mem_CNF hc]
    exact Ordinal.CNF.snd_lt Ordinal.one_lt_omega0 hc
  · rw [Ordinal.CNF.coeff_of_notMem_CNF h]
    exact Ordinal.omega0_pos

private theorem add_lt_omega0 {a b : Ordinal} (ha : a < Ordinal.omega0)
    (hb : b < Ordinal.omega0) : a + b < Ordinal.omega0 := by
  obtain ⟨m, rfl⟩ := Ordinal.lt_omega0.mp ha
  obtain ⟨n, rfl⟩ := Ordinal.lt_omega0.mp hb
  rw [← Nat.cast_add]
  exact Ordinal.natCast_lt_omega0 (m + n)

/-- 序数的自然和（Hessenberg 和）：把两个序数的 Cantor 正规形系数逐项相加再求值。
它与普通序数加法不同，在每个自变量上严格单调，因此有限个 `ω`—幂项相加时不会互相吸收。
mathlib 目前没有 `nadd`，本定义用 `Ordinal.CNF.coeff` 的逐点加法给出，`Ordinal.CNF` 在此只是定义机制。 -/
def ordNadd (a b : Ordinal) : Ordinal :=
  Ordinal.CNF.eval Ordinal.omega0
    (Ordinal.CNF.coeff Ordinal.omega0 a + Ordinal.CNF.coeff Ordinal.omega0 b)

/-- Pointwise split of an ordinal-valued finitely supported function.  The
mathlib lemma `Finsupp.filter_add_filter_not` needs commutative coefficients, so
we prove the version for `Ordinal` coefficients directly. -/
private theorem filter_add_filter_not_eq (f : Ordinal →₀ Ordinal) (p : Ordinal → Prop)
    [DecidablePred p] :
    Finsupp.filter p f + Finsupp.filter (fun x => ¬ p x) f = f := by
  ext e
  rw [Finsupp.add_apply, Finsupp.filter_apply, Finsupp.filter_apply]
  by_cases h : p e
  · rw [if_pos h]
    simp [h]
  · rw [if_neg h]
    simp [h]

/-- 自然和的右零元。 -/
theorem ordNadd_zero_right (a : Ordinal) : ordNadd a 0 = a := by
  rw [ordNadd, Ordinal.CNF.coeff_zero_right, add_zero, Ordinal.CNF.eval_coeff]

/-- 自然和的左零元。 -/
theorem ordNadd_zero_left (b : Ordinal) : ordNadd 0 b = b := by
  rw [ordNadd, Ordinal.CNF.coeff_zero_right, zero_add, Ordinal.CNF.eval_coeff]

/-- 自然和可交换：系数都是有限序数，逐点转成自然数加法后交换。 -/
theorem ordNadd_comm (a b : Ordinal) : ordNadd a b = ordNadd b a := by
  have h : Ordinal.CNF.coeff Ordinal.omega0 a + Ordinal.CNF.coeff Ordinal.omega0 b =
      Ordinal.CNF.coeff Ordinal.omega0 b + Ordinal.CNF.coeff Ordinal.omega0 a := by
    ext e
    rw [Finsupp.add_apply, Finsupp.add_apply]
    obtain ⟨m, hm⟩ := Ordinal.lt_omega0.mp (coeff_omega_lt a e)
    obtain ⟨n, hn⟩ := Ordinal.lt_omega0.mp (coeff_omega_lt b e)
    rw [hm, hn, ← Nat.cast_add, ← Nat.cast_add, Nat.add_comm]
  rw [ordNadd, ordNadd, h]

/-- 自然和可结合。 -/
theorem ordNadd_assoc (a b c : Ordinal) :
    ordNadd (ordNadd a b) c = ordNadd a (ordNadd b c) := by
  have h₁ : Ordinal.CNF.coeff Ordinal.omega0 (ordNadd a b) =
      Ordinal.CNF.coeff Ordinal.omega0 a + Ordinal.CNF.coeff Ordinal.omega0 b := by
    rw [ordNadd, Ordinal.CNF.coeff_eval Ordinal.one_lt_omega0
      (fun e => add_lt_omega0 (coeff_omega_lt a e) (coeff_omega_lt b e))]
  have h₂ : Ordinal.CNF.coeff Ordinal.omega0 (ordNadd b c) =
      Ordinal.CNF.coeff Ordinal.omega0 b + Ordinal.CNF.coeff Ordinal.omega0 c := by
    rw [ordNadd, Ordinal.CNF.coeff_eval Ordinal.one_lt_omega0
      (fun e => add_lt_omega0 (coeff_omega_lt b e) (coeff_omega_lt c e))]
  change Ordinal.CNF.eval Ordinal.omega0
      (Ordinal.CNF.coeff Ordinal.omega0 (ordNadd a b) + Ordinal.CNF.coeff Ordinal.omega0 c) =
    Ordinal.CNF.eval Ordinal.omega0
      (Ordinal.CNF.coeff Ordinal.omega0 a + Ordinal.CNF.coeff Ordinal.omega0 (ordNadd b c))
  rw [h₁, h₂, add_assoc]

/-! ### Splitting a coefficient function at one exponent -/

private def abovePart (e : Ordinal) (f : Ordinal →₀ Ordinal) : Ordinal →₀ Ordinal :=
  Finsupp.filter (fun e' => e < e') f

private def negAbovePart (e : Ordinal) (f : Ordinal →₀ Ordinal) : Ordinal →₀ Ordinal :=
  Finsupp.filter (fun e' => ¬ e < e') f

private def atPart (e : Ordinal) (f : Ordinal →₀ Ordinal) : Ordinal →₀ Ordinal :=
  Finsupp.filter (fun e' => e' = e) (negAbovePart e f)

private def belowPart (e : Ordinal) (f : Ordinal →₀ Ordinal) : Ordinal →₀ Ordinal :=
  Finsupp.filter (fun e' => ¬ e' = e) (negAbovePart e f)

private theorem mem_abovePart {e e' : Ordinal} {f : Ordinal →₀ Ordinal}
    (h : e' ∈ (abovePart e f).support) : e < e' := by
  rw [abovePart, Finsupp.support_filter, Finset.mem_filter] at h
  exact h.2

private theorem mem_negAbovePart {e e' : Ordinal} {f : Ordinal →₀ Ordinal}
    (h : e' ∈ (negAbovePart e f).support) : e' ≤ e := by
  rw [negAbovePart, Finsupp.support_filter, Finset.mem_filter] at h
  exact not_lt.mp h.2

private theorem mem_atPart {e e' : Ordinal} {f : Ordinal →₀ Ordinal}
    (h : e' ∈ (atPart e f).support) : e' = e := by
  rw [atPart, Finsupp.support_filter, Finset.mem_filter] at h
  exact h.2

private theorem mem_belowPart {e e' : Ordinal} {f : Ordinal →₀ Ordinal}
    (h : e' ∈ (belowPart e f).support) : e' < e := by
  rw [belowPart, Finsupp.support_filter, Finset.mem_filter] at h
  exact lt_of_le_of_ne (mem_negAbovePart h.1) h.2

private theorem atPart_eq_single (e : Ordinal) (f : Ordinal →₀ Ordinal) :
    atPart e f = Finsupp.single e (f e) := by
  ext e'
  rw [atPart, Finsupp.filter_apply]
  by_cases h : e' = e
  · rw [h, if_pos rfl, Finsupp.single_eq_same, negAbovePart, Finsupp.filter_apply,
      if_pos (lt_irrefl e)]
  · rw [if_neg h, Finsupp.single_eq_of_ne h]

private theorem abovePart_congr {f g : Ordinal →₀ Ordinal} {e : Ordinal}
    (h : ∀ e', e < e' → f e' = g e') : abovePart e f = abovePart e g := by
  ext e'
  rw [abovePart, abovePart, Finsupp.filter_apply, Finsupp.filter_apply]
  by_cases he : e < e'
  · rw [if_pos he, if_pos he, h e' he]
  · rw [if_neg he, if_neg he]

private theorem eval_belowPart_lt {f : Ordinal →₀ Ordinal}
    (hf : ∀ e, f e < Ordinal.omega0) (e : Ordinal) :
    Ordinal.CNF.eval Ordinal.omega0 (belowPart e f) < Ordinal.omega0 ^ e := by
  apply Ordinal.CNF.eval_lt
  · intro e'
    by_cases h : e' ∈ (belowPart e f).support
    · have hmem := h
      rw [belowPart, Finsupp.support_filter, Finset.mem_filter] at hmem
      rw [belowPart, Finsupp.filter_apply, if_pos hmem.2, negAbovePart,
        Finsupp.filter_apply, if_pos (not_lt.mpr (mem_negAbovePart hmem.1))]
      exact hf e'
    · rw [Finsupp.notMem_support_iff.mp h]
      exact Ordinal.omega0_pos
  · intro e' h'
    exact mem_belowPart h'

private theorem eval_eq_above_add_at_add_below {f : Ordinal →₀ Ordinal}
    (e : Ordinal) :
    Ordinal.CNF.eval Ordinal.omega0 f =
      Ordinal.CNF.eval Ordinal.omega0 (abovePart e f) +
        (Ordinal.omega0 ^ e * f e + Ordinal.CNF.eval Ordinal.omega0 (belowPart e f)) := by
  have hsplit : abovePart e f + negAbovePart e f = f := by
    rw [abovePart, negAbovePart]
    exact filter_add_filter_not_eq f (fun e' => e < e')
  have hsplit₂ : atPart e f + belowPart e f = negAbovePart e f := by
    rw [atPart, belowPart, negAbovePart]
    exact filter_add_filter_not_eq (negAbovePart e f) (fun e' => e' = e)
  have h₁ : Ordinal.CNF.eval Ordinal.omega0 f =
      Ordinal.CNF.eval Ordinal.omega0 (abovePart e f) +
        Ordinal.CNF.eval Ordinal.omega0 (negAbovePart e f) := by
    conv_lhs => rw [← hsplit]
    rw [Ordinal.CNF.eval_add]
    intro e₁ h₁ e₂ h₂
    exact le_trans (mem_negAbovePart h₂) (mem_abovePart h₁).le
  have h₂ : Ordinal.CNF.eval Ordinal.omega0 (negAbovePart e f) =
      Ordinal.CNF.eval Ordinal.omega0 (atPart e f) +
        Ordinal.CNF.eval Ordinal.omega0 (belowPart e f) := by
    conv_lhs => rw [← hsplit₂]
    rw [Ordinal.CNF.eval_add]
    intro e₁ h₁ e₂ h₂
    rw [mem_atPart h₁]
    exact (mem_belowPart h₂).le
  rw [h₁, h₂, atPart_eq_single, Ordinal.CNF.eval_single]

private theorem eval_lt_eval_of_agree_above {f g : Ordinal →₀ Ordinal}
    (hf : ∀ e, f e < Ordinal.omega0) (_hg : ∀ e, g e < Ordinal.omega0)
    {e : Ordinal} (he : ∀ e', e < e' → f e' = g e') (hlt : f e < g e) :
    Ordinal.CNF.eval Ordinal.omega0 f < Ordinal.CNF.eval Ordinal.omega0 g := by
  have hf' := eval_eq_above_add_at_add_below (f := f) e
  have hg' := eval_eq_above_add_at_add_below (f := g) e
  rw [hf', hg', abovePart_congr he]
  refine (add_lt_add_iff_left _).2 ?_
  calc Ordinal.omega0 ^ e * f e + Ordinal.CNF.eval Ordinal.omega0 (belowPart e f)
      < Ordinal.omega0 ^ e * f e + Ordinal.omega0 ^ e :=
        add_lt_add_right (eval_belowPart_lt hf e) _
    _ = Ordinal.omega0 ^ e * (f e + 1) := by rw [mul_add, mul_one]
    _ ≤ Ordinal.omega0 ^ e * g e := by
        apply mul_le_mul_right
        rw [← Order.succ_eq_add_one]
        exact Order.succ_le_iff.mpr hlt
    _ ≤ Ordinal.omega0 ^ e * g e + Ordinal.CNF.eval Ordinal.omega0 (belowPart e g) :=
        le_self_add

private theorem eval_injective {f g : Ordinal →₀ Ordinal}
    (hf : ∀ e, f e < Ordinal.omega0) (hg : ∀ e, g e < Ordinal.omega0)
    (h : Ordinal.CNF.eval Ordinal.omega0 f = Ordinal.CNF.eval Ordinal.omega0 g) : f = g := by
  rw [← Ordinal.CNF.coeff_eval Ordinal.one_lt_omega0 hf, h,
    Ordinal.CNF.coeff_eval Ordinal.one_lt_omega0 hg]

private theorem exists_agree_above_of_ne {f g : Ordinal →₀ Ordinal} (h : f ≠ g) :
    ∃ e, (∀ e', e < e' → f e' = g e') ∧ f e ≠ g e := by
  classical
  set s : Finset Ordinal := (f.support ∪ g.support).filter (fun e => f e ≠ g e) with hs_def
  have hs : s.Nonempty := by
    rw [Finset.nonempty_iff_ne_empty]
    intro hempty
    rw [hs_def] at hempty
    apply h
    ext e
    by_cases he : e ∈ f.support ∪ g.support
    · by_cases hdiff : f e = g e
      · exact hdiff
      · exact absurd (Finset.mem_filter.mpr ⟨he, hdiff⟩)
          (by rw [hempty]; exact Finset.notMem_empty e)
    · rw [Finset.notMem_union] at he
      rw [Finsupp.notMem_support_iff.mp he.1, Finsupp.notMem_support_iff.mp he.2]
  refine ⟨s.max' hs, ?_, ?_⟩
  · intro e' he'
    by_contra hdiff
    have hmem : e' ∈ s := by
      rw [hs_def]
      refine Finset.mem_filter.mpr ⟨?_, hdiff⟩
      by_cases hf : f e' = 0
      · rw [hf] at hdiff
        exact Finset.mem_union.mpr (Or.inr (Finsupp.mem_support_iff.mpr (Ne.symm hdiff)))
      · exact Finset.mem_union.mpr (Or.inl (Finsupp.mem_support_iff.mpr hf))
    exact absurd (Finset.le_max' s e' hmem) (not_le.mpr he')
  · have hmax := Finset.max'_mem s hs
    change s.max' hs ∈ (f.support ∪ g.support).filter (fun e => f e ≠ g e) at hmax
    exact (Finset.mem_filter.mp hmax).2

/-- 自然和在第二个自变量上严格单调（固定第一个自变量）。 -/
theorem ordNadd_lt_ordNadd_right {a b c : Ordinal} (h : a < b) :
    ordNadd c a < ordNadd c b := by
  have hne : Ordinal.CNF.coeff Ordinal.omega0 a ≠ Ordinal.CNF.coeff Ordinal.omega0 b := by
    intro heq
    have hEq : a = b := by
      have := congrArg (Ordinal.CNF.eval Ordinal.omega0) heq
      rwa [Ordinal.CNF.eval_coeff, Ordinal.CNF.eval_coeff] at this
    exact absurd hEq h.ne
  obtain ⟨e, he, hdiff⟩ := exists_agree_above_of_ne hne
  have hlt' : Ordinal.CNF.coeff Ordinal.omega0 a e < Ordinal.CNF.coeff Ordinal.omega0 b e := by
    rcases lt_or_gt_of_ne hdiff with h' | h'
    · exact h'
    · have hcontra := eval_lt_eval_of_agree_above (coeff_omega_lt b) (coeff_omega_lt a)
        (fun e' hh => (he e' hh).symm) h'
      rw [Ordinal.CNF.eval_coeff, Ordinal.CNF.eval_coeff] at hcontra
      exact absurd hcontra (not_lt.mpr h.le)
  rw [ordNadd, ordNadd]
  refine eval_lt_eval_of_agree_above (e := e) ?_ ?_ ?_ ?_
  · intro e'
    exact add_lt_omega0 (coeff_omega_lt c e') (coeff_omega_lt a e')
  · intro e'
    exact add_lt_omega0 (coeff_omega_lt c e') (coeff_omega_lt b e')
  · intro e' he'
    rw [Finsupp.add_apply, Finsupp.add_apply, he e' he']
  · rw [Finsupp.add_apply, Finsupp.add_apply]
    exact add_lt_add_right hlt' _

/-- 自然和在第一个自变量上严格单调（固定第二个自变量）。 -/
theorem ordNadd_lt_ordNadd_left {a b c : Ordinal} (h : a < b) :
    ordNadd a c < ordNadd b c := by
  rw [ordNadd_comm a c, ordNadd_comm b c]
  exact ordNadd_lt_ordNadd_right h

private theorem coeff_omega_one :
    Ordinal.CNF.coeff Ordinal.omega0 (1 : Ordinal) = Finsupp.single 0 1 := by
  have h := Ordinal.CNF.coeff_eval Ordinal.one_lt_omega0 (b := Ordinal.omega0)
    (f := Finsupp.single (0 : Ordinal) (1 : Ordinal)) (by
      intro e
      by_cases h : e = 0
      · subst h
        rw [Finsupp.single_eq_same]
        exact Ordinal.one_lt_omega0
      · rw [Finsupp.single_eq_of_ne h]
        exact Ordinal.omega0_pos)
  rwa [Ordinal.CNF.eval_single, Ordinal.opow_zero, one_mul] at h

/-- 自然和加一：`ordNadd a 1 = a + 1`，因为系数 `0` 是最小指数，`1` 永远排在末尾。 -/
theorem ordNadd_one (a : Ordinal) : ordNadd a 1 = a + 1 := by
  rw [ordNadd, coeff_omega_one, Ordinal.CNF.eval_add]
  · rw [Ordinal.CNF.eval_coeff, Ordinal.CNF.eval_single, Ordinal.opow_zero, one_mul]
  · intro e₁ _ e₂ he₂
    have hmem : (Finsupp.single (0 : Ordinal) (1 : Ordinal)) e₂ ≠ 0 :=
      Finsupp.mem_support_iff.mp he₂
    have hzero : e₂ = 0 := by
      by_contra h
      exact hmem (Finsupp.single_eq_of_ne h)
    subst hzero
    exact zero_le

private theorem coeff_omega_opow_mul (β : Ordinal) (n : ℕ) :
    Ordinal.CNF.coeff Ordinal.omega0 (Ordinal.omega0 ^ β * (n : Ordinal)) =
      Finsupp.single β (n : Ordinal) := by
  rcases Nat.eq_zero_or_pos n with hn | hn
  · subst hn
    rw [Nat.cast_zero, mul_zero, Ordinal.CNF.coeff_zero_right,
      Finsupp.single_eq_zero.mpr rfl]
  · have hn' : (n : Ordinal) ≠ 0 := by
      exact_mod_cast Nat.pos_iff_ne_zero.mp hn
    have hlt : (n : Ordinal) < Ordinal.omega0 := Ordinal.natCast_lt_omega0 n
    have h := Ordinal.CNF.coeff_opow_mul_add (b := Ordinal.omega0) (e := β)
      (x := (n : Ordinal)) (y := 0) Ordinal.one_lt_omega0 hn' hlt
      (Ordinal.opow_pos β Ordinal.omega0_pos)
    rwa [add_zero, Ordinal.CNF.coeff_zero_right, add_zero] at h



private theorem ordNadd_opow_mul (β : Ordinal) (m n : ℕ) :
    ordNadd (Ordinal.omega0 ^ β * (m : Ordinal)) (Ordinal.omega0 ^ β * (n : Ordinal)) =
      Ordinal.omega0 ^ β * ((m + n : ℕ) : Ordinal) := by
  rw [ordNadd, coeff_omega_opow_mul, coeff_omega_opow_mul, ← Finsupp.single_add,
    ← Nat.cast_add, Ordinal.CNF.eval_single]


private theorem ordNadd_opow_mul_succ (β : Ordinal) (n : ℕ) :
    ordNadd (Ordinal.omega0 ^ β) (Ordinal.omega0 ^ β * (n : Ordinal)) =
      Ordinal.omega0 ^ β * ((n + 1 : ℕ) : Ordinal) := by
  have h := ordNadd_opow_mul β n 1
  rw [Nat.cast_one, mul_one] at h
  rw [← h]
  exact ordNadd_comm _ _

/-! ## 一般序数度量与主定理 -/

mutual
  /-- 一般 Hydra 序数赋值：一个节点的值是其子森林的自然和赋值。 -/
  noncomputable def hydraGeneralOrdinal : Hydra → Ordinal.{u}
    | .node children => forestGeneralOrdinal children

  /-- 有序森林的赋值：子节点贡献 `ω^(子节点值)`，用自然和累加。 -/
  noncomputable def forestGeneralOrdinal : List Hydra → Ordinal.{u}
    | [] => 0
    | child :: rest =>
        ordNadd (ordinalPow Ordinal.omega0 (hydraGeneralOrdinal child))
          (forestGeneralOrdinal rest)
end

@[simp] theorem hydraGeneralOrdinal_node (children : List Hydra) :
    hydraGeneralOrdinal.{u} (.node children) = forestGeneralOrdinal.{u} children := rfl

@[simp] theorem forestGeneralOrdinal_cons (child : Hydra) (rest : List Hydra) :
    forestGeneralOrdinal.{u} (child :: rest) =
      ordNadd (ordinalPow Ordinal.omega0 (hydraGeneralOrdinal.{u} child))
        (forestGeneralOrdinal.{u} rest) := rfl

@[simp] theorem forestGeneralOrdinal_nil : forestGeneralOrdinal.{u} [] = 0 := rfl

@[simp] theorem hydraGeneralOrdinal_head : hydraGeneralOrdinal.{u} Hydra.head = 0 := rfl

theorem forestGeneralOrdinal_append (l₁ l₂ : List Hydra) :
    forestGeneralOrdinal.{u} (l₁ ++ l₂) =
      ordNadd (forestGeneralOrdinal.{u} l₁) (forestGeneralOrdinal.{u} l₂) := by
  induction l₁ with
  | nil => rw [List.nil_append]; exact (ordNadd_zero_left _).symm
  | cons c l₁ ih =>
      rw [List.cons_append, forestGeneralOrdinal_cons, ih, forestGeneralOrdinal_cons,
        ← ordNadd_assoc]

theorem forestGeneralOrdinal_replicate (n : Nat) (x : Hydra) :
    forestGeneralOrdinal.{u} (List.replicate n x) =
      ordinalPow Ordinal.omega0 (hydraGeneralOrdinal.{u} x) * (n : Ordinal.{u}) := by
  induction n with
  | zero => rw [List.replicate_zero]; exact (mul_zero _).symm
  | succ n ih =>
      rw [List.replicate_succ, forestGeneralOrdinal_cons, ih, ordinalPow_eq_opow,
        ordNadd_opow_mul_succ]

/-- A strict decrease of one child strictly decreases the forest measure, at an
arbitrary position and with arbitrary left and right sibling forests. -/
theorem forestGeneralOrdinal_lt_of_child_lt {p q : Hydra} (L R : List Hydra)
    (h : hydraGeneralOrdinal.{u} q < hydraGeneralOrdinal.{u} p) :
    forestGeneralOrdinal.{u} (L ++ q :: R) < forestGeneralOrdinal.{u} (L ++ p :: R) := by
  rw [forestGeneralOrdinal_append, forestGeneralOrdinal_append,
    forestGeneralOrdinal_cons, forestGeneralOrdinal_cons]
  have h2 : ordinalPow Ordinal.omega0 (hydraGeneralOrdinal.{u} q) <
      ordinalPow Ordinal.omega0 (hydraGeneralOrdinal.{u} p) :=
    (omegaPow_lt_omegaPow_iff).mpr h
  exact ordNadd_lt_ordNadd_right (ordNadd_lt_ordNadd_left h2)

/-- Replacing one child by finitely many copies of a strictly smaller child
strictly decreases the forest measure, again at an arbitrary position. -/
theorem forestGeneralOrdinal_replicate_lt {p q : Hydra} (n : Nat) (L R : List Hydra)
    (h : ordinalPow Ordinal.omega0 (hydraGeneralOrdinal.{u} q) * (n : Ordinal.{u}) <
      ordinalPow Ordinal.omega0 (hydraGeneralOrdinal.{u} p)) :
    forestGeneralOrdinal.{u} (L ++ List.replicate n q ++ R) <
      forestGeneralOrdinal.{u} (L ++ p :: R) := by
  rw [forestGeneralOrdinal_append, forestGeneralOrdinal_append,
    forestGeneralOrdinal_append, forestGeneralOrdinal_replicate,
    forestGeneralOrdinal_cons]
  simp only [ordNadd_assoc]
  exact ordNadd_lt_ordNadd_right (ordNadd_lt_ordNadd_left h)

/-- Removing a head from a forest strictly decreases its measure, at an
arbitrary position. -/
theorem forestGeneralOrdinal_remove_head (L R : List Hydra) :
    forestGeneralOrdinal.{u} (L ++ R) <
      forestGeneralOrdinal.{u} (L ++ Hydra.head :: R) := by
  rw [forestGeneralOrdinal_append, forestGeneralOrdinal_append,
    forestGeneralOrdinal_cons, hydraGeneralOrdinal_head, ordinalPow_zero,
    ordNadd_comm (1 : Ordinal.{u}), ordNadd_one]
  exact ordNadd_lt_ordNadd_right (lt_add_one _)

/-! ### Combinatorial helpers -/

private theorem subtreeAt_cons (children : List Hydra) (i : Nat) (rest : List Nat) :
    Hydra.subtreeAt (.node children) (i :: rest) =
      (children[i]?).bind (fun c => Hydra.subtreeAt c rest) := by
  cases h : children[i]? <;> simp [Hydra.subtreeAt, h]

private theorem isHeadPosition_singleton {children : List Hydra} {i : Nat}
    (h : Hydra.IsHeadPosition (.node children) [i]) : children[i]? = some Hydra.head := by
  obtain ⟨_, h2⟩ := h
  rw [subtreeAt_cons] at h2
  cases hb : children[i]? with
  | none => rw [hb] at h2; exact absurd h2 (by simp)
  | some child =>
      rw [hb] at h2
      simp only [Option.bind_some] at h2
      have hchild : child = Hydra.head := by simpa [Hydra.subtreeAt] using h2
      rw [hchild]

private theorem isHeadPosition_cons {children : List Hydra} {i : Nat} {rest : List Nat}
    (h : Hydra.IsHeadPosition (.node children) (i :: rest)) :
    ∃ child, children[i]? = some child ∧ Hydra.subtreeAt child rest = some Hydra.head := by
  obtain ⟨_, h2⟩ := h
  rw [subtreeAt_cons] at h2
  cases hb : children[i]? with
  | none => rw [hb] at h2; exact absurd h2 (by simp)
  | some child =>
      refine ⟨child, rfl, ?_⟩
      rw [hb] at h2
      simpa using h2

private theorem exists_decomp_of_getElem?_eq_some {l : List Hydra} {i : Nat} {x : Hydra}
    (h : l[i]? = some x) : ∃ L R : List Hydra, l = L ++ x :: R ∧ L.length = i := by
  induction l generalizing i with
  | nil => simp at h
  | cons c l ih =>
      cases i with
      | zero =>
          simp only [List.getElem?_cons_zero, Option.some.injEq] at h
          subst h
          exact ⟨[], l, rfl, rfl⟩
      | succ i =>
          simp only [List.getElem?_cons_succ] at h
          obtain ⟨L, R, hl, hlen⟩ := ih h
          exact ⟨c :: L, R, by simp [hl], by simp [hlen]⟩

private theorem replaceAtWith_append_cons (L R : List Hydra) (x : Hydra) (repl : List Hydra) :
    Hydra.replaceAtWith (L ++ x :: R) L.length repl = some (L ++ repl ++ R) := by
  induction L with
  | nil => rfl
  | cons first L ih =>
      simp only [List.cons_append, List.length_cons, Hydra.replaceAtWith]
      rw [ih]
      rfl

/-! ### Shape lemmas for `chop` -/

private theorem chop_singleton_eq_some {stage : Nat} {children : List Hydra} {i : Nat} {a : Hydra}
    (hchild : children[i]? = some Hydra.head)
    (hchop : Hydra.chop stage (.node children) [i] = some a) :
    ∃ cs, Hydra.replaceAtWith children i [] = some cs ∧ a = .node cs := by
  rw [Hydra.chop, hchild] at hchop
  simp only [Hydra.head, Bind.bind, Option.bind_some, Option.pure_def, Option.bind_eq_some_iff,
    Option.some.injEq] at hchop
  obtain ⟨cs, hcs, hnode⟩ := hchop
  exact ⟨cs, hcs, hnode.symm⟩

private theorem chop_pair_eq_some {stage : Nat} {children : List Hydra} {i j : Nat} {a : Hydra}
    {gs : List Hydra} (hchild : children[i]? = some (.node gs))
    (hchop : Hydra.chop stage (.node children) [i, j] = some a) :
    ∃ pl cs, Hydra.replaceAtWith gs j [] = some pl ∧
      Hydra.replaceAtWith children i (List.replicate (stage + 1) (.node pl)) = some cs ∧
      a = .node cs := by
  rw [Hydra.chop, hchild] at hchop
  simp only [Bind.bind, Option.bind_some, Option.pure_def, Option.bind_eq_some_iff,
    Option.some.injEq] at hchop
  obtain ⟨changed, ⟨ch, hch, hmatch⟩, cs, hcs, hnode⟩ := hchop
  cases ch with
  | node l =>
      cases l with
      | nil =>
          simp only [Option.bind_eq_some_iff, Option.some.injEq] at hmatch
          obtain ⟨pl, hpl, hchanged⟩ := hmatch
          refine ⟨pl, cs, hpl, ?_, hnode.symm⟩
          rw [← hchanged] at hcs
          exact hcs
      | cons h t => simp at hmatch

private theorem chop_deep_eq_some {stage : Nat} {children : List Hydra} {i j k : Nat}
    {rest : List Nat} {a : Hydra}
    (hchop : Hydra.chop stage (.node children) (i :: j :: k :: rest) = some a) :
    ∃ child d cs, children[i]? = some child ∧
      Hydra.chop stage child (j :: k :: rest) = some d ∧
      Hydra.replaceAtWith children i [d] = some cs ∧ a = .node cs := by
  rw [Hydra.chop] at hchop
  simp only [Bind.bind, Option.pure_def, Option.bind_eq_some_iff, Option.some.injEq] at hchop
  obtain ⟨child, hchild, changed, hchanged, cs, hcs, hnode⟩ := hchop
  obtain ⟨d, hd, hlist⟩ := hchanged
  refine ⟨child, d, cs, hchild, hd, ?_, hnode.symm⟩
  rw [← hlist] at hcs
  exact hcs

/-! ### The general descent theorem -/

private theorem chop_generalOrdinal_lt (stage : Nat) :
    ∀ (path : List Nat) (h a : Hydra), Hydra.IsHeadPosition h path →
      Hydra.chop stage h path = some a →
      hydraGeneralOrdinal.{u} a < hydraGeneralOrdinal.{u} h := by
  intro path
  induction path with
  | nil =>
      intro h a hpos _
      exact absurd rfl hpos.1
  | cons i rest ih =>
      intro h a hpos hchop
      cases h with
      | node children =>
          cases rest with
          | nil =>
              have hchild : children[i]? = some Hydra.head := isHeadPosition_singleton hpos
              obtain ⟨cs, hcs, rfl⟩ := chop_singleton_eq_some hchild hchop
              obtain ⟨L, R, hdecomp, hlen⟩ := exists_decomp_of_getElem?_eq_some hchild
              subst hdecomp
              rw [← hlen, replaceAtWith_append_cons] at hcs
              simp only [List.append_nil] at hcs
              have hcs' : L ++ R = cs := (Option.some.injEq _ _).mp hcs
              subst hcs'
              exact forestGeneralOrdinal_remove_head L R
          | cons j rest' =>
              cases rest' with
              | nil =>
                  obtain ⟨child, hchild, hsub⟩ := isHeadPosition_cons hpos
                  cases child with
                  | node gs =>
                      have hhead' : gs[j]? = some Hydra.head :=
                        isHeadPosition_singleton ⟨List.cons_ne_nil j [], hsub⟩
                      obtain ⟨pl, cs, hpl, hcs, rfl⟩ := chop_pair_eq_some hchild hchop
                      obtain ⟨L, R, hdecomp, hlen⟩ := exists_decomp_of_getElem?_eq_some hchild
                      subst hdecomp
                      rw [← hlen, replaceAtWith_append_cons] at hcs
                      have hcs' : L ++ List.replicate (stage + 1) (Hydra.node pl) ++ R = cs :=
                        (Option.some.injEq _ _).mp hcs
                      subst hcs'
                      obtain ⟨GL, GR, hgdecomp, hglen⟩ :=
                        exists_decomp_of_getElem?_eq_some hhead'
                      subst hgdecomp
                      rw [← hglen, replaceAtWith_append_cons] at hpl
                      simp only [List.append_nil] at hpl
                      have hpl' : GL ++ GR = pl := (Option.some.injEq _ _).mp hpl
                      subst hpl'
                      rw [hydraGeneralOrdinal_node, hydraGeneralOrdinal_node]
                      apply forestGeneralOrdinal_replicate_lt
                      have hmeasure : hydraGeneralOrdinal.{u} (Hydra.node (GL ++ GR)) <
                          hydraGeneralOrdinal.{u} (Hydra.node (GL ++ Hydra.head :: GR)) :=
                        forestGeneralOrdinal_remove_head GL GR
                      rw [ordinalPow_eq_opow, ordinalPow_eq_opow]
                      exact Ordinal.opow_mul_lt_opow
                        (Ordinal.natCast_lt_omega0 (stage + 1)) hmeasure
              | cons k rest'' =>
                  obtain ⟨child, d, cs, hchild, hchop', hcs, rfl⟩ := chop_deep_eq_some hchop
                  obtain ⟨child', hchild', hsub⟩ := isHeadPosition_cons hpos
                  rw [hchild] at hchild'
                  cases hchild'
                  have hhead : Hydra.IsHeadPosition child (j :: k :: rest'') :=
                    ⟨List.cons_ne_nil j (k :: rest''), hsub⟩
                  have hih : hydraGeneralOrdinal.{u} d < hydraGeneralOrdinal.{u} child :=
                    ih child d hhead hchop'
                  obtain ⟨L, R, hdecomp, hlen⟩ := exists_decomp_of_getElem?_eq_some hchild
                  subst hdecomp
                  rw [← hlen, replaceAtWith_append_cons] at hcs
                  have hcs' : L ++ [d] ++ R = cs := (Option.some.injEq _ _).mp hcs
                  subst hcs'
                  simpa using forestGeneralOrdinal_lt_of_child_lt L R hih

/-- 旧赋值 `hydraOrdinal`（列表序求和）**不是**一般单步的下降度量。反例是一个真实合法单步：根节点的唯一
子节点 `node [head, node [head]]` 的第 0 个头被砍掉后，剩余父树被复制两份，旧赋值从 `ω^ω` 变成
`ω^ω * 2`，反而上升。这正是本文件必须换用自然和的原因，也说明「消除最右脊柱限制」不能靠给旧赋值加假设
完成。 -/
theorem hydraOrdinal_not_general_descent :
    ∃ before after : Hydra, Hydra.Step 1 before after ∧
      hydraOrdinal before < hydraOrdinal after := by
  refine ⟨.node [.node [Hydra.head, .node [Hydra.head]]],
    .node [.node [.node [Hydra.head]], .node [.node [Hydra.head]]], ?_, ?_⟩
  · refine ⟨[0, 0], ?_, rfl⟩
    exact ⟨List.cons_ne_nil 0 [0], rfl⟩
  · have hone : hydraOrdinal (Hydra.node [Hydra.head]) = 1 := by
      rw [hydraOrdinal, forestOrdinal, hydraOrdinal_head, ordinalPow_zero, forestOrdinal,
        ordinalAdd_zero]
    have homega : hydraOrdinal (Hydra.node [Hydra.node [Hydra.head]]) = Ordinal.omega0 := by
      rw [hydraOrdinal, forestOrdinal, hone, forestOrdinal, ordinalAdd_zero]
      rw [show (1 : Ordinal) = Order.succ 0 by simp, ordinalPow_succ, ordinalPow_zero]
      simp [ordinalMul]
    have hforest : forestOrdinal [Hydra.node [Hydra.head]] = Ordinal.omega0 := homega
    have habsorb : ordinalAdd (1 : Ordinal) Ordinal.omega0 = Ordinal.omega0 := by
      rw [show ordinalAdd (1 : Ordinal) Ordinal.omega0 = 1 + Ordinal.omega0 by
        simp [ordinalAdd], Ordinal.one_add_omega0]
    have hinner : hydraOrdinal (Hydra.node [Hydra.head, Hydra.node [Hydra.head]]) =
        Ordinal.omega0 := by
      rw [hydraOrdinal, forestOrdinal, hydraOrdinal_head, ordinalPow_zero, hforest, habsorb]
    have hbefore : hydraOrdinal (.node [.node [Hydra.head, .node [Hydra.head]]]) =
        Ordinal.omega0 ^ Ordinal.omega0 := by
      rw [hydraOrdinal, forestOrdinal, hinner, forestOrdinal, ordinalAdd_zero,
        ordinalPow_eq_opow]
    have hafter : hydraOrdinal
        (.node [.node [.node [Hydra.head]], .node [.node [Hydra.head]]]) =
        Ordinal.omega0 ^ Ordinal.omega0 * 2 := by
      rw [hydraOrdinal, forestOrdinal, homega, forestOrdinal, homega, forestOrdinal,
        ordinalAdd_zero]
      rw [show ordinalAdd (ordinalPow Ordinal.omega0 Ordinal.omega0)
          (ordinalPow Ordinal.omega0 Ordinal.omega0) =
          Ordinal.omega0 ^ Ordinal.omega0 + Ordinal.omega0 ^ Ordinal.omega0 by
        simp [ordinalAdd, ordinalPow_eq_opow],
        ← Ordinal.mul_two]
    rw [hbefore, hafter, Ordinal.mul_two]
    exact lt_add_of_pos_right _ (Ordinal.opow_pos _ Ordinal.omega0_pos)

/--
> **Entry**: settheory.googology.hydra-general-descent
> **一句话**: 用自然和（Hessenberg 和）重新赋值后，任意合法 Hydra 单步（任意深度、任意头位置、任意阶段复制）都严格降低结构序数。
> **依赖**: `settheory.googology.hydra-game-step`、`settheory.googology.hydra-ordinal-assignment`
> **mathlib**: `Ordinal.CNF.eval`、`Ordinal.CNF.coeff`、`Ordinal.opow_mul_lt_opow`

Every legal `Hydra.Step` strictly lowers `hydraGeneralOrdinal`.  The statement
covers arbitrary head positions and arbitrary depths, with no rightmost-spine
certificate.
-/
theorem hydraStep_generalOrdinal_lt {stage : Nat} {before after : Hydra}
    (h : Hydra.Step stage before after) :
    hydraGeneralOrdinal.{u} after < hydraGeneralOrdinal.{u} before := by
  obtain ⟨path, hpos, hchop⟩ := h
  exact chop_generalOrdinal_lt stage path before after hpos hchop

end
end SandronesLibrary.SetTheory.HydraGeneralDescent
