# RFC：数论 N2.4–N2.15 签名冻结提案与依赖链判定

> **性质**：研究窗（`research_open`）产出。**不是可集成交付**，不含 `SandronesLibrary/` 下的正式文件，
> 不改 Registry。出口按 `docs/LEAN-PLAYBOOK.md` §10.4：签名冻结提案 + 无占位 `/tmp` 原型
> （每个 `sorry` 列条目说明在等什么）+ 接口契约 + 诚实边界。
>
> **窗口**：`e4-nt-n2-research`（worktree `/home/pisquare/czt/sandrones-library-nt-n2-research`，
> 分支 `codex/number-theory-algebraic-research`，基线 `bc8d4fe`）。
> **窗口 pack**：`number-theory-N2res-number-theory.algebraic.norm-trace`。
> **子 Agent pack**：见 §6.3。
>
> 本窗**无 Lean 交付，故无 `subject_package` 五门**（Playbook §10.4）。

---

## 1. 范围与判定口径

本 RFC 覆盖 ROADMAP §11 N2 表第 4–15 行（`number-theory.algebraic.{norm-trace, discriminant,
dedekind, fractional-ideal, ideal-factorization, class-group, prime-decomposition, minkowski,
unit-theorem, valuation, padic-completion, local-field-entry}`）。起点是已集成的 N2.1–N2.3
（`number-field` / `algebraic-integer` / `ring-of-integers`），它们的接口是 N2.4+ 的冻结起点。

**强度判定只用四档**（本 RFC 的定义，供 Main 复核）：

| 档 | 含义 |
|---|---|
| `course-strength` | 教材定义/量词与 Lean 承载同形，且有**展开或等价刻画**与至少一个真实上层使用者；证明可以由 Mathlib 承载，但**必须披露后端**，且不得是把 Mathlib 定理整体改名。 |
| `foundation` | 只登记承载与性质（如「`𝓞_K` 是 Dedekind 整环」），教材证明链**不复现**，作为下游定义的前置。 |
| `bridge` | 教材陈述与 Mathlib 陈述**不同形**，必须新建桥；桥未建成前该条目不能算课程强度。 |
| `blocked` | 教材门未解除或依赖前置未落地，**不得开工**。 |

**包内 `scope` 的说明**：本窗 pack 的 `scope.in_scope` 只有 `norm-trace`，其余 N2.4–N2.15 由脚本按
ROADMAP family 前缀机械归入 `out_of_scope`；而 pack 的手写字段 `task.goal_nl` 要求为 N2.4–N2.15
给出提案。本窗的处理是：**不实现任何条目、不写任何 `SandronesLibrary/` 文件**，只做侦察、`/tmp` 原型
与提案——这与 `out_of_scope`「不得顺手实现、不得改动它们的文件」不冲突。该歧义已在 §8 报告 Main。

---

## 2. 依赖链与 Wave C 门（开发顺序）

ROADMAP §1.2 Wave C 的原文约束：**「未有 Dedekind／分式理想定义前，不登记类群和唯一分解」**。
据此，N2.6–N2.9 不是四条平行条目，而是一条**串行依赖链**。但**编号顺序 ≠ 数学依赖顺序**，
实测后的依赖图如下（箭头 = 「必须先落地」）：

```
N2.4 norm-trace ─► N2.5 discriminant ─┐
                                      ▼
N2.1–N2.3（已集成）──────────────► N2.6 dedekind ─► N2.7 fractional-ideal
                                                       │        │
                                                       │        ├─► N2.8 ideal-factorization ─┐
                                                       │        │                             │
                                                       │        └─► N2.9 定义层（ClassGroup） │
                                                       │                                      │
                                                       └─► N2.10 prime-decomposition ◄────────┘
                                                                   （仅 e = 重数 那一支需要 N2.8）

N2.5 ──► N2.11 minkowski ──┬─► N2.9 有限性（classNumber / Fintype ClassGroup）
                           └─► N2.12 unit-theorem          （N2.12 硬依赖 N2.11）

N2.13 valuation ──► N2.14 padic-completion ──► N2.15 local-field-entry      （教材门：blocked）
```

**已实测的依赖事实**（不是计划，是 `#check`／编译结论；子 Agent 的结论已由负责人独立复跑）：

- N2.6 的 `IsDedekindDomain (𝓞 K)` 可用教材三条件**真组装**（§3、§4.3），不必只引用 Mathlib 实例；
  因此 N2.7 的 `FractionalIdeal` 有真实的前置可依。
- **N2.10 的真正前置是 N2.3 + N2.6，不是 N2.8**：`Ideal.sum_ramification_inertia_eq_finrank`
  的假设只有 `IsDomain / Module.Finite / Module.Flat / Fintype (primesOver)`，`R = ℤ, S = 𝓞 K`
  时全部自动；只有「`e` = `normalizedFactors` 重数」那一支才要 N2.8 的桥。`p ∣ disc ⟺ 分歧`
  额外要 N2.5。
- **N2.9 不是 N2.10–N2.12 的前置，反而是 N2.11 的下游**：类群的*定义*在 N2.7 之后即可写，
  但*有限性*（`instFintypeClassGroup`）与 `exists_ideal_in_class_of_norm_le` 都走 Minkowski 界。
  建议 N2.9 拆成「定义层（N2.7 后）」与「有限性层（N2.11 后）」两次交付。
- **N2.12 硬依赖 N2.11**：`NumberField.Units.exists_unit` 的证明第一步就是
  `minkowskiBound K 1 < convexBodyLTFactor K * B`。
- N2.8 的 Mathlib 形式（`∏ᶠ v : HeightOneSpectrum R, v.maxPowDividing I = I`）与教材形式
  （非零理想唯一写成素理想的有限乘积）**不同形**，需要本库建桥（§4.5）——桥已真证。
  **精度**：桥的证明只用到 N2.6（Dedekind）+ Mathlib 的 `FractionalIdeal.count` 引擎，**不需要 N2.7 的
  Entry**；Wave C 门要求「分式理想定义先行」是本库的**课程登记顺序约束**，不是 Lean 依赖。
  RFC 据实分列这两件事，登记顺序仍建议 N2.6 → N2.7 → N2.8 → N2.9。
- N2.11 的 `minkowskiBound` 是 **public def**，凸体定理也是公开定理，**没有私有后端**；
  差异只在索引方式（按无限位 vs 教材的 `Fin r₁`/`Fin r₂`）。

**建议的批次切分**（给 Main，按依赖而非编号）：

1. **批次 A（定义层）**：N2.4 → N2.5；
2. **批次 B（Dedekind 链，Wave C 门在此）**：N2.6 → N2.7 → N2.9 定义层 → N2.8；
3. **批次 C（几何与分解）**：N2.11 → N2.12；N2.10 可与批次 B 并行（其前置 N2.3 + N2.6 已足）；
4. N2.13–N2.15 在教材门解除前**一批都不开**。

---

## 3. 逐条目判定表

> 表中「Mathlib 角色」按 AGENTS §4 的四类：**正式承载**／**桥侧接口**／**私有证明后端**／**公开泄漏**。

| # | 条目 | 教材内容 | Lean 正式承载（实测） | 展开／刻画 | Mathlib 角色 | 强度判定 | 前置 |
|---|---|---|---|---|---|---|---|
| 4 | `norm-trace` | 范数 `det(m_x)`、迹 `trace(m_x)`；可乘/可加；嵌入乘积/求和；整性 | `Algebra.norm ℚ`、`Algebra.trace ℚ K` | `norm_eq_det_lmul`（`Algebra.norm_apply`）、`numberField_norm_eq_prod_embeddings`（ℂ 形式） | 正式承载（`Algebra.norm_eq_prod_embeddings` 等为证明后端） | **`course-strength`**（原型 19 条零 `sorry`） | N2.1–N2.3 |
| 5 | `discriminant` | `disc = det(Tr(ωᵢωⱼ)) = det(σᵢ(ωⱼ))²`；与整基无关；整基存在 | `Algebra.discr`、`NumberField.discr`、`NumberField.integralBasis` | `discr_eq_traceMatrix_det`、`discr_eq_embeddings_det_sq`、`exists_integralBasis_discr` | 正式承载 + 桥（`traceMatrix_apply_eq`） | **`course-strength`**（原型 8 条零 `sorry`） | N2.4 |
| 6 | `dedekind` | `𝓞_K` 是 Dedekind 整环；等价于 Noetherian + 维数 ≤ 1 + 整闭 | `IsDedekindDomain`（`IsDedekindRing` + `IsDomain`） | `ringOfIntegers_isDedekindDomain_iff`（`isDedekindDomain_iff`） | 正式承载；`IsIntegralClosure.isDedekindDomain` 是**另一条后端路线**，本库不复用它 | **`course-strength`（可组装，原型 5 条零 `sorry`）** | N2.3 |
| 7 | `fractional-ideal` | 分式理想 = `∃ a ≠ 0, aI ⊆ R` 的 `R`-子模；非零分式理想构成群 | `FractionalIdeal R⁰ K`（子类型）、`IsFractional`、`FractionalIdeal.instInv` | `IsFractional` 定义展开 + `mem_inv_iff`；**群结构只在单位 `(FractionalIdeal R⁰ K)ˣ` 上**（见 §4.4） | 正式承载（定义逐字一致） | **`course-strength`（定义层）+ `bridge`（「非零 ⇒ 可逆」）** | N2.6 |
| 8 | `ideal-factorization` | 非零理想**唯一**写成素理想的有限乘积 | 无同形承载；Mathlib 只有 `Ideal.finprod_heightOneSpectrum_factorization : ∏ᶠ v, v.maxPowDividing I = I` | 需自建 `Finsupp` 桥（§4.5，签名已实测可达） | Mathlib 的 finprod 形式是**私有证明后端**，公开形式必须本库建桥 | **`bridge`**（桥未建成前不算课程强度） | N2.7 |
| 9 | `class-group` | 分式理想模主理想；类数有限；`h = 1 ⟺ PID` | `ClassGroup R := (FractionalIdeal R⁰ (FractionRing R))ˣ ⧸ (principal).range`、`ClassGroup.mk0`、`NumberField.classNumber`、`instFintypeClassGroup`（`noncomputable`） | `classNumber_eq_one_iff` | 正式承载；有限性后端 = Minkowski 界（**须披露**） | **混合**：`mk0` 等价刻画与 `classNumber_eq_one_iff` = `course-strength`；**类群有限性只能 `foundation`／`bridge`**（Minkowski 后端未复现） | N2.7 + N2.11 |
| 10 | `prime-decomposition` | `p𝓞_K = ∏ Pᵢ^{eᵢ}`；`∑ eᵢfᵢ = n`；分歧/惯性 | `Ideal.primesOver`、`Ideal.ramificationIdx`、`Ideal.inertiaDeg`、`Ideal.sum_ramification_inertia_eq_finrank` | `IsRamifiedIn`/`IsRamifiedAt` 需本库自建（Mathlib **没有** `Ideal.IsRamified`，只有 `not_dvd_discr_iff_isUnramifiedIn` 的否定形式） | 正式承载 + 自建定义 | **`course-strength`**（`Fintype (primesOver)` 需 `p.IsMaximal`） | N2.3 + N2.6（`p∣disc` 判据另需 N2.5） |
| 11 | `minkowski` | Minkowski 嵌入；凸体定理；`∃ 0 ≠ a, |N(a)| ≤ (4/π)^{r₂}·n!/nⁿ·√|disc|` | `NumberField.mixedEmbedding`、`NumberField.mixedEmbedding.minkowskiBound`（**公开 def**）、`exists_ne_zero_mem_ringOfIntegers_of_norm_le_mul_sqrt_discr`、`MeasureTheory.exists_ne_zero_mem_lattice_of_measure_mul_two_pow_lt_measure` | 索引差异（按无限位 vs `Fin r₁`）需桥；`canonicalEmbedding` 与 `mixedEmbedding` 是两个载体 | 正式承载（**无私有后端**） | **`course-strength`** | N2.3 + N2.5（数值层） |
| 12 | `unit-theorem` | `𝓞_K^× ≅ μ_K × ℤ^{r₁+r₂−1}` | `Units.exist_unique_eq_mul_prod`（`∃!`）、`fundSystem`、`Units.rank`、`torsion`、`regulator`、`unitLattice`、`logEmbedding` | Mathlib **只有 `∃!`，没有 `≃*`**；`≃*` 必须本库真证（子 Agent 已证 `unitsMulEquiv`） | 正式承载 + 桥 | **`course-strength`（本体）+ `bridge`（同形）** | **N2.11（硬依赖）** + N2.6 |
| 13 | `valuation` | 离散赋值、赋值环、DVR、局部化 | `Valuation`、`ValuationRing`、`IsDiscreteValuationRing`（含 7 项 TFAE） | 见子 Agent FINDINGS | 正式承载 | **`blocked`**（教材门） | — |
| 14 | `padic-completion` | `ℚ_p` 是 `ℚ` 对 p-进绝对值的完备化；`ℤ_p` | `Padic p := CauSeq.Completion.Cauchy (padicNorm p)`、`PadicInt` | 稠密 + 完备 + 范数延拓三件套（无单条完备化定理） | 正式承载；完备化泛性质**缺失** | **`blocked`**（教材门） | — |
| 15 | `local-field-entry` | 局部域；局部—整体入口 | `IsNonarchimedeanLocalField`（**全库零实例**） | 需自建 `ℚ_p` 实例 | 局部—整体对象（adele 等）属**公开泄漏**风险 | **`blocked`** + 独立实现缺口 | — |

---

## 4. 签名冻结提案

> 约定：所有声明置于 `namespace SandronesLibrary.NumberTheory.Algebraic`；每条 docstring 末尾带
> `> **Entry**: <entry-id>`；`omit [...] in` 必须写在 docstring **之前**（原型实测：写在之后会报
> `unexpected token 'omit'; expected 'lemma'`）。

### 4.1 N2.4 `norm-trace` → `SandronesLibrary/NumberTheory/Algebraic/NormTrace.lean`

**命名裁决点（需 Main 定）**：短名 `trace_eq_sum_embeddings` 与 `traceForm_nondegenerate` 在 Mathlib
**根名字空间已存在**（实测 `#check` 命中），原型中曾因此发生自我引用错误。提案采用 `numberField_`
前缀族（与 N2.1 的 `numberField_iff` 风格一致，彻底消除歧义）；备选是保留短名并在文件内一律用
`_root_.` 限定 Mathlib 名。

19 条（已实测编译通过、零 `sorry`，见 `NormTraceFrozen.lean`）：

```lean
variable (K : Type*) [Field K] [NumberField K]

theorem numberField_norm_eq_det_lmul (x : K) :
    Algebra.norm ℚ x = LinearMap.det (Algebra.lmul ℚ K x)
theorem numberField_trace_eq_trace_lmul (x : K) :
    Algebra.trace ℚ K x = LinearMap.trace ℚ K (Algebra.lmul ℚ K x)
theorem numberField_norm_mul (x y : K) :
    Algebra.norm ℚ (x * y) = Algebra.norm ℚ x * Algebra.norm ℚ y
theorem numberField_norm_one : Algebra.norm ℚ (1 : K) = 1
theorem numberField_trace_add (x y : K) :
    Algebra.trace ℚ K (x + y) = Algebra.trace ℚ K x + Algebra.trace ℚ K y
theorem numberField_trace_smul (q : ℚ) (x : K) :
    Algebra.trace ℚ K (q • x) = q • Algebra.trace ℚ K x
theorem numberField_norm_rat (q : ℚ) :
    Algebra.norm ℚ (algebraMap ℚ K q) = q ^ Module.finrank ℚ K
theorem numberField_trace_rat (q : ℚ) :
    Algebra.trace ℚ K (algebraMap ℚ K q) = Module.finrank ℚ K • q
theorem numberField_norm_eq_prod_embeddings (x : K) :
    (Algebra.norm ℚ x : ℂ) = ∏ σ : K →ₐ[ℚ] ℂ, σ x
theorem numberField_trace_eq_sum_embeddings (x : K) :
    (Algebra.trace ℚ K x : ℂ) = ∑ σ : K →ₐ[ℚ] ℂ, σ x
theorem numberField_norm_ne_zero {x : K} (hx : x ≠ 0) : Algebra.norm ℚ x ≠ 0
theorem numberField_norm_eq_zero_iff {x : K} : Algebra.norm ℚ x = 0 ↔ x = 0
theorem numberField_norm_inv (x : K) : Algebra.norm ℚ x⁻¹ = (Algebra.norm ℚ x)⁻¹
theorem numberField_norm_isIntegral {x : K} (hx : IsIntegral ℤ x) :
    IsIntegral ℤ (Algebra.norm ℚ x)
theorem numberField_trace_isIntegral {x : K} (hx : IsIntegral ℤ x) :
    IsIntegral ℤ (Algebra.trace ℚ K x)
theorem numberField_norm_ringOfIntegers_coe (x : 𝓞 K) :
    ((Algebra.norm ℤ x : ℤ) : ℚ) = Algebra.norm ℚ (x : K)
theorem numberField_trace_ringOfIntegers_coe (x : 𝓞 K) :
    ((Algebra.trace ℤ (𝓞 K) x : ℤ) : ℚ) = Algebra.trace ℚ K (x : K)
theorem numberField_trace_surjective : Function.Surjective (Algebra.trace ℚ K)
theorem numberField_traceForm_nondegenerate : (Algebra.traceForm ℚ K).Nondegenerate
```

**未完成边界**：`N(x) = ±1 ⟺ x ∈ 𝓞_K^×` 这条教材常用判据**未进提案**——Mathlib 的
`NumberField.isUnit_norm` 是相对范数形式（`norm K : 𝓞 F →* 𝓞 K`），要落到 `Algebra.norm ℤ x = ±1`
需要 `𝓞 ℚ ≃+* ℤ` 的搬运，本窗未做（列入 §7 待办）。

### 4.2 N2.5 `discriminant` → `.../Discriminant.lean`

8 条（已实测编译通过、零 `sorry`）：

```lean
theorem traceMatrix_apply_eq (b : ι → 𝓞 K) (i j : ι) :
    Algebra.traceMatrix ℤ b i j = Algebra.trace ℤ (𝓞 K) (b i * b j)     -- omit [NumberField K]
theorem discr_eq_traceMatrix_det (b : ι → 𝓞 K) :
    Algebra.discr ℤ b = (Algebra.traceMatrix ℤ b).det                       -- omit [NumberField K]
theorem exists_integralBasis_discr :
    ∃ b : Basis (Fin (Module.finrank ℚ K)) ℤ (𝓞 K), Algebra.discr ℤ b = NumberField.discr K
theorem discr_eq_discr_of_basis (b : Basis ι ℤ (𝓞 K)) :
    Algebra.discr ℤ b = NumberField.discr K
theorem discr_eq_embeddings_det_sq [DecidableEq (K →+* ℂ)] :
    (NumberField.discr K : ℂ) = (NumberField.basisMatrix K).det ^ 2
theorem discr_ne_zero : NumberField.discr K ≠ 0
theorem sign_discr :
    (NumberField.discr K).sign = (-1) ^ NumberField.InfinitePlace.nrComplexPlaces K
theorem discr_rat : NumberField.discr ℚ = 1
```

### 4.3 N2.6 `dedekind` → `.../Dedekind.lean`

5 条（已实测编译通过、零 `sorry`）。**这是本窗最重要的正面判定**：教材三条件可以真组装。

```lean
theorem ringOfIntegers_isNoetherianRing : IsNoetherianRing (𝓞 K)          -- IsNoetherianRing.of_finite ℤ _
omit [NumberField K] in
theorem ringOfIntegers_dimensionLEOne : Ring.DimensionLEOne (𝓞 K)         -- Ring.DimensionLEOne.of_isIntegral ℤ _
theorem ringOfIntegers_isMaximal_of_isPrime {p : Ideal (𝓞 K)} (hp : p.IsPrime) (h : p ≠ ⊥) :
    p.IsMaximal
theorem ringOfIntegers_isDedekindDomain : IsDedekindDomain (𝓞 K)          -- 三条件经 isDedekindDomain_iff 合成
theorem ringOfIntegers_isDedekindDomain_iff :
    IsDedekindDomain (𝓞 K) ↔ IsDomain (𝓞 K) ∧ IsNoetherianRing (𝓞 K) ∧
      Ring.DimensionLEOne (𝓞 K) ∧
      ∀ {x : K}, IsIntegral (𝓞 K) x → ∃ y, algebraMap (𝓞 K) K y = x
```

**精度修正（子 Agent `chain` 发现，负责人已核对 Mathlib 源码 `RingTheory/DedekindDomain/IntegralClosure.lean:220`）**：
`Ring.DimensionLEOne.of_isIntegral` 走的是 **going-up**，与 Mathlib 自身实例
（`IsIntegralClosure.isDedekindDomain`，其结构正是 `isNoetherianRing` + `DimensionLEOne.of_isIntegral`
+ 整闭）**同一条路**。教材的**范数论证**（`𝓞_K/P` 有限 ⟹ 有限整环是域 ⟹ `P` 极大）对应的是另一条
公开路线：`Ring.HasFiniteQuotients.of_module_finite ℤ (𝓞 K)` → `finiteQuotient` →
`Finite.isField_of_domain` → `Ideal.Quotient.maximal_of_isField`（`chain/Dedekind.lean` 的
`ringOfIntegers_prime_isMaximal_via_quotient` 已真证，零 `sorry`）。**Entry docstring 若声称
「复现教材范数论证」，必须选后者，不能挂前者**——两者数学上都对，但论证路线不同。

### 4.4 N2.7 `fractional-ideal` / N2.9 `class-group` → `.../FractionalIdeal.lean`、`.../ClassGroup.lean`

**N2.7 的关键判定**：`IsFractional (𝓞 K)⁰ I := ∃ d ∈ (𝓞 K)⁰, ∀ x ∈ I, IsInteger (𝓞 K) (d • x)`
与教材「`∃ d ≠ 0, dI ⊆ 𝓞_K`」逐字同形（`IsInteger` 就是「落在 `algebraMap` 的像里」）。
**但 Mathlib 的 `FractionalIdeal` 本身只是 `CommMonoidWithZero`，没有群结构**：逆元 `I⁻¹` 是
"`1 / I`"（对不可逆的 `I` 记号有误导性），群公理只在 Dedekind 域上对非零元成立。因此 N2.7 的
「非零分式理想构成群」是**必须自建的桥**，而不是现成引用。

8 条（已实测编译通过、零 `sorry`）：

```lean
variable (K : Type*) [Field K] [NumberField K]

theorem isFractional_iff_exists_ne_zero_smul_subset (I : Submodule (𝓞 K) K) :
    IsFractional (𝓞 K)⁰ I ↔ ∃ d : 𝓞 K, d ≠ 0 ∧ ∀ x ∈ I, IsLocalization.IsInteger (𝓞 K) (d • x)
theorem fractionalIdeal_mem_iff {I : FractionalIdeal (𝓞 K)⁰ K} :
    IsFractional (𝓞 K)⁰ (I : Submodule (𝓞 K) K)
theorem fractionalIdeal_mul_inv_cancel {I : FractionalIdeal (𝓞 K)⁰ K} (hI : I ≠ 0) : I * I⁻¹ = 1
theorem fractionalIdeal_inv_eq_iff {I J : FractionalIdeal (𝓞 K)⁰ K} (h : I * J = 1) : J = I⁻¹
theorem coeIdeal_injective : Function.Injective (fun I : Ideal (𝓞 K) => (I : FractionalIdeal (𝓞 K)⁰ K))
theorem coeIdeal_mul_pow (I J : Ideal (𝓞 K)) (n : ℕ) :
    ((I * J : Ideal (𝓞 K)) : FractionalIdeal (𝓞 K)⁰ K) = (I : _) * (J : _) ∧
      ((I ^ n : Ideal (𝓞 K)) : FractionalIdeal (𝓞 K)⁰ K) = (I : _) ^ n
theorem spanSingleton_mem_iff (x y : K) :
    x ∈ FractionalIdeal.spanSingleton (𝓞 K)⁰ y ↔ ∃ z : 𝓞 K, z • y = x
theorem fractionalIdeal_group_law {I : FractionalIdeal (𝓞 K)⁰ K} (hI : I ≠ 0) :
    I * I⁻¹ = 1 ∧ I⁻¹ * I = 1
```

**N2.9 的关键判定**：Mathlib 的 `ClassGroup R` 定义在**可逆**分式理想的单位群上
（`(FractionalIdeal R⁰ (FractionRing R))ˣ ⧸ principal.range`），教材说的是「全部分式理想商主理想」。
二者在 Dedekind 域上一致，但**需要一条桥**（下条 `fractionalIdeal_isUnit_of_ne_zero`）。
类群**有限性**的陈述可直接用，但证明后端是 Minkowski 界（§4.6），必须披露。

11 条（已实测编译通过、零 `sorry`）：

```lean
theorem classGroup_def : ClassGroup (𝓞 K) =
    ((FractionalIdeal (𝓞 K)⁰ (FractionRing (𝓞 K)))ˣ ⧸ (toPrincipalIdeal (𝓞 K) _).range)
theorem classGroup_mk0_eq_mk0_iff {I J : (Ideal (𝓞 K))⁰} :
    ClassGroup.mk0 I = ClassGroup.mk0 J ↔ ∃ x y : 𝓞 K, x ≠ 0 ∧ y ≠ 0 ∧
      Ideal.span {x} * (I : Ideal (𝓞 K)) = Ideal.span {y} * (J : Ideal (𝓞 K))
theorem classGroup_mk0_eq_one_iff {I : Ideal (𝓞 K)} (hI : I ∈ (Ideal (𝓞 K))⁰) :
    ClassGroup.mk0 ⟨I, hI⟩ = 1 ↔ Submodule.IsPrincipal I
/-- **Wave C 门的关键桥**：Dedekind 域上非零分式理想可逆。 -/
theorem fractionalIdeal_isUnit_of_ne_zero {I : FractionalIdeal (𝓞 K)⁰ K} (hI : I ≠ 0) : IsUnit I
theorem classGroup_finite : Finite (ClassGroup (𝓞 K))
theorem classNumber_def : classNumber K = Fintype.card (ClassGroup (𝓞 K))
theorem classNumber_eq_one_iff : classNumber K = 1 ↔ IsPrincipalIdealRing (𝓞 K)
theorem classNumber_pos : 0 < classNumber K
theorem exists_ideal_in_class_of_norm_le (C : ClassGroup (𝓞 K)) : ∃ I : (Ideal (𝓞 K))⁰,
    ClassGroup.mk0 I = C ∧ Ideal.absNorm (I : Ideal (𝓞 K)) ≤
      (4 / Real.pi) ^ InfinitePlace.nrComplexPlaces K *
        (Nat.factorial (Module.finrank ℚ K) / (Module.finrank ℚ K) ^ (Module.finrank ℚ K) *
          Real.sqrt |(NumberField.discr K : ℝ)|)
noncomputable def classGroup_equiv_quotient :
    ClassGroup (𝓞 K) ≃* (FractionalIdeal (𝓞 K)⁰ K)ˣ ⧸ (toPrincipalIdeal (𝓞 K) K).range
theorem minkowski_lattice_point (I : (FractionalIdeal (𝓞 K)⁰ K)ˣ) : ∃ a ∈ (I : _), a ≠ 0 ∧
    |Algebra.norm ℚ (a : K)| ≤ FractionalIdeal.absNorm I.1 * (4 / Real.pi) ^
      InfinitePlace.nrComplexPlaces K * Nat.factorial (Module.finrank ℚ K) /
      (Module.finrank ℚ K) ^ (Module.finrank ℚ K) * Real.sqrt |(NumberField.discr K : ℝ)|
```

### 4.5 N2.8 `ideal-factorization` → `.../IdealFactorization.lean`

**这是本窗最关键的 `bridge`，且桥已经真证出来（零 `sorry`）**。Mathlib 只给
`Ideal.finprod_heightOneSpectrum_factorization : ∏ᶠ v, v.maxPowDividing I = I`（finprod 形式），
教材要的是「非零理想唯一地写成素理想的有限乘积」。桥的做法：用 `FractionalIdeal.count` 造
`Finsupp`，存在性走 `finprod_heightOneSpectrum_factorization'`，唯一性走
`FractionalIdeal.count_finsuppProd`（一行 `ext v`），再把 ℤ 指数降到 ℕ（`count_coe_nonneg`）。

```lean
variable {R : Type*} [CommRing R] {K : Type*} [Field K] [Algebra R K] [IsFractionRing R K]
variable [IsDedekindDomain R]
abbrev HeightOneSpectrum (R : Type*) [CommRing R] := IsDedekindDomain.HeightOneSpectrum R

theorem exists_count_support_finset (I : FractionalIdeal R⁰ K) :
    ∃ s : Finset (HeightOneSpectrum R), ∀ v, v ∈ s ↔ FractionalIdeal.count K v I ≠ 0
theorem fractionalIdeal_finsupp_factorization_unique {e e' : HeightOneSpectrum R →₀ ℤ}
    {I : FractionalIdeal R⁰ K} (hI : I ≠ 0)
    (he : e.prod (fun v n => (v.asIdeal : FractionalIdeal R⁰ K) ^ n) = I)
    (he' : e'.prod (fun v n => (v.asIdeal : FractionalIdeal R⁰ K) ^ n) = I) : e = e'
theorem fractionalIdeal_finsupp_factorization_exists (I : FractionalIdeal R⁰ K) (hI : I ≠ 0) :
    ∃ e : HeightOneSpectrum R →₀ ℤ, e.prod (fun v n => (v.asIdeal : FractionalIdeal R⁰ K) ^ n) = I
theorem fractionalIdeal_finsupp_factorization_existsUnique (I : FractionalIdeal R⁰ K) (hI : I ≠ 0) :
    ∃! e : HeightOneSpectrum R →₀ ℤ, e.prod (fun v n => (v.asIdeal : FractionalIdeal R⁰ K) ^ n) = I
theorem coeIdeal_finset_prod (e : HeightOneSpectrum R →₀ ℕ) :
    ((∏ v ∈ e.support, v.asIdeal ^ e v : Ideal R) : FractionalIdeal R⁰ K) =
      ∏ v ∈ e.support, (v.asIdeal : FractionalIdeal R⁰ K) ^ (e v : ℤ)
theorem coeIdeal_finsupp_prod (e : HeightOneSpectrum R →₀ ℕ) :
    ((e.prod fun v n => v.asIdeal ^ n : Ideal R) : FractionalIdeal R⁰ K) =
      (e.mapRange (fun n : ℕ => (n : ℤ)) (by simp)).prod (fun v n => (v.asIdeal : _) ^ n)
/-- **教材同形：非零理想的素理想幂乘积存在唯一分解。** -/
theorem ideal_finsupp_factorization_existsUnique (I : Ideal R) (hI : I ≠ 0) :
    ∃! e : HeightOneSpectrum R →₀ ℕ, e.prod (fun v n => v.asIdeal ^ n) = I
/-- 与负责人候选签名逐字同形的版本（`Finsupp.prod` 展开、等式反向）。 -/
theorem ideal_factorization_frozen_signature (I : Ideal R) (hI : I ≠ 0) :
    ∃! f : HeightOneSpectrum R →₀ ℕ, I = ∏ v ∈ f.support, v.asIdeal ^ f v
/-- Finset 版本：互异素理想 + 正指数。 -/
theorem ideal_finset_factorization_exists (I : Ideal R) (hI : I ≠ 0) :
    ∃ (s : Finset (HeightOneSpectrum R)) (e : HeightOneSpectrum R → ℕ),
      (∀ v ∈ s, 0 < e v) ∧ (∀ v ∈ s, v.asIdeal.IsPrime) ∧ ∏ v ∈ s, v.asIdeal ^ e v = I
```

### 4.6 N2.10 `prime-decomposition` / N2.11 `minkowski` / N2.12 `unit-theorem`

> 这三条来自子 Agent `geom` 的原型，**负责人已独立复跑三个文件（exit 0、零 `sorry`）**，
> 并对六条关键 `#check` 事实逐条复核（含 deprecated import 与实例坑）。完整签名与
> `#check` 原文见其 FINDINGS（`/tmp/sandrones-library/geom/FINDINGS.md`）；此处只列冻结签名要点。

**N2.10**（13 条）：本库自建两个定义（Mathlib **没有** `Ideal.IsRamified`，只有
`NumberField.not_dvd_discr_iff_isUnramifiedIn` 的否定形式）：

```lean
def IsRamifiedAt (p : Ideal ℤ) (P : Ideal (𝓞 K)) : Prop := P.LiesOver p ∧ P.ramificationIdx ℤ ≠ 1
def IsRamifiedIn (p : ℤ) : Prop := ¬ Algebra.IsUnramifiedIn (𝓞 K) (Ideal.span {p})
theorem sum_ramification_inertia_eq_finrank {p : Ideal ℤ} [p.IsMaximal] :
    ∑ q : p.primesOver (𝓞 K), q.1.ramificationIdx ℤ * q.1.inertiaDeg ℤ = Module.finrank ℚ K
theorem dvd_discr_iff_isRamifiedIn {p : ℤ} (hp : Prime p) : p ∣ NumberField.discr K ↔ IsRamifiedIn K p
theorem isUnramifiedIn_iff_forall_ramificationIdx_eq_one {p : Ideal ℤ} :
    Algebra.IsUnramifiedIn (𝓞 K) p ↔ ∀ P, P.IsPrime → P.LiesOver p → P.ramificationIdx ℤ = 1
noncomputable def kummerDedekind_primesOver_equiv_monicFactorsMod {θ : 𝓞 K} {p : ℕ}
    [Fact (Nat.Prime p)] (hp : ¬ p ∣ RingOfIntegers.exponent θ) :
    ((Ideal.span {(p : ℤ)}).primesOver (𝓞 K)) ≃ RingOfIntegers.monicFactorsMod θ p
-- 另有 ramificationIdx_eq_length_localization / inertiaDeg_eq_finrank_residueField /
-- ramificationIdx_eq_one_iff_unramified / dvd_discr_iff_exists_ramificationIdx_ne_one /
-- natPrime_dvd_discr_iff_isRamifiedIn / kummerDedekind_{inertiaDeg,ramificationIdx}_*
```

**N2.11**（13 条）：`minkowskiBound` 是公开 def，凸体定理是公开定理，**无私有后端**：

```lean
theorem mixedEmbedding_finrank : Module.finrank ℝ (mixedSpace K) = Module.finrank ℚ K
theorem nrRealPlaces_add_two_mul_nrComplexPlaces :
    nrRealPlaces K + 2 * nrComplexPlaces K = Module.finrank ℚ K
theorem norm_mixedEmbedding_eq_abs_norm (x : K) :
    mixedEmbedding.norm (mixedEmbedding K x) = |Algebra.norm ℚ x|
theorem minkowski_convex_body_measure ... (h : μ F * 2 ^ Module.finrank ℝ E < μ s) : ∃ x ≠ 0, ((x : L) : E) ∈ s
theorem exists_ne_zero_norm_le_minkowski : ∃ a : 𝓞 K, a ≠ 0 ∧
    |Algebra.norm ℚ (a : K)| ≤ (4 / Real.pi) ^ nrComplexPlaces K *
      (Module.finrank ℚ K).factorial / (Module.finrank ℚ K) ^ (Module.finrank ℚ K) *
        √|(NumberField.discr K : ℝ)|
theorem abs_discr_gt_two (h : 1 < Module.finrank ℚ K) : 2 < |NumberField.discr K|   -- Hermite–Minkowski
theorem exists_ideal_in_class_of_norm_le (C : ClassGroup (𝓞 K)) : ...   -- 上层使用者（接 N2.9）
```

**N2.12**（20 条）：Mathlib 只有 `∃!`，教材的 `≃*` 必须自建（**子 Agent 已真证 `map_mul'`**）：

```lean
theorem rank_eq_nrRealPlaces_add_nrComplexPlaces_sub_one : rank K = nrRealPlaces K + nrComplexPlaces K - 1
theorem torsion_isCyclic : IsCyclic (torsion K)
theorem logEmbedding_ker_eq_torsion : (logEmbedding K).ker = (torsion K).toAddSubgroup
theorem existsUnique_eq_mul_prod (x : (𝓞 K)ˣ) : ∃! ζe : torsion K × (Fin (rank K) → ℤ),
    x = ζe.1 * ∏ i, fundSystem K i ^ (ζe.2 i)
noncomputable def unitDecomp (x : (𝓞 K)ˣ) : torsion K × (Fin (rank K) → ℤ)
noncomputable def unitsEquiv : (𝓞 K)ˣ ≃ torsion K × (Fin (rank K) → ℤ)
/-- 教材同形：`𝓞_K^× ≅ μ_K × ℤ^{r₁+r₂-1}`。 -/
noncomputable def unitsMulEquiv : (𝓞 K)ˣ ≃* torsion K × Multiplicative (Fin (rank K) → ℤ)
theorem regulator_eq_det (w' : InfinitePlace K) (e : {w // w ≠ w'} ≃ Fin (rank K)) : ...
theorem exists_unit_neg_log (w₁ : InfinitePlace K) :
    ∃ u : (𝓞 K)ˣ, ∀ w, w ≠ w₁ → Real.log (w (u : K)) < 0
theorem unitLattice_span_eq_top : Submodule.span ℝ (unitLattice K : Set (logSpace K)) = ⊤
```

**实测接口坑（写进 Entry 文档，否则后来者必踩）**：

1. `Mathlib.NumberTheory.RamificationInertia.Basic` **已 deprecated**（编译器警告：改用
   `LinearAlgebra.Dimension.DivisionRing` + `NumberTheory.RamificationInertia.{Inertia,Ramification}`
   + `RingTheory.Ideal.Norm.AbsNorm`）；`Ideal.sum_ramification_inertia` 等旧名同批废弃。
2. `Fintype (p.primesOver (𝓞 K))` 的实例 `IsDedekindDomain.instFintypeElemIdealPrimesOver`
   要求 **`p.IsMaximal`**（不是 `p.IsPrime`），且是 `noncomputable`。
3. `Module ℤ (Additive ((𝓞 K)ˣ ⧸ torsion K))` 在导入方文件里 `inferInstance` 合成不出来，
   必须显式给 `AddCommGroup.toIntModule`。
4. `IsZLattice ℝ (unitLattice K)` 与 `logSpace` 的范数实例需要 **`open scoped Classical`**；
   `𝓞`（`open NumberField`）、`⁰`（`open scoped nonZeroDivisors`）都是 scoped notation。
5. `≃` 不是 `Prop`：重索引桥必须写 `noncomputable def`，写成 `theorem` 会报
   "type of theorem ... is not a proposition"。
6. `NumberField.Units.regulator` 在 `Units/Regulator.lean`，`DirichletTheorem` 不导入它。

### 4.7 N2.13–N2.15：`blocked`（教材门），不提议签名冻结

三条**全部被教材门挡住**，本窗只做侦察，不冻结公开签名（冻结了也不能开工，反而制造假进度）。
门依据（已核对原文）：`docs/ROADMAP-LONGTERM.md` 行 1453 把 `N2.13–N2.15` 与 `N3.7–N3.12`
同列 `research_open；补指定专题教材前不得正式开发`；行 1451 把 Ireland–Rosen 段止于 N2.12；
行 1455–1456 点名「不能从 Mathlib 已有 `Padic`…直接倒推一门局部域课程」；`reference.bib` 73 条
无任何局部域/p-进教材。

侦察结论（供门解除后使用，详见 `local` worker 的 FINDINGS）：

- **`LocalField` 在 Mathlib 不存在**（pack 的候选提示名错误）：真名 `IsNonarchimedeanLocalField`，
  且**全库零实例**——`example : IsNonarchimedeanLocalField ℚ_[p] := inferInstance` 合成失败。
  超类（`IsValuativeRel`/`IsNontrivial`/`IsRankLeOne`/`ProperSpace`/`CompleteSpace`/`IsUltrametricDist`）
  齐备；`IsDiscreteValuationRing ℤ_[p]`、`CompactSpace ℤ_[p]`、`CompleteSpace ℚ_[p]` 已由负责人复跑确认。
- `Padic p := CauSeq.Completion.Cauchy (padicNorm p)` 是**构造**；「`ℚ_p` 是 `ℚ` 对 p-进绝对值的
  完备化」**没有单条定理**，只有稠密 + 完备 + 范数延拓三件套。
- **公开泄漏风险**：`NumberField.AdeleRing`、`FiniteAdeleRing`、乘积公式、`Height.AdmissibleAbsValues`
  属研究生层级；Mathlib 无 idele 环，登记 adele 只给半条链。建议「局部—整体」另立条目并先补教材。

---

## 5. 接口契约

1. **模块与导入**：每个 Entry 一个文件，只 import Mathlib 模块与**直接前置**的 N2 文件；
   不 import `SandronesLibrary.lean` 聚合文件（避免循环）。
2. **命名空间**：本窗三个子 Agent 的提案里，`geom` 用了每文件子命名空间
   （`.PrimeDecomposition` / `.Minkowski` / `.UnitTheorem`），`chain` 用了 N2.1–N2.3 的扁平
   `SandronesLibrary.NumberTheory.Algebraic`。**建议统一用扁平命名空间**（与已集成三条一致；
   改成子命名空间等于对 N2.1–N2.3 做 M2 迁移，超出本窗范围），请 Main 裁决。
3. **命名**：与 Mathlib 根名冲突的短名一律加 `numberField_` 前缀（§4.1 实测依据）；其余沿用
   `<对象>_<性质>` 风格（N2.1–N2.3 已确立）。
4. **`omit` 约定**：`omit [NumberField K] in` 写在 docstring **之前**；只用到 `[Field K]` 的声明
   （如 `ringOfIntegers_dimensionLEOne`、`traceMatrix_apply_eq`）必须 omit，否则 linter 会重放 warning。
5. **`noncomputable` 约定**：`ClassGroup` 的 `Fintype` 实例、`primesOver` 的 `Fintype` 实例、
   `≃` 型桥（`classGroup_equiv_quotient`、`unitsEquiv`、`unitsMulEquiv`）都必须标 `noncomputable`；
   写成 `theorem` 会报 "type of theorem ... is not a proposition"。
6. **import 路径**：`Mathlib.NumberTheory.RamificationInertia.Basic` **已 deprecated**，
   N2.10 必须改用 `LinearAlgebra.Dimension.DivisionRing` + `NumberTheory.RamificationInertia.{Inertia,Ramification}`
   + `RingTheory.Ideal.Norm.AbsNorm`；`NumberField.Units.regulator` 必须 import `Units.Regulator`。
7. **scoped notation 约定**：`open NumberField`（`𝓞`）、`open scoped nonZeroDivisors`（`⁰`）、
   `open scoped Classical`（`logSpace` 的范数实例、`mixedSpace` 的测度、`DecidableEq` 相关合成）
   必须在文件头写全，否则报 `autoImplicit`／`GetElem` 之类难读错误。
8. **docstring**：每条声明带中文教材解释 + `> **Entry**: <id>`；首次出现的概念必须按 AGENTS §4
   六项说明（教材定义／Lean 承载／展开刻画／Mathlib 角色／上层使用者／边界）。
9. **公开签名四类扫描**：`ℂ`、`IsAlgClosed`、`HeightOneSpectrum`、`FractionalIdeal`、`ClassGroup`
   等必须在文件头声明归属；**adele／idele／乘积公式**不得进入公开签名（§7）。
10. **trace 义务**：开发窗每个 Lean 尝试写 `traces/lean/number-theory/<entry-id>.jsonl`，
    带该批次 pack 的 `pack_id`。
11. **前置闭包**（按 §2 实测依赖，不按编号）：N2.4 ← `ring-of-integers`；N2.5 ← `norm-trace`；
    N2.6 ← `ring-of-integers`；N2.7 ← `dedekind`；N2.8 ← `fractional-ideal`；N2.9 ← `fractional-ideal`（定义层）
    / `minkowski`（有限性层）；N2.10 ← `dedekind`（+ `discriminant`）；N2.11 ← `discriminant`；
    N2.12 ← `minkowski`。

---

## 6. /tmp 原型与 trace

> 全部原型都在 `/tmp`（研究窗产物，**不进 `SandronesLibrary/`**）。下表「编译」一列是**负责人
> 亲自复跑**的结果（`lake env lean <文件>`），不是采信子 Agent 的自述。

### 6.1 原型清单

| 归属 | 文件 | 条目 | 声明数 | `sorry` | 负责人复跑 |
|---|---|---|---|---|---|
| 负责人 | `normtrace/NormTrace.lean` | N2.4 | 19 | 0 | exit 0 |
| 负责人 | `normtrace/NormTraceFrozen.lean` | N2.4（`numberField_` 前缀冻结版） | 19 | 0 | exit 0 |
| 负责人 | `normtrace/AxiomProbe.lean` | N2.4 公理画像 | — | 0 | exit 0（19/19 = `propext, Classical.choice, Quot.sound`） |
| 负责人 | `normtrace/Discriminant.lean` | N2.5 | 8 | 0 | exit 0 |
| 负责人 | `normtrace/DedekindAssembly.lean` | N2.6 | 5 | 0 | exit 0 |
| 负责人 | `normtrace/ProbeA–P.lean` | 侦察探针（含失败轮） | — | 见 §6.2 | 见 trace |
| `chain` | `chain/Dedekind.lean` | N2.6 | 9 | 0 | exit 0 |
| `chain` | `chain/DedekindCrossCheck.lean` | N2.6（交叉核对） | — | 0 | exit 0 |
| `chain` | `chain/FractionalIdeal.lean` | N2.7 | 8 | 0 | exit 0 |
| `chain` | `chain/IdealFactorization.lean` | N2.8 | 10 | 0 | exit 0 |
| `chain` | `chain/ClassGroup.lean` | N2.9 | 11 | 0 | exit 0 |
| `geom` | `geom/PrimeDecomposition.lean` | N2.10 | 13 | 0 | exit 0 |
| `geom` | `geom/Minkowski.lean` | N2.11 | 13 | 0 | exit 0 |
| `geom` | `geom/UnitTheorem.lean` | N2.12 | 20 | 0 | exit 0 |
| `local` | `local/Valuation.lean` | N2.13（门后草案） | 8 | 0 | exit 0 |
| `local` | `local/PadicCompletion.lean` | N2.14（门后草案） | 15 | 0 | exit 0 |
| `local` | `local/LocalFieldEntry.lean` | N2.15（门后草案，条件式） | 10 | 0 | exit 0 |

### 6.2 `sorry` 清单

**所有正式原型零 `sorry`**：负责人对**全部 14 个原型文件逐个复跑** `lake env lean`，均 exit 0；
`grep -E '\bsorry\b|admit|native_decide'` 在 14 个文件里只命中 `local/Valuation.lean` 第 8 行
**注释里的「无 sorry」字样**，无真实占位。仓库内**没有任何** `sorry`／`admit`／`sorryAx`／
`native_decide` 落盘（研究窗的仓库交付物只有 trace、pack、本 RFC 与 handoff）。

唯一的 `sorry` 出现在负责人的**签名可达性探针** `normtrace/ProbeI.lean`（2 条，只为验证
N2.8 桥的陈述能否通过类型检查）。**它们等待的东西已经不需要再等**：子 Agent `chain` 在
`chain/IdealFactorization.lean` 里把同一陈述真证出来了（`ideal_finsupp_factorization_existsUnique`
与 `ideal_factorization_frozen_signature`，零 `sorry`），等的是 `FractionalIdeal.count` 的有限支撑
与 `count_finsuppProd` 唯一性引擎——现已落地为原型。

### 6.3 pack 与 trace 清单

| 角色 | pack_id | trace 路径 | 记录数 |
|---|---|---|---|
| 负责人 | `number-theory-N2res-number-theory.algebraic.norm-trace` | `traces/lean/number-theory/number-theory.algebraic.norm-trace.jsonl` | 21 |
| 子 Agent `chain`（N2.6–N2.9） | `number-theory-N2res-number-theory.algebraic.dedekind-chain` | `traces/lean/number-theory/number-theory.algebraic.dedekind-chain.jsonl` | 13（accepted 9 / error 4） |
| 子 Agent `geom`（N2.10–N2.12） | `number-theory-N2res-number-theory.algebraic.prime-decomposition-geom` | `traces/lean/number-theory/number-theory.algebraic.prime-decomposition-geom.jsonl` | 17 |
| 子 Agent `local`（N2.13–N2.15） | `number-theory-N2res-number-theory.algebraic.valuation-local` | `traces/lean/number-theory/number-theory.algebraic.valuation-local.jsonl` | 16 |

**`chain` 的 trace 缺口（已披露，未重建）**：该 worker 在 11:07–12:06 之间约 **16 轮**原型编译
未实时留痕（ProbeB/C、`Dedekind` 2 轮、`FractionalIdeal` 3 轮、**`IdealFactorization` 7 轮**、
`ClassGroup` 4 轮），原因是把「立即 append」误执行成攒批。负责人 11:34 去信要求整改，此后
该 worker 改用「编译 + 立即 append」一体化脚本（`/tmp/sandrones-library/chain/trace_run.py`），
第 7–13 条即该机制产物（含一条真实失败）。按 Playbook §8.2「不许事后补写」，本窗**不补造**
这些记录，只在此披露缺口范围；缺口清单已写进 `chain/FINDINGS.md` §0（附 mtime 证据）。

---

## 7. 诚实边界

1. **本窗无 Lean 交付**：所有原型在 `/tmp`，仓库内只有 trace、pack、本 RFC 与 handoff。
2. **哪些只是「换个名字的包装」**：N2.4 的 `numberField_norm_eq_prod_embeddings`、
   `numberField_trace_eq_sum_embeddings` 在证明上就是 Mathlib 定理加一层 `algebraMap ℚ ℂ` 的
   cast 记账；它们进提案的理由是**概念冻结与教材量词对齐**，不是新数学。N2.5 的
   `discr_eq_discr_of_basis`、`discr_ne_zero` 同理。Main 若认为定义层不需要这类条目，可只保留
   定义展开与真组装项（N2.6）。
3. **哪些证明链没有复现**（`chain` worker 列的 5 条，负责人复核后采纳）：
   `IsIntegralClosure.isNoetherianRing`（迹形式／对偶基）、`Ring.DimensionLEOne.of_isIntegral`
   （going-up）、用 `absNorm` 数商环、**Minkowski 格点／凸体定理**、`Ideal.uniqueFactorizationMonoid`
   的构造。因此 N2.9 的**类群有限性**只能 `foundation`／`bridge`，`course-strength` 应留给 N2.11。
   N2.6 例外：教材三条件（Noetherian／维数 ≤ 1／整闭）**可以**真组装（`DedekindAssembly.lean`
   与 `chain/Dedekind.lean` 两条独立路线都编译通过）；且教材**范数论证**有独立公开路线
   （`Ring.HasFiniteQuotients` 系），见 §4.3 的精度修正。
4. **哪些是真工作（不是转述）**：N2.8 的 `ideal_finsupp_factorization_existsUnique`（教材形式与
   Mathlib 的 finprod 形式不同形，桥要真证）；N2.9 的 `fractionalIdeal_isUnit_of_ne_zero`
   （教材「全部分式理想」与 Mathlib「可逆分式理想」的桥）；N2.12 的 `unitsMulEquiv`
   （Mathlib 只有 `∃!`，`≃*` 的 `map_mul'` 有实质内容）；N2.7 的
   `isFractional_iff_exists_ne_zero_smul_subset`（定义展开）。
5. **哪些只是「换个名字的包装」**：N2.4 的 `numberField_norm_eq_prod_embeddings`、
   `numberField_trace_eq_sum_embeddings` 在证明上就是 Mathlib 定理加一层 `algebraMap ℚ ℂ` 的
   cast 记账；它们进提案的理由是**概念冻结与教材量词对齐**，不是新数学。N2.5 的
   `discr_eq_discr_of_basis`、`discr_ne_zero`、N2.12 的 `rank_eq_..._sub_one` 同理。Main 若认为
   定义层不需要这类条目，可只保留定义展开与真桥（N2.6/N2.8/N2.9/N2.12 的桥项）。
6. **`Classical.choice` 画像**：N2.4 原型 19/19 条依赖 `[propext, Classical.choice, Quot.sound]`
   （ℂ/嵌入路线的结构性底线，Playbook §3.3），无 `sorryAx`；本窗**未做 choice 最小化**，
   其余原型也未逐条做公理画像（研究窗不做集成前的公理审计）。
7. **N2.13–N2.15 被教材门挡住**：ROADMAP §11 行 1453 明列 `research_open；补指定专题教材前不得
   正式开发`；行 1451 把 Ireland–Rosen 段止于 N2.12；行 1455–1456 点名禁止从 Mathlib `Padic`
   倒推课程；`reference.bib` 无局部域/p-进教材。**本窗不提议开工**。
8. **公开泄漏风险**：`NumberField.AdeleRing`、`FiniteAdeleRing`、乘积公式、`Height.AdmissibleAbsValues`
   属研究生层级；Mathlib 无 idele 环，登记 adele 只给半条链。N2.15 若要做，只做局部域本体的
   条件式陈述，「局部—整体」另立条目并先补教材。
9. **`∑ eᵢfᵢ` 的适用范围**：`Ideal.sum_ramification_inertia_eq_finrank` 的 `Fintype (primesOver)`
   实例要求 `p.IsMaximal`，因此本库桥**只对有理素数（极大理想）成立**，对一般素理想（含 `⊥`）无覆盖。
10. **未验证项**：本窗未验证 `disc ≡ 0,1 (mod 4)`、`𝓞_K^×` 的 `±1` 判据、类数计算可行性、
    Ireland–Rosen 的具体章节号等教材细节；它们不在本 RFC 的判定依据里。
11. **验证强度**：全部原型只跑 `lake env lean <单文件>`，**未跑 `lake build`**（本窗禁止），
    不等于可集成、不等于全库通过、不等于已通过 `subject_package` 五门（研究窗无五门）。

---

## 8. 给 Main 的裁决请求与协议反馈

**裁决请求**

1. **命名**：N2.4 采用 `numberField_` 前缀族，还是保留短名 + `_root_.` 限定？
2. **命名空间**：新文件统一用扁平 `SandronesLibrary.NumberTheory.Algebraic`（与 N2.1–N2.3 一致），
   还是每 Entry 一个子命名空间（`geom` 的提案）？后者等于对已集成三条做 M2 迁移。
3. **N2.6 强度**：本窗实测「教材三条件 → `IsDedekindDomain`」可组装，是否把 N2.6 从
   `foundation` 升为 `course-strength` 并据此解锁 N2.7–N2.9 的开发窗？
4. **N2.8 桥**：是否接受把「非零理想唯一分解」的公开形式冻结为
   `∃! e : HeightOneSpectrum R →₀ ℕ, e.prod (fun v n => v.asIdeal ^ n) = I`（已真证，零 `sorry`）？
5. **N2.9 拆分**：是否接受把 N2.9 拆成「定义层（N2.7 后）」与「有限性层（N2.11 后）」两次交付
   （因为类群有限性走 Minkowski 界，编号顺序与依赖顺序不一致）？
6. **N2.13 归属**：`Atiyah–Macdonald` 第 9 章含 DVR/Dedekind，但 ROADMAP §13.1 的 CA1–CA6 表
   未登记任何 DVR/赋值条目——N2.13 继续冻结，还是定向改挂交换代数线？属 Main 裁决。
7. **批次切分**：是否采纳 §2 的三批次切分（A：N2.4–5；B：N2.6–9；C：N2.10–12，其中 N2.10 可并行）？

**协议反馈**

1. **pack 的 `scope` 与 `goal_nl` 自相矛盾**：研究窗要覆盖 N2.4–N2.15，但 `scope.in_scope` 只由
   `--entry` 单值决定、`out_of_scope` 又按 family 前缀把所有同族条目列为「本批不做」。建议
   `context_pack.py` 支持研究窗的 `--covers <entry,entry,...>`，让 `in_scope` 能表达窗口真实范围。
2. **`prerequisites.mathlib` 是未验证提示**：子 Agent `local` 首轮就因 pack 里的 `LocalField`
   这个**不存在**的名字白烧一轮（真名 `IsNonarchimedeanLocalField`）。建议计划模式下对候选名做
   `#check` 存在性预检，或至少把 `unverified_hint` 标到每个名字上。
3. **trace `outcome` 粒度**：一个探针文件里 22 条 `#check` 有 1 条失败就必须记 `error`，丢失了
   「20/22 命中」的信息。建议允许 `ok_count`/`total` 或 `accepted_with_errors`。
4. **`lean_trace.py` 子命令接口不一致**：`check` 接位置参数，`summary` 只接 `--subject/--root`。
5. **子 Agent 就地更正 trace**：`local` worker 第 8 条曾把 import 拼错后原地更正并披露；建议在
   schema 里给一个 `amended: true` 字段，比事后在 `next_step` 里口头说明更可审计。
6. **「边做边写」需要可观测的强制点**：`chain` worker 在负责人去信前有近 50 分钟无 trace
   （而 `/tmp` 原型文件在持续变动）。建议 `subject_package`／窗口验收把「原型文件 mtime 晚于
   最后一条 trace」列为**软警告**，让负责人不必靠人工巡检发现。
7. **研究窗没有五门，但也没有轻量自检**：`subject_package.py` 对研究窗不适用（无 Lean 交付），
   于是「trace 与 pack 的 join key 是否闭合」「原型是否零 sorry」只能人工核对。建议给研究窗一个
   `--research` 模式的只读自检（trace 计数 + pack_id 闭合 + 原型 `sorry` 扫描）。
8. **module 系统的 `public` 标记**：`IsDedekindDomainInv`、`isDedekindDomain_iff_isDedekindDomainInv`
   在源码里可见，但未标 `public` → 外部文件 `#check` 报 `Unknown identifier`；匿名实例
   （`Ideal.fintypeSubtypeDvd`、`Ring.HasFiniteQuotients.instOfIsDomainOfFG`）同病。建议进 Playbook
   的「侦察类尝试」清单：**源码可见 ≠ 可引用**。
9. **两个 Lean 陷阱（`chain` worker 各踩 2 次）**：(a) `∃!` 的分量目标是 β-redex，`rw` 找不到模式，
   必须先 `show`；(b) `rw [← finprod_…]` 当待改写项的定义体内出现同名自由变量时报
   `motive is not type correct`，须先证不含该变量的中间等式再 `trans`。建议收进 Playbook §2/§5。
10. **trace 义务的可执行化**：`chain` worker 自建了「编译 + 立即 append」一体化脚本
    （`trace_run.py`，自动判定 outcome），这是把 §8.2「边做边写」从纪律变成机械动作的正确方向，
    建议 Playbook §8.5 收录该模式（本窗的 trace 缺口正是靠人工纪律失败造成的）。

---

## Main 裁决（2026-10-14，Main 侧记录；本窗已结束，裁决供下一批开工使用）

窗口提出 7 项待裁，逐条裁决如下。**这些裁决在下一批 pack 生成前生效**，负责人开工时按此执行；
如现场证据与之冲突，按 AGENTS §8 报 Main，不得自行改口径。

1. **N2.4 命名 —— 采用「扁平命名空间 + 同名消歧前缀」**。库内声明一律落在
   `SandronesLibrary.NumberTheory.Algebraic`（与 N2.1–N2.3 一致），**禁止把声明写到根命名空间**。
   与 Mathlib 根名**字面相同**的两条（`trace_eq_sum_embeddings`、`traceForm_nondegenerate`）
   加 `numberField_` 前缀消歧——理由是教材读者会在同一段文字里同时看到 Mathlib 根名与本库条目名，
   同名会让"谁是正式承载"在阅读层就失效。其余 17 条不加前缀。不得用 `_root_.` 限定把本库名字
   注入根命名空间。
2. **命名空间 —— 扁平，不做每 Entry 子命名空间**。`geom` 的子命名空间提案会把已集成的 N2.1–N2.3
   推成一次 M2 迁移，而收益只是名字好看；按 AGENTS §10，M2 需要影响图 + RFC + 三阶段回滚，
   不值得为一个纯审美理由启动。文件内可用 `section` 组织，但 `section` 不构成全名。
3. **N2.6 升为 course-strength，并据此解锁 N2.7–N2.9 开发窗 —— 准**。窗口用
   `IsNoetherianRing.of_finite` + `Ring.DimensionLEOne.of_isIntegral` +
   `IsIntegrallyClosed.algebraMap_eq_of_integral` **真组装**出与教材三条件逐字同形的右端，
   且另证了教材范数论证对应的 `Ring.HasFiniteQuotients` 路线。两条路线都要在 Entry 文档里写明，
   **不得只写一条**：`of_isIntegral` 走 going-up，与教材范数论证不是同一条证明。
4. **N2.8 桥签名冻结 —— 准**，冻结为
   `∃! e : HeightOneSpectrum R →₀ ℕ, e.prod (fun v n => v.asIdeal ^ n) = I`。
   该形式已零 `sorry` 真证（唯一性引擎 `FractionalIdeal.count_finsuppProd`），与教材写法逐字对应。
   **同时确认窗口的修正**：N2.8 的 Lean 前置只需 N2.6，不需要 N2.7 的 Entry——Wave C 的门是
   **登记顺序约束**而非 Lean 依赖，Entry 文档必须把这个区别写清楚，不得暗示"N2.7 是 N2.8 的数学前置"。
5. **N2.9 拆两次交付 —— 准**。定义层随 N2.7 之后交付；有限性层必须等 N2.11。
   理由是窗口已如实披露：`IsIntegralClosure.isNoetherianRing`（迹形式／对偶基）、
   `DimensionLEOne.of_isIntegral`（going-up）、Minkowski 格点／凸体定理、
   `Ideal.uniqueFactorizationMonoid` 构造四条链**未复现**，故类群有限性当前只能
   foundation／bridge，**course-strength 留给 N2.11**。不得把 foundation 写成教材定理。
6. **N2.13–N2.15 继续冻结 —— 准，不改挂交换代数线**。三条 ROADMAP 明文（行 1453「补指定专题
   教材前不得正式开发」、行 1451 Ireland–Rosen 止于 N2.12、行 1455–1456 点名禁止从 `Padic`
   倒推课程）都在生效；`reference.bib` 73 条**无局部域教材**。窗口实测的两条事实一并记账：
   **`LocalField` 在 Mathlib 不存在**（真名 `IsNonarchimedeanLocalField`，且全库零实例）、
   `Padic p` 是构造而「ℚ_p 是完备化」无单条定理。改挂 CA 线需要先在 ROADMAP §13.1 登记
   DVR／赋值条目并补教材，属独立的路线决策，**不在本窗裁决范围**。
7. **批次切分 —— 准，并按窗口自己的修正调整依赖**：
   - **A = N2.4–N2.5**（可立即开）；
   - **B = N2.6 → N2.7 → N2.9 定义层 → N2.8**（Wave C 登记门在 N2.8 前）；
   - **C = N2.11 → N2.12**；
   - **N2.10 与 B 并行**（其前置是 N2.3 + N2.6，**不是 N2.8**）；
   - **N2.9 有限性层排在 N2.11 之后**。
   窗口修正的「依赖顺序 ≠ 编号顺序」采纳：**N2.9 类群有限性是 N2.11 的下游**，不是 N2.10–N2.12
   的前置；RFC 初稿的依赖图已由窗口自行改正，以 RFC 现行版本为准。

### 附：本窗协议反馈的处置

- **`LocalField` 错名**——这是 pack 候选未验证的又一例，与 `24f9e30` 的 13/42 同类；
  `open_window.py` 的 `#check` 门禁已覆盖开窗路径，本窗是负责人手写候选，**未走门禁**。
  下一批若仍手写候选，负责人须自行 `#check` 后再写进 pack。
- **`chain` worker 的 16 轮 trace 缺口**——窗口**未事后补造**，并附 mtime 清单，处置正确：
  缺口如实披露优于补造。其自建的 `trace_run.py`（编译 + 立即 append）是把 §8.2 从纪律变成
  机械动作的正确方向，**建议在下一批推广**，Playbook §8 收录留待该模式复现一次后再固化。
- **`subject_package` 在无 Lean 变更时给出空真 `pass`**——窗口主动指出「不得当作验收结论」，
  判断正确。这确实是一个工具缺陷（`pass` 与 `not_applicable` 语义不同），列入 Main 侧工具待修项。
