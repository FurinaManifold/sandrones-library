/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Analysis.Series

/-!
# Riemann rearrangement theorem

This module formalizes Rudin's direct alternating-block construction.  Positive
and negative terms are consumed in order until moving upper and lower targets
are crossed.  The resulting block code is a permutation, and its partial sums
have prescribed `liminf` and `limsup`.
-/

namespace SandronesLibrary.Analysis.Series.RudinDirect

open Filter
open scoped Topology

/-- Finite partial sums, indexed by the number of terms retained. -/
def partialSum (u : ℕ → ℝ) (N : ℕ) : ℝ := ∑ j ∈ Finset.range N, u j

/-- The positive and negative enumerations are kept as *signed* terms. -/
def signedPositive (a : ℕ → ℝ) (indP : ℕ → ℕ) : ℕ → ℝ := fun j => a (indP j)
def signedNegative (a : ℕ → ℝ) (indQ : ℕ → ℕ) : ℕ → ℝ := fun j => a (indQ j)

/-- `pblock k` and `nblock k` are the cumulative positions in the rearranged
series after the `k`-th positive and negative block respectively.  Thus
`nblock (k-1) < pblock k < nblock k`. -/
structure BlockEnds where
  posCount : ℕ → ℕ
  negCount : ℕ → ℕ
  pblock : ℕ → ℕ
  nblock : ℕ → ℕ
  posCount_zero : posCount 0 = 0
  negCount_zero : negCount 0 = 0
  pblock_zero : pblock 0 = 0
  nblock_zero : nblock 0 = 0
  neg_before_pos : ∀ k, nblock k < pblock (k + 1)
  pos_before_neg : ∀ k, pblock (k + 1) < nblock (k + 1)
  pblock_eq : ∀ k, pblock (k + 1) = posCount (k + 1) + negCount k
  nblock_eq : ∀ k, nblock (k + 1) = posCount (k + 1) + negCount (k + 1)
  covers : ∀ ℓ, 0 < ℓ → (∃ k, nblock k < ℓ ∧ ℓ ≤ pblock (k + 1)) ∨
    (∃ k, pblock (k + 1) < ℓ ∧ ℓ ≤ nblock (k + 1))

/-- The original index selected at rearranged position `ℓ`.  The two branches
are the direct affine formulae in `1.txt`, with `posCount` and `negCount`
recording how many terms of each sign have already been consumed. -/
noncomputable def blockIndex (indP indQ : ℕ → ℕ) (E : BlockEnds) (ℓ : ℕ) : ℕ := by
  classical
  let r := ℓ + 1
  exact if h : ∃ k, E.pblock (k + 1) < r ∧ r ≤ E.nblock (k + 1) then
    let k := Nat.find h
    indQ (E.negCount k + (r - E.pblock (k + 1) - 1))
  else
    let k := Nat.find ((E.covers r (by omega)).resolve_right h)
    indP (E.posCount k + (r - E.nblock k - 1))

/-- The same block code before the two signed enumerations are applied. -/
noncomputable def blockTag (E : BlockEnds) (ℓ : ℕ) : ℕ ⊕ ℕ := by
  classical
  let r := ℓ + 1
  exact if h : ∃ k, E.pblock (k + 1) < r ∧ r ≤ E.nblock (k + 1) then
    let k := Nat.find h
    Sum.inr (E.negCount k + (r - E.pblock (k + 1) - 1))
  else
    let k := Nat.find ((E.covers r (by omega)).resolve_right h)
    Sum.inl (E.posCount k + (r - E.nblock k - 1))

/-- A disjoint exhaustive indexing of original terms by their sign classes.
Zero terms require a separate insertion policy; this direct Rudin core is the
zero-free part of the rearrangement. -/
structure SourceSplit (a : ℕ → ℝ) where
  equiv : ℕ ⊕ ℕ ≃ ℕ
  positive : ∀ j, 0 < a (equiv (Sum.inl j))
  negative : ∀ j, a (equiv (Sum.inr j)) < 0

def SourceSplit.indP {a : ℕ → ℝ} (S : SourceSplit a) : ℕ → ℕ :=
  fun j => S.equiv (Sum.inl j)
def SourceSplit.indQ {a : ℕ → ℝ} (S : SourceSplit a) : ℕ → ℕ :=
  fun j => S.equiv (Sum.inr j)

theorem SourceSplit.indP_injective {a : ℕ → ℝ} (S : SourceSplit a) :
    Function.Injective S.indP := by
  intro i j hij
  apply Sum.inl.inj
  exact S.equiv.injective hij

theorem SourceSplit.indQ_injective {a : ℕ → ℝ} (S : SourceSplit a) :
    Function.Injective S.indQ := by
  intro i j hij
  apply Sum.inr.inj
  exact S.equiv.injective hij

theorem SourceSplit.indP_ne_indQ {a : ℕ → ℝ} (S : SourceSplit a) (i j : ℕ) :
    S.indP i ≠ S.indQ j := by
  intro h
  have : Sum.inl i = Sum.inr j := S.equiv.injective h
  cases this

/-- Positive counters strictly grow because every positive block has positive
length. -/
theorem BlockEnds.posCount_strictMono (E : BlockEnds) : StrictMono E.posCount := by
  apply strictMono_nat_of_lt_succ
  intro n
  cases n with
  | zero =>
      have h := E.neg_before_pos 0
      rw [E.nblock_zero, E.pblock_eq 0, E.negCount_zero] at h
      simpa [E.posCount_zero] using h
  | succ n =>
      have h := E.neg_before_pos (n + 1)
      rw [E.nblock_eq n, E.pblock_eq (n + 1)] at h
      omega

/-- Negative counters strictly grow because every negative block has positive
length. -/
theorem BlockEnds.negCount_strictMono (E : BlockEnds) : StrictMono E.negCount := by
  apply strictMono_nat_of_lt_succ
  intro n
  have h := E.pos_before_neg n
  rw [E.pblock_eq n, E.nblock_eq n] at h
  omega

theorem BlockEnds.nblock_strictMono (E : BlockEnds) : StrictMono E.nblock := by
  apply strictMono_nat_of_lt_succ
  intro n
  exact lt_trans (E.neg_before_pos n) (E.pos_before_neg n)

theorem BlockEnds.pblock_strictMono (E : BlockEnds) : StrictMono E.pblock := by
  apply strictMono_nat_of_lt_succ
  intro n
  cases n with
  | zero =>
      have h := E.neg_before_pos 0
      rw [E.nblock_zero] at h
      simpa [E.pblock_zero] using h
  | succ n =>
      exact lt_trans (E.pos_before_neg n) (E.neg_before_pos (n + 1))

theorem not_negBlock_of_posBlock (E : BlockEnds) {k r : ℕ}
    (hpos : E.nblock k < r ∧ r ≤ E.pblock (k + 1)) :
    ¬ ∃ l, E.pblock (l + 1) < r ∧ r ≤ E.nblock (l + 1) := by
  rintro ⟨l, hleft, hright⟩
  rcases le_total l k with hlk | hkl
  · by_cases heq : l = k
    · subst l
      omega
    · have hlt : l + 1 ≤ k := Nat.succ_le_iff.mpr (lt_of_le_of_ne hlk heq)
      have hmono := E.nblock_strictMono.monotone hlt
      exact (Nat.not_lt_of_ge (hright.trans hmono)) hpos.1
  · by_cases heq : k = l
    · subst l
      omega
    · have hlt : k + 1 ≤ l := Nat.succ_le_iff.mpr (lt_of_le_of_ne hkl heq)
      have hmono := E.pblock_strictMono.monotone hlt
      have hstep := E.pblock_strictMono.monotone (Nat.le_succ l)
      exact (Nat.not_lt_of_ge (hpos.2.trans (hmono.trans hstep))) hleft

theorem not_posBlock_of_negBlock (E : BlockEnds) {k r : ℕ}
    (hneg : E.pblock (k + 1) < r ∧ r ≤ E.nblock (k + 1)) :
    ¬ ∃ l, E.nblock l < r ∧ r ≤ E.pblock (l + 1) := by
  rintro ⟨l, hleft, hright⟩
  rcases le_total l k with hlk | hkl
  · by_cases heq : l = k
    · subst l
      omega
    · have hlt : l + 1 ≤ k := Nat.succ_le_iff.mpr (lt_of_le_of_ne hlk heq)
      have hmono := E.pblock_strictMono.monotone hlt
      have hstep := E.pblock_strictMono.monotone (Nat.le_succ k)
      exact (Nat.not_lt_of_ge (hright.trans (hmono.trans hstep))) hneg.1
  · by_cases heq : k = l
    · subst l
      omega
    · have hlt : k + 1 ≤ l := Nat.succ_le_iff.mpr (lt_of_le_of_ne hkl heq)
      have hmono := E.nblock_strictMono.monotone hlt
      exact (Nat.not_lt_of_ge (hneg.2.trans hmono)) hleft

theorem nblock_add_posBlockLength (E : BlockEnds) (k : ℕ) :
    E.nblock k + (E.posCount (k + 1) - E.posCount k) = E.pblock (k + 1) := by
  cases k with
  | zero =>
      rw [E.nblock_zero, E.posCount_zero, E.pblock_eq 0, E.negCount_zero]
      omega
  | succ k =>
      have hk : k + 1 + 1 = k + 2 := by omega
      rw [E.nblock_eq k, E.pblock_eq (k + 1), hk]
      have h : E.posCount (k + 1) < E.posCount (k + 2) :=
        E.posCount_strictMono (by omega)
      omega

theorem pblock_add_negBlockLength (E : BlockEnds) (k : ℕ) :
    E.pblock (k + 1) + (E.negCount (k + 1) - E.negCount k) = E.nblock (k + 1) := by
  rw [E.pblock_eq k, E.nblock_eq k]
  have h : E.negCount k < E.negCount (k + 1) :=
    E.negCount_strictMono (by omega)
  omega

theorem BlockEnds.posCount_tendsto_atTop (E : BlockEnds) :
    Tendsto E.posCount atTop atTop := E.posCount_strictMono.tendsto_atTop

theorem BlockEnds.negCount_tendsto_atTop (E : BlockEnds) :
    Tendsto E.negCount atTop atTop := E.negCount_strictMono.tendsto_atTop

theorem exists_posCount_block (E : BlockEnds) (j : ℕ) :
    ∃ k, j < E.posCount (k + 1) := by
  rcases tendsto_atTop_atTop.mp E.posCount_tendsto_atTop (j + 1) with ⟨k, hk⟩
  exact ⟨k, lt_of_lt_of_le (Nat.lt_succ_self j) (hk (k + 1) (Nat.le_succ k))⟩

theorem exists_negCount_block (E : BlockEnds) (j : ℕ) :
    ∃ k, j < E.negCount (k + 1) := by
  rcases tendsto_atTop_atTop.mp E.negCount_tendsto_atTop (j + 1) with ⟨k, hk⟩
  exact ⟨k, lt_of_lt_of_le (Nat.lt_succ_self j) (hk (k + 1) (Nat.le_succ k))⟩

noncomputable def posTagBlock (E : BlockEnds) (j : ℕ) : ℕ :=
  Nat.find (exists_posCount_block E j)

noncomputable def negTagBlock (E : BlockEnds) (j : ℕ) : ℕ :=
  Nat.find (exists_negCount_block E j)

theorem posTagBlock_spec (E : BlockEnds) (j : ℕ) :
    j < E.posCount (posTagBlock E j + 1) :=
  Nat.find_spec (exists_posCount_block E j)

theorem negTagBlock_spec (E : BlockEnds) (j : ℕ) :
    j < E.negCount (negTagBlock E j + 1) :=
  Nat.find_spec (exists_negCount_block E j)

theorem posCount_le_posTagBlock (E : BlockEnds) (j : ℕ) :
    E.posCount (posTagBlock E j) ≤ j := by
  by_contra h
  have hpos : 0 < posTagBlock E j := by
    by_contra hz
    simp only [Nat.not_lt, Nat.le_zero] at hz
    rw [hz, E.posCount_zero] at h
    omega
  have hlt : posTagBlock E j - 1 < posTagBlock E j := Nat.sub_lt hpos Nat.zero_lt_one
  have hmin := Nat.find_min (exists_posCount_block E j) hlt
  have hle : E.posCount (posTagBlock E j - 1 + 1) ≤ j := by
    simpa [posTagBlock] using hmin
  have heq : posTagBlock E j - 1 + 1 = posTagBlock E j := by omega
  rw [heq] at hle
  omega

theorem negCount_le_negTagBlock (E : BlockEnds) (j : ℕ) :
    E.negCount (negTagBlock E j) ≤ j := by
  by_contra h
  have hpos : 0 < negTagBlock E j := by
    by_contra hz
    simp only [Nat.not_lt, Nat.le_zero] at hz
    rw [hz, E.negCount_zero] at h
    omega
  have hlt : negTagBlock E j - 1 < negTagBlock E j := Nat.sub_lt hpos Nat.zero_lt_one
  have hmin := Nat.find_min (exists_negCount_block E j) hlt
  have hle : E.negCount (negTagBlock E j - 1 + 1) ≤ j := by
    simpa [negTagBlock] using hmin
  have heq : negTagBlock E j - 1 + 1 = negTagBlock E j := by omega
  rw [heq] at hle
  omega

noncomputable def posTagPreimage (E : BlockEnds) (j : ℕ) : ℕ :=
  E.nblock (posTagBlock E j) + (j - E.posCount (posTagBlock E j))

noncomputable def negTagPreimage (E : BlockEnds) (j : ℕ) : ℕ :=
  E.pblock (negTagBlock E j + 1) + (j - E.negCount (negTagBlock E j))

theorem posTagPreimage_mem_posBlock (E : BlockEnds) (j : ℕ) :
    E.nblock (posTagBlock E j) < posTagPreimage E j + 1 ∧
      posTagPreimage E j + 1 ≤ E.pblock (posTagBlock E j + 1) := by
  let k := posTagBlock E j
  have hlow : E.posCount k ≤ j := posCount_le_posTagBlock E j
  have hhigh : j < E.posCount (k + 1) := posTagBlock_spec E j
  have hlen := nblock_add_posBlockLength E k
  change E.nblock k < E.nblock k + (j - E.posCount k) + 1 ∧
    E.nblock k + (j - E.posCount k) + 1 ≤ E.pblock (k + 1)
  constructor <;> omega

theorem negTagPreimage_mem_negBlock (E : BlockEnds) (j : ℕ) :
    E.pblock (negTagBlock E j + 1) < negTagPreimage E j + 1 ∧
      negTagPreimage E j + 1 ≤ E.nblock (negTagBlock E j + 1) := by
  let k := negTagBlock E j
  have hlow : E.negCount k ≤ j := negCount_le_negTagBlock E j
  have hhigh : j < E.negCount (k + 1) := negTagBlock_spec E j
  have hlen := pblock_add_negBlockLength E k
  change E.pblock (k + 1) < E.pblock (k + 1) + (j - E.negCount k) + 1 ∧
    E.pblock (k + 1) + (j - E.negCount k) + 1 ≤ E.nblock (k + 1)
  constructor <;> omega

theorem posBlock_unique (E : BlockEnds) {k l r : ℕ}
    (hk : E.nblock k < r ∧ r ≤ E.pblock (k + 1))
    (hl : E.nblock l < r ∧ r ≤ E.pblock (l + 1)) : k = l := by
  by_contra hne
  rcases lt_or_gt_of_ne hne with hkl | hlk
  · have hstep := E.pos_before_neg k
    have hmono := E.nblock_strictMono.monotone (show k + 1 ≤ l by omega)
    have : E.pblock (k + 1) < r := lt_trans hstep (lt_of_le_of_lt hmono hl.1)
    exact (Nat.not_lt_of_ge hk.2) this
  · have hstep := E.pos_before_neg l
    have hmono := E.nblock_strictMono.monotone (show l + 1 ≤ k by omega)
    have : E.pblock (l + 1) < r := lt_trans hstep (lt_of_le_of_lt hmono hk.1)
    exact (Nat.not_lt_of_ge hl.2) this

theorem negBlock_unique (E : BlockEnds) {k l r : ℕ}
    (hk : E.pblock (k + 1) < r ∧ r ≤ E.nblock (k + 1))
    (hl : E.pblock (l + 1) < r ∧ r ≤ E.nblock (l + 1)) : k = l := by
  by_contra hne
  rcases lt_or_gt_of_ne hne with hkl | hlk
  · have hstep : E.nblock (k + 1) < E.pblock (k + 2) := by
      simpa using E.neg_before_pos (k + 1)
    have hmono := E.pblock_strictMono.monotone (show k + 2 ≤ l + 1 by omega)
    have : E.nblock (k + 1) < r := lt_trans hstep (lt_of_le_of_lt hmono hl.1)
    exact (Nat.not_lt_of_ge hk.2) this
  · have hstep : E.nblock (l + 1) < E.pblock (l + 2) := by
      simpa using E.neg_before_pos (l + 1)
    have hmono := E.pblock_strictMono.monotone (show l + 2 ≤ k + 1 by omega)
    have : E.nblock (l + 1) < r := lt_trans hstep (lt_of_le_of_lt hmono hk.1)
    exact (Nat.not_lt_of_ge hl.2) this

theorem posCount_interval_unique (E : BlockEnds) {k l j : ℕ}
    (hk : E.posCount k ≤ j ∧ j < E.posCount (k + 1))
    (hl : E.posCount l ≤ j ∧ j < E.posCount (l + 1)) : k = l := by
  by_contra hne
  rcases lt_or_gt_of_ne hne with hkl | hlk
  · have hmono := E.posCount_strictMono.monotone (show k + 1 ≤ l by omega)
    exact (Nat.not_lt_of_ge (hmono.trans hl.1)) hk.2
  · have hmono := E.posCount_strictMono.monotone (show l + 1 ≤ k by omega)
    exact (Nat.not_lt_of_ge (hmono.trans hk.1)) hl.2

theorem negCount_interval_unique (E : BlockEnds) {k l j : ℕ}
    (hk : E.negCount k ≤ j ∧ j < E.negCount (k + 1))
    (hl : E.negCount l ≤ j ∧ j < E.negCount (l + 1)) : k = l := by
  by_contra hne
  rcases lt_or_gt_of_ne hne with hkl | hlk
  · have hmono := E.negCount_strictMono.monotone (show k + 1 ≤ l by omega)
    exact (Nat.not_lt_of_ge (hmono.trans hl.1)) hk.2
  · have hmono := E.negCount_strictMono.monotone (show l + 1 ≤ k by omega)
    exact (Nat.not_lt_of_ge (hmono.trans hk.1)) hl.2

theorem blockTag_posTagPreimage (E : BlockEnds) (j : ℕ) :
    blockTag E (posTagPreimage E j) = Sum.inl j := by
  classical
  let k := posTagBlock E j
  let ℓ := posTagPreimage E j
  let r := ℓ + 1
  have hmem : E.nblock k < r ∧ r ≤ E.pblock (k + 1) := by
    exact posTagPreimage_mem_posBlock E j
  have hnotneg : ¬ ∃ q, E.pblock (q + 1) < r ∧ r ≤ E.nblock (q + 1) :=
    not_negBlock_of_posBlock E hmem
  have hfind : Nat.find ((E.covers r (by omega)).resolve_right hnotneg) = k := by
    apply posBlock_unique E (Nat.find_spec ((E.covers r (by omega)).resolve_right hnotneg)) hmem
  have hlow : E.posCount k ≤ j := posCount_le_posTagBlock E j
  change blockTag E ℓ = Sum.inl j
  simp only [blockTag]
  rw [dif_neg hnotneg]
  rw [hfind]
  change Sum.inl (E.posCount k + (r - E.nblock k - 1)) = Sum.inl j
  have hoff : r - E.nblock k - 1 = j - E.posCount k := by
    dsimp [r, ℓ, posTagPreimage, k]
    omega
  rw [hoff]
  exact congrArg Sum.inl (Nat.add_sub_of_le hlow)

theorem blockTag_negTagPreimage (E : BlockEnds) (j : ℕ) :
    blockTag E (negTagPreimage E j) = Sum.inr j := by
  classical
  let k := negTagBlock E j
  let ℓ := negTagPreimage E j
  let r := ℓ + 1
  have hmem : E.pblock (k + 1) < r ∧ r ≤ E.nblock (k + 1) := by
    exact negTagPreimage_mem_negBlock E j
  let hExists : ∃ q, E.pblock (q + 1) < r ∧ r ≤ E.nblock (q + 1) := ⟨k, hmem⟩
  have hfind : Nat.find hExists = k := by
    apply negBlock_unique E (Nat.find_spec hExists) hmem
  have hlow : E.negCount k ≤ j := negCount_le_negTagBlock E j
  change blockTag E ℓ = Sum.inr j
  simp only [blockTag]
  rw [dif_pos ⟨k, hmem⟩]
  rw [hfind]
  change Sum.inr (E.negCount k + (r - E.pblock (k + 1) - 1)) = Sum.inr j
  have hoff : r - E.pblock (k + 1) - 1 = j - E.negCount k := by
    dsimp [r, ℓ, negTagPreimage, k]
    omega
  rw [hoff]
  exact congrArg Sum.inr (Nat.add_sub_of_le hlow)

theorem blockTag_eq_inr_of_negBlock (E : BlockEnds) {ℓ k : ℕ}
    (hmem : E.pblock (k + 1) < ℓ + 1 ∧ ℓ + 1 ≤ E.nblock (k + 1)) :
    blockTag E ℓ = Sum.inr
      (E.negCount k + (ℓ + 1 - E.pblock (k + 1) - 1)) := by
  classical
  let hExists : ∃ q, E.pblock (q + 1) < ℓ + 1 ∧
      ℓ + 1 ≤ E.nblock (q + 1) := ⟨k, hmem⟩
  have hfind : Nat.find hExists = k := by
    apply negBlock_unique E (Nat.find_spec hExists) hmem
  simp only [blockTag]
  rw [dif_pos ⟨k, hmem⟩]
  rw [hfind]

theorem blockTag_eq_inl_of_posBlock (E : BlockEnds) {ℓ k : ℕ}
    (hmem : E.nblock k < ℓ + 1 ∧ ℓ + 1 ≤ E.pblock (k + 1)) :
    blockTag E ℓ = Sum.inl
      (E.posCount k + (ℓ + 1 - E.nblock k - 1)) := by
  classical
  have hnotneg : ¬ ∃ q, E.pblock (q + 1) < ℓ + 1 ∧
      ℓ + 1 ≤ E.nblock (q + 1) := not_negBlock_of_posBlock E hmem
  have hfind : Nat.find ((E.covers (ℓ + 1) (by omega)).resolve_right hnotneg) = k := by
    apply posBlock_unique E
      (Nat.find_spec ((E.covers (ℓ + 1) (by omega)).resolve_right hnotneg)) hmem
  simp only [blockTag]
  rw [dif_neg hnotneg]
  rw [hfind]

theorem negTag_offset_mem_interval (E : BlockEnds) {ℓ k : ℕ}
    (hmem : E.pblock (k + 1) < ℓ + 1 ∧ ℓ + 1 ≤ E.nblock (k + 1)) :
    E.negCount k ≤ E.negCount k + (ℓ + 1 - E.pblock (k + 1) - 1) ∧
      E.negCount k + (ℓ + 1 - E.pblock (k + 1) - 1) < E.negCount (k + 1) := by
  have hlen := pblock_add_negBlockLength E k
  constructor
  · exact Nat.le_add_right _ _
  · omega

theorem posTag_offset_mem_interval (E : BlockEnds) {ℓ k : ℕ}
    (hmem : E.nblock k < ℓ + 1 ∧ ℓ + 1 ≤ E.pblock (k + 1)) :
    E.posCount k ≤ E.posCount k + (ℓ + 1 - E.nblock k - 1) ∧
      E.posCount k + (ℓ + 1 - E.nblock k - 1) < E.posCount (k + 1) := by
  have hlen := nblock_add_posBlockLength E k
  constructor
  · exact Nat.le_add_right _ _
  · omega

theorem blockIndex_eq_sourceSplit_apply {a : ℕ → ℝ} (S : SourceSplit a)
    (E : BlockEnds) (ℓ : ℕ) :
    blockIndex S.indP S.indQ E ℓ = S.equiv (blockTag E ℓ) := by
  simp only [blockIndex, blockTag, SourceSplit.indP, SourceSplit.indQ]
  split <;> rfl

/-- The original-index map is bijective as soon as the purely combinatorial
block-tag map is bijective. -/
theorem blockIndex_bijective_of_blockTag_bijective {a : ℕ → ℝ}
    (S : SourceSplit a) (E : BlockEnds)
    (hTag : Function.Bijective (blockTag E)) :
    Function.Bijective (blockIndex S.indP S.indQ E) := by
  rw [show blockIndex S.indP S.indQ E = fun ℓ => S.equiv (blockTag E ℓ) by
    funext ℓ
    exact blockIndex_eq_sourceSplit_apply S E ℓ]
  exact S.equiv.bijective.comp hTag

/-- TODO 1 (injectivity): ordered block intervals do not overlap, and each
affine offset inside one block is injective. -/
theorem blockTag_injective_of_block_recursion (E : BlockEnds)
    : Function.Injective (blockTag E) := by
  intro x y hxy
  rcases E.covers (x + 1) (by omega) with ⟨kx, hx⟩ | ⟨kx, hx⟩
  · rcases E.covers (y + 1) (by omega) with ⟨ky, hy⟩ | ⟨ky, hy⟩
    · rw [blockTag_eq_inl_of_posBlock E hx,
        blockTag_eq_inl_of_posBlock E hy] at hxy
      have hj := Sum.inl.inj hxy
      have hyI : E.posCount ky ≤ E.posCount kx +
          (x + 1 - E.nblock kx - 1) ∧
          E.posCount kx + (x + 1 - E.nblock kx - 1) < E.posCount (ky + 1) := by
        rw [hj]
        exact posTag_offset_mem_interval E hy
      have hk := posCount_interval_unique E (posTag_offset_mem_interval E hx) hyI
      subst ky
      omega
    · rw [blockTag_eq_inl_of_posBlock E hx,
        blockTag_eq_inr_of_negBlock E hy] at hxy
      cases hxy
  · rcases E.covers (y + 1) (by omega) with ⟨ky, hy⟩ | ⟨ky, hy⟩
    · rw [blockTag_eq_inr_of_negBlock E hx,
        blockTag_eq_inl_of_posBlock E hy] at hxy
      cases hxy
    · rw [blockTag_eq_inr_of_negBlock E hx,
        blockTag_eq_inr_of_negBlock E hy] at hxy
      have hj := Sum.inr.inj hxy
      have hyI : E.negCount ky ≤ E.negCount kx +
          (x + 1 - E.pblock (kx + 1) - 1) ∧
          E.negCount kx + (x + 1 - E.pblock (kx + 1) - 1) < E.negCount (ky + 1) := by
        rw [hj]
        exact negTag_offset_mem_interval E hy
      have hk := negCount_interval_unique E (negTag_offset_mem_interval E hx) hyI
      subst ky
      omega

/-- TODO 2 (surjectivity): strict growth of the two counters makes the union
of their consecutive block intervals cover every positive and negative tag. -/
theorem blockTag_surjective_of_block_recursion (E : BlockEnds)
    : Function.Surjective (blockTag E) := by
  intro x
  cases x with
  | inl j => exact ⟨posTagPreimage E j, blockTag_posTagPreimage E j⟩
  | inr j => exact ⟨negTagPreimage E j, blockTag_negTagPreimage E j⟩

/-- Assembly of the two checked lower interfaces. -/
theorem blockTag_bijective_of_block_recursion (E : BlockEnds)
    :
    Function.Bijective (blockTag E) :=
  ⟨blockTag_injective_of_block_recursion E,
    blockTag_surjective_of_block_recursion E⟩

/-- The direct Rudin sequence is the original sequence composed with the
explicit direct block index map. -/
noncomputable def blockSeries (a : ℕ → ℝ) (indP indQ : ℕ → ℕ)
    (E : BlockEnds) (ℓ : ℕ) : ℝ := a (blockIndex indP indQ E ℓ)

theorem blockSeries_apply (a : ℕ → ℝ) (indP indQ : ℕ → ℕ)
    (E : BlockEnds) (ℓ : ℕ) :
    blockSeries a indP indQ E ℓ = a (blockIndex indP indQ E ℓ) := rfl

/-- The direct target endpoints used by Rudin.  With `α ≤ β`, positive blocks
cross `β + 1/(k+1)` and negative blocks cross `α - 1/(k+1)`. -/
noncomputable def lowerTarget (α : ℝ) (k : ℕ) : ℝ := α - 1 / ((k : ℝ) + 1)
noncomputable def upperTarget (β : ℝ) (k : ℕ) : ℝ := β + 1 / ((k : ℝ) + 1)

theorem lowerTarget_tendsto (α : ℝ) :
    Tendsto (lowerTarget α) atTop (𝓝 α) := by
  change Tendsto (fun n : ℕ => α - 1 / ((n : ℝ) + 1)) atTop (𝓝 α)
  simpa using
    (tendsto_const_nhds : Tendsto (fun _ : ℕ => α) atTop (𝓝 α)).sub
      (tendsto_one_div_add_atTop_nhds_zero_nat (𝕜 := ℝ))

theorem upperTarget_tendsto (β : ℝ) :
    Tendsto (upperTarget β) atTop (𝓝 β) := by
  change Tendsto (fun n : ℕ => β + 1 / ((n : ℝ) + 1)) atTop (𝓝 β)
  simpa using
    (tendsto_const_nhds : Tendsto (fun _ : ℕ => β) atTop (𝓝 β)).add
      (tendsto_one_div_add_atTop_nhds_zero_nat (𝕜 := ℝ))

theorem lowerTarget_lt_upperTarget {α β : ℝ} (hαβ : α ≤ β) (m n : ℕ) :
    lowerTarget α m < upperTarget β n := by
  dsimp [lowerTarget, upperTarget]
  have hm : 0 < 1 / ((m : ℝ) + 1) := by positivity
  have hn : 0 < 1 / ((n : ℝ) + 1) := by positivity
  linarith

/-- A divergent nonnegative partial sum eventually crosses any prescribed
level after any prescribed starting index. -/
theorem choose_positive_tail {p : ℕ → ℝ}
    (hp : Tendsto (partialSum p) atTop atTop) (start : ℕ) (y : ℝ) :
    ∃ m, start ≤ m ∧ y < partialSum p m := by
  rcases tendsto_atTop_atTop.mp hp (y + 1) with ⟨N, hN⟩
  refine ⟨max start N, le_max_left _ _, ?_⟩
  have := hN (max start N) (le_max_right _ _)
  linarith

noncomputable def firstPositiveCrossing (p : ℕ → ℝ)
    (hp : Tendsto (partialSum p) atTop atTop) (start : ℕ) (y : ℝ) : ℕ :=
  Nat.find (choose_positive_tail hp start y)

theorem firstPositiveCrossing_spec {p : ℕ → ℝ}
    (hp : Tendsto (partialSum p) atTop atTop) (start : ℕ) (y : ℝ) :
    start ≤ firstPositiveCrossing p hp start y ∧
      y < partialSum p (firstPositiveCrossing p hp start y) :=
  Nat.find_spec (choose_positive_tail hp start y)

theorem firstPositiveCrossing_prev_le {p : ℕ → ℝ}
    (hp : Tendsto (partialSum p) atTop atTop) {start : ℕ} {y : ℝ}
    (hstart : partialSum p start ≤ y) :
    partialSum p (firstPositiveCrossing p hp start y - 1) ≤ y := by
  have hspec := firstPositiveCrossing_spec hp start y
  have hlt : start < firstPositiveCrossing p hp start y := by
    by_contra hnot
    have heq : firstPositiveCrossing p hp start y = start :=
      Nat.le_antisymm (Nat.le_of_not_gt hnot) hspec.1
    rw [heq] at hspec
    exact (not_lt_of_ge hstart hspec.2)
  by_contra hnot
  have hpred_start : start ≤ firstPositiveCrossing p hp start y - 1 := by omega
  have hpred_cross : y < partialSum p (firstPositiveCrossing p hp start y - 1) :=
    lt_of_not_ge hnot
  have hmin := Nat.find_min' (choose_positive_tail hp start y)
    ⟨hpred_start, hpred_cross⟩
  have hpos : 0 < firstPositiveCrossing p hp start y :=
    lt_of_le_of_lt (Nat.zero_le start) hlt
  exact (Nat.not_le_of_gt (Nat.sub_lt hpos Nat.zero_lt_one)) hmin

theorem choose_negative_tail {q : ℕ → ℝ}
    (hq : Tendsto (partialSum q) atTop atTop) (start : ℕ) (y : ℝ) :
    ∃ m, start ≤ m ∧ y < partialSum q m :=
  choose_positive_tail hq start y

noncomputable def firstNegativeCrossing (q : ℕ → ℝ)
    (hq : Tendsto (partialSum q) atTop atTop) (start : ℕ) (y : ℝ) : ℕ :=
  Nat.find (choose_negative_tail hq start y)

theorem firstNegativeCrossing_spec {q : ℕ → ℝ}
    (hq : Tendsto (partialSum q) atTop atTop) (start : ℕ) (y : ℝ) :
    start ≤ firstNegativeCrossing q hq start y ∧
      y < partialSum q (firstNegativeCrossing q hq start y) :=
  Nat.find_spec (choose_negative_tail hq start y)

theorem firstNegativeCrossing_prev_le {q : ℕ → ℝ}
    (hq : Tendsto (partialSum q) atTop atTop) {start : ℕ} {y : ℝ}
    (hstart : partialSum q start ≤ y) :
    partialSum q (firstNegativeCrossing q hq start y - 1) ≤ y := by
  have hspec := firstNegativeCrossing_spec hq start y
  have hlt : start < firstNegativeCrossing q hq start y := by
    by_contra hnot
    have heq : firstNegativeCrossing q hq start y = start :=
      Nat.le_antisymm (Nat.le_of_not_gt hnot) hspec.1
    rw [heq] at hspec
    exact (not_lt_of_ge hstart hspec.2)
  by_contra hnot
  have hpred_start : start ≤ firstNegativeCrossing q hq start y - 1 := by omega
  have hpred_cross : y < partialSum q (firstNegativeCrossing q hq start y - 1) :=
    lt_of_not_ge hnot
  have hmin := Nat.find_min' (choose_negative_tail hq start y)
    ⟨hpred_start, hpred_cross⟩
  have hpos : 0 < firstNegativeCrossing q hq start y :=
    lt_of_le_of_lt (Nat.zero_le start) hlt
  exact (Nat.not_le_of_gt (Nat.sub_lt hpos Nat.zero_lt_one)) hmin

theorem lt_firstPositiveCrossing {p : ℕ → ℝ}
    (hp : Tendsto (partialSum p) atTop atTop) {start : ℕ} {y : ℝ}
    (hstart : partialSum p start ≤ y) :
    start < firstPositiveCrossing p hp start y := by
  have hspec := firstPositiveCrossing_spec hp start y
  by_contra hnot
  have heq : firstPositiveCrossing p hp start y = start :=
    Nat.le_antisymm (Nat.le_of_not_gt hnot) hspec.1
  rw [heq] at hspec
  exact (not_lt_of_ge hstart hspec.2)

theorem lt_firstNegativeCrossing {q : ℕ → ℝ}
    (hq : Tendsto (partialSum q) atTop atTop) {start : ℕ} {y : ℝ}
    (hstart : partialSum q start ≤ y) :
    start < firstNegativeCrossing q hq start y := by
  have hspec := firstNegativeCrossing_spec hq start y
  by_contra hnot
  have heq : firstNegativeCrossing q hq start y = start :=
    Nat.le_antisymm (Nat.le_of_not_gt hnot) hspec.1
  rw [heq] at hspec
  exact (not_lt_of_ge hstart hspec.2)

/-- Rudin's direct recursive counts.  Lean's `partialSum P m` contains the
zero-based entries `P 0, ..., P (m - 1)`.  Thus the count `m` is precisely
the one-based endpoint called `m` in `1.txt`: it means that the first `m`
terms have been used.  At stage `n+1` first add positive terms until the
upper target is crossed, then add negative magnitudes until the lower target
is crossed. -/
noncomputable def rudinCounts (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop)
    (α β : ℝ) : ℕ → ℕ × ℕ
  | 0 => (0, 0)
  | n + 1 =>
      let prev := rudinCounts P Q hP hQ α β n
      let m := firstPositiveCrossing P hP (prev.1 + 1)
        (upperTarget β n + partialSum Q prev.2)
      let k := firstNegativeCrossing Q hQ (prev.2 + 1)
        (partialSum P m - lowerTarget α n)
      (m, k)

noncomputable def rudinPosCount (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop)
    (α β : ℝ) (n : ℕ) : ℕ := (rudinCounts P Q hP hQ α β n).1

noncomputable def rudinNegCount (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop)
    (α β : ℝ) (n : ℕ) : ℕ := (rudinCounts P Q hP hQ α β n).2

theorem rudinPosCount_succ (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop)
    (α β : ℝ) (n : ℕ) :
    rudinPosCount P Q hP hQ α β (n + 1) =
      firstPositiveCrossing P hP (rudinPosCount P Q hP hQ α β n + 1)
        (upperTarget β n + partialSum Q (rudinNegCount P Q hP hQ α β n)) := rfl

theorem rudinNegCount_succ (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop)
    (α β : ℝ) (n : ℕ) :
    rudinNegCount P Q hP hQ α β (n + 1) =
      firstNegativeCrossing Q hQ (rudinNegCount P Q hP hQ α β n + 1)
        (partialSum P (rudinPosCount P Q hP hQ α β (n + 1)) - lowerTarget α n) := rfl

theorem rudin_upper_endpoint_crosses (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop)
    (α β : ℝ) (n : ℕ) :
    upperTarget β n <
      partialSum P (rudinPosCount P Q hP hQ α β (n + 1)) -
        partialSum Q (rudinNegCount P Q hP hQ α β n) := by
  rw [rudinPosCount_succ]
  have h := (firstPositiveCrossing_spec hP
    (rudinPosCount P Q hP hQ α β n + 1)
    (upperTarget β n + partialSum Q (rudinNegCount P Q hP hQ α β n))).2
  linarith

theorem rudin_lower_endpoint_crosses (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop)
    (α β : ℝ) (n : ℕ) :
    partialSum P (rudinPosCount P Q hP hQ α β (n + 1)) -
      partialSum Q (rudinNegCount P Q hP hQ α β (n + 1)) < lowerTarget α n := by
  rw [rudinNegCount_succ]
  have h := (firstNegativeCrossing_spec hQ
    (rudinNegCount P Q hP hQ α β n + 1)
    (partialSum P (rudinPosCount P Q hP hQ α β (n + 1)) - lowerTarget α n)).2
  linarith

/-- After a negative block, the next positive search really starts below its
new upper target.  This is the local fact that forces a nonempty positive
block; it replaces the previously duplicated global monotonicity chain. -/
theorem rudin_positive_start_le_succ (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop) {α β : ℝ} (hαβ : α ≤ β) (n : ℕ) :
    partialSum P (rudinPosCount P Q hP hQ α β (n + 1)) ≤
      upperTarget β (n + 1) + partialSum Q (rudinNegCount P Q hP hQ α β (n + 1)) := by
  have hlow := rudin_lower_endpoint_crosses P Q hP hQ α β n
  linarith [lowerTarget_lt_upperTarget hαβ n (n + 1)]

/-- The negative search at stage `n+1` starts below its lower target. -/
theorem rudin_negative_start_le (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop) {α β : ℝ} (hαβ : α ≤ β) (n : ℕ) :
    partialSum Q (rudinNegCount P Q hP hQ α β n) ≤
      partialSum P (rudinPosCount P Q hP hQ α β (n + 1)) - lowerTarget α n := by
  have hupp := rudin_upper_endpoint_crosses P Q hP hQ α β n
  linarith [lowerTarget_lt_upperTarget hαβ n n]

theorem rudinPosCount_succ_lt (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop) (α β : ℝ) (n : ℕ) :
    rudinPosCount P Q hP hQ α β (n + 1) <
      rudinPosCount P Q hP hQ α β (n + 2) := by
  rw [rudinPosCount_succ P Q hP hQ α β (n + 1)]
  have h := (firstPositiveCrossing_spec hP
    (rudinPosCount P Q hP hQ α β (n + 1) + 1)
    (upperTarget β (n + 1) + partialSum Q (rudinNegCount P Q hP hQ α β (n + 1)))).1
  omega

theorem rudinNegCount_succ_lt (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop) (α β : ℝ) (n : ℕ) :
    rudinNegCount P Q hP hQ α β n <
      rudinNegCount P Q hP hQ α β (n + 1) := by
  rw [rudinNegCount_succ]
  have h := (firstNegativeCrossing_spec hQ
    (rudinNegCount P Q hP hQ α β n + 1)
    (partialSum P (rudinPosCount P Q hP hQ α β (n + 1)) - lowerTarget α n)).1
  omega

theorem rudinPosCount_le_succ (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop)
    (α β : ℝ) (n : ℕ) :
    rudinPosCount P Q hP hQ α β n ≤ rudinPosCount P Q hP hQ α β (n + 1) := by
  rw [rudinPosCount_succ]
  have h := (firstPositiveCrossing_spec hP
    (rudinPosCount P Q hP hQ α β n + 1)
    (upperTarget β n + partialSum Q (rudinNegCount P Q hP hQ α β n))).1
  omega

theorem rudinPosCount_strictMono (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop) (α β : ℝ) :
    StrictMono (rudinPosCount P Q hP hQ α β) := by
  apply strictMono_nat_of_lt_succ
  intro n
  cases n with
  | zero =>
      change 0 < firstPositiveCrossing P hP 1 (upperTarget β 0 + partialSum Q 0)
      have h := (firstPositiveCrossing_spec hP 1
        (upperTarget β 0 + partialSum Q 0)).1
      omega
  | succ n => exact rudinPosCount_succ_lt P Q hP hQ α β n

theorem rudinNegCount_strictMono (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop) (α β : ℝ) :
    StrictMono (rudinNegCount P Q hP hQ α β) :=
  strictMono_nat_of_lt_succ (rudinNegCount_succ_lt P Q hP hQ α β)

/-- The direct bridge from Rudin's recursive counters to the four numerical
fields used by the clean block interface.  The remaining `covers` proof is
the global interval-cover statement, not another growth proof. -/
noncomputable def rudinPBlock (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop)
    (α β : ℝ) : ℕ → ℕ
  | 0 => 0
  | n + 1 => rudinPosCount P Q hP hQ α β (n + 1) + rudinNegCount P Q hP hQ α β n

noncomputable def rudinNBlock (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop)
    (α β : ℝ) : ℕ → ℕ
  | 0 => 0
  | n + 1 => rudinPosCount P Q hP hQ α β (n + 1) + rudinNegCount P Q hP hQ α β (n + 1)

theorem rudinPBlock_succ (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop)
    (α β : ℝ) (n : ℕ) :
    rudinPBlock P Q hP hQ α β (n + 1) =
      rudinPosCount P Q hP hQ α β (n + 1) + rudinNegCount P Q hP hQ α β n := rfl

theorem rudinNBlock_succ (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop)
    (α β : ℝ) (n : ℕ) :
    rudinNBlock P Q hP hQ α β (n + 1) =
      rudinPosCount P Q hP hQ α β (n + 1) + rudinNegCount P Q hP hQ α β (n + 1) := rfl

theorem firstPositiveCrossing_overshoot {p : ℕ → ℝ}
    (hp : Tendsto (partialSum p) atTop atTop) {start : ℕ} {y : ℝ}
    (hstart : partialSum p start ≤ y) :
    partialSum p (firstPositiveCrossing p hp start y) ≤
      y + p (firstPositiveCrossing p hp start y - 1) := by
  have hlt : start < firstPositiveCrossing p hp start y := by
    have hspec := firstPositiveCrossing_spec hp start y
    by_contra hnot
    have heq : firstPositiveCrossing p hp start y = start :=
      Nat.le_antisymm (Nat.le_of_not_gt hnot) hspec.1
    rw [heq] at hspec
    exact (not_lt_of_ge hstart hspec.2)
  have hpos : 0 < firstPositiveCrossing p hp start y :=
    lt_of_le_of_lt (Nat.zero_le start) hlt
  have hprev := firstPositiveCrossing_prev_le hp hstart
  have hsucc : firstPositiveCrossing p hp start y =
      (firstPositiveCrossing p hp start y - 1) + 1 := by omega
  rw [hsucc, partialSum, Finset.sum_range_succ]
  rw [show firstPositiveCrossing p hp start y - 1 + 1 - 1 =
    firstPositiveCrossing p hp start y - 1 by omega]
  change partialSum p (firstPositiveCrossing p hp start y - 1) +
    p (firstPositiveCrossing p hp start y - 1) ≤ _
  linarith

theorem firstNegativeCrossing_overshoot {q : ℕ → ℝ}
    (hq : Tendsto (partialSum q) atTop atTop) {start : ℕ} {y : ℝ}
    (hstart : partialSum q start ≤ y) :
    partialSum q (firstNegativeCrossing q hq start y) ≤
      y + q (firstNegativeCrossing q hq start y - 1) := by
  have hlt : start < firstNegativeCrossing q hq start y := by
    have hspec := firstNegativeCrossing_spec hq start y
    by_contra hnot
    have heq : firstNegativeCrossing q hq start y = start :=
      Nat.le_antisymm (Nat.le_of_not_gt hnot) hspec.1
    rw [heq] at hspec
    exact (not_lt_of_ge hstart hspec.2)
  have hpos : 0 < firstNegativeCrossing q hq start y :=
    lt_of_le_of_lt (Nat.zero_le start) hlt
  have hprev := firstNegativeCrossing_prev_le hq hstart
  have hsucc : firstNegativeCrossing q hq start y =
      (firstNegativeCrossing q hq start y - 1) + 1 := by omega
  rw [hsucc, partialSum, Finset.sum_range_succ]
  rw [show firstNegativeCrossing q hq start y - 1 + 1 - 1 =
    firstNegativeCrossing q hq start y - 1 by omega]
  change partialSum q (firstNegativeCrossing q hq start y - 1) +
    q (firstNegativeCrossing q hq start y - 1) ≤ _
  linarith

/-- Version of the overshoot estimate matching the one-based recursion:
the search begins at `prev + 1`, while the sum before the new block is
controlled at `prev`. -/
theorem firstPositiveCrossing_after_overshoot {p : ℕ → ℝ}
    (hp : Tendsto (partialSum p) atTop atTop) {prev : ℕ} {y : ℝ}
    (hprev : partialSum p prev ≤ y) :
    partialSum p (firstPositiveCrossing p hp (prev + 1) y) ≤
      y + p (firstPositiveCrossing p hp (prev + 1) y - 1) := by
  let m := firstPositiveCrossing p hp (prev + 1) y
  have hm : prev + 1 ≤ m := (firstPositiveCrossing_spec hp (prev + 1) y).1
  have hpred : partialSum p (m - 1) ≤ y := by
    by_cases heq : m = prev + 1
    · simpa [m, heq] using hprev
    · have hlt : m - 1 < m := by omega
      have hstart : prev + 1 ≤ m - 1 := by omega
      by_contra hnot
      have hcross : y < partialSum p (m - 1) := lt_of_not_ge hnot
      have hmin := Nat.find_min' (choose_positive_tail hp (prev + 1) y)
        (m := m - 1) ⟨hstart, hcross⟩
      change m ≤ m - 1 at hmin
      omega
  have hmpos : 0 < m := by omega
  have hm_succ : m = (m - 1) + 1 := by omega
  change partialSum p m ≤ y + p (m - 1)
  rw [hm_succ, partialSum, Finset.sum_range_succ]
  change partialSum p (m - 1) + p (m - 1) ≤ y + p (m - 1)
  linarith

theorem firstNegativeCrossing_after_overshoot {q : ℕ → ℝ}
    (hq : Tendsto (partialSum q) atTop atTop) {prev : ℕ} {y : ℝ}
    (hprev : partialSum q prev ≤ y) :
    partialSum q (firstNegativeCrossing q hq (prev + 1) y) ≤
      y + q (firstNegativeCrossing q hq (prev + 1) y - 1) := by
  exact firstPositiveCrossing_after_overshoot hq hprev

theorem rudin_upper_endpoint_overshoot (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop) {α β : ℝ} (hαβ : α ≤ β) (n : ℕ) :
    partialSum P (rudinPosCount P Q hP hQ α β (n + 2)) -
        partialSum Q (rudinNegCount P Q hP hQ α β (n + 1)) ≤
      upperTarget β (n + 1) +
        P (rudinPosCount P Q hP hQ α β (n + 2) - 1) := by
  rw [rudinPosCount_succ P Q hP hQ α β (n + 1)]
  have hov := firstPositiveCrossing_after_overshoot hP
    (rudin_positive_start_le_succ P Q hP hQ hαβ n)
  linarith

theorem rudin_lower_endpoint_overshoot (P Q : ℕ → ℝ)
    (hP : Tendsto (partialSum P) atTop atTop)
    (hQ : Tendsto (partialSum Q) atTop atTop) {α β : ℝ} (hαβ : α ≤ β) (n : ℕ) :
    lowerTarget α n - Q (rudinNegCount P Q hP hQ α β (n + 1) - 1) ≤
      partialSum P (rudinPosCount P Q hP hQ α β (n + 1)) -
        partialSum Q (rudinNegCount P Q hP hQ α β (n + 1)) := by
  rw [rudinNegCount_succ]
  have hov := firstNegativeCrossing_after_overshoot hQ
    (rudin_negative_start_le P Q hP hQ hαβ n)
  linarith

/-- The exact information needed to identify `liminf` and `limsup`; it is
separate from the permutation proof. -/
def EndpointWitness (g : ℕ → ℝ) (α β : ℝ) : Prop :=
  (∀ ε > 0, ∀ᶠ N in atTop, α - ε ≤ partialSum g N) ∧
  (∃ u : ℕ → ℕ, StrictMono u ∧ Tendsto (fun k => partialSum g (u k)) atTop (𝓝 α)) ∧
  (∀ ε > 0, ∀ᶠ N in atTop, partialSum g N ≤ β + ε) ∧
  (∃ v : ℕ → ℕ, StrictMono v ∧ Tendsto (fun k => partialSum g (v k)) atTop (𝓝 β))

/-- The two independent outputs of the direct block recursion: a bijective
index code and the endpoint information.  The latter already determines the
order limits by `liminf_limsup_of_endpointWitness`. -/
def DirectBlockEvidence (a : ℕ → ℝ) (α β : ℝ) : Prop :=
  ∃ indP indQ E,
    Function.Bijective (blockIndex indP indQ E) ∧
      EndpointWitness (blockSeries a indP indQ E) α β

/-- Once bijectivity of the explicit block index is proved, the desired
rearrangement equivalence is constructed without any further combinatorics. -/
theorem directBlockEvidence_rearrangement {a : ℕ → ℝ} {α β : ℝ}
    (h : DirectBlockEvidence a α β) :
    ∃ indP indQ E, ∃ e : ℕ ≃ ℕ,
      ∀ n, blockSeries a indP indQ E n = a (e n) := by
  rcases h with ⟨indP, indQ, E, hbij, -⟩
  let e : ℕ ≃ ℕ := Equiv.ofBijective (blockIndex indP indQ E) hbij
  refine ⟨indP, indQ, E, e, ?_⟩
  intro n
  rfl

/-- Endpoint bounds and endpoint subsequences determine the two order limits. -/
theorem liminf_limsup_of_endpointWitness {g : ℕ → ℝ} {α β : ℝ}
    (h : EndpointWitness g α β) :
    Filter.liminf (partialSum g) atTop = α ∧
      Filter.limsup (partialSum g) atTop = β := by
  rcases h with ⟨hlow, ⟨u, hu, hα⟩, hupp, ⟨v, hv, hβ⟩⟩
  have hlow₁ := hlow 1 (by norm_num : (0 : ℝ) < 1)
  have hupp₁ := hupp 1 (by norm_num : (0 : ℝ) < 1)
  have hInfBounded : Filter.IsBoundedUnder (fun x y : ℝ => x ≥ y) atTop (partialSum g) :=
    ⟨α - 1, hlow₁⟩
  have hInfCobounded : Filter.IsCoboundedUnder (fun x y : ℝ => x ≥ y) atTop (partialSum g) :=
    Filter.isCoboundedUnder_ge_of_eventually_le atTop hupp₁
  have hSupCobounded : Filter.IsCoboundedUnder (fun x y : ℝ => x ≤ y) atTop (partialSum g) :=
    Filter.isCoboundedUnder_le_of_eventually_le atTop hlow₁
  have hSupBounded : Filter.IsBoundedUnder (fun x y : ℝ => x ≤ y) atTop (partialSum g) :=
    ⟨β + 1, hupp₁⟩
  apply And.intro
  · apply le_antisymm
    · rw [Filter.liminf_le_iff hInfCobounded hInfBounded]
      intro y hy
      have hev : ∀ᶠ k in atTop, partialSum g (u k) < y :=
        (tendsto_order.1 hα).2 y hy
      exact hu.tendsto_atTop.frequently hev.frequently
    · rw [Filter.le_liminf_iff hInfCobounded hInfBounded]
      intro y hy
      have hε : 0 < (α - y) / 2 := by linarith
      filter_upwards [hlow ((α - y) / 2) hε] with N hN
      linarith
  · apply le_antisymm
    · rw [Filter.limsup_le_iff hSupCobounded hSupBounded]
      intro y hy
      have hε : 0 < (y - β) / 2 := by linarith
      filter_upwards [hupp ((y - β) / 2) hε] with N hN
      linarith
    · rw [Filter.le_limsup_iff hSupCobounded hSupBounded]
      intro y hy
      have hev : ∀ᶠ k in atTop, y < partialSum g (v k) :=
        (tendsto_order.1 hβ).1 y hy
      exact hv.tendsto_atTop.frequently hev.frequently

/-- TODO 1: construct the recursive block ends from the crossing recursion,
then prove that their explicit block code is bijective and has the endpoint
witness.  This is the sole remaining direct-construction obligation. -/
theorem direct_block_evidence_of_rudin_hypotheses
    {a : ℕ → ℝ} {α β : ℝ}
    (hαβ : α ≤ β)
    (S : SourceSplit a)
    (hPzero : Tendsto (signedPositive a S.indP) atTop (𝓝 0))
    (hQzero : Tendsto (signedNegative a S.indQ) atTop (𝓝 0))
    (hP : Tendsto (partialSum (signedPositive a S.indP)) atTop atTop)
    (hQ : Tendsto (partialSum (fun j => -signedNegative a S.indQ j)) atTop atTop) :
    DirectBlockEvidence a α β := by
  let P := signedPositive a S.indP
  let Q := fun j => - signedNegative a S.indQ j
  have hEnds : ∃ E : BlockEnds,
      E.posCount = rudinPosCount P Q hP hQ α β ∧
      E.negCount = rudinNegCount P Q hP hQ α β ∧
      E.pblock = rudinPBlock P Q hP hQ α β ∧
      E.nblock = rudinNBlock P Q hP hQ α β := by
    let hpstrict := rudinPosCount_strictMono P Q hP hQ α β
    let hnstrict := rudinNegCount_strictMono P Q hP hQ α β
    refine ⟨{
      posCount := rudinPosCount P Q hP hQ α β
      negCount := rudinNegCount P Q hP hQ α β
      pblock := rudinPBlock P Q hP hQ α β
      nblock := rudinNBlock P Q hP hQ α β
      posCount_zero := rfl
      negCount_zero := rfl
      pblock_zero := rfl
      nblock_zero := rfl
      neg_before_pos := ?_
      pos_before_neg := ?_
      pblock_eq := by intro k; rfl
      nblock_eq := by intro k; rfl
      covers := ?_ }, rfl, rfl, rfl, rfl⟩
    · intro k
      cases k with
      | zero =>
          change 0 < rudinPosCount P Q hP hQ α β 1 + rudinNegCount P Q hP hQ α β 0
          have h := hpstrict (Nat.zero_lt_succ 0)
          simp [rudinNegCount] at h ⊢
          omega
      | succ k =>
          change rudinPosCount P Q hP hQ α β (k + 1) + rudinNegCount P Q hP hQ α β (k + 1) <
            rudinPosCount P Q hP hQ α β (k + 2) + rudinNegCount P Q hP hQ α β (k + 1)
          exact Nat.add_lt_add_right (hpstrict (by omega)) _
    · intro k
      change rudinPosCount P Q hP hQ α β (k + 1) + rudinNegCount P Q hP hQ α β k <
        rudinPosCount P Q hP hQ α β (k + 1) + rudinNegCount P Q hP hQ α β (k + 1)
      exact Nat.add_lt_add_left (hnstrict (by omega)) _
    · intro ell hell
      have hNstrict : StrictMono (fun k => rudinNBlock P Q hP hQ α β (k + 1)) := by
        apply strictMono_nat_of_lt_succ
        intro k
        change rudinPosCount P Q hP hQ α β (k + 1) + rudinNegCount P Q hP hQ α β (k + 1) <
          rudinPosCount P Q hP hQ α β (k + 2) + rudinNegCount P Q hP hQ α β (k + 2)
        exact Nat.add_lt_add (hpstrict (by omega)) (hnstrict (by omega))
      have hexists : ∃ k, ell ≤ rudinNBlock P Q hP hQ α β (k + 1) := by
        rcases tendsto_atTop_atTop.mp hNstrict.tendsto_atTop ell with ⟨k, hk⟩
        exact ⟨k, hk k le_rfl⟩
      set k := Nat.find hexists with hkdef
      have hk : ell ≤ rudinNBlock P Q hP hQ α β (k + 1) := Nat.find_spec hexists
      have hprev : rudinNBlock P Q hP hQ α β k < ell := by
        rw [hkdef]
        by_cases hzero : Nat.find hexists = 0
        · rw [hzero]
          change 0 < ell
          exact hell
        · have hpos : 0 < Nat.find hexists := Nat.pos_of_ne_zero hzero
          apply Nat.lt_of_not_ge
          intro hle
          have hcandidate : ell ≤ rudinNBlock P Q hP hQ α β
              ((Nat.find hexists - 1) + 1) := by
            rw [Nat.sub_add_cancel (Nat.one_le_iff_ne_zero.mpr hzero)]
            exact hle
          have hmin := Nat.find_min' hexists (m := Nat.find hexists - 1) hcandidate
          omega
      by_cases hpos : ell ≤ rudinPBlock P Q hP hQ α β (k + 1)
      · exact Or.inl ⟨k, hprev, hpos⟩
      · exact Or.inr ⟨k, Nat.lt_of_not_ge hpos, hk⟩
  rcases hEnds with ⟨E, hpos, hneg, hpblock, hnblock⟩
  have hPositiveBlockSum : ∀ k,
      ∑ ℓ ∈ Finset.Ico (E.nblock k) (E.pblock (k + 1)),
        blockSeries a S.indP S.indQ E ℓ =
      partialSum P (E.posCount (k + 1)) - partialSum P (E.posCount k) := by
    /- TODO positive-block finite sum: rewrite each term with
    `blockTag_eq_inl_of_posBlock`, then use `Finset.sum_Ico_eq_sub`. -/
    intro k
    have hterm : ∀ ℓ ∈ Finset.Ico (E.nblock k) (E.pblock (k + 1)),
        blockSeries a S.indP S.indQ E ℓ =
          P (E.posCount k + (ℓ - E.nblock k)) := by
      intro ℓ hℓ
      have hmem : E.nblock k < ℓ + 1 ∧ ℓ + 1 ≤ E.pblock (k + 1) := by
        simpa [Finset.mem_Ico] using hℓ
      change a (blockIndex S.indP S.indQ E ℓ) = _
      rw [blockIndex_eq_sourceSplit_apply S E,
        blockTag_eq_inl_of_posBlock E hmem]
      change a (S.equiv (Sum.inl (E.posCount k + (ℓ + 1 - E.nblock k - 1)))) =
        a (S.equiv (Sum.inl (E.posCount k + (ℓ - E.nblock k))))
      congr 3
      omega
    calc
      _ = ∑ ℓ ∈ Finset.Ico (E.nblock k) (E.pblock (k + 1)),
          P (E.posCount k + (ℓ - E.nblock k)) :=
        Finset.sum_congr rfl (fun ℓ hℓ => hterm ℓ hℓ)
      _ = _ := by
        have hlen := nblock_add_posBlockLength E k
        rw [← hlen, Finset.sum_Ico_eq_sum_range]
        simp only [Nat.add_sub_cancel_left]
        have hsplit := Finset.sum_range_add P (E.posCount k)
          (E.posCount (k + 1) - E.posCount k)
        change (∑ i ∈ Finset.range (E.posCount (k + 1) - E.posCount k),
          P (E.posCount k + i)) = partialSum P (E.posCount (k + 1)) -
            partialSum P (E.posCount k)
        simp only [partialSum] at hsplit ⊢
        have hcount : E.posCount k + (E.posCount (k + 1) - E.posCount k) =
            E.posCount (k + 1) := by
          exact Nat.add_sub_of_le (E.posCount_strictMono.monotone (by omega))
        rw [hcount] at hsplit
        linarith
  have hNegativeBlockSum : ∀ k,
      ∑ ℓ ∈ Finset.Ico (E.pblock (k + 1)) (E.nblock (k + 1)),
        blockSeries a S.indP S.indQ E ℓ =
      -(partialSum Q (E.negCount (k + 1)) - partialSum Q (E.negCount k)) := by
    /- TODO negative-block finite sum: rewrite each term with
    `blockTag_eq_inr_of_negBlock`, then use `Finset.sum_Ico_eq_sub`. -/
    intro k
    have hterm : ∀ ℓ ∈ Finset.Ico (E.pblock (k + 1)) (E.nblock (k + 1)),
        blockSeries a S.indP S.indQ E ℓ =
          -Q (E.negCount k + (ℓ - E.pblock (k + 1))) := by
      intro ℓ hℓ
      have hmem : E.pblock (k + 1) < ℓ + 1 ∧ ℓ + 1 ≤ E.nblock (k + 1) := by
        simpa [Finset.mem_Ico] using hℓ
      change a (blockIndex S.indP S.indQ E ℓ) = _
      rw [blockIndex_eq_sourceSplit_apply S E,
        blockTag_eq_inr_of_negBlock E hmem]
      dsimp [Q, signedNegative, SourceSplit.indQ]
      rw [neg_neg]
      congr 3
      omega
    calc
      _ = ∑ ℓ ∈ Finset.Ico (E.pblock (k + 1)) (E.nblock (k + 1)),
          -Q (E.negCount k + (ℓ - E.pblock (k + 1))) :=
        Finset.sum_congr rfl (fun ℓ hℓ => hterm ℓ hℓ)
      _ = _ := by
        have hlen := pblock_add_negBlockLength E k
        rw [← hlen, Finset.sum_Ico_eq_sum_range]
        simp only [Nat.add_sub_cancel_left]
        rw [Finset.sum_neg_distrib]
        have hsplit := Finset.sum_range_add Q (E.negCount k)
          (E.negCount (k + 1) - E.negCount k)
        change -(∑ i ∈ Finset.range (E.negCount (k + 1) - E.negCount k),
          Q (E.negCount k + i)) = -(partialSum Q (E.negCount (k + 1)) -
            partialSum Q (E.negCount k))
        simp only [partialSum] at hsplit ⊢
        have hcount : E.negCount k + (E.negCount (k + 1) - E.negCount k) =
            E.negCount (k + 1) := by
          exact Nat.add_sub_of_le (E.negCount_strictMono.monotone (by omega))
        rw [hcount] at hsplit
        linarith
  have hEndpointSums : ∀ k,
      partialSum (blockSeries a S.indP S.indQ E) (E.pblock (k + 1)) =
        partialSum P (E.posCount (k + 1)) - partialSum Q (E.negCount k) ∧
      partialSum (blockSeries a S.indP S.indQ E) (E.nblock (k + 1)) =
        partialSum P (E.posCount (k + 1)) - partialSum Q (E.negCount (k + 1)) := by
    /- TODO endpoint-sum formula: finite induction, assembled from
    `hPositiveBlockSum` and `hNegativeBlockSum`. -/
    intro k
    induction k with
    | zero =>
        constructor
        · simp only [partialSum]
          rw [← Nat.Ico_zero_eq_range]
          simpa [partialSum, E.nblock_zero, E.posCount_zero, E.negCount_zero] using
            hPositiveBlockSum 0
        · simp only [partialSum]
          rw [← Nat.Ico_zero_eq_range]
          rw [← Finset.sum_Ico_consecutive (f := blockSeries a S.indP S.indQ E)
            (by omega) (E.pos_before_neg 0).le]
          simp only [Nat.Ico_zero_eq_range]
          have hp0 := hPositiveBlockSum 0
          rw [E.nblock_zero, Nat.Ico_zero_eq_range] at hp0
          rw [hp0, hNegativeBlockSum 0]
          simp [partialSum, E.posCount_zero, E.negCount_zero, sub_eq_add_neg]
    | succ k ih =>
        rcases ih with ⟨ihp, ihn⟩
        have hpnext : partialSum (blockSeries a S.indP S.indQ E) (E.pblock (k + 2)) =
            partialSum P (E.posCount (k + 2)) - partialSum Q (E.negCount (k + 1)) := by
          simp only [partialSum]
          rw [← Nat.Ico_zero_eq_range]
          rw [← Finset.sum_Ico_consecutive (f := blockSeries a S.indP S.indQ E)
            (by omega) (E.neg_before_pos (k + 1)).le]
          have hp := hPositiveBlockSum (k + 1)
          have ihn' : ∑ i ∈ Finset.Ico 0 (E.nblock (k + 1)),
              blockSeries a S.indP S.indQ E i =
              partialSum P (E.posCount (k + 1)) - partialSum Q (E.negCount (k + 1)) := by
            simpa [partialSum, Nat.Ico_zero_eq_range] using ihn
          rw [ihn', hp]
          simp only [partialSum] at hp ⊢
          linarith
        constructor
        · simpa [Nat.add_assoc] using hpnext
        · simp only [partialSum]
          rw [← Nat.Ico_zero_eq_range]
          rw [← Finset.sum_Ico_consecutive (f := blockSeries a S.indP S.indQ E)
            (by omega) (E.pos_before_neg (k + 1)).le]
          have hn := hNegativeBlockSum (k + 1)
          have hpnext' : ∑ i ∈ Finset.Ico 0 (E.pblock (k + 2)),
              blockSeries a S.indP S.indQ E i =
              partialSum P (E.posCount (k + 2)) - partialSum Q (E.negCount (k + 1)) := by
            simpa [partialSum, Nat.Ico_zero_eq_range] using hpnext
          rw [hpnext', hn]
          simp only [partialSum] at hn ⊢
          linarith
  have hPosLast : Tendsto
      (fun k => P (rudinPosCount P Q hP hQ α β (k + 2) - 1)) atTop (𝓝 0) := by
    have hc : Tendsto (rudinPosCount P Q hP hQ α β) atTop atTop :=
      (rudinPosCount_strictMono P Q hP hQ α β).tendsto_atTop
    have hshift : Tendsto (fun k : ℕ => k + 2) atTop atTop := by
      exact (show StrictMono (fun k : ℕ => k + 2) by
        intro i j hij
        change i + 2 < j + 2
        omega).tendsto_atTop
    have hidx : Tendsto (fun k => rudinPosCount P Q hP hQ α β (k + 2) - 1)
        atTop atTop := (tendsto_sub_atTop_nat 1).comp (hc.comp hshift)
    exact hPzero.comp hidx
  have hNegLast : Tendsto
      (fun k => Q (rudinNegCount P Q hP hQ α β (k + 1) - 1)) atTop (𝓝 0) := by
    have hc : Tendsto (rudinNegCount P Q hP hQ α β) atTop atTop :=
      (rudinNegCount_strictMono P Q hP hQ α β).tendsto_atTop
    have hshift : Tendsto (fun k : ℕ => k + 1) atTop atTop := by
      exact (show StrictMono (fun k : ℕ => k + 1) by
        intro i j hij
        change i + 1 < j + 1
        omega).tendsto_atTop
    have hidx : Tendsto (fun k => rudinNegCount P Q hP hQ α β (k + 1) - 1)
        atTop atTop := (tendsto_sub_atTop_nat 1).comp (hc.comp hshift)
    simpa [Q, Function.comp_def] using hQzero.neg.comp hidx
  have hPosTerm : ∀ {k ℓ},
      E.nblock k ≤ ℓ → ℓ < E.pblock (k + 1) →
      0 ≤ blockSeries a S.indP S.indQ E ℓ := by
    intro k ℓ hleft hright
    have hmem : E.nblock k < ℓ + 1 ∧ ℓ + 1 ≤ E.pblock (k + 1) := by omega
    change 0 ≤ a (blockIndex S.indP S.indQ E ℓ)
    rw [blockIndex_eq_sourceSplit_apply S E,
      blockTag_eq_inl_of_posBlock E hmem]
    exact (S.positive _).le
  have hNegTerm : ∀ {k ℓ},
      E.pblock (k + 1) ≤ ℓ → ℓ < E.nblock (k + 1) →
      blockSeries a S.indP S.indQ E ℓ ≤ 0 := by
    intro k ℓ hleft hright
    have hmem : E.pblock (k + 1) < ℓ + 1 ∧ ℓ + 1 ≤ E.nblock (k + 1) := by omega
    change a (blockIndex S.indP S.indQ E ℓ) ≤ 0
    rw [blockIndex_eq_sourceSplit_apply S E,
      blockTag_eq_inr_of_negBlock E hmem]
    exact (S.negative _).le
  have hPosPartialBounds : ∀ {k N},
      E.nblock k ≤ N → N ≤ E.pblock (k + 1) →
      partialSum (blockSeries a S.indP S.indQ E) (E.nblock k) ≤
        partialSum (blockSeries a S.indP S.indQ E) N ∧
      partialSum (blockSeries a S.indP S.indQ E) N ≤
        partialSum (blockSeries a S.indP S.indQ E) (E.pblock (k + 1)) := by
    intro k N hleft hright
    constructor
    · have hs : 0 ≤ ∑ i ∈ Finset.Ico (E.nblock k) N,
          blockSeries a S.indP S.indQ E i := by
        apply Finset.sum_nonneg
        intro i hi
        exact hPosTerm (Finset.mem_Ico.mp hi).1
          (lt_of_lt_of_le (Finset.mem_Ico.mp hi).2 hright)
      rw [Finset.sum_Ico_eq_sub _ hleft] at hs
      exact sub_nonneg.mp hs
    · have hs : 0 ≤ ∑ i ∈ Finset.Ico N (E.pblock (k + 1)),
          blockSeries a S.indP S.indQ E i := by
        apply Finset.sum_nonneg
        intro i hi
        exact hPosTerm (hleft.trans (Finset.mem_Ico.mp hi).1)
          (Finset.mem_Ico.mp hi).2
      rw [Finset.sum_Ico_eq_sub _ hright] at hs
      exact sub_nonneg.mp hs
  have hNegPartialBounds : ∀ {k N},
      E.pblock (k + 1) ≤ N → N ≤ E.nblock (k + 1) →
      partialSum (blockSeries a S.indP S.indQ E) (E.nblock (k + 1)) ≤
        partialSum (blockSeries a S.indP S.indQ E) N ∧
      partialSum (blockSeries a S.indP S.indQ E) N ≤
        partialSum (blockSeries a S.indP S.indQ E) (E.pblock (k + 1)) := by
    intro k N hleft hright
    constructor
    · have hs : ∑ i ∈ Finset.Ico N (E.nblock (k + 1)),
          blockSeries a S.indP S.indQ E i ≤ 0 := by
        apply Finset.sum_nonpos
        intro i hi
        exact hNegTerm (hleft.trans (Finset.mem_Ico.mp hi).1)
          (Finset.mem_Ico.mp hi).2
      rw [Finset.sum_Ico_eq_sub _ hright] at hs
      simpa [partialSum] using (sub_nonpos.mp hs)
    · have hs : ∑ i ∈ Finset.Ico (E.pblock (k + 1)) N,
          blockSeries a S.indP S.indQ E i ≤ 0 := by
        apply Finset.sum_nonpos
        intro i hi
        exact hNegTerm (Finset.mem_Ico.mp hi).1
          (lt_of_lt_of_le (Finset.mem_Ico.mp hi).2 hright)
      rw [Finset.sum_Ico_eq_sub _ hleft] at hs
      simpa [partialSum] using (sub_nonpos.mp hs)
  have hEndpoint : EndpointWitness (blockSeries a S.indP S.indQ E) α β := by
    refine ⟨?_, ?_, ?_, ?_⟩
    · /- TODO endpoint-lower-bound: every block minimum is eventually above `α`. -/
      intro ε hε
      have hL : Tendsto
          (fun k => lowerTarget α k - Q (rudinNegCount P Q hP hQ α β (k + 1) - 1))
          atTop (𝓝 α) := by
        simpa using (lowerTarget_tendsto α).sub hNegLast
      have hev : ∀ᶠ k in atTop,
          α - ε < lowerTarget α k -
            Q (rudinNegCount P Q hP hQ α β (k + 1) - 1) :=
        (tendsto_order.1 hL).1 _ (by linarith)
      rcases eventually_atTop.1 hev with ⟨K, hK⟩
      filter_upwards [eventually_ge_atTop (E.nblock (K + 1))] with N hN
      have hbase : 0 < E.nblock (K + 1) := by
        rw [← E.nblock_zero]
        exact E.nblock_strictMono (by omega)
      have hNpos : 0 < N := hbase.trans_le hN
      rcases E.covers N hNpos with ⟨k, hkleft, hkright⟩ | ⟨k, hkleft, hkright⟩
      · have hkstage : K + 1 ≤ k := by
          by_contra hnot
          have hkle : k ≤ K := by omega
          have hmono := E.nblock_strictMono.monotone (show k + 1 ≤ K + 1 by omega)
          have hgap := E.pos_before_neg k
          omega
        have hkpos : 0 < k := by omega
        have hkpred : K ≤ k - 1 := by omega
        have hend : α - ε ≤ partialSum (blockSeries a S.indP S.indQ E) (E.nblock k) := by
          have htail := (hK (k - 1) hkpred).le
          have hover := rudin_lower_endpoint_overshoot P Q hP hQ hαβ (k - 1)
          have hsum := (hEndpointSums (k - 1)).2
          rw [← hpos, ← hneg] at hover
          rw [← hneg] at htail
          have hsucc : k - 1 + 1 = k := by omega
          rw [hsucc] at htail hover hsum
          linarith
        exact hend.trans (hPosPartialBounds hkleft.le hkright).1
      · have hkstage : K ≤ k := by
          by_contra hnot
          have hmono := E.nblock_strictMono (show k + 1 < K + 1 by omega)
          omega
        have htail := (hK k hkstage).le
        have hover := rudin_lower_endpoint_overshoot P Q hP hQ hαβ k
        have hsum := (hEndpointSums k).2
        rw [← hpos, ← hneg] at hover
        rw [← hneg] at htail
        have hend : α - ε ≤
            partialSum (blockSeries a S.indP S.indQ E) (E.nblock (k + 1)) := by
          linarith
        exact hend.trans (hNegPartialBounds hkleft.le hkright).1
    · /- TODO endpoint-lower-limit: negative block endpoints converge to `α`. -/
      refine ⟨fun k => E.nblock (k + 1), ?_, ?_⟩
      · apply E.nblock_strictMono.comp
        intro i j hij
        change i + 1 < j + 1
        omega
      · have hdirect : Tendsto
            (fun k => partialSum P (rudinPosCount P Q hP hQ α β (k + 1)) -
              partialSum Q (rudinNegCount P Q hP hQ α β (k + 1))) atTop (𝓝 α) := by
          have hlower : Tendsto
              (fun k => lowerTarget α k - Q (rudinNegCount P Q hP hQ α β (k + 1) - 1))
              atTop (𝓝 α) := by
            simpa using (lowerTarget_tendsto α).sub hNegLast
          have hs : Tendsto
              (fun k => partialSum P (rudinPosCount P Q hP hQ α β (k + 1)) -
                partialSum Q (rudinNegCount P Q hP hQ α β (k + 1)))
              atTop (𝓝 α) := by
            apply tendsto_of_tendsto_of_tendsto_of_le_of_le'
              hlower (lowerTarget_tendsto α)
            · exact Eventually.of_forall fun k =>
                rudin_lower_endpoint_overshoot P Q hP hQ hαβ k
            · exact Eventually.of_forall fun k =>
                (rudin_lower_endpoint_crosses P Q hP hQ α β k).le
          exact hs
        apply hdirect.congr'
        exact Eventually.of_forall fun k => by
          rw [← hpos, ← hneg]
          exact (hEndpointSums k).2.symm
    · /- TODO endpoint-upper-bound: every block maximum is eventually below `β`. -/
      intro ε hε
      have hshift : Tendsto (fun k : ℕ => k + 1) atTop atTop := by
        exact (show StrictMono (fun k : ℕ => k + 1) by
          intro i j hij
          change i + 1 < j + 1
          omega).tendsto_atTop
      have hU : Tendsto
          (fun k => upperTarget β (k + 1) +
            P (rudinPosCount P Q hP hQ α β (k + 2) - 1)) atTop (𝓝 β) := by
        have ht := (upperTarget_tendsto β).comp hshift
        simpa using ht.add hPosLast
      have hev : ∀ᶠ k in atTop,
          upperTarget β (k + 1) +
            P (rudinPosCount P Q hP hQ α β (k + 2) - 1) < β + ε :=
        (tendsto_order.1 hU).2 _ (by linarith)
      rcases eventually_atTop.1 hev with ⟨K, hK⟩
      filter_upwards [eventually_ge_atTop (E.nblock (K + 2))] with N hN
      have hbase : 0 < E.nblock (K + 2) := by
        rw [← E.nblock_zero]
        exact E.nblock_strictMono (by omega)
      have hNpos : 0 < N := hbase.trans_le hN
      rcases E.covers N hNpos with ⟨k, hkleft, hkright⟩ | ⟨k, hkleft, hkright⟩
      · have hkstage : K + 2 ≤ k := by
          by_contra hnot
          have hkle : k + 1 ≤ K + 2 := by omega
          have hmono := E.nblock_strictMono.monotone hkle
          have hgap := E.pos_before_neg k
          omega
        have hkpred : K ≤ k - 1 := by omega
        have htail := (hK (k - 1) hkpred).le
        have hover := rudin_upper_endpoint_overshoot P Q hP hQ hαβ (k - 1)
        have hsum := (hEndpointSums k).1
        rw [← hpos, ← hneg] at hover
        rw [← hpos] at htail
        have hsucc1 : k - 1 + 1 = k := by omega
        have hsucc2 : k - 1 + 2 = k + 1 := by omega
        rw [hsucc1, hsucc2] at htail hover
        have hend : partialSum (blockSeries a S.indP S.indQ E) (E.pblock (k + 1)) ≤ β + ε := by
          linarith
        exact (hPosPartialBounds hkleft.le hkright).2.trans hend
      · have hkstage : K + 1 ≤ k := by
          by_contra hnot
          have hmono := E.nblock_strictMono (show k + 1 < K + 2 by omega)
          omega
        have hkpred : K ≤ k - 1 := by omega
        have htail := (hK (k - 1) hkpred).le
        have hover := rudin_upper_endpoint_overshoot P Q hP hQ hαβ (k - 1)
        have hsum := (hEndpointSums k).1
        rw [← hpos, ← hneg] at hover
        rw [← hpos] at htail
        have hsucc1 : k - 1 + 1 = k := by omega
        have hsucc2 : k - 1 + 2 = k + 1 := by omega
        rw [hsucc1, hsucc2] at htail hover
        have hend : partialSum (blockSeries a S.indP S.indQ E) (E.pblock (k + 1)) ≤ β + ε := by
          linarith
        exact (hNegPartialBounds hkleft.le hkright).2.trans hend
    · /- TODO endpoint-upper-limit: positive block endpoints converge to `β`. -/
      refine ⟨fun k => E.pblock (k + 2), ?_, ?_⟩
      · apply E.pblock_strictMono.comp
        intro i j hij
        change i + 2 < j + 2
        omega
      · have hdirect : Tendsto
            (fun k => partialSum P (rudinPosCount P Q hP hQ α β (k + 2)) -
              partialSum Q (rudinNegCount P Q hP hQ α β (k + 1))) atTop (𝓝 β) := by
          have hshift : Tendsto (fun k : ℕ => k + 1) atTop atTop := by
            exact (show StrictMono (fun k : ℕ => k + 1) by
              intro i j hij
              change i + 1 < j + 1
              omega).tendsto_atTop
          have htarget : Tendsto (fun k => upperTarget β (k + 1)) atTop (𝓝 β) :=
            (upperTarget_tendsto β).comp hshift
          have hupper : Tendsto
              (fun k => upperTarget β (k + 1) +
                P (rudinPosCount P Q hP hQ α β (k + 2) - 1)) atTop (𝓝 β) := by
            simpa using htarget.add hPosLast
          have hs : Tendsto
              (fun k => partialSum P (rudinPosCount P Q hP hQ α β (k + 2)) -
                partialSum Q (rudinNegCount P Q hP hQ α β (k + 1)))
              atTop (𝓝 β) := by
            apply tendsto_of_tendsto_of_tendsto_of_le_of_le'
              htarget hupper
            · exact Eventually.of_forall fun k =>
                (rudin_upper_endpoint_crosses P Q hP hQ α β (k + 1)).le
            · exact Eventually.of_forall fun k =>
                rudin_upper_endpoint_overshoot P Q hP hQ hαβ k
          exact hs
        apply hdirect.congr'
        exact Eventually.of_forall fun k => by
          rw [← hpos, ← hneg]
          simpa [Nat.add_assoc] using (hEndpointSums (k + 1)).1.symm
  refine ⟨S.indP, S.indQ, E, ?_, hEndpoint⟩
  exact blockIndex_bijective_of_blockTag_bijective S E
    (blockTag_bijective_of_block_recursion E)

/-- Top-level direct Rudin construction.  Rearrangement and order limits are
separate consequences of the returned evidence.

> **Entry**: analysis.series.riemann-rearrangement
-/
theorem direct_rudin_rearrangement
    {a : ℕ → ℝ} {α β : ℝ}
    (hαβ : α ≤ β)
    (S : SourceSplit a)
    (hPzero : Tendsto (signedPositive a S.indP) atTop (𝓝 0))
    (hQzero : Tendsto (signedNegative a S.indQ) atTop (𝓝 0))
    (hP : Tendsto (partialSum (signedPositive a S.indP)) atTop atTop)
    (hQ : Tendsto (partialSum (fun j => -signedNegative a S.indQ j)) atTop atTop) :
    DirectBlockEvidence a α β := by
  exact direct_block_evidence_of_rudin_hypotheses hαβ S hPzero hQzero hP hQ

end SandronesLibrary.Analysis.Series.RudinDirect
