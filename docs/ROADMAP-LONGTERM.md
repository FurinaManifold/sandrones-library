# Sandrone's Library — 长远批次规划（数学大厦扩展蓝图）

> **定位**：本文件是 `ROADMAP-math-analysis.md` 的**超集**。那份文档管"数学分析（分析线）"
> 的章节蓝图；这份文档管**全库学科前后顺序**，并把每一门课拆成**批次**，每批拆到
> **具体定理条目**（粒度 = 现在"第四章第一批：函数极限基础 13 条"那么细致）。
>
> 每批都沿着 `INGESTION_PROTOCOL.md` 和 `LEAN-PLAYBOOK.md` 走：`.lean` 文件头列条目清单 →
> 逐条（Entry/docstring）→ 子 Agent 模块编译 → 学科负责人依赖闭包与联合导入验收 → 学科提交。
> main 合并各学科交付后统一执行 Registry/RADAR/ROADMAP、`check_axioms --fix`、`audit.py` 和
> 一次全库 `lake build`，再作独立集成提交。
>
> 一个"条目"是一个可验证的结论（一个 lemma/theorem/def + 一个叙述层 `.md` + 一条 registry 记录），
> 不是一堆结论的打包。下表把每批列到条目级，写计划的人与实现的人都应能指着条目名说"这条是否已 verified"。

---

## 0. 铁律（决定顺序）

1. **依赖优先**：每批的每个条目的 `premises` 必须已在库中 verified。批次顺序 = 数学依赖图 + mathlib 表达需求的线性化。
2. **教材定义优先、Mathlib 桥显式**：新概念先给本库教材定义和一手性质，再说明 Mathlib 结构是
   公开承载、实现桥还是证明后端。没有合适 API 时停在“定义 + 一手性质”，不能直接暴露更强结构冒充课程定义。
3. **先完整再前沿**：规划内阶段达到 §15 的“学完”标准后，才允许把科研论文作为新批次下沉。

---

## 1. 阶段顺序总览

| 阶段 | 课程（家族前缀） | 批次 | 前驱 |
|---|---|---|---|
| **Phase 1 分析线** | `analysis.*` | M1✅ M2✅ M3✅ M4✅ M5✅ | — |
| **Phase 2 线性代数** | `linear-algebra.*` | L1-L7✅ | 集合论预备 |
| **Phase 3 抽象代数** | `abstract-algebra.*` | A1✅ A2🚧 A3🚧 | 等价关系/商集 |
| **Phase 4 拓扑学基础** | `topology.*` | T1-T3✅ T4🔲 | 集合论 + 分析线直观 |
| **Phase 5 实分析** | `real-analysis.*` | R1-R4✅ R5🚧 R6🚧 | T3 + M 系列 |
| **Phase 6 复分析** | `complex-analysis.*` | C0/C0.5✅ C1🚧 C2-C3🔒 | R2 T3 M4 |
| **Phase 7 泛函分析** | `functional-analysis.*` | F1🚧 F2-F4🔒 | L5 T3 R4 |
| **Phase 8 概率论** | `probability.*` | Pr1🚧 Pr2-Pr3🔒 | R4 |
| **Phase 9 统计推断** | `statistics.*` | S1-S2🔒 | Pr1/Pr3 |
| **Phase 10 数论分支** | `number-theory.*` | N1✅ N2🔒 N3🔒 | A2/A3；N3 另需 C1-C3 |
| **Phase 11 集合论深化** | `set-theory.*` | ST1✅ ST2🚧review ST3🚧staging | 集合/关系/Zorn；ST3 另需可计算性 |
| **Phase 12+ 前沿分叉** | 交换代数/同调/代数拓扑/表示论/微分几何… | X1-X6🔒 | 各自分支前置达标 |

**状态单一来源**：本表是全库阶段状态的唯一摘要；各章节只给条目级范围与边界，不另建第二张
阶段进度表。✅ 只表示已进入 main、Registry 为 verified 且 main 全库验收通过；`staging`、
`review` 和未跟踪成果一律记 🚧，不能提前算完成。状态变化由 main 在集成提交中同时更新本表和
对应章节，不允许只改其中一处。

**为什么实分析在拓扑之后、且用测度积分**：测度论需要 σ-代数/可测空间（拓扑的抽象层）；
而 mathlib 内置积分是**一般测度的 Lebesgue 积分**，不是黎曼积分——所以一元微积分只做到导数/中值，
积分本体放到 R 用测度积分承载（覆盖黎曼的微积分基本定理/换元/收敛定理，且是概率/泛函的地基）。

### 1.1 多学科并行生产路线（main 调度基线）

本节是后续开工的权威调度表。章节清单回答“最终要学什么”，本节回答“下一轮谁先做什么、
可以怎样拆给子 Agent、何时允许进入 main”。状态含义：✅ 已完成，🚧 可立即开工，
🔒 等待依赖门，🔲 尚未排入当前两个波次。

#### 角色与容量

- **main 负责人**：维护本表、分配文件所有权、检查 worktree 和提交边界、接收 handoff、更新共有
  imports/Registry/RADAR/ROADMAP，并对一组已接收学科提交只运行一次全库验收。main 原则上不与
  学科负责人同时开发同一学科源码。
- **学科负责人**：每人维护一个学科 staging 分支；可派 2–3 个子 Agent，每个子 Agent 只拥有一组
  `.lean` 文件及对应 `docs/entries/<family>/`。负责人亲自审核定义层、数学陈述、公开签名、证明、
  文档和依赖闭包，并收敛成一个 handoff。
- **子 Agent**：优先领取 4–10 个强相关条目，避免一个 Agent 横跨两个家族或修改共有文件。
  若一个批次有公共定义，先由“定义层 Agent”交付并经负责人组装验收，再并行启动上层证明。
- **默认并发上限**：一个学科负责人加至多三个子 Agent；main 可同时接收多个学科 staging，
  但同一轮只指定一个共有文件写者。机器资源不足时优先保留 Lean 编译，文档审核可串行。

#### 当前依赖门

| 门 | 开门条件 | 解锁工作 | 当前状态 |
|---|---|---|---|
| G-A2 | A2.2–A2.9 的理想、整除、PID/UFD、CRT、局部化完成 | A3 深层、N2.1–N2.3 | 🚧 |
| G-A3 | 域扩张、次数、分裂域、可分/正规扩张完成 | Galois、N2 数域主线 | 🚧 |
| G-C | C1–C3 的全纯、复积分、解析延拓与残数接口完成 | N3.2–N3.5 | 🚧 |
| G-Pr | Pr1 概率空间、随机变量、期望和独立性完成 | Pr2、统计 S1 | 🚧 |
| G-ST | ST2 已审核接口进入 main，并另建可计算性定义层 | ST3 深层增长/不可计算性 | 🚧（ST2 Round 2） |
| G-N1+ | 连分数最佳逼近必要方向及 `√d`—Pell 桥完成 | N1 专题扩展；不阻塞 N2 | 🔲 |

依赖门只由 main 在验收对应 handoff 后改为 ✅。存在相近 Mathlib 文件或一条强定理不等于开门；
必须已有本库教材定义、显式实现桥、课程文档和 verified Registry 条目。

#### Wave A：现在立即并行（五名学科负责人）

| 优先级 | 学科 staging | 负责人总目标 | 建议子 Agent 切分 | 出口条件 |
|---|---|---|---|---|
| P0 | A2 环论 | 补齐 A2.2–A2.9，打开 G-A2 | A2-I 理想和同构定理；A2-D 整除/Euclidean/PID/UFD；A2-C CRT/局部化 | 8 个课程入口完整；A3/N2 可只依赖本库 A2 API |
| P0 | C1 复微分 | 全纯、复可微、Cauchy–Riemann 与幂级数入口 | C1-D 定义/代数；C1-CR Cauchy–Riemann；C1-P 局部幂级数 | 为 C2 复积分提供稳定公开签名 |
| P1 | F1 泛函基础 | 赋范空间、连续线性映射、Banach 基础 | F1-N 赋范/Banach 定义；F1-L 连续线性算子；F1-S 级数与完备性 | 不提前引用开映射/闭图定理 |
| P1 | Pr1 概率基础 | 概率空间、随机变量、分布、期望、独立性 | Pr1-M 概率测度；Pr1-R 随机变量/分布；Pr1-E 期望/独立 | 打开 G-Pr，且所有概率概念先有本库定义层 |
| P1 | ST2/ST3 返工 | 完成 Round 2 文档同步并收敛 staging | ST2 三篇文档；ST3 首批边界复核 | main 接收后才推进 G-ST |

Wave A 的学科负责人应先提交 1 页设计说明，冻结公开定义和文件分片；main 确认没有跨学科签名冲突后，
子 Agent 才进入证明阶段。A2 和 C1 是关键路径，main 优先审核它们的 handoff。

#### Wave B：依赖满足即可启动，不必等待 Wave A 全部结束

| 启动条件 | 学科 staging | 批次与子 Agent 包 | 关键出口 |
|---|---|---|---|
| A2-I 完成 | A3 多项式 | A3-P1 多项式定义/除法；A3-P2 不可约判据；A3-P3 分解/重根 | A3.1–A3.4 全部转正 |
| C1 完成 | C2 复积分 | C2-I 路径积分；C2-C Cauchy 定理/公式；C2-A 解析性与唯一性 | 打开 Laurent/残数路线 |
| F1 完成 | F2 Banach 定理 | 一致有界；开映像；闭图与逆算子 | 三大定理分别独立文件，公共 Baire 接口先行 |
| Pr1 完成 | Pr2 概率极限定理 | 条件期望；大数律；中心极限定理前置 | S1 只在期望/方差/分布接口稳定后启动 |
| ST2/ST3 首批进入 main | ST3 深层 | 原始递归函数类；Goodstein 完整状态；可计算性定义 | 支配、终止、不可计算性仍受定义门控制 |
| main 有空闲审核槽 | T4 代数拓扑入口 | 道路/同伦；同伦等价；基本群；教材例子 | 圆周基本群若 Mathlib 缺桥则明确降级，不伪造闭环 |

#### Wave C：受门控的纵深工作

| 门 | 后续学科路线 | 第一批可执行目标 | 禁止越界 |
|---|---|---|---|
| G-A2 + G-A3 | N2 代数数论 | N2.1 数域/代数整数；N2.2 范数迹判别式；N2.3 整数环与整基 | 未有 Dedekind/分式理想定义前，不登记类群和唯一分解 |
| G-C | N3 解析数论 | N3.1 算术函数可提前独立做；开门后做 Dirichlet 级数、ζ、Euler 乘积 | 素数定理必须有复分析依赖链，不以单条 Mathlib 定理包装代替课程证明 |
| G-Pr | S1 统计推断 | 分布族、估计量、偏差/方差、矩估计与 MLE 定义 | 不在测度/可测性前提不清时使用非正式“密度最大化” |
| G-ST | ST3 递归与增长 | 原始递归、Ackermann、序数记号、基本列 | Goodstein 状态编码完成前，不把 ST1 的下降接口宣称为 Goodstein 定理 |
| G-N1+ | N1 扩展 | 最佳逼近必要方向、周期连分数、`√d`—Pell、全体正解分类 | 负 Pell 与可解性必须单列，不由正 Pell 结果暗示 |

#### 每个学科 handoff 必须回答的路线问题

除 Playbook 规定字段外，`docs/handoffs/<subject>-<batch>.md` 必须增加以下六项：

1. 本批打开或依赖哪个门；若不开门，说明它推进了门的哪一部分。
2. 公共定义由哪个文件拥有，哪些 Mathlib 名称只是私有桥或证明后端。
3. 子 Agent 的精确文件所有权、提交号，以及负责人实际退回修改过的问题。
4. 本批联合导入测试包含哪些模块和关键 `#check`。
5. 下一批可以稳定依赖的公开 API，以及明确不能依赖的未完成接口。
6. 建议 main 更新的 imports、Registry、RADAR、ROADMAP 状态和诚实边界。

#### main 的滚动集成节奏

- **接收窗口**：按“已通过学科审核”而非按 Agent 完成时间接收；关键路径 A2/C1 优先。
- **小批集成**：一次接收 1–3 个互不冲突的学科 handoff；先语义 diff，再更新共有文件。
- **验收复用**：每个学科已通过局部闭包和联合导入，main 不重复这些证明探索；main 负责生成器、
  全量公理审计、全库 audit 和一次全库 build。
- **状态推进**：只有集成提交落在 main 且完整验收通过，表中的 🚧/🔲 才能改成 ✅；仅存在于
  子分支或 staging 的内容继续记为进行中。
- **失败回退**：数学或定义层问题退回对应学科负责人；共有文件冲突由 main 语义合并；其他学科
  的无关 linter 警告记录但不混入当前修复提交。

---

## 2. Phase 1 — 分析线（M1-M5 ✅）

> 家族前缀 `analysis.`；命名示例：`analysis.continuity.definition`、`analysis.derivative.chain-rule`。

### M1 数列极限 ✅（已完，9 条）

`analysis.sequence.definition`、`.unique`、`.bounded`、`.squeeze`、`.monotone-convergence`、
`.subsequence`、`.bolzano-weierstrass`、`.cauchy`、`.liminf-limsup`；
`analysis.completeness.*`（nested-intervals / finite-cover / accumulation-point + 等价环 6 条）归入本批的完备性扩展。

### M2 函数极限 ✅（已完，13 条）

`analysis.func-limit.definition`、`.const`、`.identity`、`.unique`、`.congr`、`.add`、`.sub`、`.mul`、
`.div`、`.const-mul`、`.le`、`.heine`、`.at-top`。

### M3 连续函数 ✅

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

### M4 导数 ✅

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

### M5 微分中值定理与泰勒 ✅

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

## 3. Phase 2 — 线性代数（L1-L7 ✅）

> 家族前缀 `linear-algebra.`。mathlib 线性代数是模语言（`Module`/`Submodule`/`Basis`），
> 向量空间 = 系数为域（`Field`）的模。叙述层先做"域上模 = 向量空间"翻译。

### L1 向量空间（基质/子空间/基/维数）✅

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `linear-algebra.vector-space.def` | 向量空间定义（域上模实例） | `Module` |
| 2 | `linear-algebra.vector-space.subspace` | 子空间：包含/closure 判据 | `Submodule`、`Submodule.mem_span` |
| 3 | `linear-algebra.vector-space.span` | 生成子空间 | `Submodule.span` |
| 4 | `linear-algebra.vector-space.independent` | 线性无关 | `LinearIndependent` |
| 5 | `linear-algebra.vector-space.basis` | 基：存在性与张成 | `Basis`、`exists_basis` |
| 6 | `linear-algebra.vector-space.dimension` | 维数 | `Module.finrank`、`Module.finrank_eq_card_basis` |

### L2 线性映射/矩阵/秩 ✅

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `linear-algebra.maps.map` | 线性映射、核/像 | `LinearMap`、`LinearMap.ker/range/map` |
| 2 | `linear-algebra.maps.iso` | 线性同构与维数同构定理 | `LinearEquiv`、`finrank_eq` |
| 3 | `linear-algebra.maps.matrix` | 矩阵表示、复合=矩阵乘 | `Matrix`、`LinearMap.toMatrix`、`Matrix.mul_assoc` |
| 4 | `linear-algebra.maps.rank` | 秩、秩-零度定理 | `rank`、`rank_comp_le`、`rank_add_le` |
| 5 | `linear-algebra.matrix.symmetric` | 对称矩阵、反对称矩阵及标准分解 | `Matrix.IsSymm`、`Matrix.transpose` |

### L3 行列式 ✅

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `linear-algebra.det.def` | 行列式定义 | `Matrix.det` |
| 2 | `linear-algebra.det.mul` | 积的行列式 | `det_mul` |
| 3 | `linear-algebra.det.invertible` | 可逆 ⟺ det≠0 | `det_ne_zero_iff`、`isUnit_iff` |
| 4 | `linear-algebra.det.likeness` | 转置/行列展开 | `det_transpose`、`Matrix.det_apply` |

### L4 特征值/相似/对角化 ✅

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `linear-algebra.eigen.eigenvalue` | 特征值/特征向量定义 | `Module.End.HasEigenvalue`、`HasEigenvector` |
| 2 | `linear-algebra.eigen.characteristic` | 特征多项式、特征子空间维数 | `Matrix.charpoly` |
| 3 | `linear-algebra.eigen.similar` | 相似变换、对角化判据 | `Matrix.Similar`、`IsDiagonalizable` |
| 4 | `linear-algebra.eigen.jordan` | 代数闭域上的 Jordan 标准形与矩阵相似形式 | 本库自建 Jordan 链、块对角矩阵与换基接口 |

### L5 内积空间/正交/谱/二次型 ✅

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `linear-algebra.inner.def` | 内积定义、Cauchy-Schwarz | `InnerProductSpace`、`inner_mul_norm_le` |
| 2 | `linear-algebra.inner.orthogonal` | 正交、正交补、Gram-Schmidt | `orthogonal`、`orthogonalBasis`、`GramSchmidtOrthogonalization` |
| 3 | `linear-algebra.inner.self-adjoint` | 自伴算子 | `IsSelfAdjoint` |
| 4 | `linear-algebra.inner.spectral` | **谱定理**（实对称） | `isDiagonalizable`、`spectrum` 系 |
| 5 | `linear-algebra.inner.quadratic` | 二次型、双线性型 | `QuadraticForm`、`QuadraticForm.associated` |

### L6 保结构矩阵与经典矩阵群 ✅

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `linear-algebra.matrix.orthogonal-unitary` | 正交矩阵、酉矩阵、共轭转置、逆矩阵公式、行列式模长与正交/酉群 | `Matrix.unitaryGroup`、`Matrix.conjTranspose`、`Matrix.mem_unitaryGroup_iff` |
| 2 | `linear-algebra.matrix.normal` | 正规矩阵、Hermitian/斜 Hermitian 矩阵及复谱定理 | `IsStarNormal`、`IsSelfAdjoint`、复内积空间谱理论 |
| 3 | `linear-algebra.matrix.symplectic` | 标准辛形式、辛矩阵 `AᵀJA=J`、乘法与逆封闭、行列式为一 | `Matrix.symplecticGroup`、`Matrix.mem_iff'`、`Matrix.det_eq_one` |
| 4 | `linear-algebra.symplectic.basis` | 辛正交补、辛基与有限维线性 Darboux 定理 | `AlternatingMap`、`BilinForm`、辛空间接口 |

### L7 矩阵分解与数值线性代数基础 ✅

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `linear-algebra.decomposition.elimination` | 初等行变换、阶梯形、秩与高斯消元 | `Matrix.rowOperation`、可逆初等矩阵 |
| 2 | `linear-algebra.decomposition.lu` | LU/LDU 分解的存在条件与唯一性；任意可逆矩阵的 PLU 分解 | mathlib 现有矩阵分块接口，不足处本库构造消元过程 |
| 3 | `linear-algebra.decomposition.qr` | 满列秩矩阵的薄 QR、方阵 QR、对角元规范化后的唯一性 | Gram–Schmidt、`Orthonormal`、矩阵等距接口 |
| 4 | `linear-algebra.decomposition.cholesky` | 实对称/复 Hermitian 正定矩阵的 Cholesky 分解及唯一性 | 正定矩阵与三角矩阵接口 |
| 5 | `linear-algebra.decomposition.schur` | 复方阵的酉 Schur 三角化；实 Schur 准三角形式 | 复谱理论、酉基与不变子空间 |
| 6 | `linear-algebra.decomposition.svd` | 奇异值分解、奇异值与秩/核/算子范数、低秩逼近前置 | `singularValues`、伴随与正算子谱定理 |
| 7 | `linear-algebra.decomposition.polar` | 方阵及线性算子的极分解，正半定因子与部分等距因子 | `Isometry`、正平方根、伴随 |
| 8 | `linear-algebra.decomposition.pseudoinverse` | Moore–Penrose 伪逆、最小二乘正规方程与最小范数解 | SVD、正交投影 |

### 线性代数已完成补遗（不重复 L4/L6/L7 条目）

| 顺序 | 条目 | 缺失内容 | 状态 |
|---|---|---|---|
| 1 | `linear-algebra.maps.basic` | 核/像判据、单射/满射、线性同构与维数保持、第一同构定理 | ✅ |
| 2 | `linear-algebra.coordinates.change-basis` | 坐标映射、过渡矩阵、换基公式、相似矩阵表示同一算子 | ✅ |
| 3 | `linear-algebra.vector-space.sum-quotient` | 子空间和、直和、商空间及维数公式 | ✅ |
| 4 | `linear-algebra.eigen.diagonalization` | 特征基判据、几何/代数重数、Cayley–Hamilton、最小多项式 | ✅ |
| 5 | `linear-algebra.inner-product` | 内积、正交补、Gram–Schmidt、伴随与自伴 | ✅ |
| 6 | `linear-algebra.spectral-quadratic` | 实对称谱定理、正交对角化、二次型与惯性定律 | ✅ |
| 7 | `linear-algebra.tensor-exterior` | 对偶基、张量基、外幂分次与维数公式 | ✅ |

---

## 4. Phase 3 — 抽象代数（A1-A3）

> 家族前缀 `abstract-algebra.`。mathlib 用 Typeclass（`Group`/`Ring`/`Module`）+ 子结构
> （`Subgroup`/`Ideal`/`Subring`）。先集合论/等价关系已备。
>
> **学期分界**：第一学期 = A1 群 + A2 环 + A3 的多项式环部分（A3.1-A3.2，域扩张前置）；
> 第二学期 = A3 域扩张/Galois。分界依据：经典近世代数一学期内容
> 即群论+环论（含多项式环），域扩张/Galois 与模需要更多抽象背景，与 L 线"第一学期基础结构、
> 第二学期深层理论"的惯例一致。
>
> **阶段语言可用性**：抽象代数阶段，mathlib 的 `Group`/`Subgroup`/`MonoidHom`/`Ring`/`Subring`/
> `Ideal`/`Polynomial` 等**教材结构直接可出现在签名**（学到什么用什么）；但 **`Module` 仍不允许**。
> 模论不属于本阶段，统一留到未来交换代数批次；线性代数继续用 `LinearSpace` 承载。

### A1 群 ✅

> A1 的十二个课程入口均已进入 main，覆盖子群、陪集、循环群、商群、同构定理、群作用、
> 置换群、Sylow 理论和有限生成交换群；更深有限群分类不属于 A1 完成范围。

| # | 条目 | 内容 | 状态 |
|---|---|---|---|
| 1 | `abstract-algebra.group.def` | 群公理的直接推论；子群判定、交与生成子群、子群格 | ✅ |
| 2 | `abstract-algebra.group.coset` | 左右陪集、陪集分割、指数、Lagrange 及元素阶整除群阶 | ✅ |
| 3 | `abstract-algebra.group.cyclic` | 元素阶、循环子群、循环群子群分类、有限循环群与 `Z/nZ` | ✅ |
| 4 | `abstract-algebra.group.normal` | 正规子群的等价刻画、商群运算、商映射的泛性质 | ✅ |
| 5 | `abstract-algebra.group.hom` | 核与像、单满射判据、第一同构定理、同构保持不变量 | ✅ |
| 6 | `abstract-algebra.group.iso-theorems` | 第二、第三同构定理及对应定理 | ✅ |
| 7 | `abstract-algebra.group.automorphism` | 自同构群、内自同构、共轭同态及 `G/Z(G) ≅ Inn(G)` | ✅ |
| 8 | `abstract-algebra.group.product` | 直积、内部直积、半直积的入门接口 | ✅ |
| 9 | `abstract-algebra.group.action` | 群作用、轨道、稳定子、轨道—稳定子定理、类方程 | ✅ |
| 10 | `abstract-algebra.group.permutation` | 置换群、Cayley 定理、循环分解、奇偶性与交错群 | ✅ |
| 11 | `abstract-algebra.group.sylow` | Cauchy 定理、Sylow 三定理及低阶群应用 | ✅ |
| 12 | `abstract-algebra.group.abelian-structure` | 有限生成交换群结构定理及有限交换群分类 | ✅ |

### A2 环 🚧

> 现有 `AbstractAlgebra/Ring.lean` 覆盖子环、理想、商环、素/极大理想和第一同构
> 定理的基础接口。完整章节还需系统处理整除理论和典型构造。

| # | 条目 | 内容 | 状态 |
|---|---|---|---|
| 1 | `abstract-algebra.ring.def` | 环、交换环、单位、子环与环同态的基本性质 | ✅（本库定义层与实现桥已完成） |
| 2 | `abstract-algebra.ring.ideal` | 左/右/双边理想、生成理想、理想和积、商环 | 🟡（判定与商环判等已有） |
| 3 | `abstract-algebra.ring.iso` | 环同态第一、第二、第三同构定理与对应定理 | 🟡（第一同构定理已有） |
| 4 | `abstract-algebra.ring.domain` | 零因子、整环、域、素理想与极大理想、商环判据 | ✅（基础版） |
| 5 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约与素元、最大公因子 | 🔲 |
| 6 | `abstract-algebra.ring.euclidean` | Euclidean 环、带余除法与扩展 Euclidean 算法 | 🔲 |
| 7 | `abstract-algebra.ring.pid-ufd` | PID、UFD、唯一分解及 Euclidean⇒PID⇒UFD | 🔲 |
| 8 | `abstract-algebra.ring.crt` | 中国剩余定理、互素理想与有限直积 | 🔲 |
| 9 | `abstract-algebra.ring.localization` | 分式域与局部化的构造及泛性质 | 🔲 |

### A3 多项式与域扩张 🚧

| # | 条目 | 内容 | 状态 |
|---|---|---|---|
| 1 | `abstract-algebra.poly.def` | 系数、次数、求值、根、整除及多项式环整环性 | 🟡（求值、根与整环性已有） |
| 2 | `abstract-algebra.poly.division` | 首一多项式带余除法、Euclidean 算法、gcd 与 Bézout | 🟡（带余除法接口已有） |
| 3 | `abstract-algebra.poly.irreducible` | 不可约判据、Gauss 引理、有理根判别、Eisenstein 判别 | 🟡（一次多项式已有） |
| 4 | `abstract-algebra.poly.factorization` | 域上唯一分解、根的重数、导数与重根判据 | 🟡（根数上界已有） |
| 5 | `abstract-algebra.field.extension` | 扩域、子域、单扩张、代数元与超越元、最小多项式 | 🔲 |
| 6 | `abstract-algebra.field.degree` | 扩张次数、塔式公式、有限扩张必代数 | 🔲 |
| 7 | `abstract-algebra.field.splitting` | 分裂域、代数闭包、有限域基础 | 🔲 |
| 8 | `abstract-algebra.field.separable-normal` | 可分扩张、正规扩张、有限域上的可分性 | 🔲 |
| 9 | `abstract-algebra.field.galois` | Galois 群、基本定理及典型低次多项式例子 | 🔲 |

---

## 5. Phase 4 — 点集拓扑及代数拓扑入口（T1-T4）

> 家族前缀 `topology.`。

### T1 拓扑空间（开闭/邻域/连续/子商积）✅

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `topology.space.def` | 拓扑/开闭集定义 | `TopologicalSpace`、`IsOpen` |
| 2 | `topology.space.closure` | 内部、闭包、边界及邻域刻画 | `interior`、`closure`、`frontier` |
| 3 | `topology.space.neighborhood` | 邻域/滤子 | `𝓝`、`nhds`、`Filter` |
| 4 | `topology.space.continuous` | 连续、点连续 ↔ 连续 | `Continuous`、`ContinuousAt`、`continuous_iff` |
| 5 | `topology.space.homeo` | 同胚 | `Homeomorph` |
| 6 | `topology.space.subspace` | 子空间/积/商拓扑 | `Subspace`、`Product`、`Quotient` |
| 7 | `topology.space.connected` | 连通/道路连通（导言） | `IsConnected`、`PathConnected` |

### T2 紧致/分离 ✅

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `topology.compact.def` | 紧致（有限覆盖/序列/滤子等价） | `IsCompact`、`CompactSpace` |
| 2 | `topology.compact.closed-bdd` | 闭区间紧（Heine-Borel 的抽象版） | `IsCompact.isClosed`、`isCompact_Icc` |
| 3 | `topology.compact.finite` | 紧 Hausdorff 的闭/紧性、Tychonoff | `isCompact_iff_isClosed`、`Tychonoff` |
| 4 | `topology.separations` | T1/T2/正则/正规 | `T1Space`、`T2Space`、`NormalSpace`、`T3Space` |

### T3 度量与完备性 ✅

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `topology.metric.def` | 度量空间、开球 | `MetricSpace`、`Metric.ball` |
| 2 | `topology.metric.uniform` | 一致连续/一致空间 | `UniformContinuous`、`UniformSpace` |
| 3 | `topology.metric.cauchy-complete` | Cauchy/完备 | `Metric.CauchySeq`、`CompleteSpace` |
| 4 | `topology.metric.completion` | **完备化** | `UniformSpace.Completion`、`denseRange_pack` |
| 5 | `topology.normed-space.def` | 赋范线性空间、范数诱导度量 | `NormedSpace`、`dist_eq_norm` |
| 6 | `topology.normed-space.inequalities` | 三角与反三角不等式、数乘范数 | `norm_add_le`、`abs_norm_sub_norm_le` |
| 7 | `topology.normed-space.banach` | 范数收敛、Cauchy 与 Banach 完备性 | `Metric.tendsto_atTop`、`CompleteSpace` |

### T4 同胚、同伦与基本群（点集拓扑后的代数拓扑入口）🔲

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

## 6. Phase 5 — 实分析（R1-R6）

状态只以 §1 总览和本节表格为准。R1-R4 与 Riemann 桥已进入 main；以下只展开仍缺的课程入口。

### R1-R4 与 R5.5 已完成主线 ✅

测度、可测函数、Lebesgue 积分、三大收敛定理、乘积测度、Fubini/Tonelli、Lᵖ，以及本库
Riemann 定义、连续可积、Lebesgue 判据、FTC、分部积分和换元均已登记。

### R5 微分定理桥 🚧

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `real-analysis.differentiation.maximal-function` | Hardy–Littlewood 极大函数与弱型估计 | 球平均/覆盖接口 |
| 2 | `real-analysis.differentiation.lebesgue-points` | Lebesgue 点及几乎处处存在 | `ae_lebesguePoint` 系 |
| 3 | `real-analysis.differentiation.theorem` | Lebesgue 微分定理 | integral average |
| 4 | `real-analysis.ftc.absolute-continuity` | 绝对连续函数与积分表示 | `AbsolutelyContinuousOn` |
| 5 | `real-analysis.ftc.ae-derivative` | a.e. 导数的 Newton–Leibniz 形式 | interval integral FTC |
| 6 | `real-analysis.riemann.lebesgue-bridge-summary` | 两套积分接口的课程总桥 | 本库 R5.5 API |

### R6 多元微积分收尾 🚧

| # | 条目 id | 内容 | 主要接口 |
|---|---|---|---|
| 1 | `analysis.forms.coordinate-expression` | 1/2/3-形式显式坐标表达 | 本库 `DifferentialForm` |
| 2 | `analysis.forms.leibniz` | 外微分对楔积的分次 Leibniz 公式 | 外微分/楔积接口 |
| 3 | `analysis.forms.poincare` | 星形域上的 Poincaré 引理 | 同伦算子与积分 |
| 4 | `analysis.stokes.domain-gluing` | 参数片拼成一般分片光滑区域 | 已有三大公式片接口 |
| 5 | `analysis.coordinate-integrals.mass-center` | 质量、重心、转动惯量例题 | 坐标换元 API |
| 6 | `analysis.multivariable.course-boundary` | 分析 II 覆盖范围与 de Rham 边界 | 本库 R6 API |

边界：R6 不定义 de Rham 上同调；闭形式模恰当形式的商空间归入 X5。

## 7. Phase 6 — 复分析（C0-C3）

C0 复数基础与 C0.5 代数学基本定理已完成。C1-C3 尚未进入 main。

### C1 复微分与全纯函数 🚧

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `complex-analysis.holomorphic.definition` | 复可微、区域上全纯 | `ComplexDifferentiableAt/On` |
| 2 | `complex-analysis.holomorphic.algebra` | 和、积、商、复合的全纯性 | 复导数代数接口 |
| 3 | `complex-analysis.holomorphic.cauchy-riemann` | CR 方程必要条件 | `Complex.hasFDerivAt_iff` |
| 4 | `complex-analysis.holomorphic.cr-sufficient` | 实可微加 CR 推出复可微 | Fréchet 导数 |
| 5 | `complex-analysis.holomorphic.power-series` | 幂级数圆内全纯与逐项求导 | `PowerSeries`、`HasSum` |
| 6 | `complex-analysis.holomorphic.elementary` | exp、sin、cos、局部 log | `Complex.exp/sin/cos/log` |

### C2 复积分与 Cauchy 理论 🔒（依赖 C1）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `complex-analysis.integral.path` | 分段光滑路径与复路径积分 | `PathIntegral` |
| 2 | `complex-analysis.integral.reparametrization` | 换参数、反向、拼接 | path integral invariance |
| 3 | `complex-analysis.cauchy.triangle` | 三角形 Cauchy 定理 | Cauchy triangle API |
| 4 | `complex-analysis.cauchy.homotopy` | 同伦不变与单连通域版本 | winding/homotopy |
| 5 | `complex-analysis.cauchy.formula` | Cauchy 积分公式 | circle integral API |
| 6 | `complex-analysis.cauchy.derivatives` | 高阶导数公式与 Cauchy 估计 | iterated derivative |
| 7 | `complex-analysis.liouville` | Liouville 与 FTA 的分析证明 | Cauchy estimate |

### C3 Laurent、残数与亚纯函数 🔒（依赖 C2）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `complex-analysis.series.taylor` | Taylor 展开与唯一性 | analytic/power series |
| 2 | `complex-analysis.series.laurent` | 环域 Laurent 展开 | `LaurentSeries` |
| 3 | `complex-analysis.singularity.classification` | 可去、极点、本性奇点 | `MeromorphicAt` |
| 4 | `complex-analysis.residue.definition` | 残数与 Laurent 系数 | `residue` |
| 5 | `complex-analysis.residue.theorem` | 残数定理 | winding/cycle integral |
| 6 | `complex-analysis.argument-principle` | 辐角原理与 Rouché | logarithmic derivative |
| 7 | `complex-analysis.residue.real-integrals` | 实积分计算例题 | contour estimates |

## 8. Phase 7 — 泛函分析（F1-F4）

### F1 赋范空间与连续线性算子 🚧

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `functional-analysis.normed.definition` | 赋范空间与 Banach 空间 | `NormedSpace`、`CompleteSpace` |
| 2 | `functional-analysis.operator.continuous-linear-map` | 连续线性映射与算子范数 | `ContinuousLinearMap` |
| 3 | `functional-analysis.operator.bounded-iff` | 连续、局部有界、全局有界等价 | `LinearMap.mkContinuous` |
| 4 | `functional-analysis.operator.space` | 算子空间的赋范与完备性 | CLM complete instance |
| 5 | `functional-analysis.series.summable` | Banach 中绝对可和推出可和 | `summable_of_summable_norm` |
| 6 | `functional-analysis.subspace.quotient` | 闭子空间与商 Banach 空间 | `NormedSpace.Quotient` |

### F2 Banach 三大定理 🔒（依赖 F1）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `functional-analysis.baire.theorem` | Baire 范畴定理 | dense open intersection |
| 2 | `functional-analysis.banach-steinhaus` | 一致有界原理 | `banach_steinhaus` |
| 3 | `functional-analysis.open-mapping` | 开映射定理 | continuous linear surjection |
| 4 | `functional-analysis.closed-graph` | 闭图定理 | closed graph |
| 5 | `functional-analysis.inverse-operator` | 有界逆定理 | open mapping 推论 |

### F3 Hilbert 空间 🔒（依赖 F1、L5）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `functional-analysis.hilbert.projection` | 闭凸集/闭子空间投影 | `orthogonalProjection` |
| 2 | `functional-analysis.hilbert.riesz` | Riesz 表示定理 | `InnerProductSpace.toDual` |
| 3 | `functional-analysis.hilbert.adjoint` | 有界算子伴随 | CLM adjoint |
| 4 | `functional-analysis.hilbert.orthonormal-basis` | 正交规范基与 Parseval | `OrthonormalBasis` |
| 5 | `functional-analysis.hilbert.compact-spectral` | 紧自伴算子谱定理 | compact operator spectrum |

### F4 算子代数入口 🔒（依赖 F2/F3）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `functional-analysis.spectrum.definition` | Banach 代数谱与预解集 | `spectrum`、`resolventSet` |
| 2 | `functional-analysis.spectrum.nonempty` | 复 Banach 代数谱非空紧致 | spectrum API |
| 3 | `functional-analysis.operator.normal` | 正规、自伴与正算子 | star operator API |
| 4 | `functional-analysis.operator.functional-calculus` | 连续函数演算入口 | functional calculus |
| 5 | `functional-analysis.operator.cstar-entry` | C*-恒等式与基本例子 | `CStarAlgebra` |

## 9. Phase 8 — 概率论（Pr1-Pr3）

### Pr1 概率空间、随机变量与期望 🚧

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `probability.space.definition` | 概率空间与事件 | `IsProbabilityMeasure` |
| 2 | `probability.variable.definition` | 随机变量与可测性 | `Measurable` |
| 3 | `probability.distribution.pushforward` | 分布作为推前测度 | `Measure.map` |
| 4 | `probability.expectation.definition` | 期望、可积性与线性 | `integral` |
| 5 | `probability.moments.variance` | 方差与协方差 | variance/covariance |
| 6 | `probability.independence.events` | 事件与 σ-代数独立 | `IndepEvents`、`Indep` |
| 7 | `probability.independence.variables` | 随机变量独立与分布乘积 | `IndepFun` |
| 8 | `probability.inequalities.basic` | Markov、Chebyshev、Jensen | probability inequalities |

### Pr2 条件期望与鞅 🔒（依赖 Pr1）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `probability.conditional-expectation.definition` | 条件期望定义与存在 | `condExp` |
| 2 | `probability.conditional-expectation.tower` | 塔式性质 | `condExp_condExp` |
| 3 | `probability.conditional-expectation.independence` | 独立时条件期望退化 | condExp independence |
| 4 | `probability.filtration.definition` | 过滤与适应过程 | `Filtration`、`Adapted` |
| 5 | `probability.martingale.definition` | 鞅、下鞅、上鞅 | `Martingale` |
| 6 | `probability.martingale.optional-stopping-entry` | 有界停时可选停止 | stopping time |

### Pr3 极限定理 🔒（依赖 Pr1/Pr2）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `probability.convergence.modes` | a.s./概率/Lp/分布收敛 | convergence APIs |
| 2 | `probability.law-large-numbers.weak` | 弱大数律 | iid variance bounds |
| 3 | `probability.law-large-numbers.strong` | 强大数律 | SLLN |
| 4 | `probability.characteristic-function` | 特征函数与分布唯一性 | charFun |
| 5 | `probability.central-limit-theorem` | iid 中心极限定理 | CLT |

## 10. Phase 9 — 统计推断（S1-S2）

### S1 参数估计 🔒（依赖 Pr1）

| # | 条目 id | 内容 | 主要实现接口 |
|---|---|---|---|
| 1 | `statistics.model.definition` | 统计模型、样本与参数族 | 测度族/概率核 |
| 2 | `statistics.estimator.definition` | 统计量、估计量与风险 | 可测映射、期望 |
| 3 | `statistics.estimator.bias-variance` | 偏差—方差分解 | Pr1 方差 |
| 4 | `statistics.estimator.consistency` | 相合性与收敛模式 | Pr3 |
| 5 | `statistics.sufficiency.definition` | 充分统计量与因子分解入口 | conditional law |
| 6 | `statistics.method-of-moments` | 矩估计 | moments |
| 7 | `statistics.maximum-likelihood` | 似然与 MLE | density/Radon–Nikodym |
| 8 | `statistics.information.cramer-rao` | Fisher 信息与 Cramér–Rao | 微分与积分交换 |

### S2 检验与回归 🔒（依赖 S1）

| # | 条目 id | 内容 | 主要实现接口 |
|---|---|---|---|
| 1 | `statistics.testing.definition` | 检验、两类错误与功效 | measurable decision |
| 2 | `statistics.testing.neyman-pearson` | Neyman–Pearson 引理 | likelihood ratio |
| 3 | `statistics.testing.likelihood-ratio` | 广义似然比检验入口 | MLE/density |
| 4 | `statistics.confidence-set` | 置信集合与覆盖概率 | probability model |
| 5 | `statistics.regression.linear-model` | 线性模型与最小二乘 | 本库伪逆/投影 |
| 6 | `statistics.regression.gauss-markov` | Gauss–Markov 定理 | covariance |
| 7 | `statistics.regression.normal-equations` | 正规方程与可识别性 | pseudoinverse |
| 8 | `statistics.regression.inference` | 正态误差下区间与检验 | Gaussian law |

## 11. Phase 10 — 数论（N1-N3）

### N1 初等数论 ✅

21 个教材入口已进入 main。最佳逼近必要方向、√d 连分数桥、负 Pell 和全体正解分类归入 N1+。

### N1+ 初等专题扩展 🔲

| # | 条目 id | 内容 | 前置 |
|---|---|---|---|
| 1 | `number-theory.elementary.convergent-best` | 收敛子是最佳逼近的必要方向 | N1 连分数 |
| 2 | `number-theory.elementary.sqrt-periodic-cf` | 二次无理数连分数周期性 | N1 |
| 3 | `number-theory.elementary.pell-cf-bridge` | √d 收敛子产生 Pell 解 | 前两条 |
| 4 | `number-theory.elementary.pell-all-positive` | 全体正解由基本解幂生成 | Pell bridge |
| 5 | `number-theory.elementary.negative-pell` | 负 Pell 可解性边界 | 周期奇偶性 |

### N2 代数数论 🔒（依赖 G-A2/G-A3）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `number-theory.algebraic.number-field` | 数域与有限扩张 | `NumberField` |
| 2 | `number-theory.algebraic.algebraic-integer` | 代数整数与整闭包 | `IsIntegral` |
| 3 | `number-theory.algebraic.ring-of-integers` | 整数环 | `RingOfIntegers` |
| 4 | `number-theory.algebraic.norm-trace` | 范数与迹 | `Algebra.norm/trace` |
| 5 | `number-theory.algebraic.discriminant` | 判别式与整基 | `Algebra.discr` |
| 6 | `number-theory.algebraic.dedekind` | 整数环的 Dedekind 性 | `IsDedekindDomain` |
| 7 | `number-theory.algebraic.fractional-ideal` | 分式理想 | `FractionalIdeal` |
| 8 | `number-theory.algebraic.ideal-factorization` | 非零理想唯一分解 | ideal factorization |
| 9 | `number-theory.algebraic.class-group` | 理想类群与类数 | `ClassGroup` |
| 10 | `number-theory.algebraic.prime-decomposition` | 分解、分歧、惯性 | ramification APIs |
| 11 | `number-theory.algebraic.minkowski` | Minkowski 嵌入与界 | embeddings |
| 12 | `number-theory.algebraic.unit-theorem` | Dirichlet 单位定理 | unit group |
| 13 | `number-theory.algebraic.valuation` | 离散赋值与局部化 | `Valuation` |
| 14 | `number-theory.algebraic.padic-completion` | p-进数与完备化 | `Padic`、`PadicInt` |
| 15 | `number-theory.algebraic.local-field-entry` | 局部域与局部—整体入口 | local field APIs |

### N3 解析数论 🔒（N3.1 可先行；其余依赖 G-C）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `number-theory.analytic.arithmetic-function` | 算术函数与乘法性 | `ArithmeticFunction` |
| 2 | `number-theory.analytic.dirichlet-convolution` | Dirichlet 卷积 | convolution |
| 3 | `number-theory.analytic.mobius-inversion` | Möbius 反演 | `moebius` |
| 4 | `number-theory.analytic.partial-summation` | Abel 部分求和 | summation by parts |
| 5 | `number-theory.analytic.dirichlet-series` | Dirichlet 级数 | `LSeries` |
| 6 | `number-theory.analytic.euler-product` | Euler 乘积 | Euler product |
| 7 | `number-theory.analytic.riemann-zeta` | ζ 函数、延拓、函数方程入口 | `riemannZeta` |
| 8 | `number-theory.analytic.chebyshev` | Chebyshev 函数与估计 | prime sums |
| 9 | `number-theory.analytic.prime-number-theorem` | 素数定理 | ζ 非零线 |
| 10 | `number-theory.analytic.dirichlet-character` | Dirichlet 特征 | `DirichletCharacter` |
| 11 | `number-theory.analytic.l-function` | Dirichlet L-函数 | `LFunction` |
| 12 | `number-theory.analytic.primes-in-progression` | 算术级数中的素数 | character/L nonvanishing |

## 12. Phase 11 — 集合论深化（ST1-ST3）

### ST1 序数理论 ✅

13 个序数入口已进入 main；Goodstein 状态编码不属于 ST1 完成范围。

### ST2 基数理论 🚧（staging Round 2，尚未进入 main）

| # | 条目 id | 内容 | 状态 |
|---|---|---|---|
| 1 | `settheory.cardinal.equinumerous` | 双射定义等势 | staging |
| 2 | `settheory.cardinal.comparison` | 单射比较闭环 | staging-review |
| 3 | `settheory.cardinal.cantor-bernstein` | 双向单射推出等势 | staging |
| 4 | `settheory.cardinal.cantor-theorem` | 对角论证与幂集严格比较 | staging-review |
| 5 | `settheory.cardinal.addition` | 不交并定义加法 | staging |
| 6 | `settheory.cardinal.multiplication` | 笛卡尔积定义乘法 | staging |
| 7 | `settheory.cardinal.exponentiation` | 函数空间定义幂 | staging |
| 8 | `settheory.cardinal.finite-set` | 与 Fin n 等势定义有限 | staging |
| 9 | `settheory.cardinal.aleph-hierarchy` | aleph 层级 | staging |
| 10 | `settheory.cardinal.beth-hierarchy` | beth 层级 | staging |
| 11 | `settheory.cardinal.cardinal-cofinality` | 基数共尾性 | staging |
| 12 | `settheory.cardinal.regular-singular` | 无限基数分类 | staging |
| 13 | `settheory.cardinal.konig-theorem` | König 定理 | staging |
| 14 | `settheory.cardinal.classical-choice-wellordering` | 经典选择与良序可用 | staging-review |
| 15 | `settheory.cardinal.continuum-hypothesis` | CH 准确陈述 | staging |

边界：无选择基础中的 AC/良序/Zorn 双向等价和 CH 独立性证明均未完成。

### ST3 递归与增长层级 🚧（首批 staging）

| # | 条目 id | 内容 | 状态 |
|---|---|---|---|
| 1 | `settheory.googology.primitive-recursion` | 单层递归生成器 | staging |
| 2 | `settheory.googology.hyperoperation` | 超运算 | staging |
| 3 | `settheory.googology.ackermann` | Ackermann 定义与方程 | staging |
| 4 | `settheory.googology.knuth-arrow` | Knuth 上箭头 | staging |
| 5 | `settheory.googology.graham-number` | Graham 数 | staging |
| 6 | `settheory.googology.hereditary-base` | 遗传基表达式 | staging |
| 7 | `settheory.googology.goodstein-step` | 换底减一单步 | staging |
| 8 | `settheory.googology.primitive-recursive-class` | 原始递归函数类 | 🔲 |
| 9 | `settheory.googology.ackermann-domination` | 支配与非原始递归 | 🔒 |
| 10 | `settheory.googology.goodstein-sequence` | 正规编码与完整序列 | 🔲 |
| 11 | `settheory.googology.goodstein-ordinal-descent` | ε₀ 严格下降 | 🔒 |
| 12 | `settheory.googology.goodstein-termination` | Goodstein 终止 | 🔒 |
| 13 | `settheory.googology.fast-growing-hierarchy` | 快速增长层级 | 🔒 |
| 14 | `settheory.googology.computability-entry` | 可计算/不可计算定义 | 🔲 |
| 15 | `settheory.googology.busy-beaver` | Busy Beaver 不可计算性 | 🔒 |

## 13. Phase 12 — 前沿分叉（X*）

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| X1.1 | `commutative-algebra.module.foundation` | 模、子模、商模、同构定理 | A2 |
| X1.2 | `commutative-algebra.module.finiteness` | 有限生成、Noether/Artin 模 | X1.1 |
| X1.3 | `commutative-algebra.module.projective-injective` | 自由、投射、内射模 | X1.1 |
| X1.4 | `commutative-algebra.tensor-localization` | 张量积与局部化 | X1.1 |
| X1.5 | `commutative-algebra.dimension` | 素理想链与 Krull 维数 | A2 |
| X2.1 | `homological-algebra.complex` | 链复形、同调 | X1 |
| X2.2 | `homological-algebra.exact-snake` | 正合列与蛇引理 | X2.1 |
| X2.3 | `homological-algebra.derived-ext-tor` | 导出函子、Ext/Tor | X2.2 |
| X3.1 | `algebraic-topology.covering` | 覆盖空间 | T4 |
| X3.2 | `algebraic-topology.singular-homology` | 奇异同调 | X2.1 |
| X3.3 | `algebraic-topology.cohomology-hurewicz` | 上同调与 Hurewicz | X3.2 |
| X4.1 | `representation-theory.definition` | 群表示与子表示 | A1/L2 |
| X4.2 | `representation-theory.maschke-character` | Maschke 与特征标 | X4.1 |
| X4.3 | `representation-theory.lie-entry` | Lie 代数表示入口 | X4.1 |
| X5.1 | `differential-geometry.manifold-bundles` | 流形、切丛、余切丛 | R6/T4 |
| X5.2 | `differential-geometry.connection-curvature` | 联络、曲率、测地线 | X5.1 |
| X5.3 | `differential-geometry.derham` | de Rham 复形、上同调、定理入口 | X5.1/X2 |
| X6.1 | `logic.syntax-formal-system` | 形式语言、理论、证明系统 | ST1 |
| X6.2 | `logic.computability` | 部分递归与可计算函数 | X6.1 |
| X6.3 | `logic.goedel-coding` | Gödel 编码与可表示性 | X6.1 |
| X6.4 | `logic.completeness-incompleteness` | 完备与不完备定理 | X6.3 |

## 14. 批次纳入节奏（沿用 INGESTION_PROTOCOL）

1. 每批开工：`.lean` 文件头写“本文件当前条目”清单，每条目一个 Entry（docstring 带 `> **Entry**: <id>`）。
2. 批内先后：行序严格（定义 → 基本性质 → 定理 → 应用）。
3. 学科验收：修改模块、依赖闭包和聚合导入通过；无占位符；文档与 Entry 一致。学科负责人不跑全库构建。
4. main 集成：统一更新共有文件，运行生成器、公理审计、audit 和一次全库 `lake build`。
5. 状态推进：main 集成提交通过后，同时更新 §1 总览和对应章节；不存在另一张进度表。

---

## 15. 学完标准与科研论文下沉

### 15.1 阶段学完标准

1. 规划内该阶段所有批次条目 = `verified`，`audit.py` 全过，无 `sorry`。
2. 阶段末能力节点被后续阶段实际引用（`dependedOnBy` 非零）——"能干活"才真读完。
3. 该阶段 RADAR 组覆盖实际用到的每个 mathlib 名。

### 15.2 瘦身维护（Slimming，持续进行）

- **任务**：按 Playbook §4.1 逐条检查 RADAR 记录，把"证明体直接 `exact mathlib`"的
  结构性条目改写为本库推导。判定：结构性可推导 → 改；定义性/依赖 mathlib 内部结构 → 保留。
- **节奏**：每完成一批新条目后，回头扫一遍已注册条目的证明体，找出新的低垂果实。
  从 RADAR 一条一条检查，到该条"谁在用"的索引全部被本库条目替换掉，即完全解明。
- **意义**：学术论文的定理 mathlib 里没有，到时全得自己写。瘦身 = 培养论文定理自证能力。

### 15.3 科研论文定理下沉

1. 选论文定理：能用规划内 premise 表述为前提。
2. 走纳营协议五步；`premises` 必须指向库内 verified 条目。
3. 需未覆盖概念时先回落补一个规划内批次。
4. 论文条目同样计入 `dependedOnBy` 调用量。

> 守则：**前沿不是空中楼阁**——每个论文定理都有规划内地基可追溯，扩展速度与根基缺口成反比。

---
