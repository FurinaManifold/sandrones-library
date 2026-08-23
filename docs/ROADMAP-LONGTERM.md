# Sandrone's Library — 长远批次规划（数学大厦扩展蓝图）

> **定位**：本文件是 `ROADMAP-math-analysis.md` 的**超集**。那份文档管"数学分析（分析线）"
> 的章节蓝图；这份文档管**全库学科前后顺序**，并把每一门课拆成**批次**，每批拆到
> **具体定理条目**（粒度 = 现在"第四章第一批：函数极限基础 13 条"那么细致）。
>
> 每批都沿着 `INGESTION_PROTOCOL.md` 走：`.lean` 文件头列条目清单 → 逐条（Entry/docstring）→
> `lake build` → `check_axioms --fix` → `audit.py` → RADAR → `git commit`（`"<阶段><批>: <主题>（N 条）+ 注册/RADAR"`）。
>
> 一个"条目"是一个可验证的结论（一个 lemma/theorem/def + 一个叙述层 `.md` + 一条 registry 记录），
> 不是一堆结论的打包。下表把每批列到条目级，写计划的人与实现的人都应能指着条目名说"这条是否已 verified"。

---

## 0. 铁律（决定顺序）

1. **依赖优先**：每批的每个条目的 `premises` 必须已在库中 verified。批次顺序 = 数学依赖图 + mathlib 表达需求的线性化。
2. **mathlib 语言优先**：先用 mathlib 原生抽象语言写（能表达什么就按什么写），人话叙述层随后。没有的 API 就停在"定义 + 一手性质"。
3. **先完整再前沿**：规划内阶段全部达到 §6 的"学完"标准后，才允许把科研论文作为新批次下沉（见 §6.2）。

---

## 1. 阶段顺序总览

| 阶段 | 课程（家族前缀） | 批次 | 前驱 |
|---|---|---|---|
| **Phase 1 分析线** | `analysis.*` | M1✅ M2✅ M3 M4 M5 | — |
| **Phase 2 线性代数** | `linear-algebra.*` | L1 L2 L3 L4 L5 | 集合论预备 |
| **Phase 3 抽象代数** | `abstract-algebra.*` | A1 A2 A3 A4 | 等价关系/商集 |
| **Phase 4 拓扑学基础** | `topology.*` | T1 T2 T3 T4 | 集合论 + 分析线直观 |
| **Phase 5 实分析** | `real-analysis.*` | R1 R2 R3 R4 R5 | T3 + M 系列 |
| **Phase 6 复分析** | `complex-analysis.*` | C1 C2 C3 | R2 T3 M4 |
| **Phase 7 泛函分析** | `functional-analysis.*` | F1 F2 F3 F4 | A4 T3 R4 |
| **Phase 8 概率论** | `probability.*` | Pr1 Pr2 Pr3 | R4 |
| **Phase 9 统计推断** | `statistics.*` | S1 S2 | Pr |
| **Phase 10 数论分支** | `number-theory.*` | N1 N2 N3 | A2/A3；N3 另需 C1-C3 |
| **Phase 11 集合论深化** | `set-theory.*` | ST1 ST2 ST3 | 集合/关系/Zorn；ST3 另需可计算性 |
| **Phase 12+ 前沿分叉** | 交换代数/同调/代数拓扑/表示论/微分几何… | X* | 各自分支前置达标 |

**为什么实分析在拓扑之后、且用测度积分**：测度论需要 σ-代数/可测空间（拓扑的抽象层）；
而 mathlib 内置积分是**一般测度的 Lebesgue 积分**，不是黎曼积分——所以一元微积分只做到导数/中值，
积分本体放到 R 用测度积分承载（覆盖黎曼的微积分基本定理/换元/收敛定理，且是概率/泛函的地基）。

---

## 2. Phase 1 — 分析线（M1✅ M2✅ M3-M5 待写）

> 家族前缀 `analysis.`；命名示例：`analysis.continuity.definition`、`analysis.derivative.chain-rule`。

### M1 数列极限 ✅（已完，9 条）

`analysis.sequence.definition`、`.unique`、`.bounded`、`.squeeze`、`.monotone-convergence`、
`.subsequence`、`.bolzano-weierstrass`、`.cauchy`、`.liminf-limsup`；
`analysis.completeness.*`（nested-intervals / finite-cover / accumulation-point + 等价环 6 条）归入本批的完备性扩展。

### M2 函数极限 ✅（已完，13 条）

`analysis.func-limit.definition`、`.const`、`.identity`、`.unique`、`.congr`、`.add`、`.sub`、`.mul`、
`.div`、`.const-mul`、`.le`、`.heine`、`.at-top`。

### M3 连续函数（下一批）

| # | 条目 id | 内容 | mathlib |
|---|---|---|---|
| 1 | `analysis.continuity.definition` | 点连续 ↔ 序列连续（heine 已备，直接桥） | `ContinuousAt`、`continuous_iff_continuousAt`、`tendsto_iff` |
| 2 | `analysis.continuity.const` | 常函数连续 | `continuous_const` |
| 3 | `analysis.continuity.identity` | 恒等/坐标投影连续 | `continuous_id`、`continuous_apply` |
| 4 | `analysis.continuity.add` | 连续函数之和连续 | `Continuous.add` |
| 5 | `analysis.continuity.mul` | 连续函数之积连续 | `Continuous.mul` |
| 6 | `analysis.continuity.div` | 连续函数之商连续（分母非零） | `Continuous.div` |
| 7 | `analysis.continuity.comp` | 复合连续 | `Continuous.comp` |
| 8 | `analysis.continuity.on-closed` | 闭区间连续函数第四则化推论（保值域） | 二阶推论 |
| 9 | `analysis.continuity.intermediate-value` | **介值定理**：连续函数取遍两端间所有值 | `intermediate_value_Icc`、`intermediate_value_Ici` |
| 10 | `analysis.continuity.max-min` | **最值定理**：闭区间连续函数取最大/最小 | `IsCompact.exists_forall_ge` 系、`exists_forall_lt` |
| 11 | `analysis.continuity.uniform` | 一致连续 | `UniformContinuous`、`uniformContinuous_iff` |
| 12 | `analysis.continuity.inverse` | 严格单调连续 ⟹ 反函数连续 | `strictMonoOn.continuousOn_inv`、`trendsto_inv_subtype` |

> 里程碑（M3 结束）：库能表达"连续函数论"，第一次"能干活"，M4 全部就绪。

### M4 导数（下一批之后）

| # | 条目 id | 内容 | mathlib |
|---|---|---|---|
| 1 | `analysis.derivative.definition` | 导数定义：差商极限 | `HasDerivAt`、`HasDerivAt.deriv` |
| 2 | `analysis.derivative.unique` | 导数唯一 | `HasDerivAt.unique`、`deriv_eq` |
| 3 | `analysis.derivative.const` / `.id` | 常数/恒等函数导数 | `HasDerivAt.const`、`HasDerivAt.id` |
| 4 | `analysis.derivative.add` / `.sub` | 和/差导数 | `HasDerivAt.add`、`.sub` |
| 5 | `analysis.derivative.mul` | 积的导数（Leibniz） | `HasDerivAt.mul` |
| 6 | `analysis.derivative.div` | 商导数 | `HasDerivAt.div` |
| 7 | `analysis.derivative.const-mul` | 常数数乘导数 | `HasDerivAt.const_mul` |
| 8 | `analysis.derivative.chain-rule` | **链式法则** | `HasDerivAt.comp` |
| 9 | `analysis.derivative.inverse-function` | **反函数求导** | `HasDerivAt.inverse` |

### M5 微分中值定理与泰勒

| # | 条目 id | 内容 | mathlib |
|---|---|---|---|
| 1 | `analysis.mvt.rolle` | **罗尔定理** | `exists_deriv_eq_zero` 系 |
| 2 | `analysis.mvt.lagrange` | **拉格朗日中值定理** | `exists_hasDerivAt_eq_slope` |
| 3 | `analysis.mvt.cauchy` | **柯西中值定理** | `exists_deriv_eq_mvt` 系 |
| 4 | `analysis.mvt.lhopital` | **L'Hôpital 法则** | `HasDerivAt.div`+MVT 组合 |
| 5 | `analysis.mvt.monotone-deriv` | 导数符号判别单调（MVT 推论） | `strictMonoOn_of_deriv_pos` 系 |
| 6 | `analysis.mvt.taylor` | **泰勒公式**（Peano/Lagrange 余项） | `taylor`、`Taylor`、`taylor_eq_sum` |
| 6.5 | `analysis.mvt.taylor-integral-remainder` | **Taylor 积分型余项**（自建 Riemann 积分版本） | `taylor_integral_remainder` |
| 7 | `analysis.asymptotic.stirling` | **Wallis 乘积与 Stirling 公式**（含全局下界） | `Real.tendsto_prod_pi_div_two`、`Stirling.factorial_isEquivalent_stirling` |

---

## 3. Phase 2 — 线性代数（L1-L5）

> 家族前缀 `linear-algebra.`。mathlib 线性代数是模语言（`Module`/`Submodule`/`Basis`），
> 向量空间 = 系数为域（`Field`）的模。叙述层先做"域上模 = 向量空间"翻译。

### L1 向量空间（基质/子空间/基/维数）

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `linear-algebra.vector-space.def` | 向量空间定义（域上模实例） | `Module` |
| 2 | `linear-algebra.vector-space.subspace` | 子空间：包含/closure 判据 | `Submodule`、`Submodule.mem_span` |
| 3 | `linear-algebra.vector-space.span` | 生成子空间 | `Submodule.span` |
| 4 | `linear-algebra.vector-space.independent` | 线性无关 | `LinearIndependent` |
| 5 | `linear-algebra.vector-space.basis` | 基：存在性与张成 | `Basis`、`exists_basis` |
| 6 | `linear-algebra.vector-space.dimension` | 维数 | `Module.finrank`、`Module.finrank_eq_card_basis` |

### L2 线性映射/矩阵/秩

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `linear-algebra.maps.map` | 线性映射、核/像 | `LinearMap`、`LinearMap.ker/range/map` |
| 2 | `linear-algebra.maps.iso` | 线性同构与维数同构定理 | `LinearEquiv`、`finrank_eq` |
| 3 | `linear-algebra.maps.matrix` | 矩阵表示、复合=矩阵乘 | `Matrix`、`LinearMap.toMatrix`、`Matrix.mul_assoc` |
| 4 | `linear-algebra.maps.rank` | 秩、秩-零度定理 | `rank`、`rank_comp_le`、`rank_add_le` |
| 5 | `linear-algebra.matrix.symmetric` | 对称矩阵、反对称矩阵及标准分解 | `Matrix.IsSymm`、`Matrix.transpose` |

### L3 行列式

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `linear-algebra.det.def` | 行列式定义 | `Matrix.det` |
| 2 | `linear-algebra.det.mul` | 积的行列式 | `det_mul` |
| 3 | `linear-algebra.det.invertible` | 可逆 ⟺ det≠0 | `det_ne_zero_iff`、`isUnit_iff` |
| 4 | `linear-algebra.det.likeness` | 转置/行列展开 | `det_transpose`、`Matrix.det_apply` |

### L4 特征值/相似/对角化

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `linear-algebra.eigen.eigenvalue` | 特征值/特征向量定义 | `Module.End.HasEigenvalue`、`HasEigenvector` |
| 2 | `linear-algebra.eigen.characteristic` | 特征多项式、特征子空间维数 | `Matrix.charpoly` |
| 3 | `linear-algebra.eigen.similar` | 相似变换、对角化判据 | `Matrix.Similar`、`IsDiagonalizable` |
| 4 | `linear-algebra.eigen.jordan` | 代数闭域上的 Jordan 标准形与矩阵相似形式 | 本库自建 Jordan 链、块对角矩阵与换基接口 |

### L5 内积空间/正交/谱/二次型

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `linear-algebra.inner.def` | 内积定义、Cauchy-Schwarz | `InnerProductSpace`、`inner_mul_norm_le` |
| 2 | `linear-algebra.inner.orthogonal` | 正交、正交补、Gram-Schmidt | `orthogonal`、`orthogonalBasis`、`GramSchmidtOrthogonalization` |
| 3 | `linear-algebra.inner.self-adjoint` | 自伴算子 | `IsSelfAdjoint` |
| 4 | `linear-algebra.inner.spectral` | **谱定理**（实对称） | `isDiagonalizable`、`spectrum` 系 |
| 5 | `linear-algebra.inner.quadratic` | 二次型、双线性型 | `QuadraticForm`、`QuadraticForm.associated` |

### 线性代数补遗批次（2026-08 审计）

此前“L1–L4 完成”只表示首批骨架已建立，并不等于标准本科线性代数内容齐全。
后续按下列顺序补齐：

| 顺序 | 条目 | 缺失内容 | 状态 |
|---|---|---|---|
| 1 | `linear-algebra.maps.basic` | 核/像判据、单射/满射、线性同构与维数保持、第一同构定理 | ✅ |
| 2 | `linear-algebra.coordinates.change-basis` | 坐标映射、过渡矩阵、换基公式、相似矩阵表示同一算子 | ✅ |
| 3 | `linear-algebra.vector-space.sum-quotient` | 子空间和、直和、商空间及维数公式 | ✅ |
| 4 | `linear-algebra.eigen.diagonalization` | 特征基判据、几何/代数重数、Cayley–Hamilton、最小多项式 | ✅ |
| 5 | `linear-algebra.eigen.jordan` | Jordan 链、标准形存在性、矩阵相似形式及由广义核维数确定块大小的唯一性 | ✅ |
| 6 | `linear-algebra.inner-product` | 内积、正交补、Gram–Schmidt、伴随与自伴 | 🔲 |
| 7 | `linear-algebra.spectral-quadratic` | 实对称谱定理、正交对角化、二次型与惯性定律 | 🔲 |
| 8 | `linear-algebra.tensor-exterior` | 对偶基、张量基、外幂分次与维数公式 | 🚧 |

---

## 4. Phase 3 — 抽象代数（A1-A4）

> 家族前缀 `abstract-algebra.`。mathlib 用 Typeclass（`Group`/`Ring`/`Module`）+ 子结构
> （`Subgroup`/`Ideal`/`Subring`）。先集合论/等价关系已备。
>
> **学期分界**：第一学期 = A1 群 + A2 环 + A3 的多项式环部分（A3.1-A3.2，域扩张前置）；
> 第二学期 = A3 域扩张/Galois（A3.3-A3.4）+ A4 模。分界依据：经典近世代数一学期内容
> 即群论+环论（含多项式环），域扩张/Galois 与模需要更多抽象背景，与 L 线"第一学期基础结构、
> 第二学期深层理论"的惯例一致。
>
> **阶段语言可用性**：抽象代数阶段，mathlib 的 `Group`/`Subgroup`/`MonoidHom`/`Ring`/`Subring`/
> `Ideal`/`Polynomial` 等**教材结构直接可出现在签名**（学到什么用什么）；但 **`Module` 仍不允许**
> ——线性代数阶段已用 `LinearSpace` 承载，保持体系一致，A4 模阶段再作决定。

### A1 群

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `abstract-algebra.group.def` | 群定义、子群 | `Group`、`Subgroup` |
| 2 | `abstract-algebra.group.coset` | 陪集、Lagrange | `Subgroup.card_mul_finset_card`、`QuotientGroup` |
| 3 | `abstract-algebra.group.normal` | 正规子群、商群 | `NormalSubgroup`、`QuotientGroup.quotient_mk` |
| 4 | `abstract-algebra.group.hom` | 同态、同构、同态定理 | `MonoidHom`、`MonoidHom.ker/range` |

### A2 环

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `abstract-algebra.ring.def` | 环定义、子环 | `Ring`、`Subring` |
| 2 | `abstract-algebra.ring.ideal` | 理想、商环 | `Ideal`、`Ideal.quotient` |
| 3 | `abstract-algebra.ring.domain` | 整环/域、素/极大理想 | `IsDomain`、`IsField`、`Ideal.IsPrime/Maximal` |

### A3 多项式与域扩张

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `abstract-algebra.poly.def` | 多项式环、整除 | `Polynomial`、`Polynomial.dvd` |
| 2 | `abstract-algebra.poly.irreducible` | 不可约、欧几里得 | `IrreduciblePolynomial`、`Polynomial.isDomain` |
| 3 | `abstract-algebra.field.extension` | 扩域、代数扩张、L→Alg | `IntermediateField`、`Algebra` |
| 4 | `abstract-algebra.field.galois` | **Galois 对应初步** | `IsGalois`、`IntermediateField.fixedField` |

### A4 模

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `abstract-algebra.module.def` | 模定义、子模/商模（系统化，L1 已用） | `Module`、`Submodule.map/ker`、`Module.quotient` |
| 2 | `abstract-algebra.module.hom` | 模同态、同态定理 | `LinearMap`、`Module.map_top` 系 |
| 3 | `abstract-algebra.module.free` | 自由模、有限自由/投影模 | `Module.Free`、`Module.Projective` |

---

## 5. Phase 4 — 点集拓扑及代数拓扑入口（T1-T4）

> 家族前缀 `topology.`。

### T1 拓扑空间（开闭/邻域/连续/子商积）

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `topology.space.def` | 拓扑/开闭集定义 | `TopologicalSpace`、`IsOpen` |
| 2 | `topology.space.closure` | 内部、闭包、边界及邻域刻画 | `interior`、`closure`、`frontier` |
| 3 | `topology.space.neighborhood` | 邻域/滤子 | `𝓝`、`nhds`、`Filter` |
| 4 | `topology.space.continuous` | 连续、点连续 ↔ 连续 | `Continuous`、`ContinuousAt`、`continuous_iff` |
| 5 | `topology.space.homeo` | 同胚 | `Homeomorph` |
| 6 | `topology.space.subspace` | 子空间/积/商拓扑 | `Subspace`、`Product`、`Quotient` |
| 7 | `topology.space.connected` | 连通/道路连通（导言） | `IsConnected`、`PathConnected` |

### T2 紧致/分离

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `topology.compact.def` | 紧致（有限覆盖/序列/滤子等价） | `IsCompact`、`CompactSpace` |
| 2 | `topology.compact.closed-bdd` | 闭区间紧（Heine-Borel 的抽象版） | `IsCompact.isClosed`、`isCompact_Icc` |
| 3 | `topology.compact.finite` | 紧 Hausdorff 的闭/紧性、Tychonoff | `isCompact_iff_isClosed`、`Tychonoff` |
| 4 | `topology.separations` | T1/T2/正则/正规 | `T1Space`、`T2Space`、`NormalSpace`、`T3Space` |

### T3 度量与完备性

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `topology.metric.def` | 度量空间、开球 | `MetricSpace`、`Metric.ball` |
| 2 | `topology.metric.uniform` | 一致连续/一致空间 | `UniformContinuous`、`UniformSpace` |
| 3 | `topology.metric.cauchy-complete` | Cauchy/完备 | `Metric.CauchySeq`、`CompleteSpace` |
| 4 | `topology.metric.completion` | **完备化** | `UniformSpace.Completion`、`denseRange_pack` |
| 5 | `topology.normed-space.def` | 赋范线性空间、范数诱导度量 | `NormedSpace`、`dist_eq_norm` |
| 6 | `topology.normed-space.inequalities` | 三角与反三角不等式、数乘范数 | `norm_add_le`、`abs_norm_sub_norm_le` |
| 7 | `topology.normed-space.banach` | 范数收敛、Cauchy 与 Banach 完备性 | `Metric.tendsto_atTop`、`CompleteSpace` |

### T4 同胚、同伦与基本群（点集拓扑后的代数拓扑入口）

> 依赖顺序固定为“同胚及拓扑不变量 → 道路与同伦 → 同伦等价 → 基本群”。其中 T1
> 已完成同胚的定义和基本接口；本批次继续发展同胚保持性质，并建立代数拓扑所需结构。

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `topology.homeomorph.invariants` | 同胚的复合、逆及对连通性、紧致性等拓扑性质的保持 | `Homeomorph.trans`、`Homeomorph.toHomotopyEquiv` |
| 2 | `topology.homotopy.path-loop` | 道路、道路复合、逆道路与以基点为端点的环路 | `Path`、`Path.trans`、`Path.symm`、`Path.Homotopic` |
| 3 | `topology.homotopy.maps` | 映射之间的同伦、相对端点同伦及同伦的复合运算 | `ContinuousMap.Homotopy`、`ContinuousMap.HomotopyRel` |
| 4 | `topology.homotopy.equivalence` | 同伦等价、同伦逆及同伦等价关系 | `ContinuousMap.HomotopyEquiv`、`Homeomorph.toHomotopyEquiv` |
| 5 | `topology.fundamental-group.def` | 基点环路按端点固定同伦取商，定义基本群 `π₁(X,x₀)` | `FundamentalGroupoid`、`FundamentalGroup`、`Path.Homotopic.Quotient` |
| 6 | `topology.fundamental-group.group` | 环路拼接诱导群结构，恒定环路、逆环路及结合律 | `FundamentalGroup.toPath`、`FundamentalGroup.fromPath` |
| 7 | `topology.fundamental-group.functorial` | 连续映射诱导基本群同态；同伦映射诱导自然同构 | `FundamentalGroupoidFunctor.map`、`FundamentalGroupoidFunctor.homotopicMapsNatIso` |
| 8 | `topology.fundamental-group.invariance` | 基本群在同胚与同伦等价下不变，并处理基点变换 | `FundamentalGroupoidFunctor.equivOfHomotopyEquiv`、`ContinuousMap.HomotopyEquiv` |
| 9 | `topology.fundamental-group.examples` | 单点、凸集、可缩空间与圆周等例子；圆周基本群作为重点自证结果 | `SimplyConnectedSpace`、`FundamentalGroupoid.punitEquivDiscretePUnit` |

---

## 6. Phase 5+ — 实分析与后续（批次级，条目在批处理时按同粒度落地）

> 这些课程及后续分支先列到"批次 + 核心定理清单"，具体条目 id 在每批开工时按 §0 铁律4 在文件头展开成与上表相同的表格。为什么不提前全部展开：这些批次量极大（R 有 5 批、后续每门数批），
> 现在列出可执行、可追踪、可逐条打勾的粒度；具体 theorem 名在批处理时结合 mathlib 现状定稿。

### Phase 5 实分析 = 数学分析第二学期（R1-R6，测度积分 + 多元微积分）

> 定位：数学分析第二学期。一元函数积分学部分**换成测度/Lebesgue 积分**（mathlib 内置
> 是一般测度的 Lebesgue 积分，非黎曼；覆盖微积分基本定理/换元/收敛定理，且是概率/泛函地基）；
> 后续**多元微积分照常写**（重积分/曲线曲面积分/三大公式）。

- **R1 测度**：σ-代数/可测空间、测度、外测度、Carathéodory 可测、正则测度。
- **R2 可测函数与积分**：可测函数、简单函数、非负可测函数积分（lintegral）、一般可积函数（integral）。
- **R3 收敛定理**：单调收敛、Fatou、控制收敛。
- **R4 乘积/Lᵖ**：乘积测度、Fubini/Tonelli、Lᵖ 空间与完备性。
- **R5 微分定理桥**：Lebesgue 微分定理、测度积分的微积分基本定理、与黎曼的关系。
- **R5.5 黎曼积分的测度理论定位**：
  - ✅ `real-analysis.riemann.def`：黎曼积分的定义（达布分划/上下和/可积/均匀分划/积分值，全部自建）。
  - ✅ `real-analysis.riemann.cont-integrable`：连续 ⟹ 黎曼可积（一致连续 + 均匀分划 + 振荡界，自证）。
  - ✅ `real-analysis.riemann.eq-lebesgue`：连续函数的黎曼积分值 = Lebesgue 区间积分；
  - ✅ `real-analysis.riemann.eq-lebesgue-general`：任意标准 Riemann 可积函数的黎曼积分值 = Lebesgue 区间积分；
  - ✅ `real-analysis.riemann.ftc`：微积分基本定理的 Newton–Leibniz 与变上限 Riemann 积分版本；
  - ✅ `real-analysis.riemann.parts-substitution`：分部积分与换元法，并完成指数函数例题；
  - ✅ `analysis.integral.examples`：自然数幂、指数、正弦、余弦及线性换元的 Riemann 定积分公式；
    达布和 = 阶梯函数积分并通过夹逼完成证明。
  - ✅ `real-analysis.riemann.lebesgue-criterion`：**黎曼可积 ⟺ 几乎处处连续**（Lebesgue 判据）。
  - ✅ `real-analysis.lebesgue-measure`：Lebesgue 测度（ℝ 上 `volume`：区间长度、区间可测）。
- **R4 乘积/Lᵖ**：✅ 乘积测度、Tonelli/Fubini、Lᵖ 基础、Hölder、Chebyshev、Minkowski 与完备性，整批完成。
- **R6 多元微积分**（进行中）：✅ Fréchet 全微分、方向导数、梯度、坐标偏导与 Jacobian；
  ✅ Hessian/Taylor、反函数定理、隐函数定理、满秩秩定理与一般常秩 `r` 定理；
  ✅ Lebesgue 闭矩形二重积分、Fubini 教材接口、Jordan 可测区域、闭盒多元 Riemann
  定义、连续函数数值桥与 Jordan 区域零延拓桥；
  ✅ `x`/`y`-型正常区域的变限累次积分公式；
  ✅ 可测区域上的多重积分换元、可积性等价与 Jacobian 体积公式；
  🚧 坐标积分已完成二维极坐标、三维柱坐标、球坐标 Jacobian、
  标准参数域换元、全空间公式与三重累次形式，继续补球体体积、质量、
  球体体积、常密度质量、重心与转动惯量例题；该坐标积分批次完成；
  🚧 参数曲线的速度、速率、正则性与弧长，以及参数曲面的坐标切向量和
  正则性已建立；仿射平面的显式微分、切向量与线性无关正则判据已完成；
  仿射平面的像已证明只依赖方向张成的子空间，而与具体生成方向无关；
  保向可微换参数下的速度、速率与弧长不变性已完成；
  三维曲面面积元、面积定义、仿射平面正则判据、仿射矩形面积公式、点态 Jacobian
  变换公式及一般可微单射换参数下的面积不变性已完成；第一型曲线/曲面积分、
  常密度公式与换参数不变性也已完成；
  🚧 对偶空间、张量积泛性质、自然缩并、外代数楔积的结合律、向量楔积与交替形式
  的第一层接口已建立；
  继续补对偶基、张量基、形式楔积与外幂维数；
  🚧 赋范向量空间上的微分形式、零次形式、拉回、外微分、`d²=0`、拉回自然性、
  闭形式、恰当形式、外微分交替和公式，以及形式楔积的代数层、shuffle 范数界和
  连续性封装、双线性接口、次数重编号、连续双线性算子及楔积保持点可微性已建立；
  线性定向、保向/反向自同构及行列式判据也已在拓扑层建立并由分析层调用；
  第二型曲线/曲面积分的微分形式定义、线性、保向换参数和恰当 1-形式端点公式
  已建立；协向量场接口、反向参数化变号和闭曲线上的恰当形式零积分也已完成；
  继续补二维/三维显式坐标表达、Leibniz 公式和 Poincaré 引理，再推进
  Green/Gauss/Stokes 公式。
  矩形 Green 公式、三维盒 Gauss 散度公式以及矩形参数曲面上的拉回版经典 Stokes
  `curl·(σᵤ×σᵥ)` 坐标展开、有限参数片/多图册拼接及闭曲面推论均已完成；
  具体三角形、圆盘、单位立方体和水平单位正方形例题放在顶层 `Examples`。
  **本阶段不定义 de Rham 上同调**：数学分析 II 只使用“闭形式在适当区域上恰当”
  的具体结论，不把闭形式模恰当形式组成商空间。

### Phase 6 复分析（C0-C3）

- **C0 复数基础**：✅ 复数的实部—虚部定义、坐标判等、加法/乘法、`i²=-1`、共轭与模平方公式。
- **C0.5 代数学基本定理**：✅ 非常数复多项式存在复根、`ℂ` 代数闭、复多项式完全分裂；
  由此得到任意复方阵的 Jordan 相似标准型。
- **C1-C3**：全纯/柯西-黎曼 → 泰勒/洛朗/唯一性 → 复积分/残数定理。

### Phase 7 泛函分析（F1-F4）

赋范空间 → Banach（开映像/闭图/一致有界）→ Hilbert（Riesz/谱）→ 算子代数。

### Phase 8 概率论（Pr1-Pr3）

概率空间/随机变量/期望 → 独立性/条件期望/大数律 → 中心极限定理。

### Phase 9 统计推断（S1-S2）

估计（MLE/矩/充分性）→ 检验（似然比/Neyman-Pearson）与回归。

### Phase 10 数论分支（N1-N3）

> 数论不作为一条必须等全部分析课程结束后才启动的单线：N1 在整数、整除和初等代数
> 齐备后即可进行；N2 依赖域扩张、理想与有限生成模；N3 则等待复分析的留数、解析延拓
> 等工具。三个批次分别使用 `number-theory.elementary.*`、`number-theory.algebraic.*`、
> `number-theory.analytic.*` 家族。

- **N1 初等数论**：
  - 整除、带余除法、最大公因数、Bézout、Euclid 引理与算术基本定理；
  - 同余、剩余类环、中国剩余定理、Euler φ 函数、Fermat/Euler 定理；
  - 素数无穷、素数判定与典型 Diophantine 方程；
  - 二次剩余、Legendre/Jacobi 符号、Gauss 引理与二次互反律；
  - 连分数、最佳有理逼近与 Pell 方程。
- **N2 代数数论**：
  - 数域、代数整数、整数环、范数、迹、判别式与整基；
  - Dedekind 整环中的分式理想、理想唯一分解、理想类群与类数；
  - 素理想在数域扩张中的分解、分歧指数与惯性次数；
  - Minkowski 嵌入与界、单位群的 Dirichlet 定理；
  - 赋值、完备化、`p`-进数和局部域入口，最后建立局部—整体问题的接口。
- **N3 解析数论**：
  - 算术函数、Dirichlet 卷积、Möbius 反演与部分求和；
  - Dirichlet 级数、Euler 乘积、Riemann ζ 函数的基本解析性质；
  - 素数计数函数、Chebyshev 估计与素数定理；
  - Dirichlet 特征、`L`-函数及算术级数中的素数定理；
  - 后续专题：零点分布、显式公式、筛法和加性数论，按依赖另立扩展批次。

### Phase 11 集合论深化（ST1-ST3）

> 现有 `SetTheory` 中的集合、函数、关系、基数入口和 Zorn 引理是本分支前置。本阶段
> 区分“序数/基数的集合论大小”与“googology 的可表示有限大数”；后者必须同时发展
> 递归论、证明论序数和增长层级，不能只靠基数理论。

- **ST1 序数理论**（`set-theory.ordinal.*`）：
  - 良序、序型、序数比较与超限归纳/递归；
  - 序数加法、乘法、幂及其非交换性；
  - 极限序数、后继序数、上确界、共尾性与正规函数；
  - Cantor 正规形、ε 数、`ε₀`，并连接 Goodstein 定理所需的序数下降论证。
- **ST2 基数理论**（`set-theory.cardinal.*`）：
  - 等势、基数比较、Cantor–Bernstein 与 Cantor 定理；
  - 基数加法、乘法、幂，有限/可数/不可数集；
  - `aleph`、`beth` 层级、共尾性、正则/奇异基数与 König 定理；
  - 选择公理、良序定理、Zorn 引理的等价关系；
  - 连续统假设只登记准确陈述和相对独立性边界，不伪造库内不可得的模型论证明。
- **ST3 Googology、递归与增长层级**（`set-theory.googology.*`）：
  - 原始递归、Ackermann 函数、超运算与 Knuth/Conway 大数记号；
  - Hardy 层级、快速增长层级与由序数基本列控制的增长率比较；
  - Goodstein 序列、Hydra 游戏及其与 `ε₀`、Peano 算术不可证性的边界；
  - Graham 数、TREE 函数、Busy Beaver 等典型大数的严格定义与已知比较；
  - 更强证明论序数和大基数相关记号仅在相应基础建立后加入，明确区分有限大数、
    无限基数和证明论强度三种概念。

### Phase 12 前沿分叉（X*）

交换代数、同调代数、代数拓扑、代数表示论、微分几何——各自前置达标后逐批细化。

---

## 7. 批次纳入节奏（沿用 INGESTION_PROTOCOL）

1. 每批开工：`.lean` 文件头写"本文件当前条目"清单（§0 铁律4），每条目一个 Entry（docstring 带 `> **Entry**: <id>`）。
2. 批内先后：行序严格（定义 → 基本性质 → 定理 → 应用）。
3. 每批验收：`lake build` 零错误；`check_axioms.py --all` 全过（缺 axioms 用 `--fix`）；`audit.py` 全过；RADAR 覆盖本次引用的每个 mathlib 名。
4. 批次提交：`git commit`，`"<阶段><批>: <主题>（<N> 条）+ 注册/RADAR"`。
5. 里程碑打勾：批次完成即更新本文件进度表。

---

## 8. 学完标准与科研论文下沉

### 8.1 阶段学完标准

1. 规划内该阶段所有批次条目 = `verified`，`audit.py` 全过，无 `sorry`。
2. 阶段末能力节点被后续阶段实际引用（`dependedOnBy` 非零）——"能干活"才真读完。
3. 该阶段 RADAR 组覆盖实际用到的每个 mathlib 名。

### 8.2 瘦身维护（Slimming，持续进行）

- **任务**：按 Playbook §4.1 逐条检查 RADAR 记录，把"证明体直接 `exact mathlib`"的
  结构性条目改写为本库推导。判定：结构性可推导 → 改；定义性/依赖 mathlib 内部结构 → 保留。
- **节奏**：每完成一批新条目后，回头扫一遍已注册条目的证明体，找出新的低垂果实。
  从 RADAR 一条一条检查，到该条"谁在用"的索引全部被本库条目替换掉，即完全解明。
- **意义**：学术论文的定理 mathlib 里没有，到时全得自己写。瘦身 = 培养论文定理自证能力。

### 8.3 科研论文定理下沉（第一阶段（抽象代数/线代/分析/拓扑）学完后即可开始）

1. 选论文定理：能用规划内 premise 表述为前提。
2. 走纳营协议五步；`premises` 必须指向库内 verified 条目。
3. 需未覆盖概念时先回落补一个规划内批次。
4. 论文条目同样计入 `dependedOnBy` 调用量。

> 守则：**前沿不是空中楼阁**——每个论文定理都有规划内地基可追溯，扩展速度与根基缺口成反比。

---

## 9. 进度表

| 阶段 | 批次 | 状态 |
|---|---|---|
| P1 | M1 数列极限 | ✅ |
| P1 | M2 函数极限 | ✅ |
| P1 | M3 连续函数 | ✅ |
| P1 | M4 导数 | ✅ |
| P1 | M5 中值/泰勒 | ✅ |
| P2 | L1-L4 线性代数（第一学期）| ✅ |
| P2 | L5 内积/谱 | 🔲（第二学期）|
| P3 | A1-A3 抽象代数第一学期（群+环+多项式环）| ✅ |
| P3 | A3.3-A3.4 域扩张/Galois + A4 模 | 🔲（第二学期）|
| P4 | T1-T3 点集拓扑 | ✅ |
| P4.5 | T4 同胚深化、同伦、同伦等价与基本群 | 🔲 |
| P5 | R1-R5 实分析（R1-R3、R5 及 R5.5 部分）| 🔶（进行中） |
| P6 | C0 复数基础 | ✅ |
| P6 | C0.5 代数学基本定理与复矩阵 Jordan 应用 | ✅ |
| P6 | C1-C3 复分析 | 🔲 |
| P7 | F1-F4 泛函分析 | 🔲 |
| P8 | Pr1-Pr3 概率论 | 🔲 |
| P9 | S1-S2 统计推断 | 🔲 |
| P10 | N1 初等数论 | 🔲 |
| P10 | N2 代数数论 | 🔲 |
| P10 | N3 解析数论 | 🔲（等待复分析） |
| P11 | ST1 序数理论 | 🔲 |
| P11 | ST2 基数理论 | 🔲 |
| P11 | ST3 Googology、递归与增长层级 | 🔲 |
| P12 | X* 前沿 | 🔲 |

### P12 后续分支：微分几何与代数拓扑

de Rham 上同调从数学分析 II 主线移至此分支，依赖顺序为：光滑流形与切/余切丛 →
流形上的微分形式、拉回与积分 → de Rham 复形及 `Hᵏ_dR` → 同伦不变性 →
de Rham 定理。它不阻塞欧氏空间上的 Poincaré 引理和 Green–Gauss–Stokes 公式。
