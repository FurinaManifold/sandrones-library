/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.Topology.FundamentalGroupTrivialityStandard
import Mathlib.Analysis.SpecialFunctions.Complex.Circle
import Mathlib.Topology.Homotopy.Lifting
import Mathlib.Algebra.Group.Equiv.Opposite
import Mathlib.Algebra.Module.Torsion.Free

/-!
# 圆周基本群与绕数

本文件沿指数覆盖 `Circle.exp : ℝ → Circle` 建立教材中的圆周基本群计算：环路从零点提升到
实直线，其终点是唯一的 `2π` 整数倍；这个整数给出绕数同态。随后分别证明该同态单射和满射，
最终推出 `π₁(S¹, 1) ≃ Multiplicative ℤ`。最终等价不是对 Mathlib 通用覆盖空间等价的改名包装。

当前条目：

* `topology.fundamental-group.circle-standard`。
-/

open scoped unitInterval
open Set

namespace SandronesLibrary.Topology

noncomputable section

private def circleExpBasepoint : Circle.exp ⁻¹' ({1} : Set Circle) :=
  ⟨0, by simp⟩

private theorem circlePeriod_ne_zero : (2 * Real.pi : ℝ) ≠ 0 :=
  mul_ne_zero (by norm_num) Real.pi_ne_zero

/-- The deck transformations of the exponential covering are the translations by unique
integer multiples of `2π`.

> **Entry**: topology.fundamental-group.circle-standard -/
def circleDeckIntEquiv : AddSubgroup.zmultiples (2 * Real.pi) ≃+ ℤ where
  toFun z := Classical.choose (AddSubgroup.mem_zmultiples_iff.mp z.property)
  invFun n := ⟨n • (2 * Real.pi), AddSubgroup.mem_zmultiples_iff.mpr ⟨n, rfl⟩⟩
  left_inv z := Subtype.ext (Classical.choose_spec
    (AddSubgroup.mem_zmultiples_iff.mp z.property))
  right_inv n := by
    apply smul_left_injective ℤ circlePeriod_ne_zero
    exact Classical.choose_spec
      (AddSubgroup.mem_zmultiples_iff.mp
        (show n • (2 * Real.pi) ∈ AddSubgroup.zmultiples (2 * Real.pi) by
          exact AddSubgroup.mem_zmultiples_iff.mpr ⟨n, rfl⟩))
  map_add' a b := by
    apply smul_left_injective ℤ circlePeriod_ne_zero
    change
      Classical.choose (AddSubgroup.mem_zmultiples_iff.mp (a + b).property) •
          (2 * Real.pi) =
        (Classical.choose (AddSubgroup.mem_zmultiples_iff.mp a.property) +
          Classical.choose (AddSubgroup.mem_zmultiples_iff.mp b.property)) •
            (2 * Real.pi)
    rw [Classical.choose_spec (AddSubgroup.mem_zmultiples_iff.mp (a + b).property)]
    simp only [add_smul]
    rw [Classical.choose_spec (AddSubgroup.mem_zmultiples_iff.mp a.property)]
    rw [Classical.choose_spec (AddSubgroup.mem_zmultiples_iff.mp b.property)]
    rfl

/-- Under `circleDeckIntEquiv`, the integer `n` corresponds exactly to translation by `n • 2π`. -/
theorem circleDeckIntEquiv_symm_apply_coe (n : ℤ) :
    ((circleDeckIntEquiv.symm n : AddSubgroup.zmultiples (2 * Real.pi)) : ℝ) =
      n • (2 * Real.pi) :=
  rfl

private def mulOppositeDeckEquivInt :
    (Multiplicative (AddSubgroup.zmultiples (2 * Real.pi)))ᵐᵒᵖ ≃* Multiplicative ℤ :=
  MulOpposite.opMulEquiv.symm.trans (AddEquiv.toMultiplicative circleDeckIntEquiv)

/-- The lift through `Circle.exp` of a based circle loop, chosen to start at zero. -/
def circleLoopLift (g : Path (1 : Circle) 1) : C(unitInterval, ℝ) :=
  Circle.isCoveringMap_exp.liftPath g 0 (by simp)

/-- The chosen circle-loop lift starts at zero. -/
theorem circleLoopLift_zero (g : Path (1 : Circle) 1) : circleLoopLift g 0 = 0 := by
  exact Circle.isCoveringMap_exp.liftPath_zero g 0 (by simp)

/-- Projecting the chosen lift by `Circle.exp` recovers the original loop pointwise. -/
theorem circleLoopLift_exp (g : Path (1 : Circle) 1) (t : unitInterval) :
    Circle.exp (circleLoopLift g t) = g t := by
  exact congr_fun (Circle.isCoveringMap_exp.liftPath_lifts g 0 (by simp)) t

/-- The winding homomorphism records, as an integer, the deck transformation reached by lifting
a based loop through the exponential covering. -/
def circleWindingHom : FundamentalGroup Circle 1 →* Multiplicative ℤ :=
  mulOppositeDeckEquivInt.toMonoidHom.comp
    (Circle.isAddQuotientCoveringMap_exp.fundamentalGroupToMulOpposite circleExpBasepoint)

/-- A loop has winding number `n` exactly when its zero-based lift ends at `n • 2π`. -/
theorem circleWindingHom_eq_iff_lift_endpoint (g : Path (1 : Circle) 1) (n : ℤ) :
    circleWindingHom (FundamentalGroup.fromPath (Path.Homotopic.Quotient.mk g)) =
        Multiplicative.ofAdd n ↔
      circleLoopLift g 1 = n • (2 * Real.pi) := by
  change mulOppositeDeckEquivInt
      (Circle.isAddQuotientCoveringMap_exp.fundamentalGroupToMulOpposite
        circleExpBasepoint (FundamentalGroup.fromPath (Path.Homotopic.Quotient.mk g))) = _ ↔ _
  let core := Circle.isAddQuotientCoveringMap_exp.fundamentalGroupToMulOpposite
    circleExpBasepoint (FundamentalGroup.fromPath (Path.Homotopic.Quotient.mk g))
  have hdeck :
      ((mulOppositeDeckEquivInt.symm (Multiplicative.ofAdd n)).unop.toAdd : ℝ) =
        n • (2 * Real.pi) := by
    rfl
  constructor
  · intro h
    have hcore : core = mulOppositeDeckEquivInt.symm (Multiplicative.ofAdd n) := by
      apply mulOppositeDeckEquivInt.injective
      simpa [core] using h
    have hm :=
      (Circle.isAddQuotientCoveringMap_exp.fundamentalGroupToMulOpposite_apply_eq_Iff).mp hcore
    change ((mulOppositeDeckEquivInt.symm (Multiplicative.ofAdd n)).unop.toAdd : ℝ) + 0 =
      circleLoopLift g 1 at hm
    simpa [hdeck] using hm.symm
  · intro h
    have hm :
        ((mulOppositeDeckEquivInt.symm (Multiplicative.ofAdd n)).unop.toAdd : ℝ) + 0 =
          circleLoopLift g 1 := by simpa [hdeck] using h.symm
    have hcore : core = mulOppositeDeckEquivInt.symm (Multiplicative.ofAdd n) :=
      (Circle.isAddQuotientCoveringMap_exp.fundamentalGroupToMulOpposite_apply_eq_Iff).mpr hm
    simpa [core] using congr_arg mulOppositeDeckEquivInt hcore

/-- Two based circle-loop classes with the same winding number are equal. -/
theorem circleWindingHom_injective : Function.Injective circleWindingHom := by
  exact mulOppositeDeckEquivInt.injective.comp
    (Circle.isAddQuotientCoveringMap_exp.fundamentalGroupToMulOpposite_injective
      circleExpBasepoint)

/-- Every integer occurs as the winding number of a based circle loop. -/
theorem circleWindingHom_surjective : Function.Surjective circleWindingHom := by
  exact mulOppositeDeckEquivInt.surjective.comp
    (Circle.isAddQuotientCoveringMap_exp.fundamentalGroupToMulOpposite_surjective
      circleExpBasepoint)

/-- The fundamental group of the circle is infinite cyclic. The equivalence is induced by the
public winding homomorphism and its separately proved bijectivity. -/
def circleFundamentalGroupEquivInt : FundamentalGroup Circle 1 ≃* Multiplicative ℤ :=
  MulEquiv.ofBijective circleWindingHom
    ⟨circleWindingHom_injective, circleWindingHom_surjective⟩

end


end SandronesLibrary.Topology
