/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Topology.Foundation

/-!
# Basic constructions of textbook topologies

This file constructs induced, subspace, and product topologies from the open-set axioms developed
in `Topology.Foundation`.

Current entry:

* `topology.foundation.constructions`.
-/

open Set Function

namespace SandronesLibrary.Topology.TextbookTopology

variable {X Y Z : Type*}

/-- The topology induced on `X` by a map `f : X → Y`: its open sets are exactly preimages of open
sets of `Y`.

> **Entry**: topology.foundation.constructions -/
def induced (f : X → Y) (τY : TextbookTopology Y) : TextbookTopology X where
  IsOpen s := ∃ v, τY.IsOpen v ∧ f ⁻¹' v = s
  isOpen_univ := ⟨univ, τY.isOpen_univ, preimage_univ⟩
  isOpen_inter s t hs ht := by
    obtain ⟨u, hu, rfl⟩ := hs
    obtain ⟨v, hv, rfl⟩ := ht
    exact ⟨u ∩ v, τY.isOpen_inter u v hu hv, preimage_inter⟩
  isOpen_sUnion S hS := by
    classical
    let V : Set (Set Y) := {v | τY.IsOpen v ∧ f ⁻¹' v ∈ S}
    refine ⟨⋃₀ V, τY.isOpen_sUnion V (fun v hv ↦ hv.1), ?_⟩
    ext x
    simp only [mem_preimage, mem_sUnion]
    constructor
    · rintro ⟨v, ⟨hvopen, hvS⟩, hxv⟩
      exact ⟨f ⁻¹' v, hvS, hxv⟩
    · rintro ⟨s, hsS, hxs⟩
      obtain ⟨v, hvopen, rfl⟩ := hS s hsS
      exact ⟨v, ⟨hvopen, hsS⟩, hxs⟩

/-- The subspace topology is induced by the inclusion map. -/
def subspace (s : Set X) (τX : TextbookTopology X) : TextbookTopology s :=
  induced Subtype.val τX

/-- Open sets in a subspace are precisely preimages of ambient open sets. -/
theorem isOpen_subspace_iff (s : Set X) (τX : TextbookTopology X) (u : Set s) :
    (subspace s τX).IsOpen u ↔ ∃ v, τX.IsOpen v ∧ Subtype.val ⁻¹' v = u :=
  Iff.rfl

/-- The inclusion of a subspace into its ambient space is continuous. -/
theorem continuous_subtype_val (s : Set X) (τX : TextbookTopology X) :
    Continuous (subspace s τX) τX (Subtype.val : s → X) := by
  intro v hv
  exact ⟨v, hv, rfl⟩

/-- The product topology: every point of an open set lies in an open rectangle contained in it.

> **Entry**: topology.foundation.constructions -/
def product (τX : TextbookTopology X) (τY : TextbookTopology Y) :
    TextbookTopology (X × Y) where
  IsOpen w := ∀ p ∈ w, ∃ u v, τX.IsOpen u ∧ τY.IsOpen v ∧ p ∈ u ×ˢ v ∧ u ×ˢ v ⊆ w
  isOpen_univ := by
    intro p hp
    exact ⟨univ, univ, τX.isOpen_univ, τY.isOpen_univ, by simp, by simp⟩
  isOpen_inter s t hs ht := by
    intro p hp
    obtain ⟨u₁, v₁, hu₁, hv₁, hp₁, hsub₁⟩ := hs p hp.1
    obtain ⟨u₂, v₂, hu₂, hv₂, hp₂, hsub₂⟩ := ht p hp.2
    refine ⟨u₁ ∩ u₂, v₁ ∩ v₂, τX.isOpen_inter _ _ hu₁ hu₂,
      τY.isOpen_inter _ _ hv₁ hv₂, ?_, ?_⟩
    · exact ⟨⟨hp₁.1, hp₂.1⟩, ⟨hp₁.2, hp₂.2⟩⟩
    · intro q hq
      exact ⟨hsub₁ ⟨hq.1.1, hq.2.1⟩, hsub₂ ⟨hq.1.2, hq.2.2⟩⟩
  isOpen_sUnion S hS := by
    intro p hp
    obtain ⟨w, hwS, hpw⟩ := hp
    obtain ⟨u, v, hu, hv, hp', hsub⟩ := hS w hwS p hpw
    exact ⟨u, v, hu, hv, hp', fun q hq ↦ ⟨w, hwS, hsub hq⟩⟩

/-- An open rectangle is open in the product topology. -/
theorem isOpen_prod {τX : TextbookTopology X} {τY : TextbookTopology Y}
    {u : Set X} {v : Set Y} (hu : τX.IsOpen u) (hv : τY.IsOpen v) :
    (product τX τY).IsOpen (u ×ˢ v) := by
  intro p hp
  exact ⟨u, v, hu, hv, hp, Subset.rfl⟩

/-- The first projection from a product is continuous. -/
theorem continuous_fst (τX : TextbookTopology X) (τY : TextbookTopology Y) :
    Continuous (product τX τY) τX Prod.fst := by
  intro u hu
  have hpre : Prod.fst ⁻¹' u = u ×ˢ (univ : Set Y) := by ext; simp
  rw [hpre]
  exact isOpen_prod hu τY.isOpen_univ

/-- The second projection from a product is continuous. -/
theorem continuous_snd (τX : TextbookTopology X) (τY : TextbookTopology Y) :
    Continuous (product τX τY) τY Prod.snd := by
  intro v hv
  have hpre : Prod.snd ⁻¹' v = (univ : Set X) ×ˢ v := by ext; simp
  rw [hpre]
  exact isOpen_prod τX.isOpen_univ hv

end SandronesLibrary.Topology.TextbookTopology
