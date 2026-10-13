# 统计推断 Wave R1 — S1 最大似然批次 handoff

- **学科**：统计推断（Phase 9，S1 参数估计）
- **分支**：`codex/statistics-wave-r1`
- **worktree**：`/home/pisquare/czt/sandrones-library-statistics-r1`
- **基线**：`7dffe37`（本分支由该 commit 净新开工；未 `lake update`，未 `lake exe cache get`）
- **交付提交**：
  - `6b4eac7` — `feat(statistics): likelihood and maximum likelihood estimator (S1 maximum-likelihood)`（源码）
  - `23e68f0` — `docs(statistics): entry draft for statistics.maximum-likelihood`（叙述层）
  - `9f9efd0` — `docs(statistics): wave-r1 handoff for S1 maximum-likelihood batch`（本文件）
  - `e612b94` — `fix(statistics): tighten log-likelihood prose and mathlib name list`（对数的严格单调边界、front-matter mathlib 实名）
  - `2027675` — `docs(statistics): record wave-r1 commit list in handoff`
  - `6128554` — `fix(statistics): document domination boundary and tighten audit-flagged docstrings`（审计返工：支配性边界、接口桥定性、删除冗余假设）
- **权限判定**：ROADMAP §Wave R 将 R-statistics 列为 S1🚧（S2🔒）可并行窗口；D-0 第 1–2 项
  （含 `statistics.sufficiency.definition`）已集成；似然/密度所需的 RN 接口
  `real-analysis.measure-derivative.radon-nikodym` 已集成，故 S1 第 7 条
  `statistics.maximum-likelihood` 的依赖已满足。第 8 条 Cramér–Rao 继续冻结，第 6 条矩估计
  仅有 `probability.moments.variance` 一层矩接口，未纳入本批（见"未完成边界"）。

## 精确文件清单

| 文件 | 角色 |
|---|---|
| `SandronesLibrary/Statistics/MaximumLikelihood.lean` | 本批唯一新增源码模块（15 个公开声明） |
| `docs/entries/statistics/maximum-likelihood.md` | Entry 叙述层（id→路径规范：`statistics.maximum-likelihood` → `docs/entries/statistics/maximum-likelihood.md`） |
| `docs/handoffs/statistics-wave-r1.md` | 本文件 |

未触碰任何 Main 共享文件（`SandronesLibrary.lean`、`index/registry.json`、`index/rankings.json`、
`reference.bib`、`docs/ROADMAP-*.md`、`docs/MATHLIB-RADAR.md`、`docs/entries/README.md`、
`docs/entries/RANKINGS.md`、`scripts/**`、`README.md`、`AGENTS.md`）。

## 顶层 import / Registry / ROADMAP / RADAR / Playbook 更新建议（Main 集成用）

- **顶层 import**：`SandronesLibrary.lean` 建议新增 `import SandronesLibrary.Statistics.MaximumLikelihood`
  （该模块已 import `SandronesLibrary.Statistics.Density`）。
- **Registry 建议条目**（Main 生成器补 `axioms`/`proof_sha`/`dependedOnBy`）：
  - `id`: `statistics.maximum-likelihood`
  - `lean_file`: `Statistics/MaximumLikelihood.lean`
  - `premises`: `statistics.model.density`、`statistics.estimator.definition`
  - `mathlib`: `ProbabilityTheory.Kernel.rnDeriv`、`ProbabilityTheory.Kernel.measurable_rnDeriv`、
    `Mathlib.Order.Filter.IsMaxOn`、`Mathlib.Order.Monotone.StrictMono`、`Set.exists_max_image`、
    `ProbabilityTheory.Kernel.deterministic`
  - `provenance.ref`: `schervish-theory-statistics-1995`（Schervish, *Theory of Statistics* 第 7 章）
  - `axioms`（文件内 `#print axioms` 实测，三处代表声明均为）：`propext`、`Classical.choice`、
    `Quot.sound`。`Classical.choice` 来自 `ℝ≥0∞`/测度结构底线与有限 argmax 的 `Classical.choose`。
- **ROADMAP 建议**：S1 表第 7 行 `statistics.maximum-likelihood` 由（无标记）改为 ✅，说明
  "似然函数（复用联合可测 RN 密度）与几乎处处 argmax 的 MLE 定义、订单/换元性质、有限参数可测
  存在性"；S1 剩余第 6、8 行维持未完成。主教材仍为 Schervish。
- **MATHLIB-RADAR 建议**：收录 `IsMaxOn` 作为本库"整个参数空间极大值点"的正式承载，标注
  "首个消费者 `statistics.maximum-likelihood`"；`Kernel.rnDeriv` 已在密度条目登记，本批只新增
  函数层消费者 `likelihood`。
- **Playbook 教训建议**：argmax/MLE 类条目应复用 Mathlib `IsMaxOn`，并把"密度仅 a.e. 唯一"
  写进定义量词，而不是在事后补正则性；`Kernel.rnDeriv` 及由它构造的函数层名字都要求
  `MeasurableSpace.CountableOrCountablyGenerated`。

## 概念清单（教材语义 → 正式承载 → 展开/一手性质 → Mathlib 角色 → 首个使用者 → Entry）

| 概念 | 教材定义 / 语义 | Lean 正式承载 | 展开 / 一手性质 | Mathlib 复用说明或桥 | 首个使用者 | 源码 Entry |
|---|---|---|---|---|---|---|
| 似然函数 | 观测 `x` 固定时 `θ ↦ dP_θ/dν(x)` | 本库 `likelihood P ν : Θ → 𝓧 → ℝ≥0∞`（对 `Kernel.rnDeriv` 的函数层命名） | `rfl` 展开到 `P.rnDeriv (Kernel.const Θ ν) θ x`；`likelihood_jointlyMeasurable`、`likelihood_lintegral_eq_one`、`withDensity_likelihood_eq` | `Kernel.rnDeriv`/`measurable_rnDeriv` 为语义一致正式承载（密度条目引入）；`likelihood` 是函数层名字而非第二套密度 | `IsMaximumLikelihoodEstimator`、`isMaximumLikelihoodEstimator_iff` | `statistics.maximum-likelihood` |
| 最大似然估计 | 几乎处处最大化似然的（确定性）估计量 | 本库 `IsMaximumLikelihoodEstimator P ν θhat : Prop` | `isMaximumLikelihoodEstimator_iff` 逐字展开为 `Measurable ∧ ∀ᵐ x, ∀ θ, L θ x ≤ L (θhat x) x` | `IsMaxOn f Set.univ` 为语义一致正式承载（第 1 类，非自建 argmax） | `maximumLikelihoodEstimator_isMarkov`、`maximumLikelihoodEstimator_likelihood_eq_ae` | `statistics.maximum-likelihood` |
| 估计量身份 | 估计量是样本的可测映射 | `Kernel.deterministic θhat h` + `IsMarkovKernel` | `maximumLikelihoodEstimator_isMarkov` | `Kernel.deterministic` 为 `statistics.estimator.definition` 已解释的正式承载 | 同上 | `statistics.maximum-likelihood` |
| 严格单调变换保持 argmax（对数似然） | 最大化似然 ⟺ 最大化其严格单调函数 | `isMaxOn_univ_comp_strictMono_iff` | `StrictMono.le_iff_le` 给出的双向 | `StrictMono` 为 Mathlib 正式订单概念（语义一致） | 文档中的对数似然讨论 | `statistics.maximum-likelihood` |
| 换参数不变性 | 双射换参数下 MLE 按逆像对应 | `isMaxOn_univ_comp_equiv_iff` + `maximumLikelihoodEstimator_reparametrize` | `e.surjective` 给出的极大值可迁性；`MeasurableEquiv` 传递可测性 | 订单层自建桥；不引入未冻结的参数 comap kernel 载体 | `maximumLikelihoodEstimator_reparametrize` | `statistics.maximum-likelihood` |
| 有限参数可测 MLE 存在 | 有限参数、离散样本上 MLE 存在且可测 | `exists_maxOn_likelihood_of_finite`、`maximumLikelihoodMapOfFinite`、`maximumLikelihoodEstimator_of_finite` | `Set.exists_max_image` + `Classical.choose` + `measurable_of_countable` | `Set.exists_max_image`、`measurable_of_countable` 为证明后端/正式引理 | `maximumLikelihoodEstimator_of_finite` | `statistics.maximum-likelihood` |

## 公开签名扫描（Mathlib 专用名四类归属）

1. **语义一致的正式公开承载**：`ProbabilityTheory.Kernel.rnDeriv`、`Kernel.measurable_rnDeriv`
   （密度条目已解释）、`Mathlib.Order.Filter.IsMaxOn`（逐字对应全参数空间极大值点）、
   `ProbabilityTheory.Kernel.deterministic`（估计量身份，估计量条目已解释）、
   `Mathlib.Order.Monotone.StrictMono`（严格单调变换）。
2. **本库特殊定义的桥侧接口**：`isMaxOn_univ_comp_strictMono_iff`、`isMaxOn_univ_comp_equiv_iff`
   （订单层一般引理，非统计专有，公开供换元使用）；`maximumLikelihoodEstimator_reparametrize`
   的右端以"换元后的似然函数"而非重参数化 kernel 表述，是对尚未冻结的参数 comap 载体的显式边界桥。
3. **私有证明后端**：`Set.exists_max_image`、`measurable_of_countable`、`Set.finite_univ`、
   `Finset.exists_max_image`（仅在有限存在性证明中出现，不进入核心公开签名）。
4. **超出课程层级的公开泄漏**：无。

## 验证证据（已实际运行）

- 逐模块编译：`lake build SandronesLibrary.Statistics.MaximumLikelihood` →
  `Build completed successfully (2939 jobs)`，无 warning。
- 依赖闭包：本批模块的闭包含 `Statistics.Model/Density/Estimator`，随同一次定向构建通过；
  本批**未运行全库 `lake build`**（按 AGENTS §7 学科负责人不做全库构建）。
- 聚合 `#check`（`/tmp/sandrones-library/agg_mle.lean`，同时 import `MaximumLikelihood` 与
  `Sufficiency`）：正式承载 `likelihood`、`IsMaximumLikelihoodEstimator`，展开
  `isMaximumLikelihoodEstimator_iff`，一手性质 `likelihood_jointlyMeasurable`、
  `likelihood_lintegral_eq_one`，桥 `isMaxOn_univ_comp_strictMono_iff`、
  `isMaxOn_univ_comp_equiv_iff`、`maximumLikelihoodEstimator_reparametrize`、
  `withDensity_likelihood_eq`，上层使用者 `maximumLikelihoodEstimator_isMarkov`、
  `maximumLikelihoodEstimator_likelihood_eq_ae`、`isMaximumLikelihoodEstimator_of_const_likelihood`、
  `exists_maxOn_likelihood_of_finite`、`maximumLikelihoodMapOfFinite`、
  `maximumLikelihoodEstimator_of_finite` 全部 `#check` 通过。
- Entry 声明映射：`scripts.check_axioms.map_entry_to_decl` 把 15 个公开声明全部归到
  `statistics.maximum-likelihood`（清单见上文"精确文件清单"与概念表），一个 id 仅一个 Lean 文件。
- 公理审计：`#print axioms` 三个代表声明均为 `[propext, Classical.choice, Quot.sound]`；无
  `sorry`/`admit`/`sorryAx`/`native_decide`。
- 学科验收包：`python3 scripts/subject_package.py --worktree /home/pisquare/czt/sandrones-library-statistics-r1
  --base 7dffe37 --subject statistics`，在含本 handoff 的提交上 verdict 记录于下方"自检结果"。
- `git diff --check`：干净（见自检 cleanliness 门）。

## 子 Agent 所有权与负责人退回

- 本批源码与叙述层由学科负责人亲自完成；另派两个**只读**审计子 Agent（权限不重叠、不改
  index/`.lake/build`）：
  - 契约/编译审计：复核模块编译、id→路径规范、front-matter 与 `#check`、`subject_package` 输出。
  - 数学语义审计：复核 `IsMaximumLikelihoodEstimator` 的忠实性与非空性、各定理强度、
    `likelihood` 是否装饰别名、边界声明是否过度。
- 子 Agent 报告见"审计结论"一节；其"完成"不构成验收，负责人逐条复核后收敛到本分支单一提交。

## 审计结论（负责人复核）

两个只读审计子 Agent 的报告已由负责人逐条复核。**无数学错误、无虚假证明**；缺陷集中在
"包装定理的新内容"与"定义边界披露"，处理如下：

| 编号 | 来源 | 问题 | 负责人处理 |
|---|---|---|---|
| A-F1 | 契约审计 | handoff 当时未提交，`cleanliness` 门 fail | `resolved`：handoff 已提交（`9f9efd0`、`2027675`），自检 5/5 门通过 |
| A-F2 | 契约审计 | Entry front-matter `mathlib:` 曾写 `Mathlib.Order.Filter.IsMaxOn` 与 `Mathlib.Order.Monotone.StrictMono`，二者既非声明也非模块 | `resolved`（`e612b94`）：改为实名 `IsMaxOn`、`StrictMono.le_iff_le`，并已 `#check` 六项全部通过 |
| B-1 | 数学审计 | `IsMaximumLikelihoodEstimator` 不含支配 `∀θ, P θ ≪ ν`，非支配模型（如 `ν=0`）下恒真 | `resolved`：在 Lean 定义 docstring 与 Entry 增设"支配性边界"段，显式说明该谓词的形式性与退化条件，并要求统计结论另行给出支配假设；不把模型正则性塞进估计量定义 |
| B-2/B-3/B-4 | 数学审计 | `likelihood_jointlyMeasurable`、`likelihood_lintegral_eq_one`、`withDensity_likelihood_eq` 是密度既有事实的改写，本身不增新数学 | `declined with reason`：保留为 `likelihood` 的**联系引理**，并在 Entry 中改称"联系引理（不增加新数学）"，用途是证明 `likelihood` 有真实消费者而非装饰别名；删除会使定义链失去密度语义锚点 |
| B-5 | 数学审计 | `maximumLikelihoodEstimator_isMarkov` 仅用可测性、docstring 过强 | `resolved`：Lean docstring 与 Entry 明确标注它是接口桥、argmax 分量不参与证明、不产生新数学 |
| B-7 | 数学审计 | `Real.log` 非全局 `StrictMono`，题注曾暗示可直接实例化 | `resolved`（`e612b94`）：Lean 与 Entry 均改为"在 `Set.Ioi 0` 上严格单调，是教材原型" |
| B-8 | 数学审计 | `maximumLikelihoodEstimator_of_finite` 的 `[Countable Θ]` 在 `[Finite Θ]` 下冗余；有限存在性 docstring 措辞 | `resolved`：删除 `[Countable Θ]`（由 `[Finite Θ]` 自动合成），docstring 改为"数值函数" |

审计 A 另确认：模块 `lake env lean` 零输出、15 个公开声明无禁用占位、id 标记唯一且位于全部声明
之前、id→叙述层路径符合 `subject_package.py:161`、`premises` 均为库内 Entry id、`provenance.ref`
在 `reference.bib:582`。审计 B 另用 `/tmp` 最小实例机器验证谓词非空且可分：`Θ=𝓧=Bool`、
`ν=δ_true+δ_false`、`P=(Kernel.const ν).withDensity(θ,x↦if x=θ then 1 else 0)` 下 `id` 是 MLE
而 `fun x=>!x` 不是。两项结论均与本文件陈述一致。

## 下一批可稳定依赖 / 不可依赖的 API

- **可稳定依赖**：`likelihood`（函数层似然，`Θ → 𝓧 → ℝ≥0∞`）、`IsMaximumLikelihoodEstimator`
  及其展开 `isMaximumLikelihoodEstimator_iff`；有限参数存在性三件套。
- **不要依赖**：重参数化 kernel 载体（本库未冻结，`maximumLikelihoodEstimator_reparametrize`
  只给似然函数层结论）；任意样本空间上的可测选择；MLE 相合性/渐近正态性（未证明）。

## 未完成边界（诚实）

1. 未证明任意样本空间上的**可测选择**（可测 argmax）定理；有限存在性额外要求可数样本空间
   `[Countable 𝓧] [MeasurableSingletonClass 𝓧]`。
2. 未证明 MLE 的相合性、渐近正态性、渐近有效性；未触及 Fisher 信息与 Cramér–Rao
   （S1 第 8 条继续冻结）。
3. 本批**未交付** S1 第 6 条矩估计 `statistics.method-of-moments`：库内矩接口目前仅
   `probability.moments.variance`，一般样本矩/母体矩与 SLLN 消费者尚不足以支撑一条稳健条目；
   留待下一窗口。
4. 未触碰 S2（检验与回归，🔒）。
5. 重参数化不变性只在似然函数层陈述，未接入重参数化 kernel（载体未冻结）。
6. `IsMaximumLikelihoodEstimator` 不含支配字段；非支配模型下逐点 argmax 退化（`ν=0` 恒真），
   统计结论必须另行给出 `∀θ, P θ ≪ ν`。这一边界已写入 Lean docstring 与 Entry，非隐藏假设。
