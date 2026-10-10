# Banach–Steinhaus (1927)：两个核心定理的 Lean 复现

## 开工冻结（2026-10-10）

- 基线：Main `b2cd090c9208283ccd3c2f3740bcece3e3f0d6ea`。
- 数学实现、教材文档与完整验收包提交：`0e8706f`；后续计量提交仅补充 token 截止记录。
- 独立 worktree：`/home/pisquare/czt/sandrones-library-condensation`；分支
  `codex/functional-analysis-paper-condensation`。
- 来源：Banach and Steinhaus, *Sur le principe de la condensation de singularités*,
  Fundamenta Mathematicae 9 (1927), 50–61；现有文献键
  `banach-steinhaus-condensation-1927`。
- 一手扫描：[Banach Œuvres II 重印](https://kielich.amu.edu.pl/Stefan_Banach/pdf/oeuvres2/366.pdf)。
  [库内 PDF](functional-analysis-paper-condensation/banach-steinhaus-1927.pdf) 保留下载扫描件的原始字节，共 10 页。
  重印 p. 366 是定义，pp. 367–368 是辅助引理，p. 369 是 §2 定理 I 与 II；
  p. 370 起是 §3 正交级数应用。
- 最终完成 §2 定理 I 与 II：每行各有无界点时存在公共无界点；每行各有非 Cauchy 点时
  存在公共非 Cauchy 点。补充公共点集的稠密性、定理 I 的 Gδ 性、算子范数版本和极限版本。
- 标量是实数；定义域是 Banach 空间。值域允许按行变化 `F : ℕ → Type*`，
  每行内部固定。定理 I 和定理 II 的 Cauchy 版本不要求值域完备；极限版本要求各值域完备。
- 采用原文的 Baire／线性缩放机制，以稠密开集交给出现代等价证明。
- 后续批次：§3 的正交级数应用。

## 文件所有权

新增 `SandronesLibrary/FunctionalAnalysis/Condensation.lean`、
`SandronesLibrary/FunctionalAnalysis/CondensationDivergence.lean`、
两篇对应 Entry 教材文档、本 handoff 及同名证据目录。
单实例串行执行任务冻结、实现和检查；依赖定义先验收，再组装大定理。
Main 共享文件只在本文件中提供更新建议。

## 六个公开接口与验收约定

1. `unbounded_on_tail_of_unbounded`：去掉有限前缀后仍能超过任意实数阈值。
2. `isOpen_norm_exceeds_set`：某个算子输出超过给定阈值的点组成开集。
3. `dense_norm_exceeds_set_of_unbounded`：一行在某点无界，则上述开集稠密。
4. `condensation_dense_Gδ`：所有行均无界的点组成稠密 Gδ 集。
5. `condensation_exists`：存在同一点，各行在每个尾段超过每个阈值。
6. `condensation_of_unbounded_operatorNorm`：各行算子范数无界时有上述公共点。

验收命令为模块及其依赖闭包的 Lake 构建、聚合 Lean 接口与公理查询、
Entry 声明映射、禁用占位及共享文件扫描、`git diff --check`。
正式源码中所有证明由 Lean 内核检查，不使用待证占位。
token 以本次用户请求前后会话日志的累计计数之差计量，缓存输入单列。

## 概念和接口冻结

| 概念 | 教材语义／量词 | Lean 承载与展开 | 复用分类 | 首个使用者 |
|---|---|---|---|---|
| 连续线性算子 | 实线性且连续 | `E →L[ℝ] F`，`map_add`、`map_smul`、`continuous` | 正式承载，既有 F1 接口 | 开集与稠密性 |
| Banach 空间 | 完备赋范实线性空间 | `[NormedLinearSpace ℝ E] [BanachSpace E]`，既有别名承载 | 正式承载 | 公共奇点稠密性 |
| 行输出无界 | `∀ C : ℝ, ∃ q, C < ‖g p q x‖` | 直接量词，不另造谓词 | 教材展开 | 局部稠密性 |
| `limsup = ∞` | 任意阈值、任意尾段均有超过阈值的项 | `∀ C N, ∃ q, N ≤ q ∧ C < ‖g p q x‖` | 教材展开；有限前缀引理连接 | 公共点存在 |
| 稠密集合 | 每个非空开球均与它相交 | `Dense`，`Metric.dense_iff` | 正式承载 | Baire 组装 |
| Gδ 集 | 可数个开集的交 | `IsGδ`，`IsGδ.iInter_of_isOpen` | 正式承载 | 公共奇点结论 |
| 算子范数无界 | `∀ C, ∃ q, C < ‖g p q‖` | `ContinuousLinearMap` 的范数 | 既有正式承载 | 算子范数版本 |

Entry `functional-analysis.condensation` 归属这六个声明及唯一 Lean 文件。
Mathlib 的计数交、度量球、有限和和有序域算术是证明后端；核心公开概念均有表中教材解释。
无新增全局 instance，无特殊定义桥，无越级公开对象。

## 实际验收记录

- 学科验收：通过；Main 的 Registry／顶层 import 集成由 Main 审核后完成。
- 单独构建两个新模块均成功；联合模块与传递依赖闭包构建成功，Lake 报告 8713 jobs
  （包括缓存依赖），并非全库 root 构建。两个新模块没有新增 linter warning，
  构建只重放 `Topology/Metric.lean` 与 `FunctionalAnalysis/Baire.lean` 的既有警告。
- `Verify.lean` 联合导入两模块，检查正式承载、关键刻画和全部 12 个公开声明。
- 线性增长算子验证定理 I；统一范数界为 1 的交替符号算子验证定理 II 的有界振荡分支和
  极限版本。两种验证均为 Lean 定理，不依赖浮点实验。
- `map_entry_to_decl` 检出两个 Entry，各恰好六个公开声明，private 子空间不单独漏报：
  它的公理由调用者继承并审计。
- 全部 12 个声明的公理只包含 `propext`、`Classical.choice`、`Quot.sound`；
  新源码无禁用占位、无 `native_decide`、无新增全局 instance。
- `verify.py` 将模块构建、定义链与例子、公理和文件身份检查串成一条可重复运行的命令；
  结果保存在同名证据目录的 `validation.json` 与三个验证日志中。
- 证明施工中修复的接口问题：docstring 与 `omit ... in` 的位置；Cauchy 点集合的显式展开；
  点态函数加法／复合用 `ext` 证明函数相等后再改写。数学目标和强度没有因这些修复而改变。
- token 计量取本次用户请求前后的实际会话累计计数之差；缓存属于输入子集，推理输出属于
  输出子集，均不重复加总。具体截止时间和数字见 `token-usage.json`。

## 第二批冻结：原论文定理 II

定理 I 的六个临时证明已于本窗口通过 Lean 聚合检查。接着增加独立文件
`CondensationDivergence.lean` 和 Entry `functional-analysis.condensation.divergence`，
实现原论文 §2 定理 II，采用 pp. 368–369 的两分支证明。最终各行值域可不同。

1. 算子范数统一有界时，Cauchy 点集是闭集（对应引理 4 的延拓机制）。
2. 这一闭集是真子空间时，其补集开且稠密。
3. 算子范数无界时，由第一批定理取得稠密 Gδ 无界点集；它包含于非 Cauchy 点集。
4. 每行非 Cauchy 点集包含一个稠密 Gδ 集，再用 Baire 取得公共非 Cauchy 点。
5. 给出存在性接口；值域完备时给出“不存在极限”的教材接口。

公开声明总数目标 3–6。`CauchySeq` 按 `Metric.cauchySeq_iff` 展开为双尾距离小于
任意正数；`Tendsto` 按值域中的极限展开。值域完备只用于不收敛与非 Cauchy 的等价转写。
私有 Cauchy 点子空间以 `Submodule` 承载，解释为 Cauchy 性在加法和实数倍下保持；
它仅用于证明后端，不成为新增公开对象。最终范围扩展为 §2 两个核心定理，§3 应用另属后续批次。

## 第二批概念及公开签名审阅

| 概念 | 教材／Lean 对照 | 四类归属 | 展开与真实使用者 |
|---|---|---|---|
| Cauchy 列 | 双尾距离最终小于任意 `ε > 0`；`CauchySeq` | 语义一致的正式承载 | `Metric.cauchySeq_iff` → 闭点集 → 公共非 Cauchy 点 |
| 序列极限 | `Tendsto (fun q => g p q x) atTop (𝓝 y)` | 语义一致的正式承载 | `cauchySeq_tendsto_of_complete`／`Tendsto.cauchySeq` → 极限版定理 II |
| 稠密 Gδ 支架 | 非 Cauchy 集合内含可数开集交的稠密子集 | 语义一致的正式承载 | `exists_dense_Gδ_nonCauchy_points` → 公共稠密性 |
| Cauchy 点子空间 | 加法、实数倍保持 Cauchy 性 | 私有证明后端 | `cauchyPointsSubmodule` → 真子空间无内部 → 开稠密坏点集 |
| 每行不同值域 | 固定行内比较，行间不比较输出 | 普通依赖类型，不另造数学结构 | `g : ∀ p, ℕ → E →L[ℝ] F p` → 两个论文主定理 |

没有特殊定义桥，没有越级公开泄漏。定理 II 的整个公共非 Cauchy 集只声称稠密；
Gδ 性只赋予证明实际选出的子集。

## Main 更新建议

1. 顶层聚合增加两个模块的 import。
2. 两个拟登记 Entry 的精确元数据见证据目录 `registry-proposal.json`。
   一手来源键已有，无需新增文献。`proof_sha`、反向依赖和索引由 Main 工具生成。
3. ROADMAP §15.3 的 Banach–Steinhaus 候选记录 §2 两个核心定理已交付 staging，
   §3 应用保持后续范围；本窗口不刷新 Main 快照。
4. Main 集成后按仓库生成器、公理、audit、diff 和全库构建顺序审核。

## 可重复运行

在本 worktree 执行：

```bash
python3 docs/handoffs/functional-analysis-paper-condensation/verify.py
```

Lean 4.33.0 与现有 `lake-manifest.json` 冻结依赖。该 worktree 的 `.lake/build` 独立，
`.lake/packages` 只复用 Main 已构建依赖缓存，本窗口没有运行依赖更新。
在新机器按 Lake 常规流程准备同版本依赖即可执行上述命令。
人类阅读入口为同名目录的 `README.md` 与两个 Entry 文档。
