/-
Copyright (c) 2026 Sandrone's Library contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sandrone's Library contributors
-/
import Mathlib

/-!
# AbstractAlgebra / Group —— 群论基础（抽象代数第一学期 A1）

本文件当前条目（引理清单，§0 铁律4：一次一条，逐条编译）：

* **abstract-algebra.group.def**（单位元与逆元唯一/消去与方程/整数幂/生成子群/子群格）✅。
* **abstract-algebra.group.coset**（左右陪集/陪集分割/Lagrange/子群阶与元素阶的整除推论）✅。
* **abstract-algebra.group.normal**（共轭封闭/交换性/平凡与全正规/商群保运算）✅。
* **abstract-algebra.group.index-two**（指数 2 子群必正规）✅。
* **abstract-algebra.group.hom**（核值域刻画/保单位元乘法逆/单射⟺核平凡/满射⟺值域全/同态基本定理）✅。

> **语言说明**：抽象代数阶段（§Phase3）允许直接用 mathlib 的 `Group`/`Subgroup`/
> `MonoidHom`/`QuotientGroup` 等教材结构；`Module` 仍不允许（线性代数已用 LinearSpace 承载）。
-/

open scoped BigOperators

namespace SandronesLibrary

namespace AbstractAlgebra.Group

open scoped Pointwise

/-! ### 群公理的直接推论 -/

/-- 左单位元是唯一的：若 `e * x = x` 对所有 x 成立，则 `e = 1`。
> **Entry**: abstract-algebra.group.def
-/
theorem left_identity_unique {G : Type*} [Group G] (e : G)
    (he : ∀ x : G, e * x = x) : e = 1 := by
  simpa using he 1

/-- 右单位元是唯一的。
> **Entry**: abstract-algebra.group.def
-/
theorem right_identity_unique {G : Type*} [Group G] (e : G)
    (he : ∀ x : G, x * e = x) : e = 1 := by
  simpa using he 1

/-- 左逆元是唯一的：`yx=1` 蕴含 `y=x⁻¹`。
> **Entry**: abstract-algebra.group.def
-/
theorem left_inverse_unique {G : Type*} [Group G] {x y : G}
    (h : y * x = 1) : y = x⁻¹ := by
  exact eq_inv_of_mul_eq_one_left h

/-- 右逆元是唯一的：`xy=1` 蕴含 `y=x⁻¹`。
> **Entry**: abstract-algebra.group.def
-/
theorem right_inverse_unique {G : Type*} [Group G] {x y : G}
    (h : x * y = 1) : y = x⁻¹ := by
  exact eq_inv_of_mul_eq_one_right h

/-- 群乘法的左消去律。
> **Entry**: abstract-algebra.group.def
-/
theorem group_mul_left_cancel {G : Type*} [Group G] {a x y : G}
    (h : a * x = a * y) : x = y := by
  exact mul_left_cancel h

/-- 群乘法的右消去律。
> **Entry**: abstract-algebra.group.def
-/
theorem group_mul_right_cancel {G : Type*} [Group G] {a x y : G}
    (h : x * a = y * a) : x = y := by
  exact mul_right_cancel h

/-- 左乘方程 `ax=b` 的唯一解是 `x=a⁻¹b`。
> **Entry**: abstract-algebra.group.def
-/
theorem solve_mul_left_iff {G : Type*} [Group G] (a x b : G) :
    a * x = b ↔ x = a⁻¹ * b := by
  constructor <;> intro h
  · rw [← h]
    group
  · rw [h]
    group

/-- 右乘方程 `xa=b` 的唯一解是 `x=ba⁻¹`。
> **Entry**: abstract-algebra.group.def
-/
theorem solve_mul_right_iff {G : Type*} [Group G] (a x b : G) :
    x * a = b ↔ x = b * a⁻¹ := by
  constructor <;> intro h
  · rw [← h]
    group
  · rw [h]
    group

/-- 乘积取逆时次序反转：`(ab)⁻¹=b⁻¹a⁻¹`。
> **Entry**: abstract-algebra.group.def
-/
theorem inverse_mul_reverse {G : Type*} [Group G] (a b : G) :
    (a * b)⁻¹ = b⁻¹ * a⁻¹ := by
  exact mul_inv_rev a b

/-- 整数零次幂等于单位元。
> **Entry**: abstract-algebra.group.def
-/
theorem zpow_zero_basic {G : Type*} [Group G] (a : G) : a ^ (0 : ℤ) = 1 := by
  exact zpow_zero a

/-- 整数一次幂等于自身。
> **Entry**: abstract-algebra.group.def
-/
theorem zpow_one_basic {G : Type*} [Group G] (a : G) : a ^ (1 : ℤ) = a := by
  exact zpow_one a

/-- 同底整数幂相乘：`a^(m+n)=a^m a^n`。
> **Entry**: abstract-algebra.group.def
-/
theorem zpow_add_basic {G : Type*} [Group G] (a : G) (m n : ℤ) :
    a ^ (m + n) = a ^ m * a ^ n := by
  exact zpow_add a m n

/-- 负整数幂等于对应幂的逆。
> **Entry**: abstract-algebra.group.def
-/
theorem zpow_neg_basic {G : Type*} [Group G] (a : G) (n : ℤ) :
    a ^ (-n) = (a ^ n)⁻¹ := by
  exact zpow_neg a n

/-- 整数幂的幂法则：`a^(mn)=(a^m)^n`。
> **Entry**: abstract-algebra.group.def
-/
theorem zpow_mul_basic {G : Type*} [Group G] (a : G) (m n : ℤ) :
    a ^ (m * n) = (a ^ m) ^ n := by
  exact zpow_mul a m n

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

/-! ### 生成子群与子群格 -/

/-- **由集合生成的子群**：`generatedSubgroup S` 是包含 `S` 的最小子群。
教材中常记作 `⟨S⟩`；这里使用具名定义，避免与 Lean 的语法符号混淆。
> **Entry**: abstract-algebra.group.def
-/
def generatedSubgroup {G : Type*} [Group G] (S : Set G) : Subgroup G :=
  Subgroup.closure S

/-- 每个生成元都属于它们生成的子群，即 `S ⊆ ⟨S⟩`。
> **Entry**: abstract-algebra.group.def
-/
theorem subset_generatedSubgroup {G : Type*} [Group G] (S : Set G) :
    S ⊆ generatedSubgroup S := by
  exact Subgroup.subset_closure

/-- **生成子群的最小性**：`⟨S⟩ ≤ H` 当且仅当 `H` 包含所有生成元。
这是从生成元定义同态、证明两个子群相等时最常用的消去原则。
> **Entry**: abstract-algebra.group.def
-/
theorem generatedSubgroup_le_iff {G : Type*} [Group G]
    (S : Set G) (H : Subgroup G) :
    generatedSubgroup S ≤ H ↔ S ⊆ H := by
  exact Subgroup.closure_le H

/-- 扩大生成元集合只会扩大生成子群。
> **Entry**: abstract-algebra.group.def
-/
theorem generatedSubgroup_mono {G : Type*} [Group G]
    {S T : Set G} (hST : S ⊆ T) :
    generatedSubgroup S ≤ generatedSubgroup T := by
  exact Subgroup.closure_mono hST

/-- 一个子群的底层集合重新生成出的子群仍是它自身。
> **Entry**: abstract-algebra.group.def
-/
theorem generatedSubgroup_coe {G : Type*} [Group G] (H : Subgroup G) :
    generatedSubgroup (H : Set G) = H := by
  exact Subgroup.closure_eq H

/-- 两组生成元的并生成两个生成子群在子群格中的上确界。
> **Entry**: abstract-algebra.group.def
-/
theorem generatedSubgroup_union {G : Type*} [Group G] (S T : Set G) :
    generatedSubgroup (S ∪ T) = generatedSubgroup S ⊔ generatedSubgroup T := by
  exact Subgroup.closure_union S T

/-- 两个子群的下确界就是它们的集合交：元素属于 `H ⊓ K` 当且仅当同时属于二者。
> **Entry**: abstract-algebra.group.def
-/
theorem mem_subgroup_inf_iff {G : Type*} [Group G]
    (H K : Subgroup G) (x : G) :
    x ∈ H ⊓ K ↔ x ∈ H ∧ x ∈ K := by
  exact Subgroup.mem_inf

/-- 任意族子群的下确界就是共同交集。
> **Entry**: abstract-algebra.group.def
-/
theorem mem_subgroup_iInf_iff {G : Type*} [Group G]
    {ι : Sort*} (H : ι → Subgroup G) (x : G) :
    x ∈ ⨅ i, H i ↔ ∀ i, x ∈ H i := by
  exact Subgroup.mem_iInf

/-- 子群上确界的序刻画：`H ⊔ K ≤ L` 当且仅当 H、K 都包含于 L。
> **Entry**: abstract-algebra.group.def
-/
theorem subgroup_sup_le_iff {G : Type*} [Group G] (H K L : Subgroup G) :
    H ⊔ K ≤ L ↔ H ≤ L ∧ K ≤ L := by
  exact sup_le_iff

/-- 子群下确界的序刻画：`L ≤ H ⊓ K` 当且仅当 L 同时包含于 H、K。
> **Entry**: abstract-algebra.group.def
-/
theorem subgroup_le_inf_iff {G : Type*} [Group G] (H K L : Subgroup G) :
    L ≤ H ⊓ K ↔ L ≤ H ∧ L ≤ K := by
  exact le_inf_iff

/-- 单元素集合生成的子群就是该元素的所有整数次幂组成的子群。
> **Entry**: abstract-algebra.group.def
-/
theorem generatedSubgroup_singleton_eq_zpowers {G : Type*} [Group G] (g : G) :
    generatedSubgroup ({g} : Set G) = Subgroup.zpowers g := by
  exact (Subgroup.zpowers_eq_closure g).symm

/-- 同态把由 S 生成的子群映到由 `f(S)` 生成的子群。
这使得只在生成元上指定映射成为可能。
> **Entry**: abstract-algebra.group.def
-/
theorem map_generatedSubgroup {G N : Type*} [Group G] [Group N]
    (f : G →* N) (S : Set G) :
    Subgroup.map f (generatedSubgroup S) = generatedSubgroup (f '' S) := by
  exact MonoidHom.map_closure f S

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

/-- **右陪集元素刻画**：`x ∈ Ha` 当且仅当 `x a⁻¹ ∈ H`。
它与左陪集判据互为镜像，但在非交换群中二者不能混用。
> **Entry**: abstract-algebra.group.coset
-/
theorem right_coset_mem_iff {G : Type*} [Group G] (H : Subgroup G) (a x : G) :
    x ∈ MulOpposite.op a • (H : Set G) ↔ x * a⁻¹ ∈ H := by
  exact mem_rightCoset_iff a

/-- **右陪集相等判据**：`Ha = Hb` 当且仅当 `b a⁻¹ ∈ H`。
> **Entry**: abstract-algebra.group.coset
-/
theorem right_coset_eq_iff {G : Type*} [Group G] (H : Subgroup G) (a b : G) :
    MulOpposite.op a • (H : Set G) = MulOpposite.op b • (H : Set G) ↔
      b * a⁻¹ ∈ H := by
  exact _root_.rightCoset_eq_iff H

/-- 每个代表元都属于自己的右陪集 `Ha`。
> **Entry**: abstract-algebra.group.coset
-/
theorem right_coset_mem_self {G : Type*} [Group G] (H : Subgroup G) (a : G) :
    a ∈ MulOpposite.op a • (H : Set G) := by
  exact mem_own_rightCoset H.toSubmonoid a

/-- **陪集相交判据**：两个左陪集有公共元素，当且仅当它们相等。

向前方向取公共元素 `x`，则 `a⁻¹x,b⁻¹x ∈ H`，所以
`a⁻¹b = (a⁻¹x)(b⁻¹x)⁻¹ ∈ H`，由陪集相等判据得到结论。
> **Entry**: abstract-algebra.group.coset
-/
theorem left_coset_inter_nonempty_iff_eq {G : Type*} [Group G]
    (H : Subgroup G) (a b : G) :
    (a • (H : Set G) ∩ b • (H : Set G)).Nonempty ↔
      a • (H : Set G) = b • (H : Set G) := by
  constructor
  · rintro ⟨x, hxa, hxb⟩
    apply (_root_.leftCoset_eq_iff H).2
    have ha : a⁻¹ * x ∈ H := (left_coset_mem_iff H a x).1 hxa
    have hb : b⁻¹ * x ∈ H := (left_coset_mem_iff H b x).1 hxb
    have hid : a⁻¹ * b = (a⁻¹ * x) * (b⁻¹ * x)⁻¹ := by group
    rw [hid]
    exact H.mul_mem ha (H.inv_mem hb)
  · intro hab
    exact ⟨a, left_coset_mem_self H a, hab ▸ left_coset_mem_self H a⟩

/-- **陪集分割的核心性质**：任意两个左陪集或者相等，或者不相交。
配合每个元素属于自己的陪集，这说明左陪集把整个群分割成等势的块。
> **Entry**: abstract-algebra.group.coset
-/
theorem left_cosets_eq_or_disjoint {G : Type*} [Group G]
    (H : Subgroup G) (a b : G) :
    a • (H : Set G) = b • (H : Set G) ∨
      Disjoint (a • (H : Set G)) (b • (H : Set G)) := by
  by_cases hab : a • (H : Set G) = b • (H : Set G)
  · exact Or.inl hab
  · right
    rw [Set.disjoint_left]
    intro x hxa hxb
    exact hab ((left_coset_inter_nonempty_iff_eq H a b).1 ⟨x, hxa, hxb⟩)

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

/-- **Lagrange 的整除形式**：子群的阶整除群的阶。
这里使用 `Nat.card`，有限群时就是通常的有限基数；等式中的商因子正是子群指数。
> **Entry**: abstract-algebra.group.coset
-/
theorem subgroup_card_dvd_group_card {G : Type*} [Group G] (H : Subgroup G) :
    Nat.card H ∣ Nat.card G := by
  exact ⟨H.index, (lagrange H).symm⟩

/-- **元素阶整除群阶**：有限群中每个元素生成的循环子群之阶整除群阶。
这是 Lagrange 定理应用于循环子群 `⟨x⟩` 的标准推论。
> **Entry**: abstract-algebra.group.coset
-/
theorem element_order_dvd_group_order {G : Type*} [Group G] [Fintype G] (x : G) :
    orderOf x ∣ Fintype.card G := by
  exact orderOf_dvd_card

/-- **有限群中的幂公式**：对每个 `x ∈ G`，都有 `x ^ |G| = 1`。
它由元素阶整除群阶立即得到，是 Euler 与 Fermat 型合同的群论原型。
> **Entry**: abstract-algebra.group.coset
-/
theorem pow_group_order_eq_one {G : Type*} [Group G] [Fintype G] (x : G) :
    x ^ Fintype.card G = 1 := by
  exact pow_card_eq_one

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
  -- 因 H 正规，共轭 b·(a·b)·b⁻¹ ∈ H；化简得 b·a ∈ H
  have h2 := nH.conj_mem (a * b) h b
  have : b * (a * b) * b⁻¹ = b * a := by
    group
  rwa [this] at h2

/-- **平凡子群正规**：只含单位元的子群是正规子群。 
> **Entry**: abstract-algebra.group.normal
-/
theorem normal_bot {G : Type*} [Group G] : (⊥ : Subgroup G).Normal := by
  refine Subgroup.Normal.mk ?_
  intro n hn g
  have hn1 : n = 1 := Subgroup.mem_bot.mp hn
  rw [hn1, mul_one, mul_inv_cancel]
  exact Subgroup.mem_bot.mpr rfl

/-- **全子群正规**：整个群自身是正规子群。 
> **Entry**: abstract-algebra.group.normal
-/
theorem normal_top {G : Type*} [Group G] : (⊤ : Subgroup G).Normal := by
  refine Subgroup.Normal.mk ?_
  intro n hn g
  exact Subgroup.mem_top (g * n * g⁻¹)

/-- **商群投影保乘法**：自然同态 `mk : G → G⧸H` 是同态（`↑(a*b) = ↑a * ↑b`）。 
> **Entry**: abstract-algebra.group.normal
-/
theorem quotient_mk_mul {G : Type*} [Group G] (H : Subgroup G) (nH : H.Normal) (a b : G) :
    QuotientGroup.mk (s := H) (a * b) =
      QuotientGroup.mk (s := H) a * QuotientGroup.mk (s := H) b := by
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
theorem hom_map_one {G M : Type*} [Group G] [Group M] (f : G →* M) : f 1 = 1 := by
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
  -- f a⁻¹ · f a = f(a⁻¹·a) = f 1 = 1，故 f a⁻¹ = (f a)⁻¹
  apply eq_inv_of_mul_eq_one_left
  calc
    f a⁻¹ * f a = f (a⁻¹ * a) := by rw [f.map_mul]
    _ = f 1 := by rw [inv_mul_cancel]
    _ = 1 := by rw [f.map_one]

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

end AbstractAlgebra.Group

end SandronesLibrary
