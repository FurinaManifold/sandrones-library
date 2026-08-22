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

> **粒度原则**：第二章不注册"ℝ 是有序域"类结构条目（新生尚不知环/完备格）；
> 结构性质"用到再提起"——穿上确界原理（sup）、阿基米德（archimedean）等性质条目注册，
> 环/序环/完备格等抽象结构类在代数阶段再以变体加入。

| 条目家族 | 内容 | mathlib 参考 | 状态 |
|---|---|---|---|
| `analysis.real.archimedean` | **✅ 阿基米德性质** | `exists_nat_gt` | ✅ |
| `analysis.real.bounded-sets` | 有界集、上下界（刻画 + 子集继承 + 下界刻画） | `BddAbove`, `BddAbove.mono`, `BddBelow` | ✅（`…bdd-above`,`…subset`,`…bdd-below`） |
| `analysis.real.density` | 有理数在实数中稠密 | `exists_rat_btwn` | ✅ |
| `analysis.real.sup` | 确界原理（完备性） | `sSup`, `Real.isLUB_sSup` | ✅ |
| `analysis.real.inf` | 下确界原理 | `sInf`, `isGLB_csInf` | ✅ |
| `analysis.real.construction-cauchy` | 实数构造（Cantor）：有理柯西序列等价类、差趋于 0 是等价关系、商判等、有理数嵌入 | `CauSeq`, `CauSeq.equiv`, `Real.ofCauchy` | ✅ |

> **🏁 第二章已收官（6 家族 / 8 条目）**：实数的序结构（阿基米德、上下确界、稠密）
> 与构造（Cantor）齐备，下一章进入数列极限。

## 第三章 数列极限

| 条目家族 | 内容 | mathlib 参考 | 状态 |
|---|---|---|---|
| `analysis.sequence.definition` | 收敛的 ε-N 判据 | `Metric.tendsto_atTop` | ✅ |
| `analysis.sequence.unique` | 极限唯一 | `tendsto_nhds_unique` | ✅ |
| `analysis.sequence.bounded` | 收敛 ⇒ 有界 | `IsBoundedUnder`, `Metric.tendsto_atTop` | ✅ |
| `analysis.sequence.squeeze` | 夹逼定理 | `tendsto_of_tendsto_of_tendsto_of_le_of_le` | ✅ |
| `analysis.sequence.monotone-convergence` | 单调有界收敛（极限=上确界） | `tendsto_atTop_ciSup`, `Real.isLUB_sSup` | ✅ |
| `analysis.sequence.bolzano-weierstrass` | 波尔查诺-魏尔斯特拉斯 | `CompactIccSpace.isCompact_Icc`, `IsCompact.isSeqCompact` | ✅ |
| `analysis.sequence.cauchy` | 柯西收敛准则 | `CauchySeq`, `Metric.cauchySeq_iff`, `cauchySeq_tendsto_of_complete` | ✅ |
| `analysis.sequence.subsequence` | 子列 | `StrictMono.tendsto_atTop`, `Filter.Tendsto.comp` | ✅ |
| `analysis.sequence.liminf-limsup` | 上/下极限 | `Filter.liminf_le_limsup`, `tendsto_of_liminf_eq_limsup` | ✅ |

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
| `analysis.mvt.taylor` | 抽象有限阶 Taylor 公式（含 Lagrange 余项） | `taylor`, `Taylor` |
| `analysis.mvt.taylor-examples` | `exp` 一阶、`sin/cos` 二阶有限阶展开（不使用级数） | `taylor_mean_remainder_lagrange_iteratedDeriv` |

## 第七章补充：初等特殊函数与重要极限

| 批次 | 内容 | 状态 |
|---|---|---|
| `analysis.special-functions` | `exp`、`sin`、`cos` 的连续性、恒等式和导数 | ✅ 基础批次 |
| `analysis.special-functions.log` | `log` 的连续性、单调性、加法公式、反函数和导数 | ✅ |
| `analysis.special-functions.tan-pow` | `tan`、幂函数、反三角函数的基础性质和导数 | ✅ |

### 高中教材层三角函数公式补充

> 现有 `special-functions` 只覆盖连续性、导数和少量特殊值；高中阶段反复使用的恒等式应单独登记，
> 以便后续重要极限、Taylor 展开和积分例子直接调用。批次按“基本对称性 → 和差 → 倍角/半角 → 变形公式”推进。

| 批次 | 内容 | 主要结果 | 状态 |
|---|---|---|---|
| `analysis.trigonometric.basic-identities` | 奇偶性、周期性、基本界 | `sin(-x)=-sin x`、`cos(-x)=cos x`、`sin(x+2π)=sin x`、`cos(x+2π)=cos x`、`|sin x|≤1`、`|cos x|≤1` | ✅ |
| `analysis.trigonometric.add-sub` | 正弦/余弦和差公式 | `sin(x±y)`、`cos(x±y)`；正切公式留待带条件批次 | ✅ |
| `analysis.trigonometric.double-half` | 倍角、降幂与半角公式 | `sin 2x`、`cos 2x`、`sin²x/cos²x` 的降幂形式；正切和半角根式留待带条件批次 | ✅ |
| `analysis.trigonometric.product-sum` | 积化和差 | `sin x sin y`、`cos x cos y`、`sin x cos y` 的和差表达式 | ✅ |
| `analysis.trigonometric.sum-product` | 和差化积 | `sin x ± sin y`、`cos x ± cos y` 的积表达式 | ✅ |
| `analysis.trigonometric.special-angles` | 高中常用特殊角 | `π/6`、`π/4`、`π/3` 处的正弦、余弦、正切值 | ✅ |
| `analysis.trigonometric.tan-identities` | 正切和差与倍角公式（显式极点条件） | `tan(x±y)`、`tan(2x)` | ✅ |
| `analysis.trigonometric.half-root` | 半角平方根公式（显式符号条件） | `|sin(x/2)|`、`|cos(x/2)|` 及区间内去绝对值版本 | ✅ |
| `analysis.limits.classical` | `sin x/x`、`(1-cos x)/x²`、`(exp x-1)/x`、`log(1+x)/x` | ✅ |
| `analysis.limits.asymptotic` | 指数、对数和幂函数的无穷小/无穷大阶比较 | ✅ |

## 第七章补充：重要常数与零散基础结果

> 这些结论不宜埋在特殊函数条目中。先建立常数的教材层定义和基本数值性质，
> 再在级数或积分工具完备后处理无理性；其中 `e` 的无理性需要独立的算术估计，
> 不能由 `exp` 的连续性或导数公式直接推出。

| 批次 | 内容 | 前置 | 状态 |
|---|---|---|---|
| `analysis.constants.e-definition` | `e := exp 1` 的定义接口、正性、`2 < e < 3`、对数反函数关系 | `analysis.special-functions.basic`, `analysis.special-functions.log` | ✅ |
| `analysis.constants.pi-definition` | `π` 的教材层定义接口、正性、`π ≠ 0`、圆周率基本三角值和周期关系 | `analysis.special-functions.basic`, `analysis.special-functions.log-tan-pow` | ✅ |
| `analysis.constants.special-values` | `exp 0`、`exp 1`、`log 1`、`sin/cos` 在 `0, π/2, π` 的重要值 | `analysis.constants.e-definition`, `analysis.constants.pi-definition` | ✅ |
| `analysis.constants.nth-root-irrational` | 非完全幂整数的正整数次根无理性通用引理 | `analysis.real.archimedean`, `analysis.real.construction-cauchy` | ✅ |
| `analysis.constants.pi-irrational` | `π` 无理性 | `analysis.constants.pi-definition`, `analysis.series.basic` 或 Riemann 积分工具 | 🔲 |
| `analysis.constants.e-irrational` | `e` 无理性 | `analysis.constants.e-definition`, `analysis.series.basic` 或 Riemann 积分工具 | 🔲 |
| `analysis.constants.root-irrational-examples` | 具体 `√2、√3、√5、√7、√11` 等实例 | `analysis.constants.nth-root-irrational` | ⏭️（由通用引理覆盖，不单独登记） |
| `analysis.constants.e-transcendence` | `e` 的超越性 | 代数数、超越数、Lindemann–Weierstrass | 🔲（远期专题） |
| `analysis.constants.pi-transcendence` | `π` 的超越性 | 复分析、代数数、Lindemann–Weierstrass | 🔲（远期专题） |

## 第八章补充：数项级数与幂级数

| 批次 | 内容 | 状态 |
|---|---|---|
| `analysis.series.basic` | 级数定义、Cauchy 准则、几何级数、调和级数 | ✅ |
| `analysis.series.tests` | 比较、比值、交错级数判别法（根值判别法另列待办） | ✅ |
| `analysis.series.power` | 收敛半径、幂级数逐项求导与逐项积分 | 🔲 |
| `analysis.series.taylor` | `exp`、`sin`、`cos` 的 Taylor 展开 | 🔲 |

### 数项级数与幂级数的验收细化

| 批次 | 内容 | 前置 | 状态 |
|---|---|---|---|
| `analysis.series.absolute` | 绝对收敛、绝对收敛蕴含收敛、部分和趋于级数和 | `analysis.series.basic`, `analysis.series.tests` | ✅ |
| `analysis.series.conditional` | 条件收敛、交错级数部分和收敛 | `analysis.series.tests` | ✅ |
| `analysis.series.rearrangement` | 绝对收敛级数的重排不变性（Riemann 条件重排另列） | `analysis.series.absolute`, `analysis.series.conditional` | ✅ |
| `analysis.series.riemann-rearrangement` | Riemann 条件重排的直接分块构造，并指定部分和的 `liminf` 与 `limsup` | `analysis.series.conditional`, `analysis.sequence.liminf-limsup` | ✅ |
| `analysis.series.cauchy-product-definition` | Cauchy 乘积定义、反对角线表示与有限三角部分和恒等式 | `analysis.series.basic` | ✅ |
| `analysis.series.cauchy-product-absolute` | 两级数绝对收敛时，Cauchy 乘积绝对收敛且其和等于两级数和之积 | `analysis.series.absolute`, `analysis.series.cauchy-product-definition` | ✅ |
| `analysis.series.mertens` | Mertens 定理：一个级数绝对收敛、另一个收敛时，Cauchy 乘积收敛到两者和之积 | `analysis.series.cauchy-product-absolute`, `analysis.series.conditional` | ✅ |
| `analysis.series.abel-cauchy-product` | Abel 型乘积定理：两个级数及其 Cauchy 乘积均收敛时，乘积级数之和等于两级数和之积 | `analysis.series.mertens` | ✅ |
| `analysis.power-series.definition` | 幂级数定义、部分和、收敛点集 | `analysis.series.basic` | ✅ |
| `analysis.power-series.radius` | 收敛半径：半径内绝对收敛、半径外发散 | `analysis.power-series.definition`, `analysis.series.tests` | ✅ |
| `analysis.power-series.endpoints` | 收敛区间端点的独立判定 | `analysis.power-series.radius`, `analysis.series.conditional` | ✅ |
| `analysis.power-series.operations` | 收敛区间内逐项加法、乘法、求导和积分 | `analysis.power-series.radius`, `analysis.series.cauchy-product-absolute` | 🔲 |

## 第八章 Riemann 积分

| 条目家族 | 内容 | mathlib 参考 |
|---|---|---|
| `analysis.integral.riemann-def` | 达布和与可积性 | `intervalIntegral`, `Darboux` |
| `analysis.integral.riemann-integrable` | 可积函数类 | `IntervalIntegrable` |
| `analysis.integral.mean-value` | 积分中值定理 | `intervalIntegral.integral_le` 系 |
| `analysis.integral.ftc1` | 微积分基本定理（一） | `intervalIntegral.integral_hasDerivAt` |
| `analysis.integral.ftc2` | 微积分基本定理（二） | `intervalIntegral.integral_deriv_eq_sub` |
| `analysis.integral.substitution` | 换元法 | `intervalIntegral.integral_comp_mul_deriv` |

## 第九章补充：Riemann 积分教材层结果

| 批次 | 内容 | 状态 |
|---|---|---|
| `analysis.integral.riemann-algebra` | 线性、区间可加性、单调性、正性和绝对值估计 | 🔲 |
| `analysis.integral.mean-value` | 积分中值定理与周期函数积分 | 🔲 |
| `analysis.integral.ftc` | 与自建 Riemann 定义对齐的微积分基本定理 | 🔲 |
| `analysis.integral.parts-substitution` | 分部积分与换元积分 | 🔲 |
| `analysis.integral.examples` | 多项式、指数、三角函数和幂函数的数值积分 | 🔲 |

## 推进节奏

1. **章节内先后**：严格按表内行序（定义 → 基本性质 → 定理 → 应用型定理），
   保证每个条目的 premises 已经就绪。
2. **同一行多版本**：mathlib-formal 变体先（机械、快），教材人话变体后（叙述层工作量大）。
3. **里程碑**：第二章结束 = 库能表达"实数的序结构"；
   第三章结束 = 库能表达"极限语言"（分析学的通用语言）；
   第五章结束 = 库能表达"连续函数论"，达到第一次"能干活"（可被后续课程调用）。
4. **并行**：章节之间无依赖的条目（如集合论预备 vs 实数序性质）可由不同会话并行纳入。

---

## 与长远批次规划的关系

本文件只细化"数学分析"这门课；**全库的学科先后顺序**（分析 → 线性代数 → 抽象代数 →
点集拓扑 → 实分析 → 后续）见 **`ROADMAP-LONGTERM.md`**。

关于第八章 Riemann 积分的必要更正：**mathlib 内置的积分是一般测度的 Lebesgue 积分，
不是黎曼积分**。因此一元微积分只推进到导数与中值定理（第四章/五六七章），
积分内容放到长远规划的 **Phase 5 实分析**，以测度论顺流而下的勒贝格积分承载
（它覆盖黎曼可积应用，且是概率论/泛函分析的地基）。
