# 数学分析维护 Handoff：登记完整性（E2 窗口）

- 分支：`codex/analysis-registry-maintenance`
- worktree：`/home/pisquare/czt/sandrones-library-analysis-registry`
- 基线 Main：`52021fe`（Wave E 调度；缺陷复验基线 `c58dd2f`）
- RFC：`docs/maintenance/analysis-registry-integrity.md`
- 权限：维护 🚧；本轮**不改数学陈述、不改公开签名、不删除任何 API、不执行退役**

## 1. 提交列表

| commit | 内容 | 阶段／等级 |
|---|---|---|
| `750be71` | RFC `docs/maintenance/analysis-registry-integrity.md` | 第一份交付 |
| `aad836c` | Entry 元数据修正：11 份文档 bib key、严格 premises、`x-normal-domain`→`normal-domain`、`derivative.definition` 章节定位入正文 | 阶段 1 / M0 |
| `88927b7` | 10 个无标记模块加 `> **Entry**:` 标记 + 新建 `normed-alternating.md` | 阶段 2 / M1 |
| `49cd981` | 两份 complex 文档 `state: partial`→`verified`，对齐 Registry 全 `verified` 约定 | 阶段 1 余项 / M0 |
| 本文件 | handoff | — |

工作树在提交后 `git status --short` 为空；每个提交 `git diff --check` 干净。

## 2. 现场重跑的缺陷验证（最终快照，原文）

判据：源码 `> **Entry**: <id>` 标记集合 ↔ `index/registry.json` 的 `id` 集合双向差集；
同一 id 的跨文件映射；`docs/entries/**/*.md` 的 `id:` 是否都在 Registry。

```text
== A1. source marker id not in registry ==
   analysis.complex.definition | files: ['SandronesLibrary/Analysis/Complex.lean']
   analysis.complex.fundamental-theorem-algebra | files: ['SandronesLibrary/Analysis/FundamentalTheoremAlgebra.lean']
   analysis.derivative.definition | files: ['SandronesLibrary/Analysis/Derivative.lean']
   analysis.multivariable.change-variables | files: ['SandronesLibrary/Analysis/ChangeOfVariables.lean']
   analysis.multivariable.constant-rank-theorem | files: ['SandronesLibrary/Analysis/ConstantRank.lean']
   analysis.multivariable.coordinate-integrals | files: ['SandronesLibrary/Analysis/CoordinateIntegrals.lean']
   analysis.multivariable.jordan-region | files: ['SandronesLibrary/Analysis/JordanRegion.lean']
   analysis.multivariable.jordan-riemann-bridge | files: ['SandronesLibrary/Analysis/JordanRiemannBridge.lean']
   analysis.multivariable.normal-domain | files: ['SandronesLibrary/Analysis/NormalDomain.lean']
   analysis.multivariable.normed-alternating | files: ['SandronesLibrary/Analysis/NormedAlternating.lean']
   analysis.multivariable.rectangle-integral | files: ['SandronesLibrary/Analysis/MultivariableIntegration.lean']
  (count 11)
== A2. registry id without any source marker ==
   linear-algebra.vector-space.dimension   (E1 窗口，本窗口不处理)
   real-analysis.riemann.cont-integrable    (E3 窗口，本窗口不处理)
  (count 2)
== B. id mapped to >1 distinct lean file ==   (E1/E3 窗口，本窗口不处理)
   abstract-algebra.poly.irreducible | Poly.lean + PolynomialIrreducibility.lean
   linear-algebra.matrix.normal      | NormalMatrix.lean + NormalSpectral.lean
== E. docs/entries id not in registry ==
   （分析线 11 条：见 A1，均为本轮新增标记，等 Main 登记）
   linear-algebra.coordinates.change-basis | linear-algebra.eigen.diagonalization
   linear-algebra.eigen.jordan | linear-algebra.vector-space.sum-quotient
   topology.space.closure                   (E1/E3 窗口，本窗口不处理)
  (count 16)
== F. registry id with no doc id ==   （空）
== G. totals ==
registry: 575 source ids: 584 no-marker files: 18 md ids: 591
```

解读：E2 的 1 个缺登记（`analysis.derivative.definition`）+ 10 个无标记模块 + 9 个 orphan
文档已全部处置为“带标记 + 带文档 + 待 Main 登记”。`no-marker files` 由 28 降到 18，减少的
10 个正是本窗口模块；剩余 18 个属 Examples（4）、基础设施（`Basic.lean`、
`Topology/MathlibBridge.lean`）、线代（E1，11）、拓扑（E3，1）。A1 的 11 条是本轮
**新增**的 source-only 记录，正是 Main 需要写入 Registry 的清单。

## 3. M 等级与阶段

| 项 | 等级 | 阶段 |
|---|---|---|
| 11 份 Entry 文档 front matter 修正（bib key、strict premises、id 改名、章节定位入正文） | M0 | 阶段 1（commit `aad836c`、`49cd981`） |
| 10 个模块加文件级 `> **Entry**:` 标记 + 新建 `normed-alternating.md` | M1 | 阶段 2（commit `88927b7`） |

**无 M2/M3 项**：公开签名完全不变，登记前后是同一批声明，不需要 `old_iff_new`；不存在
语义变化，不触发 M2 三阶段与旧接口退役条件。未使用 import（`ConstantRank`←
`MultivariableIntegration`、`MultivariableIntegration`←`JordanRegion`）**留待退役窗口**，
本轮不清理、不删文件。

## 4. `analysis.derivative.definition` 完整 Registry 记录建议

源码标记 `SandronesLibrary/Analysis/Derivative.lean:32`，管辖
`HasDerivativeAtTextbook`（`def`）、`hasDerivativeAtTextbook_iff_hasDerivAt`、
`hasDerivativeAtTextbook_unique`。

```json
{
  "id": "analysis.derivative.definition",
  "kind": "definition",
  "state": "verified",
  "title": "一元导数的差商极限定义",
  "summary": "HasDerivativeAtTextbook 以去心差商极限定义导数值，并与 HasDerivAt 等价",
  "premises": [],
  "mathlib": ["slope_def_field", "hasDerivAt_iff_tendsto_slope", "HasDerivAt"],
  "provenance": { "source_type": "book", "ref": "ecnu-mathematical-analysis-5" },
  "lean_file": "Analysis/Derivative.lean",
  "nl_file": "docs/entries/analysis/derivative/definition.md",
  "family": "analysis.derivative",
  "variant": "ecnu"
}
```

- `ref` 已在 `reference.bib:46` 现场核对为 `ecnu-mathematical-analysis-5`
  （华东师范大学数学科学学院《数学分析》第五版，2019）。
- **`premises` 由文档原值 `[analysis.func-limit.definition]` 改为 `[]`**：`Derivative.lean`
  只 `import Mathlib`，差商极限直接用 `Tendsto`／`𝓝[≠]` 表达，未引用 `Analysis/FuncLimit.lean`；
  Main 已裁决采用严格口径（见 §9）。
- `axioms`／`proof_sha`／`dependedOnBy` 由 Main 的 `check_axioms.py`／
  `update_dependency_graph.py` 生成，本 handoff 不预填。

## 5. 10 个无标记模块：逐个判定与证据

判定原则：禁止按文件名猜；证据 = 声明清单 + 库内导入者计数 + 与已登记条目重复度。
**结论：10 个模块全部内容唯一，无一被取代，本轮零退役申请。**

| 模块 | 判定 | 关键证据 |
|---|---|---|
| `ChangeOfVariables` (76) | 补登记 | `absJacobianWithin`（用 `fderivWithin`，前提弱于教材）被 `CoordinateIntegrals` 真实消费 |
| `Complex` (72) | 补登记 | 12 条教材复数定义与运算；FTA 的概念前置；无文本级消费者，属 Mathlib 薄包装，但不存在替代条目 |
| `ConstantRank` (572) | 补登记，**不是 superseded** | `constant_rank_theorem_rudin_9_32` 是一般秩 `r` 正规形；`full_rank_level_set_normal_form` 只是 `r = dim F` 特例；库内零使用 |
| `CoordinateIntegrals` (509) | 补登记 | 35 条极／柱／球坐标 Jacobian、单射、测度保持与累次积分；被 `Examples` 消费 |
| `FundamentalTheoremAlgebra` (44) | 补登记 | `complex_is_algebraically_closed` 被 `LinearAlgebra/JordanSimilarity.lean:127`、`MatrixSchur.lean:162,348` 真实消费（跨学科） |
| `JordanRegion` (61) | 补登记 | `IsJordanMeasurable`/`JordanEuc` 被 `MultivariableRiemann`、`JordanRiemannBridge`、`NormalDomain`、`ChangeOfVariables` 消费 |
| `JordanRiemannBridge` (100) | 补登记 | 3 条桥引理被 `NormalDomain` 真实消费 |
| `MultivariableIntegration` (61) | 补登记 | `closedRectangle`/`rectangleIntegral` 被 `ParametrizedGeometry`、`SecondKindIntegrals` 真实消费 |
| `NormalDomain` (380) | 补登记 | `xNormalDomain`/`yNormalDomain`/2 条累次积分被 `GreenGaussStokes` 与 `Examples/GreenRegions` 消费 |
| `NormedAlternating` (52) | M1 补登记并披露边界 | `NormalizedAlternatingSpace` 及 to/from 桥被 `DifferentialForms` 消费；公开签名暴露 Mathlib 结构，Main 已裁定为「本库特殊定义的桥」，**不**纳入基础设施白名单 |

`ConstantRank` 声明级对比（判定核心，复核自独立子 Agent）：

```lean
-- Analysis/InverseImplicit.lean:96  (analysis.multivariable.full-rank-theorem)
theorem full_rank_level_set_normal_form {f : E₁ × E₂ → F} {u}
    (hf : ContDiffAt ℝ 1 f u)
    (h₂ : (fderiv ℝ f u ∘L ContinuousLinearMap.inr ℝ E₁ E₂).IsInvertible) :
    ∃ ψ, ψ u.1 = u.2 ∧ ∀ᶠ v in nhds u, (f v = f u ↔ ψ v.1 = v.2)

-- Analysis/ConstantRank.lean:517  (analysis.multivariable.constant-rank-theorem)
theorem constant_rank_theorem_rudin_9_32 {F : Euc n → Euc m} {a}
    (hrank : ∀ x ∈ E, Module.finrank ℝ (fderiv ℝ F x).range = r) ... :
    ∃ e, ... F (e.symm x) = fderiv ℝ F a x + φ(...)
```

`h₂` 强制秩 = 值域维数；`hrank` 允许任意 `r < dim F`。包含关系是
`constant-rank ⊇ full-rank`，反向不成立，故 `ConstantRank` 不是重复实现。

## 6. 9 个 orphan 文档：逐个判定

**全部内容有效，本轮零删除。** 逐条已修正 `provenance.ref` 为 `reference.bib` 已存在键并
按严格口径修正 `premises`：

| 文档（最终 id） | 判定 | ref | 修正后 premises |
|---|---|---|---|
| `analysis.complex.definition` | 补 Registry | `ahlfors-complex-analysis-1979` | `[]` |
| `analysis.complex.fundamental-theorem-algebra` | 补 Registry | `ahlfors-complex-analysis-1979` | `[]` |
| `analysis.multivariable.change-variables` | 补 Registry | `spivak-calculus-manifolds-1965` | `[analysis.multivariable.jordan-region]` |
| `analysis.multivariable.constant-rank-theorem` | 补 Registry | `spivak-calculus-manifolds-1965` | `[]` |
| `analysis.multivariable.coordinate-integrals` | 补 Registry | `spivak-calculus-manifolds-1965` | `[analysis.multivariable.change-variables]` |
| `analysis.multivariable.jordan-region` | 补 Registry | `spivak-calculus-manifolds-1965` | `[]` |
| `analysis.multivariable.jordan-riemann-bridge` | 补 Registry | `spivak-calculus-manifolds-1965` | `[analysis.multivariable.jordan-region, analysis.multivariable.riemann-box]` |
| `analysis.multivariable.normal-domain`（原 `x-normal-domain`） | 改 id 后补 Registry | `spivak-calculus-manifolds-1965` | `[analysis.multivariable.jordan-region, analysis.multivariable.jordan-riemann-bridge, analysis.multivariable.riemann-box, real-analysis.riemann.eq-lebesgue]` |
| `analysis.multivariable.rectangle-integral` | 补 Registry | `spivak-calculus-manifolds-1965` | `[]` |

备注：`constant-rank-theorem.md` 原 ref 为 `Walter Rudin, Principles of Mathematical
Analysis, Theorem 9.32`，`reference.bib` **没有 Rudin 条目**，故替换为同族键
`spivak-calculus-manifolds-1965`（Spivak 的逆／隐／秩定理章节）。`normal-domain.md` 的 id
改名已获 Main 批准。

## 7. 10 个模块的 Registry 记录建议（补充 §4）

| id | kind | lean_file | nl_file | premises | ref |
|---|---|---|---|---|---|
| `analysis.complex.definition` | definition | `Analysis/Complex.lean` | `docs/entries/analysis/complex/definition.md` | `[]` | `ahlfors-complex-analysis-1979` |
| `analysis.complex.fundamental-theorem-algebra` | theorem | `Analysis/FundamentalTheoremAlgebra.lean` | `docs/entries/analysis/complex/fundamental-theorem-algebra.md` | `[]` | `ahlfors-complex-analysis-1979` |
| `analysis.multivariable.rectangle-integral` | theorem | `Analysis/MultivariableIntegration.lean` | `docs/entries/analysis/multivariable/rectangle-integral.md` | `[]` | `spivak-calculus-manifolds-1965` |
| `analysis.multivariable.jordan-region` | definition | `Analysis/JordanRegion.lean` | `docs/entries/analysis/multivariable/jordan-region.md` | `[]` | `spivak-calculus-manifolds-1965` |
| `analysis.multivariable.jordan-riemann-bridge` | theorem | `Analysis/JordanRiemannBridge.lean` | `docs/entries/analysis/multivariable/jordan-riemann-bridge.md` | `[analysis.multivariable.jordan-region, analysis.multivariable.riemann-box]` | `spivak-calculus-manifolds-1965` |
| `analysis.multivariable.normal-domain` | theorem | `Analysis/NormalDomain.lean` | `docs/entries/analysis/multivariable/normal-domain.md` | `[analysis.multivariable.jordan-region, analysis.multivariable.jordan-riemann-bridge, analysis.multivariable.riemann-box, real-analysis.riemann.eq-lebesgue]` | `spivak-calculus-manifolds-1965` |
| `analysis.multivariable.change-variables` | theorem | `Analysis/ChangeOfVariables.lean` | `docs/entries/analysis/multivariable/change-of-variables.md` | `[analysis.multivariable.jordan-region]` | `spivak-calculus-manifolds-1965` |
| `analysis.multivariable.coordinate-integrals` | theorem | `Analysis/CoordinateIntegrals.lean` | `docs/entries/analysis/multivariable/coordinate-integrals.md` | `[analysis.multivariable.change-variables]` | `spivak-calculus-manifolds-1965` |
| `analysis.multivariable.constant-rank-theorem` | theorem | `Analysis/ConstantRank.lean` | `docs/entries/analysis/multivariable/constant-rank-theorem.md` | `[]` | `spivak-calculus-manifolds-1965` |
| `analysis.multivariable.normed-alternating` | definition | `Analysis/NormedAlternating.lean` | `docs/entries/analysis/multivariable/normed-alternating.md` | `[]` | `spivak-calculus-manifolds-1965` |

`state` 一律建议 `verified`（Registry 现有 575 条全为 `verified`；10 个模块与
`Derivative.lean` 均在 `sorry`/`admit`/`sorryAx`/`native_decide` 扫描中为零）。`mathlib`、
`family`、`variant` 与 `axioms`/`proof_sha`/`dependedOnBy` 由 Main 按生成器确定。

## 8. Main 需要更新的共有文件清单

1. **`index/registry.json`**：新增 §4 的 1 条 + §7 的 10 条，共 **11 条** Entry 记录。
2. **既有 Registry 条目的 `premises` 补边**（V1 独立核验发现的真实代码依赖，登记后生效）：
   - `analysis.multivariable.green-gauss-stokes`：现 `[analysis.multivariable.second-kind-integrals]`
     → 增加 `analysis.multivariable.normal-domain`（用 `xNormalDomain`/`yNormalDomain`/累次积分）。
   - `analysis.multivariable.second-kind-integrals`：现 `[analysis.multivariable.differential-forms]`
     → 增加 `analysis.multivariable.rectangle-integral`、`analysis.multivariable.parametrized-curves-surfaces`。
   - `analysis.multivariable.parametrized-curves-surfaces`：现 `[]`
     → 增加 `analysis.multivariable.rectangle-integral`（用 `closedRectangle`/`rectangleIntegral`）。
   - `linear-algebra.decomposition.schur`（`MatrixSchur.lean`）：建议增加跨学科
     `analysis.complex.fundamental-theorem-algebra`（`complex_is_algebraically_closed`，`:162,348`）——
     是否记跨学科 premise 由 Main 决定。
3. **`docs/MATHLIB-RADAR.md`**：id 改名后同步 `:2123`、`:2131` 的
   `analysis.multivariable.x-normal-domain` → `analysis.multivariable.normal-domain`
   （`:2097`/`:2106`/`:2139`/`:2147`/`:2155` 引用的其他 id 不变）。建议补 `analysis.derivative.definition`
   行（`slope_def_field`／`hasDerivAt_iff_tendsto_slope`）、`analysis.complex.*`、
   `analysis.multivariable.constant-rank-theorem`、`analysis.multivariable.normed-alternating`
   的“谁在用”记录。
4. **`docs/ROADMAP-LONGTERM.md`**：Wave E E2 状态；§2 AN-MV“已完成常秩定理”现在有了
   可登记的 `analysis.multivariable.constant-rank-theorem`（此前只有 `full-rank-theorem`）。
5. **`SandronesLibrary.lean`**：**本轮不需要改 import**——10 个模块早已全部被根导入；
   本轮零退役，无 import 需移除。
6. **派生文件**：`docs/entries/README.md`、`index/rankings.json`、`docs/entries/RANKINGS.md`
   按 AGENTS §6 顺序重建。
7. **命名建议（由 Main 定）**：ROADMAP §7 用 `complex-analysis.*` 前缀描述 C0/C0.5，而本轮
   登记沿用文档既有 id `analysis.complex.*`。若要统一前缀，属 Main 的 id 规范化决定，本窗口
   不擅自改名。

## 9. 验证结果

- **单模块编译**：`lake build SandronesLibrary.Analysis.Complex` 通过。
- **依赖闭包构建**：一次 `lake build` 编译 10 个模块 + `Derivative`，`Build completed
  successfully (8732 jobs)`，仅有仓库既有 linter warning，无 error。
- **下游定向构建**：`GreenGaussStokes`、`DifferentialForms`、`ParametrizedGeometry`、
  `SecondKindIntegrals`、`FirstKindIntegrals`、`LinearAlgebra/JordanSimilarity`、
  `LinearAlgebra/MatrixSchur`、`Examples/GreenRegions`、`MultivariableRiemann`
  `Build completed successfully (8753 jobs)`。
- **聚合 `#check`**：临时文件导入 11 个模块并对
  `HasDerivativeAtTextbook`、`hasDerivativeAtTextbook_iff_hasDerivAt`、
  `hasDerivativeAtTextbook_unique`、`Complex.mk`/`mul_conj`、`fundamental_theorem_of_algebra`、
  `complex_is_algebraically_closed`、`absJacobianWithin`、`constant_rank_theorem_rudin_9_32`、
  `polarMap`、`sphericalMap`、`IsJordanMeasurable`、
  `hasRiemannBoxIntegral_indicator_eq_setIntegral_of_aeContinuous`、`closedRectangle`、
  `xNormalDomain`、`yNormalDomain`、`NormalizedAlternatingSpace` 全部 `#check` 成功；
  临时文件已删除。
- **禁用占位扫描**：10 个模块中 `sorry`／`admit`／`sorryAx`／`native_decide` 均为零。
- **id／角色一致性**：11 个新标记各自唯一对应一个 Lean 文件；文档 id 与标记 id 逐条一致；
  `reference.bib` 键 `ecnu-mathematical-analysis-5`、`ahlfors-complex-analysis-1979`、
  `spivak-calculus-manifolds-1965` 均已存在。
- **`git diff --check`**：干净；`git status --short`：空（提交后）。
- **磁盘**：构建前后 `df -h /` 可用空间均约 11G，未触碰 `.lake/packages`。

未运行：全库 `lake build`、`lake update`、`lake exe cache get`、公理审计、`audit.py`、
生成器——均属 Main。

## 10. 子 Agent 清单与退回记录

本窗口派出 **2 个 depth-2 只读子 Agent**，无文件所有权、未写任何文件、未跑 git 写／`lake`：

| 子 Agent | 任务 | 结论 | 处置 |
|---|---|---|---|
| `0fd06df4-ad59-40c2-88af-e898f065f50b` | 10 模块声明级重复度审计；核心是 `ConstantRank` vs `full-rank-theorem` | 证实 `ConstantRank` 是一般常秩、**不是** full-rank 的重复；列出全部真实外部消费者与三个假阳性声明（`Complex.mk`/`ext_iff`/`mk_mul`） | **全部采纳**；`Complex` 由“内容唯一”改标为“Mathlib 薄包装但无替代条目”，登记结论不变 |
| `c36e4d10-10fc-4450-8540-18c891ca6282` | 9 个 orphan 文档 front matter、premises、declaration 存在性、bib key | 逐条给出正确键（complex→ahlfors，multivariable→spivak）、发现原 ref 全是自由文本、建议 `normal-domain` 改名 | **全部采纳**；`constant-rank-theorem` 确认无 Rudin 键 |

**退回记录：无整项退回。** 两处口径修正：① 子 Agent 建议 `Complex` 归 (c) 基础设施，
但 Main 已裁定仅 `Basic.lean`／`Topology/MathlibBridge.lean` 入白名单，故 `Complex` 仍按
M1 登记；② `NormedAlternating` 同样按 M1 登记并在文档披露边界，不视为纯基础设施。子 Agent
的“完成”不是验收：上述结论均由我现场重跑验证（§2 的脚本、§9 的构建与 `#check`）。

## 11. 诚实边界与未完成项

- **未运行全库 `lake build`**；本轮只做学科依赖闭包与受影响下游定向构建。最终全库验收、
  公理审计、`audit.py`、派生文件重建由 Main 在合并后执行。
- **退役未执行**：`ConstantRank`←`MultivariableIntegration`、`MultivariableIntegration`←
  `JordanRegion` 存在未使用的 import；属 ROLE 阶段 C，需零使用计数 + 下游验收 + Main 全库
  build，本轮**不删 import、不提交退役**。
- **premises 口径**：本轮采用 Main 已裁决的严格口径（只记真实库内代码依赖）。若 Main 希望
  对 `analysis.complex.fundamental-theorem-algebra` 保留概念前置
  `analysis.complex.definition`，或对 `analysis.multivariable.*` 保留教材概念链，请回退
  对应文档 `premises` 并同步 Registry。
- **`analysis.complex.*` 与 ROADMAP §7 `complex-analysis.*` 前缀不一致**：本轮保持文档既有
  id，未擅自改名；建议 Main 单开规范化窗口。
- **Static evidence only**：子 Agent 的声明引用计数是文本级核验（含假阳性剔除），最终依赖图
  以 `update_dependency_graph.py` 输出为准。
- `ConstantRank` 是否应真正接线进 `full-rank-theorem` 路线（而非仅登记）属 AN-MV 数学路线
  决定，留给后续窗口。
