# 数学分析登记完整性维护 RFC（E2 窗口）

- 窗口：`docs/ROADMAP-LONGTERM.md` Wave E 的 **E2 数学分析维护**
- 分支／worktree：`codex/analysis-registry-maintenance` / `sandrones-library-analysis-registry`
- 基线 Main：`52021fe`（Wave E 调度提交；`c58dd2f` 为缺陷复验基线）
- 角色：学科维护负责人（`docs/roles/SUBJECT-MAINTENANCE-ROLE.md`），权限 **维护 🚧**
- 本轮性质：**登记完整性修复**，不改数学陈述、不改公开签名、不删除任何 API

本 RFC 先给只读影响图，再动源码。所有源码改动仅为在既有声明上加 `> **Entry**:` 标记、
修正 Entry 文档 front matter；不改任何 `def`/`theorem` 的类型或证明体。

---

## 1. 现场重跑的缺陷验证（原文）

在 worktree 现场用 Python 重算（脚本逻辑：源码 `> **Entry**: <id>` 标记集合 ↔
`index/registry.json` 的 `id` 集合双向差集；同一 id 的跨文件映射；`docs/entries/**/*.md`
的 `id:` 是否都在 Registry）：

```text
== A1. source marker id not in registry ==
   analysis.derivative.definition | files: ['SandronesLibrary/Analysis/Derivative.lean']
  (count 1)
== A2. registry id without any source marker ==
   linear-algebra.vector-space.dimension | lean_file: LinearAlgebra/VectorSpace.lean | state: verified
   real-analysis.riemann.cont-integrable | lean_file: RealAnalysis/Riemann.lean | state: verified
  (count 2)
== B. id mapped to >1 distinct lean file ==
   abstract-algebra.poly.irreducible | files: ['SandronesLibrary/AbstractAlgebra/Poly.lean', 'SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean']
   linear-algebra.matrix.normal | files: ['SandronesLibrary/LinearAlgebra/NormalMatrix.lean', 'SandronesLibrary/LinearAlgebra/NormalSpectral.lean']
== E. docs/entries id not in registry ==
   analysis.complex.definition | files: ['docs/entries/analysis/complex/definition.md']
   analysis.complex.fundamental-theorem-algebra | files: ['docs/entries/analysis/complex/fundamental-theorem-algebra.md']
   analysis.derivative.definition | files: ['docs/entries/analysis/derivative/definition.md']
   analysis.multivariable.change-variables | files: ['docs/entries/analysis/multivariable/change-of-variables.md']
   analysis.multivariable.constant-rank-theorem | files: ['docs/entries/analysis/multivariable/constant-rank-theorem.md']
   analysis.multivariable.coordinate-integrals | files: ['docs/entries/analysis/multivariable/coordinate-integrals.md']
   analysis.multivariable.jordan-region | files: ['docs/entries/analysis/multivariable/jordan-region.md']
   analysis.multivariable.jordan-riemann-bridge | files: ['docs/entries/analysis/multivariable/jordan-riemann-bridge.md']
   analysis.multivariable.rectangle-integral | files: ['docs/entries/analysis/multivariable/rectangle-integral.md']
   analysis.multivariable.x-normal-domain | files: ['docs/entries/analysis/multivariable/normal-domain.md']
   linear-algebra.coordinates.change-basis | files: ['docs/entries/linear-algebra/coordinates/change-basis.md']
   linear-algebra.eigen.diagonalization | files: ['docs/entries/linear-algebra/eigen/diagonalization.md']
   linear-algebra.eigen.jordan | files: ['docs/entries/linear-algebra/eigen/jordan.md']
   linear-algebra.vector-space.sum-quotient | files: ['docs/entries/linear-algebra/vector-space/sum-quotient.md']
   topology.space.closure | files: ['docs/entries/topology/space/closure.md']
  (count 15)
== F. registry id with no doc id ==
== G. totals ==
registry: 575 source ids: 574 no-marker files: 28 md ids: 590
```

结论：D-4 第 4 项 (c)(d) 在基线上**仍然存在**，且 E2 关心的 1 + 10 + 9 项与 ROADMAP 描述一致。
A2 的 `linear-algebra.vector-space.dimension`、`real-analysis.riemann.cont-integrable` 与
B 的两条跨文件 id 属 E1/E3 窗口，本 RFC 不处理。

`no-marker files: 28` 中，属于 E2 的是：

```text
SandronesLibrary/Analysis/ChangeOfVariables.lean
SandronesLibrary/Analysis/Complex.lean
SandronesLibrary/Analysis/ConstantRank.lean
SandronesLibrary/Analysis/CoordinateIntegrals.lean
SandronesLibrary/Analysis/FundamentalTheoremAlgebra.lean
SandronesLibrary/Analysis/JordanRegion.lean
SandronesLibrary/Analysis/JordanRiemannBridge.lean
SandronesLibrary/Analysis/MultivariableIntegration.lean
SandronesLibrary/Analysis/NormalDomain.lean
SandronesLibrary/Analysis/NormedAlternating.lean
```

十个文件**全部被根 `SandronesLibrary.lean` 导入**（`Topology/MathlibBridge.lean` 是唯一
无标记且未被根导入的文件）。即它们参与全库构建，却完全绕过 Entry／公理审计／文档契约。

---

## 2. 只读影响图

### 2.1 文件规模与库内导入者（谁在用）

导入者计数用 `grep -rl "import SandronesLibrary.Analysis.<M>" SandronesLibrary --include=*.lean`
（不含根聚合文件本身）：

| 模块 | 行数 | 库内导入者（除根） | 它们是否真的用到该模块声明 |
|---|---|---|---|
| `ChangeOfVariables` | 76 | `CoordinateIntegrals` | 是：`absJacobianWithin`、`integral_image_eq_integral_absJacobian_mul` |
| `Complex` | 72 | `FundamentalTheoremAlgebra` | 否：FTA 未引用 `mk` 等任何声明（仅继承命名空间） |
| `ConstantRank` | 572 | `MultivariableIntegration` | **否**：`MultivariableIntegration` 未引用任何 ConstantRank 声明 |
| `CoordinateIntegrals` | 509 | `Examples/CoordinateIntegrals` | 否：Examples 只消费球坐标数值结果 |
| `FundamentalTheoremAlgebra` | 44 | `LinearAlgebra/JordanSimilarity`、`LinearAlgebra/MatrixSchur` | 是：`complex_is_algebraically_closed`（跨学科） |
| `JordanRegion` | 61 | `MultivariableRiemann`、`ChangeOfVariables`（经 NormalDomain 链）、`NormalDomain`、`JordanRiemannBridge`（经 MultivariableRiemann 链） | 是：`JordanEuc`、`IsJordanMeasurable` |
| `JordanRiemannBridge` | 100 | `NormalDomain` | 是：`hasRiemannBoxIntegral_indicator_eq_setIntegral_of_aeContinuous`、`jordan_indicator_*` |
| `MultivariableIntegration` | 61 | `ParametrizedGeometry`、`SecondKindIntegrals`、`JordanRegion` | 是：`closedRectangle`、`rectangleIntegral`、`rectangleIntegral_one` |
| `NormalDomain` | 380 | `ChangeOfVariables`、`GreenGaussStokes`、`Examples/GreenRegions` | 是：`xNormalDomain`、`yNormalDomain`、`integral_*NormalDomain_eq_iterated` |
| `NormedAlternating` | 52 | `DifferentialForms` | 是：`NormalizedAlternatingSpace`、`to/fromNormalizedAlternatingSpace` |

依赖拓扑（本组内部边，箭头 = import，括号内为**实际使用**的声明）：

```text
NormedAlternating ──(NormalizedAlternatingSpace)──▶ DifferentialForms[analysis.multivariable.differential-forms]
ConstantRank      ──(未使用 import)──▶ MultivariableIntegration
MultivariableIntegration ──(未使用 import)──▶ JordanRegion
JordanRegion ──(JordanEuc, IsJordanMeasurable)──▶ MultivariableRiemann[analysis.multivariable.riemann-box]
MultivariableRiemann ──(RiemannBox, HasRiemannBoxIntegral)──▶ JordanRiemannBridge
JordanRiemannBridge ──(hasRiemannBoxIntegral_..._of_aeContinuous)──▶ NormalDomain
NormalDomain ──(未使用 import)──▶ ChangeOfVariables
ChangeOfVariables ──(absJacobianWithin)──▶ CoordinateIntegrals
Complex ──(未使用 import)──▶ FundamentalTheoremAlgebra
```

显式核验脚本（import 闭包 × 未加标记前可识别的已登记声明引用）输出的**真实库内 premises**：

```text
== ChangeOfVariables == real in-lib entry premises: []
== Complex == real in-lib entry premises: []
== ConstantRank == real in-lib entry premises: []
== CoordinateIntegrals == real in-lib entry premises: []
== FundamentalTheoremAlgebra == real in-lib entry premises: []
== JordanRegion == real in-lib entry premises: []
== JordanRiemannBridge == real in-lib entry premises: [('analysis.multivariable.riemann-box','MultivariableRiemann.lean')]
== MultivariableIntegration == real in-lib entry premises: []
== NormalDomain == real in-lib entry premises: [('analysis.multivariable.riemann-box','MultivariableRiemann.lean'),('real-analysis.riemann.def','Riemann.lean'),('real-analysis.riemann.eq-lebesgue','Riemann.lean')]
== NormedAlternating == real in-lib entry premises: []
```

（未计入本组内部互相引用，因为它们当时还没有 Entry id。补登记后，组内真实 premises 见 §4。）

### 2.2 隐藏影响面

- **typeclass / instance**：`NormedAlternating` 定义 `NormalizedAlternatingSpace` 的两个
  `NormedAddCommGroup`／`NormedSpace ℝ` 实例。它们是**命名实例**，不会改变全局实例搜索；
  核验方式为 `DifferentialForms.lean` 中的 `normalizedAlternatingSpace_differentiableAt`、
  `normalizedWedgeLinearMap` 等直接使用。除 `DifferentialForms` 外无消费者。
- **notation / simp**：本组没有新增 notation。`Complex` 的 `mk_re`/`mk_im` 带 `@[simp]`，
  但它们只在 `SandronesLibrary.Analysis.Complex` 命名空间内，库内无其他 `simp` 消费者。
- **公开泄漏**：`NormalizedAlternatingSpace E k := E [⋀^Fin k]→L[ℝ] ℝ` 是 Mathlib 类型的
  reducible 别名（本库特殊定义的桥），公开签名直接暴露 Mathlib 结构；属于 AGENTS §4 的
  “本库特殊定义的桥”类别，需在条目文档与 RFC 中披露边界。
- **跨学科**：`FundamentalTheoremAlgebra.complex_is_algebraically_closed` 被线性代数
  `JordanSimilarity.lean:127`、`MatrixSchur.lean:162,348` 单向使用。
- **RADAR**：`docs/MATHLIB-RADAR.md` 已有 `analysis.multivariable.{jordan-region,
  jordan-riemann-bridge, x-normal-domain, rectangle-integral, change-variables,
  coordinate-integrals}` 的“谁在用”记录（虽然 Registry 中并不存在这些条目），说明
  Main 侧早已按“应存在”维护；本 RFC 不修改 RADAR，只给更新建议。
- **示例**：`Examples/{CoordinateIntegrals,GaussStokes,GreenRegions,SphericalMoments}.lean`
  中，`GreenRegions` 用 `xNormalDomain`/`yNormalDomain`，`CoordinateIntegrals`/`SphericalMoments`
  消费球坐标结果。条目文档提到这些示例是本条目的应用，但没有注册依赖倒置。

### 2.3 关键判定证据：`ConstantRank` 与 `full-rank-theorem` 的声明级对比

任务书提示“`ConstantRank.lean` 很可能被 `full-rank-theorem` 路线取代”。**声明级对比
证明该提示不成立**：

- `SandronesLibrary/Analysis/InverseImplicit.lean:96` 的
  `analysis.multivariable.full-rank-theorem`（RADAR 记 `full_rank_level_set_normal_form`）：
  `{f : E₁ × E₂ → F}`，在 `(fderiv ℝ f u ∘L inr).IsInvertible`（即**满秩／值域方向全秩**）
  下，把水平集局部写成图像 `v₂ = ψ(v₁)`。
- `SandronesLibrary/Analysis/ConstantRank.lean:517` 的 `constant_rank_theorem_rudin_9_32`：
  `{F : Euc n → Euc m}`，在开集上 `C¹` 且 `∀ x ∈ E, finrank ℝ (fderiv ℝ F x).range = r`
  （**任意固定秩 r**），得到 Rudin 9.32 的局部坐标正规形
  `F (e.symm x) = fderiv ℝ F a x + φ(...)`。

`full_rank_level_set_normal_form` 是“秩 = 值域维数”的特例；`constant_rank_theorem_rudin_9_32`
覆盖一般 `r`，是**严格更一般**的定理。两者不是替代关系。且 `constant_rank_theorem_rudin_9_32`
在库内**零使用**、其唯一导入者 `MultivariableIntegration` 不引用它——它是一个“已证明但
未登记、未接线”的孤立定理。因此判定为**内容唯一、应补登记**，而不是退役。

---

## 3. 缺陷分组与判定

### 3.1 (c) 有标记、有文档、无 Registry：`analysis.derivative.definition`

- 源码标记：`SandronesLibrary/Analysis/Derivative.lean:32`，管辖
  `HasDerivativeAtTextbook`（`def`）、`hasDerivativeAtTextbook_iff_hasDerivAt`、
  `hasDerivativeAtTextbook_unique`。
- 文档：`docs/entries/analysis/derivative/definition.md`，正文完整。
- ROADMAP §2 M4 第 1 行已记 ✅，但 Registry 无记录 → 不进公理审计、不进 index／rankings。
- 文档 `provenance.ref` 是中文自由文本 `华东师大《数学分析》第五版 第一卷 第五章 §1 导数概念`，
  违反 AGENTS §6。**现场在 `reference.bib:46` 查到本书键为 `ecnu-mathematical-analysis-5`**
  （`author = 华东师范大学数学科学学院`，`title = 数学分析`，`edition = 5`，`year = 2019`）。
- 文档 `premises: [analysis.func-limit.definition]` 经核验**不是该文件的真实依赖**：
  `Derivative.lean` 只 `import Mathlib`，差商极限直接用 `Tendsto`／`𝓝[≠]` 表达，没有引用
  `Analysis/FuncLimit.lean` 的任何声明。按库内既有约定（`analysis.continuity.definition`、
  `analysis.func-limit.definition`、`analysis.derivative.*` 的 premises 均为 `[]`），
  本条 premises 应为 `[]`。

### 3.2 (d) 十个无标记模块：逐个判定

判定原则（Main 已定）：禁止按文件名猜；证据来自声明清单、库内导入者计数、与已登记条目的
重复度。本组 10 个模块的结论如下（None = 无对应已登记条目可被取代）：

| 模块 | 判定 | 依据（声明级） |
|---|---|---|
| `ChangeOfVariables` | **内容唯一 → 补登记** | 定义 `absJacobianWithin` + 3 条换元定理；`CoordinateIntegrals` 真实消费；无已登记条目覆盖“有限维 Jacobian 换元公式” |
| `Complex` | **内容唯一 → 补登记** | 12 条复数教材定义与基本运算（`mk`/`ext_iff`/`mk_add`/`mk_mul`/`I_eq_mk`/`mul_conj`/`norm_sq` 等）；是 FTA 的概念前置；`complex-analysis.holomorphic.elementary` 讲的是 exp/sin/cos/log，不覆盖该内容 |
| `ConstantRank` | **内容唯一 → 补登记（不是 superseded）** | 见 §2.3；`constant_rank_theorem_rudin_9_32` 严格强于 `full_rank_level_set_normal_form`，库内零使用 |
| `CoordinateIntegrals` | **内容唯一 → 补登记** | 35 条：极/柱/球坐标映射、Jacobian 行列式、单射性、换元与累次积分、测度保持等价；被 `Examples` 消费；无已登记条目覆盖 |
| `FundamentalTheoremAlgebra` | **内容唯一 → 补登记** | 4 条：FTA + `IsAlgClosed ℂ` + 分裂 + 根乘积；`complex_is_algebraically_closed` 被线性代数两条模块真实使用 |
| `JordanRegion` | **内容唯一 → 补登记** | `IsJordanMeasurable` 定义 + 6 条性质；是 `MultivariableRiemann`、`NormalDomain`、`ChangeOfVariables` 的前置；无已登记条目覆盖 |
| `JordanRiemannBridge` | **内容唯一 → 补登记** | 零延拓 Riemann–Lebesgue 桥 6 条；`NormalDomain` 真实消费；无已登记条目覆盖 |
| `MultivariableIntegration` | **内容唯一 → 补登记** | 矩形 Fubini 教材接口 6 条；`ParametrizedGeometry`、`SecondKindIntegrals`、`JordanRegion` 真实消费 |
| `NormalDomain` | **内容唯一 → 补登记** | x/y 型正常区域 + 变限累次积分 17 条；`GreenGaussStokes`、`Examples/GreenRegions` 真实消费 |
| `NormedAlternating` | **内容唯一但属 Mathlib 桥／分析基础设施 → 建议补登记并披露边界** | 1 个类型别名 + 2 个命名实例 + 2 个恒等连续线性桥；只服务 `DifferentialForms`；公开签名暴露 Mathlib `ContinuousAlternatingMap`，按 AGENTS §4 属“本库特殊定义的桥”，不是纯教材定义，也不是可退役的重复实现 |

**退役结论：本组没有任何模块满足 ROLE 阶段 C 的四条退役条件**，本轮**不提交退役申请**。
`ConstantRank` 与 `MultivariableIntegration`、`JordanRegion` 之间存在**未使用的 import**，
但“删除 import”属退役提交的一部分，且需 Main 全库 build 与下游验收，本轮只记录。

### 3.3 (d) 九个 orphan 文档：逐个判定

| 文档（id） | 判定 | 依据 |
|---|---|---|
| `analysis.complex.definition` | **内容有效 → 补 Registry** | id 与 `Complex.lean` 12 条声明完全对应；正文完整 |
| `analysis.complex.fundamental-theorem-algebra` | **内容有效 → 补 Registry** | id 与 FTA 4 条声明对应；premise 指向同组 `analysis.complex.definition` |
| `analysis.multivariable.change-variables` | **内容有效 → 补 Registry** | id 与 `ChangeOfVariables.lean` 4 条声明对应 |
| `analysis.multivariable.constant-rank-theorem` | **内容有效 → 补 Registry** | id 与 `constant_rank_theorem_rudin_9_32` 对应；证明路线描述与源码一致 |
| `analysis.multivariable.coordinate-integrals` | **内容有效 → 补 Registry** | id 与 `CoordinateIntegrals.lean` 对应；正文记录球坐标 Fubini 展开与 Examples |
| `analysis.multivariable.jordan-region` | **内容有效 → 补 Registry** | id 与 `JordanRegion.lean` 对应 |
| `analysis.multivariable.jordan-riemann-bridge` | **内容有效 → 补 Registry** | id 与 `JordanRiemannBridge.lean` 对应 |
| `analysis.multivariable.x-normal-domain` | **内容有效 → 改 id 后补 Registry** | 文档内容覆盖 x 与 y 两型；`x-` 前缀误导；建议改为 `analysis.multivariable.normal-domain`（文件名已是 `normal-domain.md`，Registry 无冲突） |
| `analysis.multivariable.rectangle-integral` | **内容有效 → 补 Registry** | id 与 `MultivariableIntegration.lean` 6 条声明对应 |

**九个 orphan 文档全部有效，本轮不删除任何一个。** 每个文档的 `provenance.ref` 都是自由
文本，须替换为 `reference.bib` 的已存在键（见 §4）。`normal-domain.md` 的 id 改动会在
handoff 中列出 Main 需同步的 RADAR 行（`docs/MATHLIB-RADAR.md:2123,2131`）。

**遗漏项**：十个无标记模块中，`NormedAlternating.lean` **没有对应 orphan 文档**，补登记时
需要新建 `docs/entries/analysis/multivariable/normed-alternating.md`。

---

## 4. 建议的 Registry 记录（供 Main 写入）

### 4.1 `analysis.derivative.definition`（补登记，修正后的 front matter）

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

说明：`premises` 由文档原值 `[analysis.func-limit.definition]` 改为 `[]`（§3.1 核验），
`axioms`／`proof_sha`／`dependedOnBy` 由 `check_axioms.py`／`update_dependency_graph.py`
生成，Main 不手填。章节定位 `第五章 §1 导数概念` 移入文档正文。

### 4.2 十个模块的补登记（均在源码加一个文件级 Entry 标记）

| id | lean_file | kind | premises（补登记后真实依赖） | provenance.ref | nl_file |
|---|---|---|---|---|---|
| `analysis.complex.definition` | `Analysis/Complex.lean` | definition | `[]` | `ahlfors-complex-analysis-1979` | `docs/entries/analysis/complex/definition.md` |
| `analysis.complex.fundamental-theorem-algebra` | `Analysis/FundamentalTheoremAlgebra.lean` | theorem | `[]`（见备注） | `ahlfors-complex-analysis-1979` | `docs/entries/analysis/complex/fundamental-theorem-algebra.md` |
| `analysis.multivariable.rectangle-integral` | `Analysis/MultivariableIntegration.lean` | theorem | `[]` | `spivak-calculus-manifolds-1965` | `docs/entries/analysis/multivariable/rectangle-integral.md` |
| `analysis.multivariable.jordan-region` | `Analysis/JordanRegion.lean` | definition | `[]` | `spivak-calculus-manifolds-1965` | `docs/entries/analysis/multivariable/jordan-region.md` |
| `analysis.multivariable.jordan-riemann-bridge` | `Analysis/JordanRiemannBridge.lean` | theorem | `[analysis.multivariable.jordan-region, analysis.multivariable.riemann-box]` | `spivak-calculus-manifolds-1965` | `docs/entries/analysis/multivariable/jordan-riemann-bridge.md` |
| `analysis.multivariable.normal-domain` | `Analysis/NormalDomain.lean` | theorem | `[analysis.multivariable.jordan-region, analysis.multivariable.jordan-riemann-bridge, real-analysis.riemann.def, real-analysis.riemann.eq-lebesgue]` | `spivak-calculus-manifolds-1965` | `docs/entries/analysis/multivariable/normal-domain.md` |
| `analysis.multivariable.change-variables` | `Analysis/ChangeOfVariables.lean` | theorem | `[analysis.multivariable.jordan-region]` | `spivak-calculus-manifolds-1965` | `docs/entries/analysis/multivariable/change-of-variables.md` |
| `analysis.multivariable.coordinate-integrals` | `Analysis/CoordinateIntegrals.lean` | theorem | `[analysis.multivariable.change-variables, analysis.multivariable.jordan-region]` | `spivak-calculus-manifolds-1965` | `docs/entries/analysis/multivariable/coordinate-integrals.md` |
| `analysis.multivariable.constant-rank-theorem` | `Analysis/ConstantRank.lean` | theorem | `[]` | `spivak-calculus-manifolds-1965` | `docs/entries/analysis/multivariable/constant-rank-theorem.md` |
| `analysis.multivariable.normed-alternating` | `Analysis/NormedAlternating.lean` | definition | `[]` | `spivak-calculus-manifolds-1965` | `docs/entries/analysis/multivariable/normed-alternating.md`（新建） |

备注（逐条 premises 核验）：

- `analysis.complex.definition`：`Complex.lean` 只 `import Mathlib`，未引用任何库内 Entry，
  因此 `[]`；文档原 premise `analysis.real.construction-cauchy` 应删。
- `analysis.complex.fundamental-theorem-algebra`：文件 `import Analysis.Complex`，但 4 条声明
  全部直接调用 Mathlib `Complex.exists_root` 等，未引用 `Complex.lean` 的声明，严格核验为
  `[]`。文档原 premise `analysis.complex.definition` 是**概念前置**而非代码依赖；若 Main
  采用“概念前置也记 premises”的宽松口径，可保留 `[analysis.complex.definition]`。本 RFC
  按库内既有严格口径给 `[]`，并在 handoff 标为“待 Main 确认口径”。
- `analysis.multivariable.rectangle-integral`：`MultivariableIntegration.lean` 调用的是
  Mathlib `MeasureTheory.setIntegral_prod`／`intervalIntegral_intervalIntegral_swap`，不是
  库内 `real-analysis.measure.fubini`（后者在 `ProductMeasure.lean` 另有一条同名定理）。
  故 `[]`。文档原 premise `real-analysis.measure.fubini` 应删。
- `analysis.multivariable.jordan-region`：`JordanRegion.lean` 只用 Mathlib
  `nullMeasurableSet_of_null_frontier` 等；其 `import MultivariableIntegration` 未被使用，
  故 `[]`。文档原 premise `analysis.multivariable.rectangle-integral` 应删。
- `analysis.multivariable.jordan-riemann-bridge`：真实引用 `RiemannBox`（riemann-box）与
  `IsJordanMeasurable`（jordan-region）。
- `analysis.multivariable.normal-domain`：真实引用 `hasRiemannBoxIntegral_..._of_aeContinuous`
  与 `jordan_indicator_*`（jordan-riemann-bridge）、`IsJordanMeasurable`（jordan-region）、
  `riemannIntegral_eq_interval`（`real-analysis.riemann.def`）／`real-analysis.riemann.eq-lebesgue`；
  `MeasureTheory.integral_prod` 是 Mathlib。文档原 premise 里的
  `real-analysis.riemann.eq-lebesgue-general` 是**外壳条目**，实际被引用的
  `riemannIntegral_eq_interval` 在 `RealAnalysis/Riemann.lean:909`，归属
  `real-analysis.riemann.def`／`.eq-lebesgue`，故按之修正。
- `analysis.multivariable.change-variables`：真实引用 `JordanEuc`（jordan-region）；
  `import NormalDomain` 未被使用。文档原 premises `x-normal-domain`／`frechet` 应删。
- `analysis.multivariable.coordinate-integrals`：真实引用 `absJacobianWithin`（change-variables）
  与 `JordanEuc`（jordan-region）。文档原 premise `real-analysis.measure.fubini` 应删。

---

## 5. 定级、波次与回滚点

| 变更 | 等级 | 理由 | 波次 |
|---|---|---|---|
| derivative.definition 文档 `ref`／`premises` 修正 | **M0** | 只改 Entry 元数据，不改任何 Lean 签名 | 阶段 1 |
| 9 个 orphan 文档 front matter 修正（ref／premises／id） | **M0** | 同上 | 阶段 1 |
| 10 个模块加 `> **Entry**:` 标记 + 新建 NormedAlternating 文档 | **M1** | 新增 Entry 登记，公开 API 与旧接口完整保留，不迁移、不删除 | 阶段 2 |
| 未使用 import 清理（ConstantRank / MultivariableIntegration / JordanRegion） | 退役候选，**本轮不做** | 属阶段 C，需 Main 全库 build + 下游验收 + 零使用计数 | 未来窗口 |

**没有 M2/M3 项**：本轮不改变任何公开签名，不需要 `old_iff_new`（新旧接口是同一个声明），
也不存在语义变化。M2 三阶段与旧接口退役条件在本轮**不触发**。

回滚点：

- 阶段 1（元数据）：单独 commit，回滚只需 revert 该 commit，不影响编译。
- 阶段 2（加标记）：单独 commit；标记是纯注释，回滚后源码语义完全不变；但 Main 若已据
  标记写入 Registry，回滚须与 Registry 同步（README/rankings 由生成器重建）。

---

## 6. 本轮不处理的内容

- 不修改任何 Main 共享文件（`SandronesLibrary.lean`、`index/*.json`、`reference.bib`、
  `docs/entries/README.md`、`docs/entries/RANKINGS.md`、`docs/MATHLIB-RADAR.md`、
  `docs/ROADMAP-*.md`、`docs/LEAN-PLAYBOOK.md`、`README.md`、`AGENTS.md`、`scripts/**`）。
- 不执行任何退役（含未使用 import 清理），只提交 RFC 与退役建议。
- 不处理 E1/E3 的缺陷：`linear-algebra.vector-space.dimension` 幽灵 Entry、
  `real-analysis.riemann.cont-integrable` 缺标记、两条跨文件 id、拓扑/线代 orphan 文档。
- 不运行全库 `lake build`；不跑 `lake update`／`lake exe cache get`。
- 不新增数学定义、不改证明体、不改定理类型。

## 7. 诚实边界

- 本 RFC 的“真实 premises”来自静态 import 闭包 × 声明名引用的脚本核验；最终以 Main 的
  `update_dependency_graph.py`／`check_axioms.py`／`audit.py` 结果为准。
- `ConstantRank` 是否应真正接线到 `full-rank-theorem` 路线（而非仅登记）是数学路线决定，
  留给 AN-MV 后续窗口；本 RFC 只证明它不是 `full-rank-theorem` 的重复实现。
- `NormedAlternating` 属“Mathlib 结构桥”还是“基础设施豁免”存在口径空间；本 RFC 建议
  先按 M1 登记并披露边界，最终分类由 Main 决定。
- 文档 ref 键的选择沿用同族已登记条目的既有约定：`analysis.multivariable.*` 用
  `spivak-calculus-manifolds-1965`，`analysis.complex.*`（ROADMAP §7 的 C0/C0.5）用
  `ahlfors-complex-analysis-1979`。若 Main 认为坐标积分应以 ECNU 为源，可单点更换键。
