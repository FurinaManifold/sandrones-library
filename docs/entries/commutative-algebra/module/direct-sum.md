---
id: commutative-algebra.module.direct-sum
family: commutative-algebra.module
variant: textbook
kind: theorem
state: verified
title: 内外直和与分解判据
summary: "内直和（两项互补 `IsCompl`）与分解判据 `∀ x, ∃! yz : p × q, yz.1 + yz.2 = x` 的双向证明、外直和 `⨁ i, M i` 的坐标刻画与泛性质（唯一性半本库自证）、以及族版本内直和 `DirectSum.Decomposition` 的桥与两项情形下两种拼写的双向等价"
premises: [commutative-algebra.module.definition]
mathlib: [IsCompl, Disjoint, Submodule.prodEquivOfIsCompl, DirectSum, DirectSum.of, DirectSum.lof, DirectSum.toModule, DirectSum.component, DirectSum.Decomposition, DirectSum.IsInternal, DirectSum.decomposeLinearEquiv, DirectSum.isInternal_submodule_iff_isCompl, DirectSum.Decomposition.isInternal]
provenance:
  source_type: book
  ref: "atiyah-macdonald-commutative-algebra-1969"
---

# 动机

Atiyah–Macdonald 第 2 章讲完模、子模、模同态之后，马上要做一件结构性的工作：**把模拆开**。
`M = M₁ + M₂` 这样的「和」什么时候是「直和」？为什么教材要把「内直和」（子模互补，`M` 本身
就是两个子模拼起来的）与「外直和」（从一族模 `M_i` 造出一个**新**模 `⨁ M_i`）分成两件事讲，
又为什么必须说明它们其实是一回事？

三条理由说明这一条目不能省：

1. **后面的整条课程线都踩在它上面。** 有限生成模里「生成元可以去掉冗余」用的是直和分解；
   自由模 `R^n` 的定义就是 `R` 的 `n` 重外直和；正合序列的「分裂」说的是短正合列
   `0 → A → B → C → 0` 什么时候同构于 `0 → A → A ⊕ C → C → 0`；投射模与内射模的定义
   都要靠直和来陈述。没有「内/外直和 + 分解判据」这一层，CA2 的四个条目无从开口。
2. **它是一个判据（iff），不是一条性质。** 教材的定义是「`M = p + q` 且 `p ∩ q = 0`」，
   而真正好用的形式是「每个 `x` 的分解存在且唯一」。这两者等价这件事需要证明，而且证明里
   定义的两半各用一次——存在性用「和是整个模」，唯一性用「交为零」。本条目把这个双向证明
   完整写出来（`isCompl_iff_existsUnique_decomposition`），两个方向都是自己证的。
3. **内外两种拼写在 Lean 里由两个不同的载体承载，这件事本身必须交代。** 两项内直和的载体是
   **序论谓词** `IsCompl`（`PartialOrder` + `BoundedOrder` 层面，不是 `Submodule` 专用谓词）；
   族版本内直和的载体是 Mathlib 的**类** `DirectSum.Decomposition ℳ`；外直和的载体是
   `DirectSum ι M`（底层是 `DFinsupp`）。不把三者的关系钉死，读者会在「为什么这里用
   `IsCompl`、那里用 `Decomposition`」上迷路。

本条目只做 CA1 的这一层：内外直和的定义、分解判据、泛性质、以及两者的桥。有限生成、自由模与
秩、正合序列、投射/内射/平坦、张量积与局部化都不在本批范围内（冻结）。

# 直觉

**内直和**说的是「`M` 已经是两个子模拼起来的」：`p` 与 `q` 都住在 `M` 里面，`M` 的每个元素
都能写成 `p` 里的东西加 `q` 里的东西，而且这种写法**唯一**。

「唯一」不是装饰。取 `M = R × R`：若 `p = R × 0`、`q = 0 × R`，分解唯一；但若取
`p = R × 0`、`q = ⊤`，则 `p + q = M` 照样成立，可是每个元素都有无穷多种写法——因为
`p ∩ q = 0` 不成立。**所以「`p + q = M`」单独不够，必须同时有「`p ∩ q = 0`」。** 这正是教材
定义里两条都要写的原因，也是本条目把它做成判据的意义：判据把「和是整个模」与「交为零」
两件事一次说成「分解存在且唯一」。

**外直和**说的是「从一族模造一个新模」：`⨁_{i ∈ I} M_i` 的元素是**有限支撑族**
`(x_i)_{i ∈ I}`（只有有限多个 `i` 使 `x_i ≠ 0`），加法与数乘逐分量定义。它与笛卡尔积
`∏_i M_i` 的差别就在「有限支撑」四个字上——指标集有限时两者相同，无限时不同。教材把外直和
当成**新对象**：它不在原来的 `M` 里面，`M_i` 通过标准嵌入 `x ↦ (…, 0, x, 0, …)` 住进去，
而泛性质（`directSum_existsUnique_toModule`）说「要定义一个从外直和出发的线性映射，只需在
每个分量上给一个线性映射，且这种给法唯一」。

**两者的差别与桥。** 差别在「住在哪里」：内直和的子模是**同一个 `M` 的子集**，外直和是
**新造的模**。桥是「分解同构」：说 `M` 是各 `ℳ i` 的内直和，等价于说有一个同构
`M ≅ ⨁ i, ℳ i`，它把 `ℳ i` 的元素送到第 `i` 个坐标、把 `M` 的元素送到它的分量族。
Mathlib 把这件事做成一个**带数据的类** `DirectSum.Decomposition ℳ`：它不只说「同构存在」，
而是直接给出映射 `M → ⨁ i, ℳ i` 并证明它是重组映射的左右逆。所以它比命题版内直和
（`DirectSum.IsInternal`：`⨆ i, ℳ i = ⊤` 且各分量线性无关）更强，也更好用——分量可以真的
算出来（`internalDirectSum_decompose_of_mem_same` / `_of_mem_ne`）。

**具体例子**（下面这段在 `/tmp` scratch 文件里机器验证过，不属于条目公开声明）：

```lean
-- M = R × R，p = R × 0 = ker snd，q = 0 × R = ker fst
example {R : Type*} [CommRing R] :
    IsCompl (LinearMap.ker (LinearMap.snd R R R)) (LinearMap.ker (LinearMap.fst R R R)) := by
  rw [isCompl_iff_disjoint_sup_eq_top]
  constructor
  · rw [Submodule.disjoint_def]
    intro x hx hy
    rw [LinearMap.mem_ker] at hx hy
    exact Prod.ext hy hx
  · rw [Submodule.eq_top_iff']
    intro x
    refine Submodule.mem_sup.mpr ⟨(x.1, 0), ?_, (0, x.2), ?_, ?_⟩
    · rw [LinearMap.mem_ker]; rfl
    · rw [LinearMap.mem_ker]; rfl
    · ext <;> simp
```

`x ∈ p` 是 `x.2 = 0`，`x ∈ q` 是 `x.1 = 0`，故 `p ⊓ q = ⊥`；而 `x = (x.1, 0) + (0, x.2)`
给出 `p ⊔ q = ⊤`。于是分解判据说 `(a, b)` 有唯一分解 `(a, 0) + (0, b)`，重组同构
`p × q ≃ₗ[R] M` 就是 `((a,0), (0,b)) ↦ (a, b)`。这个例子是本条目所有陈述的模型。

# 陈述（自然语言）

**定义 1（内直和，两项）**。设 `p q` 是交换环 `A` 上模 `M` 的子模。称 `M` 是 `p` 与 `q` 的
内直和（记 `M = p ⊕ q`），若

1. `p + q = M`：每个 `x ∈ M` 可写成 `x = y + z`，其中 `y ∈ p`、`z ∈ q`；
2. `p ∩ q = 0`：`p` 与 `q` 唯一的公共元素是零。

**定理 1（分解判据）**。`M = p ⊕ q` **当且仅当**每个 `x ∈ M` 都有唯一的分解
`x = y + z`（`y ∈ p`、`z ∈ q`）。精确地：
`IsCompl p q ↔ ∀ x : M, ∃! yz : p × q, yz.1 + yz.2 = x`。

**命题 1（重组同构）**。若 `M = p ⊕ q`，则配对重组 `(y, z) ↦ y + z` 是线性同构
`p × q ≃ₗ[A] M`（`prodEquivOfIsCompl_apply`）。注意**不能**反过来说「存在某个同构
`p × q ≃ₗ[A] M` 就互补」：取 `M = R²`、`p = q = R × 0`，则 `p × q ≃ₗ[R] R²` 而
`p ⊓ q = p ≠ 0`。本条目形式化的正是「互补 ⟹ 重组映射是同构，且它确实是 `y + z`」这一半。

**定义 2（外直和）**。给定一族 `A`-模 `(M_i)_{i ∈ I}`，其外直和 `⨁_{i ∈ I} M_i` 是有限支撑族
的集合 `{(x_i)_{i ∈ I} : 只有有限多个 i 使 x_i ≠ 0}`，带逐分量加法与数乘。标准嵌入
`ι_i : M_i → ⨁_j M_j` 把 `x` 送到「第 `i` 个坐标是 `x`、其余坐标是 `0`」的族。

**定理 2（外直和的泛性质）**。对任意一族线性映射 `φ_i : M_i → N`，存在**唯一**的线性映射
`g : ⨁_i M_i → N` 使 `g ∘ ι_i = φ_i` 对一切 `i` 成立。

**定义 3（族版本的内直和 / 分解）**。设 `ℳ : I → Submodule A M` 是一族子模。称 `M` 分解为
`ℳ` 的直和，若每个 `x ∈ M` 都能唯一地写成有限和 `x = Σ_{i ∈ F} y_i`（`y_i ∈ ℳ i`）。
Mathlib 用带数据的类 `DirectSum.Decomposition ℳ` 承载它，并附带同构
`M ≃ₗ[A] ⨁ i, ℳ i`。

**定理 3（分量刻画）**。在上述分解下，若 `x ∈ ℳ i`，则 `x` 的第 `i` 个分量是 `x` 本身，
而第 `j` 个分量（`j ≠ i`）是 `0`。

**定理 4（两项情形：两种拼写是同一件事）**。当指标集只有两个元素时，
`IsCompl p q ↔ DirectSum.IsInternal ![p, q] ↔ Nonempty (DirectSum.Decomposition ![p, q])`。
也就是说：两项内直和（`IsCompl`）与族版本内直和（`Decomposition`）在两项情形下是
**双向等价**的两种拼写，不是两套数学。

# 陈述（Lean 对照）

```lean
-- 正式承载（Mathlib）：
--   IsCompl p q            ：内直和（序论谓词，PartialOrder + BoundedOrder 层面）
--   DirectSum ι M          ：外直和 ⨁ i, M i（底层 DFinsupp，即有限支撑族）
--   DirectSum.Decomposition ℳ：族版本的内直和（带数据的类）
--   Submodule.prodEquivOfIsCompl h : (p × q) ≃ₗ[R] M：重组同构

/-- (A1) 内直和 = 交为零 + 和是整个模 -/
theorem isCompl_iff_disjoint_sup_eq_top {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (p q : Submodule R M) :
    IsCompl p q ↔ Disjoint p q ∧ p ⊔ q = ⊤

/-- (A2) 和模的成员刻画 -/
theorem mem_sup_iff_exists_add {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    {p q : Submodule R M} {x : M} :
    x ∈ p ⊔ q ↔ ∃ y ∈ p, ∃ z ∈ q, y + z = x

/-- (A3) 分解的存在半 -/
theorem exists_add_of_isCompl {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    {p q : Submodule R M} (h : IsCompl p q) (x : M) :
    ∃ y ∈ p, ∃ z ∈ q, y + z = x

/-- (A4) 分解的唯一性半（分量形式） -/
theorem add_eq_add_iff_of_disjoint {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    {p q : Submodule R M} (h : Disjoint p q) {y y' : p} {z z' : q} :
    (y : M) + (z : M) = (y' : M) + (z' : M) ↔ y = y' ∧ z = z'

/-- (A5) 分解的唯一性半（配对形式，可直接喂给 ∃!） -/
theorem decomposition_unique_of_disjoint {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    {p q : Submodule R M} (h : Disjoint p q) {x : M}
    {yz yz' : p × q} (h₁ : (yz.1 : M) + (yz.2 : M) = x)
    (h₂ : (yz'.1 : M) + (yz'.2 : M) = x) : yz = yz'

/-- (A6) 分解判据（本条目主定理） -/
theorem isCompl_iff_existsUnique_decomposition {R M : Type*} [CommRing R] [AddCommGroup M]
    [Module R M] (p q : Submodule R M) :
    IsCompl p q ↔ ∀ x : M, ∃! yz : p × q, (yz.1 : M) + (yz.2 : M) = x

/-- (A7) 重组同构就是 (y, z) ↦ y + z -/
theorem prodEquivOfIsCompl_apply {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (p q : Submodule R M) (h : IsCompl p q) (yz : p × q) :
    Submodule.prodEquivOfIsCompl p q h yz = (yz.1 : M) + (yz.2 : M)

/-- (B1) 外直和的坐标：of i x 在第 i 个坐标是 x -/
theorem directSum_of_apply_same {R : Type*} [CommRing R] {ι : Type*} [DecidableEq ι]
    {M : ι → Type*} [∀ i, AddCommGroup (M i)] [∀ i, Module R (M i)] (i : ι) (x : M i) :
    (DirectSum.of M i x) i = x

/-- (B2) 外直和的坐标：j ≠ i 处是 0 -/
theorem directSum_of_apply_of_ne {R : Type*} [CommRing R] {ι : Type*} [DecidableEq ι]
    {M : ι → Type*} [∀ i, AddCommGroup (M i)] [∀ i, Module R (M i)]
    (i j : ι) (x : M i) (h : j ≠ i) : (DirectSum.of M i x) j = 0

/-- (B3) 泛性质：存在半 -/
theorem directSum_toModule_lof {R : Type*} [CommRing R] {ι : Type*} [DecidableEq ι]
    {M : ι → Type*} [∀ i, AddCommGroup (M i)] [∀ i, Module R (M i)]
    {N : Type*} [AddCommGroup N] [Module R N] (φ : ∀ i, M i →ₗ[R] N) (i : ι) (x : M i) :
    DirectSum.toModule R ι N φ (DirectSum.lof R ι M i x) = φ i x

/-- (B4) 泛性质：唯一性半（本文件自证，走 DirectSum.induction_on） -/
theorem directSum_toModule_unique {R : Type*} [CommRing R] {ι : Type*} [DecidableEq ι]
    {M : ι → Type*} [∀ i, AddCommGroup (M i)] [∀ i, Module R (M i)]
    {N : Type*} [AddCommGroup N] [Module R N] (φ : ∀ i, M i →ₗ[R] N)
    (g : (⨁ i, M i) →ₗ[R] N) (hg : ∀ (i : ι) (x : M i), g (DirectSum.lof R ι M i x) = φ i x) :
    g = DirectSum.toModule R ι N φ

/-- (B5) 泛性质的 iff 打包 -/
theorem directSum_lof_ext_iff {R : Type*} [CommRing R] {ι : Type*} [DecidableEq ι]
    {M : ι → Type*} [∀ i, AddCommGroup (M i)] [∀ i, Module R (M i)]
    {N : Type*} [AddCommGroup N] [Module R N] (φ : ∀ i, M i →ₗ[R] N) (g : (⨁ i, M i) →ₗ[R] N) :
    g = DirectSum.toModule R ι N φ ↔ ∀ (i : ι) (x : M i), g (DirectSum.lof R ι M i x) = φ i x

/-- (B6) 泛性质：存在唯一 -/
theorem directSum_existsUnique_toModule {R : Type*} [CommRing R] {ι : Type*} [DecidableEq ι]
    {M : ι → Type*} [∀ i, AddCommGroup (M i)] [∀ i, Module R (M i)]
    {N : Type*} [AddCommGroup N] [Module R N] (φ : ∀ i, M i →ₗ[R] N) :
    ∃! g : (⨁ i, M i) →ₗ[R] N, ∀ (i : ι) (x : M i), g (DirectSum.lof R ι M i x) = φ i x

/-- (B7) 坐标映射就是取值 -/
theorem directSum_component_apply {R : Type*} [CommRing R] {ι : Type*}
    {M : ι → Type*} [∀ i, AddCommGroup (M i)] [∀ i, Module R (M i)]
    (i : ι) (v : ⨁ i, M i) : DirectSum.component R ι M i v = v i

/-- (C1) 桥：内直和（族版本）给出 M ≃ₗ[R] ⨁ i, ℳ i -/
noncomputable def internalDirectSum_decomposeLinearEquiv {R : Type*} [CommRing R] {ι : Type*}
    [DecidableEq ι] {M : Type*} [AddCommGroup M] [Module R M] (ℳ : ι → Submodule R M)
    [DirectSum.Decomposition ℳ] : M ≃ₗ[R] ⨁ i, ℳ i

/-- (C2) 分量刻画：x ∈ ℳ i 的第 i 个分量就是 x -/
theorem internalDirectSum_decompose_of_mem_same {R : Type*} [CommRing R] {ι : Type*}
    [DecidableEq ι] {M : Type*} [AddCommGroup M] [Module R M] (ℳ : ι → Submodule R M)
    [DirectSum.Decomposition ℳ] {x : M} {i : ι} (hx : x ∈ ℳ i) :
    ((internalDirectSum_decomposeLinearEquiv ℳ x) i : M) = x

/-- (C3) 分量刻画：x ∈ ℳ i 的第 j 个分量（j ≠ i）是 0 -/
theorem internalDirectSum_decompose_of_mem_ne {R : Type*} [CommRing R] {ι : Type*}
    [DecidableEq ι] {M : Type*} [AddCommGroup M] [Module R M] (ℳ : ι → Submodule R M)
    [DirectSum.Decomposition ℳ] {x : M} {i j : ι} (hx : x ∈ ℳ i) (hij : i ≠ j) :
    ((internalDirectSum_decomposeLinearEquiv ℳ x) j : M) = 0

/-- (C4) 桥的逆就是重组 -/
theorem internalDirectSum_decomposeLinearEquiv_symm_lof {R : Type*} [CommRing R] {ι : Type*}
    [DecidableEq ι] {M : Type*} [AddCommGroup M] [Module R M] (ℳ : ι → Submodule R M)
    [DirectSum.Decomposition ℳ] (i : ι) (x : ℳ i) :
    (internalDirectSum_decomposeLinearEquiv ℳ).symm (DirectSum.lof R ι (fun i => ℳ i) i x) = x

/-- (C5) 两项情形：IsCompl 就是 DirectSum.IsInternal -/
theorem isCompl_iff_isInternal_fin_two {R : Type*} [CommRing R] {M : Type*} [AddCommGroup M]
    [Module R M] (p q : Submodule R M) :
    IsCompl p q ↔ DirectSum.IsInternal ![p, q]

/-- (C6) 由互补性造出分解结构 -/
@[instance_reducible]
noncomputable def decompositionOfIsCompl {R : Type*} [CommRing R] {M : Type*} [AddCommGroup M]
    [Module R M] (p q : Submodule R M) (h : IsCompl p q) :
    DirectSum.Decomposition ![p, q]

/-- (C7) 两项情形的落地：IsCompl 给出 M ≃ₗ[R] ⨁ i : Fin 2, ![p, q] i -/
noncomputable def internalDirectSum_decomposeLinearEquiv_fin_two {R : Type*} [CommRing R]
    {M : Type*} [AddCommGroup M] [Module R M] (p q : Submodule R M) (h : IsCompl p q) :
    M ≃ₗ[R] ⨁ i : Fin 2, ![p, q] i

/-- (C8) 两项情形：互补 ⟺ 分解结构存在（双向等价） -/
theorem isCompl_iff_nonempty_decomposition_fin_two {R : Type*} [CommRing R] {M : Type*}
    [AddCommGroup M] [Module R M] (p q : Submodule R M) :
    IsCompl p q ↔ Nonempty (DirectSum.Decomposition ![p, q])
```

三条说明：

1. **(A) 与 (B) 的对象层级不同**，这是刻意的。内直和的载体 `IsCompl` 写在
   `{R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]` 上（教材设定）；外直和的对象
   本来就是**一族**模，所以 (B) 的载体写成 `{M : ι → Type*}` 加 `[∀ i, AddCommGroup (M i)]`
   与 `[∀ i, Module R (M i)]`——这不是把教材陈述弱化到 Mathlib 的一般性
   （`Semiring`/`AddCommMonoid`），而是教材 `⨁_{i ∈ I} M_i` 的忠实载体。
2. **(B) 的唯一性半是自己证的。** Mathlib 里没有整体形式的 `DirectSum.toModule_unique`
   （该名字 `#check` 报 `Unknown constant`）；它有的是逐元素形式 `DirectSum.toModule.unique`
   与 `@[ext]` 形式 `DirectSum.linearMap_ext`。本条目按教材用 `DirectSum.induction_on`
   重新证明整体形式，并在 docstring 里如实披露这两条等价形态的存在。
3. **(C) 的 `Decomposition` 是类而不是命题。** 因此「两项情形下 `IsCompl` 与它等价」不能写成
   裸的 `↔`，而写成 `↔ Nonempty (DirectSum.Decomposition ![p, q])`（Mathlib 已证
   `Decomposition` 是 `Subsingleton`，所以 `Nonempty` 就是「分解结构存在」这个命题）。

# 思维脉络（thinking trace）

1. **侦察（47 条 `#check` 一次跑完）。** 先把三块要用的名字全部交给编译器，钉死隐式参数与
   参数顺序。三条关键发现：
   - `Submodule.prodEquivOfIsCompl` 的类型是 `(p q : Submodule R E) → IsCompl p q → (p × q) ≃ₗ[R] E`，
     `h` 是**最后一个显式参数**；`Submodule.coe_prodEquivOfIsCompl'` 的证明体就是 `rfl`。
   - 派工包点名的 `DirectSum.toModule_unique` 确实不存在，但 `DirectSum.toModule.unique`
     （逐元素）与 `DirectSum.linearMap_ext`（`@[ext]`）存在——所以「唯一性半必须自证」这句话
     对整体形式成立，对逐元素形式不成立，文档里如实写清。
   - **派工包漏报了一条关键接口**：`DirectSum.isInternal_submodule_iff_isCompl`
     （`IsInternal A ↔ IsCompl (A i) (A j)`，当指标集恰为 `{i, j}`）。这条正是两项情形
     拉伸的钥匙，比手写 `Submodule.projectionOnto` 造分解映射便宜得多。
2. **`⨁` 记号的坑。** 文件里不加 `open scoped DirectSum` 时，`⨁ i, M i` 会被解析成**范畴论
   的双积记号**（`CategoryTheory.Limits`），报错却伪装成类型不匹配
   （`DirectSum.toModule ... has type (DirectSum ι fun i => M i) →ₗ[R] N but is expected to have
   type ?m.33 →ₗ[R] N`）与「`unexpected token ','`」。最小复现（`/tmp/ca_b2_ds/mini.lean`）
   确认根因后加 `open scoped DirectSum` 解决。教训：记号报错要先怀疑记号在不在 scope 里，
   不要顺着类型不匹配去改定义。
3. **分解判据的证明结构。** 没有把双向一次写死，而是先立一条独立引理
   `add_eq_add_iff_of_disjoint`（唯一性半的分量形式）：由 `y + z = y' + z'` 移项得
   `y - y' = z' - z`，左端在 `p`、右端在 `q`，故这个元素在 `p ⊓ q = ⊥` 里，于是 `y = y'`；
   再约去 `y'` 得 `z = z'`。判据的正向（存在半 + 唯一性半）与反向（用 `(x, 0)` 与 `(0, x)`
   两个分解逼出 `x = 0`，再对任意 `x` 用存在性得 `x ∈ p ⊔ q`）都从它派生。
4. **移项与负号的细节（两次编译失败换来的）。** `sub_eq_sub_iff_add_eq_add` 的右端是
   `a + d = c + b`，与 `y + z = y' + z'` 差一个 `add_comm`；`q.neg_mem` 给的是
   `-(z' - z) ∈ q`，而需要的是 `z' - z ∈ q`——改用 `q.sub_mem z'.2 z.2` 直接得到，绕开
   `neg_sub`。另外 `Submodule.disjoint_def.mp h` 必须显式给元素（`∀ x ∈ p, ...` 的 `x` 不会
   自动推断），`ExistsUnique.unique` 的两个隐式 witness 也要显式写成 `(y₁ := …) (y₂ := …)`。
5. **`@[ext]` 抢占的坑。** 证明外直和的唯一性时，裸写 `ext v` 命中的不是 `LinearMap.ext`，
   而是被标了 `@[ext]` 的 `DirectSum.linearMap_ext`（它引入的是**指标** `i : ι`，不是元素），
   错误表现为「`v` 有类型 `ι` 但期望 `⨁ i, ?m i`」。改成 `apply LinearMap.ext; intro v`
   即可。这条写进了「应用与陷阱」。
6. **Fin 2 拉伸的三次弯路。**
   - 第一弯：把族写成 `fun i : Fin 2 => ![p, q]`——`![p, q]` **本身已经是** `Fin 2 → Submodule R M`，
     再加一层 lambda 得到的是「常函数返回函数」，于是 `SetLike` 合成失败。正确写法是直接用
     `![p, q]`。
   - 第二弯：`(Set.univ : Set (Fin 2)) = {0, 1}` 不能用 `decide`——`Set` 的 `DecidableEq` 是
     经典的（`Classical.choice` 卡住归约），要用 `ext i; fin_cases i <;> simp`。
   - 第三弯：反向比较里 `DirectSum.Decomposition.isInternal d` 与 `(ℳ := ![p,q]) d` 都推不出族，
     `letI := d` 能过但在 Prop 目标上触发 `let`/`letI` 风格警告；最终用**点记法** `d.isInternal`
     一次通过、零警告。
7. **公理核查（对照实验）。** 22 条声明 `#print axioms` 全部报
   `[propext, Classical.choice, Quot.sound]`。为了判断这是不是「我证出来的」，做了对照：
   Mathlib 自己的 `Submodule.mem_sup`、`DirectSum.of_eq_same`、`DirectSum.toModule_lof`、
   `DirectSum.decompose_of_mem_same`、`DirectSum.isInternal_submodule_iff_isCompl`、
   `DirectSum.IsInternal.chooseDecomposition` 报的是同样三条；又写了两个只有类型、没有证明
   内容的 `rfl` 探针：`p = p`（`Submodule`）**零公理**，而 `(IsCompl p q) = (IsCompl p q)`
   就已经带这三条。结论：`IsCompl`/`DirectSum` 相关陈述的公理足迹主要是**类型层**的
   （子模格的 `CompleteLattice` 与 `DirectSum`/`DFinsupp` 结构），与证明路径无关；真正在
   **证明体**里用 choice 的是 `decompositionOfIsCompl`（经 `IsInternal.chooseDecomposition` 的
   `Equiv.ofBijective`）与依赖它的 `internalDirectSum_decomposeLinearEquiv_fin_two`。
8. **角色分类（AGENTS §4 第 4 条要求的四类）见下一节。**

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| `M` 是 `p` 与 `q` 的内直和（互补） | `IsCompl p q` |
| 交为零 | `Disjoint p q`（可用 `Submodule.disjoint_def` 展开成 `∀ x ∈ p, x ∈ q → x = 0`） |
| 和是整个模 | `p ⊔ q = ⊤`（`⊔` 是子模格的上确界 = 教材的和） |
| 内直和的两条定义 | `isCompl_iff_disjoint_sup_eq_top` |
| `x ∈ p + q` | `x ∈ p ⊔ q` |
| 和的定义（一切 `y + z`） | `mem_sup_iff_exists_add` |
| 分解的存在性 | `exists_add_of_isCompl` |
| 分解的唯一性（分量） | `add_eq_add_iff_of_disjoint` |
| 分解的唯一性（配对） | `decomposition_unique_of_disjoint` |
| **分解判据** | `isCompl_iff_existsUnique_decomposition` |
| 重组 `(y, z) ↦ y + z` | `Submodule.prodEquivOfIsCompl p q h` + `prodEquivOfIsCompl_apply` |
| 外直和 `⨁_{i ∈ I} M_i` | `DirectSum ι M`（记号 `⨁ i, M i`，需 `open scoped DirectSum`） |
| 标准嵌入 `M_i → ⨁_j M_j` | `DirectSum.lof R ι M i`（线性映射版）/ `DirectSum.of M i`（加法版，同一映射） |
| 第 `i` 个坐标 | `v i`（`DFinsupp` 求值）= `DirectSum.component R ι M i v` |
| 坐标刻画（本位） | `directSum_of_apply_same` |
| 坐标刻画（异位） | `directSum_of_apply_of_ne` |
| 外直和的泛性质（存在） | `directSum_toModule_lof` |
| 外直和的泛性质（唯一） | `directSum_toModule_unique`（本库自证） |
| 泛性质的 iff 形式 | `directSum_lof_ext_iff` |
| 泛性质（存在唯一） | `directSum_existsUnique_toModule` |
| 坐标映射 = 求值 | `directSum_component_apply` |
| 族版本内直和（分解） | `DirectSum.Decomposition ℳ`（类） |
| 分解同构 `M ≅ ⨁ i, ℳ i` | `internalDirectSum_decomposeLinearEquiv ℳ` |
| 分量的计算（本位 / 异位） | `internalDirectSum_decompose_of_mem_same` / `_of_mem_ne` |
| 重组（桥的逆） | `internalDirectSum_decomposeLinearEquiv_symm_lof` |
| 两项情形：`IsCompl` = 族版本内直和 | `isCompl_iff_isInternal_fin_two`、`isCompl_iff_nonempty_decomposition_fin_two` |
| 由互补性造分解结构 | `decompositionOfIsCompl` |
| 两项情形的分解同构 | `internalDirectSum_decomposeLinearEquiv_fin_two` |

# Mathlib 角色分类（AGENTS §4 第 4 条）

本条目公开签名里出现的 Mathlib 专用对象，按四类逐项归属。

**1. 语义一致的正式公开承载（推荐复用）。**

- `IsCompl`（+ 它展开出的 `Disjoint`、`Codisjoint`、`⊔`、`⊤`）：内直和的正式承载。
  它是**序论**谓词而不是 `Submodule` 专用谓词，这恰好与教材一致——「互补」本来就不是子模
  独有的概念（子群、理想、拓扑都谈互补）。Mathlib 对有限维除环上的子空间另有一条
  `Submodule.isCompl_iff_disjoint`，但它在 `[DivisionRing K] [FiniteDimensional K V]` 下，
  不在教材设定内，本条目不用它。
- `DirectSum ι M`（记号 `⨁ i, M i`）、`DirectSum.of`、`DirectSum.lof`、`DirectSum.toModule`、
  `DirectSum.component`：外直和及其标准嵌入、坐标、泛性质映射的正式承载。底层是 `DFinsupp`
  （有限支撑族），与教材「有限支撑族」逐字一致。
- `DirectSum.Decomposition ℳ`：族版本内直和的正式承载。**这是一个 typeclass，出现在公开签名
  里**（`internalDirectSum_decomposeLinearEquiv`、两条分量刻画、`symm_lof`、`decompositionOfIsCompl`、
  `isCompl_iff_nonempty_decomposition_fin_two`）。它被归入本类而不是「超出课程层级」的理由是：
  (i) 它的数学内容就是教材的「`M` 是各 `ℳ i` 的内直和」；(ii) 它只比命题版多带了「分解映射」
  这一份数据，而这份数据正是教材里「分解」二字所指的东西（不是新概念）；
  (iii) 它在本文件里是**被使用**的承载而不是被引用的高阶定理：`M ≃ₗ[R] ⨁ i, ℳ i` 这条桥
  必须靠它才能陈述。诚实补充：它是**类**（带数据、有 `Subsingleton` 实例），比教材里一条
  「唯一分解」命题更强；本条目把它当承载用，并在 `isCompl_iff_nonempty_decomposition_fin_two`
  里用 `Nonempty` 把它折回命题，避免把「带数据的结构存在」当成「性质成立」。
- `DirectSum.IsInternal ℳ`：命题版内直和（`⨆ i, ℳ i = ⊤` + 各分量线性无关）。出现在
  `isCompl_iff_isInternal_fin_two` 的公开签名里。归本类：它就是教材「`M` 是各 `ℳ i` 的直和」
  的命题形式。
- `Submodule.prodEquivOfIsCompl p q h : (p × q) ≃ₗ[R] M`：出现在 `prodEquivOfIsCompl_apply`
  的公开签名里。归本类：它就是教材的重组映射 `(y, z) ↦ y + z`，本文件只是公开地刻画它
  （证明它确实等于 `y + z`），没有另造等价结构。

**2. 本库特殊定义的桥。** 本条目**没有**「本库结构 ↔ Mathlib 结构」意义上的桥：本库的教材
记号（`IsSubspace`、`TwoSidedIdealSet` 等）不在本条目出现，本条目也不定义新对象。因此这一类
为空。与它最接近的是 (C) 块的**内外桥**（`internalDirectSum_decomposeLinearEquiv` 等），
但那是「同一个数学概念的两种 Mathlib 拼写之间的桥」，两端都是 Mathlib 的正式承载，
按上面的归属分别落在第 1 类，不构成第 2 类。

**3. 私有证明后端（只出现在 `:= by` 之后，不进公开签名）。** 本文件用到的后端名字：

- (A)：`isCompl_iff`、`codisjoint_iff`、`IsCompl.codisjoint`、`Submodule.mem_sup`、
  `Submodule.disjoint_def`、`Submodule.sub_mem`、`Submodule.eq_top_iff'`、`Submodule.mem_top`、
  `Submodule.coe_prodEquivOfIsCompl'`、`sub_eq_sub_iff_add_eq_add`、`sub_eq_zero`、
  `Subtype.ext`、`Subtype.ext_iff`、`Prod.ext`、`ExistsUnique.unique`、`add_left_cancel`、
  `add_comm`、`congrArg`。
- (B)：`DirectSum.of_eq_same`、`DirectSum.of_eq_of_ne`、`DirectSum.toModule_lof`、
  `DirectSum.lof_eq_of`、`DirectSum.induction_on`、`LinearMap.ext`、`map_add`。
- (C)：`DirectSum.decomposeLinearEquiv`、`DirectSum.decompose_of_mem_same`、
  `DirectSum.decompose_of_mem_ne`、`DirectSum.decomposeLinearEquiv_symm_lof`、
  `DirectSum.isInternal_submodule_iff_isCompl`、`DirectSum.IsInternal.chooseDecomposition`、
  `DirectSum.Decomposition.isInternal`、`Set.ext`（经 `ext` 策略）、`fin_cases`（策略）。
  （`Subsingleton (DirectSum.Decomposition ℳ)` 这个事实在叙事里引用，但本文件的证明体
  并没有调用它，因此不算后端。）

**4. 超出课程层级的公开泄漏。** 无。逐项核对过三处可疑点：

- (i) `[DecidableEq ι]` 出现在 (B) 与 (C) 的公开签名里——它是**技术性可判定性假设**
  （`DirectSum.of`/`lof` 经 `DFinsupp.single` 定义时需要判等），不是数学概念，也不构成
  课程层级泄漏。`directSum_component_apply` 一开始多写了这个假设，编译器实测不需要，已删。
- (ii) `Fin 2` 与向量记号 `![p, q]` 出现在 (C) 的公开签名里——它们只是「两项」这个指标集的
  写法（`![p, q]` 是 Mathlib 的 `Matrix.vecCons` 记号），没有引入超出直和的概念。
- (iii) `DirectSum.IsInternal`、`DirectSum.Decomposition` 都已在第 1 类里逐条辩护；本条目
  公开签名里没有商模、张量积、正合序列、投射/内射、范畴论语言。

**公理披露。** 22 条声明 `#print axioms` 全部为 `[propext, Classical.choice, Quot.sound]`。
对照实验（见「思维脉络」第 7 条）表明这一足迹主要来自**类型层**（子模格的 `CompleteLattice`、
`DirectSum`/`DFinsupp` 结构）：连只提类型、证明为 `rfl` 的
`(IsCompl p q) = (IsCompl p q)` 都报这三条，而 Mathlib 自己的同名引理报的也是这三条。
**证明体里真的用了 `Classical.choice` 的是**：`decompositionOfIsCompl`（走
`DirectSum.IsInternal.chooseDecomposition`，其 `Equiv.ofBijective` 非计算地取出逆映射），
以及依赖它的 `internalDirectSum_decomposeLinearEquiv_fin_two`；另外
`prodEquivOfIsCompl_apply` 的**陈述**含 Mathlib 的 `Submodule.prodEquivOfIsCompl`，
后者的定义体同样走 `LinearEquiv.ofBijective`。这是「数学上非构造」还是「形式化噪声」？
本条目判定为**结构性 choice**：`Decomposition` 类本身就携带「分解映射」这份数据，从纯存在性
命题（`IsInternal`）造出这份数据必须选一个逆，这与 Playbook §3 的「结构性 choice，接受」
一致；本文件没有为了消掉它而弱化任何陈述。

# 依赖（人话版）

- `commutative-algebra.module.definition`（CA1 定义层）：模、子模、模同态的教材定义。
  本条目所有陈述里的 `Submodule R M`、`M →ₗ[R] N`、`LinearMap.ker` 都来自它；外直和块里的
  `N` 与 `φ : ∀ i, M i →ₗ[R] N` 也是它的模同态。本条目是 CA1 里**第一个**把子模格结构
  （`⊔`、`⊓`、`⊤`、`⊥`、`Disjoint`）真正用起来的条目。
- 本条目没有别的库内前提。按 ROADMAP §13.1，它的前置就是 `CA1.definition`；
  有限生成、自由模、正合序列等下游条目（CA2）本批冻结。
- 上游的 `abstract-algebra.ring.def`、`abstract-algebra.ring.ideal`、
  `linear-algebra.vector-space.*` 是 `commutative-algebra.module.definition` 自己的前提，
  经它传递而来，不直接出现在本文件里。

# 应用与陷阱

- **应用（本条目概念的真实使用者）。** 分解判据是后面整条 CA 线的入口：
  自由模 `R^n = ⨁_{i ∈ Fin n} R` 用的是外直和；「`M` 由子模 `N` 与 `N'` 直和分解」是
  正合序列分裂的定义；投射模的「`P` 是某个自由模的直和项」也靠内直和陈述。此外
  `DirectSum.Decomposition` 的 `DirectSum.decompose`（本条目 (C) 的桥）是 Mathlib 里
  分次结构（`SetLike.IsHomogeneous`、`DirectSum.Decomposition.inductionOn`）的入口，
  本条目只取了它的两项/一般族两条最基础的用法。
- **陷阱 1（`p ⊔ q = ⊤` 单独不够）。** 必须同时有 `Disjoint p q`。最简单的反例取 `q = ⊤`：
  `p ⊔ ⊤ = ⊤` 恒成立，但只要 `p ≠ ⊥` 就 `¬ IsCompl p ⊤`（下面这段也在 `/tmp` scratch 里
  机器验证过）：

  ```lean
  example {R : Type*} [CommRing R] [Nontrivial R] {M : Type*} [AddCommGroup M] [Module R M]
      (p : Submodule R M) (hp : p ≠ ⊥) : ¬ IsCompl p ⊤ := by
    intro h
    apply hp
    rw [Submodule.eq_bot_iff]
    intro x hx
    exact (Submodule.disjoint_def.mp h.disjoint) x hx trivial
  ```

  教材把定义写成两条并列，正是因为这两条互相独立。
- **陷阱 2（`IsCompl` 是两项的，`Decomposition` 是族的）。** 前者是序论谓词，说「两个」
  子模互补；后者是带数据的类，说「一族」子模把 `M` 分解掉。两项情形下二者等价
  （`isCompl_iff_nonempty_decomposition_fin_two`），但**不能**把 `IsCompl` 直接套到
  「`⨆ i, ℳ i = ⊤`」上——`IsCompl` 只接受两个参数。族版本的「互补」是
  `DirectSum.IsInternal`（`⨆ i, ℳ i = ⊤` + 各分量线性无关）。`IsInternal` 与 `Decomposition`
  在**命题层面**等价（`DirectSum.Decomposition.isInternal` 是一个方向，
  `DirectSum.IsInternal.chooseDecomposition` 是另一个方向且非计算），但前者只是「重组映射是
  双射」这条命题，后者额外携带逆映射这份数据——用哪一个取决于你要的是性质还是可计算的分解。
- **陷阱 3（`⨁` 记号必须先 `open scoped DirectSum`）。** 不加 scope 时 `⨁` 落到范畴论双积
  记号上，报错是「类型不匹配 + 意外逗号」，很容易被误诊成 `DirectSum.toModule` 的参数问题。
- **陷阱 4（`ext` 可能命中 `DirectSum.linearMap_ext`）。** 目标是「从外直和出发的两个线性映射
  相等」时，`DirectSum.linearMap_ext` 被标了 `@[ext]`，裸写 `ext v` 会引入**指标** `v : ι`
  而不是元素；要证逐元素相等必须显式写 `apply LinearMap.ext; intro v`。
- **陷阱 5（`Decomposition` 是类，不能塞进 `↔` 的一侧）。** 它带数据（一个映射加两条逆律），
  写在 `↔` 左边会变成「类型等价」而不是命题。本条目用
  `Nonempty (DirectSum.Decomposition ![p, q])` 把它折回命题；由于 Mathlib 已证
  `Subsingleton (DirectSum.Decomposition ℳ)`，这个 `Nonempty` 就是「分解存在」的诚实写法。
- **陷阱 6（`decompositionOfIsCompl` 是 `def` 不是 `instance`）。** `IsCompl p q` 不是类型类，
  写成全局 `instance` 只会污染实例搜索而几乎搜不到（typeclass 搜索不会去猜 `IsCompl p q`）。
  需要时用 `letI` 局部装载（`internalDirectSum_decomposeLinearEquiv_fin_two` 就是这么写的），
  或者显式传给 `internalDirectSum_decomposeLinearEquiv`。
- **未完成边界（诚实清单）。**
  1. **只做了两项内直和 + 一般族分解**，没有做「有限多个子模的内直和判据」
     （例如 `IsCompl` 的 `n` 元推广、`iSupIndep` 的教材化展开）；`DirectSum.IsInternal` 的
     完整刻画（`isInternal_submodule_iff_iSupIndep_and_iSup_eq_top`）在 Mathlib 里有，
     本条目没有把它作为公开陈述暴露。
  2. **重组同构只做了一个方向，且反向命题是假的。** `prodEquivOfIsCompl_apply` 说的是
     「Mathlib 的重组同构确实等于 `y + z`」，即 `IsCompl p q ⟹ p × q ≃ₗ[R] M`。
     反过来的「存在同构 `p × q ≃ₗ[R] M` ⟹ `IsCompl p q`」**不成立**（因此本条目不是
     「只做了半边、另一半待补」，而是**刻意不做**）：取 `M = R²`、`p = q = R × 0`
     （`R` 非平凡），则 `p × q ≅ R × R ≅ M` 确有同构，但 `p ⊓ q = p ≠ ⊥`，
     故 `IsCompl p q` 为假。差别在于：互补性包含一条**位置信息**（`p ⊓ q = ⊥` 与
     `p ⊔ q = ⊤`，说的是这两个子模在 `M` 里怎么摆放），而「存在同构 `p × q ≃ₗ[R] M`」
     只约束两个子模各自的同构类型，完全不说它们在 `M` 里如何相交——上例里甚至 `p = q`。
     本条目在「陈述（自然语言）」与本节都显式标注这条不可反推。
  3. **外直和的泛性质只做了「映射出发」方向**（`⨁` 是余积）；没有做「映入 `⨁` 的映射由分量
     决定」的收口定理（那需要 `DirectSum.lof` 的线性无关性），也没有做 `⨁` 与 `∏` 在有限
     指标下的比较（`DirectSum.linearEquivFunOnFintype` 存在但未使用）。
  4. **两项情形的拉伸用的是 `DirectSum.isInternal_submodule_iff_isCompl` +
     `IsInternal.chooseDecomposition`**，没有按派工单的备选路线手写
     `Submodule.projectionOnto` 版本的分解映射；因此 `decompositionOfIsCompl` 是非计算的
     （带 `Classical.choice`），不是「显式给出 `x ↦ (p 分量, q 分量)`」的可计算公式。
  5. **没有做**：有限生成、自由模与基/秩、正合序列与分裂、投射/内射/平坦、张量积、局部化、
     分次代数、商模与同构定理（后两者是同批其它条目）。
