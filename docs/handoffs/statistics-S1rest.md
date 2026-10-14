# statistics / S1rest 窗口 handoff

> 窗口：E6 `docs/dispatch/e6-stats-s1.md`（由 pack 渲染）　角色：`subject-maintainer`
> 本文件自包含；Main 不需要回看过程。

## 1. 现场

| 项 | 值 |
|---|---|
| worktree | `/home/pisquare/czt/sandrones-library-stats-s1` |
| 分支 | `codex/statistics-s1-rest` |
| 基线 | `bc8d4feb59f639aa440d7719466297d918e9dd28` |
| 本批提交 | `2383975`（交付主体）；本 handoff 为后续提交 |
| 同步 Main | 未 rebase：本窗口自 `bc8d4fe` 开出后未收到新的 Main 集成提交；Main 的 pack 更正（`24f9e30`，`Kernel.rnDeriv` → `ProbabilityTheory.Kernel.rnDeriv`）只改窗口定义与 `open_window.py`，不在本 worktree 的交付面上，未强行拉入 |
| 工作区 | 提交后干净（`git status --short` 空） |
| 磁盘 | 未复制 `.lake/build`，只做定向构建；`.lake/packages` 沿用软链 |

## 2. 交付

| Entry id | Lean 文件 | 行数 | 声明数 | 叙述层 |
|---|---|---|---|---|
| `statistics.method-of-moments` | `SandronesLibrary/Statistics/MethodOfMoments.lean` | 216 | 14 | `docs/entries/statistics/method-of-moments.md` |
| `statistics.information.cramer-rao` | `SandronesLibrary/Statistics/CramerRao.lean` | 296 | 16 | `docs/entries/statistics/information/cramer-rao.md` |

两条都是**计划中新条目**，首次交付；未改动任何既有文件，未触碰 `scope.out_of_scope`
（`statistics.testing.*`、`confidence-set`、`regression.*` 全未做，S2 未开门）。

**公理画像**（`#print axioms`，聚合导入下实测）：

```
'SandronesLibrary.Statistics.cramerRao_lower_bound' depends on axioms: [propext, Classical.choice, Quot.sound]
'SandronesLibrary.Statistics.cramerRao_variance_ge' depends on axioms: [propext, Classical.choice, Quot.sound]
'SandronesLibrary.Statistics.cramerRao_variance_ge_inv_of_unbiased' depends on axioms: [propext, Classical.choice, Quot.sound]
'SandronesLibrary.Statistics.methodOfMomentsEstimator_tendstoInMeasure' depends on axioms: [propext, Classical.choice, Quot.sound]
'SandronesLibrary.Statistics.momentMap_measurable' depends on axioms: [propext, Classical.choice, Quot.sound]
'SandronesLibrary.Statistics.modelMeasure_kernelDensity_eq' depends on axioms: [propext, Classical.choice, Quot.sound]
'SandronesLibrary.Statistics.score_integral_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound]
'SandronesLibrary.Statistics.sq_integral_mul_le_integral_sq_mul_integral_sq' depends on axioms: [propext, Classical.choice, Quot.sound]
```

与既有统计条目（`statistics.estimator.consistency`、`statistics.maximum-likelihood`）一致：
只有 `propext`／`Classical.choice`／`Quot.sound`，无 `sorryAx`、无额外公理。
`axioms` 与 `proof_sha` 字段未自行写入 Registry（由 Main 跑 `check_axioms.py --all --fix` 生成）。

## 3. 验证

- **定向构建**（逐模块，非全库）：
  - `lake build SandronesLibrary.Statistics.MethodOfMoments` → `Build completed successfully (2981 jobs)`；
  - `lake build SandronesLibrary.Statistics.CramerRao` → `Build completed successfully (2991 jobs)`；
  - 依赖闭包 `Density`／`BiasVariance`／`Estimator`／`Model` 均先单独构建通过。
  以上只证明学科模块与其依赖闭包，**不是全库通过**。
- **聚合 #check**：`/tmp/sandrones-library/aggregate.lean` 同时 import 两个模块，
  对 12 个公开载体（`momentMap`、`IsMethodOfMomentsEstimator`、`MomentIdentifiable`、
  `MomentEquationWellPosedAt`、`methodOfMomentsEstimator_tendstoInMeasure`、`modelMeasure`、
  `IsRegularDominatedFamily`、`fisherInformation`、`densityMean`、`cramerRao_lower_bound`、
  `cramerRao_variance_ge`、`cramerRao_variance_ge_inv_of_unbiased`）逐个 `#check` 打印精确类型，
  用于冻结公开签名；无错误。
- **占位扫描**：`grep -n "sorry\|admit\|sorryAx\|native_decide"` 两个文件 → 无命中。
- **冲突标记 / 全局 instance**：两个 `.lean` 与两篇叙述层无冲突标记；未新增任何 `instance`
  或 `attribute [instance]`，无全局实例泄漏。
- **Entry↔声明映射**：两个 Lean 文件头部 docstring 各含 `> **Entry**: <id>`；
  id、`lean_file`、`nl_file` 与 Registry 建议一致。
- **`git diff --check`**：干净（提交前实测）。
- **Mathlib 候选实测**：本批要在叙述层与 Registry 登记的 10 个 Mathlib 名逐个 `#check`
  全限定名（探针 `probe4`／`probe5`），只有零错误的才写进 front matter。
  pack 的候选 `Kernel.rnDeriv` 缺命名空间（Main 已通报），真名 `ProbabilityTheory.Kernel.rnDeriv`；
  同轮还发现 `MeasureTheory.withDensity` 不存在（真名 `MeasureTheory.Measure.withDensity`）、
  `integral_withDensity_eq_integral_toReal_smul₀` 在根命名空间。
  两条 pack 都给的候选 `MeasureTheory.integral` 实测通过。

## 4. pack 与 trace

**pack_id 清单（本批 2 个，均由 Main 在开窗时生成，本窗已随分支提交）：**

- `statistics-S1rest-statistics.method-of-moments`
- `statistics-S1rest-statistics.information.cramer-rao`

`python3 scripts/context_pack.py check traces/packs/*.json` → `检查 4 个 pack：通过`
（含仓库既有的 2 个 CA1 pack）。

**trace 路径与记录数：**

| 路径 | 记录数 | accepted | error |
|---|---|---|---|
| `traces/lean/statistics/statistics.method-of-moments.jsonl` | 5 | 2 | 3 |
| `traces/lean/statistics/statistics.information.cramer-rao.jsonl` | 7 | 3 | 4 |

`python3 scripts/lean_trace.py check traces/lean/statistics/` → `检查 2 个文件、12 条记录：通过`
`python3 scripts/lean_trace.py summary --subject statistics` → `2 个任务、12 条尝试；accepted: 5，error: 7`
（失败占 58%；失败尝试全部保留，未做美化。）

**本窗未派子 Agent**，原因：两个 Entry 共用同一套 Mathlib 侦察（`Kernel` 积分可测性、
`withDensity` 积分桥、`MemLp`／`Hölder`）与同一套载体设计，拆分只会重复侦察；而
Cramér–Rao 的**强度判断**（交换性是假设还是可推导定理）是负责人不可外包的核心判断。
按 AGENTS §7 第 9 条，无子 Agent 即无 `--worker` 后缀 pack；本窗 pack 数保持简令所写的 2 个，
不额外生成 pack，避免简令与 pack 数量漂移。全部编译、数学陈述核对、四类扫描均由负责人亲自执行。

## 5. subject_package 原文

见本文件末尾「附录：subject_package 复跑原文」（在本 handoff 提交后复跑抄录）。

## 6. 子 Agent 与负责人审核发现

本窗无子 Agent，故无"退回子 Agent"事项。负责人自查发现并修掉的问题：

1. **`momentMap_measurable` 的类型类代价**：`StronglyMeasurable → Measurable` 需要
   `[MeasurableSpace 𝓨] [BorelSpace 𝓨]`。第一版把它们放进 section variable，导致其余 5 条定理
   各报一条 `unusedSectionVars` 警告；改为内联在该定理语句上，并把 `simpa [momentMap]` 换成
   `change`（`simp` 不展开目标里的 `momentMap`）。
2. **`funext` 打不开常值右端**：`S = momentMap P T θ₀` 这条"退化的精确识别"陈述在 `funext`
   后要求 `momentMap P T θ₀` 是函数，无法类型化；改成有意义的
   `methodOfMomentsEstimator_eq_const_of_sample_moment_eq`（样本矩等于真值矩 ⟹ 估计等于真值）。
3. **交换性假设不能是装饰**：第一版主定理把结论左端直接写成 `∫ x, T x * s θ x * p θ x ∂ν`，
   此时 `hswap` 在证明里完全不被使用——等于"正则条件只是标签"。改为把左端写成
   `deriv (densityMean ν p T) θ`，用 `HasDerivAt.deriv` 让 `hswap` 真正参与证明
   （把 `g'(θ)` 识别为那个积分）。这是本窗最重要的自查修正。
4. **前置条目要真正承重**：初版 `momentMap_const`／`methodOfMomentsEstimator_isMarkov`
   只调 Mathlib，`statistics.model.definition`／`statistics.estimator.definition` 成了装饰性前提。
   改为直接引用 `statisticalModel_measure_univ` 与 `deterministicEstimator_isMarkov`；
   Cramér–Rao 一侧把方差那一步从 Mathlib 的 `variance_eq_integral` 换成
   `statistics.estimator.bias-variance` 的 `squaredError_integral_eq_variance_add_bias_sq`，
   使 `statistics.estimator.bias-variance` 成为真实前提。
5. **`haveI` linter 警告**：`have hμ : IsProbabilityMeasure μ`（类类型的 `have` 同样参与实例搜索）
   替代 `haveI`，消除 `linter.style.haveILetI`；并用对照实验（删掉该行 → `IsFiniteMeasure`
   综合失败）证明它不是冗余。

## 7. 诚实边界

**矩估计（`statistics.method-of-moments`）**

- **一致性是转移而非证明**：`methodOfMomentsEstimator_tendstoInMeasure` 把大数定律一侧
  （样本矩依概率收敛）与矩方程适定性都作为**显式假设**，只做"矩收敛 ⟹ 参数收敛"的拓扑转移。
  本条目**不证明大数定律**，也**不构造样本矩** `S n`（无经验测度、无 `(1/n)∑ T(Xᵢ)`）。
- **适定性是假设**：`MomentEquationWellPosedAt`（矩映射的逆在 `θ₀` 连续，`edist` 的 ε-δ 形式）
  未从"参数空间紧 + 矩映射连续 + 单射"推导。教材证明这一步不在本条目内，属登记在案的未完成边界。
- **矩存在性只能逐条显式**：Bochner 积分对不可积函数返回 `0`，故没有 `Integrable T (P θ)`
  时 `momentMap P T θ` 不承载矩语义；本条目在所有需要处显式假设，不从 `IsMarkovKernel` 推导。
- 不涉及渐近正态性、有效性、`k` 个矩的选择问题；`𝓨` 取任意实赋范空间，故 `ℝ^k` 已可表达，
  但"用哪 `k` 个矩"未决定。

**Cramér–Rao（`statistics.information.cramer-rao`）**

- **强度登记为 foundation／bridge，不是教材定理已完成**：`IsRegularDominatedFamily.deriv_integral_swap`
  与主定理的 `hswap` 就是"微分与积分可交换"本身。本条目**不**引用 Mathlib 的
  `hasDerivAt_integral_of_dominated_loc_of_deriv_le` 之类的强定理，也**不**从课程级充分条件
  （支撑集不随 `θ` 变 + 逐点可微 + 可积控制函数）推导它。要把它变成可推导定理，需要一条独立桥，
  本条目未做。
- **得分函数是输入**：`s` 由模型显式给出，本条目不证明 `s = ∂_θ log p_θ` 的链式法则关系。
- **密度桥只对齐测度**：`modelMeasure_kernelDensity_eq` 说明 `statistics.model.density` 的
  `ℝ≥0∞` 值 kernel 密度取实值后重建同一模型测度；**未**证明 `IsRegularDominatedFamily` 的
  可积性与归一化字段对 kernel 密度成立（需要 `∫⁻` 到 `∫` 的额外换算）。
- 不证明 Fisher 信息与支配测度选择无关，不给出多参数 Fisher 信息矩阵、渐近有效性与
  下界可达性；`deriv` 在不可微点约定取 `0`，结论只在 `hswap` 成立处有意义。

## 8. 共享更新建议（只建议，不代改）

**(a) `SandronesLibrary.lean`（Main 共享文件，本窗只读）**：请追加两行

```lean
import SandronesLibrary.Statistics.MethodOfMoments
import SandronesLibrary.Statistics.CramerRao
```

本窗已在 `/tmp` 用聚合导入验证两条模块可以联合 import 且无循环、无重名。

**(b) `index/registry.json` 新增两条（语义字段由 Main 复核后合并）**：

```json
{
  "id": "statistics.method-of-moments",
  "kind": "definition",
  "state": "verified",
  "title": "矩估计",
  "summary": "以总体矩映射的配平等式定义矩估计，显式列出模型族可测性、矩存在性、识别性与矩方程适定性，并给出相合性的拓扑转移",
  "premises": ["statistics.model.definition", "statistics.estimator.definition"],
  "mathlib": [
    "MeasureTheory.integral",
    "MeasureTheory.Integrable",
    "MeasureTheory.StronglyMeasurable.integral_kernel",
    "MeasureTheory.TendstoInMeasure",
    "ProbabilityTheory.Kernel.deterministic"
  ],
  "provenance": { "source_type": "book", "ref": "schervish-theory-statistics-1995" },
  "lean_file": "Statistics/MethodOfMoments.lean",
  "nl_file": "docs/entries/statistics/method-of-moments.md",
  "family": "statistics.estimator",
  "variant": "textbook"
}
```

```json
{
  "id": "statistics.information.cramer-rao",
  "kind": "theorem",
  "state": "verified",
  "title": "Fisher 信息与 Cramér–Rao 下界",
  "summary": "以支配测度上的实值密度族承载模型测度与 Fisher 信息，把微分与积分可交换写成显式正则条件，并证明 Cramér–Rao 下界及其教材形式与无偏形式",
  "premises": ["statistics.model.density", "statistics.estimator.bias-variance"],
  "mathlib": [
    "ProbabilityTheory.Kernel.rnDeriv",
    "MeasureTheory.integral",
    "MeasureTheory.Measure.withDensity",
    "MeasureTheory.integral_mul_norm_le_Lp_mul_Lq",
    "ProbabilityTheory.variance"
  ],
  "provenance": { "source_type": "book", "ref": "schervish-theory-statistics-1995" },
  "lean_file": "Statistics/CramerRao.lean",
  "nl_file": "docs/entries/statistics/information/cramer-rao.md",
  "family": "statistics.information",
  "variant": "textbook"
}
```

`axioms`、`proof_sha`、`added_by`、`added_at`、`dependedOnBy` 未填，交由
`check_axioms.py --all --fix` 与 `update_dependency_graph.py` 生成。
新增家族 `statistics.information` 只出现在这两条的 `family` 字段，`gen_entries_index.py`
按 entry-id 前缀分组，不受影响。

**(c) `docs/ROADMAP-LONGTERM.md` §10 S1 批次表**：第 6 行（矩估计）与第 8 行（Fisher 信息与
Cramér–Rao）可标 ✅，但**建议保留诚实边界注记**：Cramér–Rao 的交换性是显式假设
（foundation／bridge），矩估计的相合性是转移而非大数定律证明。S2 依赖门不变（🔒）。

**(d) 文献**：沿用既有 `schervish-theory-statistics-1995`，不需要新 BibTeX 条目。

## 9. 协议反馈

1. **pack 的 Mathlib 候选仍是未验证提示，且确实会错**：本窗 `Kernel.rnDeriv` 缺命名空间
   （Main 已修）；我另实测出 `MeasureTheory.withDensity` 与
   `MeasureTheory.integral_withDensity_eq_integral_toReal_smul₀` 也是同型错误
   （真名分别是 `MeasureTheory.Measure.withDensity` 与根命名空间的
   `integral_withDensity_eq_integral_toReal_smul₀`）。建议 `open_window.py` 的 `#check` 门禁
   不仅覆盖 pack 候选，也覆盖负责人后来要写进 front matter 的名字——本窗是靠人工探针兜住的。
2. **pack 的 `frozen` 块对新条目为空**，符合"新文件从零开始"；但本窗的实际冻结动作发生在
   实现过程中（签名随证明调整了 3 次，见 §6 第 1、3 条）。pack 里没有"实现期签名漂移"的
   记录位；我用 trace 的 `narration`／`next_step` 承载，建议 §9.3 的字段表补一个可选
   `signature_revisions` 指针位。
3. **`subject_package.py` 的 cleanliness 门与 handoff 的引用存在先后依赖**：handoff 必须提交后
   才能跑出 `verdict=pass`，而 handoff 又要抄录包原文。本窗的做法是先提交交付主体、跑包、
   再把原文抄进 handoff 并复跑。建议协议明确这一顺序（或允许 handoff 单独作为第二次提交）。
4. **trace schema 对"文档/名实核对轮"表达力不足**：front matter 的 Mathlib 名实测是真实的
   验证尝试（本轮就抓出两个错名），但 `goal` 字段要求写 Lean 探针命令，`outcome` 只能取
   accepted／error。本窗按侦察轮约定处理（探针命令 + `error`／`accepted`），可用但略勉强。
5. **软门 `traces` 的计数口径**：包显示"本批含 39 条验证尝试记录"，而本窗实际只写 12 条，
   差额是仓库既有的 CA1 轨迹（27 条）随基线一起被计入。建议按 `pack_id` 前缀过滤，
   否则"本批"数字会随基线携带的历史轨迹膨胀。

## 附录：subject_package 复跑原文

命令：

```bash
python3 scripts/subject_package.py --worktree /home/pisquare/czt/sandrones-library-stats-s1 \
    --base bc8d4fe --subject statistics
```

在提交 `50ab3d0`（交付主体 + 本 handoff，工作区干净）上的**原文**：

```text
学科验收包 statistics  (codex/statistics-s1-rest @ 50ab3d02d)
  基线 bc8d4fe｜提交 2｜改动文件 9
  ✅ cleanliness
  ✅ ownership
  ✅ semantics
  ✅ proof
  ✅ coverage
  ✅ traces（软门）：本批含 39 条验证尝试记录
  ✅ packs（软门）：pack 与 trace 的 pack_id 已配对，trace.path 指针正确

  verdict: pass
```

按 AGENTS §7 第 7 条要求逐字抄录的两行：

```text
  ✅ traces（软门）：本批含 39 条验证尝试记录
  ✅ packs（软门）：pack 与 trace 的 pack_id 已配对，trace.path 指针正确
```

异常清单：空。`verdict = pass`。
（追加本附录后提交数变为 3、改动文件变为 10，这两项是包头部对"相对基线的提交/文件计数"，
不改变任何门的结论；除本附录外，被审的树与上表完全一致。）
