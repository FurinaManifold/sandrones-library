# Sandrone's Library — 长远批次规划（数学大厦扩展蓝图）

> **定位**：本文件是全库课程进度、学科先后顺序与批次规划的**唯一事实源**。除跨学科计算例与
> 反例专项账本 `ROADMAP-examples.md` 外，不再用第二份 ROADMAP 保存某门课程的章节蓝图。本文件把每一门课拆成
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
4. **教材映射先于批次设计**：每门已有主教材的课程必须先登记“教材主题 → 本库批次 → 偏离理由”。
   教材未覆盖的内容只能标为补充专题、跨学科桥或“教材待指定”，不得仅凭 Mathlib API 列表扩成
   新章节；已完成条目不因章节编号变化重造接口，但其课程归属必须按教材重新校准。

---

## 1. 阶段顺序总览

| 阶段 | 课程（家族前缀） | 批次 | 前驱 |
|---|---|---|---|
| **Phase 1 分析线** | `analysis.*` | M1✅ M2✅ M3✅ M4✅ M5✅ AN3🔒 AN-MV🚧 | — |
| **Phase 2 线性代数** | `linear-algebra.*` | L1-L7✅ | 集合论预备 |
| **Phase 3 抽象代数** | `abstract-algebra.*` | A1✅ A2✅ A3✅ | 等价关系/商集 |
| **Phase 4 拓扑学基础** | `topology.*` | T1-T3✅ T4🚧（复分析负责人转入） | 集合论 + 分析线直观 |
| **Phase 5 实分析** | `real-analysis.*` | R1-R4✅ RA-F1–RA-F6🚧 | T3 + M 系列 |
| **Phase 6 复分析** | `complex-analysis.*` | C0/C0.5/C1✅；C2-C3⏸（等待 T4） | R2 T3 M4 T4 |
| **Phase 7 泛函分析** | `functional-analysis.*` | F1-F3✅ F4🚧 F5-F8🔒 | L5 T3 R4 C1 |
| **Phase 8 概率论** | `probability.*` | Pr1🚧 Pr2-Pr3🔒 | R4 |
| **Phase 9 统计推断** | `statistics.*` | S1-S2🔒 | Pr1/Pr3 |
| **Phase 10 数论分支** | `number-theory.*` | N1✅ N2.1–N2.3🚧/其余🔒 N3🔒 | A2/A3；N3 另需 C1-C3 |
| **Phase 11 集合论深化** | `settheory.*` | ST1✅ ST2基础✅/等价🔲 ST3基础58项✅/纵深🚧 | 集合/关系/Zorn；ST3 另需可计算性 |
| **Phase 12+ 高阶学科群** | 交换/同调/代数几何、代数拓扑、表示论、流形/微分拓扑/黎曼几何、ODE/PDE、随机过程、高等泛函、Fourier/调和分析、多复变、Riemann 曲面、博弈论、数理逻辑 | 各学科独立路线🔒 | 各自课程门达标 |
| **持续学科 Examples** | `examples.*` | E0🚧 E1-E4🔒 | 巡视所有已进入 main 的课程条目 |
| **常驻书稿《水仙十字的世界式》** | `docs/world-formula/*` | WF0✅ WF1🚧 WF2–WF3🔒/滚动开放 | 只消费已验收 Entry、合规出版背景和明确标记的远景 |

**状态单一来源**：本表是全库阶段状态的唯一摘要；各章节只给条目级范围与边界，不另建第二张
阶段进度表。✅ 只表示已进入 main、Registry 为 verified 且 main 全库验收通过；`staging`、
`review` 和未跟踪成果一律记 🚧，不能提前算完成。状态变化由 main 在集成提交中同时更新本表和
对应章节，不允许只改其中一处。

**为什么实分析在拓扑之后、且用测度积分**：测度论需要 σ-代数/可测空间（拓扑的抽象层）；
而 mathlib 内置积分是**一般测度的 Lebesgue 积分**，不是黎曼积分——所以一元微积分只做到导数/中值，
积分本体放到 R 用测度积分承载（覆盖黎曼的微积分基本定理/换元/收敛定理，且是概率/泛函的地基）。

**为什么 Examples 是持续学科而不是最后一章**：例子必须在理论接口仍新鲜时验证其可计算性和概念
边界，不能等全库完成后集中补题。每次 Main 集成新增重要知识点后都产生一次 Examples 覆盖巡检；
详细规则和跨学科清单见 `ROADMAP-examples.md`。

**为什么《水仙十字的世界式》是常驻任务**：Entry 文档解释单个知识点，ROADMAP 维护课程路径，
但二者都不负责把多个学科写成一部连续的数学世界图景。本书沿当前依赖图反复吸收已经进入 Main 的
资产，用综合文章统一术语、前驱和跨学科联系。它不是第二份 Registry、ROADMAP 或教材完成表，也
不承诺足够习题用于授课。目录、写作边界和双重审稿见 `docs/world-formula/README.md` 与
`docs/world-formula/REVIEW-PROTOCOL.md`。

**职责硬边界**：本文件各理论学科路线只分配一般定义、结构、定理和供例子调用的计算接口；不得把
具体数值题、标准对象实例、低维／低阶计算或反例作为该理论学科负责人的后续开发窗口。此类任务
一律登记到 `ROADMAP-examples.md`，由 Examples 负责人领取。理论负责人只需保证公开接口足够使用，
并在 handoff 提交 Examples 需求清单；不得自行在理论目录扩建新的 example 批次。历史上已经进入
main 的理论命名例子 Entry 暂不破坏性迁移，但其补例、扩展和维护改由 Examples 负责人承担。
即使主教材把例题紧接在定理后面，Main 也必须在排期时拆成“理论接口”和“Examples 实例化”两个
所有权不同的项目；不得因为例题是教材章节的一部分，就把它继续派给理论学科负责人。

### 1.1 《水仙十字的世界式》常驻批次

| 批次 | 范围 | 开工门 | 接收出口 |
|---|---|---|---|
| WF0 书稿基础设施 | 定位、卷册骨架、主编 ROLE、来源账与双重审稿协议 | 无 | Main 接收规范；不冒充已有正式章节 |
| WF1 第一条依赖主线 | 集合／函数语言 → 分析与线性结构 → 抽象代数与拓扑基础 | 对应 Entry 已 verified | 章节逐断言可追溯，概念首现与跨章链接冻结 |
| WF2 成熟学科扩展 | 实分析、数论、复分析、概率、泛函分析 | 只领取已集成部分；未开门内容仅作明确远景 | 每个学科至少一篇路径综述与两个跨学科连接 |
| WF3 高阶综合 | Fourier/调和、PDE、几何、代数拓扑、范畴／同调／代数几何、逻辑与重要论文 | 各自课程门满足 | 正式章节与出版背景严格分栏；不得用论文摘要替代知识链 |

WF0 已完成，WF1 持续 `development_open`；WF2/WF3 按各学科已验收资产滚动开放，不要求全库先
“完成”。每个章节记录事实截止 Main commit，后续源条目变化触发文字维护审计，而不是静默过时。

### 1.2 多学科并行生产路线（main 调度基线）

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
| G-A2 | A2.2–A2.9 的理想、整除、PID/UFD、CRT、局部化完成 | A3 深层、N2.1–N2.3 | ✅ |
| G-A3 | 域扩张、次数、分裂域、可分/正规扩张完成 | Galois、N2 数域主线 | ✅ |
| G-T4/C | 本库道路同伦、相对端点同伦、同伦等价与基本群接口完成，并补连续同伦到复路径积分所需的正则化桥 | 恢复 C2 一般同伦不变、单连通域原函数，再推进 C3 | 🚧（当前优先门） |
| G-C | T4 桥完成后，C1–C3 的全纯、复积分、解析延拓与残数接口完成 | N3.2–N3.5 | ⏸（等待 G-T4/C） |
| G-Pr | Pr1 概率空间、随机变量、期望和独立性完成 | Pr2、统计 S1 | ✅ |
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
| ✅ G-ST 已打开 | ST3 深层 | 原始递归函数类；一般 Goodstein 正规化；通用机语义与翻转编译器正确性定理 | 支配、终止、不可计算性仍须逐项证明；具体机器程序与运行轨迹归 Examples E1.8 |

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

## 2. Phase 1 — 分析线（M1-M5 ✅；AN3🔒）

> 家族前缀 `analysis.`；命名示例：`analysis.continuity.definition`、`analysis.derivative.chain-rule`。
>
> **教材框架**：M1–M5 与 AN-MV 以华东师范大学《数学分析》第五版为中文课程主教材，按照极限、
> 连续、微分、积分、级数和多元微积分的通常先后组织；第三学期 AN3 单独以卓里奇
> *Mathematical Analysis II* 第二版第 16–18 章为主线。前者负责基础教学顺序，后者负责函数列、
> 含参积分、Fourier 级数与 Fourier 变换初步；两条线不得互相占用编号。对应文献键分别为
> `ecnu-mathematical-analysis-5` 与 `zorich-mathematical-analysis-ii-2016`。

| 教材段落 | 本库批次 | 路线决定 |
|---|---|---|
| 极限、连续与一元微分 | M1–M5 | 保持“定义—运算—核心定理—应用”的基础顺序 |
| 多元微分、重积分、曲线曲面积分 | AN-MV | 独立于现代测度论，不再误编号为实分析 |
| 一致收敛与函数族 | AN3-1–AN3-4 | 先冻结一致控制，再交换极限、导数与积分 |
| 含参积分 | AN3-5–AN3-9 | 位于 Fourier 理论之前，卷积作为含参积分应用引入 |
| Fourier 级数与 Fourier 变换初步 | AN3-10–AN3-15 | 以卓里奇终章为出口；Plancherel/分布留给后续学科 |

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

### AN3 / Analysis 第三学期 🔒

主参照为卓里奇《数学分析》第二卷第 16--18 章。它承接一元分析和多元微积分，终点是 Fourier
变换初步；Folland 现代实分析路线另见 §6，不占用 AN3 编号。

| 批次 | 条目家族 | 内容 | 前置／完成出口 |
|---|---|---|---|
| AN3-1 | `analysis.function-sequence.uniform-convergence` | 函数列／函数项级数的一致收敛、Cauchy 判据、Weierstrass M 判别法 | 教材定义、点态关系和一致 Cauchy 等价齐全 |
| AN3-2 | `analysis.function-sequence.limit-operations` | 一致极限保持连续；极限与积分交换 | AN3-1；给出假设精确的交换次序定理 |
| AN3-3 | `analysis.function-sequence.derivative-exchange` | 导函数列一致收敛时逐项求导及必要基点条件 | AN3-1；不把函数列本身一致收敛误当充分条件 |
| AN3-4 | `analysis.function-family.uniform` | 带参数函数族的一致、局部一致与正规收敛 | 为含参积分和 Fourier 级数冻结统一接口 |
| AN3-5 | `analysis.parameter-integral.continuity` | 正常积分的参数连续性与一致连续控制 | AN3-2、AN3-4 |
| AN3-6 | `analysis.parameter-integral.differentiation` | 积分号下求导及支配／一致控制条件 | AN3-3、AN3-5 |
| AN3-7 | `analysis.parameter-integral.improper` | 广义含参积分的一致收敛、连续性及求导 | AN3-4--AN3-6 |
| AN3-8 | `analysis.parameter-integral.special-functions` | Gamma/Beta 型积分所需的参数恒等式与一般理论接口 | AN3-6、AN3-7；具体计算归 Examples |
| AN3-9 | `analysis.convolution.intro` | 卷积的定义、基本运算及与含参积分的关系 | AN3-5--AN3-7 |
| AN3-10 | `analysis.fourier-series.orthogonal-system` | 正交函数系、Fourier 系数／级数与 Bessel 不等式 | AN3-1；积分内积 |
| AN3-11 | `analysis.fourier-series.trigonometric` | 三角 Fourier 系数、部分和与 Dirichlet 核 | AN3-10；三角恒等式 |
| AN3-12 | `analysis.fourier-series.pointwise-convergence` | Dirichlet/Jordan 型逐点收敛，跳跃点取左右极限平均 | AN3-7、AN3-11 |
| AN3-13 | `analysis.fourier-series.smoothness-decay` | 光滑性与 Fourier 系数衰减、逐项微分边界 | AN3-3、AN3-12 |
| AN3-14 | `analysis.fourier-series.completeness` | 三角系完备性、Parseval 等式与均方收敛 | AN3-10--AN3-13 |
| AN3-15 | `analysis.fourier-transform.intro` | Fourier 积分表示、变换定义及微分／平移／缩放／卷积性质 | AN3-6、AN3-9、AN3-12--AN3-14 |

AN3-10--AN3-14 是第三学期正文，不得整体后移到调和分析。AN3-15 只做到卓里奇第 18 章意义下的
Fourier 变换初步，须明确归一化、积分存在和反演正则性条件；`L²(ℝⁿ)` Plancherel 延拓、Schwartz
空间、温和分布、Poisson 求和、奇异积分和局部紧群 Fourier 理论仍归 `harmonic-analysis.*`。

### AN-MV 多元微积分收尾 🚧

原旧路线曾误称“实分析 R6”；现统一归回数学分析路线。已完成 Fréchet 微分、梯度/Jacobian、
Hessian/Taylor、反函数／隐函数／常秩定理、多重积分与换元、坐标积分、曲线曲面参数化及第一型
积分。剩余课程出口为：

| # | 条目 id | 内容 | 主要接口 |
|---|---|---|---|
| 1 | `analysis.forms.coordinate-expression` | 1/2/3-形式显式坐标表达 | 本库 `DifferentialForm` |
| 2 | `analysis.forms.leibniz` | 外微分对楔积的分次 Leibniz 公式 | 外微分/楔积接口 |
| 3 | `analysis.forms.poincare` | 星形域上的 Poincaré 引理 | 同伦算子与积分 |
| 4 | `analysis.stokes.domain-gluing` | 参数片拼成一般分片光滑区域 | 已有三大公式片接口 |
| 5 | `analysis.coordinate-integrals.mass-center` | 质量、重心、转动惯量理论接口 | 坐标换元 API；计算题归 Examples |
| 6 | `analysis.multivariable.course-boundary` | 分析 II 覆盖范围与 de Rham 边界 | 本库多元分析 API |

边界：本路线只到欧氏空间上的第二型积分、Green--Gauss--Stokes 与 Poincaré 型结论；de Rham
上同调、同伦不变性和 de Rham 定理归微分几何／代数拓扑。

---

## 3. Phase 2 — 线性代数（L1-L7 ✅）

> 家族前缀 `linear-algebra.`。mathlib 线性代数是模语言（`Module`/`Submodule`/`Basis`），
> 向量空间 = 系数为域（`Field`）的模。叙述层先做"域上模 = 向量空间"翻译。
>
> **教材框架**：L1–L5 的抽象向量空间、线性映射、特征理论与内积空间以 Sheldon Axler,
> *Linear Algebra Done Right* 第三版为主教材；行列式在本库中的位置可以早于该书，但不得因此
> 跳过“算子先于矩阵”的概念顺序。L5 的矩阵谱专题以及 L6–L7 的正规／酉矩阵、矩阵群、Schur、
> SVD、极分解等以 Horn–Johnson, *Matrix Analysis* 第二版为专题主教材。Axler 不负责数值分解，
> Horn–Johnson 也不替代 L1–L4 的向量空间定义链。文献键为 `axler-linear-algebra-2015`、
> `horn-johnson-matrix-analysis-2013`。

| 教材主题 | 本库批次 | 路线调整 |
|---|---|---|
| Axler：向量空间、线性映射、特征理论、内积空间 | L1、L2、L4、L5 | 作为主干；L3 行列式是配合矩阵表示的插入批次 |
| Horn–Johnson Chs. 1–4：相似、酉等价、规范形、Hermitian | L4–L6 非辛部分 | 承担矩阵谱与正规矩阵专题 |
| Horn–Johnson Chs. 3、5、7：三角分解、范数、正定矩阵 | L7 | 依次组织 Schur/QR、范数/SVD、Cholesky/极分解；消元作前置 |
| McDuff–Salamon：线性辛空间 | L6 的辛矩阵与辛基 | 改列补充教材线，不再声称来自 Horn–Johnson |

L7 的 Moore–Penrose 伪逆和数值稳定性若超出 Horn–Johnson 当前章节的证明范围，只能作为 SVD
下游补充；不得把“数值线性代数基础”扩成没有另一本数值教材支撑的算法课程。

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
> **教材框架**：A1–A3 统一以 Dummit–Foote, *Abstract Algebra* 第三版为主教材：群论部分确定
> A1，环、理想与多项式部分确定 A2 及 A3.1–A3.2，域扩张、可分／正规扩张与 Galois 理论确定
> A3 后半。该书的模论和更深交换代数内容不提前塞入 A2/A3，而归 §13.1；本库批次可以因 Lean
> 依赖调整证明次序，但不得改变这条概念依赖。文献键为 `dummit-foote-abstract-algebra-2004`。
>
> 教材批次映射固定为：Dummit–Foote 的群与群作用对应 A1；环、理想、商环、整除和多项式对应
> A2 与 A3.1–A3.2；域扩张、代数闭包、分裂域、可分／正规扩张和 Galois 对应 A3.3–A3.9。
> 因此 Galois 基本定理不得早于有限扩张、分裂域、可分与正规四个出口；模、张量积和 Noether
> 理论继续归 CA，不再用“抽象代数后续”绕过课程门。
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

### A2 环 ✅

> 现有 `AbstractAlgebra/Ring.lean` 覆盖子环、理想、商环、素/极大理想和第一同构
> 定理的基础接口。完整章节还需系统处理整除理论和典型构造。

| # | 条目 | 内容 | 状态 |
|---|---|---|---|
| 1 | `abstract-algebra.ring.def` | 环、交换环、单位、子环与环同态的基本性质 | ✅（本库定义层与实现桥已完成） |
| 2 | `abstract-algebra.ring.ideal` | 左/右/双边理想、生成理想与理想和积 | ✅（本库定义层与运算桥已完成） |
| 2.5 | `abstract-algebra.ring.quotient` | 模双边理想同余、商环、投影、核与泛性质 | ✅（本库商集构造已完成） |
| 3 | `abstract-algebra.ring.iso-theorems` | 本库第一、第二、第三同构定理与理想对应；旧 `ring.iso` 保留为 Mathlib 兼容入口 | ✅ |
| 4 | `abstract-algebra.ring.domain` | 零因子、整环与域的本库公理定义 | ✅（定义层与 Mathlib 桥已完成） |
| 4.5 | `abstract-algebra.ring.prime-ideal` | 素理想、极大理想及商整环／商域双向判据 | ✅ |
| 5 | `abstract-algebra.ring.divisibility` | 整除、相伴、不可约与素元、最大公因子 | ✅ |
| 6 | `abstract-algebra.ring.euclidean` | Euclidean 环、带余除法与扩展 Euclidean 算法 | ✅ |
| 7 | `abstract-algebra.ring.pid-ufd` | PID、UFD、唯一分解及 Euclidean⇒PID⇒UFD | ✅ |
| 8 | `abstract-algebra.ring.crt` | 中国剩余定理、互素理想与有限直积 | ✅ |
| 9 | `abstract-algebra.ring.localization` | 分式域与局部化的构造及泛性质 | ✅ |

### A3 多项式与域扩张 ✅

| # | 条目 | 内容 | 状态 |
|---|---|---|---|
| 1 | `abstract-algebra.poly.def` | `Polynomial` 正式承载的有限支撑系数语义、次数、求值、根与旧表示双向桥 | ✅ |
| 2 | `abstract-algebra.poly.division` | 首一多项式带余除法、Euclidean 算法、gcd 与 Bézout | ✅ |
| 3 | `abstract-algebra.poly.irreducible` | 不可约判据、Gauss 引理、有理根判别、Eisenstein 判别 | ✅ |
| 4 | `abstract-algebra.poly.factorization` | 域上唯一分解、根的重数、导数与重根判据 | ✅ |
| 5 | `abstract-algebra.field.extension` | 显式域嵌入、生成中间域、单扩张、代数/超越元与最小多项式 | ✅ |
| 6 | `abstract-algebra.field.degree` | 扩张次数、塔式公式、有限扩张必代数 | ✅ |
| 7 | `abstract-algebra.field.splitting` | 分裂域、存在性、有限性与基域上同构唯一性 | ✅ |
| 8 | `abstract-algebra.field.separable-normal`、`abstract-algebra.field.separable-normal-characterizations` | 可分多项式、可分／正规扩张、根重数与不可约有根刻画 | ✅ |
| 9 | `abstract-algebra.field.galois-definitions`、`abstract-algebra.field.galois-correspondence` | Galois 扩张、显式基域自同构群、固定域与有限 Galois 基本对应 | ✅ |
| 9c | `abstract-algebra.field.galois-consequences`、`abstract-algebra.field.galois-normality`、`abstract-algebra.field.galois-restriction` | 固定域次数—子群指数；正规子群—正规/Galois 固定域；限制同态核像与商群同构 | ✅ |

**当前并行权限（2026-08-25）**：

| 窗口 | 权限 | 可执行范围 | 集成门 |
|---|---|---|---|
| A3.6 扩张次数 | 已集成 | 显式有限线性组合、线性无关、基、扩张次数和塔式公式 | Main 全库验收完成 |
| A3.7 分裂域基础 | 已集成 | 根集、分裂、根生成、存在性、有限性与基域上同构 | Main 全库验收完成 |
| A3.8 可分/正规扩张第一批 | 已集成 | 四个核心定义、导数判据、有限正规刻画与有限域扩张可分 | Main 全库验收完成 |
| A3.8 第二批刻画 | 已集成 | 根重数可分刻画、不可约多项式有一根则分裂的正规性刻画 | Main 全库验收完成 |
| A3.9a Galois 定义层 | 已集成 | Galois 扩张、显式自同构群、固定域及展开性质 | Main 全库验收完成 |
| A3.9b 基本定理 | 已集成 | 显式中间域—子群反变连接、restriction、群阶—相对次数链与双向恢复 | Main 全库验收完成；具体有限扩张计算归 Examples E6.12 |
| A3.9c Galois 对应推论 | 已集成 | 次数—指数公式、正规中间扩张—正规子群、限制同态核像与标准商群同构 | Main 全库验收完成；二次扩张、有限域和低次多项式计算归 Examples E6.12 |

A3.6 的课程主签名继续显式接受 `FieldEmbedding`，线性组合、线性无关、张成和基需要给出教材
定义；Mathlib `Algebra`、`Module`、`Basis` 可作已解释的私有证明后端。A3.7 不必等待 A3.6 审核
结束才开始开发，但不得在自己的正式接口中猜测尚未集成的次数 API。

---

## 5. Phase 4 — 点集拓扑及代数拓扑入口（T1-T4）

> 家族前缀 `topology.`。
>
> **教材框架**：T1–T3 以 Munkres, *Topology* 第二版为主教材，依次组织拓扑空间、连续性、
> 子空间／积／商、连通、紧致、分离公理和度量化／完备性。T4 的同伦、基本群及其计算改以
> Hatcher, *Algebraic Topology* 的第 0–1 章为主线；Munkres 只提供点集拓扑和基本群入口，不能
> 代替 Hatcher 的函子性、同伦不变性与计算路线。文献键为 `munkres-topology-2000`、
> `hatcher-algebraic-topology-2002`。

| 教材段落 | 本库批次 | 路线决定 |
|---|---|---|
| Munkres：拓扑空间、连续与构造 | T1 | 子空间、积与商在这里冻结正式承载 |
| Munkres：连通、紧致、分离公理 | T1 后半、T2 | 先连通，再紧致与分离；滤子刻画只是 Lean 对照 |
| Munkres：度量化与完备性 | T3 前四项 | 度量、一致性、Cauchy 与完备化形成一条线 |
| 泛函分析前置 | T3 后三项 | 赋范空间改标为跨学科桥，不算 Munkres 点集拓扑章节 |
| Hatcher Ch. 0 | T4-H/T4-E | 道路、同伦、同伦等价和基本几何构造 |
| Hatcher Ch. 1.1 | T4-F1/F2 | 基本群承载、运算、诱导映射、圆周计算 |
| Hatcher Chs. 1.2–1.3 | AT 后续 | van Kampen 与覆盖空间不挤入 T4 收尾，转入 §13.3 |

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
| `topology.foundation.structure` | Mathlib `TopologicalSpace`、开闭集、邻域、连续与同胚的教材刻画；旧载体冻结兼容 | ✅ A1 第一波已集成 |
| `topology.foundation.mathlib-compatibility` | 旧载体与 Mathlib 拓扑、空间构造、实线、单位区间及道路的双向迁移桥 | ✅ 随 A1 迁移扩展 |
| `topology.foundation.constructions` | 诱导、子空间与积拓扑的 explained Mathlib reuse，旧构造冻结兼容 | ✅ A1 第二波已集成 |
| `topology.foundation.real-line` | 标准实拓扑的 ε 邻域刻画与标准 `unitInterval` | ✅ A1 第三波已集成 |
| `topology.homotopy.path-definition-foundation` | Mathlib `Path` 的连续轨迹与端点语义，及旧/新道路桥 | ✅ A1 道路数据窗口已集成 |
| `topology.homotopy.path-reversal-foundation` | `Path.symm` 的单位区间反射语义、双重反向严格等式及旧操作桥 | ✅ A1 道路运算窗口已集成 |
| `topology.homotopy.path-concatenation-foundation` | `Path.trans` 的左右半区二倍速参数化及旧操作桥 | ✅ A1 道路运算窗口已集成 |

| # | 条目 | 内容 | mathlib |
|---|---|---|---|
| 1 | `topology.homeomorph.invariants` | 同胚的复合、逆及对连通性、紧致性等拓扑性质的保持 | `Homeomorph.trans`、`Homeomorph.toHomotopyEquiv` |
| 2 | `topology.homotopy.path-loop` | 道路、逆道路、环路、拼接、道路分支与道路连通基础 ✅ | `Path.Homotopic` |
| 3 | `topology.homotopy.maps` | 本库同伦与相对端点同伦定义、自反和对称 ✅；传递与复合待续 | `ContinuousMap.Homotopy`、`ContinuousMap.HomotopyRel` |
| 4 | `topology.homotopy.equivalence` | 同伦等价、同伦逆及同伦等价关系 | `ContinuousMap.HomotopyEquiv`、`Homeomorph.toHomotopyEquiv` |
| 5 | `topology.fundamental-group.def` | 基点环路按端点固定同伦取商，定义基本群 `π₁(X,x₀)` | `FundamentalGroupoid`、`FundamentalGroup`、`Path.Homotopic.Quotient` |
| 6 | `topology.fundamental-group.group` | 环路拼接诱导群结构，恒定环路、逆环路及结合律 | `FundamentalGroup.toPath`、`FundamentalGroup.fromPath` |
| 7 | `topology.fundamental-group.functoriality-standard` | 连续映射诱导基本群同态；同伦映射诱导自然同构 ✅ | `FundamentalGroupoidFunctor.map`、`FundamentalGroupoidFunctor.homotopicMapsNatIso` |
| 8 | `topology.fundamental-group.invariance-standard` | 基本群在同伦等价下不变，并处理基点变换 ✅ | `FundamentalGroupoidFunctor.equivOfHomotopyEquiv`、`ContinuousMap.HomotopyEquiv` |
| 9 | `topology.fundamental-group.triviality-standard`、`topology.fundamental-group.circle-standard` | 单连通／可缩空间平凡性的一般定理与圆周基本群分类定理 ✅；具体环路演算归 Examples E7.11 | `SimplyConnectedSpace`、指数覆盖与道路提升 |

**当前并行权限（2026-08-25）**：A1 已集成标准 `Path` 数据与逆向/拼接运算窗口；新课程不得
借兼容桥绕回 `TextbookTopology` 或旧 `Path`。后续不再整体冻结为单一串行批次：

| 窗口 | 权限 | 文件所有权建议 | 集成门 |
|---|---|---|---|
| T4-H1 标准道路同伦承载 | 已集成 | `PathHomotopyStandard.lean`；解释 `Path.Homotopy`、端点固定、refl/symm/trans | Main 全库验收完成 |
| T4-H2 一般/相对同伦 | 已集成 | `HomotopyStandard.lean`；解释 `ContinuousMap.Homotopy/HomotopyRel` 与复合 | Main 全库验收完成 |
| T4-E 同伦等价 | 已集成 | `HomotopyEquivalenceStandard.lean`；同伦逆、等价关系、同胚桥 | Main 全库验收完成 |
| T4-F1a 道路同伦商 | 已集成 | `PathHomotopyQuotientStandard.lean`；标准商、判等展开与代表存在 | Main 全库验收完成 |
| T4-F1b 基本群胚/基本群承载 | 已集成 | `FundamentalGroupCarrierStandard.lean`；只冻结 carrier 与转换，不发布群运算 | Main 全库验收完成 |
| T4-F2a 群运算与群律 | 已集成 | `FundamentalGroupOperationsStandard.lean`；解释单位、逆、乘法反序和商上群律 | Main 全库验收完成 |
| T4-F2b1 诱导映射函子律与同伦自然性 | 已集成 | 连续映射诱导、恒等／复合律、同伦自然同构及其自然性 | Main 全库验收完成 |
| T4-F2b2 基点变换与同伦等价不变性 | 已集成 | `mapOfEq`、沿道路换基点、同伦等价诱导基本群等价 | Main 全库验收完成 |
| T4-F2c1 单连通／可缩／凸集平凡性 | 已集成 | 基本群平凡性的一般判据；具体空间与环路类演算归 Examples E7.11 | Main 全库验收完成 |
| T4-F2c2 圆周基本群分类 | 已集成 | 指数覆盖、环路提升、绕数同态及 `π₁(S¹,1) ≃* Multiplicative ℤ` 的一般分类定理；具体绕数计算归 Examples E7.11 | Main 全库验收完成 |
| T4-F2c3 积空间基本群 | 已集成 | 从群胚积同构提取指定基点的基本群乘法等价及一般作用公式；具体空间积计算归 Examples E7.11 | `prodIso` 已有定义体内真实使用者及正逆复合公式 |
| AT1-VK1 van Kampen 覆盖细分 | 已集成 | 二开集覆盖下，用 Mathlib `Path.subpath` 封装有限带标签子段及相邻切换点交集性质 | 已冻结有限网格、标签、逐段包含和拼接同伦接口 |
| AT1-VK2 规范同态与满射 | 已集成 | 用 VK1 数据建立逐段基点修正环路词，并证明 `Monoid.PushoutI` 规范同态满射 | Main 全库验收完成；没有声称单射或同构 |
| AT1-VK3a 零同伦方格细分 | 已集成 | 一致二维网格、逐格覆盖标签及异标签整条公共边落在交集 | 目标空间只需拓扑结构；接口严格止于方格细分 |
| T4-I1 通用道路／网格设施归位 | 已集成 | `unitIntervalMeshPoint`、`pathCodRestrict` 与 `Path.correctedLoop`/有限 telescope 已分别移入三个中性模块 | 唯一声明、无 alias 或第二套实现；VK1/VK2/VK3a 消费链保持构建 |
| AT1-VK3b 单格边界词与内部边抵消 | 已集成（VK3b-01--15c） | 已完成逐边 transport、block 内外 cocycle、两层 telescope、residual gauge 消去、kernel triviality，并组装二开集 Seifert--van Kampen 群同构 | 完成的是道路连通开二覆盖且交集道路连通的版本；many-set、groupoid、非连通交集与自然性另列后续路线 |
| T4-R1 开域统一余量 | 无独立 Entry | 直接使用紧致同伦像在开域中的统一加厚余量 | `IsCompact.exists_cthickening_subset_open` 已精确承载；只作为 R2 证明步骤 |
| T4-R2 边界 collar 相对平滑化 | 已集成 | 全局连续延拓在四边闭集邻域已 `C²` 时，相对四边平滑并返回标准 `Path.Homotopy` | 已保留延拓、collar、开域像和双重 `IccExtend` 正则性前提；不推出 R3 |
| T4-R3a 开集内相对折线路径逼近 | 已集成 | `Path.Homotopy` 像集控制层；实赋范空间中把连续道路相对端点同伦到同一开集内的有限直线段拼接 | 完整同伦像和折线像均有开集内证书；不声称同伦光滑或线积分不变 |
| T4-R3b-path 有限分段 `C¹` 道路 | 已集成 | 以 Mathlib `Path` 上的归纳命题 `Path.PiecewiseC1` 承载整体 `C¹`、拼接和端点 cast；已证明常道路、线段、反向、有限 concat、`meshPolygonal` 及开集内替换 | 当前只刻画实际 `Path.trans` 生成的有限 concat tree，未声称与任意实断点定义等价；曲线可积性消费者归复分析独立批次 |
| T4-R3b-square 分片 `C¹` 道路同伦不变性 | 已集成（A--F） | shared square-grid、dyadic alignment、indexed subdivision、dyadic integral assembly、raw grid、outer-boundary cancellation 与最终连续相对同伦不变性全部验收 | 最终定理只要求边界道路 PiecewiseC1 和全像受控的标准连续 `Path.Homotopy`；没有恢复全局 relative-`C²` 签名，也没有调用旧最终定理包装 |
| AT2-C1 覆盖空间定义层 | 已集成 | 直接解释 Mathlib `IsEvenlyCovered` / `IsCoveringMap`，明确其允许空 fiber、教材满射约定须另加假设 | carrier、开乘积邻域、离散 fiber 与基础性质均已冻结 |
| AT2-C2 道路提升 | 已集成 | 直接复用 Mathlib 道路提升存在唯一性，并提供标准 `Path` 视图与终点 fiber | C1/C2 分文件；没有复制提升算法 |
| AT2-C3 同伦提升 | 已集成 | 复用 Mathlib 联合连续同伦提升，冻结参数空间、时间零提升及唯一性量词 | 提供 endpoint 与标准 `ContinuousMap.Homotopy` 薄视图；没有重写逐片算法 |
| AT2-C4 monodromy 与提升判据 | 已集成（C4a/C4b） | 标准提升终点与 monodromy、闭合提升与固定点、已有提升的必要像包含及完整存在唯一判据 | 真实消费 C2/C3；C4c simply-connected 薄别名不单独建 Entry，等待真实消费者 |
| AT2-C5a 半局部单连通定义层 | 已集成 | 以开邻域 inclusion 的基本群像为唯一主定义；全局性质为 Prop-valued class，loops 仅作 iff 展开 | 两个强假设桥是普通 theorem，未注册 instance；没有混同 semilocally contractible |
| AT2-C5b 道路类商承载 | 已集成 | dependent endpoint carrier、子群轨道 setoid、quotient 与 endpoint projection | 采用右陪集 `gH` 方向；没有偷带教材差环路 iff、拓扑或连续性 |
| AT2-C5c 覆盖 chart 与拓扑接口调查 | `research_open` | 只在 `/tmp` 调查小开邻域上的 canonical lift chart、拓扑承载、投影连续性与 `IsCoveringMap` 签名 | 不得直接给商注册未经验证的 quotient topology；提交设计 handoff 后再开放正式开发 |
| AT2-C5d--C5g 覆盖分类施工 | 冻结，C5c handoff 后分步开放 | 子群恢复、pointed/unpointed 分类与 universal cover | 不得一个大文件直冲最终分类；非连通 cover 不能误称对应单一子群 |

三个正式开发窗口必须使用互不重叠文件并各自形成独立提交。单位律、结合律和逆律若不是严格道路
等式，必须在标准道路同伦承载上陈述；不得从旧同伦施工复制结论来绕过新接口。

---

## 6. Phase 5 — 实分析（R1-R4；Folland RA-F1–RA-F6）

默认教材为 Gerald B. Folland, *Real Analysis: Modern Techniques and Their Applications*,
Second Edition。来源须精确到章／节或定理主题。R1-R4 与 Riemann 桥已进入 main；后续现代实分析
统一采用 RA-F 编号。多元微积分属于 §2 的 AN-MV，不再占用实分析编号。文献键为
`folland-real-analysis-1999`。

### R1-R4 与 Riemann–Lebesgue 桥已完成主线 ✅

测度、可测函数、Lebesgue 积分、三大收敛定理、乘积测度、Fubini/Tonelli、Lᵖ，以及本库
Riemann 定义、连续可积、Lebesgue 判据、FTC、分部积分和换元均已登记。

### Folland 后续路线 RA-F1–RA-F6 🚧

现有正测度、可测函数、Lebesgue 积分、收敛定理、乘积测度、Fubini--Tonelli 与 `Lᵖ` 主线，不能
代替测度微分所需的有符号／复测度与 Radon--Nikodym 前置。批次顺序和出口如下：

| 批次 | 教材内容 | 开工门 | 完成出口 |
|---|---|---|---|
| RA-F1 | 有符号测度、Jordan 分解、正负／全变差、复测度 | 正测度与积分主线已验收 | 四类概念均有正式承载、教材解释、展开性质和必要桥 |
| RA-F2 | 绝对连续、互奇异、Lebesgue 分解与 Radon--Nikodym | RA-F1 | RN 存在唯一性、由密度构造测度、积分换测度及链式／互逆边界 |
| RA-F3 | Hardy--Littlewood 极大函数与弱型估计 | RA-F2；覆盖引理接口冻结 | 极大函数教材定义、弱型估计和可测性边界 |
| RA-F4 | Lebesgue 点与 Lebesgue 微分定理 | RA-F3 | 平均算子、Lebesgue 点定义、a.e. 定理和具名桥 |
| RA-F5 | 单调函数、有界变差与绝对连续函数 | RA-F2；一维测度接口验收 | BV/AC 定义、分解性质与 a.e. 导数 |
| RA-F6 | FTC 的 a.e. 版本与 Newton--Leibniz 表示 | RA-F4、RA-F5 | 积分表示双向定理及与既有 Riemann/FTC 接口的总桥 |

Mathlib 的 `SignedMeasure`、`ComplexMeasure`、`Measure.AbsolutelyContinuous`、`rnDeriv` 等接口
语义一致时应直接复用，但必须解释教材定义、量词、假设、展开性质和真实下游；语义不一致时才自建
谓词或结构及具名桥。RA-F3/RA-F4 不得只包装 `ae_lebesguePoint` 或最终微分强定理：应保留覆盖／
弱型估计、简单函数或 `L¹` 逼近、坏集测度控制以及通向 a.e. 结论的证明骨架；做不到时诚实登记为
foundation/bridge，不能宣称整条 Folland 定理已经完成。

本路线交付证据须明确：正／有符号／复测度类型、标量、有限性或 σ-有限性、`a.e.` 所依赖的测度、
积分类型（`lintegral`／Bochner／区间积分）以及等式是处处、a.e. 还是测度相等。自然语言不得把
a.e. 结论写成逐点结论。

## 7. Phase 6 — 复分析（C0-C3）

> **教材框架**：C0–C3 以 Ahlfors, *Complex Analysis* 第三版为主教材。复数与初等函数、解析性
> 和幂级数对应 C0–C1；路径积分、Cauchy 理论和同伦边界对应 C2；Laurent 展开、孤立奇点、残数
> 与辐角原理对应 C3。ROADMAP 中新增 foundation 条目只是在 Lean 依赖尚未闭合时保留教材链，
> 不改变 Ahlfors 主线，也不得把 foundation 状态写成对应章节已经完成。文献键为
> `ahlfors-complex-analysis-1979`。

| Ahlfors 教材主题 | 本库批次 | 依赖门 |
|---|---|---|
| 复数、初等函数、解析函数 | C0–C1 | 实微分与幂级数前置 |
| 复积分与 Cauchy 理论 | C2 | 路径积分后按 Goursat → Cauchy 公式 → 高阶导数与估计推进 |
| 同伦形式与单连通域原函数 | C2 收口 | 必须等待 T4 连续同伦桥，不以现成强 API 越过 |
| Laurent、奇点、残数、辐角原理 | C3 | 完整 C2；先展开与分类，再残数和应用 |

实积分计算例归 Examples；它是残数定理的使用者，不作为 C3 理论完成门。已有 foundation 条目按
上述顺序吸收，不再平行生长一条“Mathlib 可用什么就做什么”的路线。

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
| 3 | `complex-analysis.cauchy.triangle` | 任意开集内的局部三角形 Cauchy--Goursat 定理 ✅ | 凸三角形上的相对原函数接口 |
| 4 | `complex-analysis.cauchy.homotopy` | 同伦不变与单连通域版本 | winding/homotopy |
| 5 | `complex-analysis.cauchy.formula` | Cauchy 积分公式 ✅ | circle integral API |
| 6 | `complex-analysis.cauchy.derivatives` | 高阶导数公式与 Cauchy 估计 ✅ | iterated derivative |
| 7 | `complex-analysis.liouville` | Liouville 与 FTA 的分析证明 ✅ | Cauchy estimate |
| 8 | `complex-analysis.cauchy.triangle-ball` | 圆盘内三角形边界积分为零 ✅（foundation） | 原函数桥 |
| 9 | `complex-analysis.cauchy.path-independence-primitive` | 已有原函数时路径无关 ✅（foundation） | 原函数端点公式 |
| 10 | `complex-analysis.cauchy.smooth-homotopy-foundation` | 给定 C² 相对端点同伦时路径积分不变 ✅（foundation） | `ContinuousMap.Homotopy`、`ContDiffOn` |
| 11 | `complex-analysis.cauchy.primitive-from-path-independence-foundation` | 由 admissible 道路积分无关构造原函数 ✅（foundation） | `HasDerivAt`、短线段积分 |
| 12 | `complex-analysis.cauchy.admissible-path-connectivity-foundation` | 开连通域内从基点到各点存在有限分段正则道路 ✅（foundation） | `IsPreconnected`、`Path.trans` |

### C3 Laurent、残数与亚纯函数 ⏸（依赖完整 C2）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `complex-analysis.series.taylor` | Taylor 展开与唯一性 ✅ | analytic/power series |
| 2 | `complex-analysis.series.laurent` | 环域 Laurent 展开 | `LaurentSeries` |
| 3 | `complex-analysis.singularity.classification` | 可去、极点、本性奇点 | `MeromorphicAt` |
| 4 | `complex-analysis.residue.definition` | 残数与 Laurent 系数 | `residue` |
| 5 | `complex-analysis.residue.theorem` | 残数定理 | winding/cycle integral |
| 6 | `complex-analysis.argument-principle` | 辐角原理与 Rouché | logarithmic derivative |
| 7 | `complex-analysis.residue.contour-estimates` | 供残数应用调用的一般轮廓估计接口；具体实积分归 Examples E9.5 | contour estimates |
| 8 | `complex-analysis.series.laurent-foundation` | Laurent 解析定义与单项级数接口 ✅ | 双向整数指标 `HasSum` |
| 9 | `complex-analysis.singularity.classification-foundation` | 孤立奇点教材谓词与亚纯阶桥 ✅ | `MeromorphicAt` |
| 10 | `complex-analysis.residue.circle-foundation` | 指定圆周的正规化积分 ✅ | circle integral |
| 11 | `complex-analysis.residue.simple-pole` | 简单极点圆周公式 ✅ | Cauchy 公式 |
| 12 | `complex-analysis.residue.real-integral-example` | 历史已验证广义实积分接口 ✅；后续扩例与维护归 Examples E9.5 | Mathlib 广义积分后端 |
| 13 | `complex-analysis.argument-principle.linear-special-case` | 线性辐角/Rouché 特例 ✅ | logarithmic derivative |

## 8. Phase 7 — 泛函分析（F1-F8，Bühler–Salamon 主线）

> 默认教材固定为 Theo Bühler 与 Dietmar A. Salamon, *Functional Analysis*, AMS GSM 191
>（2018；ETH 讲义更新版可作勘误参考）。课程顺序对应第 1–7 章：基础、三大原理与凸分离、
> 弱／弱星拓扑、Fredholm 理论、有界谱理论、无界算子、算子半群。现有条目保留，不为贴合章节
> 编号重造等价接口；新增批次负责补齐教材缺口并冻结真实依赖门。文献键为
> `buehler-salamon-functional-analysis-2018`。

### F1 赋范空间与连续线性算子 ✅

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `topology.normed-space.def` | 赋范空间与 Banach 空间 ✅（复用已验收拓扑条目） | `NormedSpace`、`CompleteSpace` |
| 2 | `functional-analysis.operator.continuous-linear-map` | 连续线性映射与算子范数 ✅ | `ContinuousLinearMap` |
| 3 | `functional-analysis.operator.bounded-iff` | 连续与全局有界等价 ✅ | `LinearMap.mkContinuous` |
| 4 | `functional-analysis.operator.space` | 算子空间的赋范与完备性 ✅ | CLM complete instance |
| 5 | `functional-analysis.series.summable` | Banach 中绝对可和推出可和 ✅ | `Summable.of_norm` |
| 6 | `functional-analysis.subspace.quotient` | 闭子空间与商 Banach 空间 ✅ | `NormedSpace.Quotient` |

### F2 泛函分析基本原理与凸性 ✅（Salamon Chapter 2；已完成）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `functional-analysis.baire.theorem` | Baire 范畴定理 ✅ | dense open intersection |
| 2 | `functional-analysis.banach-steinhaus` | 一致有界原理 ✅ | `banach_steinhaus` |
| 3 | `functional-analysis.open-mapping` | 开映射定理 ✅ | continuous linear surjection |
| 4 | `functional-analysis.closed-graph` | 闭图定理 ✅ | closed graph |
| 5 | `functional-analysis.inverse-operator` | 有界逆定理 ✅ | open mapping 推论 |
| 6 | `functional-analysis.hahn-banach.extension` | Hahn–Banach 延拓定理、支配次线性泛函版本与范数保持延拓 ✅ | `exists_extension_norm_eq`、`Sublinear` |
| 7 | `functional-analysis.hahn-banach.norming-functional` | 给定非零向量的范数化泛函与对偶范数刻画 ✅ | `exists_dual_vector`、dual norm API |
| 8 | `functional-analysis.convex.separation` | 开／闭凸集的几何分离与 Minkowski 泛函证明链 ✅ | geometric Hahn–Banach、`Convex` |
| 9 | `functional-analysis.subspace.annihilator-closure` | 子空间闭包、连续零化子与双零化子刻画 ✅ | `StrongDual.polarSubmodule`、dual pairing |
| 10 | `functional-analysis.bidual.reflexive` | 连续双对偶典范等距嵌入、自反性的满射刻画与弱紧性边界 ✅ | `NormedSpace.inclusionInDoubleDual`、`inclusionInDoubleDualLi` |
| 11 | `functional-analysis.separable.dual` | 可分空间、可分对偶的基本蕴含与不可逆边界 ✅ | separability/reflexivity API |
| 12 | `functional-analysis.bidual.reflexive-examples` | 两类一般自反性定理：有限维实赋范空间与完备实内积空间 ✅；历史 id 保留，具体实例归 Examples E11.6 | finite dimension、Riesz equivalence |

### F3 Hilbert 空间 ✅（F1、L5 均已完成）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `functional-analysis.hilbert.projection` | 闭凸集/闭子空间投影 ✅ | `orthogonalProjection` |
| 2 | `functional-analysis.hilbert.riesz` | Riesz 表示定理 ✅ | `InnerProductSpace.toDual` |
| 3 | `functional-analysis.hilbert.adjoint` | 有界算子伴随 ✅ | `ContinuousLinearMap.adjoint` |
| 4 | `functional-analysis.hilbert.orthonormal-basis` | Hilbert 基、Fourier 重构与 Parseval ✅ | `HilbertBasis` |
| 5 | `functional-analysis.hilbert.unitary` | 等距、酉算子及正交分解的基本接口 ✅ | `LinearIsometryEquiv`、unitary API |

> 紧自伴算子谱定理属于 Salamon Chapter 5，移至 F6；F3 只建立后续谱理论真正需要的 Hilbert
> 空间语言，不提前声称已完成紧算子理论。

本课程复用 Mathlib 时须按对象层级分别解释 `ContinuousLinearMap`、弱／弱星拓扑、紧／Fredholm
算子、谱、投影值测度、稠密定义域算子和 `C₀` 半群的数据、量词与 topology/typeclass 假设，尤其
不得混称 Banach 对偶与 Hilbert 伴随、有界与无界算子、自伴与对称、强与弱收敛。若只能调用最终
强定理而不能交付章节的定义、关键展开和真实下游，应标为 foundation/bridge。handoff 还须明确
标量域、完备性、可分／自反条件、算子类别、拓扑和收敛方式。

### F4 弱拓扑、弱星拓扑与弱紧性 🚧（Salamon Chapter 3；依赖 F2/T1/T2）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `functional-analysis.topological-vector-space.foundation` | 拓扑向量空间、联合连续运算与平移自同胚 ✅ | `IsTopologicalAddGroup`、`ContinuousSMul` |
| 2 | `functional-analysis.weak-topology.definition` | 弱拓扑、弱收敛及由对偶泛函刻画 ✅ | `WeakSpace`、initial topology API |
| 3 | `functional-analysis.weak-star.definition` | 对偶空间的弱星拓扑、弱星收敛与弱／弱星辨析 ✅ | `WeakDual` |
| 4 | `functional-analysis.banach-alaoglu` | 对偶闭单位球的弱星紧致性 ✅ | `WeakDual.isCompact_closedBall` |
| 5 | `functional-analysis.weak.metrizable-separable` | 可分情形弱星紧集可度量化、闭球序列紧与收敛子列抽取 ✅ | `WeakDual.metrizable_of_isCompact`、序列紧接口 |
| 6 | `functional-analysis.weak-star.banach-dieudonne` | Banach–Dieudonné 定理及弱星闭性判据 ✅ | `WeakDual`、Banach–Alaoglu、`ZeroAtInfty`、Hahn–Banach |
| 7 | `functional-analysis.eberlein-smulian` | 自反性、闭单位球弱紧、弱序列紧与有界序列弱收敛子列四项等价 ✅ | `WeakSpace`、`IsCompact`、`IsSeqCompact` |
| 8 | `functional-analysis.krein-milman` | 紧凸集、face、极点与闭凸包的教材解释 ✅ | 已集成：复用 `IsExtreme`、`extremePoints` 与 Krein–Milman API，并明确 Mathlib 极性谓词与教材完整 face 的差异 |
| 9 | `functional-analysis.ergodic.mean` | power-bounded Banach 算子的均值遍历分解、弱子列判据、自反情形与极限投影 ✅ | decomposition、reflexive convergence、`ST=TS=S²=S` 均已集成 |

### F5 对偶算子、紧算子与 Fredholm 理论 🔒（Salamon Chapter 4；依赖 F2/F4）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `functional-analysis.dual-operator.definition` | Banach 空间对偶算子、范数、复合与核／像零化子 ✅ | `ContinuousLinearMap.precomp` |
| 2 | `functional-analysis.closed-range` | 闭值域、对偶值域闭、核零化子及共同零点恢复的四项等价 ✅ | `ContinuousLinearMap.exists_preimage_norm_le`、Banach–Dieudonné、弱星分离 |
| 2b | `functional-analysis.closed-range.double-annihilator` | 值域闭包的双零化子刻画；闭值域推出对偶值域范数闭与弱星闭 ✅ | `Submodule.topologicalClosure`、`WeakDual.eval_continuous` |
| 3 | `functional-analysis.compact-operator.definition` | 紧算子的单位球像刻画、有限维域上的一般紧性定理与恒等算子判据 ✅；具体算子计算归 Examples E11.7 | compact operator API |
| 4 | `functional-analysis.compact-operator.composition` | 紧算子理想性质、复合稳定性与范数极限闭性 ✅ | compact composition API |
| 5 | `functional-analysis.fredholm.definition` | Fredholm 算子、核与余核有限维、指数 ✅ | `ContinuousLinearMap.IsFredholm`、`LinearMap.index` |
| 6 | `functional-analysis.fredholm.alternative` | 恒等减紧算子的 Fredholm 备择；对偶紧致、有限维核余核、闭值域、指数零及单射／满射等价 ✅ | 完整证明链已集成；没有调用 Mathlib 最终 package 代替教材证明 |
| 6b | `functional-analysis.fredholm.cokernel` | `I-K` 的余核有限维 ✅ | 闭值域零化子、Schauder 对偶紧性 |
| 6c | `functional-analysis.fredholm.index-zero` | `index(I-K)=0` ✅ | 幂链稳定、Fitting 分解、`LinearMap.index_comp` |
| 6d | `functional-analysis.fredholm.alternative-final` | 由有限维核余核和指数零推出 `I-K` 单射当且仅当满射 ✅ | `index_of_injective`、`index_of_surjective` |
| 7 | `functional-analysis.fredholm.stability` | 复合稳定性与指数可加性 ✅；紧扰动和小扰动稳定性分后续窗口 | Fredholm stability API |

### F6 Banach 代数与有界算子谱理论 🔒（Salamon Chapter 5；依赖 F3/F5/C1）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `functional-analysis.banach-algebra.foundation` | 复 Banach 代数、单位化与几何级数求逆 ✅ | `NormedRing`、`NormedAlgebra`、`Unitization` |
| 2 | `functional-analysis.spectrum.definition` | 谱、预解集、预解算子与谱半径 ✅ | `spectrum`、`resolventSet`、`spectralRadius` |
| 3 | `functional-analysis.spectrum.nonempty-compact` | 复 Banach 代数中谱非空紧致及谱半径公式 ✅ | spectrum API、Liouville |
| 4 | `functional-analysis.compact-spectrum` | 紧算子的非零谱、特征值有限重数与零点聚集边界 | compact operator spectrum |
| 5 | `functional-analysis.hilbert.compact-selfadjoint-spectral` | 紧自伴算子的正交特征分解 | compact self-adjoint spectral theorem |
| 6 | `functional-analysis.functional-calculus.holomorphic` | Dunford 积分与全纯函数演算、谱映射定理 | holomorphic functional calculus |
| 7 | `functional-analysis.operator.selfadjoint-positive-normal` | 有界自伴、正、酉与正规算子的关系 | star/positive/normal operator API |
| 8 | `functional-analysis.functional-calculus.continuous` | 自伴／正规算子的连续函数演算 | continuous functional calculus |
| 9 | `functional-analysis.spectral-measure.bounded` | 投影值测度、循环向量与有界正规算子谱定理 | spectral measure/integral API |
| 10 | `functional-analysis.gelfand-spectrum.entry` | 交换 Banach 代数极大理想空间与 Gelfand 变换入口 | character/Gelfand spectrum API |

### F7 无界算子与无界谱定理 🔒（Salamon Chapter 6；依赖 F4-F6/R4）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `functional-analysis.unbounded-operator.definition` | 稠密定义域线性算子、图、闭算子与可闭算子 | submodule domain/closed graph API |
| 2 | `functional-analysis.unbounded-operator.graph-norm` | 图范数、闭性与定义域完备性的等价 | graph norm/completion API |
| 3 | `functional-analysis.unbounded-operator.dual` | Banach 空间无界算子的对偶、稠密定义域与闭值域关系 | unbounded dual operator API |
| 4 | `functional-analysis.unbounded-operator.adjoint` | Hilbert 空间稠密定义算子的伴随、对称与自伴 | unbounded adjoint API |
| 5 | `functional-analysis.unbounded-operator.resolvent` | 无界闭算子的预解集、谱与 Cayley 变换入口 | resolvent/Cayley API |
| 6 | `functional-analysis.spectral-measure.unbounded` | 无界自伴算子的谱测度与可测函数演算 | projection-valued measure API |
| 7 | `functional-analysis.unbounded-selfadjoint.spectral` | 无界自伴算子谱定理与定义域刻画 | unbounded spectral theorem |

### F8 强连续半群与抽象演化方程 🔒（Salamon Chapter 7；依赖 F7/R4）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `functional-analysis.semigroup.strongly-continuous` | `C₀` 半群、轨道连续性与指数增长界 | operator semigroup API |
| 2 | `functional-analysis.semigroup.generator` | 无穷小生成元、稠密定义域、闭性与预解公式 | infinitesimal generator API |
| 3 | `functional-analysis.semigroup.hille-yosida-phillips` | Hille–Yosida–Phillips 生成定理 | resolvent power estimates |
| 4 | `functional-analysis.semigroup.dual` | 对偶半群、强连续性边界与自反空间情形 | dual semigroup API |
| 5 | `functional-analysis.semigroup.selfadjoint-unitary` | 自伴半群、酉群与 Stone 定理入口 | unitary group/generator API |
| 6 | `functional-analysis.semigroup.analytic` | 解析半群、扇形生成元与正则化 | analytic semigroup API |
| 7 | `functional-analysis.bochner-measurable` | Banach 值强可测函数、Bochner 积分与基本收敛定理 | `StronglyMeasurable`、Bochner integral |
| 8 | `functional-analysis.evolution.inhomogeneous` | 非齐次抽象 Cauchy 问题、变常公式、温和解与经典解 | semigroup integral/Duhamel |

**F4/F5 当前并行权限（2026-08-26）**：F4.1--F4.5、F4.7 Eberlein--Šmulian 与 F4.8
Krein--Milman 已集成；F4.8 直接复用 Mathlib 最终定理，但已补齐 face／极点／闭凸包的教材定义链
解释与必要组装使用者。F4.9 的
`mean-ergodic.decomposition` 已集成：冻结 `birkhoffAverage`、幂一致有界量词、收敛域、fixed space 与
`closure(range(T-1))`，完成直和分解和“弱收敛子列 iff 范数收敛”。两个消费者也已集成：
`mean-ergodic.reflexive` 证明自反空间处处收敛，`mean-ergodic.projection` 构造极限投影并证明
`ST = TS = S² = S`；两批均真实复用了 decomposition 的公开接口。F4.6 与编号
较后的弱紧致工具仍可先做接口调查。F5.3--F5.4
紧算子定义、单位球像刻画、有限维域上的一般紧性定理、复合与范数极限闭性已经集成；具体有限秩
或对角算子实例归 Examples E11.7。F5.2 第一批零化子刻画
已集成；对偶值域范数闭的逆向与原／对偶四项闭值域等价已经完成。F5.5 Fredholm 定义层也已集成。
F5.6 Fredholm 备择的完整证明链已经集成：紧算子的对偶仍紧，`I-K` 的核与余核有限维、值域闭、
`index (I-K)=0`，并由这些中间接口推出单射当且仅当满射。F5.7 的复合稳定性与指数可加性已经
集成；紧扰动窗口为 `development_open`，小扰动窗口为 `research_open`，并在紧扰动 handoff 后自动转
`development_open`。两个窗口必须使用独立文件并真实消费已冻结的指数、复合与紧扰动接口，不得直接
包装最终稳定性定理。
F6.1 Banach 代数 foundation、F6.2 谱／预解集定义层与 F6.3 谱非空、紧致及谱半径公式已经集成。
F6.4 紧算子谱现为 `development_open`；F6.5 紧自伴谱定理维持 `research_open`，待 F6.4 handoff 后
再由 Main 审核是否转为正式开发。
F6.5--F6.10 仍按教材依赖门推进；
具体有限秩积分核归 Examples E11。F6.3 以后等待紧算子消费者与
复分析 C1，F7/F8 严格顺序
解锁。若 Mathlib 尚无成熟的无界算子、Fredholm 或半群承载，只能先登记 foundation/bridge，不能
用若干已有强定理包装成整章“完成”。

## 9. Phase 8 — 概率论（Pr1-Pr3）

> 主教材为 Kallenberg, *Foundations of Modern Probability* 第三版
>（`kallenberg-modern-probability-2021`）：测度概率、分布与独立性对应 Pr1，条件化、过滤与鞅
> 对应 Pr2，收敛方式与经典极限定理对应 Pr3。Markov 过程、Brownian 运动、随机积分和 SDE 按书
> 后半转入 SP，不在 Pr3 提前展开。

### Pr1 概率空间、随机变量与期望 ✅

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `probability.space.definition` | 概率空间与事件 ✅ | `IsProbabilityMeasure` |
| 2 | `probability.variable.definition` | 随机变量与可测性 ✅ | `Measurable` |
| 3 | `probability.distribution.pushforward` | 分布作为推前测度 ✅ | `Measure.map` |
| 4 | `probability.expectation.definition` | 期望、可积性与线性 ✅ | `integral` |
| 5 | `probability.moments.variance` | 方差与协方差 ✅ | variance/covariance |
| 6 | `probability.independence.events` | 事件与 σ-代数独立 ✅ | `IndepSet`、`Indep` |
| 7 | `probability.independence.variables` | 随机变量独立与分布乘积 ✅ | `IndepFun` |
| 8 | `probability.inequalities.basic` | Markov、Chebyshev、Jensen ✅ | probability inequalities |

### Pr2 条件期望与鞅 🚧（依赖 Pr1）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `probability.conditional-expectation.definition` | 条件期望定义与存在 ✅ | `condExp` |
| 2 | `probability.conditional-expectation.tower` | 塔式性质 ✅ | `condExp_condExp` |
| 3 | `probability.conditional-expectation.independence` | 独立时条件期望退化 ✅ | condExp independence |
| 4 | `probability.filtration.definition` | 过滤与适应过程 ✅ | `Filtration`、`Adapted` |
| 5 | `probability.martingale.definition` | 鞅、下鞅、上鞅 ✅ | `Martingale` |
| 6 | `probability.martingale.optional-stopping-entry` | 有界停时可选停止 ✅ | stopping time |

**Pr2 当前权限**：条件期望 definition、tower、independence、filtration 与 martingale 定义层已集成；
定义层直接复用 `MeasureTheory.Martingale`／`Submartingale`／`Supermartingale`，并已解释条件期望、
过滤和可积性量词；有界停时可选停止也已集成，严格止于 `ℕ` 指标、实值与确定常数一致有界版本。Pr3
`probability.convergence.modes` 已集成，完成四种教材展开、经典单向蕴含、a.s. 子列与连续映射
消费者。弱大数律现为 `research_open`，只调查 iid／独立同分布 carrier、样本均值、方差假设与
Chebyshev 证明链；强大数律、特征函数和 CLT 继续冻结。

统计 S1 的模型／密度审计已完成：正式模型采用 `Kernel Θ 𝓧` 与 `IsMarkovKernel`，联合可测 likelihood
采用 `Kernel.rnDeriv` 而非逐参数 `Measure.rnDeriv`。`statistics.model.definition` 已集成；支配
模型与联合可测 density 已集成。`statistics.estimator.definition` 现为 `research_open`：先审计
估计量的可测映射 carrier、损失函数、逐参数风险与 Mathlib `avgRisk`／`bayesRisk` 接口，提交签名
handoff 后再决定正式开发。一般估计定理继续冻结，不得用有限离散样本冒充一般统计实验。

### Pr3 极限定理 🔒（依赖 Pr1/Pr2）

| # | 条目 id | 内容 | 主要 Mathlib 接口 |
|---|---|---|---|
| 1 | `probability.convergence.modes` | a.s./概率/Lp/分布收敛 ✅ | convergence APIs |
| 2 | `probability.law-large-numbers.weak` | 弱大数律（`research_open`） | iid variance bounds |
| 3 | `probability.law-large-numbers.strong` | 强大数律 | SLLN |
| 4 | `probability.characteristic-function` | 特征函数与分布唯一性 | charFun |
| 5 | `probability.central-limit-theorem` | iid 中心极限定理 | CLT |

## 10. Phase 9 — 统计推断（S1-S2）

> 主教材为 Schervish, *Theory of Statistics*（`schervish-theory-statistics-1995`），按统计模型、
> 充分性、决策与风险、估计、检验组织 S1–S2；线性回归采用 Seber–Lee,
> *Linear Regression Analysis* 第二版（`seber-lee-linear-regression-2003`）。似然和密度必须
> 等待 RN 接口，不能用有限样本公式冒充一般统计实验已经定义。

### S1 参数估计 🔒（依赖 Pr1）

| # | 条目 id | 内容 | 主要实现接口 |
|---|---|---|---|
| 1 | `statistics.model.definition` | 统计模型、样本与参数族 ✅ | 测度族/概率核 |
| 1b | `statistics.model.density` | 支配模型与联合可测 Radon--Nikodym 密度 ✅ | `Kernel.rnDeriv` |
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

> **教材框架**：N1 与 N1+ 以 Hardy–Wright, *An Introduction to the Theory of Numbers* 第六版
> 为主教材，覆盖整除、同余、素数、算术函数、连分数与 Pell 方程；Ireland–Rosen,
> *A Classical Introduction to Modern Number Theory* 第二版作为现代数论桥，负责 N2 的代数
> 数论入口以及 N3 的特征、二次互反、算术函数和解析方法入口。两书都不单独覆盖 ROADMAP 中
> 完整的局部域、类域式纵深或素数定理证明链；这些后续批次在开工前仍须由 Main 补指定专题教材，
> 不得把现有书目挂名为整条 N2/N3 已有出处。文献键为 `hardy-wright-number-theory-2008`、
> `ireland-rosen-number-theory-1990`。

| 教材覆盖 | 本库批次 | 开发权限 |
|---|---|---|
| Hardy–Wright：整除、同余、素数、算术函数 | N1 | 已完成主干；按教材缺口做维护，不横向扩题 |
| Hardy–Wright：连分数与 Pell | N1+ | 最佳逼近 → 二次无理数周期性 → Pell 桥 → 解分类 |
| Ireland–Rosen：代数数论入口 | N2.1–N2.12 | 数域、整数环、理想分解、类群、Minkowski、单位依次推进 |
| Ireland–Rosen：特征、算术函数与解析入口 | N3.1–N3.6、N3.10 | 可先研究；Dirichlet 级数前先完成卷积、反演和部分求和 |
| 局部域及完整解析数论 | N2.13–N2.15、N3.7–N3.12 | `research_open`；补指定专题教材前不得正式开发 |

据此，原来笼统的 N2/N3 冻结拆为“教材覆盖段可研究、超出覆盖段继续冻结”。尤其不能从 Mathlib
已有 `Padic`、`riemannZeta` 或 `LFunction` 直接倒推一门局部域／解析数论课程。

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

### N2 代数数论 🚧（G-A2/G-A3 已满足；N2.1–N2.3 `development_open`，N2.4–N2.15 `research_open`）

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

### N3 解析数论 🔒（教材入口段 `research_open`；正式开发仍依赖 G-C）

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

> **教材框架**：ST1–ST2 以 Jech, *Set Theory* 第三千禧版为集合论主教材，负责序数、基数、选择、
> 共尾性以及独立性语言的标准框架。ST3 的 Goodstein、Hydra、大数与可计算性不是 Jech 课程的
> 单一章节：数的表示和大数例证可参考 Conway–Guy，经典递归论以 Odifreddi 为主教材，Goodstein、
> Kirby–Paris、Wainer、Rado 与 Knuth 的已发表论文只作为相应定理的原始 provenance。原始论文
> 不能代替教材定义层。文献键为 `jech-set-theory-2003`、`conway-guy-book-of-numbers-1996`、
> `odifreddi-classical-recursion-1989` 及各专题论文键。

| 来源 | 本库路线 | 调整后的边界 |
|---|---|---|
| Jech：Axioms、Ordinals、Cardinals | ST1–ST2 基础 | 序数先于基数；基数算术之后才进入共尾性与正则性 |
| Jech：Choice、Models、Constructible Sets、Forcing | ST2 后续与 ML6 | AC/良序/Zorn 等价先于独立性；forcing 移交数理逻辑模型线 |
| Odifreddi：经典递归论 | ST3 可计算性段与 ML4 | 先机器/部分函数承载，再可枚举、停机与不可计算性 |
| Goodstein/Kirby–Paris/Wainer/Rado/Knuth | ST3 专题段 | 只支撑各自定理链，不作为集合论总教材 |

因此 ST3 改视为“集合论基础之后的递归、增长与独立性专题群”，不再用 ST1–ST2 的完成度为其
全部内容背书。Goodstein 路线固定为遗传表示 → 序数赋值 → 单步下降 → 终止 → PA 边界；Hydra
和 Busy Beaver 分别保持独立依赖链，不再与 Goodstein 共享一个模糊的“增长函数前置”。

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

### ST3 递归、增长、Goodstein、Hydra 与可计算性：基础 61 项 ✅，纵深 🚧

当前进入 main 的 61 项包括：递归定义、大数记号与序数幂桥 8 项，Conway/TREE 与带燃料增长层级
10 项，Goodstein 状态、自然数遗传编码、幂秩、局部借位和序数下降 16 项，Hydra 步骤、局部下降、
赋值、认证轨迹、策略终止与良基归纳 12 项，Busy Beaver 有限候选、经典输出/时间最大值与收敛
8 项，以及机器编码、代码级有界停机检查、可计算性、部分可计算性和条件式对角接口 7 项。逐项权威状态见 Registry；
以下表格保留下一阶段真正尚缺的课程门。

| # | 待开发条目 | 需要补齐的内容 | 状态 |
|---|---|---|---|
| 1 | `settheory.googology.primitive-recursive-class` | 冻结原始递归函数类并证明闭包 | 🚧 |
| 2 | `settheory.googology.ackermann-domination` | 支配全部原始递归函数及非原始递归性 | 🔒 |
| 3 | `settheory.googology.hereditary-encoding-order` | 已有全局严格保序、底数幂精确秩、`B^(B^k)` 参数族借位与规范状态；继续证明一般换底重编码保持 `omegaValue` | 🚧 |
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

> 本节不是一个名为“前沿”的杂项批次。以下十七门都是独立学科，每门的体量、负责人、worktree、
> family 前缀、handoff 和完成状态均独立；一门完成不代表其他门完成。表中一行是一个可验收
> Entry，不是用一个标题包装整章理论。正式开工时，学科负责人应按依赖把每个课程批次拆成
> 3–6 条的文件包交给子 Agent，并由负责人组装验收。
>
> **CA–HA–AG 统一施工参考：The Stacks Project。** 它以稳定 Tag 提供从范畴／同调语言、交换
> 代数到概形、层、上同调、下降、étale、代数栈和形变理论的细粒度依赖网。正式课程顺序和
> provenance 仍由已出版教材决定；Stacks Tag 用于核对定义、拆分引理和记录跨章依赖。它是持续
> 维护的网站，故不进入 `reference.bib`，Registry 的 `provenance.ref` 也不得填写 Stacks URL。
> 每个 CA/HA/AG handoff 可另列“Stacks tags consulted”，但不得以某个最终 Tag 代替教材证明链。

### 13.1 交换代数（CA1–CA6）🔒

> 家族前缀 `commutative-algebra.*`。课程门：A2 的理想、商环、整除、局部化完成；CA5 另需 A3。
> 主教材为 Atiyah–Macdonald, *Introduction to Commutative Algebra*
>（`atiyah-macdonald-commutative-algebra-1969`），Eisenbud
>（`eisenbud-commutative-algebra-1995`）补自由分解、关联素理想、深度与几何应用。Stacks Project
> 的 Algebra、Commutative Algebra 与 More on Algebra chapters 负责 Tag 级定义核对，不改变
> “模／张量 → 局部化 → Noether → 整扩张 → 维数与局部环”的教材顺序。

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
> 主教材为 Weibel, *An Introduction to Homological Algebra*（`weibel-homological-algebra-1994`）：
> 范畴语言和链复形 → 正合列 → 分解与导出函子 → Ext/Tor → 谱序列。Stacks Project 的
> Categories、Homological Algebra 与 Derived Categories chapters 只提供稳定 Tag 索引；不得从
> 导出范畴 Tag 反向跳过链复形、连接同态和分解无关性。

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
> 主教材为 Fulton–Harris, *Representation Theory: A First Course*
>（`fulton-harris-representation-theory-1991`）。有限群表示、Schur/Maschke、特征标和对称群
> 对应 RT1–RT4；Lie 代数、`sl₂`、根系、最高权与 Weyl 特征标对应 RT5–RT6。两条线共享基础
> 定义，但不得互相替代各自的完全可约与分类证明。

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
| RT3 | `representation-theory.character.table` | 特征标表的构造、行列索引与正交约束接口；具体有限群表归 Examples | RT3.decomposition |
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

> 家族前缀 `differential-manifolds.*`。课程门：AN-MV、T1–T4、L5；只负责光滑流形的语言、
> 切丛、形式与积分，不把微分拓扑或黎曼度量混入“流形基础”。
> 主教材为 Lee, *Introduction to Smooth Manifolds* 第二版（`lee-smooth-manifolds-2012`）：光滑
> 结构、切丛、向量场与流、Lie 群、微分形式、Stokes 和 de Rham 理论依次约束 DM1–DM5。Sard、
> 横截性与映射度按课程职责转入 DT，不重复造接口。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| DM1 | `differential-manifolds.manifold.definition` | 拓扑流形、图册与光滑结构 | AN-MV/T4 |
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
> 主教材为 Guillemin–Pollack, *Differential Topology*
>（`guillemin-pollack-differential-topology-1974`），负责 DT1–DT3 的 Sard、横截、交数和映射度；
> DT4 采用 Milnor, *Morse Theory*（`milnor-morse-theory-1963`）。DT5 的配边与特征类尚缺完整
> 出版教材，在补齐前保持 `research_open`。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| DT1 | `differential-topology.rank-theorem` | 常秩、逆函数与隐函数定理 | DM2/AN-MV |
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
> 主教材为 Lee, *Introduction to Riemannian Manifolds* 第二版
>（`lee-riemannian-manifolds-2018`），依书序覆盖度量、联络、Levi–Civita、测地线、曲率、
> 子流形、Jacobi 场与比较理论，即 RG1–RG6。RG7 的完整 Hodge 理论与 Gauss–Bonnet–Chern 尚需
> 专题教材，补齐前只开放研究接口。

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
| RG3 | `riemannian-geometry.first-variation` | 第一变分与测地线极值性 | RG3/AN-MV |
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
> 主教材继续采用 Kallenberg 第三版（`kallenberg-modern-probability-2021`）：过程与扩张、Markov
> 链、鞅、Gaussian/Brownian、随机积分、半鞅、SDE 与扩散依次对应 SP1–SP6。SP 与 Pr 共用同一
> 概率基础，不另造随机变量、条件期望或过滤。

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

> 家族前缀 `ode.*`。课程门：M4–M5、AN-MV、L2、T3。
> 主教材为 Teschl, *Ordinary Differential Equations and Dynamical Systems*
>（`teschl-ode-dynamical-systems-2012`）。Part I 的初值问题、连续依赖、线性方程与边值问题对应
> ODE1–ODE3；Part II 的动力系统、平面系统、高维系统和稳定性对应 ODE4–ODE6。分岔、KAM 与
> 遍历入口只作后续专题，不得早于存在唯一性、延拓与流的基础链。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| ODE1 | `ode.initial-value.problem` | 初值问题、经典解与最大解 | AN-MV |
| ODE1 | `ode.picard-lindelof` | Picard–Lindelöf 存在唯一性 | AN-MV/T3 |
| ODE1 | `ode.peano-existence` | Peano 存在定理 | AN-MV |
| ODE1 | `ode.continuous-dependence` | 对初值和参数连续依赖 | ODE1 |
| ODE2 | `ode.flow.semigroup` | 流、逃逸时间与延拓准则 | ODE1 |
| ODE2 | `ode.gronwall` | Grönwall 不等式及稳定性应用 | R4 |
| ODE2 | `ode.variation-of-constants` | 常数变易公式 | L2/ODE1 |
| ODE2 | `ode.linear.fundamental-matrix` | 基本矩阵、Wronskian 与 Liouville 公式 | L2 |
| ODE3 | `ode.linear.constant-coefficients` | 常系数系统与矩阵指数 | L4 |
| ODE3 | `ode.sturm-liouville` | Sturm 比较、振荡与边值问题 | RA-F5/F3 |
| ODE4 | `ode.phase-plane` | 平衡点、线性化与相图 | ODE2/L4 |
| ODE4 | `ode.lyapunov.stability` | Lyapunov 稳定性与不变集原理 | ODE2 |
| ODE4 | `ode.stable-manifold` | 稳定/不稳定流形定理 | ODE2/AFA |
| ODE5 | `ode.poincare-bendixson` | Poincaré–Bendixson 定理 | ODE4/T4 |
| ODE5 | `ode.bifurcation.local` | 鞍结、叉形与 Hopf 分岔 | ODE4 |
| ODE5 | `ode.hamiltonian.system` | Hamilton 系统、辛结构与守恒量 | ODE2/DM |
| ODE6 | `ode.dynamical-systems.invariant-set` | ω-极限集、吸引子与复现 | ODE2/T3 |
| ODE6 | `ode.ergodic-entry` | 流的不变测度与遍历入口 | ODE6/Pr3 |

**完成能力节点**：同时覆盖定性存在唯一性、线性系统、稳定性、分岔和动力系统，而非只收集解公式。

### 13.10 偏微分方程（PDE1–PDE10，Evans 第二版主线）🔒

> 家族前缀 `pde.*`。默认教材固定为 Lawrence C. Evans, *Partial Differential Equations*,
> Second Edition, AMS GSM 19（2010）。课程顺序保持教材的三部结构：表示公式（Chapters 2–4）、
> 线性 PDE 理论（Chapters 5–7）、非线性 PDE 理论（Chapters 8–12）。课程门：AN-MV、R4、
> ODE1–ODE2；Sobolev 以后另需 F1–F3。AFA5 分布和 F8 半群可作为后续桥，但不是跳过 Evans
> 经典表示公式、能量估计与弱解施工的捷径。文献键为
> `evans-partial-differential-equations-2010`。

#### PDE1 四类重要线性方程与表示公式（Evans Chapter 2）

| # | 条目 id | 内容 | 前置 |
|---|---|---|---|
| 1 | `pde.transport.characteristics` | 常系数输运方程、特征线与初值传播 | ODE1 |
| 2 | `pde.laplace.fundamental-solution` | Laplace 方程基本解与 Poisson 方程表示 | R4 |
| 3 | `pde.laplace.mean-value` | 调和函数平均值性质及其逆命题 | PDE1.2 |
| 4 | `pde.laplace.maximum-principle` | 弱／强最大值原理、唯一性与 Harnack 入口 | PDE1.3 |
| 5 | `pde.poisson.green-function` | Green 函数、Poisson 核与球／半空间表示 | PDE1.2 |
| 6 | `pde.heat.fundamental-solution` | 热核、卷积表示、平滑与质量守恒 | R4 |
| 7 | `pde.heat.maximum-energy` | 热方程最大值原理、能量法与唯一性 | PDE1.6 |
| 8 | `pde.wave.dalembert-spherical-means` | 一维 d’Alembert、高维球面均值公式与 Huygens 辨析 | 多元分析 |
| 9 | `pde.wave.energy-domain-dependence` | 波方程能量守恒、有限传播速度与依赖域 | PDE1.8 |
| 10 | `pde.linear.duhamel` | 热／波非齐次问题的 Duhamel 原理 | PDE1.6/PDE1.8 |

#### PDE2 非线性一阶方程（Evans Chapter 3）

| # | 条目 id | 内容 | 前置 |
|---|---|---|---|
| 1 | `pde.first-order.complete-integrals` | 完全积分、包络与奇异解 | ODE1 |
| 2 | `pde.first-order.characteristics` | 一般一阶 PDE 的特征方程组与局部解 | ODE2 |
| 3 | `pde.first-order.characteristic-breakdown` | 特征线交叉、梯度爆破与经典解失效 | PDE2.2 |
| 4 | `pde.hamilton-jacobi.introduction` | Hamilton–Jacobi 方程、作用量与完整积分入口 | PDE2.2/ODE |
| 5 | `pde.conservation-law.scalar-introduction` | 标量守恒律、Rankine–Hugoniot 与激波／稀疏波 | PDE2.2 |
| 6 | `pde.conservation-law.entropy-introduction` | 弱解不唯一、熵条件与 `L¹` 压缩入口 | PDE2.5 |

#### PDE3 其他解表示方法（Evans Chapter 4）

| # | 条目 id | 内容 | 前置 |
|---|---|---|---|
| 1 | `pde.representation.separation-variables` | 分离变量、特征函数展开与边界条件 | L5/PDE1 |
| 2 | `pde.representation.similarity` | 相似变量、尺度不变性与自相似解 | PDE1/PDE2 |
| 3 | `pde.representation.transform` | Fourier／Laplace 变换求解线性 PDE | AN3 |
| 4 | `pde.representation.nonlinear-transform` | Hopf–Cole 等非线性到线性的变换 | PDE1/PDE2 |
| 5 | `pde.representation.asymptotics` | Laplace 方法、驻相／最速下降的 PDE 渐近入口 | AN3/C1 |
| 6 | `pde.representation.power-series` | 解析系数、幂级数形式解与适用边界 | AN3 |

#### PDE4 Sobolev 空间（Evans Chapter 5）

| # | 条目 id | 内容 | 前置 |
|---|---|---|---|
| 1 | `pde.weak-derivative.definition` | 弱导数、分部积分定义与唯一性 | R4/F1 |
| 2 | `pde.sobolev.definition` | `W^{k,p}`、`H^k`、范数与完备性 | PDE4.1 |
| 3 | `pde.mollifier-density` | 磨光、局部逼近及光滑函数稠密性 | R4/PDE4.2 |
| 4 | `pde.sobolev.extension-trace` | 延拓算子、迹与零边界空间 `W₀^{1,p}` | PDE4.2 |
| 5 | `pde.sobolev.inequalities` | Gagliardo–Nirenberg–Sobolev、Morrey 与 Poincaré 不等式 | PDE4.2 |
| 6 | `pde.sobolev.compactness` | Rellich–Kondrachov 紧嵌入 | PDE4.5/F5 |
| 7 | `pde.sobolev.dual-negative` | 对偶空间与 `H⁻¹` 表示 | F2/PDE4.2 |
| 8 | `pde.sobolev.time-dependent` | Bochner–Sobolev 空间和时间弱导数入口 | R4/F1/PDE4.2 |

#### PDE5 二阶椭圆方程（Evans Chapter 6）

| # | 条目 id | 内容 | 前置 |
|---|---|---|---|
| 1 | `pde.elliptic.weak-formulation` | 散度型椭圆方程、弱解与双线性型 | PDE4 |
| 2 | `pde.elliptic.lax-milgram` | Lax–Milgram、弱解存在唯一性与能量界 | F3/PDE5.1 |
| 3 | `pde.elliptic.galerkin` | Galerkin 逼近、先验界与弱极限 | F4/PDE5.1 |
| 4 | `pde.elliptic.energy-estimates` | Caccioppoli 型估计、差商与内部 `H²` 正则性 | PDE4/PDE5.1 |
| 5 | `pde.elliptic.boundary-regularity` | 边界展平、全局正则性与边界条件 | PDE5.4 |
| 6 | `pde.elliptic.maximum-principle-general` | 一般二阶算子的弱／强最大值原理 | PDE1.4/PDE5.1 |
| 7 | `pde.elliptic.eigenvalues` | 椭圆特征值、主特征值与 Rayleigh 商刻画 | PDE5.2/F3/F5 |

#### PDE6 线性演化方程（Evans Chapter 7）

| # | 条目 id | 内容 | 前置 |
|---|---|---|---|
| 1 | `pde.parabolic.weak-formulation` | 二阶抛物方程弱解与时空能量空间 | PDE4/PDE5 |
| 2 | `pde.parabolic.galerkin` | Galerkin 构造、能量估计及存在唯一性 | PDE6.1 |
| 3 | `pde.parabolic.regularity` | 时间／空间正则性与初值迹 | PDE6.2 |
| 4 | `pde.parabolic.maximum-principle-general` | 一般抛物算子的最大值原理 | PDE1.7/PDE6.1 |
| 5 | `pde.hyperbolic.weak-formulation` | 二阶双曲方程弱解和能量空间 | PDE4/PDE1.9 |
| 6 | `pde.hyperbolic.galerkin-energy` | 双曲 Galerkin 法、能量估计与有限传播 | PDE6.5 |

#### PDE7 变分法（Evans Chapter 8）

| # | 条目 id | 内容 | 前置 |
|---|---|---|---|
| 1 | `pde.variational.direct-method` | 强制性、弱下半连续与直接法 | F4/PDE4 |
| 2 | `pde.variational.euler-lagrange` | 第一变分、Euler–Lagrange 方程与弱形式 | 多元分析/PDE4 |
| 3 | `pde.variational.convexity` | 凸性、严格凸性、存在唯一性与下半连续 | F2/PDE7.1 |
| 4 | `pde.variational.regularity` | 极小值的正则性入口与部分正则边界 | PDE5/PDE7.2 |
| 5 | `pde.variational.constraints` | 约束极值、Lagrange 乘子与障碍问题入口 | PDE7.1 |

#### PDE8 非变分技术（Evans Chapter 9）

| # | 条目 id | 内容 | 前置 |
|---|---|---|---|
| 1 | `pde.nonlinear.monotonicity` | 单调算子、弱收敛与 Minty 技巧 | AFA6/PDE4 |
| 2 | `pde.nonlinear.fixed-point` | Schauder／压缩映射的 PDE 存在性框架 | F2/PDE4 |
| 3 | `pde.nonlinear.sub-super-solutions` | 上下解、单调迭代与比较 | PDE5 |
| 4 | `pde.nonlinear.regularity-bootstrap` | 先验估计、bootstrap 与延拓选择 | PDE5/PDE6 |
| 5 | `pde.nonlinear.degree-method` | Leray–Schauder 度与同伦延拓入口 | T4/F2 |

#### PDE9 Hamilton–Jacobi 方程（Evans Chapter 10）

| # | 条目 id | 内容 | 前置 |
|---|---|---|---|
| 1 | `pde.hamilton-jacobi.hopf-lax` | Hopf–Lax 公式、半群性质与经典解失效 | PDE2/AN-MV |
| 2 | `pde.viscosity.definition` | 上／下测试函数、黏性次解／上解 | PDE2/PDE9.1 |
| 3 | `pde.viscosity.stability` | 局部一致极限下稳定性 | PDE9.2 |
| 4 | `pde.viscosity.comparison` | doubling variables、比较原理与唯一性 | PDE9.2 |
| 5 | `pde.hamilton-jacobi.control` | 动态规划、最优控制与 Hamilton–Jacobi–Bellman 入口 | PDE9.1/Pr1 |

#### PDE10 守恒律系统与非线性波（Evans Chapters 11–12）

| # | 条目 id | 内容 | 前置 |
|---|---|---|---|
| 1 | `pde.conservation-law.weak-solution` | 标量／系统弱解与 Rankine–Hugoniot | PDE2/PDE4 |
| 2 | `pde.conservation-law.entropy` | 熵–熵通量对、熵不等式与可容许性 | PDE10.1 |
| 3 | `pde.conservation-law.l1-contraction` | 标量熵解唯一性与 `L¹` 压缩 | PDE10.2 |
| 4 | `pde.conservation-system.hyperbolicity` | 严格双曲系统、特征族与 Riemann 不变量 | PDE10.1/L5 |
| 5 | `pde.nonlinear-wave.local-existence` | 拟线性／半线性波方程局部存在 | PDE6/PDE8 |
| 6 | `pde.nonlinear-wave.energy-blowup` | 高阶能量、延拓判据与有限时爆破 | PDE10.5 |
| 7 | `pde.nonlinear-wave.null-condition-entry` | 零条件与小数据整体存在入口 | PDE10.6 |

#### PDE+ Evans 主线之外的后续专题

| 条目 id | 内容 | 前置／归属 |
|---|---|---|
| `pde.navier-stokes.weak-existence` | Leray–Hopf 弱解、能量不等式与压力恢复 | PDE4/PDE6/AFA6 |
| `pde.microlocal.wavefront-entry` | Fourier 变换、奇性传播与波前集入口 | HAna/AFA5/PDE6 |
| `pde.evolution.semigroup-bridge` | Evans 弱解／能量解到 `C₀` 半群温和解的具名桥 | PDE6/F8 |
| `pde.semigroup.maximal-regularity` | 解析半群和抛物方程最大正则性 | F8/AFA6/PDE6 |

**完成能力节点**：先能由表示公式解释输运、Laplace、热和波方程，再以 Sobolev 空间建立弱解、
存在唯一性和正则性；最后能区分变分、非变分、黏性、熵和能量方法。不得把分布、半群或现成
Mathlib 强定理当成跳过 Evans 经典公式与估计链的捷径。

### 13.11 局部凸空间与广义泛函分析（AFA1–AFA6）🔒

> 家族前缀 `advanced-functional-analysis.*`。本课程研究不能由单个范数良好控制的拓扑向量空间，
> 主线是“半范数族 → 局部凸空间 → Fréchet／LF／DFS 空间 → 桶性、Bornological 与 Montel 性质
> → 核空间 → 测试函数与分布”。Salamon 主线中的弱拓扑、紧／Fredholm 算子、有界与无界谱理论
> 及半群仍归 F2–F8，本节不重复登记。课程门：F2、F4、F7、R4、AN-MV、T1–T2。
> 主教材为 Trèves, *Topological Vector Spaces, Distributions and Kernels*
>（`treves-topological-vector-spaces-1967`），依次约束 AFA1–AFA5。AFA6 的现代算子理想、最大
> 正则性和非线性出口超出主教材，补指定专题教材前只开放研究。

本课程交付须逐对象报告：拓扑由哪些半范数／邻域生成、是否 Hausdorff、采用何种完备性与有界性、
对偶上的具体拓扑，以及收敛使用序列还是一般网／滤子；不得把 Fréchet 完备性脱离“可度量局部凸”
语境，也不得混称弱有界、拓扑有界和范数有界。

#### AFA1 半范数与局部凸拓扑

| # | 条目 id | 内容 | 前置 |
|---|---|---|---|
| 1 | `advanced-functional-analysis.seminorm.definition` | 半范数、核、商空间及与范数的差别 | F1 |
| 2 | `advanced-functional-analysis.locally-convex.generated` | 半范数族生成局部凸拓扑、有限交邻域基 | AFA1.1/T1 |
| 3 | `advanced-functional-analysis.locally-convex.continuous-linear` | 线性映射连续性的有限半范数控制判据 | AFA1.2 |
| 4 | `advanced-functional-analysis.locally-convex.bounded-set` | 吸收、平衡、凸集与拓扑有界集 | AFA1.2 |
| 5 | `advanced-functional-analysis.locally-convex.minkowski` | Minkowski 泛函与局部凸邻域重建 | F2/AFA1.4 |
| 6 | `advanced-functional-analysis.locally-convex.hahn-banach` | 局部凸空间上的 Hahn–Banach 与几何分离 | F2/AFA1.5 |

#### AFA2 可度量化、完备化与 Fréchet 空间

| # | 条目 id | 内容 | 前置 |
|---|---|---|---|
| 1 | `advanced-functional-analysis.metrizable.countable-seminorms` | 可数半范数族与平移不变度量 | AFA1 |
| 2 | `advanced-functional-analysis.frechet.definition` | Fréchet 空间、完备可度量局部凸性的定义与基本性质；标准空间实例归 Examples E11.11 | AFA2.1 |
| 3 | `advanced-functional-analysis.locally-convex.completion` | Hausdorff 化、完备化及稠密嵌入泛性质 | AFA1/AFA2.1 |
| 4 | `advanced-functional-analysis.frechet.open-mapping` | Fréchet 空间开映射定理 | AFA2.2/F2 |
| 5 | `advanced-functional-analysis.frechet.closed-graph` | Fréchet 空间闭图定理 | AFA2.4 |
| 6 | `advanced-functional-analysis.frechet.inverse` | Fréchet 空间连续线性双射的逆连续性 | AFA2.4 |

#### AFA3 桶空间、Bornological 空间与对偶性

| # | 条目 id | 内容 | 前置 |
|---|---|---|---|
| 1 | `advanced-functional-analysis.barrelled.definition` | 桶、桶空间与 Fréchet 空间的桶性 | AFA1/AFA2 |
| 2 | `advanced-functional-analysis.barrelled.banach-steinhaus` | 桶空间上的一致有界原理 | AFA3.1/F2 |
| 3 | `advanced-functional-analysis.bornological.definition` | Bornology、Bornological 空间与有界线性映射连续性 | AFA1.4 |
| 4 | `advanced-functional-analysis.equicontinuous.polar` | 等度连续族、极集与双极定理 | F4/AFA1 |
| 5 | `advanced-functional-analysis.dual.strong-weak-star` | 强对偶、弱对偶、弱星对偶及相应拓扑 | F4/AFA3.4 |
| 6 | `advanced-functional-analysis.mackey-topology` | 对偶配对、Mackey 拓扑与 Mackey–Arens 入口 | AFA3.5 |

#### AFA4 Montel、LF／DFS 与核空间

| # | 条目 id | 内容 | 前置 |
|---|---|---|---|
| 1 | `advanced-functional-analysis.montel.definition` | Montel 空间、闭有界集紧性与自反性 | AFA2/AFA3 |
| 2 | `advanced-functional-analysis.inductive-limit.lf` | 局部凸归纳极限与 LF 空间 | AFA1/AFA2 |
| 3 | `advanced-functional-analysis.strong-dual.dfs` | Fréchet–Schwartz 空间的强对偶与 DFS 空间 | AFA3/AFA4.2 |
| 4 | `advanced-functional-analysis.nuclear.definition` | 核映射、核空间与半范数／Hilbert 空间刻画 | AFA2/AFA3 |
| 5 | `advanced-functional-analysis.nuclear.stability` | 子空间、商、积、极限和完备化下的核性 | AFA4.4 |
| 6 | `advanced-functional-analysis.nuclear.tensor` | 投射／内射张量积与核空间上的一致性 | AFA4.4 |

#### AFA5 测试函数、分布与核定理

| # | 条目 id | 内容 | 前置 |
|---|---|---|---|
| 1 | `advanced-functional-analysis.test-function.frechet` | `C∞` 空间的 Fréchet 拓扑与导数半范数 | AFA2/AN-MV |
| 2 | `advanced-functional-analysis.test-function.lf` | 紧支撑光滑函数 `𝒟` 的 LF 拓扑 | AFA4.2/AN-MV |
| 3 | `advanced-functional-analysis.distribution.definition` | 分布作为 `𝒟` 的连续线性泛函、阶与支撑 | AFA5.2 |
| 4 | `advanced-functional-analysis.schwartz-space` | Schwartz 空间的 Fréchet／核拓扑 | AFA2/AFA4.4 |
| 5 | `advanced-functional-analysis.tempered-distribution` | 温和分布、Fourier 变换与卷积边界 | AFA5.4/AN3 |
| 6 | `advanced-functional-analysis.schwartz-kernel` | Schwartz 核定理与双线性映射表示 | AFA4.6/AFA5.2 |

#### AFA6 广义算子理论出口

| # | 条目 id | 内容 | 前置 |
|---|---|---|---|
| 1 | `advanced-functional-analysis.operator-space.topologies` | 强、弱、一致收敛算子拓扑及等度连续集合 | AFA3/F4 |
| 2 | `advanced-functional-analysis.operator-ideals` | 核、Hilbert–Schmidt、迹类与 Schatten 理想 | F5/F6/AFA4 |
| 3 | `advanced-functional-analysis.trace-determinant` | 迹、Fredholm 行列式与谱乘积 | AFA6.2/F6 |
| 4 | `advanced-functional-analysis.semigroup.maximal-regularity` | 解析半群的最大正则性与插值空间 | F8/AFA3 |
| 5 | `advanced-functional-analysis.nonlinear.monotone` | 极大单调算子与非线性演化入口 | F7/AFA3 |
| 6 | `advanced-functional-analysis.variational` | 变分不等式、次微分与凸优化接口 | F2/AFA3 |

**完成能力节点**：能明确区分范数有界与拓扑有界、完备与序列完备、Fréchet／LF／DFS、桶性／
Bornological／Montel／核性以及不同对偶拓扑；能在测试函数和分布空间中正确选择连续性、有界性与
收敛概念，而不是把 Banach 空间定理无条件照搬到“性质较差”的空间。

### 13.12 Fourier 与调和分析（HAna1–HAna7）🔒

> 家族前缀 `harmonic-analysis.*`。课程门：R4、F1–F3、AFA；避免与同调代数 HA 缩写混淆。
> 这是本库的**专门 Fourier 分析课程**，不是 AN3 的 Fourier 变换初步，也不是泛函分析 Parseval
> 条目的附录。主教材为 Grafakos, *Classical Fourier Analysis* 第三版
>（`grafakos-classical-fourier-analysis-2014`）。`Lᵖ` 与插值、Fourier 变换／分布／卷积、
> Fourier 级数、极大函数、卷积型奇异积分、Littlewood–Paley 与乘子、加权不等式依次对应 HAna1–HAna7；
> 群上调和分析与限制问题超出该书主线，补教材前保持研究专题。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| HAna1 | `harmonic-analysis.fourier.normalization` | 固定 `ℝⁿ` Fourier 变换的指数、测度与常数约定 | R4/AN3 |
| HAna1 | `harmonic-analysis.fourier.schwartz` | Schwartz 空间、变换自同构及微分／乘法互换 | AFA5 |
| HAna1 | `harmonic-analysis.fourier.inversion` | `L¹` 与 Schwartz 类上的 Fourier 反演 | HAna1.schwartz |
| HAna1 | `harmonic-analysis.fourier.plancherel` | 从稠密子空间延拓到 `L²` 的 Plancherel 酉算子 | F3/R4 |
| HAna1 | `harmonic-analysis.convolution.young` | 卷积、平移、结合律与 Young 不等式 | R4 |
| HAna1 | `harmonic-analysis.approximate-identity` | 近似恒等与 `Lᵖ` 收敛 | HAna1.convolution |
| HAna1 | `harmonic-analysis.fourier.tempered-distribution` | 温和分布上的 Fourier 变换及卷积边界 | AFA5/HAna1.schwartz |
| HAna2 | `harmonic-analysis.fourier-series.kernel` | 圆环 Fourier 系数、Dirichlet／Fejér／Poisson 核 | AN3/R4 |
| HAna2 | `harmonic-analysis.fourier-series.convergence` | Fourier 级数的点态、Cesàro 与 `L²` 收敛 | HAna2.kernel/HAna1.plancherel |
| HAna2 | `harmonic-analysis.poisson-summation` | Poisson 求和公式及成立条件 | HAna1.schwartz/HAna2.kernel |
| HAna3 | `harmonic-analysis.maximal.hardy-littlewood` | Hardy–Littlewood 极大算子 | R4 |
| HAna3 | `harmonic-analysis.differentiation-integrals` | Lebesgue 微分定理 | HAna3 |
| HAna3 | `harmonic-analysis.interpolation` | Riesz–Thorin 与 Marcinkiewicz 插值 | F2/R4 |
| HAna4 | `harmonic-analysis.singular-integral.hilbert` | Hilbert 变换与 `Lᵖ` 有界性 | HAna3 |
| HAna4 | `harmonic-analysis.calderon-zygmund` | Calderón–Zygmund 分解与算子 | HAna3 |
| HAna4 | `harmonic-analysis.littlewood-paley` | Littlewood–Paley 分解与平方函数 | HAna1 |
| HAna5 | `harmonic-analysis.hardy-bmo` | Hardy 空间、BMO 与对偶 | HAna4 |
| HAna5 | `harmonic-analysis.sobolev-besov` | Sobolev、Besov 与 Triebel–Lizorkin 入口 | HAna4/PDE4 |
| HAna6 | `harmonic-analysis.locally-compact-group` | Haar 测度与群卷积 | A1/R4 |
| HAna6 | `harmonic-analysis.pontryagin-duality` | 局部紧 Abel 群 Fourier 理论 | HAna6 |
| HAna6 | `harmonic-analysis.peter-weyl` | 紧群 Peter–Weyl 定理 | HAna6/RT |
| HAna7 | `harmonic-analysis.oscillatory-integral` | 振荡积分与驻相法 | C3/AN3 |
| HAna7 | `harmonic-analysis.restriction-entry` | Fourier 限制问题入口 | HAna7 |

**完成能力节点**：从 Fourier/卷积推进到极大函数、奇异积分、函数空间和群上的调和分析；
只证明 Fourier 反演或 Plancherel 不算完成。

### 13.13 代数几何（AG1–AG10）🔒

> 家族前缀 `algebraic-geometry.*`。课程门：CA1–CA6、A3、HA1–HA5。它是独立的大型路线，
> 仿射簇课程只能算 AG1–AG2，不能代表概形、层上同调或高维几何。
> 主教材为 Hartshorne, *Algebraic Geometry*（`hartshorne-algebraic-geometry-1977`）：Chapter I
> 对应 AG1–AG2，Chapter II 对应 AG3–AG5，Chapter III 对应 AG6，Chapters IV–V 对应 AG7 与
> 曲面入口。Stacks Project 从 Schemes 起承担 AG3 之后的 Tag 级依赖导航，并为 descent、étale、
> algebraic stacks、deformation 等 AG8–AG10 专题提供施工地图；这些超出 Hartshorne 连续覆盖的
> 批次仍须补出版教材，不能因为 Stacks 已有章节就直接开放正式开发。

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
>
> **教材框架**：ML1–ML2 与 ML5 以 Enderton, *A Mathematical Introduction to Logic* 第二版
>（`enderton-mathematical-logic-2001`）为主教材，按语法／语义、可靠性／完备性、可定义性与
> 不完备性推进；ML3 以 Marker, *Model Theory: An Introduction*（`marker-model-theory-2002`）
> 为主教材。ML4 可计算性以 Odifreddi, *Classical Recursion Theory* 为主教材，ML6
> 的模型、可构造宇宙与 forcing 以 Jech 的 Models/Constructible Sets/Forcing 章节为主教材，ML7
> 证明论以 Pohlers, *Proof Theory: An Introduction* 为主教材。至此 ML1–ML7 均有出版教材；各书
> 的对象语言、证明系统、机器模型和集合论宇宙不得静默混用。其余文献键为 `jech-set-theory-2003`、
> `odifreddi-classical-recursion-1989`、`pohlers-proof-theory-1989`。

路线顺序据教材调整为 ML1 语法／语义 → ML2 证明系统与完备性 → ML3 模型论；ML4 可在共享机器
承载冻结后并行；ML5 必须同时等待 ML1 的语法编码和 ML4 的可表示性工具；ML6 等待 ML2 的模型
语言与 ST2 的集合论基础；ML7 的切消可在 ML2 后研究，序数分析与一致性必须等待 ML5/ST3。

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

### 13.15 多复变函数论（SCV1–SCV7）🔒

> 家族前缀 `several-complex-variables.*`。主教材为 Krantz, *Function Theory of Several Complex
> Variables* 第二版（`krantz-several-complex-variables-2001`）。课程从 `ℂⁿ` 上全纯性、幂级数与
> 多重 Cauchy 公式推进到 Hartogs 现象、拟凸性、Levi 问题、`∂̄` 方法和解析集；不能把逐坐标全纯
> 或把一元 Cauchy 定理重复 `n` 次冒充多复变理论。课程门为完整 C2–C3、AN-MV、R4；SCV5 以后
> 另需 AFA5/DM。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| SCV1 | `several-complex-variables.holomorphic.definition` | `ℂⁿ` 上复 Fréchet 可微、全纯映射与坐标判据 | C1/AN-MV |
| SCV1 | `several-complex-variables.power-series.multindex` | 多重指标、绝对收敛域与逐项微分 | C1/R4 |
| SCV1 | `several-complex-variables.cauchy.polydisc` | 多圆盘上的迭代 Cauchy 公式与导数估计 | C2/Fubini |
| SCV2 | `several-complex-variables.identity-uniqueness` | 恒等定理、唯一性集及零集边界 | SCV1 |
| SCV2 | `several-complex-variables.hartogs.extension` | Hartogs 分别全纯与延拓现象 | SCV1 |
| SCV2 | `several-complex-variables.domain-holomorphy` | 全纯域、全纯凸包与延拓障碍 | SCV2.hartogs |
| SCV3 | `several-complex-variables.psh.definition` | 次调和／多重次调和函数与基本闭包性质 | C3/SCV1 |
| SCV3 | `several-complex-variables.pseudoconvex.levi` | 拟凸域、Levi 形式与 Levi 拟凸性 | SCV3.psh/AN-MV |
| SCV4 | `several-complex-variables.dbar.complex` | `(p,q)` 形式、`∂`、`∂̄` 与 Dolbeault 复形 | DM2/SCV1 |
| SCV4 | `several-complex-variables.dbar.solution` | `∂̄` 方程的积分／估计解法入口 | SCV4/R4/AFA5 |
| SCV4 | `several-complex-variables.levi-problem` | 拟凸域是全纯域的证明链 | SCV3/SCV4 |
| SCV5 | `several-complex-variables.analytic-set.local` | 解析集、正则点、奇点与局部维数 | SCV1/CA |
| SCV5 | `several-complex-variables.weierstrass.preparation` | Weierstrass 预备与除法定理 | SCV1/A3 |
| SCV6 | `several-complex-variables.mapping.proper` | proper 全纯映射、分歧与有限性 | SCV5/DM |
| SCV6 | `several-complex-variables.automorphism-domain` | 有界域自同构与不变量的一般接口 | SCV3/SCV6 |
| SCV7 | `several-complex-variables.coherent-sheaf-entry` | 全纯函数层、凝聚性与 Cartan 定理入口 | SCV5/AG3/HA4 |

**完成能力节点**：能够处理 Hartogs 延拓、拟凸性与 `∂̄` 三条真正多变量的主线，并把解析集接到
复几何／代数几何；只建立 `ℂⁿ` 导数和多重幂级数不算完成。

### 13.16 Riemann 曲面与一维复几何（RS1–RS7）🔒

> “解析曲面”在本路线中精确登记为一维复流形，即 Riemann 曲面；复维二及以上的复解析空间归
> SCV5–SCV7。主教材为 Forster, *Lectures on Riemann Surfaces*
>（`forster-riemann-surfaces-1981`）。课程门为 T4、完整 C2–C3、DM1–DM2；层与 Riemann–Roch
> 批次另需 HA/AG 基础。不得把“局部看起来像 `ℂ`”当成全局亚纯函数、除子或一致化已经建立。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| RS1 | `riemann-surfaces.definition.atlas` | 复图册、一维复流形与全纯／反全纯映射 | DM1/C1 |
| RS1 | `riemann-surfaces.covering-analytic-continuation` | 解析延拓、单值化与覆盖空间接口 | T4/C2 |
| RS2 | `riemann-surfaces.meromorphic.divisor` | 亚纯函数、零极点阶数与除子 | C3/RS1 |
| RS2 | `riemann-surfaces.differential.meromorphic` | 全纯／亚纯微分与留数定理 | C3/RS1 |
| RS3 | `riemann-surfaces.harmonic.green` | 调和函数、Green 函数与共轭微分 | R4/C2/RS1 |
| RS3 | `riemann-surfaces.periods.homology` | 闭微分、周期与一阶同调配对 | AT2/RS2 |
| RS4 | `riemann-surfaces.sheaf.cohomology` | 全纯函数层、亚纯函数层与一阶层上同调 | AG3/HA4/RS1 |
| RS4 | `riemann-surfaces.runge-mittag-leffler` | Runge、Mittag–Leffler 与 Cousin 问题 | RS4/C3 |
| RS5 | `riemann-surfaces.riemann-roch` | 紧 Riemann 曲面的 Riemann–Roch | RS2/RS4 |
| RS5 | `riemann-surfaces.serre-duality` | 一维 Serre 对偶与残数配对 | RS4/HA5 |
| RS6 | `riemann-surfaces.uniformization` | 单连通 Riemann 曲面一致化 | RS1/T4/HAna |
| RS6 | `riemann-surfaces.compact.genus` | genus、Euler 特征与典范除子 | RS3/RS5/AT |
| RS7 | `riemann-surfaces.jacobian.abel` | Jacobian、Abel 定理与 Abel–Jacobi 映射 | RS3/RS5 |
| RS7 | `riemann-surfaces.algebraic-curve-bridge` | 紧 Riemann 曲面与光滑射影复曲线的桥 | RS5/AG7 |

**完成能力节点**：局部复图册、覆盖与解析延拓、亚纯函数／微分、层上同调、Riemann–Roch 和
一致化形成连续链；只形式化 Riemann 球面或环面等具体对象归 Examples，不代表课程完成。

### 13.17 博弈论（GT1–GT8）🔒

> 家族前缀 `game-theory.*`。主教材为 Osborne–Rubinstein, *A Course in Game Theory*
>（`osborne-rubinstein-game-theory-1994`）；不完全信息、机制与合作博弈部分以 Myerson,
> *Game Theory: Analysis of Conflict*（`myerson-game-theory-1991`）补齐。课程按战略式、混合策略与
> 均衡存在、扩展式、重复博弈、不完全信息、合作博弈与机制设计推进。有限博弈入口只需有限集合与
> 概率单纯形；Nash 存在需凸性／不动点，Bayesian 路线需 Pr1，连续行动空间另需 T2/F2。

| 批次 | 条目 id | 内容 | 前置 |
|---|---|---|---|
| GT1 | `game-theory.strategic-form.definition` | 玩家、策略集、收益与战略式博弈 | ST1/L1 |
| GT1 | `game-theory.best-response.nash` | 最优反应、纯策略 Nash 均衡与优势关系 | GT1 |
| GT1 | `game-theory.dominance.rationalizability` | 严格／弱占优、迭代删除与可理性化 | GT1 |
| GT2 | `game-theory.mixed-strategy.simplex` | 有限混合策略、期望收益与支撑 | Pr1/L1 |
| GT2 | `game-theory.nash-existence.finite` | 有限博弈 Nash 均衡存在定理 | GT2/T2/F2.fixed-point |
| GT2 | `game-theory.zero-sum.minimax` | 二人零和极小极大、鞍点与线性规划对偶接口 | GT2/L7/F2 |
| GT3 | `game-theory.extensive-form.history` | 历史树、信息集、行为策略与实现计划 | GT1/ST1 |
| GT3 | `game-theory.backward-induction` | 完美信息有限博弈的逆向归纳 | GT3 |
| GT3 | `game-theory.subgame-perfect` | 子博弈精炼与一次偏离原则 | GT3 |
| GT4 | `game-theory.repeated.discounted` | 折扣重复博弈、策略与收益 | GT3/Series |
| GT4 | `game-theory.repeated.folk-theorem-entry` | 可行且个体理性收益与 folk theorem 入口 | GT4/GT2 |
| GT5 | `game-theory.bayesian.type-space` | 类型空间、先验、策略与 Bayesian Nash 均衡 | Pr1/GT2 |
| GT5 | `game-theory.incomplete-information.harsanyi` | Harsanyi 变换与序贯均衡入口 | GT3/GT5 |
| GT6 | `game-theory.cooperative.core` | 特征函数博弈、核与平衡性 | GT1/CA |
| GT6 | `game-theory.cooperative.shapley` | Shapley 值的公理刻画与唯一性 | GT6/L1 |
| GT7 | `game-theory.bargaining.nash` | Nash 议价解的公理刻画 | GT2/F2 |
| GT7 | `game-theory.social-choice.gibbard-satterthwaite-entry` | 社会选择、操纵与不可能性入口 | GT1/ST1 |
| GT8 | `game-theory.mechanism.revelation` | 直接机制、激励相容与揭示原理 | GT5 |
| GT8 | `game-theory.auction.revenue-equivalence` | 拍卖、支付恒等式与收益等价的一般定理 | GT5/GT8 |

**完成能力节点**：至少贯通 Nash 均衡存在、扩展式精炼、不完全信息、合作解概念和机制设计；只枚举
有限收益矩阵的均衡是 Examples 工作，不等于博弈论课程完成。

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

#### 15.3.1 论文候选的状态与验收规则

以下清单不是把论文标题当作已完成 Entry，也不是要求逐页翻译历史证明。状态统一解释为：

- `paper_ready`：表中“必要设施”已经进入 Main，可以为首批核心结果建立 RFC；正式开发仍须由
  Main 分配文件所有权。
- `paper_research_open`：可以调查原文、现代证明链与 Mathlib 接口，但尚不能提交声称覆盖论文核心
  定理的正式 Entry。
- `future_paper`：课程设施尚未完成，只登记依赖门和目标，禁止提前包装最终 Mathlib 定理。

每篇论文开工前必须形成 `docs/handoffs/<subject>-paper-<slug>.md`，逐条回答：原论文的哪一个定理／
引理是本批目标；采用原证明还是现代等价证明；哪些定义由本库承载；哪些 Mathlib 结果只是后端；
首批没有覆盖论文的哪些部分。一个论文可以拆成多批，但每批仍须是 3–6 个相互支撑、可以被下游
实际使用的公开声明。历史论文中的数值实验、物理解释或非严格断言不得改写成 Lean 定理。

#### 15.3.2 主干学科论文形式化候选

| 领域 | 论文（`reference.bib` key） | 必要设施 | 首批可形式化核心 | 状态与边界 |
|---|---|---|---|---|
| 线性代数／数值线性代数 | Eckart–Young, 1936（`eckart-young-low-rank-1936`） | L4–L7；奇异值、Frobenius 范数、秩约束集合 | 截断 SVD 的秩界、误差公式与最佳秩 `k` 逼近 | `paper_ready`；先做有限维实／复矩阵，不宣称任意酉不变范数的 Mirsky 推广 |
| 抽象代数 | Wedderburn, 1905（`wedderburn-finite-algebras-1905`） | A1、A2 域／除环桥、A3 有限域 | 有限除环中心、极大子域与“有限除环必交换” | `paper_research_open`；当前本库公开域默认交换，须先建立非交换除环课程承载 |
| 点集拓扑／流形入口 | Whitney, 1936（`whitney-differentiable-manifolds-1936`） | T1–T4、AN-MV、DM1–DM4 | 局部嵌入、分割单位、紧流形到欧氏空间的嵌入施工 | `future_paper`；不能把 Mathlib 已有嵌入存在性单句包装为整篇论文 |
| 实分析／测度论 | Nikodym, 1930（`nikodym-radon-generalization-1930`） | R4、RA-F1–RA-F2；有限符号测度与绝对连续 | Radon–Nikodym 导数的存在、a.e. 唯一性与积分重建 | `paper_research_open`；先冻结 σ-有限／有限测度版本及符号约定 |
| 复分析 | de Branges, 1985（`de-branges-bieberbach-1985`） | 完整 C2–C3；单叶函数、正规族、Loewner 链与系数泛函 | 归一化单叶类、Loewner 系数微分式、低阶系数界 | `future_paper`；低阶验证不等于 Bieberbach 全系数定理完成 |
| 泛函分析 | Banach–Steinhaus, 1927（`banach-steinhaus-condensation-1927`） | F1–F2、Baire 与一致有界原理 | 双指标泛函族的奇点凝聚原理及其一致有界推论 | `paper_ready`；不得只把现有 Banach–Steinhaus 条目换标题 |
| 概率论 | Donsker, 1951（`donsker-invariance-principle-1951`） | Pr1–Pr3、SP1–SP3；路径空间、弱收敛与 Brownian 运动 | 随机游走插值、有限维分布收敛、紧性与 Wiener 极限 | `future_paper`；CLT 不能代替路径空间中的函数型极限定理 |
| 统计推断 | Neyman–Pearson, 1933（`neyman-pearson-tests-1933`） | Pr1、S1–S2；似然比、检验大小与功效 | 简单对简单假设的 Neyman–Pearson 引理及随机化边界 | `future_paper`；先做支配概率模型，不把复合假设一并声称完成 |
| 数论 | Green–Tao, 2008（`green-tao-prime-progressions-2008`） | N3、HAna1–HAna4；Szemerédi 定理、伪随机测度与筛法 | 稠密模型／传递原理、线性形式条件和素数等差数列结论 | `future_paper`；不得用现成最终 theorem 跳过相对 Szemerédi 证明链 |
| 集合论 | Cohen, 1963（`cohen-continuum-hypothesis-1963`） | ST1–ST2、ML1–ML4；可数传递模型、偏序与 forcing 语义 | 名称／估值递归、forcing theorem、保持 ZF(C) 的扩张及 `¬CH` 模型 | `future_paper`；最终独立性陈述不能脱离元理论一致性前提 |

#### 15.3.3 高阶学科论文形式化候选

| 领域 | 论文（`reference.bib` key） | 必要设施 | 首批可形式化核心 | 状态与边界 |
|---|---|---|---|---|
| 交换代数 | Quillen, 1976（`quillen-projective-modules-1976`） | CA1–CA6、HA1–HA5；有限表示投射模、局部化与拼接 | Quillen 局部—整体拼接引理，继而证明多项式环上的有限生成投射模自由 | `future_paper`；须说明与 Suslin 独立证明的范围，不把 Serre 问题名称当证明 |
| 同调代数 | Grothendieck, 1957（`grothendieck-tohoku-1957`） | HA1–HA5、CA1–CA3；Abel 范畴、分解、导出函子 | AB 公理、足够内射对象条件、导出函子长正合列与 Grothendieck 谱序列入口 | `future_paper`；一篇论文拆多批，不能用一个“有足够内射”包装覆盖全文 |
| 代数拓扑 | Serre, 1951（`serre-fiber-spaces-1951`） | AT1–AT4、HA2–HA6；纤维化、过滤复形与谱序列 | Serre 谱序列构造、边缘同态及可供实例调用的同调比较接口 | `future_paper`；先固定同调系数与收敛型；具体纤维束同调计算另登记 Examples，不笼统声称全部应用 |
| 表示论 | Deligne–Lusztig, 1976（`deligne-lusztig-finite-groups-1976`） | RT1–RT6、AG3–AG6；有限 Lie 型群、étale 上同调 | Deligne–Lusztig 簇的群作用、虚特征标定义及一般上同调迹接口 | `future_paper`；具体低秩对象归 Examples E13.2；几何构造与上同调迹公式未完成前不得发布表示分类 |
| 微分流形 | Whitney, 1936（`whitney-differentiable-manifolds-1936`） | DM1–DM5、T2、AN-MV | Whitney 嵌入定理的局部图、一般位置和有限子覆盖证明链 | `future_paper`；与主干表共享同一来源，只登记一个 BibTeX 条目 |
| 微分拓扑 | Smale, 1961（`smale-generalized-poincare-1961`） | DT1–DT5、AT1–AT5；手术、handle 与 h-cobordism | handle 消去、h-cobordism 主步骤及高维广义 Poincaré 推论 | `future_paper`；维数与单连通前提必须逐条保留，不涉及四维情形 |
| 黎曼几何 | Cheeger, 1970（`cheeger-finiteness-1970`） | RG1–RG7、DT1–DT3；曲率、测地坐标与紧性 | 曲率／直径／体积界下的坐标控制、有限微分同胚型结论 | `future_paper`；先冻结论文使用的归一化与注入半径桥 |
| 随机过程 | Itô, 1944（`ito-stochastic-integral-1944`） | SP1–SP4、Pr1–Pr3；适应过程、二次变差与 `L²` 极限 | 简单过程积分、Itô 等距、完备化及 Itô 公式入口 | `future_paper`；不把确定性 Bochner 积分冒充随机积分 |
| 常微分方程／动力系统 | Lorenz, 1963（`lorenz-nonperiodic-flow-1963`） | ODE1–ODE5、L4、数值误差接口 | Lorenz 多项式向量场、对称性、平衡点、局部稳定性与吸收椭球估计 | `future_paper`；论文数值轨道不自动成为严格“混沌存在”定理 |
| 偏微分方程 | Nash, 1958（`nash-pde-continuity-1958`） | PDE1–PDE6、RA-F3–RA-F5、F1–F3 | 一致椭圆／抛物方程弱解的能量估计、迭代不等式与 Hölder 连续性 | `future_paper`；先做标量方程，不能泛化到任意非线性系统 |
| 局部凸空间／广义泛函分析 | Grothendieck, 1955（`grothendieck-topological-tensor-1955`） | AFA1–AFA6、F1–F4、HA1；完备化与张量泛性质 | 投射／内射拓扑张量积、核型映射定义与首批等价刻画 | `future_paper`；Memoirs 专著按章节拆批，不以一个 nuclearity 谓词代替理论 |
| 调和分析 | Carleson, 1966（`carleson-fourier-convergence-1966`） | HAna1–HAna5、RA-F3–RA-F6；极大算子与时频分解 | Carleson 算子模型、弱型／`L²` 估计分解及 Fourier 部分和 a.e. 收敛 | `future_paper`；先冻结周期归一化和 maximal truncation，不用 Plancherel 冒充核心估计 |
| 多复变 | Hörmander, 1965（`hormander-dbar-estimates-1965`） | SCV1–SCV4、R4、AFA5；拟凸域、加权 `L²` 空间与闭算子 | `∂̄` 的先验估计、最小范数解与在拟凸域上的存在性链 | `future_paper`；必须固定权函数正则性和闭值域框架，不以最终 solvability theorem 包装全文 |
| Riemann 曲面／复几何 | Serre, 1956（`serre-gaga-1956`） | RS1–RS7、AG3–AG7、HA4；解析／代数凝聚层与上同调 | analytification、凝聚层上同调比较及射影情形解析—代数态射对应 | `future_paper`；先限复射影对象，不把一般复解析空间都声称为代数化 |
| 博弈论 | Nash, 1950（`nash-equilibrium-points-1950`） | GT1–GT2、T2；有限策略概率单纯形与不动点 | 最优反应对应、有限博弈混合策略均衡存在及原文有限维边界 | `future_paper`；具体收益矩阵归 Examples E17，不用单个 Mathlib 固定点调用代替对应构造 |
| 代数几何 | Deligne–Mumford, 1969（`deligne-mumford-curves-1969`） | AG1–AG10、HA1–HA5；稳定曲线、代数栈与形变 | 稳定曲线族、DM 栈对角线／光滑覆盖、紧化和不可约性证明链 | `future_paper`；只完成模函子或稳定约化均不等于全文完成 |
| 数理逻辑 | Gödel, 1931（`godel-incompleteness-1931`） | ML1–ML7、ST3；语法编码、递归代入、可证明性谓词 | 对角引理、第一不完备定理、第二不完备定理所需 Hilbert–Bernays 条件 | `future_paper`；一致性、ω-一致性与可靠性假设必须按采用版本区分 |

#### 15.3.4 跨领域复用与优先顺序

1. **近期可启动**：Eckart–Young 与 Banach–Steinhaus 已有大部分课程设施；负责人先提交 theorem
   inventory 和“现有 Entry 不足在哪里”的差分 RFC，避免重复证明已完成课程结论。
2. **中期桥项目**：Nikodym、Neyman–Pearson、Wedderburn 分别暴露符号测度／统计决策／非交换
   除环缺口；这些缺口先回填对应课程批次，再将论文状态提升为 `paper_ready`。
3. **大型长期项目**：Cohen、Green–Tao、Carleson、Smale、Deligne–Lusztig、Deligne–Mumford 和
   Gödel 必须按证明依赖图拆成多个课程级批次；“论文很重要”不构成跳过基础设施的理由。
4. **同源跨学科**：Whitney 同时服务主干拓扑与微分流形，Grothendieck 的不同论文分别服务同调
   代数与广义泛函分析。Registry 为每个实际 theorem 建独立 Entry，但文献键不得重复造别名。

---
