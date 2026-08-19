# Sandrone's Library — 数学分析学习地图（一年级主线）

> **视角**：刚入学的数学系大一新生。mathlib 是看不懂的百科全书，
> 我们要把"大一读得懂的数学分析"逐条纳入知识库。
> 这份地图是纳入顺序的路线图，也是库骨架的组织蓝图。
>
> **多版本策略**：每个结论默认两个变体——
> `mathlib-formal`（非人话形式化版，直接复用 mathlib）+ 至少一本教材的人话版。
> 教材作为独立变体，用调用量决定谁更有价值。

## 教材参照（人话版候选）

| 代号 | 教材 | 特点 |
|---|---|---|
| `ecnu` | 华东师范大学《数学分析》(第五版) | **✅ 主参照**：国内经典，体系平稳，起点友好 |
| `chen` | 陈纪修/於崇华/金路《数学分析》 | 严谨细致，适合自学（候选变体） |
| `zorich` | 卓里奇《数学分析原理》 | 更抽象、更接近现代分析（候选变体） |
| `rudin` | Rudin《Principles of Mathematical Analysis》 | 英文经典，分析学圣经（候选变体） |

> 人话版条目默认带 `variant: ecnu`，其余教材作为后续追加变体。

> 未定：以哪本为主参照（影响变体标签与首批纳入顺序）。

## 第一章 集合与映射（预备）

> 原则：**只写分析真正要用的**。深集合论（选择公理体系、基数/序数算术）留给抽象代数阶段。
> 例外：等价关系/商集**浅层**纳入——实数的 Cantor 构造（第二章）要用。

| 条目家族 | 内容 | mathlib 参考 | 状态 |
|---|---|---|---|
| `settheory.set.subset` | 子集/包含：定义、传递性、`A⊆B` 的等价刻画 | `Set.subset_def` | 🔶（`…trans`,`…antisymm`,`…empty-subset` ✅） |
| `settheory.set.operations` | 并/交/补/差：分配律、德摩根律、`A∖B=A∩Bᶜ`、`∅⊆A` | `Set.inter_union_distrib_left` | ✅（`…ext`,`…inter-distrib`,`…complement-union`,`…complement-inter`,`…diff-inter-complement`） |
| `settheory.set.relations` | **浅层**：等价关系、等价类、商集、商映射（支撑实数构造） | `Setoid`, `Quotient` | ✅（`…equivalence-class-eq`,`…quotient-surj`） |
| `settheory.function.inject-surject` | 单射/满射/双射、复合保持、双射⇔有逆 | `Function.Injective/Surjective/Bijective` | ✅（`…inj-comp`,`…surj-comp`,`…bijective-iff-inverse`） |
| `settheory.function.image-preimage` | 像 `f[A]`、原像 `f⁻¹[B]`，原像保并/交 | `Set.image`, `Set.preimage` | ✅（`…preimage-union`,`…preimage-inter`） |
| `settheory.cardinal.countable` | 可数定义、**有理数可数**、**实数不可数**、可数个可数之并可数 | `Countable`, `Set.countable_iUnion` | ✅（`…countable-def`,`…countable-rat`,`…uncountable-real`,`…countable-union`） |

> ✅ = verified；🔶 = 进行中。

## 第二章 实数与实数系

| 条目家族 | 内容 | mathlib 参考 | 状态 |
|---|---|---|---|
| `analysis.real.ordered-field` | 实数是有序域（4.33 已拆类：`Field`+`LinearOrder`+`IsStrictOrderedRing`+`ConditionallyCompleteLinearOrder`） | `IsStrictOrderedRing ℝ` | ✅ |
| `analysis.real.archimedean` | **✅ 阿基米德性质** | `exists_nat_gt` | ✅ |
| `analysis.real.bounded-sets` | 有界集、上下界（刻画 + 子集继承） | `BddAbove`, `BddAbove.mono` | ✅（`…bdd-above`,`…subset`） |
| `analysis.real.density` | 有理数在实数中稠密 | `exists_rat_btwn` | ✅ |
| `analysis.real.sup` | 确界原理（完备性） | `sSup`, `Real.isLUB_sSup` | ✅ |
| `analysis.real.construction-cauchy` | **实数构造（Cantor）**：有理数柯西序列的等价类 | `Cauchy`, `Setoid`（有理数 Cauchy 序列） | 待写，依赖 `settheory.set.relations` |

## 第三章 数列极限

| 条目家族 | 内容 | mathlib 参考 |
|---|---|---|
| `analysis.sequence.definition` | 数列收敛的定义 | `Tendsto (fun n ↦ a n) atTop (𝓝 l)` |
| `analysis.sequence.unique` | 极限唯一 | `tendsto_nhds_unique` |
| `analysis.sequence.bounded` | 收敛 ⇒ 有界 | `tendsto_bddAbove_range` |
| `analysis.sequence.squeeze` | 夹逼定理 | `tendsto_of_tendsto_of_le_of_le` |
| `analysis.sequence.monotone-convergence` | 单调有界收敛定理 | `tendsto_of_monotone_of_isBoundedAbove` |
| `analysis.sequence.bolzano-weierstrass` | 波尔查诺-魏尔斯特拉斯 | `exists_seq_monotone_tendsto` 系 |
| `analysis.sequence.cauchy` | 柯西收敛准则 | `cauchySeq_iff_tendsto` 系 |
| `analysis.sequence.subsequence` | 子列 | `SeqNat.tendsto` 系 |
| `analysis.sequence.liminf-limsup` | 上/下极限 | `limsup`, `liminf`, `Filter.limsup` |

## 第四章 函数极限

| 条目家族 | 内容 | mathlib 参考 |
|---|---|---|
| `analysis.func-limit.definition` | 函数极限定义（ε-δ） | `Tendsto f (𝓝[≤] a) ...` |
| `analysis.func-limit.heine` | Heine 归结原理 | `tendsto_iff_tendsto` |
| `analysis.func-limit.arithmetic` | 极限四则运算 | `tendsto.add/mul/div` |
| `analysis.func-limit.one-sided` | 单侧极限 | `𝓝[<]`, `𝓝[≥]` 上的 Tendsto |
| `analysis.func-limit.infinite` | 无穷大与无穷极限 | `Tendsto ... atTop` |

## 第五章 连续函数

| 条目家族 | 内容 | mathlib 参考 |
|---|---|---|
| `analysis.continuity.definition` | 连续性定义（序列/ε-δ 等价） | `ContinuousAt`, `continuous_iff` |
| `analysis.continuity.arithmetic` | 连续函数四则运算 | `Continuous.add/mul` |
| `analysis.continuity.comp` | 复合连续性 | `Continuous.comp` |
| `analysis.continuity.intermediate-value` | 介值定理 | `intermediate_value_Icc`, `intermediate_value_univ` |
| `analysis.continuity.max-min` | 最值定理（紧致性） | `isCompact.exists_forall_ge` 系 |
| `analysis.continuity.uniform` | 一致连续 | `UniformContinuous` |
| `analysis.continuity.inverse` | 严格单调函数反函数连续 | `strictMonoOn.continuousOn_inv` 系 |

## 第六章 导数

| 条目家族 | 内容 | mathlib 参考 |
|---|---|---|
| `analysis.derivative.definition` | 导数定义 | `HasDerivAt` |
| `analysis.derivative.arithmetic` | 求导法则 | `HasDerivAt.add/mul/div` |
| `analysis.derivative.chain-rule` | 链式法则 | `HasDerivAt.comp` |
| `analysis.derivative.inverse-function` | 反函数求导 | `HasDerivAt.inverse` |

## 第七章 微分中值定理

| 条目家族 | 内容 | mathlib 参考 |
|---|---|---|
| `analysis.mvt.rolle` | 罗尔定理 | `exists_deriv_eq_zero` 系 |
| `analysis.mvt.lagrange` | 拉格朗日中值定理 | `exists_hasDerivAt_eq_slope` |
| `analysis.mvt.cauchy` | 柯西中值定理 | `exists_deriv_eq_mvt` 系 |
| `analysis.mvt.lhopital` | L'Hôpital 法则 | `hasDerivAt.div` + MVT 组合 |
| `analysis.mvt.taylor` | 泰勒公式（含 Lagrange 余项） | `taylor`, `Taylor` |

## 第八章 Riemann 积分

| 条目家族 | 内容 | mathlib 参考 |
|---|---|---|
| `analysis.integral.riemann-def` | 达布和与可积性 | `intervalIntegral`, `Darboux` |
| `analysis.integral.riemann-integrable` | 可积函数类 | `IntervalIntegrable` |
| `analysis.integral.mean-value` | 积分中值定理 | `intervalIntegral.integral_le` 系 |
| `analysis.integral.ftc1` | 微积分基本定理（一） | `intervalIntegral.integral_hasDerivAt` |
| `analysis.integral.ftc2` | 微积分基本定理（二） | `intervalIntegral.integral_deriv_eq_sub` |
| `analysis.integral.substitution` | 换元法 | `intervalIntegral.integral_comp_mul_deriv` |

## 推进节奏

1. **章节内先后**：严格按表内行序（定义 → 基本性质 → 定理 → 应用型定理），
   保证每个条目的 premises 已经就绪。
2. **同一行多版本**：mathlib-formal 变体先（机械、快），教材人话变体后（叙述层工作量大）。
3. **里程碑**：第二章结束 = 库能表达"实数的序结构"；
   第三章结束 = 库能表达"极限语言"（分析学的通用语言）；
   第五章结束 = 库能表达"连续函数论"，达到第一次"能干活"（可被后续课程调用）。
4. **并行**：章节之间无依赖的条目（如集合论预备 vs 实数序性质）可由不同会话并行纳入。
