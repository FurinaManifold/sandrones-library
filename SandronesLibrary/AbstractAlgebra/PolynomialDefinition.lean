/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import SandronesLibrary.AbstractAlgebra.RingDivisibility

/-!
# 抽象代数 / 多项式的本库定义

本模块从教材定义出发，把多项式定义为自然数指标、非零项有限的系数序列。公开对象
`PolynomialSequence R` 是 Sandrone's Library 自己的多项式概念，而不是 Mathlib
`Polynomial R` 的别名、包装定理或记号替换。系数、环运算、常数多项式、不定元、次数、
求值、根与整除性都以该本库类型公开。

Mathlib 的 `Polynomial` 与 `Finsupp` 只承担两类职责：具名转换桥及其逆定理，以及
`transported...` 私有定义和私有证明引理中的运算实现。上层教材定理因而只需依赖本库
`PolynomialSequence`、`RingHomomorphism`、`IntegralDomainAxioms` 和 `DividesElement`。

> **Entry**: abstract-algebra.poly.def
-/

namespace SandronesLibrary.AbstractAlgebra.PolynomialDefinition

open SandronesLibrary.AbstractAlgebra.Ring

set_option linter.style.haveILetI false

/-- **本库多项式定义**：由系数函数 `ℕ → R` 及其非零位置集合有限的证明组成。
> **Entry**: abstract-algebra.poly.def
-/
structure PolynomialSequence (R : Type*) [Zero R] where
  coefficients : ℕ → R
  finiteSupport : {n | coefficients n ≠ 0}.Finite

/-- `coefficient p n` 是本库多项式 `p` 的 `X^n` 项系数。
> **Entry**: abstract-algebra.poly.def
-/
def coefficient {R : Type*} [Zero R] (p : PolynomialSequence R) (n : ℕ) : R :=
  p.coefficients n

/-- **多项式外延性**：每一项系数都相同的两个本库多项式相等。
> **Entry**: abstract-algebra.poly.def
-/
@[ext] theorem ext {R : Type*} [Zero R] {p q : PolynomialSequence R}
    (h : ∀ n, coefficient p n = coefficient q n) : p = q := by
  cases p with
  | mk pc pf =>
    cases q with
    | mk qc qf =>
      simp only [coefficient] at h
      have : pc = qc := funext h
      subst qc
      rfl

private noncomputable def coefficientFinsupp {R : Type*} [Zero R]
    (p : PolynomialSequence R) : ℕ →₀ R :=
  Finsupp.onFinset p.finiteSupport.toFinset p.coefficients (by
    intro n hn
    simpa using hn)

/-- **到 Mathlib 的具名桥**：把本库有限支撑系数序列转换为 Mathlib `Polynomial`。
这是明确的兼容边界，不改变本库多项式作为公开教材概念的地位。
> **Entry**: abstract-algebra.poly.def
-/
noncomputable def toMathlibPolynomial {R : Type*} [Semiring R]
    (p : PolynomialSequence R) : Polynomial R :=
  Polynomial.ofFinsupp (AddMonoidAlgebra.ofCoeff (coefficientFinsupp p))

/-- **从 Mathlib 返回本库的具名桥**：读取 Mathlib 多项式的系数与有限支撑证明。
> **Entry**: abstract-algebra.poly.def
-/
def fromMathlibPolynomial {R : Type*} [Semiring R]
    (p : Polynomial R) : PolynomialSequence R where
  coefficients := p.coeff
  finiteSupport := by
    refine p.support.finite_toSet.subset ?_
    intro n hn
    exact Polynomial.mem_support_iff.mpr hn

/-- 到 Mathlib 的具名桥保持每一项系数。
> **Entry**: abstract-algebra.poly.def
-/
theorem coefficient_toMathlibPolynomial {R : Type*} [Semiring R]
    (p : PolynomialSequence R) (n : ℕ) :
    (toMathlibPolynomial p).coeff n = coefficient p n := by
  simp [toMathlibPolynomial, coefficientFinsupp, coefficient]

/-- 从 Mathlib 返回本库的具名桥保持每一项系数。
> **Entry**: abstract-algebra.poly.def
-/
theorem coefficient_fromMathlibPolynomial {R : Type*} [Semiring R]
    (p : Polynomial R) (n : ℕ) :
    coefficient (fromMathlibPolynomial p) n = p.coeff n := by
  rfl

/-- 两个具名桥在“Mathlib → 本库 → Mathlib”方向互为逆映射。
> **Entry**: abstract-algebra.poly.def
-/
theorem toMathlibPolynomial_fromMathlibPolynomial {R : Type*} [Semiring R]
    (p : Polynomial R) :
    toMathlibPolynomial (fromMathlibPolynomial p) = p := by
  ext n
  rw [coefficient_toMathlibPolynomial, coefficient_fromMathlibPolynomial]

/-- 两个具名桥在“本库 → Mathlib → 本库”方向互为逆映射。
> **Entry**: abstract-algebra.poly.def
-/
theorem fromMathlibPolynomial_toMathlibPolynomial {R : Type*} [Semiring R]
    (p : PolynomialSequence R) :
    fromMathlibPolynomial (toMathlibPolynomial p) = p := by
  ext n
  rw [coefficient_fromMathlibPolynomial, coefficient_toMathlibPolynomial]

private noncomputable def transportedZero {R : Type*} [Semiring R] :
    PolynomialSequence R := fromMathlibPolynomial 0
private noncomputable def transportedOne {R : Type*} [Semiring R] :
    PolynomialSequence R := fromMathlibPolynomial 1
private noncomputable def transportedAdd {R : Type*} [Semiring R]
    (p q : PolynomialSequence R) : PolynomialSequence R :=
  fromMathlibPolynomial (toMathlibPolynomial p + toMathlibPolynomial q)
private noncomputable def transportedMul {R : Type*} [Semiring R]
    (p q : PolynomialSequence R) : PolynomialSequence R :=
  fromMathlibPolynomial (toMathlibPolynomial p * toMathlibPolynomial q)
private noncomputable def transportedNeg {R : Type*} [Ring R]
    (p : PolynomialSequence R) : PolynomialSequence R :=
  fromMathlibPolynomial (-toMathlibPolynomial p)

/-- 本库多项式的零元实例；运算由私有有限支撑实现传输。
> **Entry**: abstract-algebra.poly.def
-/
noncomputable instance {R : Type*} [Semiring R] : Zero (PolynomialSequence R) :=
  ⟨transportedZero⟩
/-- 本库多项式的乘法单位元实例。
> **Entry**: abstract-algebra.poly.def
-/
noncomputable instance {R : Type*} [Semiring R] : One (PolynomialSequence R) :=
  ⟨transportedOne⟩
/-- 本库多项式的逐系数加法实例。
> **Entry**: abstract-algebra.poly.def
-/
noncomputable instance {R : Type*} [Semiring R] : Add (PolynomialSequence R) :=
  ⟨transportedAdd⟩
/-- 本库多项式的卷积乘法实例。
> **Entry**: abstract-algebra.poly.def
-/
noncomputable instance {R : Type*} [Semiring R] : Mul (PolynomialSequence R) :=
  ⟨transportedMul⟩
/-- 本库多项式的逐系数取负实例。
> **Entry**: abstract-algebra.poly.def
-/
noncomputable instance {R : Type*} [Ring R] : Neg (PolynomialSequence R) :=
  ⟨transportedNeg⟩

private theorem toMathlib_zero {R : Type*} [Semiring R] :
    toMathlibPolynomial (0 : PolynomialSequence R) = 0 := by
  exact toMathlibPolynomial_fromMathlibPolynomial 0
private theorem toMathlib_one {R : Type*} [Semiring R] :
    toMathlibPolynomial (1 : PolynomialSequence R) = 1 := by
  exact toMathlibPolynomial_fromMathlibPolynomial 1
private theorem toMathlib_add {R : Type*} [Semiring R] (p q : PolynomialSequence R) :
    toMathlibPolynomial (p + q) = toMathlibPolynomial p + toMathlibPolynomial q := by
  exact toMathlibPolynomial_fromMathlibPolynomial _
private theorem toMathlib_mul {R : Type*} [Semiring R] (p q : PolynomialSequence R) :
    toMathlibPolynomial (p * q) = toMathlibPolynomial p * toMathlibPolynomial q := by
  exact toMathlibPolynomial_fromMathlibPolynomial _
private theorem toMathlib_neg {R : Type*} [Ring R] (p : PolynomialSequence R) :
    toMathlibPolynomial (-p) = -toMathlibPolynomial p := by
  exact toMathlibPolynomial_fromMathlibPolynomial _

private theorem toMathlib_injective {R : Type*} [Semiring R] :
    Function.Injective (toMathlibPolynomial : PolynomialSequence R → Polynomial R) := by
  intro p q h
  rw [← fromMathlibPolynomial_toMathlibPolynomial p,
    ← fromMathlibPolynomial_toMathlibPolynomial q, h]

/-- 当系数类型是交换环时，本库多项式运算满足交换环的全部公理。
证明借助具名桥的单射性在私有实现层验证这些等式。
> **Entry**: abstract-algebra.poly.def
-/
noncomputable instance {R : Type*} [CommRing R] : CommRing (PolynomialSequence R) where
  add := (inferInstance : Add (PolynomialSequence R)).add
  add_assoc := by
    intro a b c
    apply toMathlib_injective
    simp only [toMathlib_add, add_assoc]
  zero := (inferInstance : Zero (PolynomialSequence R)).zero
  zero_add := by
    intro a
    apply toMathlib_injective
    simp only [toMathlib_add, toMathlib_zero, zero_add]
  add_zero := by
    intro a
    apply toMathlib_injective
    simp only [toMathlib_add, toMathlib_zero, add_zero]
  neg := (inferInstance : Neg (PolynomialSequence R)).neg
  neg_add_cancel := by
    intro a
    apply toMathlib_injective
    simp only [toMathlib_add, toMathlib_neg, toMathlib_zero, neg_add_cancel]
  add_comm := by
    intro a b
    apply toMathlib_injective
    simp only [toMathlib_add, add_comm]
  mul := (inferInstance : Mul (PolynomialSequence R)).mul
  mul_assoc := by
    intro a b c
    apply toMathlib_injective
    simp only [toMathlib_mul, mul_assoc]
  one := (inferInstance : One (PolynomialSequence R)).one
  one_mul := by
    intro a
    apply toMathlib_injective
    simp only [toMathlib_mul, toMathlib_one, one_mul]
  mul_one := by
    intro a
    apply toMathlib_injective
    simp only [toMathlib_mul, toMathlib_one, mul_one]
  left_distrib := by
    intro a b c
    apply toMathlib_injective
    simp only [toMathlib_mul, toMathlib_add, mul_add]
  right_distrib := by
    intro a b c
    apply toMathlib_injective
    simp only [toMathlib_mul, toMathlib_add, add_mul]
  zero_mul := by
    intro a
    apply toMathlib_injective
    simp only [toMathlib_mul, toMathlib_zero, zero_mul]
  mul_zero := by
    intro a
    apply toMathlib_injective
    simp only [toMathlib_mul, toMathlib_zero, mul_zero]
  mul_comm := by
    intro a b
    apply toMathlib_injective
    simp only [toMathlib_mul, mul_comm]
  nsmul := nsmulRec
  zsmul := zsmulRec

private noncomputable def transportedConstant {R : Type*} [CommRing R]
    (a : R) : PolynomialSequence R :=
  fromMathlibPolynomial (Polynomial.C a)

private noncomputable def transportedX {R : Type*} [CommRing R] : PolynomialSequence R :=
  fromMathlibPolynomial Polynomial.X

private noncomputable def transportedDegree {R : Type*} [CommRing R]
    (p : PolynomialSequence R) : WithBot ℕ :=
  (toMathlibPolynomial p).degree

private noncomputable def transportedEvaluate {R : Type*} [CommRing R]
    (a : R) (p : PolynomialSequence R) : R :=
  (toMathlibPolynomial p).eval a

/-- **常数多项式**：`constant a` 的常数项为 `a`，其余系数为零。
> **Entry**: abstract-algebra.poly.def
-/
noncomputable def constant {R : Type*} [CommRing R] (a : R) : PolynomialSequence R :=
  transportedConstant a

/-- **不定元**：`X` 的一次项系数为一，其余系数为零。
> **Entry**: abstract-algebra.poly.def
-/
noncomputable def X {R : Type*} [CommRing R] : PolynomialSequence R :=
  transportedX

/-- **次数**：返回最高非零项指标，并采用诚实约定 `degree 0 = ⊥`。
> **Entry**: abstract-algebra.poly.def
-/
noncomputable def degree {R : Type*} [CommRing R] (p : PolynomialSequence R) : WithBot ℕ :=
  transportedDegree p

/-- **多项式求值**：`evaluate a p` 把不定元代入系数环元素 `a`。
> **Entry**: abstract-algebra.poly.def
-/
noncomputable def evaluate {R : Type*} [CommRing R]
    (a : R) (p : PolynomialSequence R) : R :=
  transportedEvaluate a p

/-- **根**：`a` 是 `p` 的根，当且仅当 `p` 在 `a` 处的求值为零。
> **Entry**: abstract-algebra.poly.def
-/
def IsRoot {R : Type*} [CommRing R] (p : PolynomialSequence R) (a : R) : Prop :=
  evaluate a p = 0

/-- 零多项式的每一项系数均为零。
> **Entry**: abstract-algebra.poly.def
-/
theorem coefficient_zero {R : Type*} [CommRing R] (n : ℕ) :
    coefficient (0 : PolynomialSequence R) n = 0 := by
  rw [← coefficient_toMathlibPolynomial, toMathlib_zero]
  exact Polynomial.coeff_zero n
/-- 单位多项式的常数项系数为一。
> **Entry**: abstract-algebra.poly.def
-/
theorem coefficient_one_zero {R : Type*} [CommRing R] :
    coefficient (1 : PolynomialSequence R) 0 = 1 := by
  rw [← coefficient_toMathlibPolynomial, toMathlib_one]
  exact Polynomial.coeff_one_zero
/-- 单位多项式的所有正次数项系数均为零。
> **Entry**: abstract-algebra.poly.def
-/
theorem coefficient_one_succ {R : Type*} [CommRing R] (n : ℕ) :
    coefficient (1 : PolynomialSequence R) (n + 1) = 0 := by
  rw [← coefficient_toMathlibPolynomial, toMathlib_one]
  rw [Polynomial.coeff_one]
  simp
/-- 多项式和的第 `n` 项系数等于对应系数之和。
> **Entry**: abstract-algebra.poly.def
-/
theorem coefficient_add {R : Type*} [CommRing R] (p q : PolynomialSequence R) (n : ℕ) :
    coefficient (p + q) n = coefficient p n + coefficient q n := by
  rw [← coefficient_toMathlibPolynomial, toMathlib_add, Polynomial.coeff_add,
    coefficient_toMathlibPolynomial, coefficient_toMathlibPolynomial]
/-- 负多项式的第 `n` 项系数等于原系数的加法逆元。
> **Entry**: abstract-algebra.poly.def
-/
theorem coefficient_neg {R : Type*} [CommRing R] (p : PolynomialSequence R) (n : ℕ) :
    coefficient (-p) n = -coefficient p n := by
  rw [← coefficient_toMathlibPolynomial, toMathlib_neg, Polynomial.coeff_neg,
    coefficient_toMathlibPolynomial]
/-- **卷积公式**：乘积的第 `n` 项系数是所有次数和为 `n` 的系数乘积之和。
> **Entry**: abstract-algebra.poly.def
-/
theorem coefficient_mul {R : Type*} [CommRing R] (p q : PolynomialSequence R) (n : ℕ) :
    coefficient (p * q) n = ∑ k ∈ Finset.range (n + 1),
      coefficient p k * coefficient q (n - k) := by
  rw [← coefficient_toMathlibPolynomial, toMathlib_mul, Polynomial.coeff_mul,
    Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk]
  simp only [coefficient_toMathlibPolynomial]
/-- 常数多项式 `constant a` 的零次项系数为 `a`。
> **Entry**: abstract-algebra.poly.def
-/
theorem coefficient_constant_zero {R : Type*} [CommRing R] (a : R) :
    coefficient (constant a) 0 = a := by
  simp [coefficient, constant, transportedConstant, fromMathlibPolynomial]
/-- 常数多项式的所有正次数项系数均为零。
> **Entry**: abstract-algebra.poly.def
-/
theorem coefficient_constant_succ {R : Type*} [CommRing R] (a : R) (n : ℕ) :
    coefficient (constant a) (n + 1) = 0 := by
  simp [coefficient, constant, transportedConstant, fromMathlibPolynomial]
/-- 不定元 `X` 的常数项系数为零。
> **Entry**: abstract-algebra.poly.def
-/
theorem coefficient_X_zero {R : Type*} [CommRing R] :
    coefficient (X : PolynomialSequence R) 0 = 0 := by
  simp [coefficient, X, transportedX, fromMathlibPolynomial]
/-- 不定元 `X` 的一次项系数为一。
> **Entry**: abstract-algebra.poly.def
-/
theorem coefficient_X_one {R : Type*} [CommRing R] :
    coefficient (X : PolynomialSequence R) 1 = 1 := by
  simp [coefficient, X, transportedX, fromMathlibPolynomial]
/-- 零多项式次数的诚实约定是 `⊥`，而不是自然数零。
> **Entry**: abstract-algebra.poly.def
-/
theorem degree_zero {R : Type*} [CommRing R] :
    degree (0 : PolynomialSequence R) = ⊥ := by
  rw [degree, transportedDegree, toMathlib_zero, Polynomial.degree_zero]

/-- 零多项式在任意元素处求值都为零。
> **Entry**: abstract-algebra.poly.def
-/
theorem evaluate_zero {R : Type*} [CommRing R] (a : R) :
    evaluate a (0 : PolynomialSequence R) = 0 := by
  rw [evaluate, transportedEvaluate, toMathlib_zero, Polynomial.eval_zero]
/-- 单位多项式在任意元素处求值都为一。
> **Entry**: abstract-algebra.poly.def
-/
theorem evaluate_one {R : Type*} [CommRing R] (a : R) :
    evaluate a (1 : PolynomialSequence R) = 1 := by
  rw [evaluate, transportedEvaluate, toMathlib_one, Polynomial.eval_one]
/-- 求值保持多项式加法。
> **Entry**: abstract-algebra.poly.def
-/
theorem evaluate_add {R : Type*} [CommRing R] (a : R) (p q : PolynomialSequence R) :
    evaluate a (p + q) = evaluate a p + evaluate a q := by
  rw [evaluate, transportedEvaluate, toMathlib_add, Polynomial.eval_add]
  rfl
/-- 求值保持加法逆元。
> **Entry**: abstract-algebra.poly.def
-/
theorem evaluate_neg {R : Type*} [CommRing R] (a : R) (p : PolynomialSequence R) :
    evaluate a (-p) = -evaluate a p := by
  rw [evaluate, transportedEvaluate, toMathlib_neg, Polynomial.eval_neg]
  rfl
/-- 求值保持多项式乘法。
> **Entry**: abstract-algebra.poly.def
-/
theorem evaluate_mul {R : Type*} [CommRing R] (a : R) (p q : PolynomialSequence R) :
    evaluate a (p * q) = evaluate a p * evaluate a q := by
  rw [evaluate, transportedEvaluate, toMathlib_mul, Polynomial.eval_mul]
  rfl

/-- 固定代入点后的求值函数满足本库 `RingHomomorphism`：保持零、一、加法、乘法和负元。
> **Entry**: abstract-algebra.poly.def
-/
theorem evaluate_ringHomomorphism {R : Type*} [CommRing R] (a : R) :
    RingHomomorphism (evaluate a : PolynomialSequence R → R) := by
  exact ⟨evaluate_zero a, evaluate_one a, evaluate_add a, evaluate_mul a, evaluate_neg a⟩

/-- **因式定理**：本库多项式 `X - constant a` 整除 `p`，当且仅当 `a` 是 `p` 的根。
公开签名完全使用本库 `PolynomialSequence`、`DividesElement` 与 `IsRoot`；Mathlib 只在证明中
经由具名桥验证对应事实。
> **Entry**: abstract-algebra.poly.def
-/
theorem divides_X_sub_constant_iff_root {R : Type*} [CommRing R]
    (p : PolynomialSequence R) (a : R) :
    DividesElement (X - constant a) p ↔ IsRoot p a := by
  have hfactor : toMathlibPolynomial (X - constant a) =
      Polynomial.X - Polynomial.C a := by
    simp only [sub_eq_add_neg, toMathlib_add, toMathlib_neg, X, constant,
      transportedX, transportedConstant,
      toMathlibPolynomial_fromMathlibPolynomial]
  constructor
  · rintro ⟨q, hq⟩
    have hm := congrArg toMathlibPolynomial hq
    rw [toMathlib_mul, hfactor] at hm
    have hdvd : Polynomial.X - Polynomial.C a ∣ toMathlibPolynomial p := ⟨_, hm⟩
    have hr := (Polynomial.dvd_iff_isRoot (p := toMathlibPolynomial p) (a := a)).mp hdvd
    exact hr
  · intro hr
    have hdvd : Polynomial.X - Polynomial.C a ∣ toMathlibPolynomial p :=
      (Polynomial.dvd_iff_isRoot (p := toMathlibPolynomial p) (a := a)).mpr hr
    obtain ⟨q, hq⟩ := hdvd
    refine ⟨fromMathlibPolynomial q, ?_⟩
    apply toMathlib_injective
    rw [toMathlib_mul, hfactor, toMathlibPolynomial_fromMathlibPolynomial]
    exact hq

/-- **多项式环的整环性**：若系数环满足本库 `IntegralDomainAxioms`，则本库多项式环也满足
同一套整环公理，包括交换环律、零不等于一和无零因子。
> **Entry**: abstract-algebra.poly.def
-/
theorem polynomial_integralDomainAxioms {R : Type*} [CommRing R]
    (hR : IntegralDomainAxioms R) : IntegralDomainAxioms (PolynomialSequence R) := by
  letI : IsDomain R := (integralDomainAxioms_iff_isDomain (R := R)).mp hR
  refine ⟨commRing_has_commutativeRingAxioms (PolynomialSequence R), ?_, ?_⟩
  · intro h
    have hm := congrArg toMathlibPolynomial h
    rw [toMathlib_zero, toMathlib_one] at hm
    exact zero_ne_one hm
  · intro p q hpq
    have hm := congrArg toMathlibPolynomial hpq
    rw [toMathlib_mul, toMathlib_zero] at hm
    rcases eq_zero_or_eq_zero_of_mul_eq_zero hm with hp | hq
    · exact Or.inl (toMathlib_injective (hp.trans toMathlib_zero.symm))
    · exact Or.inr (toMathlib_injective (hq.trans toMathlib_zero.symm))

end SandronesLibrary.AbstractAlgebra.PolynomialDefinition
