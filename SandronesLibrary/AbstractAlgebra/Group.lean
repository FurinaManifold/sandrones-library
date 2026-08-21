/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

open scoped BigOperators

/-!
# AbstractAlgebra / Group —— 群论基础（抽象代数第一学期 A1）

本文件当前条目（引理清单，§0 铁律4：一次一条，逐条编译）：

* **abstract-algebra.group.def**（子群判定/含单位元/外延性/平凡子群/全子群）✅。
* **abstract-algebra.group.coset**（左陪集成员/相等判据/自身在陪集/单位元陪集/陪集等势/Lagrange）✅。
* **abstract-algebra.group.normal**（共轭封闭/交换性/平凡与全正规/商群保运算）✅。
* **abstract-algebra.group.index-two**（指数 2 子群必正规）✅。
* **abstract-algebra.group.hom**（核值域刻画/保单位元乘法逆/单射⟺核平凡/满射⟺值域全/同态基本定理）✅。

> **语言说明**：抽象代数阶段（§Phase3）允许直接用 mathlib 的 `Group`/`Subgroup`/
> `MonoidHom`/`QuotientGroup` 等教材结构；`Module` 仍不允许（线性代数已用 LinearSpace 承载）。
-/

namespace SandronesLibrary

namespace AbstractAlgebra.Group

open scoped Pointwise

/-- **子群判定定理**（教材核心判据）：子集 S 含单位元、对乘法与取逆封闭 ⟹ S 是子群。 
> **Entry**: abstract-algebra.group.def
-/
theorem subgroup_of_closed {G : Type*} [Group G] (S : Set G)
    (h1 : 1 ∈ S) (hmul : ∀ {x y : G}, x ∈ S → y ∈ S → x * y ∈ S)
    (hinv : ∀ {x : G}, x ∈ S → x⁻¹ ∈ S) :
    ∃ H : Subgroup G, ∀ x : G, x ∈ H ↔ x ∈ S := by
  let ssm : Subsemigroup G := ⟨S, hmul⟩
  let sm : Submonoid G := ⟨ssm, h1⟩
  let H : Subgroup G := ⟨sm, hinv⟩
  refine ⟨H, ?_⟩
  intro x
  constructor <;> intro hx <;> exact hx

/-- **子群含单位元**：任何子群都包含单位元。 
> **Entry**: abstract-algebra.group.def
-/
theorem subgroup_one_mem {G : Type*} [Group G] (H : Subgroup G) : 1 ∈ H := by
  exact H.one_mem

/-- **子群外延性**：成员一致的两个子群相等。 
> **Entry**: abstract-algebra.group.def
-/
theorem subgroup_ext {G : Type*} [Group G] {H K : Subgroup G}
    (h : ∀ x : G, x ∈ H ↔ x ∈ K) : H = K := by
  exact Subgroup.ext h

/-- **平凡子群**：只含单位元的子群（最小子群）。 
> **Entry**: abstract-algebra.group.def
-/
theorem subgroup_bot_eq_singleton {G : Type*} [Group G] :
    ((⊥ : Subgroup G) : Set G) = {1} := by
  ext x
  exact Subgroup.mem_bot

/-- **全子群**：整个群自身是子群（最大子群）。 
> **Entry**: abstract-algebra.group.def
-/
theorem subgroup_top_eq_univ {G : Type*} [Group G] :
    ((⊤ : Subgroup G) : Set G) = Set.univ := by
  ext x
  constructor
  · intro hx
    trivial
  · intro hx
    exact Subgroup.mem_top x

/-- **左陪集元素刻画**：x ∈ aH ⟺ a⁻¹·x ∈ H（左陪集 aH = { a·h | h ∈ H }）。 
> **Entry**: abstract-algebra.group.coset
-/
theorem left_coset_mem_iff {G : Type*} [Group G] (H : Subgroup G) (a x : G) :
    x ∈ a • (H : Set G) ↔ a⁻¹ * x ∈ H := by
  exact mem_leftCoset_iff (a := a)

/-- **左陪集相等判据**：aH = bH ⟺ b⁻¹·a ∈ H（两个陪集相等当且仅当代表元素差落在 H 中）。 
> **Entry**: abstract-algebra.group.coset
-/
theorem left_coset_eq_iff {G : Type*} [Group G] (H : Subgroup G) (a b : G) :
    a • (H : Set G) = b • (H : Set G) ↔ b⁻¹ * a ∈ H := by
  constructor
  · intro h
    exact (leftCoset_eq_iff (s := H) (x := b) (y := a)).mp h.symm
  · intro h
    exact ((leftCoset_eq_iff (s := H) (x := b) (y := a)).mpr h).symm

/-- **自身在陪集中**：对任意 a，a ∈ aH。 
> **Entry**: abstract-algebra.group.coset
-/
theorem left_coset_mem_self {G : Type*} [Group G] (H : Subgroup G) (a : G) :
    a ∈ a • (H : Set G) := by
  exact mem_own_leftCoset (s := H.toSubmonoid) a

/-- **单位元陪集**：1H = H。 
> **Entry**: abstract-algebra.group.coset
-/
theorem one_left_coset {G : Type*} [Group G] (H : Subgroup G) :
    (1 : G) • (H : Set G) = (H : Set G) := by
  exact one_leftCoset (s := (H : Set G))

/-- **陪集与子群等势**：左陪集 aH 与子群 H 的元素个数相同（陪集都是"同样大小"）。 
> **Entry**: abstract-algebra.group.coset
-/
theorem leftCoset_card_eq {G : Type*} [Group G] (H : Subgroup G) (a : G) :
    Nat.card ({x : G // x ∈ a • (H : Set G)}) = Nat.card (↥H) := by
  exact Nat.card_congr (Subgroup.leftCosetEquivSubgroup (s := H) a)

/-- **Lagrange 定理**：对有限群 G，|H| · [G:H] = |G|（子群阶整除群阶）。 
> **Entry**: abstract-algebra.group.coset
-/
theorem lagrange {G : Type*} [Group G] (H : Subgroup G) :
    Nat.card ↥H * H.index = Nat.card G := by
  exact Subgroup.card_mul_index H

/-- **正规子群的共轭封闭性**：H 正规 ⟹ 对 n ∈ H、任意 g，共轭 g·n·g⁻¹ ∈ H。
  这是正规子群的定义本质（教材定义）。 
> **Entry**: abstract-algebra.group.normal
-/
theorem normal_conj_mem {G : Type*} [Group G] (H : Subgroup G) (nH : H.Normal)
    (n : G) (hn : n ∈ H) (g : G) : g * n * g⁻¹ ∈ H := by
  exact nH.conj_mem n hn g

/-- **正规子群的交换性**：H 正规 ⟹ a·b ∈ H ⟹ b·a ∈ H。 
> **Entry**: abstract-algebra.group.normal
-/
theorem normal_mem_comm {G : Type*} [Group G] (H : Subgroup G) (nH : H.Normal)
    {a b : G} (h : a * b ∈ H) : b * a ∈ H := by
  exact nH.mem_comm h

/-- **平凡子群正规**：只含单位元的子群是正规子群。 
> **Entry**: abstract-algebra.group.normal
-/
theorem normal_bot {G : Type*} [Group G] : (⊥ : Subgroup G).Normal := by
  exact Subgroup.normal_bot

/-- **全子群正规**：整个群自身是正规子群。 
> **Entry**: abstract-algebra.group.normal
-/
theorem normal_top {G : Type*} [Group G] : (⊤ : Subgroup G).Normal := by
  exact Subgroup.normal_top

/-- **商群投影保乘法**：自然同态 `mk : G → G⧸H` 是同态（`↑(a*b) = ↑a * ↑b`）。 
> **Entry**: abstract-algebra.group.normal
-/
theorem quotient_mk_mul {G : Type*} [Group G] (H : Subgroup G) (nH : H.Normal) (a b : G) :
    (QuotientGroup.mk (s := H) (a * b)) = QuotientGroup.mk (s := H) a * QuotientGroup.mk (s := H) b := by
  exact QuotientGroup.mk_mul H a b

/-- **商群单位元**：商群的单位元是 `↑1`（H 所在的陪集）。 
> **Entry**: abstract-algebra.group.normal
-/
theorem quotient_mk_one {G : Type*} [Group G] (H : Subgroup G) (nH : H.Normal) :
    QuotientGroup.mk (s := H) (1 : G) = 1 := by
  exact QuotientGroup.mk_one H

/-- **商群取逆保持**：商群中 `↑(a⁻¹) = (↑a)⁻¹`。 
> **Entry**: abstract-algebra.group.normal
-/
theorem quotient_mk_inv {G : Type*} [Group G] (H : Subgroup G) (nH : H.Normal) (a : G) :
    QuotientGroup.mk (s := H) (a⁻¹) = (QuotientGroup.mk (s := H) a)⁻¹ := by
  exact QuotientGroup.mk_inv H a

/-- **指数 2 子群必正规**：若 H 在 G 中的指数 [G:H] = 2（恰有两个陪集），则 H 是正规子群。
  教材经典定理：指数最小的非平凡子群必正规。 
> **Entry**: abstract-algebra.group.index-two
-/
theorem normal_of_index_two {G : Type*} [Group G] (H : Subgroup G) (hH : H.index = 2) :
    H.Normal := by
  exact Subgroup.normal_of_index_eq_two hH

end AbstractAlgebra.Group

end SandronesLibrary
/-- **同态核元素刻画**：x 在核中 ⟺ f(x) = 1（核 = 映到单位元的元素集）。 
> **Entry**: abstract-algebra.group.hom
-/
theorem hom_mem_ker {G M : Type*} [Group G] [MulOneClass M] (f : G →* M) (x : G) :
    x ∈ f.ker ↔ f x = 1 := by
  exact MonoidHom.mem_ker (f := f)

/-- **同态值域元素刻画**：y 在值域中 ⟺ 存在 x 使 f(x) = y。 
> **Entry**: abstract-algebra.group.hom
-/
theorem hom_mem_range {G N : Type*} [Group G] [Group N] (f : G →* N) (y : N) :
    y ∈ f.range ↔ ∃ x : G, f x = y := by
  exact MonoidHom.mem_range (f := f)

/-- **同态保单位元**：f(1) = 1。 
> **Entry**: abstract-algebra.group.hom
-/
theorem hom_map_one {G M : Type*} [Group G] [Monoid M] (f : G →* M) : f 1 = 1 := by
  exact f.map_one

/-- **同态保乘法**：f(a·b) = f(a)·f(b)。 
> **Entry**: abstract-algebra.group.hom
-/
theorem hom_map_mul {G M : Type*} [Group G] [Monoid M] (f : G →* M) (a b : G) :
    f (a * b) = f a * f b := by
  exact f.map_mul a b

/-- **同态保逆**：f(a⁻¹) = (f a)⁻¹。 
> **Entry**: abstract-algebra.group.hom
-/
theorem hom_map_inv {G N : Type*} [Group G] [Group N] (f : G →* N) (a : G) :
    f a⁻¹ = (f a)⁻¹ := by
  exact f.map_inv a

/-- **单射 ⟺ 核平凡**：群同态 f 是单射当且仅当其核只含单位元。 
> **Entry**: abstract-algebra.group.hom
-/
theorem hom_injective_iff_ker_bot {G M : Type*} [Group G] [MulOneClass M] (f : G →* M) :
    f.ker = ⊥ ↔ Function.Injective f := by
  exact MonoidHom.ker_eq_bot_iff f

/-- **满射 ⟺ 值域为全群**：群同态 f 是满射当且仅当其值域是整个 N。 
> **Entry**: abstract-algebra.group.hom
-/
theorem hom_surjective_iff_range_top {G N : Type*} [Group G] [Group N] (f : G →* N) :
    f.range = ⊤ ↔ Function.Surjective f := by
  exact MonoidHom.range_eq_top (f := f)

/-- **同态基本定理（第一同构定理）**：G/ker(f) ≅ im(f)。
  商群 G/ker f 与 f 的值域同构。 
> **Entry**: abstract-algebra.group.hom
-/
theorem first_isomorphism_theorem {G N : Type*} [Group G] [Group N] (f : G →* N) :
    Nonempty (G ⧸ f.ker ≃* f.range) := by
  exact ⟨QuotientGroup.quotientKerEquivRange f⟩
