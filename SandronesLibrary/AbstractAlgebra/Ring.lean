/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

/-!
# AbstractAlgebra / Ring —— 环论基础（抽象代数第一学期 A2）

本文件当前条目（引理清单，§0 铁律4：一次一条，逐条编译）：

* **abstract-algebra.ring.def**（子环判定/外延性/平凡与全子环/子环含1/环同态保运算）✅。
* **abstract-algebra.ring.ideal**（理想判定/吸收乘法/含单位元理想全环/商环判等/核值域）✅。
* **abstract-algebra.ring.domain**（无零因子/域非零元可逆/素理想判据/极大⟹素/素⟹商整环/域⟺零理想极大）✅。

> **语言说明**：抽象代数阶段（§Phase3）允许直接用 mathlib 的 `Ring`/`Subring`/`Ideal`/
> `RingHom` 等教材结构；`Module` 仍不允许（线性代数已用 LinearSpace 承载）。
-/

namespace SandronesLibrary

namespace AbstractAlgebra.Ring

/-- **子环判定定理**（教材核心判据）：子集 S 含 0 与 1、对加减乘封闭 ⟹ S 是子环。 
> **Entry**: abstract-algebra.ring.def
-/
theorem subring_of_closed {R : Type*} [Ring R] (S : Set R)
    (h0 : 0 ∈ S) (h1 : 1 ∈ S)
    (hadd : ∀ {x y : R}, x ∈ S → y ∈ S → x + y ∈ S)
    (hmul : ∀ {x y : R}, x ∈ S → y ∈ S → x * y ∈ S)
    (hneg : ∀ {x : R}, x ∈ S → -x ∈ S) :
    ∃ T : Subring R, ∀ x : R, x ∈ T ↔ x ∈ S := by
  let ssg : Subsemigroup R := ⟨S, hmul⟩
  let sm : Submonoid R := ⟨ssg, h1⟩
  let ssr : Subsemiring R := ⟨sm, hadd, h0⟩
  let T : Subring R := ⟨ssr, hneg⟩
  refine ⟨T, ?_⟩
  intro x
  constructor <;> intro hx <;> exact hx

/-- **子环含单位元**：任何子环都包含乘法单位元 1。 
> **Entry**: abstract-algebra.ring.def
-/
theorem subring_one_mem {R : Type*} [Ring R] (S : Subring R) : 1 ∈ S := by
  exact S.one_mem

/-- **子环含零元**：任何子环都包含加法零元 0。 
> **Entry**: abstract-algebra.ring.def
-/
theorem subring_zero_mem {R : Type*} [Ring R] (S : Subring R) : 0 ∈ S := by
  exact S.zero_mem

/-- **子环外延性**：元素集相同的子环相等。 
> **Entry**: abstract-algebra.ring.def
-/
theorem subring_ext {R : Type*} [Ring R] {S T : Subring R}
    (h : ∀ x : R, x ∈ S ↔ x ∈ T) : S = T := by
  exact Subring.ext h

/-- **平凡子环**：`⊥`（由整数生成的子环，元素形如 n·1）。 
> **Entry**: abstract-algebra.ring.def
-/
theorem subring_bot {R : Type*} [Ring R] (x : R) :
    x ∈ (⊥ : Subring R) ↔ ∃ n : ℤ, (n : R) = x := by
  exact Subring.mem_bot

/-- **全子环**：整个环自身是子环（最大子环）。 
> **Entry**: abstract-algebra.ring.def
-/
theorem subring_top {R : Type*} [Ring R] :
    ((⊤ : Subring R) : Set R) = Set.univ := by
  ext x
  constructor
  · intro hx
    trivial
  · intro hx
    exact Subring.mem_top x

/-- **环同态保单位元**：f(1) = 1。 
> **Entry**: abstract-algebra.ring.def
-/
theorem ring_hom_map_one {R S : Type*} [Ring R] [Ring S] (f : R →+* S) : f 1 = 1 := by
  exact f.map_one

/-- **环同态保加法**：f(a+b) = f(a) + f(b)。 
> **Entry**: abstract-algebra.ring.def
-/
theorem ring_hom_map_add {R S : Type*} [Ring R] [Ring S] (f : R →+* S) (a b : R) :
    f (a + b) = f a + f b := by
  exact f.map_add a b

/-- **环同态保乘法**：f(a·b) = f(a)·f(b)。 
> **Entry**: abstract-algebra.ring.def
-/
theorem ring_hom_map_mul {R S : Type*} [Ring R] [Ring S] (f : R →+* S) (a b : R) :
    f (a * b) = f a * f b := by
  exact f.map_mul a b

/-- **理想判定定理**（教材核心判据）：子集 I 含 0、对加法封闭、且被 R 乘法吸收（y ∈ I ⟹ x·y ∈ I）⟹ I 是理想。 
> **Entry**: abstract-algebra.ring.ideal
-/
theorem ideal_of_closed {R : Type*} [Ring R] (I : Set R)
    (h0 : 0 ∈ I)
    (hadd : ∀ {x y : R}, x ∈ I → y ∈ I → x + y ∈ I)
    (hmulr : ∀ {x y : R}, y ∈ I → x * y ∈ I) :
    ∃ J : Ideal R, ∀ x : R, x ∈ J ↔ x ∈ I := by
  let asg : AddSubsemigroup R := ⟨I, hadd⟩
  let asm : AddSubmonoid R := ⟨asg, h0⟩
  let J : Ideal R := ⟨asm, fun c x hx => hmulr (x := c) (y := x) hx⟩
  refine ⟨J, ?_⟩
  intro x
  constructor <;> intro hx <;> exact hx

/-- **理想左吸收**：x ∈ I ⟹ a·x ∈ I（理想对左乘封闭）。 
> **Entry**: abstract-algebra.ring.ideal
-/
theorem ideal_mul_mem_left {R : Type*} [Ring R] (I : Ideal R) {x : R} (hx : x ∈ I) (a : R) :
    a * x ∈ I := by
  exact I.mul_mem_left a hx

/-- **理想右吸收**：x ∈ I ⟹ x·a ∈ I（双边理想对右乘封闭）。 
> **Entry**: abstract-algebra.ring.ideal
-/
theorem ideal_mul_mem_right {R : Type*} [Ring R] (I : Ideal R) [I.IsTwoSided]
    {x : R} (hx : x ∈ I) (a : R) : x * a ∈ I := by
  exact I.mul_mem_right a hx

/-- **含单位元的理想是全环**：若理想含某个可逆元，则该理想是整个环。 
> **Entry**: abstract-algebra.ring.ideal
-/
theorem ideal_eq_top_of_unit_mem {R : Type*} [Ring R] (I : Ideal R)
    {x : R} (hx : x ∈ I) (hunit : IsUnit x) : I = ⊤ := by
  exact Ideal.eq_top_of_isUnit_mem I hx hunit

/-- **商环判等准则**：mk x = mk y ⟺ x - y ∈ I（两个同余类相等当且仅当差落在理想中）。 
> **Entry**: abstract-algebra.ring.ideal
-/
theorem quotient_eq_iff_sub_mem {R : Type*} [Ring R] (I : Ideal R) [I.IsTwoSided]
    (x y : R) : (Ideal.Quotient.mk I) x = (Ideal.Quotient.mk I) y ↔ x - y ∈ I := by
  exact Ideal.Quotient.eq (I := I) (x := x) (y := y)

/-- **环同态核是理想**：环同态 f 的核 `f.ker` 是理想（含 0、加封闭、吸收）。 
> **Entry**: abstract-algebra.ring.ideal
-/
theorem ring_hom_ker_is_ideal {R S : Type*} [Ring R] [Ring S] (f : R →+* S) :
    ∃ J : Ideal R, ∀ x : R, x ∈ J ↔ f x = 0 := by
  refine ⟨RingHom.ker f, ?_⟩
  intro x
  exact RingHom.mem_ker (f := f)

/-- **环同态值域元素刻画**：y 在值域中 ⟺ 存在 x 使 f(x) = y。 
> **Entry**: abstract-algebra.ring.ideal
-/
theorem ring_hom_mem_range {R S : Type*} [Ring R] [Ring S] (f : R →+* S) (y : S) :
    y ∈ f.range ↔ ∃ x : R, f x = y := by
  exact RingHom.mem_range (f := f)

/-- **环同态单射 ⟺ 核平凡**：环同态 f 是单射当且仅当其核只含零元。 
> **Entry**: abstract-algebra.ring.ideal
-/
theorem ring_hom_injective_iff_ker_bot {R S : Type*} [Ring R] [Ring S] (f : R →+* S) :
    Function.Injective f ↔ RingHom.ker f = ⊥ := by
  exact RingHom.injective_iff_ker_eq_bot f

/-- **整环无零因子**：a·b = 0 ⟹ a = 0 或 b = 0（整环没有非零零因子）。 
> **Entry**: abstract-algebra.ring.domain
-/
theorem is_domain_mul_eq_zero {R : Type*} [Ring R] [IsDomain R] {a b : R}
    (h : a * b = 0) : a = 0 ∨ b = 0 := by
  exact mul_eq_zero.mp h

/-- **域中非零元可逆**：a ≠ 0 ⟹ 存在 b 使 a·b = 1（域中每个非零元有乘法逆元）。 
> **Entry**: abstract-algebra.ring.domain
-/
theorem is_field_inv_exists {R : Type*} [Ring R] (hF : IsField R) {a : R} (ha : a ≠ 0) :
    ∃ b : R, a * b = 1 := by
  exact IsField.mul_inv_cancel hF ha

/-- **素理想定义**（教材判据）：I 素 ⟺ I ≠ ⊤ 且 a·b ∈ I ⟹ a ∈ I 或 b ∈ I。 
> **Entry**: abstract-algebra.ring.domain
-/
theorem is_prime_iff {R : Type*} [CommRing R] (I : Ideal R) :
    I.IsPrime ↔ I ≠ ⊤ ∧ ∀ {x y : R}, x * y ∈ I → x ∈ I ∨ y ∈ I := by
  exact Ideal.isPrime_iff

/-- **极大理想是素理想**：极大理想必为素理想。 
> **Entry**: abstract-algebra.ring.domain
-/
theorem is_maximal_implies_is_prime {R : Type*} [CommRing R] (I : Ideal R)
    (hI : I.IsMaximal) : I.IsPrime := by
  exact hI.isPrime

/-- **素理想 ⟹ 商环是整环**：I 是素理想 ⟹ 商环 R/I 是整环。 
> **Entry**: abstract-algebra.ring.domain
-/
theorem quotient_is_domain_of_is_prime {R : Type*} [CommRing R] (I : Ideal R)
    (hI : I.IsPrime) : IsDomain (R ⧸ I) := by
  exact Ideal.Quotient.isDomain I

/-- **R 是域 ⟺ 零理想极大**：环 R 是域当且仅当零理想 (0) 是极大理想。 
> **Entry**: abstract-algebra.ring.domain
-/
theorem is_field_iff_bot_is_maximal {R : Type*} [CommRing R] [Nontrivial R] :
    IsField R ↔ (⊥ : Ideal R).IsMaximal := by
  exact Ring.isField_iff_maximal_bot

end AbstractAlgebra.Ring

end SandronesLibrary