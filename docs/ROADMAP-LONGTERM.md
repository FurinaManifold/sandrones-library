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
| **Phase 4 点集拓扑** | `topology.*` | T1 T2 T3 | 集合论 + 分析线直观 |
| **Phase 5 实分析** | `real-analysis.*` | R1 R2 R3 R4 R5 | T3 + M 系列 |
| **Phase 6 复分析** | `complex-analysis.*` | C1 C2 C3 | R2 T3 M4 |
| **Phase 7 泛函分析** | `functional-analysis.*` | F1 F2 F3 F4 | A4 T3 R4 |
| **Phase 8 概率论** | `probability.*` | Pr1 Pr2 Pr3 | R4 |
| **Phase 9 统计推断** | `statistics.*` | S1 S2 | Pr |
| **Phase 10+ 前沿分叉** | 交换代数/同调/代数拓扑/表示论/微分几何… | X* | 各自分支前置达标 |

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
| 4 | `linear-algebra.eigen.jordan` | Jordan 标准形（理性/实矩阵） | `Matrix.JordanForm`、`exists_jordanForm` |

### L5 内积空间/正交/谱/二次型

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `linear-algebra.inner.def` | 内积定义、Cauchy-Schwarz | `InnerProductSpace`、`inner_mul_norm_le` |
| 2 | `linear-algebra.inner.orthogonal` | 正交、正交补、Gram-Schmidt | `orthogonal`、`orthogonalBasis`、`GramSchmidtOrthogonalization` |
| 3 | `linear-algebra.inner.self-adjoint` | 自伴算子 | `IsSelfAdjoint` |
| 4 | `linear-algebra.inner.spectral` | **谱定理**（实对称） | `isDiagonalizable`、`spectrum` 系 |
| 5 | `linear-algebra.inner.quadratic` | 二次型、双线性型 | `QuadraticForm`、`QuadraticForm.associated` |

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

## 5. Phase 4 — 点集拓扑（T1-T3）

> 家族前缀 `topology.`。

### T1 拓扑空间（开闭/邻域/连续/子商积）

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `topology.space.def` | 拓扑/开闭集定义 | `TopologicalSpace`、`IsOpen` |
| 2 | `topology.space.neighborhood` | 邻域/滤子 | `𝓝`、`nhds`、`Filter` |
| 3 | `topology.space.continuous` | 连续、点连续 ↔ 连续 | `Continuous`、`ContinuousAt`、`continuous_iff` |
| 4 | `topology.space.homeo` | 同胚 | `Homeomorph` |
| 5 | `topology.space.subspace` | 子空间/积/商拓扑 | `Subspace`、`Product`、`Quotient` |
| 6 | `topology.space.connected` | 连通/道路连通（导言） | `IsConnected`、`PathConnected` |

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

---

## 6. Phase 5+ — 实分析与后续（批次级，条目在批处理时按同粒度落地）

> 这四门及之后先列到"批次 + 核心定理清单"，具体条目 id 在每批开工时按 §0 铁律4 在文件头展开成与上表相同的表格。为什么不提前全部展开：这些批次量极大（R 有 5 批、后续每门数批），
> 现在列出可执行、可追踪、可逐条打勾的粒度；具体 theorem 名在批处理时结合 mathlib 现状定稿。

### Phase 5 实分析（R1-R5，测度 + Lebesgue 积分）

- **R1 测度**：σ-代数/可测空间、测度、外测度、Carathéodory 可测、正则测度。
- **R2 可测函数与积分**：可测函数、简单函数、非负可测函数积分（lintegral）、一般可积函数（integral）。
- **R3 收敛定理**：单调收敛、Fatou、控制收敛。
- **R4 乘积/Lᵖ**：乘积测度、Fubini/Tonelli、Lᵖ 空间与完备性。
- **R5 微分定理桥**：Lebesgue 微分定理、测度积分的微积分基本定理、与黎曼的关系。

### Phase 6 复分析（C1-C3）

全纯/柯西-黎曼 → 泰勒/洛朗/唯一性 → 复积分/残数定理。

### Phase 7 泛函分析（F1-F4）

赋范空间 → Banach（开映像/闭图/一致有界）→ Hilbert（Riesz/谱）→ 算子代数。

### Phase 8 概率论（Pr1-Pr3）

概率空间/随机变量/期望 → 独立性/条件期望/大数律 → 中心极限定理。

### Phase 9 统计推断（S1-S2）

估计（MLE/矩/充分性）→ 检验（似然比/Neyman-Pearson）与回归。

### Phase 10 前沿分叉（X*）

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

### 8.2 科研论文定理下沉（Phase 1-5 全部学完之后）

1. 选论文定理：能用规划内 premise 表述为前提。
2. 走纳营协议五步；`premises` 必须指向库内 verified 条目。
3. 需未覆盖概念时先回落补一个规划内批次。
4. 论文条目同样计入 `dependedOnBy` 调用量。

> 守则：**前沿不是空中楼阁**——每个论文定理都有规划内地基可追溯，扩展速度与根基缺口成反比。

---

## 9. 进度表

| 阶段 | 批次 | 状态 |
|---|---|---|
| P1 | M1 数列极限（9）| ✅ |
| P1 | M2 函数极限（13）| ✅ |
| P1 | M3 连续函数（12）| 🔲 |
| P1 | M4 导数（9）| 🔲 |
| P1 | M5 中值/泰勒（6）| 🔲 |
| P2 | L1-L5 线性代数 | 🔲 |
| P3 | A1-A4 抽象代数 | 🔲 |
| P4 | T1-T3 点集拓扑 | 🔲 |
| P5 | R1-R5 实分析 | 🔲 |
| P6 | C1-C3 复分析 | 🔲 |
| P7 | F1-F4 泛函分析 | 🔲 |
| P8 | Pr1-Pr3 概率论 | 🔲 |
| P9 | S1-S2 统计推断 | 🔲 |
| P10 | X* 前沿 | 🔲 |