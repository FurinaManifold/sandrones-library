# Sandrone's Library — 长远批次规划（数学大厦扩展蓝图）

> **定位**：本文件是 `ROADMAP-math-analysis.md` 的**超集**。
> 那份文档管"数学分析"这一门课的段落级蓝图；这份文档管**全库学科学科的先后顺序**，
> 以"批次（Batch）"为纳入单位，回答三件事：
>
> 1. **下一步学什么**：每一批的归属学科、覆盖主题、依赖前驱。
> 2. **为什么是这个顺序**：Lean/Opt 的数据现实（如积分的测度化、代数/拓扑的抽象层级）。
> 3. **什么时候"学完"**：批次级与阶段级的验收标准，以及"学完后再下沉科研论文"的机制。

---

## 0. 铁律（决定顺序的三条约束）

1. **依赖优先**：一个批次的每一条目，其 premises 必须已在库中 verified。
   批次顺序 = 数学依赖图 + mathlib 表达需求的线性化。
2. **mathlib 语言优先**：每个学科先用 mathlib 原生的抽象语言写（它能表达什么就按什么写），
   人话叙述层随后补。**mathlib 没有的 API 就停在"定义 + 一手性质"，不硬造结构**。
3. **先完整再前沿**：规划内学科全部达标（下文的"学完"标准）之后，才允许把科研论文定理
   作为新批次下沉——新定理必须有规划内条目的 premises 支撑。

---

## 1. 阶段与批次总览

> 记号：`M`=数学分析，`L`=线性代数，`A`=抽象代数，`T`=点集拓扑，
> `R`=实分析（测度与积分），`C`=复分析，`F`=泛函分析，`X`=后续学科。

| 阶段 | 批次 | 主题 | mathlib 主力语言 | 前驱 |
|---|---|---|---|---|
| **Phase 1 分析线** | M1 ✅ | 数列极限（9 条，已完） | Tendsto/atTop/𝓝 | — |
| | M2 ✅ | 函数极限（13 条，已完） | Tendsto/𝓝[≠] | M1 |
| | M3 | 连续函数 | Continuous/IsCompact | M2 |
| | M4 | 导数 | HasDerivAt | M3 |
| | M5 | 微分中值定理与泰勒 | exists_deriv / Taylor | M4 |
| **Phase 2 线性代数** | L1 | 向量空间/子空间/基/维数 | Submodule/Basis/finrank | 集合论预备 |
| | L2 | 线性映射/矩阵/秩 | LinearMap/Matrix/rank | L1 |
| | L3 | 行列式 | det | L2 |
| | L4 | 特征值/相似/对角化 | eigenvalues/eigenvector | L2, L3 |
| | L5 | 内积空间/正交/谱/二次型 | InnerProdSpace/Diagonalization | L3, L4 |
| **Phase 3 抽象代数** | A1 | 群/子群/陪集/商群/同态 | Subgroup/NormalSubgroup/QuotientGroup | 集合论/等价关系 |
| | A2 | 环/理想/商环/整环/域 | Ideal/Subring/Quotient | A1 |
| | A3 | 多项式环/域扩张/Galois 初步 | Polynomial/IsGalois | A2 |
| | A4 | 模/子模/商模/同态定理 | Submodule/QuotientModule | A1, A2 |
| **Phase 4 点集拓扑** | T1 | 拓扑空间/开闭/连续/邻域 | TopologicalSpace/IsOpen | 集合论 + M3(直观) |
| | T2 | 紧致/连通/分离公理/商/积 | IsCompact/IsConnected/T2Space | T1 |
| | T3 | 度量空间/完备性/完备化 | MetricSpace/UniformSpace | T1, M 系列 |
| **Phase 5 实分析** | R1 | 测度/外测度/σ 代数/可测集 | MeasureTheory | T3 + M 系列 |
| | R2 | 可测函数/Lebesgue 积分 | MeasureTheory.lintegral/integral | R1 |
| | R3 | 收敛定理（单调/控制/Fatou） | MeasureTheory 收敛三兄弟 | R2 |
| | R4 | 乘积测度/Fubini/Lᵖ/完备化 | MeasureTheory.prod/Lp | R3 |
| | R5 | 微分定理/与黎曼的桥 | 测度积分 vs 微积分基本定理 | R3, M5 |
| **Phase 6+ 后续学科** | C1-C3 | 复分析（全纯/级数/残数） | Complex/ContDiff/Normed 族 | R2 + T3 |
| | F1-F4 | 泛函分析（赋范/Banach/Hilbert/算子） | NormedSpace/Banach/Hilbert/operator | A4, T3, R4 |
| | R6+ | 概率论（概率空间/随机变量/期望） | MeasureTheory.Probability | R4 |
| | S1+ | 统计推断（估计/检验/回归） | Probability 族 + 分析 | R6+ |
| | X1+ | 交换代数/同调代数/代数拓扑/代数表示论/微分几何… | 各学科 mathlib 模块 | 分叉前置达标后 |

---

## 2. 批次详情（每批：目标 / 条目 / mathlib / 里程碑）

### Phase 1：分析线（进行中，M1-M2 已完成）

- **M3 连续函数**：定义（点连续 ↔ 序列连续）、四则、复合、介值定理、最值定理、一致连续、反函数连续。
  mathlib：`ContinuousAt`、`continuous_iff`、`Continuous.comp/add`、`intermediate_value_Icc`、`isCompact.exists_forall_ge`、`UniformContinuous`。
  里程碑：**"库能表达连续函数论"**——库第一次"能干活"，M5 全部就绪。
- **M4 导数**：定义、四则、链式、反函数求导。
  mathlib：`HasDerivAt`、`HasDerivAt.add/mul/div/comp/inverse`。
- **M5 微分中值定理与泰勒**：Rolle、Lagrange、Cauchy MVT、L'Hôpital、Taylor（含余项）。
  mathlib：`exists_deriv_eq_zero`、`exists_hasDerivAt_eq_slope`、`exists_deriv_eq_mvt`、`Taylor`。
  > 注：一元 Riemann 积分**不在此线推进**——放到 Phase 5 实分析，用数学读成 Lebesgue 积分。

### Phase 2：线性代数

> 前驱：集合论预备（第一章）+ 抽象语言基础。mathlib 的线性代数抽象在模（Module）上，
> 向量空间是系数为域的模，叙述层需先做"域上模 = 向量空间"这个翻译。

- **L1 向量空间/子空间/基/维数**：定义、子空间、生成、线性无关、基的存在、维数。
  mathlib：`Module`、`Submodule`、`Basis`、`finrank`、`exists_basis`、`Module.finrank_eq_card_basis`。
- **L2 线性映射/矩阵/秩**：线性映射、同构、核/像、矩阵表示、秩。
  mathlib：`LinearMap`、`Matrix`、`rank`、`LinearMap.ker/range`、`rank_eq_card` 系。
- **L3 行列式**：定义、展开、乘性、可逆判据、N 微元形式。
  mathlib：`det`、`det_mul`、`det_ne_zero_iff`、`Matrix.det`。
- **L4 特征值/相似/对角化**：特征子空间、特征多项式、Jordan 块、对角化判据。
  mathlib：`eigenvalues`、`Module.End.eigenvector`、`Matrix.det`（特征多项式）。
- **L5 内积空间/正交/谱/二次型**：内积、正交基、Gram-Schmidt、谱定理、二次型与附表。
  mathlib：`InnerProdSpace`、`orthonormalBasis`、`IsSelfAdjoint`、`GramSchmidtOrthogonalization`、`QuadraticForm`。

### Phase 3：抽象代数

> 前驱：等价关系/商集（第一章已备）+ 集合论。mathlib 把抽象代数做在 Typeclass 上
> （`Group`、`Ring`、`Module`…），子结构用结构体（`Subgroup`、`Ideal`…）。

- **A1 群**：定义、子群、陪集、Lagrange、正规子群、商群、同态/同构定理。
  mathlib：`Group`、`Subgroup`、`Subgroup.card_mul_finset_card`、`NormalSubgroup`、`QuotientGroup`、`MonoidHom`。
- **A2 环**：定义、子环、理想、商环、整环/域、素理想/极大理想。
  mathlib：`Ring`、`Subring`、`Ideal`、`Ideal.quotient`、`IsDomain`、`IsField`、`Ideal.IsPrime/Maximal`。
- **A3 多项式与域扩张**：多项式环、整除、不可约、扩域、代数扩张、Galoiss 对应初步。
  mathlib：`Polynomial`、`IrreduciblePolynomial`、`IntermediateField`、`IsGalois`、`AdjoinRoot`。
- **A4 模**：定义（在 L 里已用过 Submodule/Module，这里系统化）、子模、商模、同态定理、自由模/射影模。
  mathlib：`Module`、`Submodule.map/ker`、`Module.quotient`、`Module.free`、`Module.Projective`。

### Phase 4：点集拓扑

> **先拓扑后实分析**：测度论需要拓扑/可测空间语言（Borel σ 代数），所以拓扑在实分析之前。

- **T1 拓扑空间**：开/闭/邻域/连续/同胚、子空间/积空间/商空间、滤子与网。
  mathlib：`TopologicalSpace`、`IsOpen`、`Continuous`、`Homeomorph`、`SeparatingSet`、`Filter`。
- **T2 紧致/连通/分离**：紧致性（有限覆盖/序列紧/滤子紧等价）、连通/道路连通、T1/T2/正则/正规。
  mathlib：`IsCompact`、`CompactSpace`、`IsConnected`、`PathConnected`、`T2Space`、`NormalSpace`。
- **T3 度量空间与完备性**：度量、开球、一致连续、Cauchy/完备、完备化。
  mathlib：`MetricSpace`、`UniformSpace`、`UniformContinuous`、`Metric.CauchySeq`、`UniformSpace.Completion`。

### Phase 5：实分析（测度与积分）

> **为什么这里转"实分析"而不是教材的黎曼积分**：mathlib 内置的积分是**一般测度理论的积分**
> （`MeasureTheory` 的勒贝格积分），不是黎曼积分。与其为黎曼积分重建一整套与库语言脱节的装置，
> 不如直接学测度论顺流而下的勒贝格积分——它覆盖了黎曼可积的几乎全部应用（微积分基本定理、
> 换元、收敛定理），且是概率论/泛函分析的地基。

- **R1 测度**：σ-代数、测度、外测度、Carathéodory 可测、正则测度。
  mathlib：`MeasurableSpace`、`MeasureTheory.Measure`、`Measures.ext`、`OuterMeasure`、`Caratheodory`。
- **R2 可测函数与积分**：可测函数、简单函数、非负可测函数的积分（lintegral）、一般可积函数（integral）。
  mathlib：`Measurable`、`SimpleFunc`、`MeasureTheory.lintegral`、`MeasureTheory.integral`、`LEstLp`。
- **R3 收敛定理**：单调收敛、Fatou、控制收敛。
  mathlib：`ltH`/`lintegral_monotone_convergence`、`lintegral_liminf`、`integral_limsup`（控制收敛）。
- **R4 乘积测度/Lᵖ/Fubini**：乘积 σ-代数、Fubini/Tonelli、Lᵖ 空间与完备性。
  mathlib：`MeasureTheory.prod`、`MeasureTheory.measure_prod`、`MeasureTheory.integral_prod`、`Lp`、`Lp.normedSpace`。
- **R5 微分定理与桥**：Lebesgue 微分定理（密度点、Vitali）、测度积分的微积分基本定理、
  与黎曼积分的关系（勒贝格可积黎曼可积 ⟹ 值相等）。
  mathlib：`DifferentiableOn`/`HasDerivAt` 的积分形式（`measureSpace`+`integral_deriv_eq_sub`）与
  `intervalIntegral`（作为"区间上的 Lebesgue 积分"）。

### Phase 6+：后续学科（按批次推进，含方向参考）

- **C 复分析**（C1 全纯/柯西-黎曼·C2 级数/泰勒/洛朗·C3 残数定理）：`Complex`、`DifferentiableOn`、
  `integral_line_integral`、`Complex.deriv`、`goursat`、`residue 系`。前驱：R2、T3、M4。
- **F 泛函分析**（F1 赋范空间·F2 Banach·F3 Hilbert·F4 算子）：`NormedSpace`、`BanachSpace`、
  `InnerProductSpace`、`ContinuousLinearMap`；前驱：A4、T3、R4。
- **Pr 概率论**（概率空间/随机变量/期望/大数律/中心极限）：`MeasureTheory.ProbabilityMeasure`、
  `ProbabilityMassFunction`、`∫ x, ⋯ ∂μ`（期望）；前驱：R4。
- **St 统计推断**（估计/检验/回归）：概率族 + 分析族；前驱：Pr。
- **X 代数拓扑/交换代数/同调代数/代数表示论/微分几何**：各自 mathlib 模块；
  首批分叉前驱：代数拓扑→T2+A3；交换代数→A3+A2；同调→A4+A2；表示论→A4+L5；微分几何→T3+M4+R2。

---

## 3. 批次纳入节奏（沿用 `INGESTION_PROTOCOL.md`）

1. **每批开工前**：在该学科的 `.lean` 文件头写下"本文件当前条目"清单（§3.11）；
   每一条目一个（Entry, docstring 带 `> **Entry**: <id>`）。
2. **批内的先后**：行序严格（定义 → 基本性质 → 定理 → 应用）。
3. **每批验收**：`lake build` 零错误；`check_axioms.py --all` 全过；`audit.py` 全过；
   缺 axioms 用 `--fix` 回填；RADAR 覆盖本次引用的每个 mathlib 名。
4. **批次提交**：`git commit`，message 用 `"<阶段><批号>: <主题>（<N> 条）+ 注册/RADAR"`。
5. **里程碑打勾**：批次完成即更新本文件的进度表。

---

## 4. "学完"标准与科研论文下沉

### 4.1 学完标准（阶段级）

一个**阶段**（如 Phase 2 线性代数）标记"学完"，要求：

1. 该阶段规划内所有批次 = `verified`，且 `audit.py` 全过、无 `sorry`。
2. 阶段末的**能力节点**被后续阶段实际引用过（dependedOnBy 非零）——
   "能干活"才算真的读完。
3. 与该阶段相关的 RADAR 组（G1-G11 及后续新增组）覆盖了实际用到的每个 mathlib 名。

### 4.2 科研论文定理下沉（Phase 规划完成之后）

当 Phase 1-5 全部"学完"（分析线 + 线代 + 抽象代数 + 拓扑 + 实分析），库的能力底座已覆盖
大一到大三的完整主线。此刻允许开始：

1. **选论文**：从已达标学科的顶会/期刊（或 arXiv）抽定理，需能用规划内 premise 表述为前提。
2. **走纳营协议**：与教材条目完全相同的五步流程；`premises` 必须指向库内已 verified 条目。
3. **新增依赖链**：若论文定理需要规划内未覆盖的概念，先回落补一个规划内批次，再回来。
4. **价值统计**：论文条目同样计入 `dependedOnBy` 调用量，衡量"前沿定理的复用度"。

> 这条守则保证了：**前沿不是空中楼阁**——每个论文定理都有规划内的地基可追溯，
> 库的扩展速度与根基缺口成反比。

---

## 5. 进度表

| 阶段 | 批次 | 状态 | 备注 |
|---|---|---|---|
| Phase 1 | M1 数列极限 | ✅ verified（9 条） | 第三章第一批/第二批 |
| Phase 1 | M2 函数极限 | ✅ verified（13 条） | 第四章第一批 |
| Phase 1 | M3 连续函数 | 🔲 待办 | 下一批 |
| Phase 1 | M4 导数 | 🔲 | |
| Phase 1 | M5 微分中值/泰勒 | 🔲 | |
| Phase 2 | L1-L5 线性代数 | 🔲 | |
| Phase 3 | A1-A4 抽象代数 | 🔲 | |
| Phase 4 | T1-T3 点集拓扑 | 🔲 | |
| Phase 5 | R1-R5 实分析 | 🔲 | 测度/勒贝格积分 |
| Phase 6+ | C/F/Pr/St/X | 🔲 | 分批推进 |