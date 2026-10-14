---
id: commutative-algebra.module.isomorphism-theorems
family: commutative-algebra.module
variant: textbook
kind: theorem
state: verified
title: 模的三大同构定理
summary: 交换环上模的第一、第二、第三同构定理，每条按「构造诱导映射 → 证核/单射 → 证满射 → 组装线性等价」四步自建完整证明链（不引用 Mathlib 的三条现成等价）；含陈述口径说明、Mathlib 四类角色分类、公理披露与未完成边界
premises: [commutative-algebra.module.definition, commutative-algebra.module.quotient]
mathlib: [Submodule.Quotient.mk, Submodule.mkQ, Submodule.liftQ, Submodule.factor, Submodule.inclusion, Submodule.comap, Submodule.map, Submodule.prod, LinearMap.codRestrict, LinearMap.ker, LinearMap.range, LinearEquiv.ofBijective]
provenance:
  source_type: book
  ref: "atiyah-macdonald-commutative-algebra-1969"
---

# 动机

商模（`commutative-algebra.module.quotient`）交付的是「下降同态」这一台机器。**三大同构定理**
是这台机器第一次真正做功的地方：它们说，模的构造里三处看起来不同的商，其实是同一个东西。

- **第一同构定理** `M / ker f ≅ im f`：任意模同态都能「分解」为满射 + 同构 + 单射。
  它是整门课使用频率最高的定理——证明某个商模同构于某个具体模，几乎总是先造一个同态、
  算它的核、再引用这一条。
- **第二同构定理** `(S + T)/T ≅ S/(S ∩ T)`：子模的和与交通过商互相交换。
  它是「子模格是模的」这一直觉的精确版本，也是投射模、正合列里「分裂」判据的原料。
- **第三同构定理** `(M/S)/(T/S) ≅ M/T`（`S ⊆ T`）：商的商还是商。
  它保证「商掉 `S` 之后再商掉 `T/S`」与「直接商掉 `T`」没有区别。

**本条目与「包装 Mathlib」的界线（这是本批简令点名的出口条件）。** 本版 Mathlib 里三条定理
**都已经有现成的线性等价**：`LinearMap.quotKerEquivRange`、
`LinearMap.quotientInfEquivSupQuotient`、`Submodule.quotientQuotientEquivQuotient`。
如果本条目只是 `:= LinearMap.quotKerEquivRange f` 这样写一行，那它交付的是「Mathlib 有这条定理」
这条事实，而不是教材定理。所以本条目采用**证明链口径**：每条定理都按教材的四步自己走完——

1. **构造诱导映射**（用 `Submodule.liftQ` 下降，或 `Submodule.inclusion` 复合 `mkQ`）；
2. **算核**（用陪集判等 `Submodule.Quotient.eq` 或 `Submodule.ker_liftQ_eq_bot`）；
3. **证满射**（取出代表元，把像写成陪集）；
4. **用 `LinearEquiv.ofBijective` 组装**。

本文件**不引用**上述三条现成等价，也不引用 `Submodule.quotientQuotientEquivQuotientAux`
（这一条可以用 `grep` 在源码里核实：它们只出现在本文件的模块 docstring 里，正文没有任何调用）。
只复用下层接口：`liftQ`、`mkQ`、`factor`、`inclusion`、`ker_liftQ_eq_bot`、`Quotient.eq`。

**与 `commutative-algebra.module.quotient` 的分工**：商模条目交付 `M ⧸ p` 的承载、自然投影、
陪集判等与泛性质；本条目只做三条同构定理本身。两条条目共享同一批下层接口，不重复实现。

# 直觉

**三条定理的共同骨架是同一句话：先在 `M` 上造映射，再让它穿过商。**

以第一同构定理为例。想要 `M/ker f ≅ im f`，最自然的动作是「让 `f` 自己下降」：
`f` 在 `ker f` 上取零，所以由商模泛性质它下降为 `f̄ : M/ker f → im f`。
剩下两件事：

- **单射**：`f̄(π x) = 0` 意味着 `f(x) = 0`，即 `x ∈ ker f`，即 `π x = 0`。核里只有零陪集；
- **满射**：`im f` 的元素按定义就是 `f(x)`，而它就是 `π x` 的像。

第二、第三同构定理的骨架完全相同，只是「先在 `M` 上造的映射」不同：

| 定理 | 先在 `M`（或其子模）上造的映射 | 下降用的子模 | 单射来自 | 满射来自 |
|---|---|---|---|---|
| 第一 | `f : M → N`，余域收到 `im f` | `ker f` | `ker f̄ = ⊥` | `im f` 的定义 |
| 第二 | `S ↪ S + T ↠ (S+T)/T` | `S ∩ T` | `ker = S ∩ T` | `x = s + t` 拆解 |
| 第三 | `M/S → M/T`（`p ≤ p'` 诱导） | `T/S = T.map S.mkQ` | `ker = T/S` | 双重陪集直接取像 |

**第二同构定理的形式化难点不在数学，在记法。** 教材写 `S/(S ∩ T)`，其中 `S ∩ T` 必须看成
`S` 的子模；在 Lean 里 `S ⧸ (S ⊓ T)` 根本写不出来（`S ⊓ T : Submodule R M` 是 `M` 的子模，
不是 `↥S` 的子模）。正确的写法是 `Submodule.comap S.subtype T`（把 `T` 沿 `S ↪ M` 拉回来）。
本条目专门给了一条桥 `second_iso_mem_comap_iff` 说明这两种写法指的是同一批元素，并在 Lean 对照
一节里把口径写清。

**第三同构定理的形式化难点在「双重陪集」。** `(M ⧸ S) ⧸ T.map S.mkQ` 的元素是「陪集的陪集」，
任何关于它的陈述都要用两次 `Submodule.Quotient.induction_on`，任何等式都要用一次
`Submodule.Quotient.eq`（`mk a = mk b ↔ a - b ∈ ...`）。本条目给出 `third_iso_mk_mk`
（`mk (mk x) ↦ mk x`）把这条计算规则固定下来。

**一个必须说清的边界。** 三条定理里的「≅」在 Lean 里是 `≃ₗ[R]`（线性等价，**数据**），
不是 `↔`（命题）。所以三条定理在本文件里是 `noncomputable def` 而不是 `theorem`：它们
**产生**一个对象（同构映射），不只是断言一件事。这一点在「应用与陷阱」里展开。

# 陈述（自然语言）

以下固定：`A` 是含单位元的交换环，`M, N` 是 `A`-模，`S, T ⊆ M` 是子模。

**定理 1（第一同构定理）**。设 `f : M → N` 是模同态。则

`M / ker f ≅ im f`，`x + ker f ↦ f(x)`。

若 `f` 满射，则 `M / ker f ≅ N`。

**定理 2（第二同构定理）**。设 `S, T ⊆ M` 是子模。则

`(S + T) / T ≅ S / (S ∩ T)`，`x + (S ∩ T) ↦ x + T`（`x ∈ S`）。

**定理 3（第三同构定理）**。设 `S ⊆ T ⊆ M` 是子模。则

`(M / S) / (T / S) ≅ M / T`，`(x + S) + (T/S) ↦ x + T`。

三条的证明骨架相同：构造诱导映射 → 证核 → 证满射 → 组装。详细证明见「思维脉络」。

# 陈述（Lean 对照）

```lean
-- 正式承载（Mathlib）：三条定理里的全部对象都在 CA1 商模条目里出现过
--   M ⧸ p                    ：商模
--   Submodule.liftQ          ：商模泛性质（下降同态）
--   Submodule.factor         ：p ≤ p' 诱导的 M ⧸ p →ₗ[R] M ⧸ p'
--   Submodule.inclusion      ：p ≤ p' 诱导的 ↥p →ₗ[R] ↥p'
--   LinearEquiv.ofBijective  ：由双射组装线性等价

/- 第一同构定理 -/
noncomputable def firstIsoHom (f : M →ₗ[R] N) :
    M ⧸ LinearMap.ker f →ₗ[R] LinearMap.range f

theorem firstIsoHom_mk (f : M →ₗ[R] N) (x : M) :
    firstIsoHom f (Submodule.Quotient.mk x) = ⟨f x, ⟨x, rfl⟩⟩

theorem firstIsoHom_ker (f : M →ₗ[R] N) : LinearMap.ker (firstIsoHom f) = ⊥

theorem firstIsoHom_injective (f : M →ₗ[R] N) : Function.Injective (firstIsoHom f)

theorem firstIsoHom_surjective (f : M →ₗ[R] N) : Function.Surjective (firstIsoHom f)

noncomputable def first_iso (f : M →ₗ[R] N) :
    (M ⧸ LinearMap.ker f) ≃ₗ[R] LinearMap.range f

noncomputable def first_iso_of_surjective (f : M →ₗ[R] N) (hf : Function.Surjective f) :
    (M ⧸ LinearMap.ker f) ≃ₗ[R] N

theorem first_iso_mk (f : M →ₗ[R] N) (x : M) :
    (first_iso f (Submodule.Quotient.mk x) : N) = f x

/- 第二同构定理（S, T : Submodule R M） -/
noncomputable def secondIsoHom (S T : Submodule R M) :
    ↥S →ₗ[R] (↥(S ⊔ T)) ⧸ Submodule.comap (S ⊔ T).subtype T

theorem secondIsoHom_ker (S T : Submodule R M) :
    LinearMap.ker (secondIsoHom S T) = Submodule.comap S.subtype T

theorem second_iso_mem_comap_iff (S T : Submodule R M) (x : ↥S) :
    x ∈ Submodule.comap S.subtype T ↔ (x : M) ∈ S ⊓ T

noncomputable def secondIsoMap (S T : Submodule R M) :
    (↥S ⧸ Submodule.comap S.subtype T) →ₗ[R]
      (↥(S ⊔ T)) ⧸ Submodule.comap (S ⊔ T).subtype T

theorem secondIsoMap_ker (S T : Submodule R M) : LinearMap.ker (secondIsoMap S T) = ⊥

theorem secondIsoMap_surjective (S T : Submodule R M) : Function.Surjective (secondIsoMap S T)

noncomputable def second_iso (S T : Submodule R M) :
    (↥S ⧸ Submodule.comap S.subtype T) ≃ₗ[R]
      (↥(S ⊔ T)) ⧸ Submodule.comap (S ⊔ T).subtype T

theorem second_iso_mk (S T : Submodule R M) (x : ↥S) :
    second_iso S T (Submodule.Quotient.mk x) =
      Submodule.Quotient.mk (Submodule.inclusion le_sup_left x)

/- 第三同构定理（S T : Submodule R M，h : S ≤ T） -/
theorem factor_ker (h : S ≤ T) : LinearMap.ker (Submodule.factor h) = T.map S.mkQ

noncomputable def thirdIsoMap (h : S ≤ T) : (M ⧸ S) ⧸ T.map S.mkQ →ₗ[R] M ⧸ T

theorem thirdIsoMap_ker (h : S ≤ T) : LinearMap.ker (thirdIsoMap h) = ⊥

theorem thirdIsoMap_surjective (h : S ≤ T) : Function.Surjective (thirdIsoMap h)

noncomputable def third_iso (h : S ≤ T) : ((M ⧸ S) ⧸ T.map S.mkQ) ≃ₗ[R] M ⧸ T

theorem third_iso_mk_mk (h : S ≤ T) (x : M) :
    third_iso h (Submodule.Quotient.mk (S.mkQ x)) = Submodule.Quotient.mk x
```

（上表中所有声明的完整 binder 都是教材设定 `{R M N : Type*} [CommRing R] [AddCommGroup M]
[AddCommGroup N] [Module R M] [Module R N]`，第二、三两条只用 `M`，为排版省略。）

**陈述口径的两处说明。**

1. **第二同构定理里 `S ∩ T` 的写法**。教材的 `S/(S ∩ T)` 在 Lean 里写成
   `↥S ⧸ Submodule.comap S.subtype T`：`S.subtype : ↥S →ₗ[R] M` 是包含映射，
   `comap S.subtype T` 就是「`T` 沿包含拉回 `S` 里」，其载体是 `{x : ↥S | (x : M) ∈ T}`。
   `second_iso_mem_comap_iff` 给出 `x ∈ comap S.subtype T ↔ (x : M) ∈ S ⊓ T`，
   于是教材记号与 Lean 写法可以逐元素互译。`S + T` 写成 `S ⊔ T`（子模格的上确界就是和）。
2. **第三同构定理里 `T/S` 的写法**。教材的 `T/S` 在 Lean 里写成 `T.map S.mkQ`：
   `T` 沿自然投影 `S.mkQ : M →ₗ[R] M ⧸ S` 的像，即 `M ⧸ S` 中那些「代表元落在 `T` 里」的陪集。
   `factor_ker` 正是「这个子模恰是 `M ⧸ S → M ⧸ T` 的核」这条计算。

# 思维脉络（thinking trace）

1. **先查 Mathlib 有没有现成的，再决定怎么写**。开工第一步 `grep` 了
   `Mathlib/LinearAlgebra/Isomorphisms.lean`（该文件开头就写「The Noether's first, second, and
   third isomorphism theorems for modules are proved as `LinearMap.quotKerEquivRange`,
   `LinearMap.quotientInfEquivSupQuotient` and `Submodule.quotientQuotientEquivQuotient`」），
   确认三条都现成。这一步决定了本条目的**写法**：既然目标是「教材定理」而不是「Mathlib 索引」，
   就必须自己走证明链，并把「不引用这三条」写进模块 docstring 以便审阅者核实。
2. **第一同构定理：构造方式换了一次（用了两轮编译）**。初稿的构造是
   「`(ker f).liftQ (f.codRestrict (range f) _) h`」——先下降再收余域，于是必须证明
   `LinearMap.ker (f.codRestrict (range f) _) = LinearMap.ker f`。这个等式落在 **`Subtype` 层**：
   目标变成 `f x = 0 ↔ (codRestrict …) x = 0`，两边要来回做 `Subtype` 强转，
   `simp [Submodule.coe_eq_zero]` 报「unused simp argument」，改 `Subtype.coe_injective` 又因
   参数类型是元变量而报 `Type mismatch`。**第二轮换构造**：把 `codRestrict` 提到最外层，
   用 `Submodule.Quotient.induction_on` 直接给出「落在 `im f` 里」的证明：

   ```lean
   LinearMap.codRestrict (LinearMap.range f) ((LinearMap.ker f).liftQ f le_rfl)
     (fun x => Submodule.Quotient.induction_on (LinearMap.ker f) x fun m =>
       ⟨m, (Submodule.liftQ_apply (LinearMap.ker f) f m).symm⟩)
   ```

   核等式整步消失，一次通过。教训：**`Subtype` 层的等式是形式化噪声，能用「把 `codRestrict`
   提到最外层 + 陪集归纳」消掉就不要证**。
3. **`induction_on` 只改目标，不改假设（第一轮编译的第二个错）**。`firstIsoHom_ker` 里
   `intro x hx` 之后直接 `refine Submodule.Quotient.induction_on … x fun m => ?_`，目标里的 `x`
   被换成了 `mk m`，但 `hx : firstIsoHom f x = 0` 仍然说的是 `x`，于是
   `rw [firstIsoHom_mk] at hx` 报「找不到模式 `firstIsoHom f (mk ?x)`」。正确写法是先
   `revert hx` 把假设放回目标，再做归纳，`intro m hx` 时 `hx` 就已经是关于 `mk m` 的了。
4. **第一同构定理的单射与满射**。单射：`ker = ⊥`（`Submodule.eq_bot_iff` + 陪集归纳 +
   `Quotient.mk_eq_zero`），再走 `LinearMap.ker_eq_bot.mp`。满射：`im f` 的元素写成
   `⟨y, x, rfl⟩`，原像取 `mk x`。两条各自独立成定理，最后 `LinearEquiv.ofBijective` 组装。
5. **第二同构定理：核的计算**。`secondIsoHom S T = mkQ ∘ inclusion`。核的证明是
   `ext x` + `simp only [LinearMap.mem_ker, secondIsoHom, LinearMap.comp_apply, Submodule.mkQ_apply,
   Submodule.Quotient.mk_eq_zero, Submodule.mem_comap, Submodule.coe_inclusion, Submodule.subtype_apply]`
   ——关键是 `Submodule.coe_inclusion`：把 `↑(inclusion le_sup_left x)` 化回 `↑x`。
   下降用 `liftQ` + `le_of_eq (secondIsoHom_ker S T).symm`；单射直接用
   `Submodule.ker_liftQ_eq_bot`（「被商的子模恰好是核」就是单射性的全部内容）。
6. **第二同构定理：满射的拆解**。`(S ⊔ T)/T` 的元素是 `mk x`（`x : ↥(S ⊔ T)`）；
   `Submodule.mem_sup.mp x.2` 给出 `s ∈ S`、`t ∈ T`、`s + t = x`；取原像 `mk ⟨s, hs⟩`，
   再证两个陪集相等——由 `Submodule.Quotient.eq` 归结为 `(x : M) - s ∈ T`，
   而 `x - s = t ∈ T`（`abel` 一步把 `s - (s + t)` 化成 `-t`）。
7. **第三同构定理：`rw` 不认 defeq（用了两轮编译）**。`Submodule.factor_mk` 的陈述写作
   `(Submodule.factor h) (p.mkQ x) = p'.mkQ x`，而 `Submodule.Quotient.induction_on` 给出的目标
   里写的是 `Submodule.Quotient.mk m`。两者**定义上相等**（`Submodule.mkQ_apply` 是 `rfl`），
   但 `rw` 的关键字匹配认不出，报「Did not find an occurrence of the pattern」。
   修法是先用 `change` 把整个目标换成 `mkQ` 写法（`change` 是 defeq-aware 的），再做 `rw`。
   这正是 Playbook §5.2「`rw` 找不到复合记号的匹配」的又一实例。
8. **第三同构定理：不要用 `rw` 一把梭**。反向那半需要把假设 `S.mkQ t = S.mkQ m` 转成
   `t - m ∈ S`；如果直接在目标上 `rw [Submodule.mkQ_apply]`，`rw` 会把目标里**所有** `mkQ`
   一起重写（包括 `S.mkQ t`），破坏结构。改成在**假设**上局部改写（`have` + `rw at`），
   或者直接靠 defeq 把 `mkQ` 形式的假设喂给以 `Quotient.mk` 陈述的 `Submodule.Quotient.eq`。
9. **组装**。三条定理的最后一步都是 `LinearEquiv.ofBijective`。注意它的结果是 `≃ₗ[R]`（数据），
   所以三条定理声明为 `noncomputable def` 而不是 `theorem`——Lean 会直接拒绝
   `type of theorem ... is not a proposition`（本批商模条目的 `quotient_bot_equiv` 踩过同一个坑）。
10. **反「包装」核查**。交付前 `grep` 本文件正文，确认
    `quotKerEquivRange` / `quotientInfEquivSupQuotient` / `quotientQuotientEquivQuotient` /
    `quotientQuotientEquivQuotientAux` 四个名字**只出现在模块 docstring 的声明性句子里**，
    没有任何调用点。这是本条目「完整证明链」这一出口条件的机器可查证据。
11. **角色分类**见下一节；公理披露见该节末段。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 第一同构定理 `M/ker f ≅ im f` | `first_iso f : (M ⧸ LinearMap.ker f) ≃ₗ[R] LinearMap.range f` |
| 诱导映射 `x + ker f ↦ f(x)` | `firstIsoHom f`（构造）+ `firstIsoHom_mk`（取值） |
| 满射版本 `M/ker f ≅ N` | `first_iso_of_surjective f hf` |
| 单射性 | `firstIsoHom_ker`（`ker = ⊥`）+ `firstIsoHom_injective` |
| 满射性 | `firstIsoHom_surjective` |
| 同构在陪集上求值 | `first_iso_mk`（`(first_iso f (mk x) : N) = f x`） |
| 第二同构定理 `(S+T)/T ≅ S/(S∩T)` | `second_iso S T : (↥S ⧸ comap S.subtype T) ≃ₗ[R] (↥(S ⊔ T)) ⧸ comap (S ⊔ T).subtype T` |
| 诱导映射 `x + (S∩T) ↦ x + T` | `secondIsoHom S T`（构造）+ `second_iso_mk`（取值） |
| `S ∩ T` 作为 `S` 的子模 | `Submodule.comap S.subtype T` |
| 教材记号与 Lean 写法的互译 | `second_iso_mem_comap_iff` |
| 下降映射 | `secondIsoMap S T` |
| 单射性 | `secondIsoMap_ker`（`ker = ⊥`） |
| 满射性 | `secondIsoMap_surjective` |
| 第三同构定理 `(M/S)/(T/S) ≅ M/T` | `third_iso h : ((M ⧸ S) ⧸ T.map S.mkQ) ≃ₗ[R] M ⧸ T` |
| 双重陪集求值 `(x+S)+(T/S) ↦ x+T` | `third_iso_mk_mk` |
| `T/S` 作为 `M ⧸ S` 的子模 | `T.map S.mkQ` |
| `M/S → M/T` 的核恰是 `T/S` | `factor_ker h` |
| 下降映射 | `thirdIsoMap h` |
| 单射性 / 满射性 | `thirdIsoMap_ker` / `thirdIsoMap_surjective` |
| 由双射组装线性等价 | `LinearEquiv.ofBijective` |

# Mathlib 角色分类（AGENTS §4 第 4 条）

本条目公开签名里出现的 Mathlib 专用对象，按四类逐项归属：

1. **语义一致的正式公开承载**（推荐复用）：
   - 商类型 `M ⧸ p` 与 `Submodule.Quotient.mk`、`Submodule.mkQ`：教材商模与自然投影的正式承载，
     三条定理的**陈述**全部建立在它们之上。其角色论证已在
     `commutative-algebra.module.quotient` 做过，本条目不重复。
   - `Submodule.liftQ`：商模泛性质的正式承载，是本条目「下降」这一步的载体。
   - `Submodule.factor`：`p ≤ p'` 诱导的商映射，第三同构定理的构造原料。
   - `Submodule.inclusion`：`p ≤ p'` 诱导的包含映射（`↥p →ₗ[R] ↥p'`），
     第二同构定理的构造原料；教材里它就是含入 `S ↪ S + T`。
   - `Submodule.comap` / `Submodule.map`：子模沿同态的原像与像，是第二、第三同构定理把
     教材的 `S ∩ T`、`T/S` 翻译成 `↥S` 与 `M ⧸ S` 的子模时用的正式承载。
   - `LinearMap.ker` / `LinearMap.range` / `LinearMap.codRestrict`：核、像与「把余域收到子模」
     的正式承载；`ker`/`range` 的角色论证在 CA1 定义层做过。
   - `LinearEquiv.ofBijective`：由双射组装线性等价的标准入口；它产生的是 `≃ₗ[R]`（数据），
     这也是三条定理写成 `noncomputable def` 的原因。
2. **本库特殊定义的桥**：**无**。本条目不定义任何新结构或新谓词。本文件里唯一带「桥」味道的
   `second_iso_mem_comap_iff` 是**教材记号与 Mathlib 记号之间的翻译引理**（`S ∩ T` 的两种写法），
   两端都是 Mathlib 的 `Submodule`，不构成「本库结构 ↔ Mathlib 结构」意义上的桥。
3. **私有证明后端**（只出现在 `:= by` 之后，不进公开签名；逐项披露）：
   `Submodule.liftQ_apply`、`Submodule.ker_liftQ_eq_bot`、`Submodule.factor_mk`、
   `Submodule.Quotient.induction_on`、`Submodule.Quotient.eq`、`Submodule.Quotient.mk_eq_zero`、
   `Submodule.mkQ_apply`、`Submodule.mem_sup`、`Submodule.mem_comap`、`Submodule.mem_inf`、
   `Submodule.coe_inclusion`、`Submodule.subtype_apply`、`Submodule.coe_sub`、`Submodule.eq_bot_iff`、
   `Submodule.neg_mem`、`Submodule.sub_mem`、`LinearMap.mem_ker`、`LinearMap.ker_eq_bot`、
   `LinearMap.range_eq_top`、`LinearMap.congr_fun`、`LinearEquiv.ofTop`、`LinearEquiv.coe_ofBijective`、
   `SetLike.ext`（经 `ext`）、`Subtype.ext`、`Subtype.coe_injective`、`congrArg`、`abel`（策略）。
   公开陈述与 Mathlib 原引理**同名不同命名空间**（例如本库的 `factor_ker` 与 Mathlib 的
   `Submodule.ker_liftQ`），映射表已注明底层对应物，不会让读者误以为是新数学。
4. **超出课程层级的公开泄漏**：**无**。公开签名里只有模、子模、模同态、商模与线性等价。
   三处专门复核过的可疑点：
   （i）`Submodule.liftQ` 的完整类型是**半线性**的（带 `{τ₁₂ : R →+* R₂}`），但本条目一律在
   `R₂ = R`、`τ₁₂ = RingHom.id R` 的线性形式下使用，`RingHomSurjective (RingHom.id R)` 由类型类
   合成自动提供，不进公开签名；
   （ii）`↥S`（子类型的模结构）出现在第二同构定理的公开签名里——它是教材「把 `S` 本身看成模」
   的正式承载（子模自带模结构），不是高阶结构；
   （iii）`T.map S.mkQ` 出现在第三同构定理的公开签名里——它就是教材的 `T/S`，见上文口径说明。

**公理披露**（Playbook §3，逐条实测，非推测）：22 条声明全部为
`[propext, Classical.choice, Quot.sound]`。三条来源不同，逐条说清：

- `Quot.sound`：商类型 `M ⧸ p` 的构造公理，不可削减；
- `Classical.choice` 的**类型级部分**：本条目实测，同一次编译里
  `theorem q_refl (p : Submodule R M) : p.mkQ = p.mkQ := rfl`（商模条目）与
  `theorem compl_refl (p q : Submodule R M) : IsCompl p q = IsCompl p q := rfl`（直和条目）
  都报这三条，说明「陈述里出现商类型或 `IsCompl`」本身就会带进 choice，与证明路径无关
  （Playbook §3.3）；
- `Classical.choice` 的**数学必需部分**：`LinearEquiv.ofBijective`（以及 `LinearEquiv.ofTop`）
  需要为双射**选**一个逆映射。这是数学上非构造的一步——「存在唯一的逆」到「给出逆函数」
  必须用选择。本条目没有为了消掉它而弱化任何陈述，也没有把它伪装成零公理。
  对照：Mathlib 自己的 `LinearMap.quotKerEquivRange` 同样是 `noncomputable` 且带 choice，
  口径一致。

# 依赖（人话版）

- `commutative-algebra.module.definition`（CA1 定义层）：提供模、子模与模同态的教材定义与
  Mathlib 承载（`Module`、`Submodule`、`LinearMap`、`LinearMap.ker`、`LinearMap.range`）。
  本条目所有陈述里的 `M →ₗ[R] N`、`Submodule R M`、`ker`、`range` 都来自它。
- `commutative-algebra.module.quotient`（**同批条目，尚未登记 Registry**）：提供商模 `M ⧸ p`、
  自然投影 `mkQ`、陪集判等与商模泛性质 `quotient_liftQ_exists_unique`。本文件 `import` 了它，
  并且第一、第三两条定理的构造方式与它的 `quotient_liftQ_*` 一族完全同构（只是把
  「存在唯一的 `g`」实例化成具体的 `firstIsoHom`/`thirdIsoMap`）。**Registry 登记时
  `premises` 必须补上这一条**——本文件在 pack 生成时该条目尚未登记，所以 pack 里只列了
  `commutative-algebra.module.definition`。这是 Main 集成时必须修正的一项。
- Mathlib 侧的底座（不是本库 Entry）：`Submodule.inclusion`、`Submodule.comap`、
  `Submodule.map`、`Submodule.factor`、`Submodule.liftQ`、`LinearEquiv.ofBijective`。
- 本条目是 CA2 的前提：正合序列（`commutative-algebra.module.exact-sequence`）的第一同构定理
  就是「`M/ker f ≅ im f`」；投射模的「分裂」判据要用第二同构定理的形状。它们本批冻结。

# 应用与陷阱

- **应用 1（造同构的标准流程）**：要证 `X ≅ Y`，教材的流程是「造同态 `X → Y`，算核，算像」。
  本条目把这个流程在三条定理上各演示了一遍，可以直接照搬：`liftQ` 下降 → 陪集判等算核 →
  取代表元算像 → `LinearEquiv.ofBijective`。这也是后续所有「商模同构」证明的模板。
- **应用 2（第一同构定理的满射版本）**：`first_iso_of_surjective` 是使用频率最高的一条。
  例如「`R ⧸ ker φ ≅ im φ`」在环论里就是 `A/I ≅ A/ker φ`；在模论里是
  「商掉核之后同构于余域」。
- **应用 3（第三同构定理与子模对应）**：`(M/S)/(T/S) ≅ M/T` 说明「`M ⧸ S` 的子模」与
  「`M` 中含 `S` 的子模」一一对应（Mathlib 的 `Submodule.comapMkQRelIso` 是这条对应的序同构，
  本条目未使用）。它是后续「子模格区间」语言的基础。
- **陷阱 1（`≃ₗ` 是数据不是命题）**：三条定理在本文件里是 `noncomputable def`。
  写 `theorem first_iso … : (M ⧸ ker f) ≃ₗ[R] range f` 会被 Lean 拒绝，报
  `type of theorem ... is not a proposition`。凡是结论为 `≃ₗ`/`≃`/`×` 的「定理」都如此。
- **陷阱 2（第二同构定理的 `S ∩ T` 写不出来）**：`S ⧸ (S ⊓ T)` 是**类型错误**——`S ⊓ T` 是
  `M` 的子模，不是 `↥S` 的子模。正确写法是 `comap S.subtype T`，其载体是
  `{x : ↥S | (x : M) ∈ T}`。同理 `(S+T)/T` 里的 `T` 要写成 `comap (S ⊔ T).subtype T`。
  这不是形式化吹毛求疵：教材默认了「`S ∩ T` 看成 `S` 的子模」这一步，Lean 要求显式。
- **陷阱 3（`rw` 不认 defeq，用 `change`）**：`Submodule.factor_mk` 用 `p.mkQ x` 陈述，
  而 `Quotient.induction_on` 的目标用 `Quotient.mk m`；两者 defeq 但 `rw` 匹配不上。
  先用 `change` 把目标换成 `mkQ` 写法，再 `rw`（Playbook §5.2）。
- **陷阱 4（`induction_on` 只改目标不改假设）**：在商模上做归纳时，若假设里含被归纳的变量，
  必须先 `revert` 该假设再做 `Submodule.Quotient.induction_on`，否则假设里的变量不会变成 `mk m`。
- **陷阱 5（不要用 `rw` 一把梭重写 `mkQ`）**：目标里若同时出现 `S.mkQ` 与 `T.mkQ`，
  在目标上 `rw [Submodule.mkQ_apply]` 会把它们一起重写。要在假设上局部改写（`have` + `rw at`），
  或直接利用 defeq 把 `mkQ` 形式的命题喂给以 `Quotient.mk` 陈述的引理。
- **陷阱 6（`Subtype` 层的等式是噪声）**：`LinearMap.ker (f.codRestrict p _) = LinearMap.ker f`
  这类等式落在 `Subtype` 层，`simp` 与 `rw` 都不好使。更好的做法是换构造，把它整步消掉
  （本条目第一同构定理的第二版构造）。
- **未完成边界（诚实清单）**：
  1. **第二同构定理只做了 `comap` 形式**，没有额外提供一条以 `Submodule.map`/`Submodule.prod`
     重写的等价版本，也没有把 Mathlib 的 `LinearMap.quotientInfEquivSupQuotient` 的
     `simp` 引理族（`quotientInfEquivSupQuotient_apply_mk`、`_symm_apply_left/right`）移植过来；
     本条目只给 `second_iso_mk` 一条取值引理。
  2. **第三同构定理只做了 `S ≤ T` 的版本**，没有做 Mathlib 里以 `⊔` 重述的
     `quotientQuotientEquivQuotientSup`，也没有做指标公式 `[M:T][T:S] = [M:S]`。
  3. **没有做环版本 / 代数版本 / 群版本**：本条目的三条定理只对模陈述；
     `A/I` 作为商环的同构定理要用 `Ideal` 层的接口，属于 A2 线。
  4. **没有做「第一同构定理的加性群版本」**：`QuotientAddGroup.quotientKerEquivRange`
     存在，本条目未使用、未比较。
  5. **没有做**：直和（`commutative-algebra.module.direct-sum`，同批条目）、子集生成子模
     （`commutative-algebra.module.generated`，同批条目）、正合序列、投射/内射/平坦、
     张量积、局部化、分次结构。
  6. **`premises` 需要 Main 补登记**：本条目实际依赖 `commutative-algebra.module.quotient`
     （`import` 了它，并用它的接口），但该条目在本批同时新登记，pack 生成时尚未入 Registry。
     集成时 `premises` 必须写成
     `[commutative-algebra.module.definition, commutative-algebra.module.quotient]`。
