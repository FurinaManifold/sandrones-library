/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

/-!
# AbstractAlgebra / Ring —— 环论基础（抽象代数第一学期 A2）

本文件当前条目（引理清单，§0 铁律4：一次一条，逐条编译）：

* **abstract-algebra.ring.def**（交换环/单位/零环判据、子环与生成子环、环同态保运算）✅。
* **abstract-algebra.ring.ideal**（理想判定/吸收乘法/含单位元理想全环/商环判等/核值域）✅。
* **abstract-algebra.ring.domain**（无零因子/域非零元可逆/素理想判据/极大⟹素/素⟹商整环/域⟺零理想极大/商环域⟹极大）✅。
* **abstract-algebra.ring.iso**（环同态基本定理 R/ker≅im）✅。

> **语言说明**：Mathlib 的 `Ring`/`Subring`/`Ideal`/`RingHom` 可以作为实现承载，但不能
> 代替本库教材定义。核心概念必须先以公理、谓词或本库结构明确给出，再建立到 Mathlib
> 表示的桥；公开主定理优先使用本库概念。`Module` 仍不允许出现在本阶段公开签名中。
-/

namespace SandronesLibrary

namespace AbstractAlgebra.Ring

/-! ### 教材定义层 -/

/-- **环公理**：在给定 `0,1,+,*,−` 五种运算后，逐条列出加法交换群、乘法幺半群
和左右分配律。

这是本库的教材定义层；Mathlib 的 `[Ring R]` 只作为已经打包好这些运算与公理的实现。
> **Entry**: abstract-algebra.ring.def
-/
structure RingAxioms (R : Type*) [Zero R] [One R] [Add R] [Mul R] [Neg R] : Prop where
  add_assoc : ∀ a b c : R, a + b + c = a + (b + c)
  zero_add : ∀ a : R, 0 + a = a
  add_zero : ∀ a : R, a + 0 = a
  add_left_neg : ∀ a : R, -a + a = 0
  add_comm : ∀ a b : R, a + b = b + a
  mul_assoc : ∀ a b c : R, a * b * c = a * (b * c)
  one_mul : ∀ a : R, 1 * a = a
  mul_one : ∀ a : R, a * 1 = a
  left_distrib : ∀ a b c : R, a * (b + c) = a * b + a * c
  right_distrib : ∀ a b c : R, (a + b) * c = a * c + b * c

/-- **交换环公理**：满足环公理，并且乘法交换。
> **Entry**: abstract-algebra.ring.def
-/
def CommutativeRingAxioms (R : Type*) [Zero R] [One R] [Add R] [Mul R] [Neg R] : Prop :=
  RingAxioms R ∧ ∀ a b : R, a * b = b * a

/-- **单位元素**：`a` 有一个同时为左逆和右逆的元素。
> **Entry**: abstract-algebra.ring.def
-/
def UnitElement {R : Type*} [One R] [Mul R] (a : R) : Prop :=
  ∃ b : R, a * b = 1 ∧ b * a = 1

/-- **子环集合判据**：集合含 `0,1`，并对加法、乘法和取负封闭。
> **Entry**: abstract-algebra.ring.def
-/
def SubringSet {R : Type*} [Zero R] [One R] [Add R] [Mul R] [Neg R]
    (S : Set R) : Prop :=
  0 ∈ S ∧ 1 ∈ S ∧
    (∀ ⦃a b : R⦄, a ∈ S → b ∈ S → a + b ∈ S) ∧
    (∀ ⦃a b : R⦄, a ∈ S → b ∈ S → a * b ∈ S) ∧
    (∀ ⦃a : R⦄, a ∈ S → -a ∈ S)

/-- **环同态谓词**：函数保持 `0,1,+,*,−`。把它写成普通函数上的谓词，可先用教材
语言验证同态性，再在需要调用实现库时打包为 `RingHom`。
> **Entry**: abstract-algebra.ring.def
-/
def RingHomomorphism {R S : Type*} [Zero R] [One R] [Add R] [Mul R] [Neg R]
    [Zero S] [One S] [Add S] [Mul S] [Neg S] (f : R → S) : Prop :=
  f 0 = 0 ∧ f 1 = 1 ∧
    (∀ a b, f (a + b) = f a + f b) ∧
    (∀ a b, f (a * b) = f a * f b) ∧
    (∀ a, f (-a) = -f a)

/-- 每个 Mathlib `Ring` 实例都满足本库逐条列出的环公理。
> **Entry**: abstract-algebra.ring.def
-/
theorem ring_has_ringAxioms (R : Type*) [Ring R] : RingAxioms R := by
  exact ⟨add_assoc, zero_add, add_zero, neg_add_cancel, add_comm,
    mul_assoc, one_mul, mul_one, mul_add, add_mul⟩

/-- 每个 Mathlib `CommRing` 实例都满足本库交换环公理。
> **Entry**: abstract-algebra.ring.def
-/
theorem commRing_has_commutativeRingAxioms (R : Type*) [CommRing R] :
    CommutativeRingAxioms R := ⟨ring_has_ringAxioms R, mul_comm⟩

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

/-- 本库 `SubringSet` 判据与“存在一个底层集合恰为 `S` 的 Mathlib 子环”完全等价。
> **Entry**: abstract-algebra.ring.def
-/
theorem subringSet_iff_exists_subring {R : Type*} [Ring R] (S : Set R) :
    SubringSet S ↔ ∃ T : Subring R, (T : Set R) = S := by
  constructor
  · rintro ⟨h0, h1, hadd, hmul, hneg⟩
    obtain ⟨T, hT⟩ := subring_of_closed S h0 h1
      (fun ha hb => hadd ha hb) (fun ha hb => hmul ha hb) (fun ha => hneg ha)
    exact ⟨T, Set.ext hT⟩
  · rintro ⟨T, rfl⟩
    exact ⟨T.zero_mem, T.one_mem, fun _ _ => T.add_mem, fun _ _ => T.mul_mem,
      fun _ => T.neg_mem⟩

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

/-- **交换环的乘法交换律**：交换环中因子的次序不影响乘积。

普通 `Ring` 只要求加法交换；`CommRing` 额外要求乘法交换。
> **Entry**: abstract-algebra.ring.def
-/
theorem comm_ring_mul_comm {R : Type*} [CommRing R] (a b : R) : a * b = b * a :=
  mul_comm a b

/-- **单位判据**：幺半群元素 `a` 可逆，当且仅当存在同一个元素 `b` 同时满足
`a * b = 1` 与 `b * a = 1`。

在非交换乘法中，只有单侧逆通常不够，因此教材定义必须同时保留两个方向。
> **Entry**: abstract-algebra.ring.def
-/
theorem isUnit_iff_exists_two_sided_inverse {R : Type*} [Monoid R] (a : R) :
    IsUnit a ↔ ∃ b : R, a * b = 1 ∧ b * a = 1 := by
  constructor
  · rintro ⟨u, rfl⟩
    exact ⟨↑u⁻¹, Units.mul_inv u, Units.inv_mul u⟩
  · rintro ⟨b, hab, hba⟩
    exact ⟨⟨a, b, hab, hba⟩, rfl⟩

/-- 本库单位元素定义与 Mathlib `IsUnit` 等价；后者只作为单位群打包实现。
> **Entry**: abstract-algebra.ring.def
-/
theorem unitElement_iff_isUnit {R : Type*} [Monoid R] (a : R) :
    UnitElement a ↔ IsUnit a :=
  (isUnit_iff_exists_two_sided_inverse a).symm

/-- **零环判据**：环中 `0 = 1` 当且仅当该环只有一个元素。
> **Entry**: abstract-algebra.ring.def
-/
theorem zero_eq_one_iff_subsingleton {R : Type*} [Ring R] :
    (0 : R) = 1 ↔ Subsingleton R := subsingleton_iff_zero_eq_one

/-- **由集合生成的子环**：`generatedSubring S` 是包含 `S` 的最小子环。
> **Entry**: abstract-algebra.ring.def
-/
def generatedSubring {R : Type*} [Ring R] (S : Set R) : Subring R :=
  Subring.closure S

/-- 每个生成元都属于它们生成的子环，即 `S ⊆ generatedSubring S`。
> **Entry**: abstract-algebra.ring.def
-/
theorem subset_generatedSubring {R : Type*} [Ring R] (S : Set R) :
    S ⊆ generatedSubring S := Subring.subset_closure

/-- **生成子环的最小性**：`generatedSubring S ≤ T` 当且仅当 `T` 包含 `S`。
> **Entry**: abstract-algebra.ring.def
-/
theorem generatedSubring_le_iff {R : Type*} [Ring R] {S : Set R} {T : Subring R} :
    generatedSubring S ≤ T ↔ S ⊆ T := Subring.closure_le

/-- 扩大生成元集合只会扩大生成子环。
> **Entry**: abstract-algebra.ring.def
-/
theorem generatedSubring_mono {R : Type*} [Ring R] {S T : Set R} (hST : S ⊆ T) :
    generatedSubring S ≤ generatedSubring T :=
  generatedSubring_le_iff.mpr (Set.Subset.trans hST (subset_generatedSubring T))

/-- 两个子环的交仍是子环；元素属于交，当且仅当它同时属于两个子环。
> **Entry**: abstract-algebra.ring.def
-/
theorem mem_subring_inf_iff {R : Type*} [Ring R] {S T : Subring R} {x : R} :
    x ∈ S ⊓ T ↔ x ∈ S ∧ x ∈ T := Subring.mem_inf

/-- 环同态把零元映到零元。
> **Entry**: abstract-algebra.ring.def
-/
theorem ring_hom_map_zero {R S : Type*} [Ring R] [Ring S] (f : R →+* S) : f 0 = 0 :=
  f.map_zero

/-- 环同态保持加法逆元。
> **Entry**: abstract-algebra.ring.def
-/
theorem ring_hom_map_neg {R S : Type*} [Ring R] [Ring S] (f : R →+* S) (a : R) :
    f (-a) = -f a := f.map_neg a

/-- 环同态保持减法。
> **Entry**: abstract-algebra.ring.def
-/
theorem ring_hom_map_sub {R S : Type*} [Ring R] [Ring S] (f : R →+* S) (a b : R) :
    f (a - b) = f a - f b := f.map_sub a b

/-- 环同态保持自然数次幂。
> **Entry**: abstract-algebra.ring.def
-/
theorem ring_hom_map_pow {R S : Type*} [Ring R] [Ring S] (f : R →+* S) (a : R) (n : ℕ) :
    f (a ^ n) = (f a) ^ n := f.map_pow a n

/-- 环同态保持整数经单位元嵌入所得的元素：`f(n · 1_R) = n · 1_S`。
> **Entry**: abstract-algebra.ring.def
-/
theorem ring_hom_map_intCast {R S : Type*} [Ring R] [Ring S] (f : R →+* S) (n : ℤ) :
    f (n : R) = (n : S) := map_intCast f n

/-- 打包的 Mathlib 环同态满足本库的逐运算同态谓词。
> **Entry**: abstract-algebra.ring.def
-/
theorem ringHom_is_RingHomomorphism {R S : Type*} [Ring R] [Ring S] (f : R →+* S) :
    RingHomomorphism f :=
  ⟨f.map_zero, f.map_one, f.map_add, f.map_mul, f.map_neg⟩

/-- 反之，满足本库环同态谓词的普通函数可打包成 Mathlib `RingHom`，且底层函数不变。
> **Entry**: abstract-algebra.ring.def
-/
theorem ringHomomorphism_exists_ringHom {R S : Type*} [Ring R] [Ring S] (f : R → S)
    (hf : RingHomomorphism f) : ∃ F : R →+* S, ⇑F = f := by
  refine ⟨{
    toFun := f
    map_one' := hf.2.1
    map_mul' := hf.2.2.2.1
    map_zero' := hf.1
    map_add' := hf.2.2.1 }, rfl⟩

/-! ### 理想的本库定义与运算 -/

/-- **左理想**：加法子群 `I` 对环中任意元素的左乘封闭。这里把零元、加法、负元和
左吸收逐项写出，不以 Mathlib 的打包结构代替教材定义。
> **Entry**: abstract-algebra.ring.ideal
-/
def LeftIdealSet {R : Type*} [Zero R] [Add R] [Neg R] [Mul R] (I : Set R) : Prop :=
  0 ∈ I ∧ (∀ ⦃x y : R⦄, x ∈ I → y ∈ I → x + y ∈ I) ∧
    (∀ ⦃x : R⦄, x ∈ I → -x ∈ I) ∧ (∀ (r : R) ⦃x : R⦄, x ∈ I → r * x ∈ I)

/-- **右理想**：加法子群 `I` 对环中任意元素的右乘封闭。
> **Entry**: abstract-algebra.ring.ideal
-/
def RightIdealSet {R : Type*} [Zero R] [Add R] [Neg R] [Mul R] (I : Set R) : Prop :=
  0 ∈ I ∧ (∀ ⦃x y : R⦄, x ∈ I → y ∈ I → x + y ∈ I) ∧
    (∀ ⦃x : R⦄, x ∈ I → -x ∈ I) ∧ (∀ (r : R) ⦃x : R⦄, x ∈ I → x * r ∈ I)

/-- **双边理想**：同时是左理想和右理想。交换环中两侧吸收等价；非交换环中必须区分。
> **Entry**: abstract-algebra.ring.ideal
-/
def TwoSidedIdealSet {R : Type*} [Zero R] [Add R] [Neg R] [Mul R] (I : Set R) : Prop :=
  LeftIdealSet I ∧ RightIdealSet I

/-- 集合 `S` 生成的双边理想：所有包含 `S` 的双边理想之交。这一定义直接表达“包含
`S` 的最小双边理想”，不预先依赖有限和的具体表示。
> **Entry**: abstract-algebra.ring.ideal
-/
def generatedTwoSidedIdeal {R : Type*} [Zero R] [Add R] [Neg R] [Mul R]
    (S : Set R) : Set R :=
  {x | ∀ I : Set R, TwoSidedIdealSet I → S ⊆ I → x ∈ I}

/-- 两个理想集合的和：由一个 `I` 中元素与一个 `J` 中元素之和组成。
> **Entry**: abstract-algebra.ring.ideal
-/
def idealSetSum {R : Type*} [Add R] (I J : Set R) : Set R :=
  {z | ∃ x ∈ I, ∃ y ∈ J, x + y = z}

/-- 两个双边理想集合的积：由所有 `x*y`（`x∈I, y∈J`）生成的双边理想。
生成闭包自动包含有限和及双侧环乘，因此该定义在非交换环中也正确。
> **Entry**: abstract-algebra.ring.ideal
-/
def idealSetProduct {R : Type*} [Zero R] [Add R] [Neg R] [Mul R]
    (I J : Set R) : Set R :=
  generatedTwoSidedIdeal {z | ∃ x ∈ I, ∃ y ∈ J, x * y = z}

theorem generatedTwoSidedIdeal_is_ideal {R : Type*} [Ring R] (S : Set R) :
    TwoSidedIdealSet (generatedTwoSidedIdeal S) := by
  constructor
  · refine ⟨?_, ?_, ?_, ?_⟩
    · intro I hI hSI; exact hI.1.1
    · intro x y hx hy I hI hSI; exact hI.1.2.1 (hx I hI hSI) (hy I hI hSI)
    · intro x hx I hI hSI; exact hI.1.2.2.1 (hx I hI hSI)
    · intro r x hx I hI hSI; exact hI.1.2.2.2 r (hx I hI hSI)
  · refine ⟨?_, ?_, ?_, ?_⟩
    · intro I hI hSI; exact hI.2.1
    · intro x y hx hy I hI hSI; exact hI.2.2.1 (hx I hI hSI) (hy I hI hSI)
    · intro x hx I hI hSI; exact hI.2.2.2.1 (hx I hI hSI)
    · intro r x hx I hI hSI; exact hI.2.2.2.2 r (hx I hI hSI)

theorem subset_generatedTwoSidedIdeal {R : Type*} [Ring R] (S : Set R) :
    S ⊆ generatedTwoSidedIdeal S := by
  intro x hx I hI hSI
  exact hSI hx

theorem generatedTwoSidedIdeal_least {R : Type*} [Ring R] {S I : Set R}
    (hI : TwoSidedIdealSet I) (hSI : S ⊆ I) : generatedTwoSidedIdeal S ⊆ I := by
  intro x hx
  exact hx I hI hSI

theorem idealSetSum_is_ideal {R : Type*} [Ring R] {I J : Set R}
    (hI : TwoSidedIdealSet I) (hJ : TwoSidedIdealSet J) :
    TwoSidedIdealSet (idealSetSum I J) := by
  constructor
  · refine ⟨⟨0, hI.1.1, 0, hJ.1.1, add_zero 0⟩, ?_, ?_, ?_⟩
    · rintro a b ⟨x, hx, y, hy, rfl⟩ ⟨u, hu, v, hv, rfl⟩
      exact ⟨x + u, hI.1.2.1 hx hu, y + v, hJ.1.2.1 hy hv, by abel⟩
    · rintro a ⟨x, hx, y, hy, rfl⟩
      exact ⟨-x, hI.1.2.2.1 hx, -y, hJ.1.2.2.1 hy, by abel⟩
    · rintro r a ⟨x, hx, y, hy, rfl⟩
      exact ⟨r * x, hI.1.2.2.2 r hx, r * y, hJ.1.2.2.2 r hy, by noncomm_ring⟩
  · refine ⟨⟨0, hI.2.1, 0, hJ.2.1, add_zero 0⟩, ?_, ?_, ?_⟩
    · rintro a b ⟨x, hx, y, hy, rfl⟩ ⟨u, hu, v, hv, rfl⟩
      exact ⟨x + u, hI.2.2.1 hx hu, y + v, hJ.2.2.1 hy hv, by abel⟩
    · rintro a ⟨x, hx, y, hy, rfl⟩
      exact ⟨-x, hI.2.2.2.1 hx, -y, hJ.2.2.2.1 hy, by abel⟩
    · rintro r a ⟨x, hx, y, hy, rfl⟩
      exact ⟨x * r, hI.2.2.2.2 r hx, y * r, hJ.2.2.2.2 r hy, by noncomm_ring⟩

/-- 在交换环中，本库双边理想定义与 Mathlib `Ideal` 承载结构完全等价。
> **Entry**: abstract-algebra.ring.ideal
-/
theorem twoSidedIdealSet_iff_exists_ideal {R : Type*} [CommRing R] (I : Set R) :
    TwoSidedIdealSet I ↔ ∃ J : Ideal R, (J : Set R) = I := by
  constructor
  · intro hI
    let asg : AddSubsemigroup R := ⟨I, fun hx hy => hI.1.2.1 hx hy⟩
    let asm : AddSubmonoid R := ⟨asg, hI.1.1⟩
    let J : Ideal R := ⟨asm, fun r x hx => hI.1.2.2.2 r hx⟩
    exact ⟨J, rfl⟩
  · rintro ⟨J, rfl⟩
    constructor
    · exact ⟨J.zero_mem, (fun {_ _} hx hy => J.add_mem hx hy),
        (fun {_} hx => J.neg_mem hx), fun r {_} hx => J.mul_mem_left r hx⟩
    · refine ⟨J.zero_mem, (fun {_ _} hx hy => J.add_mem hx hy),
        (fun {_} hx => J.neg_mem hx), ?_⟩
      intro r x hx
      rw [mul_comm]
      exact J.mul_mem_left r hx

/-- 本库理想和与 Mathlib 格结构中的上确界具有相同底层集合。
> **Entry**: abstract-algebra.ring.ideal
-/
theorem idealSetSum_eq_mathlib_sup {R : Type*} [CommRing R] (I J : Ideal R) :
    idealSetSum (I : Set R) (J : Set R) = ((I ⊔ J : Ideal R) : Set R) := by
  ext z
  exact Submodule.mem_sup.symm

/-- 本库“由两两乘积生成”的定义与 Mathlib 理想乘积具有相同底层集合。
> **Entry**: abstract-algebra.ring.ideal
-/
theorem idealSetProduct_eq_mathlib_mul {R : Type*} [CommRing R] (I J : Ideal R) :
    idealSetProduct (I : Set R) (J : Set R) = ((I * J : Ideal R) : Set R) := by
  ext z
  constructor
  · intro hz
    apply hz (I * J : Ideal R)
    · exact (twoSidedIdealSet_iff_exists_ideal ((I * J : Ideal R) : Set R)).2 ⟨I * J, rfl⟩
    · rintro w ⟨x, hx, y, hy, rfl⟩
      exact Ideal.mul_mem_mul hx hy
  · intro hz
    obtain ⟨K, hK⟩ :=
      (twoSidedIdealSet_iff_exists_ideal (generatedTwoSidedIdeal
        {w | ∃ x ∈ (I : Set R), ∃ y ∈ (J : Set R), x * y = w})).1
        (generatedTwoSidedIdeal_is_ideal _)
    have hmul : I * J ≤ K := Ideal.mul_le.mpr (by
      intro x hx y hy
      change x * y ∈ (K : Set R)
      rw [hK]
      exact subset_generatedTwoSidedIdeal _ ⟨x, hx, y, hy, rfl⟩)
    change z ∈ generatedTwoSidedIdeal
      {w | ∃ x ∈ (I : Set R), ∃ y ∈ (J : Set R), x * y = w}
    rw [← hK]
    exact hmul hz

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

/-- **环同态基本定理（第一同构定理）**：R/ker(f) ≅ im(f)。
  商环 R/ker f 与 f 的值域（子环）同构。 
> **Entry**: abstract-algebra.ring.iso
-/
theorem ring_first_isomorphism {R S : Type*} [Ring R] [Ring S] (f : R →+* S) :
    Nonempty (R ⧸ RingHom.ker f ≃+* ↥f.range) := by
  exact ⟨RingHom.quotientKerEquivRange f⟩

/-- **商环是域 ⟹ 理想极大**：若商环 R/I 是域，则 I 是极大理想。
  （教材：极大理想 ⟺ 商环是域，的另一半方向。） 
> **Entry**: abstract-algebra.ring.domain
-/
theorem ideal_maximal_of_quotient_isField {R : Type*} [CommRing R] (I : Ideal R)
    (hqf : IsField (R ⧸ I)) : I.IsMaximal := by
  exact Ideal.Quotient.maximal_of_isField I hqf

end AbstractAlgebra.Ring

end SandronesLibrary
