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
| **Phase 4 拓扑学基础** | `topology.*` | T1-T3✅ T4🚧（复分析负责人转入） | 集合论 + 分析线直观 |
| **Phase 5 实分析** | `real-analysis.*` | R1-R4✅ R5🚧 R6🚧 | T3 + M 系列 |
| **Phase 6 复分析** | `complex-analysis.*` | C0/C0.5/C1✅；C2-C3⏸（等待 T4） | R2 T3 M4 T4 |
| **Phase 7 泛函分析** | `functional-analysis.*` | F1🚧 F2-F4🔒 | L5 T3 R4 |
| **Phase 8 概率论** | `probability.*` | Pr1🚧 Pr2-Pr3🔒 | R4 |
| **Phase 9 统计推断** | `statistics.*` | S1-S2🔒 | Pr1/Pr3 |
| **Phase 10 数论分支** | `number-theory.*` | N1✅ N2🔒 N3🔒 | A2/A3；N3 另需 C1-C3 |
| **Phase 11 集合论深化** | `settheory.*` | ST1✅ ST2基础✅/等价🔲 ST3基础58项✅/纵深🚧 | 集合/关系/Zorn；ST3 另需可计算性 |
| **Phase 12+ 高阶学科群** | 交换/同调/代数几何、代数拓扑、表示论、流形/微分拓扑/黎曼几何、ODE/PDE、随机过程、高等泛函、调和分析、数理逻辑 | 各学科独立路线🔒 | 各自课程门达标 |

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
| G-T4/C | 本库道路同伦、相对端点同伦、同伦等价与基本群接口完成，并补连续同伦到复路径积分所需的正则化桥 | 恢复 C2 一般同伦不变、单连通域原函数，再推进 C3 | 🚧（当前优先门） |
| G-C | T4 桥完成后，C1–C3 的全纯、复积分、解析延拓与残数接口完成 | N3.2–N3.5 | ⏸（等待 G-T4/C） |
| G-Pr | Pr1 概率空间、随机变量、期望和独立性完成 | Pr2、统计 S1 | 🚧 |
| G-ST | ST2 已审核接口进入 main，并另建可计算性定义层 | ST3 深层增长/不可计算性 | ✅ |
| G-N1+ | 连分数最佳逼近必要方向及 `√d`—Pell 桥完成 | N1 专题扩展；不阻塞 N2 | 🔲 |

依赖门只由 main 在验收对应 handoff 后改为 ✅。存在相近 Mathlib 文件或一条强定理不等于开门；
必须已有本库教材定义、显式实现桥、课程文档和 verified Registry 条目。

#### Wave A：现在立即并行（五名学科负责人）

| 优先级 | 学科 staging | 负责人总目标 | 建议子 Agent 切分 | 出口条件 |
|---|---|---|---|---|
| P0 | A2 环论 | 补齐 A2.2–A2.9，打开 G-A2 | A2-I 理想和同构定理；A2-D 整除/Euclidean/PID/UFD；A2-C CRT/局部化 | 8 个课程入口完整；A3/N2 可只依赖本库 A2 API |
| P0 | T4 拓扑学 | 补齐同伦课程层并打开 G-T4/C | T4-H 道路与相对端点同伦；T4-E 同伦等价；T4-F 基本群；T4-R 正则化桥 | 复分析负责人转岗；桥完成前 C2/C3 暂停 |
| P1 | F1 泛函基础 | 赋范空间、连续线性映射、Banach 基础 | F1-N 赋范/Banach 定义；F1-L 连续线性算子；F1-S 级数与完备性 | 不提前引用开映射/闭图定理 |
| P1 | Pr1 概率基础 | 概率空间、随机变量、分布、期望、独立性 | Pr1-M 概率测度；Pr1-R 随机变量/分布；Pr1-E 期望/独立 | 打开 G-Pr，且所有概率概念先有本库定义层 |
| P1 | ST2/ST3 基础集成 | ST2 基数基础与 ST3 递归/增长/可计算性定义层 | 62 个新增 verified 条目 | ✅ 已进入 main；纵深路线转入下一波 |

Wave A 的学科负责人应先提交 1 页设计说明，冻结公开定义和文件分片；main 确认没有跨学科签名冲突后，
子 Agent 才进入证明阶段。A2 和 T4 是关键路径，main 优先审核它们的 handoff。

#### Wave B：依赖满足即可启动，不必等待 Wave A 全部结束

| 启动条件 | 学科 staging | 批次与子 Agent 包 | 关键出口 |
|---|---|---|---|
| A2-I 完成 | A3 多项式 | A3-P1 多项式定义/除法；A3-P2 不可约判据；A3-P3 分解/重根 | A3.1–A3.4 全部转正 |
| G-T4/C 完成 | C2 复积分恢复开发 | 一般同伦不变；单连通域积分无关与原函数；Cauchy 理论收口 | 打开 Laurent/残数路线 |
| F1 完成 | F2 Banach 定理 | 一致有界；开映像；闭图与逆算子 | 三大定理分别独立文件，公共 Baire 接口先行 |
| Pr1 完成 | Pr2 概率极限定理 | 条件期望；大数律；中心极限定理前置 | S1 只在期望/方差/分布接口稳定后启动 |
| ✅ G-ST 已打开 | ST3 深层 | 原始递归函数类；一般 Goodstein 正规化；通用机与翻转编译器实例 | 支配、终止、不可计算性仍须逐项证明 |

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
| 2 | `abstract-algebra.ring.ideal` | 左/右/双边理想、生成理想与理想和积 | ✅（本库定义层与运算桥已完成） |
| 2.5 | `abstract-algebra.ring.quotient` | 模双边理想同余、商环、投影、核与泛性质 | ✅（本库商集构造已完成） |
| 3 | `abstract-algebra.ring.iso` | 环同态第一、第二、第三同构定理与对应定理 | 🟡（第一同构定理已有） |
| 4 | `abstract-algebra.ring.domain` | 零因子、整环与域的本库公理定义 | ✅（定义层与 Mathlib 桥已完成） |
| 4.5 | `abstract-algebra.ring.prime-ideal` | 素理想、极大理想及商整环／商域双向判据 | ✅ |
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

### T4 同胚、同伦与基本群（点集拓扑后的代数拓扑入口）🚧

> 依赖顺序固定为“同胚及拓扑不变量 → 道路与同伦 → 同伦等价 → 基本群”。其中 T1
> 已完成同胚的定义和基本接口；本批次继续发展同胚保持性质，并建立代数拓扑所需结构。

已进入 main 的定义前置层：

| 条目 | 内容 | 状态 |
|---|---|---|
| `topology.foundation.structure` | 本库开集公理、闭集、邻域、连续与同胚；Mathlib 仅为显式桥 | ✅ |
| `topology.foundation.constructions` | 诱导、子空间与积拓扑，包含映射及投影连续 | ✅ |

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

**当前调度（2026-08-25）**：复分析负责人已停止 C2/C3 的新增研发并转任 T4 拓扑学负责人。
优先顺序是本库道路与相对端点同伦定义、一手运算、同伦等价、基本群，再建立连续相对端点同伦到
复路径积分所需分段光滑／C² 代表的正则化桥。该桥进入 main 并验收前，复分析不得继续用未在本库
定义的同伦概念堆叠上层定理；已有复分析基础保留，不撤回，也不将 foundation 条目提前转正。

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

C0 复数基础、C0.5 代数学基本定理与 C1 已完成；C2/C3 已有基础条目进入 main。当前研发暂停：
一般同伦不变、单连通域原函数及其后续 Laurent／残数路线依赖 T4 中尚未完成的本库同伦、同伦等价、
基本群和连续同伦正则化接口。原复分析负责人已转入 T4；只有 G-T4/C 经 Main 验收后才恢复 C2/C3。
已有一般三角形 Goursat 等已提交成果继续保留，未完成内容不得借 Mathlib 拓扑结构直接冒充本库课程层。

### C1 复微分与全纯函数 ✅

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `complex-analysis.holomorphic.definition` | 复可微、区域上全纯 ✅ | `ComplexDifferentiableAt/On` |
| 2 | `complex-analysis.holomorphic.algebra` | 和、积、商、复合的全纯性 ✅ | 复导数代数接口 |
| 3 | `complex-analysis.holomorphic.cauchy-riemann` | CR 方程必要条件 ✅ | `Complex.hasFDerivAt_iff` |
| 4 | `complex-analysis.holomorphic.cr-sufficient` | 实可微加 CR 推出复可微 ✅ | Fréchet 导数 |
| 5 | `complex-analysis.holomorphic.power-series` | 幂级数圆内全纯与逐项求导 ✅ | `PowerSeries`、`HasSum` |
| 6 | `complex-analysis.holomorphic.elementary` | exp、sin、cos、局部 log ✅ | `Complex.exp/sin/cos/log` |

### C2 复积分与 Cauchy 理论 ⏸（依赖 C1 与 G-T4/C）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `complex-analysis.integral.path` | 分段光滑路径与复路径积分 ✅ | `PathIntegral` |
| 2 | `complex-analysis.integral.reparametrization` | 底层换元、反向、拼接 ✅；一般 `Path.reparam` 待补 | path integral invariance |
| 3 | `complex-analysis.cauchy.triangle` | 三角形 Cauchy 定理 | Cauchy triangle API |
| 4 | `complex-analysis.cauchy.homotopy` | 同伦不变与单连通域版本 | winding/homotopy |
| 5 | `complex-analysis.cauchy.formula` | Cauchy 积分公式 ✅ | circle integral API |
| 6 | `complex-analysis.cauchy.derivatives` | 高阶导数公式与 Cauchy 估计 ✅ | iterated derivative |
| 7 | `complex-analysis.liouville` | Liouville 与 FTA 的分析证明 ✅ | Cauchy estimate |
| 8 | `complex-analysis.cauchy.triangle-ball` | 圆盘内三角形边界积分为零 ✅（foundation） | 原函数桥 |
| 9 | `complex-analysis.cauchy.path-independence-primitive` | 已有原函数时路径无关 ✅（foundation） | 原函数端点公式 |

### C3 Laurent、残数与亚纯函数 ⏸（依赖完整 C2）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `complex-analysis.series.taylor` | Taylor 展开与唯一性 ✅ | analytic/power series |
| 2 | `complex-analysis.series.laurent` | 环域 Laurent 展开 | `LaurentSeries` |
| 3 | `complex-analysis.singularity.classification` | 可去、极点、本性奇点 | `MeromorphicAt` |
| 4 | `complex-analysis.residue.definition` | 残数与 Laurent 系数 | `residue` |
| 5 | `complex-analysis.residue.theorem` | 残数定理 | winding/cycle integral |
| 6 | `complex-analysis.argument-principle` | 辐角原理与 Rouché | logarithmic derivative |
| 7 | `complex-analysis.residue.real-integrals` | 实积分计算例题 | contour estimates |
| 8 | `complex-analysis.series.laurent-foundation` | Laurent 解析定义与单项例子 ✅ | 双向整数指标 `HasSum` |
| 9 | `complex-analysis.singularity.classification-foundation` | 孤立奇点教材谓词与亚纯阶桥 ✅ | `MeromorphicAt` |
| 10 | `complex-analysis.residue.circle-foundation` | 指定圆周的正规化积分 ✅ | circle integral |
| 11 | `complex-analysis.residue.simple-pole` | 简单极点圆周公式 ✅ | Cauchy 公式 |
| 12 | `complex-analysis.residue.real-integral-example` | 一个广义实积分课程接口 ✅ | Mathlib 广义积分后端 |
| 13 | `complex-analysis.argument-principle.linear-special-case` | 线性辐角/Rouché 特例 ✅ | logarithmic derivative |

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

### ST2 基数理论：基础接口 ✅，选择等价与独立性仍待开发

| # | 条目 id | 内容 | 状态 |
|---|---|---|---|
| 1 | `settheory.cardinal.equinumerous` | 双射定义等势 | verified |
| 2 | `settheory.cardinal.comparison` | 单射比较闭环 | verified |
| 3 | `settheory.cardinal.cantor-bernstein` | 双向单射推出等势 | verified |
| 4 | `settheory.cardinal.cantor-theorem` | 对角论证与幂集严格比较 | verified |
| 5 | `settheory.cardinal.addition` | 不交并定义加法 | verified |
| 6 | `settheory.cardinal.multiplication` | 笛卡尔积定义乘法 | verified |
| 7 | `settheory.cardinal.exponentiation` | 函数空间定义幂 | verified |
| 8 | `settheory.cardinal.finite-set` | 与 Fin n 等势定义有限 | verified |
| 9 | `settheory.cardinal.aleph-hierarchy` | aleph 层级 | verified |
| 10 | `settheory.cardinal.beth-hierarchy` | beth 层级 | verified |
| 11 | `settheory.cardinal.cardinal-cofinality` | 基数共尾性 | verified |
| 12 | `settheory.cardinal.regular-singular` | 无限基数分类 | verified |
| 13 | `settheory.cardinal.konig-theorem` | König 定理 | verified |
| 14 | `settheory.cardinal.classical-choice-wellordering` | 经典基础中选择与良序可用 | verified（非三原则等价） |
| 15 | `settheory.cardinal.continuum-hypothesis` | CH 准确陈述 | verified |

边界：无选择基础中的 AC/良序/Zorn 双向等价和 CH 独立性证明均未完成。

### ST3 递归、增长、Goodstein、Hydra 与可计算性：基础 58 项 ✅，纵深 🚧

| # | 条目 id | 内容 | 状态 |
|---|---|---|---|
当前进入 main 的 58 项包括：递归定义、大数记号与序数幂桥 8 项，Conway/TREE 与带燃料增长层级
10 项，Goodstein 状态、自然数遗传编码、幂秩、局部借位和序数下降 14 项，Hydra 步骤、局部下降、
赋值、认证轨迹、策略终止与良基归纳 12 项，Busy Beaver 有限候选、经典输出/时间最大值与收敛
8 项，以及机器编码、可计算性、部分可计算性和条件式对角接口 6 项。逐项权威状态见 Registry；
以下表格保留下一阶段真正尚缺的课程门。

| # | 待开发条目 | 需要补齐的内容 | 状态 |
|---|---|---|---|
| 1 | `settheory.googology.primitive-recursive-class` | 冻结原始递归函数类并证明闭包 | 🚧 |
| 2 | `settheory.googology.ackermann-domination` | 支配全部原始递归函数及非原始递归性 | 🔒 |
| 3 | `settheory.googology.hereditary-encoding-order` | 已有全局严格保序与底数幂精确秩；继续补一般借位正规化接口 | 🚧 |
| 4 | `settheory.googology.goodstein-ordinal-descent` | 从局部借位推广到一般正规 Goodstein 步骤 | 🔒 |
| 5 | `settheory.googology.goodstein-termination` | 用序数良基性证明完整序列终止 | 🔒 |
| 6 | `settheory.googology.goodstein-pa-independence` | 精确形式化 PA 不可证性边界 | 🔒 |
| 7 | `settheory.googology.hydra-general-descent` | 消除最右脊柱证书限制，覆盖一般游戏步骤 | 🚧 |
| 8 | `settheory.googology.hydra-termination` | 一般 Hydra 游戏终止及强度边界 | 🔒 |
| 9 | `settheory.computability.universal-machine-instance` | 为当前 `NatProgram` 构造通用 runner | 🚧 |
| 10 | `settheory.computability.diagonal-flip-instance` | 实现并验证翻转编译闭包 | 🔒 |
| 11 | `settheory.computability.halting-undecidable` | 去除结构参数的停机不可判定定理 | 🔒 |
| 12 | `settheory.googology.busy-beaver-uncomputable` | 从停机问题完成不可计算性归约 | 🔒 |

## 13. Phase 12+ — 高阶学科群（每门独立建设）

> 本节不是一个名为“前沿”的杂项批次。以下十四门都是独立学科，每门的体量、负责人、worktree、
> family 前缀、handoff 和完成状态均独立；一门完成不代表其他门完成。表中一行是一个可验收
> Entry，不是用一个标题包装整章理论。正式开工时，学科负责人应按依赖把每个课程批次拆成
> 3–6 条的文件包交给子 Agent，并由负责人组装验收。

### 13.1 交换代数（CA1–CA6）🔒

> 家族前缀 `commutative-algebra.*`。课程门：A2 的理想、商环、整除、局部化完成；CA5 另需 A3。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| CA1 | `commutative-algebra.module.definition` | 模、子模与模同态的教材定义及 Mathlib 桥 | A2/L1 |
| CA1 | `commutative-algebra.module.generated` | 子集生成子模及最小性 | CA1.definition |
| CA1 | `commutative-algebra.module.quotient` | 商模、自然投影与商映射泛性质 | CA1.definition |
| CA1 | `commutative-algebra.module.isomorphism-theorems` | 模的三大同构定理 | CA1.quotient |
| CA1 | `commutative-algebra.module.direct-sum` | 内外直和及分解判据 | CA1.definition |
| CA2 | `commutative-algebra.module.finite-generation` | 有限生成模及生成元变换 | CA1 |
| CA2 | `commutative-algebra.module.free` | 自由模、基与秩 | CA1/L1 |
| CA2 | `commutative-algebra.module.exact-sequence` | 模同态序列、正合性、分裂正合 | CA1 |
| CA2 | `commutative-algebra.module.projective` | 投射模及提升性质 | CA2.free/exact-sequence |
| CA2 | `commutative-algebra.module.injective` | 内射模及延拓性质 | CA2.exact-sequence |
| CA2 | `commutative-algebra.module.flat` | 平坦模与张量保持单射 | CA3.tensor-product |
| CA3 | `commutative-algebra.tensor-product.definition` | 张量积的平衡映射泛性质 | CA1 |
| CA3 | `commutative-algebra.tensor-product.functoriality` | 张量映射、结合/交换/单位同构 | CA3.definition |
| CA3 | `commutative-algebra.tensor-product.base-change` | 标量扩张与基变换 | CA3.functoriality |
| CA3 | `commutative-algebra.localization.ring` | 乘法集局部化及泛性质 | A2.localization |
| CA3 | `commutative-algebra.localization.module` | 模局部化与分式判等 | CA1/CA3.localization.ring |
| CA3 | `commutative-algebra.localization.prime-correspondence` | 局部化后的素理想对应 | CA3.localization.ring |
| CA4 | `commutative-algebra.chain-conditions.noetherian` | Noether 环/模与升链条件 | CA2.finite-generation |
| CA4 | `commutative-algebra.chain-conditions.artinian` | Artin 环/模与降链条件 | CA2.finite-generation |
| CA4 | `commutative-algebra.noetherian.hilbert-basis` | Hilbert 基定理 | CA4.noetherian/A3.poly |
| CA4 | `commutative-algebra.noetherian.primary-decomposition` | 主分解的存在与关联素理想 | CA4.noetherian |
| CA5 | `commutative-algebra.integral-extension.definition` | 整元素、整扩张与整闭 | A3.field-extension |
| CA5 | `commutative-algebra.integral-extension.finiteness` | 有限生成整代数的有限模性质 | CA5.definition/CA2 |
| CA5 | `commutative-algebra.integral-extension.going-up` | lying-over 与 going-up | CA5.definition |
| CA5 | `commutative-algebra.normalization` | 分式域中的整闭包与正规化 | CA5.definition |
| CA6 | `commutative-algebra.dimension.krull` | 素理想链与 Krull 维数 | A2.prime-ideal |
| CA6 | `commutative-algebra.dimension.height` | 素理想高度与余维 | CA6.krull |
| CA6 | `commutative-algebra.local-ring.definition` | 局部环、极大理想与局部判据 | CA3.localization |
| CA6 | `commutative-algebra.nakayama` | Nakayama 引理及有限生成推论 | CA2/CA6.local-ring |
| CA6 | `commutative-algebra.dimension.principal-ideal-theorem` | Krull 主理想定理 | CA4/CA6.height |

**完成能力节点**：能用本库接口陈述局部环、有限生成模、张量积、整扩张和 Krull 维数，并为
同调代数、代数几何与代数数论提供稳定定义层，而不是只暴露 `Module`/`Ideal` 的 Mathlib 名称。

### 13.2 同调代数（HA1–HA6）🔒

> 家族前缀 `homological-algebra.*`。课程门：CA1–CA3；抽象范畴接口必须先有教材定义与桥。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| HA1 | `homological-algebra.category.foundation` | 范畴、函子、自然变换与自然同构 | CA1 |
| HA1 | `homological-algebra.category.universal-properties` | 初终对象、积/余积、核/余核 | HA1.foundation |
| HA1 | `homological-algebra.abelian-category.entry` | 加性范畴与 Abel 范畴入口 | HA1/CA1 |
| HA2 | `homological-algebra.complex.chain` | 链复形、上链复形与微分平方为零 | HA1 |
| HA2 | `homological-algebra.complex.morphism` | 复形态射、同伦与同伦等价 | HA2.chain |
| HA2 | `homological-algebra.complex.homology` | cycles、boundaries 与同调对象 | HA2.chain/CA1.quotient |
| HA2 | `homological-algebra.complex.shift` | 平移、符号约定与锥 | HA2.morphism |
| HA3 | `homological-algebra.exactness.definition` | 正合、短正合与分裂正合 | HA2/CA2.exact-sequence |
| HA3 | `homological-algebra.exactness.long-homology` | 短正合复形诱导长正合列 | HA2/HA3.definition |
| HA3 | `homological-algebra.lemma.five` | 五引理、四引理与九引理 | HA3.definition |
| HA3 | `homological-algebra.lemma.snake` | 蛇引理与连接同态 | HA3.definition |
| HA4 | `homological-algebra.resolution.projective` | 投射分解及比较定理 | CA2.projective/HA3 |
| HA4 | `homological-algebra.resolution.injective` | 内射分解及比较定理 | CA2.injective/HA3 |
| HA4 | `homological-algebra.derived-functor.definition` | 左/右导出函子 | HA4.resolution |
| HA4 | `homological-algebra.derived-functor.independence` | 分解选择无关性与函子性 | HA4.definition |
| HA5 | `homological-algebra.ext.definition` | Ext 的分解定义与低次解释 | HA4 |
| HA5 | `homological-algebra.tor.definition` | Tor 的分解定义与低次解释 | HA4/CA3.tensor |
| HA5 | `homological-algebra.ext.long-exact` | Ext 长正合列与连接态射 | HA5.ext/HA3 |
| HA5 | `homological-algebra.tor.long-exact` | Tor 长正合列与平坦性判据 | HA5.tor/CA2.flat |
| HA5 | `homological-algebra.ext-yoneda` | Yoneda 扩张及与 Ext 的对应 | HA5.ext |
| HA6 | `homological-algebra.double-complex` | 双复形、总复形与过滤 | HA2 |
| HA6 | `homological-algebra.spectral-sequence.definition` | 谱序列页、微分与收敛 | HA6.double-complex |
| HA6 | `homological-algebra.spectral-sequence.filtered-complex` | 过滤复形谱序列 | HA6.definition |
| HA6 | `homological-algebra.spectral-sequence.grothendieck` | 复合导出函子的 Grothendieck 谱序列 | HA4/HA6 |

**完成能力节点**：可独立构造同调、连接同态、Ext/Tor 和基本谱序列；“导出函子”不得继续作为
一个无法验收的单行目标。

### 13.3 代数拓扑（AT1–AT6）🔒

> 家族前缀 `algebraic-topology.*`。课程门：T4；同调部分另需 HA2–HA3。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| AT1 | `algebraic-topology.homotopy.paths` | 道路、道路同伦与基本群胚 | T4 |
| AT1 | `algebraic-topology.fundamental-group.definition` | 基本群、基点变换与函子性 | AT1.paths |
| AT1 | `algebraic-topology.fundamental-group.circle` | 圆周基本群 | AT1.definition |
| AT1 | `algebraic-topology.fundamental-group.van-kampen` | Seifert–van Kampen 定理 | AT1.definition |
| AT2 | `algebraic-topology.covering.definition` | 覆盖映射、均匀覆盖邻域 | T4 |
| AT2 | `algebraic-topology.covering.path-lifting` | 道路提升与唯一性 | AT2.definition |
| AT2 | `algebraic-topology.covering.homotopy-lifting` | 同伦提升 | AT2.path-lifting |
| AT2 | `algebraic-topology.covering.classification` | 覆盖空间分类与子群对应 | AT1/AT2 |
| AT3 | `algebraic-topology.singular.simplex` | 奇异单形、面算子与边界 | T4/HA2 |
| AT3 | `algebraic-topology.singular.chain-complex` | 奇异链复形与边界平方为零 | AT3.simplex |
| AT3 | `algebraic-topology.singular.homology` | 奇异同调及连续映射诱导 | AT3.chain |
| AT3 | `algebraic-topology.singular.homotopy-invariance` | 同伦不变性 | AT3.homology |
| AT3 | `algebraic-topology.singular.excision` | 切除定理 | AT3.homology |
| AT3 | `algebraic-topology.singular.mayer-vietoris` | Mayer–Vietoris 长正合列 | AT3.excision/HA3 |
| AT4 | `algebraic-topology.cellular.cw-complex` | CW 复形与胞腔附着 | T4 |
| AT4 | `algebraic-topology.cellular.homology` | 胞腔链复形与胞腔同调 | AT3/AT4.cw |
| AT4 | `algebraic-topology.degree.sphere-map` | 球面映射次数 | AT3 |
| AT4 | `algebraic-topology.fixed-point.brouwer` | Brouwer 不动点定理的同调证明 | AT4.degree |
| AT5 | `algebraic-topology.cohomology.definition` | 奇异上同调与上积 | AT3/HA2 |
| AT5 | `algebraic-topology.cohomology.cup-product` | cup product 与分次交换 | AT5.definition |
| AT5 | `algebraic-topology.cohomology.universal-coefficient` | 上同调普遍系数定理 | AT5/HA5.ext |
| AT5 | `algebraic-topology.homology.kuenneth` | Künneth 定理 | AT3/HA5.tor |
| AT6 | `algebraic-topology.homotopy.higher-groups` | 高阶同伦群与长正合列 | AT1 |
| AT6 | `algebraic-topology.hurewicz` | Hurewicz 同态与定理 | AT3/AT6 |
| AT6 | `algebraic-topology.whitehead` | Whitehead 定理 | AT4/AT6 |

**完成能力节点**：能计算基本群、覆盖空间、奇异/胞腔同调和上同调环，并以长正合列连接这些计算。

### 13.4 表示论（RT1–RT6）🔒

> 家族前缀 `representation-theory.*`。课程门：A1、A2、L1–L5；模表示路线另需 CA1。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| RT1 | `representation-theory.group-representation.definition` | 群表示、等价表示与交织算子 | A1/L2 |
| RT1 | `representation-theory.subrepresentation` | 子表示、商表示与直和 | RT1.definition |
| RT1 | `representation-theory.invariant-subspace` | 不变子空间、不可约与完全可约 | RT1.definition |
| RT1 | `representation-theory.group-algebra` | 群代数与表示—模对应 | A2/CA1 |
| RT2 | `representation-theory.schur-lemma` | Schur 引理及代数闭域推论 | RT1 |
| RT2 | `representation-theory.maschke` | Maschke 定理 | RT1/A2 |
| RT2 | `representation-theory.isotypic-decomposition` | 等型分量与半单分解 | RT2.maschke |
| RT2 | `representation-theory.regular-representation` | 正则表示与不可约重数 | RT2 |
| RT3 | `representation-theory.character.definition` | 特征标、类函数与内积 | RT1/L5 |
| RT3 | `representation-theory.character.orthogonality` | 行、列正交关系 | RT3.definition |
| RT3 | `representation-theory.character.decomposition` | 特征标分解与不可约判据 | RT3.orthogonality |
| RT3 | `representation-theory.character.table` | 特征标表及有限群例子 | RT3.decomposition |
| RT3 | `representation-theory.induction-restriction` | 诱导、限制与 Frobenius 互反 | RT1/CA3.tensor |
| RT4 | `representation-theory.symmetric-group.partitions` | 分拆、Young 图与 tableaux | A1 |
| RT4 | `representation-theory.symmetric-group.specht` | Specht 模构造 | RT4.partitions |
| RT4 | `representation-theory.symmetric-group.classification` | 对称群不可约表示分类 | RT4.specht/RT3 |
| RT5 | `representation-theory.lie-algebra.definition` | Lie 代数、子代数、理想与同态 | A2/L2 |
| RT5 | `representation-theory.lie-algebra.representation` | Lie 代数表示与包络代数 | RT5.definition/CA1 |
| RT5 | `representation-theory.lie-algebra.sl2` | `sl₂` 表示分类 | RT5.representation |
| RT5 | `representation-theory.lie-algebra.engel-lie` | Engel 与 Lie 定理 | RT5.definition |
| RT6 | `representation-theory.semisimple.root-system` | Cartan 子代数、根与权 | RT5/L5 |
| RT6 | `representation-theory.semisimple.weyl-group` | Weyl 群与根系 | `representation-theory.semisimple.root-system` |
| RT6 | `representation-theory.semisimple.highest-weight` | 最高权分类入口 | `representation-theory.semisimple.root-system` |
| RT6 | `representation-theory.semisimple.weyl-character` | Weyl 特征标公式 | `representation-theory.semisimple.highest-weight` |

**完成能力节点**：有限群特征标和半单 Lie 代数表示形成两条完整主线；Lie 入口不能代替整门 Lie 表示论。

### 13.5 微分流形（DM1–DM5）🔒

> 家族前缀 `differential-manifolds.*`。课程门：R6、T1–T4、L5；只负责光滑流形的语言、
> 切丛、形式与积分，不把微分拓扑或黎曼度量混入“流形基础”。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| DM1 | `differential-manifolds.manifold.definition` | 拓扑流形、图册与光滑结构 | R6/T4 |
| DM1 | `differential-manifolds.smooth-map` | 光滑映射、微分与链式法则 | DM1 |
| DM1 | `differential-manifolds.product-submanifold` | 乘积流形、子流形与边界 | DM1 |
| DM1 | `differential-manifolds.partition-of-unity` | bump 函数与单位分解 | DM1/T2 |
| DM2 | `differential-manifolds.tangent.derivation` | 曲线/导子两种切向量定义及等价 | DM1 |
| DM2 | `differential-manifolds.tangent-map` | 切映射、秩与函子性 | DM2 |
| DM2 | `differential-manifolds.tangent-bundle` | 切丛、余切丛及局部平凡化 | DM2 |
| DM2 | `differential-manifolds.vector-field` | 向量场、Lie 括号与自然性 | DM2 |
| DM3 | `differential-manifolds.flow.local` | 向量场局部流 | DM2/ODE2 |
| DM3 | `differential-manifolds.flow.complete` | 完备向量场与一参数微分同胚群 | DM3 |
| DM3 | `differential-manifolds.lie-group` | Lie 群、Lie 代数与指数映射入口 | DM2/A1 |
| DM4 | `differential-manifolds.forms.exterior-algebra` | 微分形式、楔积与拉回 | DM2/L5 |
| DM4 | `differential-manifolds.forms.exterior-derivative` | 外微分、Cartan 公式与 `d²=0` | DM4 |
| DM4 | `differential-manifolds.orientation` | 定向、带边流形与形式积分 | DM4/R4 |
| DM4 | `differential-manifolds.stokes` | 流形上的 Stokes 定理 | DM4 |
| DM5 | `differential-manifolds.derham-complex` | de Rham 复形、Poincaré 引理 | DM4/HA2 |
| DM5 | `differential-manifolds.derham-cohomology` | de Rham 上同调与同伦不变性 | DM5 |
| DM5 | `differential-manifolds.derham-theorem` | de Rham 定理 | DM5/AT5 |

**完成能力节点**：形成可被微分拓扑、黎曼几何和几何 PDE 共用的流形定义层。

### 13.6 微分拓扑（DT1–DT5）🔒

> 家族前缀 `differential-topology.*`。课程门：DM1–DM4、T4、AT1。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| DT1 | `differential-topology.rank-theorem` | 常秩、逆函数与隐函数定理 | DM2/R6 |
| DT1 | `differential-topology.immersion-submersion` | 浸入、浸没、嵌入的局部标准形 | DT1 |
| DT1 | `differential-topology.regular-value` | 正则值定理与水平集子流形 | DT1 |
| DT1 | `differential-topology.sard` | Sard 定理 | DT1/R4 |
| DT2 | `differential-topology.transversality.definition` | 横截性及稳定性 | DT1 |
| DT2 | `differential-topology.transversality.preimage` | 横截逆像定理 | DT2 |
| DT2 | `differential-topology.transversality.approximation` | 横截逼近与参数横截性 | DT2/Sard |
| DT2 | `differential-topology.embeddings.whitney` | Whitney 嵌入与浸入定理 | DT2 |
| DT3 | `differential-topology.degree.definition` | 映射度、局部度与定向计数 | DM4/DT1 |
| DT3 | `differential-topology.degree.homotopy` | 度的同伦不变性与乘法性 | DT3 |
| DT3 | `differential-topology.intersection-number` | 交数与横截交 | DT2/DT3 |
| DT3 | `differential-topology.fixed-point.lefschetz-entry` | Lefschetz 数与不动点入口 | DT3/AT5 |
| DT4 | `differential-topology.morse.function` | Morse 函数、临界点与 Morse 引理 | DT1 |
| DT4 | `differential-topology.morse.handle` | 把手附着与子水平集变化 | DT4 |
| DT4 | `differential-topology.morse-inequalities` | Morse 不等式 | DT4/AT3 |
| DT5 | `differential-topology.cobordism.definition` | 配边、配边群与 Pontryagin–Thom 入口 | DT2/AT6 |
| DT5 | `differential-topology.characteristic-classes` | Euler、Stiefel–Whitney、Chern 类 | DM2/AT5 |
| DT5 | `differential-topology.gauss-bonnet-topological` | Euler 类与 Gauss–Bonnet | DT3/DM4 |

**完成能力节点**：能以横截性、映射度和 Morse 理论研究流形的全局拓扑。

### 13.7 黎曼几何（RG1–RG7）🔒

> 家族前缀 `riemannian-geometry.*`。课程门：DM1–DM4、L5、ODE；比较几何另需实分析。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| RG1 | `riemannian-geometry.metric` | Riemann 度量、音乐同构与体积形式 | DM2/L5 |
| RG1 | `riemannian-geometry.length-distance` | 曲线长度、能量与 Riemann 距离 | RG1/T3 |
| RG1 | `riemannian-geometry.isometry` | 等距映射与局部等距 | RG1 |
| RG2 | `riemannian-geometry.connection` | 仿射联络、协变导数与挠率 | DM2 |
| RG2 | `riemannian-geometry.levi-civita` | Levi–Civita 存在唯一性与 Koszul 公式 | RG1/RG2 |
| RG2 | `riemannian-geometry.parallel-transport` | 平行移动与 holonomy 入口 | RG2/ODE |
| RG3 | `riemannian-geometry.geodesic` | 测地线方程与指数映射 | RG2/ODE |
| RG3 | `riemannian-geometry.gauss-lemma` | Gauss 引理与法坐标 | RG3 |
| RG3 | `riemannian-geometry.hopf-rinow` | Hopf–Rinow 完备性等价 | RG3/T3 |
| RG3 | `riemannian-geometry.first-variation` | 第一变分与测地线极值性 | RG3/R6 |
| RG4 | `riemannian-geometry.curvature.riemann` | 曲率张量、截面曲率与恒等式 | RG2 |
| RG4 | `riemannian-geometry.curvature.ricci-scalar` | Ricci、标量曲率与曲率算子 | RG4 |
| RG4 | `riemannian-geometry.jacobi-field` | Jacobi 场、共轭点与第二变分 | RG3/RG4 |
| RG5 | `riemannian-geometry.submanifold.second-form` | 第二基本形式、形算子与平均曲率 | DM1/RG2 |
| RG5 | `riemannian-geometry.gauss-codazzi` | Gauss、Codazzi、Ricci 方程 | RG5/RG4 |
| RG5 | `riemannian-geometry.minimal-submanifold-entry` | 极小子流形与一阶变分 | RG5 |
| RG6 | `riemannian-geometry.comparison.rauch` | Rauch 比较定理 | RG4/Jacobi |
| RG6 | `riemannian-geometry.comparison.toponogov` | Toponogov 三角形比较 | RG6/RG3 |
| RG6 | `riemannian-geometry.comparison.bishop-gromov` | Bishop–Gromov 体积比较 | RG4/R4 |
| RG6 | `riemannian-geometry.bonnet-myers` | Bonnet–Myers 与直径界 | RG6 |
| RG7 | `riemannian-geometry.laplacian` | Laplace–Beltrami 算子与 Bochner 公式 | RG2/PDE |
| RG7 | `riemannian-geometry.hodge-theory` | Hodge 星、调和形式与 Hodge 定理 | RG7/DM5/AFA |
| RG7 | `riemannian-geometry.gauss-bonnet` | Gauss–Bonnet–Chern | RG4/DM4/DT5 |

**完成能力节点**：覆盖局部张量计算、完备性、变分、曲率、比较几何和 Hodge 理论，不再把
黎曼几何压缩成“度量—曲率”数条。

### 13.8 随机过程（SP1–SP6）🔒

> 家族前缀 `stochastic-processes.*`。课程门：Pr1–Pr3、R4；随机分析另需高等泛函。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| SP1 | `stochastic-processes.definition` | 过程、有限维分布、修改与不可区分 | Pr1 |
| SP1 | `stochastic-processes.filtration-stopping-time` | 过滤、适应性、停时与可选 σ-代数 | Pr2 |
| SP1 | `stochastic-processes.kolmogorov-extension` | Kolmogorov 扩张定理 | Pr1/R4 |
| SP1 | `stochastic-processes.continuity-criterion` | Kolmogorov 连续性准则 | Pr3 |
| SP2 | `stochastic-processes.markov.kernel` | 转移核、Markov 性与半群 | SP1 |
| SP2 | `stochastic-processes.markov.chapman-kolmogorov` | Chapman–Kolmogorov 方程 | SP2 |
| SP2 | `stochastic-processes.markov.stationary` | 不变分布、遍历性与收敛 | SP2/Pr3 |
| SP2 | `stochastic-processes.markov.generator` | 生成元与 Kolmogorov 方程 | SP2/AFA |
| SP3 | `stochastic-processes.martingale.convergence` | 离散/连续时间鞅收敛 | Pr2 |
| SP3 | `stochastic-processes.martingale.optional-stopping` | 可选停时与抽样定理 | SP1/Pr2 |
| SP3 | `stochastic-processes.martingale.doob-meyer` | Doob–Meyer 分解 | SP3 |
| SP4 | `stochastic-processes.brownian.construction` | Brownian 运动构造与路径性质 | SP1 |
| SP4 | `stochastic-processes.brownian.markov` | 强 Markov 性与反射原理 | SP4 |
| SP4 | `stochastic-processes.brownian.local-time` | 局部时与占用时间公式 | SP4 |
| SP5 | `stochastic-processes.ito.integral` | Itô 积分、等距与局部鞅 | SP3/SP4 |
| SP5 | `stochastic-processes.ito.formula` | Itô 公式与二次变差 | SP5 |
| SP5 | `stochastic-processes.sde.existence-uniqueness` | SDE 强解存在唯一性 | SP5/ODE |
| SP5 | `stochastic-processes.girsanov` | Girsanov 变换 | SP5 |
| SP6 | `stochastic-processes.feynman-kac` | Feynman–Kac 公式 | SP5/PDE |
| SP6 | `stochastic-processes.diffusion-generator` | 扩散、生成元与鞅问题 | SP2/SP5 |

**完成能力节点**：从过程的可测性与路径版本推进到 Markov、鞅、Brownian、Itô、SDE 和扩散；
仅完成离散 Markov 链不能标记本学科完成。

### 13.9 常微分方程（ODE1–ODE6）🔒

> 家族前缀 `ode.*`。课程门：M4–M5、R6、L2、T3。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| ODE1 | `ode.initial-value.problem` | 初值问题、经典解与最大解 | R6 |
| ODE1 | `ode.picard-lindelof` | Picard–Lindelöf 存在唯一性 | R6/T3 |
| ODE1 | `ode.peano-existence` | Peano 存在定理 | R6 |
| ODE1 | `ode.continuous-dependence` | 对初值和参数连续依赖 | ODE1 |
| ODE2 | `ode.flow.semigroup` | 流、逃逸时间与延拓准则 | ODE1 |
| ODE2 | `ode.gronwall` | Grönwall 不等式及稳定性应用 | R4 |
| ODE2 | `ode.variation-of-constants` | 常数变易公式 | L2/ODE1 |
| ODE2 | `ode.linear.fundamental-matrix` | 基本矩阵、Wronskian 与 Liouville 公式 | L2 |
| ODE3 | `ode.linear.constant-coefficients` | 常系数系统与矩阵指数 | L4 |
| ODE3 | `ode.sturm-liouville` | Sturm 比较、振荡与边值问题 | R5/F3 |
| ODE4 | `ode.phase-plane` | 平衡点、线性化与相图 | ODE2/L4 |
| ODE4 | `ode.lyapunov.stability` | Lyapunov 稳定性与不变集原理 | ODE2 |
| ODE4 | `ode.stable-manifold` | 稳定/不稳定流形定理 | ODE2/AFA |
| ODE5 | `ode.poincare-bendixson` | Poincaré–Bendixson 定理 | ODE4/T4 |
| ODE5 | `ode.bifurcation.local` | 鞍结、叉形与 Hopf 分岔 | ODE4 |
| ODE5 | `ode.hamiltonian.system` | Hamilton 系统、辛结构与守恒量 | ODE2/DM |
| ODE6 | `ode.dynamical-systems.invariant-set` | ω-极限集、吸引子与复现 | ODE2/T3 |
| ODE6 | `ode.ergodic-entry` | 流的不变测度与遍历入口 | ODE6/Pr3 |

**完成能力节点**：同时覆盖定性存在唯一性、线性系统、稳定性、分岔和动力系统，而非只收集解公式。

### 13.10 偏微分方程（PDE1–PDE8）🔒

> 家族前缀 `pde.*`。课程门：R4–R6、F1–F3、AFA1；各方程先区分经典、弱、分布解。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| PDE1 | `pde.distributions.definition` | 测试函数、分布与分布导数 | R4/F1 |
| PDE1 | `pde.sobolev.definition` | 弱导数与 Sobolev 空间 | PDE1/AFA |
| PDE1 | `pde.sobolev.embedding` | Sobolev 嵌入、紧嵌入与迹 | PDE1 |
| PDE1 | `pde.mollifier-density` | 磨光、逼近与稠密性 | R4 |
| PDE2 | `pde.first-order.characteristics` | 一阶方程特征线法 | ODE |
| PDE2 | `pde.conservation-law.weak-solution` | 守恒律弱解、熵解与 Rankine–Hugoniot | PDE1 |
| PDE2 | `pde.conservation-law.l1-contraction` | 熵解唯一性与 `L¹` 压缩 | PDE2 |
| PDE3 | `pde.laplace.fundamental-solution` | Laplace 方程基本解与平均值性质 | R4 |
| PDE3 | `pde.laplace.maximum-principle` | 强弱最大值原理与唯一性 | PDE3 |
| PDE3 | `pde.poisson.green-function` | Green 函数与 Poisson 核 | PDE3/HAna1 |
| PDE3 | `pde.elliptic.variational` | Lax–Milgram 与弱解存在性 | AFA/F3 |
| PDE3 | `pde.elliptic.regularity` | 内部/边界正则性 | PDE1/PDE3 |
| PDE4 | `pde.heat.kernel` | 热核、半群与平滑 | AFA/PDE3 |
| PDE4 | `pde.heat.energy-maximum` | 能量法、最大值原理与唯一性 | PDE4 |
| PDE4 | `pde.parabolic.regularity` | 抛物正则性入口 | PDE1/PDE4 |
| PDE5 | `pde.wave.energy` | 波方程能量、有限传播速度 | AFA |
| PDE5 | `pde.wave.duhamel` | Duhamel 原理与解公式 | PDE5 |
| PDE6 | `pde.nonlinear.fixed-point` | 压缩映射与局部适定性 | AFA/ODE |
| PDE6 | `pde.nonlinear.energy-method` | 先验估计、延拓与爆破解择 | PDE6 |
| PDE6 | `pde.navier-stokes.weak-existence` | Leray–Hopf 弱解入口 | PDE1/AFA |
| PDE7 | `pde.viscosity.definition` | 黏性解、比较原理与稳定性 | R6 |
| PDE7 | `pde.hamilton-jacobi` | Hamilton–Jacobi 方程与 Hopf–Lax | PDE7/ODE |
| PDE8 | `pde.microlocal.wavefront-entry` | Fourier 变换、奇性与波前集入口 | HA/PDE1 |

**完成能力节点**：能区分并连接经典解、弱解、分布解和黏性解，具备椭圆、抛物、双曲及非线性
方程的基本存在唯一性、正则性和先验估计链。

### 13.11 高等泛函分析（AFA1–AFA6）🔒

> 家族前缀 `advanced-functional-analysis.*`。课程门：F1–F4、R4、L5。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| AFA1 | `advanced-functional-analysis.locally-convex` | 局部凸空间、半范数族与对偶 | F2 |
| AFA1 | `advanced-functional-analysis.hahn-banach.separation` | 几何分离与 Minkowski 泛函 | F2 |
| AFA1 | `advanced-functional-analysis.weak-topologies` | 弱/弱星拓扑与极拓扑 | F2/T1 |
| AFA1 | `advanced-functional-analysis.banach-alaoglu` | Banach–Alaoglu 与弱紧致性 | AFA1/T2 |
| AFA2 | `advanced-functional-analysis.reflexivity` | 自反、可分与弱紧性判据 | AFA1 |
| AFA2 | `advanced-functional-analysis.uniform-convexity` | 一致凸与 Milman–Pettis | AFA2 |
| AFA2 | `advanced-functional-analysis.compact-operator` | 紧算子、逼近与 Fredholm 备择 | F3 |
| AFA3 | `advanced-functional-analysis.unbounded-operator` | 闭算子、伴随与图范数 | F3 |
| AFA3 | `advanced-functional-analysis.selfadjoint.spectral` | 无界自伴算子谱定理 | AFA3 |
| AFA3 | `advanced-functional-analysis.functional-calculus` | 连续/Borel 函数演算 | F4/AFA3 |
| AFA4 | `advanced-functional-analysis.semigroup.definition` | `C₀` 半群及生成元 | AFA3 |
| AFA4 | `advanced-functional-analysis.hille-yosida` | Hille–Yosida 定理 | AFA4 |
| AFA4 | `advanced-functional-analysis.stone-theorem` | 酉群与 Stone 定理 | AFA3 |
| AFA5 | `advanced-functional-analysis.distributions` | Schwartz 空间、温和分布与对偶 | AFA1 |
| AFA5 | `advanced-functional-analysis.nuclear-space-entry` | 核空间与 Schwartz 核定理 | AFA5 |
| AFA6 | `advanced-functional-analysis.banach-algebra` | Banach 代数、谱与 Gelfand 变换 | F4 |
| AFA6 | `advanced-functional-analysis.cstar-representation` | C*-代数、正泛函与 GNS | AFA6 |
| AFA6 | `advanced-functional-analysis.von-neumann-entry` | von Neumann 代数与双交换子 | AFA6 |

**完成能力节点**：在 Banach 三大定理之后建立弱拓扑、紧算子、无界算子、半群、分布和算子代数
主线，为 PDE、随机过程与调和分析提供稳定接口。

### 13.12 调和分析（HAna1–HAna7）🔒

> 家族前缀 `harmonic-analysis.*`。课程门：R4、F1–F3、AFA；避免与同调代数 HA 缩写混淆。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| HAna1 | `harmonic-analysis.fourier.rn` | `ℝⁿ` Fourier 变换、反演与 Plancherel | R4/F3 |
| HAna1 | `harmonic-analysis.fourier.schwartz` | Schwartz 空间与温和分布 | AFA5 |
| HAna1 | `harmonic-analysis.convolution` | 卷积、近似恒等与 Young 不等式 | R4 |
| HAna2 | `harmonic-analysis.fourier-series.convergence` | Fourier 级数的点态与 `L²` 收敛 | HAna1 |
| HAna2 | `harmonic-analysis.poisson-summation` | Poisson 求和公式 | HAna1 |
| HAna3 | `harmonic-analysis.maximal.hardy-littlewood` | Hardy–Littlewood 极大算子 | R4 |
| HAna3 | `harmonic-analysis.differentiation-integrals` | Lebesgue 微分定理 | HAna3 |
| HAna3 | `harmonic-analysis.interpolation` | Riesz–Thorin 与 Marcinkiewicz 插值 | F2/R4 |
| HAna4 | `harmonic-analysis.singular-integral.hilbert` | Hilbert 变换与 `Lᵖ` 有界性 | HAna3 |
| HAna4 | `harmonic-analysis.calderon-zygmund` | Calderón–Zygmund 分解与算子 | HAna3 |
| HAna4 | `harmonic-analysis.littlewood-paley` | Littlewood–Paley 分解与平方函数 | HAna1 |
| HAna5 | `harmonic-analysis.hardy-bmo` | Hardy 空间、BMO 与对偶 | HAna4 |
| HAna5 | `harmonic-analysis.sobolev-besov` | Sobolev、Besov 与 Triebel–Lizorkin 入口 | HAna4/PDE1 |
| HAna6 | `harmonic-analysis.locally-compact-group` | Haar 测度与群卷积 | A1/R4 |
| HAna6 | `harmonic-analysis.pontryagin-duality` | 局部紧 Abel 群 Fourier 理论 | HAna6 |
| HAna6 | `harmonic-analysis.peter-weyl` | 紧群 Peter–Weyl 定理 | HAna6/RT |
| HAna7 | `harmonic-analysis.oscillatory-integral` | 振荡积分与驻相法 | C3/R6 |
| HAna7 | `harmonic-analysis.restriction-entry` | Fourier 限制问题入口 | HAna7 |

**完成能力节点**：从 Fourier/卷积推进到极大函数、奇异积分、函数空间和群上的调和分析；
只证明 Fourier 反演或 Plancherel 不算完成。

### 13.13 代数几何（AG1–AG10）🔒

> 家族前缀 `algebraic-geometry.*`。课程门：CA1–CA6、A3、HA1–HA5。它是独立的大型路线，
> 仿射簇课程只能算 AG1–AG2，不能代表概形、层上同调或高维几何。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| AG1 | `algebraic-geometry.affine-variety.definition` | 仿射代数集、坐标环与正则函数 | A3/CA |
| AG1 | `algebraic-geometry.nullstellensatz` | Hilbert 零点定理 | CA4/A3 |
| AG1 | `algebraic-geometry.zariski-topology` | Zariski 拓扑与不可约分支 | AG1 |
| AG1 | `algebraic-geometry.affine-variety.morphism` | 正则映射与坐标环反变对应 | AG1 |
| AG2 | `algebraic-geometry.projective-space` | 射影空间、齐次理想与 Proj 前置 | AG1 |
| AG2 | `algebraic-geometry.projective-variety` | 射影簇、射影闭包与 Segre/Veronese | AG2 |
| AG2 | `algebraic-geometry.dimension.variety` | 簇的维数、超越次数与纤维维数 | CA6/AG1 |
| AG2 | `algebraic-geometry.bezout-entry` | 平面曲线交数与 Bézout | AG2/CA |
| AG3 | `algebraic-geometry.sheaf.presheaf` | 预层、层、茎与层化 | HA1/T1 |
| AG3 | `algebraic-geometry.ringed-space` | 环空间、局部环空间与态射 | AG3/CA6 |
| AG3 | `algebraic-geometry.affine-scheme.spec` | `Spec`、结构层与仿射概形 | CA3/AG3 |
| AG3 | `algebraic-geometry.scheme.definition` | 概形、开子概形与粘合 | AG3 |
| AG3 | `algebraic-geometry.affine-scheme.equivalence` | 仿射概形与交换环反等价 | AG3 |
| AG4 | `algebraic-geometry.scheme.fiber-product` | 纤维积与基变换 | AG3/HA1 |
| AG4 | `algebraic-geometry.scheme.separated` | 分离态射、对角态射与 proper 前置 | AG4 |
| AG4 | `algebraic-geometry.scheme.finite-type` | 有限型、有限表示与拟紧拟分离 | AG4/CA2 |
| AG4 | `algebraic-geometry.scheme.proper` | proper 态射与赋值判据 | AG4 |
| AG4 | `algebraic-geometry.scheme.smooth-etale` | 光滑、非分歧与 étale 态射 | AG4/CA5 |
| AG5 | `algebraic-geometry.quasicoherent-sheaf` | 拟凝聚层与模的层化 | AG3/CA1 |
| AG5 | `algebraic-geometry.line-bundle` | 可逆层、除子与 Picard 群 | AG5 |
| AG5 | `algebraic-geometry.differentials` | Kähler 微分、切空间与光滑判据 | CA1/AG4 |
| AG5 | `algebraic-geometry.divisor.cartier-weil` | Cartier/Weil 除子及正规概形对应 | AG5/CA5 |
| AG6 | `algebraic-geometry.sheaf-cohomology.definition` | 导出函子层上同调 | AG3/HA4 |
| AG6 | `algebraic-geometry.cech-cohomology` | Čech 上同调及比较 | AG6 |
| AG6 | `algebraic-geometry.affine-vanishing` | 仿射概形拟凝聚层高次上同调消失 | AG5/AG6 |
| AG6 | `algebraic-geometry.serre-finiteness` | 射影概形上同调有限性 | AG2/AG6 |
| AG6 | `algebraic-geometry.serre-duality` | Serre 对偶 | AG6/HA5 |
| AG7 | `algebraic-geometry.curves.function-field` | 光滑射影曲线与函数域 | AG2/AG4 |
| AG7 | `algebraic-geometry.curves.riemann-roch` | 曲线 Riemann–Roch | AG5/AG6 |
| AG7 | `algebraic-geometry.curves.genus-jacobian` | genus、Jacobian 与 Abel–Jacobi | AG7 |
| AG7 | `algebraic-geometry.curves.riemann-hurwitz` | Riemann–Hurwitz | AG7/AG5 |
| AG8 | `algebraic-geometry.intersection.chow-group` | 代数循环、合理等价与 Chow 群 | AG5 |
| AG8 | `algebraic-geometry.intersection-product` | 光滑簇交叉积 | AG8/HA5 |
| AG8 | `algebraic-geometry.grothendieck-riemann-roch-entry` | GRR 入口 | AG8/AG6 |
| AG9 | `algebraic-geometry.surfaces.blowup` | 爆破、例外除子与消解入口 | AG4/AG5 |
| AG9 | `algebraic-geometry.surfaces.classification-entry` | 曲面最小模型与分类入口 | AG9 |
| AG10 | `algebraic-geometry.etale.site` | étale site 与 étale 上同调入口 | AG4/AG6 |
| AG10 | `algebraic-geometry.moduli.functor` | 模空间函子与可表示性问题 | AG4/HA1 |
| AG10 | `algebraic-geometry.deformation-entry` | 形变、切障碍空间与 cotangent complex 入口 | AG5/HA5 |

**完成能力节点**：仿射/射影簇、概形与态射、拟凝聚层、上同调、曲线、交叉理论形成连续依赖链；
AG3–AG10 未完成时，不得把“代数几何”标为完成。

### 13.14 数理逻辑（ML1–ML7）🔒

> 家族前缀 `mathematical-logic.*`。课程门：ST1–ST2；可计算性路线与 ST3 共享底层编码，必须指定
> 单一文件所有者，避免集合论和逻辑分支各自定义一套机器模型。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| ML1 | `mathematical-logic.syntax.first-order-language` | 一阶语言、项与公式 | ST1 |
| ML1 | `mathematical-logic.syntax.substitution` | 代入、自由变量与变量捕获规避 | ML1.language |
| ML1 | `mathematical-logic.semantics.structure` | 结构、赋值与满足关系 | ML1.syntax |
| ML1 | `mathematical-logic.semantics.elementary-equivalence` | 理论、模型与初等等价 | ML1.structure |
| ML2 | `mathematical-logic.proof-system.deduction` | 形式证明、演绎定理与可靠性 | ML1 |
| ML2 | `mathematical-logic.model-theory.compactness` | 一阶紧致性定理 | ML2/ST2.choice |
| ML2 | `mathematical-logic.model-theory.completeness` | Gödel 完备性定理 | ML2.deduction |
| ML2 | `mathematical-logic.model-theory.lowenheim-skolem` | 向上/向下 Löwenheim–Skolem | ML2.compactness |
| ML3 | `mathematical-logic.model-theory.types` | 类型、实现与饱和模型 | ML2 |
| ML3 | `mathematical-logic.model-theory.quantifier-elimination` | 量词消去与典型理论 | ML2 |
| ML3 | `mathematical-logic.model-theory.back-and-forth` | back-and-forth 与可数范畴性 | ML3.types |
| ML4 | `mathematical-logic.computability.machine` | 寄存器机/Turing 机的统一计算模型 | ST3 |
| ML4 | `mathematical-logic.computability.partial-recursive` | 部分递归函数与机器等价 | ML4.machine |
| ML4 | `mathematical-logic.computability.enumerability` | 可判定、可枚举及闭包性质 | ML4.partial-recursive |
| ML4 | `mathematical-logic.computability.halting` | 停机问题不可判定 | ML4.enumerability |
| ML4 | `mathematical-logic.computability.rice` | Rice 定理 | ML4.halting |
| ML5 | `mathematical-logic.arithmetic.goedel-numbering` | 语法 Gödel 编码与基本操作可表示性 | ML1/ML4 |
| ML5 | `mathematical-logic.arithmetic.representability` | 递归关系的算术可表示性 | ML5.encoding |
| ML5 | `mathematical-logic.arithmetic.diagonal-lemma` | 对角引理 | ML5.representability |
| ML5 | `mathematical-logic.arithmetic.first-incompleteness` | 第一不完备定理 | ML5.diagonal |
| ML5 | `mathematical-logic.arithmetic.second-incompleteness` | 第二不完备定理 | ML5.first |
| ML6 | `mathematical-logic.set-theory.zf-models` | ZF 模型与相对一致性语言 | ST2/ML2 |
| ML6 | `mathematical-logic.set-theory.constructible-universe` | 可构造宇宙 L | ST1/ML6.models |
| ML6 | `mathematical-logic.set-theory.choice-independence-entry` | 选择公理独立性方法入口 | ML6 |
| ML6 | `mathematical-logic.set-theory.forcing-entry` | forcing 偏序、名字与真值关系入口 | ML6.models |
| ML7 | `mathematical-logic.proof-theory.ordinals` | 证明论序数与序数分析入口 | ST3/ML5 |
| ML7 | `mathematical-logic.proof-theory.cut-elimination` | 相继式演算与切消 | ML2 |
| ML7 | `mathematical-logic.proof-theory.consistency` | Gentzen 一致性证明入口 | ML7/ST3 |

**完成能力节点**：模型论、可计算性、不完备性和证明论分别形成可追踪主线；“数理逻辑完成”只有
在各路线独立达到 §15 标准后才能声明，不能用一条完备/不完备定理代表整门学科。

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
