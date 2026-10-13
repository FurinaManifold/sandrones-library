---
id: commutative-algebra.module.definition
family: commutative-algebra.module
variant: textbook
kind: definition
state: verified
title: 模、子模与模同态
summary: 交换环上模、子模与模同态的教材定义与量词展开；子模的加法/数乘封闭刻画、模同态与线性映射的关系，以及它们在 Mathlib 中的角色分类
premises: [abstract-algebra.ring.def, abstract-algebra.ring.ideal, linear-algebra.vector-space.def, linear-algebra.vector-space.subspace]
mathlib: [Module, Submodule, LinearMap, LinearMap.ker, LinearMap.range]
provenance:
  source_type: book
  ref: "atiyah-macdonald-commutative-algebra-1969"
---

# 动机

交换代数把「环上的线性代数」系统化：Atiyah–Macdonald 第 2 章一开头就把**模**定义为
「交换环 `A` 通过一个作用 `A × M → M` 作用在阿贝尔群 `M` 上」。这不是为了抽象而抽象：
理想是 `A` 作为自身模的子模、商环是商模的特例、局部化是标量扩张、有限生成与 Noether 性
都是模的性质、整扩张的有限性也是模的有限性。整门课后面的对象都要住在同一个线性结构里，
所以定义层必须先钉死：模是什么、子模是什么、模同态是什么，它们各自在 Lean 里由谁承载。

本条目只做**定义层**。子集生成的子模、商模与同构定理、直和一律不在本批范围内（冻结），
它们是 CA1 后续条目；张量积、局部化更在 CA3 之后。

# 直觉

模就是把向量空间的「系数域」换成「交换环」。这一步换掉了两样东西：

- 环里的非零元不一定可逆，于是模会**带挠**：`ℤ/2ℤ` 作为 `ℤ`-模满足 `2·x = 0`，
  而线性代数里「非零向量组的系数必须全零」这类结论在模上没有对应物；
- 环里可能有零因子，于是「`ax = 0` 蕴含 `a = 0` 或 `x = 0`」也不成立。

但**定义本身**一字不改地照抄：分配律、结合律、单位律。所以模的教材层不是「新的数学」，
而是「把线性代数的定义搬到环上，并明确哪些直觉失效」。

子模的直觉同样简单：对加法与数乘封闭的非空子集。注意「非空」与「含 `0`」在模里等价
（取 `x ∈ N`，则 `0 = 0·x ∈ N`），这正是下面「等价刻画」一节要展开的量词。

当系数环是**域**时，模就是向量空间、模同态就是线性映射。本库的 L1 线
（`linear-algebra.vector-space.*`）用教材记号 `LinearSpace`/`IsSubspace` 承载这件事；
本条目给出它与 `Module`/`Submodule` 的桥。同理，A2 线用 `TwoSidedIdealSet` 承载理想，
而交换环上「`R` 作为自身模的子模」就是双边理想，本条目也给出桥。

# 陈述（自然语言）

**定义 1（模）**。设 `A` 是含单位元的交换环。一个 `A`-模是一个阿贝尔群 `M` 连同一个
作用 `A × M → M`，`(a, x) ↦ ax`，满足：

1. `a(x + y) = ax + ay`（数乘对加法分配）；
2. `(a + b)x = ax + bx`（环加法对作用分配）；
3. `(ab)x = a(bx)`（结合律）；
4. `1x = x`（单位律）。

由 1 与阿贝尔群结构可推出 `a·0 = 0`；由 2 可推出 `0·x = 0`。教材把 1 连同 `a·0 = 0`
打包成「`M` 是 `A` 上的分配作用」，把 2 连同 `0·x = 0` 打包进模结构。

**定义 2（子模）**。`M` 的子集 `N` 称为子模，若

1. `0 ∈ N`；
2. 对任意 `x, y ∈ N` 有 `x + y ∈ N`；
3. 对任意 `a ∈ A`、`x ∈ N` 有 `ax ∈ N`。

**命题 1（子模的等价刻画）**。`M` 的子集 `N` 是某个子模的载体，**当且仅当**它满足定义 2 的
三条封闭性。也就是说：`∃ S : Submodule A M, (S : Set M) = N` 与「`0 ∈ N` ∧ 加法封闭 ∧
数乘封闭」等价。（`⟹` 方向就是定义 2 本身；`⟸` 方向说明教材的三条封闭性足以装配出子模。）

**定义 3（模同态）**。映射 `f : M → N` 是 `A`-模同态，若

1. `f(x + y) = f(x) + f(y)`（加法保持）；
2. `f(ax) = a·f(x)`（数乘保持）。

等价地：`f` 是加法群同态且与数乘交换。由 1 可推出 `f(0) = 0`。**当 `A` 是域时**，
`A`-模就是 `A`-向量空间、`A`-模同态就是线性映射——两者是同一个概念的两个名字。

**子模的标准例子**。模同态 `f : M → N` 的**核** `ker f = {x ∈ M : f(x) = 0}` 与
**像** `im f = {f(x) : x ∈ M}` 都是子模（分别是 `M` 与 `N` 的子模）。这是「子模」这个
概念第一次被真实使用的地方，也是后续商模与同构定理的入口（后者本批冻结）。

# 陈述（Lean 对照）

```lean
-- 正式承载（Mathlib）：模、子模、模同态
--   Module R M       ：R-模结构（R 交换环，M 阿贝尔群）
--   Submodule R M    ：M 的子模
--   M →ₗ[R] N        ：M 到 N 的 R-模同态（= 线性映射）

/-- 模的六条教材公理 -/
theorem module_axioms {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (r s : R) (x y : M) :
    r • (x + y) = r • x + r • y ∧ (r + s) • x = r • x + s • x ∧
      (r * s) • x = r • (s • x) ∧ (1 : R) • x = x ∧ (0 : R) • x = 0 ∧ r • (0 : M) = 0

/-- 子模的必要条件：含零、加法封闭、数乘封闭 -/
theorem submodule_closure {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (S : Submodule R M) :
    (0 : M) ∈ S ∧ (∀ x ∈ S, ∀ y ∈ S, x + y ∈ S) ∧
      (∀ (a : R) (x : M), x ∈ S → a • x ∈ S)

/-- 子模的充分条件：三条封闭性装配出子模 -/
theorem submodule_of_closure {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    {s : Set M} (h0 : (0 : M) ∈ s) (hadd : ∀ x ∈ s, ∀ y ∈ s, x + y ∈ s)
    (hsmul : ∀ (a : R) (x : M), x ∈ s → a • x ∈ s) :
    ∃ S : Submodule R M, (S : Set M) = s

/-- 子模相等的判定：相等当且仅当逐点属于相同 -/
theorem submodule_eq_iff {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    {S T : Submodule R M} : S = T ↔ ∀ x, x ∈ S ↔ x ∈ T

/-- 模同态的刻画：加法保持 + 数乘保持 ⟹ 存在唯一的模同态 -/
theorem linearMap_iff {R M N : Type*} [CommRing R] [AddCommGroup M] [AddCommGroup N]
    [Module R M] [Module R N] (f : M → N) :
    (∃ F : M →ₗ[R] N, ⇑F = f) ↔
      (∀ x y : M, f (x + y) = f x + f y) ∧ (∀ (a : R) (x : M), f (a • x) = a • f x)

/-- 模同态相等的判定：相等当且仅当逐点相等 -/
theorem linearMap_ext_iff {R M N : Type*} [CommRing R] [AddCommGroup M] [AddCommGroup N]
    [Module R M] [Module R N] {F G : M →ₗ[R] N} : F = G ↔ ∀ x, F x = G x

/-- 模同态保持零元 -/
theorem linearMap_map_zero {R M N : Type*} [CommRing R] [AddCommGroup M] [AddCommGroup N]
    [Module R M] [Module R N] (F : M →ₗ[R] N) : F 0 = 0

/-- 核是子模：x ∈ ker F 当且仅当 F x = 0 -/
theorem linearMap_mem_ker_iff {R M N : Type*} [CommRing R] [AddCommGroup M] [AddCommGroup N]
    [Module R M] [Module R N] (F : M →ₗ[R] N) (x : M) :
    x ∈ LinearMap.ker F ↔ F x = 0

/-- 像是子模：y ∈ range F 当且仅当 y 是某个元素的像 -/
theorem linearMap_mem_range_iff {R M N : Type*} [CommRing R] [AddCommGroup M] [AddCommGroup N]
    [Module R M] [Module R N] (F : M →ₗ[R] N) (y : N) :
    y ∈ LinearMap.range F ↔ ∃ x, F x = y

/-- 本库桥（L1）：域上「子空间」与「子模」互相翻译 -/
theorem isSubspace_iff_exists_submodule {K V : Type*} [Field K] [AddCommGroup V]
    [LinearSpace K V] (W : Set V) :
    IsSubspace K W ↔ ∃ S : Submodule K V, (S : Set V) = W

/-- 本库桥（A2）：交换环上「双边理想」与「R 作为自身模的子模」互相翻译 -/
theorem twoSidedIdealSet_iff_exists_submodule_self {R : Type*} [CommRing R] (I : Set R) :
    AbstractAlgebra.Ring.TwoSidedIdealSet I ↔ ∃ S : Submodule R R, (S : Set R) = I
```

Lean 的正式承载是 Mathlib 的 `Module`、`Submodule`、`LinearMap`（记号 `M →ₗ[R] N`），
三者语义与教材定义逐条一致，本库**不另造结构**（AGENTS §4：不为了制造本库名称重造等价
结构）。本库自己陈述的是 Mathlib 没有同形版本的**教材命题**：`module_axioms`（六条公理的
合取展开）、`submodule_closure`/`submodule_of_closure`（定义 2 与命题 1 的两个方向）、
`linearMap_iff`（定义 3 的存在性刻画），以及两条**桥**。

# 思维脉络（thinking trace）

1. 先问「Mathlib 的 `Module` 与教材定义是否逐条一致」。`#print Module` 给出：父类
   `DistribMulAction R M`（携带 `SMul.smul`、`mul_smul`、`one_smul`、`smul_zero`、`smul_add`）
   加自有字段 `Module.add_smul`、`Module.zero_smul`——正好是定义 1 的六条。于是以 `Module`
   为**正式承载**，不建包装类。
2. 子模：`Submodule R M` 的构造子需要「加法子幺半群 + 数乘封闭」，与定义 2 的三条一致。
   但「三条封闭 ⟹ 子模」这条教材命题在 Mathlib 里没有现成的 `↔`，所以本库补
   `submodule_of_closure`（构造）与 `submodule_closure`（投影），两条合起来就是命题 1。
3. 模同态：Mathlib 没有单独的 `ModuleHom`，`LinearMap R M N` 就是模同态，`M →ₗ[R] N` 是它的
   记号。它在 Mathlib 内部的父结构是 `AddHom`（不是 `AddMonoidHom`），因此
   `LinearMap.mk (AddHom.mk f hadd) hsmul` 就能装配——**加法保持 + 数乘保持已经足够**，
   `f(0) = 0` 是推出来的（`linearMap_map_zero`）。这与教材把 `f(0)=0` 单独列出的写法形成
   对照，写进「应用与陷阱」。
4. 桥一（L1）：L1 用 `IsSubspace K W`（`W.Nonempty ∧ 加法封闭 ∧ 数乘封闭`）作为子空间的
   教材记号。它与 `Submodule K V` 的载体一一对应；注意 L1 用**非空**而不是 `0 ∈ W`，
   桥接时先用 `0 = 0·v` 把非空换成含零，再套 `submodule_of_closure`。
5. 桥二（A2）：A2 用 `TwoSidedIdealSet I`（`LeftIdealSet I ∧ RightIdealSet I`）作为理想的
   教材记号。交换环上 `Submodule R R` 的数乘就是乘法 `r • x = r * x`，所以「`R` 的子模」
   与「双边理想」是同一批集合；反向的负元由 `(-1) • x` 给出，右吸收由 `mul_comm` 给出。
   补充一条实测事实：本版 Mathlib 里 `Ideal R` 就是 `@[reducible] def Ideal R [Semiring R] :=
   Submodule R R`（`#print Ideal` 的真实输出），所以 `Ideal.ofSubmodule`/`Submodule.toIdeal`/
   `Ideal.toSubmodule` 这三个名字**不存在也不需要**——`Ideal R` 与 `Submodule R R` 是同一个
   类型（`(I : Set R) = (I : Submodule R R)` 可用 `rfl` 判定）。A2 已有的
   `twoSidedIdealSet_iff_exists_ideal` 用 `Ideal` 陈述同一等价；本条目给出的
   `twoSidedIdealSet_iff_exists_submodule_self` 是它在 CA1 词汇（`Submodule R R`）下的版本，
   价值在于让读者不离开模的词汇就看到「理想 = `R` 的子模」。
6. 角色分类（AGENTS §4 第 4 条要求的四类）见下一节。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 交换环 `A` 上的模 `M` | `Module R M`（`[CommRing R] [AddCommGroup M]`） |
| 数乘 `a·x` | `a • x` |
| 模的六条公理 | `module_axioms`（`smul_add`/`add_smul`/`mul_smul`/`one_smul`/`zero_smul`/`smul_zero`） |
| 子模 `N ≤ M` | `Submodule R M` |
| `N` 含零 | `(0 : M) ∈ S`（`S.zero_mem`） |
| `N` 加法封闭 | `∀ x ∈ S, ∀ y ∈ S, x + y ∈ S`（`S.add_mem`） |
| `N` 数乘封闭 | `∀ a x, x ∈ S → a • x ∈ S`（`S.smul_mem`） |
| 三条封闭 ⟹ 子模 | `submodule_of_closure` |
| 子模 ⟹ 三条封闭 | `submodule_closure` |
| 两个子模相等 | `submodule_eq_iff` |
| 模同态 `f : M → N` | `F : M →ₗ[R] N`（即 `LinearMap R M N`） |
| 加法保持 | `F.map_add`（`∀ x y, F (x + y) = F x + F y`） |
| 数乘保持 | `F.map_smul`（`∀ a x, F (a • x) = a • F x`） |
| 加法 + 数乘保持 ⟹ 同态 | `linearMap_iff` |
| 两个同态相等 | `linearMap_ext_iff` |
| `f(0) = 0` | `linearMap_map_zero` |
| 核 `ker f` | `LinearMap.ker F : Submodule R M` |
| 像 `im f` | `LinearMap.range F : Submodule R N` |
| `x ∈ ker f ↔ f(x) = 0` | `linearMap_mem_ker_iff` |
| `y ∈ im f ↔ ∃ x, f(x) = y` | `linearMap_mem_range_iff` |
| 子空间（L1 记号） | `IsSubspace K W` |
| 子空间 ↔ 子模 | `isSubspace_iff_exists_submodule` |
| 双边理想（A2 记号） | `AbstractAlgebra.Ring.TwoSidedIdealSet I` |
| 双边理想 ↔ `R` 的子模 | `twoSidedIdealSet_iff_exists_submodule_self` |

# Mathlib 角色分类（AGENTS §4 第 4 条）

本条目公开签名里出现的 Mathlib 专用对象，按四类逐项归属：

1. **语义一致的正式公开承载**（推荐复用）：`Module`、`Submodule`、`LinearMap`（`M →ₗ[R] N`）、
   `LinearMap.ker`、`LinearMap.range`。它们与教材定义逐条一致，直接出现在公开陈述里，
   每一条都有教材解释（见上表）。
2. **本库特殊定义的桥**：`isSubspace_iff_exists_submodule`（Mathlib `Submodule` ↔
   L1 教材记号 `IsSubspace`/`LinearSpace`）、`twoSidedIdealSet_iff_exists_submodule_self`
   （Mathlib `Submodule R R` ↔ A2 教材记号 `TwoSidedIdealSet`）。两条都是**双向**的，
   方向写清、无缺失反向。本条目自身不定义新对象，所以不存在「本库结构 ↔ Mathlib 结构」
   的第三类桥。诚实披露：由于本版 Mathlib 里 `Ideal R` 就是 `Submodule R R` 的可约别名，
   第二条桥与 A2 已有的 `twoSidedIdealSet_iff_exists_ideal` 是同一命题的两种词汇写法
   （`Ideal` 版 / `Submodule` 版），不是两条不同的数学内容。
3. **私有证明后端**：只出现在 `:= by` 之后的构造子与公理投影，例如 `Submodule.mk`
   （`submodule_of_closure` 用它的 `carrier`/`zero_mem'`/`add_mem'`/`smul_mem'` 字段装配子模）、
   `LinearMap.mk`/`AddHom.mk`（`linearMap_iff` 的构造方向）、`smul_add`、`add_smul`、`mul_smul`、
   `one_smul`、`zero_smul`、`smul_zero`、`Submodule.add_mem`、`Submodule.smul_mem`、
   `Submodule.zero_mem`、`SetLike.ext_iff`、`map_zero`、`LinearMap.mem_ker`、
   `LinearMap.mem_range`。它们不进公开签名。
4. **超出课程层级的公开泄漏**：无。公开签名里没有出现比「模/子模/模同态」更高层的对象
   （没有商模、没有张量积、没有范畴语言）。独立复核还专门检查了两处可疑点：
   （i）`LinearMap.range` 内部需要 `RingHomSurjective (RingHom.id R)`，但该实例由类型类
   合成自动提供，不会作为额外 typeclass 出现在使用处的公开签名里（`#print` 一个形如
   `∃ S, S = f.range` 的定理，binder 列表里没有 `RingHomSurjective`）；
   （ii）`TwoSidedIdealSet`/`IsSubspace` 都是本库自己的谓词，不是 Mathlib 高阶接口。

# 依赖（人话版）

- `abstract-algebra.ring.def`（A2）：交换环的教材定义。模的系数环就是它；本条目在
  `[CommRing R]` 上陈述，公开签名里的 `R` 用的正是 A2 那门课定义的环。
- `abstract-algebra.ring.ideal`（A2）：理想的教材记号 `TwoSidedIdealSet`。桥二的右端就是它；
  「理想是 `R` 作为自身模的子模」是 A–M 第 2 章的第一个例子。
- `linear-algebra.vector-space.def`（L1）：向量空间的教材记号 `LinearSpace`（域上的模）。
  桥一的左端用它；「域上模就是向量空间」这句话在这里变成一条 Lean 定理。
- `linear-algebra.vector-space.subspace`（L1）：子空间的教材记号 `IsSubspace`
  （非空 + 加法封闭 + 数乘封闭）。桥一的左端是它，右端是 Mathlib 的 `Submodule`。
- 本条目是 CA1 后续条目（生成子模、商模、同构定理、直和）的定义层前提；那些条目本批冻结。

# 应用与陷阱

- **应用**：`LinearMap.ker`/`LinearMap.range` 是本条目里「子模」概念的真实使用者，也是
  后续商模 `M/ker f` 与同构定理 `M/ker f ≃ im f` 的入口（后者本批冻结）。A2 桥说明理想
  不是另一套对象，而是 `Submodule R R`；L1 桥说明向量空间不是另一套对象，而是域上的模。
- **陷阱 1（挠）**：`ℤ/2ℤ` 是 `ℤ`-模且 `2·x = 0`，所以线性代数里「线性无关组的系数必须
  全零」「无关组可扩充为基」在模上都不成立。本条目只搬运定义，不搬运这些定理。
- **陷阱 2（`f(0) = 0` 的地位）**：教材把 `f(0)=0` 列为同态的性质（甚至列为条件）；Mathlib
  的 `LinearMap` 父结构是 `AddHom`，构造时只需要加法保持与数乘保持，`f(0)=0` 由
  `linearMap_map_zero` 推出。写 `LinearMap.mk` 时多给一个 `map_zero'` 反而会报「未知字段」。
- **陷阱 3（非空 vs 含零）**：L1 的 `IsSubspace` 用 `W.Nonempty`，本条目用 `0 ∈ s`；两者在
  模里等价（`0 = 0·x`），但桥接时必须显式换一次，不能直接 `exact`。
- **陷阱 4（`Ideal` 不是另一个类型）**：本版 Mathlib 里 `Ideal.ofSubmodule`、`Submodule.toIdeal`、
  `Ideal.toSubmodule` 都不存在（`#check` 实测报 `Unknown constant`），原因不是缺桥，而是
  `Ideal R` 本身就是 `@[reducible] def Ideal R := Submodule R R`——`Ideal R` 与
  `Submodule R R` 是同一个类型，写转换引理反而是画蛇添足。A2 桥的两端因此是
  「本库谓词 `TwoSidedIdealSet`」与「Mathlib 的 `Submodule R R`」，中间不需要任何强制转换。
- **未完成边界**：不含子集生成的子模、商模与自然投影、同构定理、直和、自由模与秩、
  张量积、局部化；也不含子模格的运算（和、交、任意交）。`Module` 在 Mathlib 里比教材更
  一般（系数可以是 `Semiring`、底群可以是 `AddCommMonoid`），本条目一律在教材设定
  `[CommRing R] [AddCommGroup M]` 上陈述，不把这种一般性当教材内容。
