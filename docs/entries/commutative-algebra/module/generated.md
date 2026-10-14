---
id: commutative-algebra.module.generated
family: commutative-algebra.module
variant: textbook
kind: theorem
state: verified
title: 子集生成的子模与最小性
summary: 交换环上由子集生成的子模（Mathlib 正式承载 Submodule.span）的最小性四张脸、归纳原理与 span 基本演算，以及模同态下像的生成刻画；含 Mathlib 四类角色分类、公理披露与未完成边界
premises: [commutative-algebra.module.definition]
mathlib: [Submodule.span, Submodule.map, LinearMap, Submodule.mem_span, Submodule.span_le, Submodule.subset_span, Submodule.span_mono, Submodule.span_eq, Submodule.span_span, Submodule.span_empty, Submodule.span_univ, Submodule.span_union, Submodule.span_eq_bot, Submodule.mem_span_singleton, Submodule.span_induction, Submodule.map_span]
provenance:
  source_type: book
  ref: "atiyah-macdonald-commutative-algebra-1969"
---

# 动机

Atiyah–Macdonald 第 2 章把模与子模定义完之后，紧接着做的第一件事就是**由子集生成子模**：
给定交换环 `A`、`A`-模 `M` 与子集 `S ⊆ M`，定义 `⟨S⟩` 为「所有包含 `S` 的子模之交」，
并指出它是包含 `S` 的最小子模。这一步看起来只是个小构造，实际是整门课的传送带：

- 理想就是 `A` 作为自身模里由子集生成的子模（A2 的 `TwoSidedIdealSet` 与 CA1 定义层的桥
  已经把「理想 = `Submodule R R`」钉死），于是「由集合生成的理想」不再需要单独定义；
- 有限生成模（CA2）的定义就是「存在有限集 `S` 使 `⟨S⟩ = ⊤`」，没有 `⟨S⟩` 就写不出这个定义；
- 同态的像 `im f` 是 `⟨f '' S⟩` 这种形状，商模 `M/N` 的合法性也依赖「`N` 是子模」，
  而制造子模最常用的手段就是取生成；
- 局部化、张量积、正合列这些后续构造里，「取生成」是出现频率最高的动作之一。

所以本条目要做的事很具体：把教材的 `⟨S⟩` 钉到一个正式的 Lean 承载上，把它「最小」的
几种说法逐条写成 Lean 定理并互相打通，给出它的归纳原理与基本演算，再给一个真实使用它的
上层定理。**不**做的是有限生成、基与秩、自由模、商模与同构定理、直和——那些是 CA1/CA2 的
兄弟条目或后续条目。

本条目与 `commutative-algebra.module.definition` 的分工：定义层已经钉死了「模 / 子模 / 模同态」
三个概念与它们的承载；本条目**不重新定义**任何东西，只在已有的 `Submodule R M` 上
补出「生成」这个构造与它的泛性质。因此本条目没有新结构、没有新记号，也就没有「本库结构 ↔
Mathlib 结构」这类桥（这一点在「Mathlib 角色分类」一节会明确说明）。

# 直觉

**「最小」是一句话，但有四张脸。** 教材说「`⟨S⟩` 是包含 `S` 的最小子模」。这句话里的
「最小」在 Lean 里有四种等价写法，本条目全部给出：

1. **元素层**：`x ∈ ⟨S⟩` 当且仅当 `x` 属于**每一个**包含 `S` 的子模。这是「最小」展开到
   元素上：`⟨S⟩` 是全体候选的公共部分，所以 `x` 要进 `⟨S⟩`，就得在所有候选里都进得去。
2. **序层（伴随形式）**：`⟨S⟩ ≤ p` 当且仅当 `S ⊆ p`。这是「最小」作为格论里最小上界的
   标准形式：`⟨S⟩ ≤ p` 不需要逐元素验证，只要验证 `S ⊆ p` 这一条更弱的前提。
   反过来，`S ⊆ ⟨S⟩` 是「有资格当候选」那一半。
3. **最小子模形式**：`⟨S⟩ = p` 当且仅当 `p` 包含 `S`，且 `p` 含于每个包含 `S` 的子模。
   这是教材原话最直接的翻译：右式第一条说 `p` 是候选，第二条说它是最小的候选。
4. **交形式**：`⟨S⟩` 等于全体包含 `S` 的子模之交。这是定义本身，也是「公共部分」的写法。

**归纳原理是「没有多余元素」那一面。** 前三张脸说的是「`⟨S⟩` 不比候选大」，归纳原理说的是
「`⟨S⟩` 不比必需的大」：`⟨S⟩` 的元素由 `S` 经 `0`、`+`、`•` 生成，所以任何在 `S` 上成立、
且对这三条运算封闭的性质 `P`，在整个 `⟨S⟩` 上都成立。这是后续所有「对生成子模证明某事」
的标准起手式。

**生成是闭包算子。** 它满足闭包算子的三条公理：`S ⊆ ⟨S⟩`（扩张）、`S ⊆ T ⟹ ⟨S⟩ ≤ ⟨T⟩`
（单调）、`⟨⟨S⟩⟩ = ⟨S⟩`（幂等）。本条目把这三条作为 `subset_span`、`span_mono`、`span_span`
逐条给出。幂等还有一条更贴教材的姊妹版：当生成集本身就是某个子模 `p` 的载体时，`⟨p⟩ = p`。

**一个必须说清的直觉边界。** 在线性代数里我们习惯把 `⟨S⟩` 想成「`S` 的有限线性组合之集」。
这句话在模上**也对**（系数取自交换环、组合是有限的），但本条目**没有**把它形式化：
它需要 `Finset`/`Finsupp` 级别的有限和机器，而且与本条目的「生成」主题相比更靠近 CA2 的
有限生成。本条目给出的是归纳原理这一**结构性**刻画，两者不是同一件事（见「应用与陷阱」）。

# 陈述（自然语言）

以下固定：`A` 是含单位元的交换环，`M` 是 `A`-模，`S, T ⊆ M`，`p, q` 是 `M` 的子模。

**定义 1（由子集生成的子模）**（Atiyah–Macdonald 第 2 章）。`S` 生成的子模 `⟨S⟩` 定义为
`M` 的全体包含 `S` 的子模之交。由定义立即有：`⟨S⟩` 是子模（子模之交仍是子模），且 `S ⊆ ⟨S⟩`。

**命题 1（最小性，四张脸）**。对任意 `x ∈ M` 与子模 `p`：

1. `x ∈ ⟨S⟩` 当且仅当对每个包含 `S` 的子模 `q` 都有 `x ∈ q`；
2. `⟨S⟩ ≤ p` 当且仅当 `S ⊆ p`；
3. `⟨S⟩ = p` 当且仅当 `S ⊆ p` 且 `p ≤ q` 对每个满足 `S ⊆ q` 的子模 `q` 成立；
4. `⟨S⟩ = ⋂ {q : q 是包含 S 的子模}`。

四条互为等价，其中 3 是教材「最小子模」原话的直接翻译。注意 3 的右式**不能**简化成
「`S ⊆ p` 且 `p` 是子模」——那样只说 `p` 是候选，不说它最小。

**定理 2（归纳原理）**。设 `P` 是 `M` 的元素的性质。若

1. 对每个 `x ∈ S` 有 `P(x)`；
2. `P(0)`；
3. `P(x) ∧ P(y) ⟹ P(x + y)`；
4. `P(x) ⟹ P(a·x)` 对每个 `a ∈ A`，

则对每个 `x ∈ ⟨S⟩` 有 `P(x)`。

**命题 3（基本演算）**。

1. `S ⊆ ⟨S⟩`；
2. `S ⊆ T ⟹ ⟨S⟩ ≤ ⟨T⟩`；
3. `⟨p⟩ = p`（生成集本身是子模时，生成不添新元素）；
4. `⟨⟨S⟩⟩ = ⟨S⟩`；
5. `⟨∅⟩ = ⊥`；
6. `⟨M⟩ = ⊤`；
7. `⟨S ∪ T⟩ = ⟨S⟩ ⊔ ⟨T⟩`；
8. `⟨S⟩ = ⊥` 当且仅当 `S` 的每个元素都是 `0`；
9. `x ∈ ⟨{y}⟩` 当且仅当存在 `a ∈ A` 使 `a·y = x`。

**定理 4（像由像集生成，上层使用者）**。设 `F : M → N` 是 `A`-模同态，则
`F(⟨S⟩) = ⟨F(S)⟩`：`F` 把 `S` 生成的子模映到 `F(S)` 生成的子模。这条把「取生成」与
「取同态的像」交换，是本条目里 `⟨S⟩` 被真实使用的地方（`F(⟨S⟩)` 是 `N` 的子模，
`⟨F(S)⟩` 也是，两者相等）。

# 陈述（Lean 对照）

```lean
-- 正式承载（Mathlib）：由子集生成的子模
--   Submodule.span R s      ：s 生成的子模 ⟨s⟩
--   R ∙ y                   ：单元素生成，即 Submodule.span R {y} 的记号
--   Submodule.map F p       ：子模 p 在 F 下的像

/-- 生成子模包含原集合：s ⊆ ⟨s⟩ -/
theorem subset_span {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    {s : Set M} : s ⊆ Submodule.span R s

/-- 最小性（元素层）：x ∈ ⟨s⟩ ↔ x 属于每个包含 s 的子模 -/
theorem mem_span_iff {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (s : Set M) (x : M) :
    x ∈ Submodule.span R s ↔ ∀ p : Submodule R M, s ⊆ p → x ∈ p

/-- 最小性（序层，伴随形式）：⟨s⟩ ≤ p ↔ s ⊆ p -/
theorem span_le_iff_subset {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (s : Set M) (p : Submodule R M) :
    Submodule.span R s ≤ p ↔ s ⊆ p

/-- 最小性（最小子模形式）：⟨s⟩ = p ↔ s ⊆ p 且 p 含于每个包含 s 的子模 -/
theorem span_eq_iff_subset_and_le {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (s : Set M) (p : Submodule R M) :
    Submodule.span R s = p ↔ s ⊆ p ∧ ∀ q : Submodule R M, s ⊆ q → p ≤ q

/-- 最小性（交形式）：⟨s⟩ 是全体包含 s 的子模之交 -/
theorem span_eq_sInf {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (s : Set M) :
    Submodule.span R s = sInf {p : Submodule R M | s ⊆ p}

/-- 归纳原理：P 在 s 上成立且对 0、+、• 封闭 ⟹ P 在整个 ⟨s⟩ 上成立 -/
theorem span_induction {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    {s : Set M} {P : M → Prop}
    (mem : ∀ x ∈ s, P x) (zero : P 0) (add : ∀ x y, P x → P y → P (x + y))
    (smul : ∀ (a : R) x, P x → P (a • x)) :
    ∀ x ∈ Submodule.span R s, P x

/-- 对生成集单调：s ⊆ t ⟹ ⟨s⟩ ≤ ⟨t⟩ -/
theorem span_mono {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    {s t : Set M} (h : s ⊆ t) : Submodule.span R s ≤ Submodule.span R t

/-- 子模的生成幂等：⟨p⟩ = p -/
theorem span_eq_of_submodule {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (p : Submodule R M) : Submodule.span R (p : Set M) = p

/-- 生成子的生成幂等：⟨⟨s⟩⟩ = ⟨s⟩ -/
theorem span_span {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (s : Set M) :
    Submodule.span R (Submodule.span R s : Set M) = Submodule.span R s

/-- 空集生成零子模：⟨∅⟩ = ⊥ -/
theorem span_empty {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M] :
    Submodule.span R (∅ : Set M) = ⊥

/-- 全集生成整个模：⟨univ⟩ = ⊤ -/
theorem span_univ {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M] :
    Submodule.span R (Set.univ : Set M) = ⊤

/-- 并集的生成等于生成子模的上确界：⟨s ∪ t⟩ = ⟨s⟩ ⊔ ⟨t⟩ -/
theorem span_union {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (s t : Set M) :
    Submodule.span R (s ∪ t) = Submodule.span R s ⊔ Submodule.span R t

/-- 零子模判定：⟨s⟩ = ⊥ ↔ s 的每个元素都是 0 -/
theorem span_eq_bot_iff {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    {s : Set M} : Submodule.span R s = ⊥ ↔ ∀ x ∈ s, x = 0

/-- 单元素生成：x ∈ R ∙ y ↔ 存在 a : R 使 a • y = x -/
theorem mem_span_singleton_iff {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (x y : M) : x ∈ R ∙ y ↔ ∃ a : R, a • y = x

/-- 上层使用者：模同态把 ⟨s⟩ 映到 ⟨F '' s⟩ -/
theorem map_span {R M N : Type*} [CommRing R] [AddCommGroup M] [AddCommGroup N]
    [Module R M] [Module R N] (F : M →ₗ[R] N) (s : Set M) :
    Submodule.map F (Submodule.span R s) = Submodule.span R (F '' s)
```

Lean 的正式承载是 Mathlib 的 `Submodule.span`（记号 `R ∙ y` 是它在单元素集上的特例），
本库**不另造结构、不另设记号**（AGENTS §4：不为制造本库名称重造等价结构）。本库自己陈述的
是教材命题：最小性的四张脸（其中 3、4 两条是 Mathlib 没有同形版本的，见「思维脉络」）、
教材形式的归纳原理（Mathlib 的 motive 带证明项，见下），以及九条基本演算的教材 binder 版本。
`map_span` 是本条目的上层使用者。

# 思维脉络（thinking trace）

1. **承载选择**。先读 Mathlib 源码：`Submodule.span` 的定义是
   `def span (s : Set M) : Submodule R M := sInf { p | s ⊆ p }`——**字面上就是教材的交定义**。
   于是「`⟨S⟩` 的正式承载」这个问题一次解决：不需要包装类，不需要新记号；连「交形式」
   （`span_eq_sInf`）都是定义展开。实测确认：该条可用 `rfl` 证明（因此也顺带避免了走
   `le_sInf`/`sInf_le` 把 `Classical.choice` 带进公理档案）。
2. **最小性的四张脸**。`#check` 实测：`Submodule.mem_span`（元素层）与 `Submodule.span_le`
   （序层）在本版存在且与教材逐字一致，可直接复用；`Submodule.span_eq_sInf` 与
   `Submodule.span_le_span_iff`、`Submodule.span_eq_iff`、`Submodule.span_eq_top_iff`
   **都不存在**（`Unknown constant`，本条目侦察阶段实测）。教材的「最小子模形式」
   `span_eq_iff_subset_and_le` 是本条目自己证的：正向把 `p` 用 `subst` 换成 `⟨s⟩` 后两条前提
   都变成现成引理，反向由子模格的反对称性给出（`⟨s⟩ ≤ p` 用序层最小性，`p ≤ ⟨s⟩` 用
   「含于每个候选」作用在 `⟨s⟩` 自己身上）。
3. **归纳原理**。`Submodule.span_induction` 存在，但 motive 是
   `p : (x : M) → x ∈ span R s → Prop`（带证明项的 dependent motive），而
   `Submodule.span_induction'`（教材式的 `P : M → Prop` 版本）在本版**不存在**（实测
   `Unknown constant`）。所以本条目把它包装成教材形式：四条前提照抄教材，证明体里把
   `add`/`smul` 分支的证明参数显式丢弃（`fun x y _ _ hx hy => …`）。这不是数学上的新内容，
   而是把 Mathlib 的接口整理成教材可以直接引用的形状。
4. **基本演算九条**。九条在 Mathlib 里都有对应物，且 `#check` 确认内容与教材一致。本条目
   在 `SandronesLibrary.CommutativeAlgebra.Module` 命名空间下以教材 binder
   （`[CommRing R] [AddCommGroup M] [Module R M]`）重新陈述。其中 `span_mono`、`span_span`、
   `span_univ`、`span_eq_bot_iff`、`span_empty` 的证明体**刻意**复用本文件自己的
   `subset_span` / `span_le_iff_subset` / `span_eq_of_submodule`，让 docstring 里写的推导
   在证明体里真的发生，条目内部形成依赖链（扩张 → 最小性 → 单调/幂等/零判定）。
5. **上层使用者**。`Submodule.map_span` 在本版是**半线性**的、带显式
   `[RingHomSurjective σ₁₂]` 假设。派工要求「写线性形式，不让 `RingHomSurjective` 泄漏进公开
   签名」：实测在线性形式 `F : M →ₗ[R] N` 下，`RingHomSurjective (RingHom.id R)` 由类型类
   合成自动提供（`#check` 出的公开签名里没有它），而且本条目改用「两个包含」的自足证明后
   **根本不需要**这个实例：`map F ⟨s⟩ ≤ ⟨F '' s⟩` 用 `map_le_iff_le_comap` 与最小性，
   反向用最小性与 `mem_map_of_mem`。
6. **公理纪律（Playbook §3）**。审计发现四条声明带 `Classical.choice`：`span_eq_sInf`、
   `span_empty`、`span_union`、`map_span`。逐条做受控实验后：三条是**证明路径噪声**，
   换成构造性证明后消失（`span_eq_sInf := rfl`、`span_empty` 用 `le_antisymm` 两条夹出、
   `map_span` 用两包含自足证明）；剩下 `span_union` 一条经判决性实验确认是**类型级噪声**
   ——`theorem sup_refl (p q : Submodule R M) : p ⊔ q = p ⊔ q := rfl` 也报
   `Classical.choice`，说明 choice 来自类型里 `⊔` 的实例定义体（Playbook §3.3），
   与证明无关；而本条的陈述被冻结为含 `⊔` 的形式，故不可消除，如实披露。
7. **意外的坑（点记号 `.trans`）**。第 6 步的对照实验顺带发现：同一目标
   `⟨s⟩ ≤ ⟨t⟩`，写 `Submodule.span_le.2 (Set.Subset.trans h subset_span)` 时公理档案是
   `[propext, Quot.sound]`，而写 `(Submodule.span_le …).mpr (h.trans subset_span)`
   （点记号）时会多出 `Classical.choice`——两者数学内容完全相同。点记号 `.trans` 走的是
   `Trans` 实例解析，混进来的证明路径是经典化的。本文件因此统一改用显式
   `Set.Subset.trans`，并把这条教训写进「应用与陷阱」。
8. **四类角色**见下一节；本条目无新结构、无桥、无公开泄漏，`Classical.choice` 的归属逐条披露。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 交换环 `A` 上的模 `M` | `[CommRing R] [AddCommGroup M] [Module R M]` |
| 子集 `S` 生成的子模 `⟨S⟩` | `Submodule.span R s` |
| 单元素生成 `⟨{y}⟩` | `R ∙ y`（`Submodule.span R {y}` 的记号） |
| `S ⊆ ⟨S⟩` | `subset_span` |
| `x ∈ ⟨S⟩` 当且仅当属于每个候选 | `mem_span_iff`（底层 `Submodule.mem_span`） |
| `⟨S⟩ ≤ p` 当且仅当 `S ⊆ p` | `span_le_iff_subset`（底层 `Submodule.span_le`） |
| `⟨S⟩ = p` 当且仅当 `p` 是含 `S` 的最小子模 | `span_eq_iff_subset_and_le`（本条目自证） |
| `⟨S⟩` 是全体候选之交 | `span_eq_sInf`（本版为定义展开 `rfl`） |
| 归纳原理（`0`、`+`、`•` 封闭） | `span_induction`（包装 `Submodule.span_induction`） |
| 生成对生成集单调 | `span_mono` |
| `⟨p⟩ = p`（生成集是子模） | `span_eq_of_submodule`（底层 `Submodule.span_eq`） |
| `⟨⟨S⟩⟩ = ⟨S⟩` | `span_span`（由 `span_eq_of_submodule` 得到） |
| `⟨∅⟩ = ⊥` | `span_empty` |
| `⟨M⟩ = ⊤` | `span_univ` |
| `⟨S ∪ T⟩ = ⟨S⟩ ⊔ ⟨T⟩` | `span_union` |
| `⟨S⟩ = ⊥` 当且仅当 `S` 全是 `0` | `span_eq_bot_iff` |
| `x ∈ ⟨{y}⟩` 当且仅当 `x` 是 `y` 的纯量倍 | `mem_span_singleton_iff` |
| `F(⟨S⟩) = ⟨F(S)⟩` | `map_span`（`Submodule.map F (Submodule.span R s) = Submodule.span R (F '' s)`） |
| 子模 `p` 在 `F` 下的像 | `Submodule.map F p` |
| 模同态 `F : M → N` | `F : M →ₗ[R] N`（`LinearMap R M N`） |
| 子模之交 / 最小 / 和 | `sInf` / `≤` / `⊔`（`Submodule R M` 的完备格结构） |

# Mathlib 角色分类（AGENTS §4 第 4 条）

本条目公开签名里出现的 Mathlib 专用对象，按四类逐项归属：

1. **语义一致的正式公开承载**（推荐复用）：
   - `Submodule.span R s`：教材 `⟨S⟩` 的正式承载。本版 Mathlib 的定义体就是教材的交定义
     `sInf {p | s ⊆ p}`（源码 `Mathlib/LinearAlgebra/Span/Defs.lean`），语义逐字一致。
   - `R ∙ y`：`Submodule.span R {y}` 的记号，教材「单元素生成的子模」的正式承载。
     Mathlib 源码特意提醒它是 `\span` 而不是数乘 `•`（`\bub`）。
   - `Submodule.map F p` 与 `M →ₗ[R] N`（`LinearMap R M N`）：子模的像与模同态的正式承载，
     在 `map_span` 里同时出现；`LinearMap` 的角色分类已在 `commutative-algebra.module.definition`
     做过，本条目不重复论证。
   - 子模格运算 `⊥`、`⊤`、`⊔`、`sInf`：教材「零子模 / 整个模 / 子模之和 / 子模之交」的正式
     承载。诚实说明：CA1 定义层明确把「子模格的运算」列为未完成边界，本条目用到它们只是因为
     冻结的陈述本身含 `⟨∅⟩ = ⊥`、`⟨M⟩ = ⊤`、`⟨S ∪ T⟩ = ⟨S⟩ ⊔ ⟨T⟩` 与交形式；本条目
     **不**开发子模格的 API（交、和的一般演算、`map`/`comap` 的格同态性质都不在范围内）。
2. **本库特殊定义的桥**：**无**。本条目不定义任何新结构或新谓词，`⟨S⟩` 的教材语义与
   `Submodule.span` 的 Mathlib 语义逐条一致，因此不存在「本库记号 ↔ Mathlib 结构」的桥。
   这与 CA1 定义层形成对照（那一层有 L1 的 `IsSubspace` 桥与 A2 的 `TwoSidedIdealSet` 桥）；
   本条目**没有**第三类桥不是遗漏，而是承载选择正确的结果。
3. **私有证明后端**（只出现在 `:= by` 之后，不进公开签名；逐项披露）：
   `Submodule.span_le`、`Submodule.subset_span`、`Submodule.mem_span`、`Submodule.span_induction`
   （被 `span_induction` 的证明体调用）、`Submodule.span_eq`（`span_eq_of_submodule` 的证明体）、
   `Submodule.map_le_iff_le_comap`、`Submodule.mem_map_of_mem`（`map_span` 的两个包含）、
   `Submodule.mem_bot`（`span_eq_bot_iff` 右到左）、`Submodule.eq_top_iff'`（`span_univ`）、
   `le_antisymm`、`bot_le`、`sup_le`、`le_sup_left`、`le_sup_right`、`Set.Subset.trans`、
   `Set.subset_union_left`、`Set.subset_union_right`、`Set.empty_subset`、`Set.subset_univ`、
   `Set.mem_univ`。
   公开陈述与 Mathlib 原引理**同名不同命名空间**（例如本库的 `span_mono` 与
   `Submodule.span_mono`），文档与映射表已逐条注明底层对应物，不会让读者误以为是新数学。
4. **超出课程层级的公开泄漏**：**无**。公开签名里只有模、子模、模同态、子集与子模格运算，
   没有有限生成、基与秩、自由模、商模、张量积、范畴语言。两个专门复核过的可疑点：
   （i）`RingHomSurjective`：`Submodule.map_span` 的**半线性**形式带显式 `[RingHomSurjective σ₁₂]`，
   本条目冻结在线性形式 `M →ₗ[R] N`；`#check` 实测本条目 `map_span` 的 binder 列表里
   没有 `RingHomSurjective`，而且自足的两包含证明根本不需要该实例；
   （ii）`sInf` / `⊔`：它们是教材「交 / 和」的正式承载，不是高阶概念（见第 1 类说明）。

**公理披露**（Playbook §3，逐条实测，非推测）：15 条声明中 14 条的公理档案是
`[propext, Quot.sound]`；唯一带 `Classical.choice` 的是 `span_union`
（`[propext, Classical.choice, Quot.sound]`）。判决性实验：
`theorem sup_refl (p q : Submodule R M) : p ⊔ q = p ⊔ q := rfl` 同样报 `Classical.choice`，
证明 choice 来自**类型**里 `⊔` 的实例定义体（类型级噪声，Playbook §3.3），
而不是本条的数学内容或证明路径；由于陈述被冻结为含 `⊔` 的形式，该 choice 不可消除。
其余三条原本带 choice 的声明（`span_eq_sInf`、`span_empty`、`map_span`）已通过构造性证明消去。

# 依赖（人话版）

- `commutative-algebra.module.definition`（CA1 定义层）：提供模、子模与模同态的教材定义与
  Mathlib 承载（`Module`、`Submodule`、`LinearMap`）以及 L1/A2 两条桥。本条目全程使用
  `Submodule R M` 这个承载，并复用定义层的 `[CommRing R] [AddCommGroup M] [Module R M]` 设定；
  本条目**不**重新解释子模是什么。
- Mathlib 侧的底座（不是本库 Entry）：`Set` 与 `Set.image`（生成集与像集）、`Submodule R M`
  的完备格结构（`⊥`、`⊤`、`⊔`、`sInf`，用于零/全/并/交四条）。
- 本条目是 CA1/CA2 后续条目的前提：有限生成（`commutative-algebra.module.finite-generation`）
  要把「有限生成」写成「存在有限集 `S` 使 `⟨S⟩ = ⊤`」；商模与同构定理要用「子模的像」
  （`map_span` 是其中最基础的一条）；自由模与秩更在其后。它们本批冻结。

# 应用与陷阱

- **应用 1（同态的像）**：`map_span` 把「取生成」与「取像」交换，是后续商模、正合列里
  「像怎么算」的标准入口。它也是 AGENTS §4 第 5 条要求的「真实使用该承载的上层公开定理」。
- **应用 2（对生成子模做证明）**：`span_induction` 是标准起手式——要证 `⟨S⟩` 上处处有性质 `P`，
  只需验证 `S` 上成立 + 对 `0`、`+`、`•` 封闭。CA2 的有限生成条目会反复用到。
- **应用 3（理想）**：由集合生成的理想就是 `Submodule.span R s` 在 `Submodule R R` 里的特例
  （见定义层的 A2 桥），所以本条目对 `⟨S⟩` 说的话，对「由集合生成的理想」同样成立。
- **陷阱 1（「最小」不是现成引理）**：四张脸里只有元素层与序层是 Mathlib 现成的
  （`Submodule.mem_span`、`Submodule.span_le`）；最小子模形式是本条目自证的，
  交形式在本版是定义展开。侦察阶段实测 `Submodule.span_eq_iff`、`Submodule.span_le_span_iff`、
  `Submodule.span_eq_top_iff`、`Submodule.span_eq_iSup_of_singleton`、`Submodule.span_attach`
  **都不存在**（`Unknown constant`），不要凭印象引用。
- **陷阱 2（归纳原理的 motive）**：`Submodule.span_induction` 的 motive 带证明项
  `(x : M) → x ∈ span R s → Prop`，教材式的 `P : M → Prop` 版本
  `Submodule.span_induction'` 在本版**不存在**。本条目给出的 `span_induction` 是包装，
  包装时要显式丢弃 `add`/`smul` 分支里的证明参数。
- **陷阱 3（`RingHomSurjective`）**：`Submodule.map_span` 是半线性的、带显式
  `[RingHomSurjective σ₁₂]`。冻结在线性形式 `M →ₗ[R] N` 后该实例自动合成、不进公开签名；
  若把结论推广到一般半线性映射 `M →ₛₗ[σ] N` 而不假设实例，`RingHomSurjective` 就会真的
  成为公开假设。
- **陷阱 4（「有限线性组合」不在本条目）**：把 `⟨S⟩` 描述成「`S` 的有限线性组合之集」
  在数学上是对的，但本条目**没有**形式化它——本条目给的是归纳原理这一结构性刻画。
  侦察阶段实测 `Submodule.mem_span_iff_exists_finset` 在本版**不存在**（`Unknown constant`），
  有限和版本的刻画需要 `Finset`/`Finsupp` 机器，属于 CA2 有限生成的范围。**不要**把本条目
  的归纳原理读成「有限线性组合」的等价陈述：它只给出「性质封闭 ⟹ 处处成立」这一方向。
- **陷阱 5（点记号 `.trans` 会带进 `Classical.choice`）**：本条目实测，
  `Submodule.span_le.2 (Set.Subset.trans h subset_span)` 的公理档案是 `[propext, Quot.sound]`，
  而 `(Submodule.span_le …).mpr (h.trans subset_span)` 会多出 `Classical.choice`——两者数学
  内容相同，差别只在点记号 `.trans` 走了 `Trans` 实例解析，混进了经典化的证明路径。
  本文件统一用显式 `Set.Subset.trans`。这类「引用现成定理悄悄带进 choice」正是 Playbook §3.1
  描述的现象，值得在写新引理时留意。
- **陷阱 6（`R ∙ y` 不是数乘）**：`R ∙ y` 是 `Submodule.span R {y}` 的记号，与 `a • y`
  不是一回事；Mathlib 源码注释专门提醒 `\span` 与 `\bub` 的区别。
- **陷阱 7（`span_union` 的 `Classical.choice`）**：见「Mathlib 角色分类」末段的公理披露。
  这是类型级噪声，不是数学上需要选择公理；若将来把陈述改写成不含 `⊔` 的形式
  （例如逐元素的 `x ∈ ⟨s ∪ t⟩ ↔ …`），choice 可以进一步消去，但那会改变陈述形状，
  超出本条目冻结范围。
- **未完成边界**：不含有限生成、有限生成集、`Submodule.FG`、基、秩、自由模（CA2 条目）；
  不含商模、自然投影、同构定理、直和（本批兄弟条目）；不含张量积、局部化；
  不含子模格的完整 API（一般交与和的演算、`map`/`comap` 的格性质、任意并
  `Submodule.span_iUnion`、`span_insert`、`span_singleton_eq_range` 等未列入公开接口的
  Mathlib 引理）；不含「有限线性组合」的等价刻画。本条目公开陈述一律写在教材设定
  `[CommRing R] [AddCommGroup M] [Module R M]` 上，Mathlib 的承载更一般
  （`Semiring`/`AddCommMonoid`），本条目不把这种一般性当教材内容，也不为迁就它弱化陈述。
