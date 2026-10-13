# RA-F2 绝对连续／互奇异／Lebesgue 分解／Radon–Nikodym 正式交接

- entries（4 条，1 Entry ↔ 1 Lean 文件）：
  - `real-analysis.measure-derivative.absolute-continuity`
  - `real-analysis.measure-derivative.mutually-singular`
  - `real-analysis.measure-derivative.lebesgue-decomposition`
  - `real-analysis.measure-derivative.radon-nikodym`
- branch：`codex/real-analysis-wave-r1`
- worktree：`/home/pisquare/czt/sandrones-library-real-r1`
- 基线（base）：`49acfa0`（Wave R 起点 `main` 尖端；建 worktree 时现场 `git log` 核对，未 rebase）
- gate：`development_open`（RA-F1 已于 `f856e0f`／`ef88ec4` 集成，RA-F2 开工门“RA-F1”已满足）
- formal sources（4 个新文件，未改任何既有 `.lean`）：
  - `SandronesLibrary/RealAnalysis/MeasureDerivativeAbsoluteContinuity.lean`
  - `SandronesLibrary/RealAnalysis/MeasureDerivativeMutuallySingular.lean`
  - `SandronesLibrary/RealAnalysis/MeasureDerivativeLebesgueDecomposition.lean`
  - `SandronesLibrary/RealAnalysis/MeasureDerivativeRadonNikodym.lean`
- documents：`docs/entries/real-analysis/measure-derivative/{absolute-continuity,mutually-singular,lebesgue-decomposition,radon-nikodym}.md` + 本 handoff
- 本批提交（4 段）：
  - `293fa00` absolute-continuity（Lean + md）
  - `ca1737a` mutually-singular（Lean + md）
  - `b7657b2` lebesgue-decomposition（Lean + md）
  - `27b2a1e` radon-nikodym（Lean + md）
  - 紧随其后另有仅更新本 handoff 的文档提交（见 `git log 49acfa0..HEAD`）
- 未改任何 Main 共享文件（仅在本 handoff 给建议）；未 push。

## 1. 依赖门与范围

RA-F2 的开工门是 RA-F1（已集成）。本批交付 RA-F2 全部出口：RN 存在唯一性、由密度构造测度、
积分换测度及链式／互逆边界。RA-F3–RA-F6 仍 🚧，本批任何文件都没有实现或宣称它们完成。

四个 Lean 文件均只 `import Mathlib`（与 RA-F1 各文件一致），互不 import；概念链在 Mathlib
承载上组装，联合导入与定义链由聚合文件验证（§5）。`docs/entries` 的 `premises` 给出 Entry 层
依赖图；Main 登记 Registry 时按 §9 建议填写。

## 2. 概念冻结表

| 概念 | 教材语义（Folland 2nd ed. §3.2） | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|---|
| 绝对连续 `μ ≪ ν` | `ν(E)=0 ⟹ μ(E)=0` | `Measure.AbsolutelyContinuous`（记号 `≪`） | `absolutelyContinuous_iff`、`absolutelyContinuous_iff_measurable` | 语义一致，直接复用；a.e. 滤子桥 `absolutelyContinuous_iff_ae_le` | `absolutelyContinuous_null_mono`、`eq_zero_of_mutuallySingular_of_absolutelyContinuous` | absolute-continuity |
| 密度测度 `μ.withDensity f` | `E ↦ ∫_E f dμ` | `Measure.withDensity` | `withDensity_absolutelyContinuous` | 语义一致；RN“⟸”方向入口 | `radonNikodym` | absolute-continuity |
| 互奇异 `μ ⟂ₘ ν` | `∃s` 可测，`μ s=0 ∧ ν sᶜ=0` | `Measure.MutuallySingular`（记号 `⟂ₘ`） | `mutuallySingular_iff`；见证 `h.nullSet` 三则 | 语义一致，直接复用；桥到 `Disjoint μ ν`、`Disjoint (ae μ) (ae ν)` | `eq_zero_of_mutuallySingular_of_absolutelyContinuous` | mutually-singular |
| Lebesgue 分解 | `μ=s+fν`，`s⟂ₘν` | `HaveLebesgueDecomposition`；`singularPart`、`rnDeriv` | `haveLebesgueDecomposition_spec` | 语义一致，直接复用 | `singularPart_unique`、`rnDeriv_unique` | lebesgue-decomposition |
| 奇异部分零点 | `s=0 ⟺ μ≪ν` | `Measure.singularPart` | `singularPart_eq_zero_iff` | Mathlib `singularPart_eq_zero` 的教材命名 | `rnDeriv_unique` | lebesgue-decomposition |
| 测度导数 `dμ/dν` | `f=rnDeriv`，`ν.withDensity f=μ` | `Measure.rnDeriv : α → ℝ≥0∞` | `rnDeriv_withDensity` | 语义一致；式子是**测度相等**，非 a.e. | `rnDeriv_mul_rnDeriv`、`inv_rnDeriv` | radon-nikodym |
| 有符号测度 RN | `s` 关于 `μ` 的密度 | `SignedMeasure`＋`≪ᵥ`／`Measure.withDensityᵥ` | `signedMeasure_absolutelyContinuous_iff_withDensityᵥ_rnDeriv_eq` | 桥连 RA-F1 `real-analysis.signed-measure.*` | （桥本身） | radon-nikodym |

## 3. 公开签名扫描（四类归属）

- **第 1 类（语义一致的正式公开承载）**：`Measure.AbsolutelyContinuous`、`Measure.MutuallySingular`、
  `Measure.HaveLebesgueDecomposition`、`Measure.singularPart`、`Measure.rnDeriv`、
  `Measure.withDensity`、`Measure.withDensityᵥ`、`Measure.real`、`SFinite`／`SigmaFinite`
  （类型类假设）、`SignedMeasure`（RA-F1 载体，仅出现在一条桥的类型里）。各 Entry 文档给出
  教材定义、量词、类型类假设与展开。
- **第 2 类（本库具名桥）**：`absolutelyContinuous_iff_ae_le`（`≪` ↔ `ae μ ≤ ae ν`）；
  `mutuallySingular_iff_disjoint`／`mutuallySingular_iff_disjoint_ae`；
  `eq_zero_of_mutuallySingular_of_absolutelyContinuous`（`≪` 与 `⟂ₘ` 相遇）；
  `singularPart_eq_zero_iff`（分解 ↔ 绝对连续）；
  `signedMeasure_absolutelyContinuous_iff_withDensityᵥ_rnDeriv_eq`（RN ↔ RA-F1 向量测度）。
- **第 3 类（私有证明后端）**：本文件定理体调用的全部 Mathlib 性质引理（`Measure.absolutelyContinuous_*`、
  `Measure.MutuallySingular.*`、`Measure.haveLebesgueDecomposition_*`、`Measure.eq_singularPart`、
  `Measure.eq_rnDeriv`、`Measure.rnDeriv_*`、`Measure.inv_rnDeriv`、`Measure.*rnDeriv*Integral*`、
  `Measure.singularPart_eq_*` 等）。它们只在 docstring 与证明体出现，未成为课程新概念。
- **第 4 类（越级公开泄漏）**：无。
- 无全局 `instance` 声明、无冲突标记、无 `sorry`/`admit`/`sorryAx`/`native_decide`（§7 扫描）。
- **角色说明**：本批不新造任何 `def`/`structure`；所有 66 条公开声明都是 Mathlib 语义一致承载的
  教材化重述、量词展开或桥，符合 ROLE“语义一致优先复用、不为造名字重造同构”的要求。

## 4. 子 Agent 所有权、提交与负责人退回

公共定义层（`MeasureDerivativeAbsoluteContinuity.lean`）由负责人亲自撰写、`lake build` 冻结
（8706 jobs，exit 0）后，才派生 3 个文件所有权互不重叠的子 Agent。子 Agent 只写各自的一个
`.lean` 与对应 `.md`，未做 git 写、未跑 `lake build`（仅 `lake env lean` 自检）。

| 子 Agent | 所有权（.lean + doc） | 自验证 | 负责人复核结果 |
|---|---|---|---|
| `c4a68063` | `MeasureDerivativeMutuallySingular.lean` + `mutually-singular.md` | `lake env lean` exit 0 | 17 条声明数学/映射通过；**退回并已就地修复 2 处**：① Lean 头注释长行 warning（第 27 行）；② md「直觉」节把 `ν` 的集中方向写反（`ν(sᶜ)=0` 应读作 `ν` 集中在 `s`，非 `sᶜ`），并修正 front matter `mathlib` 列表（去掉该文件未使用的 `withDensity_absolutelyContinuous`）。 |
| `e2c85711` | `MeasureDerivativeLebesgueDecomposition.lean` + `lebesgue-decomposition.md` | `lake env lean` exit 0 | 15 条声明通过；**退回并已就地修复 1 处**：Lean 头注释长行 warning（第 34 行）。命名偏差（`singularPart_eq_zero_iff` 等封装 Mathlib 的 `_ac`/无 `_iff` 后缀版）经复核为合理封装，不返工。 |
| `9b5a9999` | `MeasureDerivativeRadonNikodym.lean` + `radon-nikodym.md` | `lake env lean` exit 0 | 16 条声明通过；**退回并已就地修复 1 处**：Lean 头注释长行 warning（第 30 行）。有符号测度桥 `#check` 通过、`≪ᵥ` 记号可用。 |

子 Agent 报告不作为验收；以上结论均经负责人重新 `lake build` 四个模块、聚合 `#check`、公理审计与
逐文件声明映射后得出。

## 5. 定义链聚合与 Entry 声明映射

聚合文件 `/tmp/sandrones-library/RA_F2_Aggregate.lean` 联合导入 4 个模块并同时 `#check`
“正式承载 → 展开／刻画 → 必要桥 → 上层使用者”：

- 承载与展开：`Measure.AbsolutelyContinuous`／`MutuallySingular`／`HaveLebesgueDecomposition`／
  `singularPart`／`rnDeriv`、`absolutelyContinuous_iff(_measurable)`、`mutuallySingular_iff`、
  `haveLebesgueDecomposition_spec`；
- 桥：`absolutelyContinuous_iff_ae_le`、`withDensity_absolutelyContinuous`、
  `mutuallySingular_iff_disjoint(_ae)`、`eq_zero_of_mutuallySingular_of_absolutelyContinuous`、
  `singularPart_eq_zero_iff`、`mutuallySingular_haveLebesgueDecomposition`、
  `signedMeasure_absolutelyContinuous_iff_withDensityᵥ_rnDeriv_eq`；
- 使用者／主定理：`radonNikodym`、`absolutelyContinuous_iff_withDensity_rnDeriv_eq`、
  `rnDeriv_unique`、`rnDeriv_mul_rnDeriv`、`inv_rnDeriv`、`rnDeriv_withDensity_left/right`、
  `setIntegral_toReal_rnDeriv`、`rnDeriv_lt_top` 等。

命令 `lake env lean /tmp/sandrones-library/RA_F2_Aggregate.lean` → exit 0，38 条 `#check` 全部解析。
`#print axioms` 取 `absolutelyContinuous_iff_ae_le`、`eq_zero_of_mutuallySingular_of_absolutelyContinuous`、
`haveLebesgueDecomposition_add`、`rnDeriv_unique`、`absolutelyContinuous_iff_withDensity_rnDeriv_eq`、
`rnDeriv_mul_rnDeriv`，六者均仅含 `[propext, Classical.choice, Quot.sound]`（含 ℝ／Lebesgue 结构，
属 Playbook §3.3 的结构必需 choice）。

Entry 声明映射（用 `scripts/check_axioms.py` 的 `map_entry_to_decl` 现场运行）：
`absolute-continuity` → 18；`mutually-singular` → 17；`lebesgue-decomposition` → 15；
`radon-nikodym` → 16。每个文件只映射到唯一 Entry，无跨文件吸入；Markdown id、源码 `> **Entry**:`
标记、拟登记 Registry id、唯一 `lean_file` 四者一致。

## 6. 验证命令与结果（原文）

- `lake build SandronesLibrary.RealAnalysis.MeasureDerivativeAbsoluteContinuity
  SandronesLibrary.RealAnalysis.MeasureDerivativeMutuallySingular
  SandronesLibrary.RealAnalysis.MeasureDerivativeLebesgueDecomposition
  SandronesLibrary.RealAnalysis.MeasureDerivativeRadonNikodym`
  → `Build completed successfully (8709 jobs)`，exit 0，**无 warning**（修掉三处长行后）。
  单模块 Definition 阶段 `8706 jobs`、其余 `8707–8709 jobs`，均 exit 0。
- `lake env lean /tmp/sandrones-library/RA_F2_Aggregate.lean` → exit 0，38 条 `#check` 通过；
  6 项 `#print axioms` 均为 `[propext, Classical.choice, Quot.sound]`。
- `map_entry_to_decl`：4 文件分别映射 18/17/15/16 个声明，无跨文件吸入。
- `grep -rnE '\b(sorry|admit|sorryAx|native_decide)\b' SandronesLibrary/RealAnalysis/MeasureDerivative*.lean`
  → 无命中；冲突标记 → 无；全局 `instance` → 无。
- `git diff --cached --check`（分段提交前）→ 干净；每次提交后 `git status --short` 为空。
- 磁盘：开工时 `df -h /` 可用约 `8.9G`，全部定向构建后约 `8.4G`，未触 3G 下限；
  未跑 `lake update`／`lake exe cache get`，`.lake/packages` 符号链接未动。
- 全库 `lake build`、`audit.py --all`、Registry/RADAR/ROADMAP 生成器均未运行（Main 集成职责）。

## 7. 下一批可依赖／不可依赖

**可稳定依赖（已编译、签名冻结）**：
- `SandronesLibrary.RealAnalysis.MeasureDerivative` 命名空间下全部 66 条公开声明：
  `absolutelyContinuous_*`、`withDensity_absolutelyContinuous`、`mutuallySingular_*`、
  `eq_zero_of_mutuallySingular_of_absolutelyContinuous`、`haveLebesgueDecomposition_*`、
  `singularPart_*`、`rnDeriv_*`、`setLIntegral_rnDeriv`、`lintegral_rnDeriv`、
  `setIntegral_toReal_rnDeriv`、`integral_toReal_rnDeriv`、
  `signedMeasure_absolutelyContinuous_iff_withDensityᵥ_rnDeriv_eq`。
- RA-F5（BV/AC 函数）与 RA-F2 的 `Measure.rnDeriv`、`HaveLebesgueDecomposition` 可直接依赖；
  RA-F3（Hardy–Littlewood）的覆盖引理接口尚未冻结，其“RA-F2 依赖”指可引用本批绝对连续／
  互奇异谓词，不得复制本批教材化重述。

**明确不可依赖（未完成／未冻结）**：
- RA-F3–RA-F6 全部内容：极大函数与弱型估计、Lebesgue 点／微分定理、单调/BV/AC 函数、
  a.e. FTC。
- 本批未提供 `IsFiniteMeasure (c.variation)` 等 RA-F1 遗留未注册实例，也未扩展复测度 RN。
- 本批未运行全库 `lake build`（属 Main）。

## 8. Main 更新建议

- 顶层 imports（加入 `SandronesLibrary.lean`）：
  - `import SandronesLibrary.RealAnalysis.MeasureDerivativeAbsoluteContinuity`
  - `import SandronesLibrary.RealAnalysis.MeasureDerivativeMutuallySingular`
  - `import SandronesLibrary.RealAnalysis.MeasureDerivativeLebesgueDecomposition`
  - `import SandronesLibrary.RealAnalysis.MeasureDerivativeRadonNikodym`
- Registry：新增 4 条 Entry，`lean_file` 分别为
  `RealAnalysis/MeasureDerivativeAbsoluteContinuity.lean`、
  `RealAnalysis/MeasureDerivativeMutuallySingular.lean`、
  `RealAnalysis/MeasureDerivativeLebesgueDecomposition.lean`、
  `RealAnalysis/MeasureDerivativeRadonNikodym.lean`；`provenance.ref` 均为已存在的
  `"folland-real-analysis-1999"`；`mathlib` 由各 Entry front matter 提供（只列真实名称）；
  `premises` 建议：
  - `real-analysis.measure-derivative.absolute-continuity`：`[]`
  - `real-analysis.measure-derivative.mutually-singular`：`[real-analysis.measure-derivative.absolute-continuity]`
  - `real-analysis.measure-derivative.lebesgue-decomposition`：`[real-analysis.measure-derivative.absolute-continuity, real-analysis.measure-derivative.mutually-singular]`
  - `real-analysis.measure-derivative.radon-nikodym`：`[real-analysis.measure-derivative.absolute-continuity, real-analysis.measure-derivative.mutually-singular, real-analysis.measure-derivative.lebesgue-decomposition]`
- RADAR：登记 `Measure.AbsolutelyContinuous`、`Measure.MutuallySingular`、
  `Measure.HaveLebesgueDecomposition`、`Measure.rnDeriv`、`Measure.singularPart`、
  `Measure.withDensity` 为“已正式承载（教材解释见对应 Entry）”，并标注
  `SignedMeasure.absolutelyContinuous_iff_withDensityᵥ_rnDeriv_eq` 为跨 RA-F1 的桥。
- ROADMAP §6：RA-F2 行由 🚧 推进到“本批交付、待 Main 验收”（验收通过后置 ✅）；RA-F3–RA-F6
  保持 🚧。
- 文献：无需新增 `reference.bib` 条目（Folland 2nd ed. 已存在）；章节定位（§3.2）已写在 Entry 正文。
- 无 Playbook 新教训（本批未遇新的 tactic 坑；唯一反复项是长行 linter，已按仓库惯例修复）。

## 9. 诚实边界与未完成项

- 本批 4 个 Entry 是 Folland §3.2 的**教材化承载与桥**：载体、量词展开、唯一性/正性、链式/互逆、
  积分换测度与有符号测度桥，均通过复用 Mathlib 已证定理实现；本批**未从头重证** RN／Lebesgue
  分解（ROLE 明确语义一致时优先复用，不重造）。
- ROADMAP §6 对“RA-F3/RA-F4 不得只包装 `ae_lebesguePoint` 或最终微分强定理”的证明骨架要求
  **只适用于后续批次**，本批 RA-F2 不涉及；此处如实说明，避免误读为已满足证明骨架要求。
- 有符号测度 RN 仅给桥（`≪ᵥ`／`withDensityᵥ`），未展开其证明；不涉及复测度 RN 或 Banach
  空间值向量测度。
- 等式类型边界已逐条披露：RN 存在性/iff 是测度相等；唯一性/正性/链式/互逆是 `=ᵐ[·]`；
  积分换测度为 `ℝ≥0∞` 或经 `toReal` 的 `ℝ` 等式。
- 子 Agent 仅以只读 `lake env lean` 自检；正式 `lake build` 与全部验收由负责人串行完成。
- 本批未运行全库 `lake build`、未运行 `audit.py --all`、未改 Registry/RADAR/ROADMAP/共享文档、
  未 push。
