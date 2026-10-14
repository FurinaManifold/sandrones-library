---
id: commutative-algebra.module.quotient
family: commutative-algebra.module
variant: textbook
kind: definition
state: verified
title: 商模、自然投影与商映射的泛性质
summary: 交换环上商模 M/p 的正式承载（商类型 M ⧸ p，而非独立结构）、自然投影的两个层次、陪集判等、商映射的泛性质（存在唯一性）与函子性，以及商模的极端情形；含 Mathlib 四类角色分类、公理披露与未完成边界
premises: [commutative-algebra.module.definition]
mathlib: [Submodule.Quotient.mk, Submodule.mkQ, Submodule.liftQ, Submodule.ker_mkQ, Submodule.range_mkQ, Submodule.factor, Submodule.quotEquivOfEqBot, LinearMap.ker, LinearMap.range]
provenance:
  source_type: book
  ref: "atiyah-macdonald-commutative-algebra-1969"
---

# 动机

Atiyah–Macdonald 第 2 章在定义完模与子模之后立刻引入**商模** `M/N`：它是「把 `N` 里的元素
全部捏成零」之后得到的模。这一步是整门课的第二个传送带：

- **同态的像**：任意模同态 `f : M → N` 都可以分解为 `M ↠ M/ker f ≅ im f`，这就是第一同构定理
  （本批 `commutative-algebra.module.isomorphism-theorems`），而它的全部机器就是本条目交付的
  「自然投影 + 泛性质」；
- **商环**：`A/I` 是 `A` 作为自身模商掉子模 `I`（`Ideal R` 就是 `Submodule R R`，见 CA1 定义层
  的 A2 桥）的特例；
- **局部化**：`S⁻¹M` 是 `M` 的一个商模的滤过极限，商模的泛性质是那里「先定义、再验证良定义」
  这套动作的原型；
- **正合列**：`M/N` 是余核，没有商模就写不出正合。

所以本条目要做的事很具体：把教材的商模钉到一个正式的 Lean 承载上，把教材里那句
「π 是自然投影，且任何在 `N` 上消失的同态都唯一地穿过 π」写成一条真正的 Lean 定理
（存在性 + 唯一性），再给出商模上做计算的判等规则与函子性。**不**做的是三大同构定理本身
（下一 Entry）、直和、张量积、局部化。

**与 `commutative-algebra.module.definition` 的分工**：定义层已经钉死「模 / 子模 / 模同态」；
本条目**不重新定义**任何东西，只在已有的 `Submodule R M` 上补出「商」这个构造与它的泛性质。
因此本条目没有新结构、没有新记号。

# 直觉

**商模 = 把子模压成一点，其余照旧。** 教材的构造是：在 `M` 上定义等价关系
`x ~ y ⟺ x - y ∈ N`，取商集 `M/N`，再把加法与数乘「按代表元」定义下去。两件必须验证的事：

1. **运算良定义**：换代表元不改变陪集的和与数乘（`quotient_mk_add`、`quotient_mk_smul`）；
2. **零元素是谁**：陪集 `x + N` 是零当且仅当 `x ∈ N`（`quotient_mk_eq_zero_iff`）。

这两件事做完，`M/N` 就是一个 `A`-模。

**自然投影有两个层次，这不是吹毛求疵。** 教材只写一个 `π : M → M/N`。在 Lean 里必须区分：

- `Submodule.Quotient.mk : M → M ⧸ p` 是一个**函数**，用来陈述「陪集 `mk x` 等于陪集 `mk y`」
  这类逐点命题；
- `Submodule.mkQ : M →ₗ[R] M ⧸ p` 是一个**线性映射**，用来陈述「`g ∘ π = f`」这类泛性质。

`mkQ_apply_mk` 把两者在元素上接起来（`p.mkQ x = mk x`）。泛性质必须用 `mkQ` 说，否则
`g.comp p.mkQ = f` 根本写不出来；陪集判等必须用 `mk` 说，否则要绕开线性结构。

**泛性质是商模的「唯一职责」。** 教材的话是：「若 `f : M → N` 是模同态且 `N ⊆ ker f`
（教材把子模写作 `N`），则存在唯一的模同态 `f̄ : M/N → N` 使 `f̄ ∘ π = f`。」注意这是
**双向**的：`f` 能在商模上下降，**当且仅当** `N ⊆ ker f`。这一条是本条目唯一需要真证明的
定理（`quotient_liftQ_exists_unique`），其余都是把 Mathlib 的下层接口按教材口径重新陈述。

**一个必须说清的直觉边界。** 商模的元素是**陪集**，不是 `M` 的元素；`M ⧸ p` 与 `M` 之间没有
自然的包含关系（π 不是单射，除非 `p = ⊥`）。教材里常见的错误是把 `x ∈ M/N` 与 `x ∈ M` 混用。
本条目用「陪集判等」把这件事钉死：`M/N` 里两个元素相等，只能通过 `x - y ∈ N` 判定。

# 陈述（自然语言）

以下固定：`A` 是含单位元的交换环，`M, N` 是 `A`-模，`P ⊆ M` 是子模，`π : M → M/P` 是自然投影。

**定义 1（商模）**。在 `M` 上定义 `x ~ y ⟺ x - y ∈ P`，这是同余关系；商集 `M/P` 带上
「按代表元」定义的加法与数量乘构成 `A`-模，称为 `M` 对 `P` 的**商模**。自然投影
`π : M → M/P`，`π(x) = x + P`，是满线性映射。

**命题 1（陪集判等）**。对任意 `x, y ∈ M`：`π(x) = π(y) ⟺ x - y ∈ P`；特别地
`π(x) = 0 ⟺ x ∈ P`。

**命题 2（自然投影的核与像）**。`ker π = P`；`π` 满射（等价地 `im π = M/P`）。

**定理 3（商模的泛性质）**。设 `f : M → N` 是模同态。则「存在唯一的模同态 `f̄ : M/P → N`
使 `f̄ ∘ π = f`」当且仅当 `P ⊆ ker f`。当条件成立时，`f̄` 在陪集上的取值是 `f̄(π(x)) = f(x)`。

**命题 4（商模同态的外延性）**。两个从 `M/P` 出发的模同态相等，当且仅当它们在每个陪集
`π(x)` 上取值相同。（因为 π 满射，验证只需在陪集上进行。）

**命题 5（商模的函子性）**。若 `P ⊆ Q` 是 `M` 的两个子模，则有自然的模同态
`M/P → M/Q`，把 `x + P` 送到 `x + Q`；它是满射。

**命题 6（极端情形）**。`M/M = 0`（即 `M ⧸ P` 平凡当且仅当 `P = M`）；`M/0 ≅ M`。

# 陈述（Lean 对照）

```lean
-- 正式承载（Mathlib）：商模
--   M ⧸ p                     ：商模 M/p（商类型；Submodule.Quotient 是命名空间，不是常量）
--   Submodule.Quotient.mk     ：自然投影（函数） M → M ⧸ p
--   Submodule.mkQ             ：自然投影（线性映射） M →ₗ[R] M ⧸ p
--   Submodule.liftQ           ：商映射的存在性（泛性质的一半）
--   Submodule.factor          ：由 p ≤ p' 诱导的商映射 M ⧸ p →ₗ[R] M ⧸ p'

/-- 陪集判等：mk x = mk y ↔ x - y ∈ p -/
theorem quotient_mk_eq_iff (p : Submodule R M) (x y : M) :
    (Submodule.Quotient.mk x : M ⧸ p) = Submodule.Quotient.mk y ↔ x - y ∈ p

/-- 陪集等于零：mk x = 0 ↔ x ∈ p -/
theorem quotient_mk_eq_zero_iff (p : Submodule R M) (x : M) :
    (Submodule.Quotient.mk x : M ⧸ p) = 0 ↔ x ∈ p

/-- 商加法良定义：mk (x + y) = mk x + mk y -/
theorem quotient_mk_add (p : Submodule R M) (x y : M) :
    (Submodule.Quotient.mk (x + y) : M ⧸ p) =
      Submodule.Quotient.mk x + Submodule.Quotient.mk y

/-- 商数量乘良定义：mk (a • x) = a • mk x -/
theorem quotient_mk_smul (p : Submodule R M) (a : R) (x : M) :
    (Submodule.Quotient.mk (a • x) : M ⧸ p) = a • Submodule.Quotient.mk x

/-- 自然投影的两个层次在元素上一致：p.mkQ x = mk x -/
theorem mkQ_apply_mk (p : Submodule R M) (x : M) : p.mkQ x = Submodule.Quotient.mk x

/-- 自然投影的核恰是 p -/
theorem mkQ_ker (p : Submodule R M) : LinearMap.ker p.mkQ = p

/-- 自然投影的像是整个商模 -/
theorem mkQ_range (p : Submodule R M) : LinearMap.range p.mkQ = ⊤

/-- 自然投影满射 -/
theorem mkQ_surjective (p : Submodule R M) : Function.Surjective p.mkQ

/-- 商映射在陪集上的取值：liftQ f h (mk x) = f x -/
theorem quotient_liftQ_mk (p : Submodule R M) (f : M →ₗ[R] N) (h : p ≤ LinearMap.ker f) (x : M) :
    p.liftQ f h (Submodule.Quotient.mk x) = f x

/-- 商映射的交换性：liftQ f h ∘ π = f -/
theorem quotient_liftQ_comp_mkQ (p : Submodule R M) (f : M →ₗ[R] N) (h : p ≤ LinearMap.ker f) :
    (p.liftQ f h).comp p.mkQ = f

/-- 商模的泛性质（存在唯一性） -/
theorem quotient_liftQ_exists_unique (p : Submodule R M) (f : M →ₗ[R] N) :
    (∃! g : M ⧸ p →ₗ[R] N, g.comp p.mkQ = f) ↔ p ≤ LinearMap.ker f

/-- 商映射的唯一性 -/
theorem quotient_liftQ_unique (p : Submodule R M) (f : M →ₗ[R] N) (h : p ≤ LinearMap.ker f)
    {g : M ⧸ p →ₗ[R] N} (hg : g.comp p.mkQ = f) : g = p.liftQ f h

/-- 商模同态的外延性 -/
theorem quotient_hom_ext (p : Submodule R M) {g₁ g₂ : M ⧸ p →ₗ[R] N}
    (h : ∀ x : M, g₁ (Submodule.Quotient.mk x) = g₂ (Submodule.Quotient.mk x)) : g₁ = g₂

/-- 商映射的函子性：p ≤ p' 诱导 M ⧸ p → M ⧸ p' -/
theorem quotient_factor_mkQ {p p' : Submodule R M} (h : p ≤ p') (x : M) :
    Submodule.factor h (p.mkQ x) = p'.mkQ x

/-- 商映射的满射性 -/
theorem quotient_factor_surjective {p p' : Submodule R M} (h : p ≤ p') :
    Function.Surjective (Submodule.factor h)

/-- 商模平凡当且仅当商掉整个模 -/
theorem quotient_subsingleton_iff {p : Submodule R M} : Subsingleton (M ⧸ p) ↔ p = ⊤

/-- 商模非平凡当且仅当子模真包含 -/
theorem quotient_nontrivial_iff {p : Submodule R M} : Nontrivial (M ⧸ p) ↔ p ≠ ⊤

/-- 商掉零子模得到自身：M ⧸ ⊥ ≃ₗ[R] M -/
noncomputable def quotient_bot_equiv : (M ⧸ (⊥ : Submodule R M)) ≃ₗ[R] M
```

（上表中所有声明的完整 binder 都是教材设定 `{R M N : Type*} [CommRing R] [AddCommGroup M]
[AddCommGroup N] [Module R M] [Module R N]`，为排版省略。）

**商模没有独立的「结构」。** 本版 Mathlib 里 `#check @Submodule.Quotient` 报
`Unknown constant`：`Submodule.Quotient` 只是一个**命名空间**，商模的类型就是商类型
`M ⧸ p`（`Quotient` 记法），它的 `Module R` 实例由 `Submodule.Quotient.module` 提供。
所以「商模的正式承载」这句话的答案是：**类型 `M ⧸ p` 加上它的实例**，不是一个可供命名的
结构体。本库不另造包装结构（AGENTS §4）。

**本库自己证的只有一条。** 17 条声明里，16 条是把 Mathlib 的下层接口按教材口径重新陈述
（`Submodule.Quotient.eq`、`Submodule.mkQ_apply`、`Submodule.ker_mkQ`、`Submodule.liftQ_apply`、
`Submodule.liftQ_mkQ`、`Submodule.quot_hom_ext`、`Submodule.factor_mk`、`Submodule.factor_surjective`、
`Submodule.Quotient.subsingleton_iff`、`Submodule.Quotient.nontrivial_iff`、`Submodule.quotEquivOfEqBot`），
真正需要自己写的证明只有 `quotient_liftQ_exists_unique`——泛性质的「存在**唯一**」是一个
`∃!`，Mathlib 只给了存在性（`Submodule.liftQ`）与交换性（`Submodule.liftQ_mkQ`），
没有打包成一条定理。

# 思维脉络（thinking trace）

1. **承载侦察（先实测再写）**。开工第一步按 Playbook §10.7 用 `#check @` 探了 39 个候选名，
   得到三条决定性事实：
   (a) `Submodule.Quotient` **不是常量**（`Unknown constant`），商模类型就是 `M ⧸ p`；
   (b) `Submodule.Quotient.mk'`、`Submodule.Quotient.inductionOn`、`Submodule.Quotient.liftOn`
   这些「看起来该有」的名字**都不存在**，实际名字是 `Submodule.Quotient.induction_on`；
   (c) `Submodule.ker_mkQ`、`Submodule.range_mkQ`、`Submodule.quotEquivOfEq` 在 **`Submodule`
   命名空间下**，不在 `Submodule.Quotient` 下——这一条如果按记忆写会白烧编译轮。
2. **泛性质怎么落地**。Mathlib 有 `Submodule.liftQ (f) (h : p ≤ ker f) : M ⧸ p →ₛₗ[τ₁₂] M₂`
   （存在性）与 `Submodule.liftQ_mkQ`（交换性）。唯一性没有现成名字
   （`Submodule.Quotient.liftQ_unique` 实测 `Unknown constant`），但 `Submodule.linearMap_qext`
   正是「与 π 复合后相等即相等」，一条 `hg.trans (liftQ_mkQ …).symm` 就够。于是把三者打包成
   `quotient_liftQ_exists_unique`：`(∃! g, g.comp p.mkQ = f) ↔ p ≤ ker f`。
3. **正向为什么要证**。`⟹` 方向（下降条件）不是形式上的废话：若 `x ∈ p`，则 `π x = 0`，
   于是 `f x = g (π x) = g 0 = 0`，即 `p ≤ ker f`。证明链是
   `p.mkQ x = 0`（由 `mkQ_apply` + `Quotient.mk_eq_zero`）→ `f x = g (p.mkQ x)`（由 `hg`）
   → `g 0 = 0`。编译时这里踩了一次坑：`rw [..., h0, map_zero]` 中 `h0 : p.mkQ x = 0` 在语法上
   匹配不到复合式 `(g ∘ₗ p.mkQ) x` 里的 `p.mkQ x`，改成 `simp [h0]` 才对。
4. **接口参数位置的坑**。`Submodule.liftQ_apply` 的 `h` 是**隐式**参数 `{h}`，第三个显式位置
   是 `x`；按源码书写顺序写成 `Submodule.liftQ_apply p f h x` 会被编译器当成「`h` 应该是 `M`
   的元素」。`Submodule.quotEquivOfEqBot` 的第一个显式参数是**子模本身**而不是等式证明。
   两条都是 `#check` 实测出来的，不是读源码猜的（Playbook §10.7 的 CA1 教训重演）。
5. **`theorem` 装不下线性等价**。`M ⧸ ⊥ ≃ₗ[R] M` 的类型是 `Type` 不是 `Prop`，写 `theorem`
   会报 `type of theorem ... is not a proposition`；改用 `noncomputable def`。
6. **角色分类**见下一节；公理披露见该节末段。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 商模 `M/P` | `M ⧸ p`（`Submodule.Quotient` 是命名空间，不是结构） |
| 自然投影（函数） | `Submodule.Quotient.mk : M → M ⧸ p` |
| 自然投影（线性映射） | `p.mkQ : M →ₗ[R] M ⧸ p`（底层 `Submodule.mkQ`） |
| `π(x) = π(y) ⟺ x - y ∈ P` | `quotient_mk_eq_iff`（底层 `Submodule.Quotient.eq`） |
| `π(x) = 0 ⟺ x ∈ P` | `quotient_mk_eq_zero_iff`（底层 `Submodule.Quotient.mk_eq_zero`） |
| 商加法良定义 | `quotient_mk_add`（底层 `Submodule.Quotient.mk_add`） |
| 商数量乘良定义 | `quotient_mk_smul`（底层 `Submodule.Quotient.mk_smul`） |
| 两个层次的 π 一致 | `mkQ_apply_mk`（底层 `Submodule.mkQ_apply`） |
| `ker π = P` | `mkQ_ker`（底层 `Submodule.ker_mkQ`） |
| `im π = M/P` | `mkQ_range`（底层 `Submodule.range_mkQ`） |
| `π` 满射 | `mkQ_surjective`（底层 `Submodule.mkQ_surjective`） |
| 商映射 `f̄(π(x)) = f(x)` | `quotient_liftQ_mk`（底层 `Submodule.liftQ_apply`） |
| `f̄ ∘ π = f` | `quotient_liftQ_comp_mkQ`（底层 `Submodule.liftQ_mkQ`） |
| 泛性质（存在唯一） | `quotient_liftQ_exists_unique`（本条目自证） |
| 唯一性 | `quotient_liftQ_unique`（底层 `Submodule.linearMap_qext`） |
| 商模同态外延性 | `quotient_hom_ext`（底层 `Submodule.quot_hom_ext`） |
| `P ⊆ Q` 诱导 `M/P → M/Q` | `quotient_factor_mkQ`（底层 `Submodule.factor` / `factor_mk`） |
| 该诱导映射满射 | `quotient_factor_surjective`（底层 `Submodule.factor_surjective`） |
| `M/M = 0` | `quotient_subsingleton_iff`（底层 `Submodule.Quotient.subsingleton_iff`） |
| `M/P ≠ 0 ⟺ P ≠ M` | `quotient_nontrivial_iff`（底层 `Submodule.Quotient.nontrivial_iff`） |
| `M/0 ≅ M` | `quotient_bot_equiv`（底层 `Submodule.quotEquivOfEqBot`） |

# Mathlib 角色分类（AGENTS §4 第 4 条）

本条目公开签名里出现的 Mathlib 专用对象，按四类逐项归属：

1. **语义一致的正式公开承载**（推荐复用）：
   - 商类型 `M ⧸ p` 与其 `Module R` 实例（`Submodule.Quotient.module`）：教材商模的正式承载。
     披露：`Submodule.Quotient` **不是**一个可 `#check` 的常量，它是命名空间；商模在 Lean 里
     就是「带模结构的商类型」，不存在一个叫 `Submodule.Quotient` 的结构体可供命名。
   - `Submodule.Quotient.mk`（函数）与 `Submodule.mkQ`（线性映射）：教材自然投影 π 的正式承载，
     两个层次都在公开签名里出现（这正是本条目要解释的「为什么教材的一个 π 在 Lean 里是两个」）。
   - `Submodule.liftQ`：商映射的正式承载，出现在 `quotient_liftQ_mk`、`quotient_liftQ_comp_mkQ`、
     `quotient_liftQ_unique` 的陈述里。
   - `Submodule.factor`：`p ≤ p'` 诱导的商映射的正式承载（`quotient_factor_mkQ` 等）。
   - `Submodule.quotEquivOfEqBot`：`M ⧸ ⊥ ≃ₗ[R] M` 的正式承载（`quotient_bot_equiv`）。
   - `LinearMap.ker` / `LinearMap.range`：核与像的正式承载，在 `mkQ_ker` / `mkQ_range` 里出现；
     其角色分类已在 `commutative-algebra.module.definition` 做过，本条目不重复论证。
2. **本库特殊定义的桥**：**无**。本条目不定义任何新结构或新谓词：教材的商模与 Mathlib 的
   `M ⧸ p` 语义逐条一致（陪集、按代表元定义的运算、自然投影），因此不存在「本库记号 ↔ Mathlib
   结构」的桥。这与 CA1 定义层形成对照（那一层有 L1 的 `IsSubspace` 桥与 A2 的
   `TwoSidedIdealSet` 桥）；本条目没有桥不是遗漏，而是承载选择正确的结果。
3. **私有证明后端**（只出现在 `:= by` 之后或作为单行 term 的底层引理，不进公开签名；逐项披露）：
   `Submodule.Quotient.eq`、`Submodule.Quotient.mk_eq_zero`、`Submodule.Quotient.mk_add`、
   `Submodule.Quotient.mk_smul`、`Submodule.mkQ_apply`、`Submodule.ker_mkQ`、`Submodule.range_mkQ`、
   `Submodule.mkQ_surjective`、`Submodule.liftQ_apply`、`Submodule.liftQ_mkQ`、
   `Submodule.linearMap_qext`、`Submodule.quot_hom_ext`、`Submodule.factor_mk`、
   `Submodule.factor_surjective`、`Submodule.Quotient.subsingleton_iff`、
   `Submodule.Quotient.nontrivial_iff`、`Submodule.quotEquivOfEqBot`、`LinearMap.mem_ker`、
   `LinearMap.congr_fun`、`Submodule.eq_bot_iff`、`Submodule.mem_comap`、`Submodule.subtype_apply`。
   公开陈述与 Mathlib 原引理**同名不同命名空间**（例如本库的 `mkQ_ker` 与 `Submodule.ker_mkQ`），
   映射表已逐条注明底层对应物，不会让读者误以为是新数学。
4. **超出课程层级的公开泄漏**：**无**。公开签名里只有模、子模、模同态、商模与商映射，
   没有同构定理、直和、正合列、张量积、局部化、范畴语言。两个专门复核过的可疑点：
   （i）`Submodule.liftQ` 的完整类型是**半线性**的（带 `{τ₁₂ : R →+* R₂}`），但本条目一律在
   `R₂ = R`、`τ₁₂ = RingHom.id R` 的线性形式 `M →ₗ[R] N` 上陈述，`RingHomSurjective (RingHom.id R)`
   由类型类合成自动提供，不进公开签名；
   （ii）`Submodule.Quotient.subsingleton_iff` / `nontrivial_iff` 用到了 `Subsingleton`/`Nontrivial`
   两个类型类——它们是「商模塌缩成一点」的教材说法的标准载体（`M/M = 0` 与 `M/P ≠ 0`），
   不是高阶结构。

**公理披露**（Playbook §3，逐条实测，非推测）：18 条声明中，17 条的 `#print axioms` 都是
`[propext, Classical.choice, Quot.sound]`（`quotient_bot_equiv` 同）。**这是类型级噪声**，
判决性实验：本条目实测

```lean
theorem q_refl (p : Submodule R M) : p.mkQ = p.mkQ := rfl
-- #print axioms q_refl → [propext, Classical.choice, Quot.sound]
```

——一条 `rfl` 也报 `Classical.choice`，说明 choice 来自类型 `M ⧸ p` 的商构造本身
（Playbook §3.3 的「结构底线」），与本条目的证明路径无关，也无法通过改写证明消除。
对照实验：同一文件里 `theorem q_mem (p : Submodule R M) (x : M) : x ∈ p → x ∈ p := id`
的档案是 `does not depend on any axioms`，说明噪声确实只跟着商类型走。
`Quot.sound` 是商类型的构造公理，同样不可削减。

# 依赖（人话版）

- `commutative-algebra.module.definition`（CA1 定义层）：提供模、子模与模同态的教材定义与
  Mathlib 承载（`Module`、`Submodule`、`LinearMap`）以及 L1/A2 两条桥。本条目全程使用
  `Submodule R M` 这个承载，并复用定义层的 `[CommRing R] [AddCommGroup M] [Module R M]` 设定；
  本条目**不**重新解释子模是什么。
- Mathlib 侧的底座（不是本库 Entry）：`Quotient`（商类型的构造与 `Quot.sound`）、
  `Submodule.Quotient.module`（商模的模实例，本条目只使用不解释）。
- 本条目是 CA1 后续条目的前提：`commutative-algebra.module.isomorphism-theorems` 直接用
  `quotient_liftQ_exists_unique` 与 `Submodule.factor` 构造三条同构定理；CA2 的
  `commutative-algebra.module.exact-sequence` 要用余核 `M ⧸ im f`；CA3 的张量积右正合性
  也要用商模的泛性质。它们本批冻结或更晚。

# 应用与陷阱

- **应用 1（下降同态）**：`quotient_liftQ_exists_unique` 是「在商模上定义映射」的唯一合法入口。
  要定义 `M/P → N`，教材的标准动作是：先在 `M` 上定义一个同态 `f`，验证 `P ⊆ ker f`，
  再由泛性质得到 `f̄`。本条目把这三步压成一条 iff，避免了「先构造再证良定义」的手工劳动。
- **应用 2（同构定理的机器）**：`mkQ_ker`（`ker π = P`）与 `quotient_liftQ_exists_unique`
  合起来就是第一同构定理的全部机器：`M/ker f ≅ im f` 的映射就是
  `(ker f).liftQ f` 再收余域。下一 Entry 的证明链正是这么走的。
- **应用 3（商环）**：`A/I` 是 `Ideal R = Submodule R R` 的商模特例（见定义层的 A2 桥）。
  本条目对 `M ⧸ p` 说的话，对 `A ⧸ I` 同样成立。
- **陷阱 1（`Submodule.Quotient` 不是常量）**：`#check @Submodule.Quotient` 报
  `Unknown constant`。它是命名空间，商模类型写作 `M ⧸ p`。同族实测不存在的名字还有
  `Submodule.Quotient.mk'`、`Submodule.Quotient.inductionOn`、`Submodule.Quotient.liftOn`、
  `Submodule.Quotient.liftQ_unique`、`Submodule.Quotient.ker_liftQ`、`Submodule.Quotient.range_liftQ`、
  `Submodule.quotientEquivOfEq`（真名在 `Submodule` 下：`Submodule.quotEquivOfEq`）；
  实测存在的正确名字是 `Submodule.Quotient.induction_on`、`Submodule.ker_mkQ`、
  `Submodule.range_mkQ`、`Submodule.ker_liftQ`、`Submodule.range_liftQ`。不要凭印象引用。
- **陷阱 2（`h` 是隐式参数）**：`Submodule.liftQ_apply` 的类型是
  `(p) (f) {h} (x)`——`h` 是隐式的，显式第三位是 `x`。写成 `liftQ_apply p f h x` 会被读成
  「`h` 是 `M` 的元素」并报 `Application type mismatch`。
- **陷阱 3（`theorem` 与 `Type`）**：`M ⧸ ⊥ ≃ₗ[R] M` 是 `Type`，不能用 `theorem` 声明；
  必须用 `noncomputable def`。这条对任何以 `≃ₗ` 为结论的「定理」都成立。
- **陷阱 4（`rw` 不认 defeq）**：`h0 : p.mkQ x = 0` 无法用 `rw` 改写复合式
  `(g ∘ₗ p.mkQ) x` 里的 `p.mkQ x`（Playbook §5.2 的同类现象），改用 `simp [h0]` 即可。
- **陷阱 5（商模的 `Classical.choice` 是结构底线）**：见「Mathlib 角色分类」末段。
  一条 `rfl` 也带 choice，说明它来自类型 `M ⧸ p` 的商构造，不是证明噪声，不可削减。
  写新引理时不要把这条 choice 当成「可以优化掉」的目标。
- **未完成边界**：不含三大同构定理本身（下一 Entry `commutative-algebra.module.isomorphism-theorems`）；
  不含直和（`commutative-algebra.module.direct-sum`）；不含子集生成子模
  （`commutative-algebra.module.generated`）；不含张量积、局部化、正合列；不含商模上的一般
  格性质（子模对应定理 `Submodule.comapMkQRelIso`、`Submodule.mapQ` 的完整演算、
  `Submodule.Quotient.equiv` 等在 Mathlib 存在但未列入公开接口）。本条目公开陈述一律写在
  教材设定 `[CommRing R] [AddCommGroup M] [Module R M]` 上，Mathlib 的承载更一般
  （`Ring`/`AddCommGroup`），本条目不把这种一般性当教材内容，也不为迁就它弱化陈述。
