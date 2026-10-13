# Complex analysis handoff — Wave R1 窗口：D1 finite-cycle 正式化（`development_open`）

- 分支：`codex/complex-analysis-wave-r1`
- worktree：`/home/pisquare/czt/sandrones-library-complex-r1`
- 基线：`7dffe37`（= 开工时 `main` HEAD；本窗口为净新分支，未 rebase）
- 窗口权限：`development_open`（依据 `../review-inbox/complex-analysis/main-d1-cycle-signature-freeze.md`
  与 ROADMAP §Wave D D-1b 的正式签名冻结，2026-10-13）
- 角色：复分析学科负责人（Wave R1 并行窗口），未 push

## 1. 范围与提交

本窗口执行冻结通知 §五第 3 条（"冻结后的第一件事"）：把 D1 的三个 `research_open`
研究原型迁入 `SandronesLibrary/ComplexAnalysis/`，按三个冻结 Entry id 各写一份课程文档初稿，
并走 `docs/roles/SUBJECT-MAINTAINER-ROLE.md` 的学科验收门。**未**在同一个窗口顺手加
Laurent／残数／辐角原理。

| 提交 | 内容 |
|---|---|
| `dbae690` | 三个正式 Lean 模块（本 handoff 另见下方补记） |
| `c76fae2` | 三篇 Entry 课程文档初稿 |
| 本 handoff 提交 | `docs/handoffs/complex-analysis-wave-r1.md`（本文件） |

精确文件清单：

- `SandronesLibrary/ComplexAnalysis/BanachPathIntegral.lean`（新增）
- `SandronesLibrary/ComplexAnalysis/CycleCarrier.lean`（新增）
- `SandronesLibrary/ComplexAnalysis/WindingIndex.lean`（新增）
- `docs/entries/complex-analysis/integral/banach-path-foundation.md`（新增）
- `docs/entries/complex-analysis/integral/finite-cycle-foundation.md`（新增）
- `docs/entries/complex-analysis/integral/winding-number-foundation.md`（新增）
- `docs/handoffs/complex-analysis-wave-r1.md`（本文件）

未触碰任何 Main 共享文件（`index/registry.json`、`reference.bib`、`SandronesLibrary.lean`、
`docs/MATHLIB-RADAR.md`、`docs/ROADMAP-*.md`、`docs/entries/README.md`、`scripts/**` 等）。

## 2. 冻结遵从声明

| 冻结项 | 本窗口实现 |
|---|---|
| `BanachPathIntegral.lean` → `complex-analysis.integral.banach-path-foundation` | `banachOneForm`／`BanachPathIntegrable`／`banachPathIntegral` 及 `_zero/_add/_smul/_neg/_refl/_symm/_trans/_cast`、`BanachPathIntegrable.symm/.trans`、`banachPathIntegral_complex_eq_pathIntegral` |
| `CycleCarrier.lean` → `complex-analysis.integral.finite-cycle-foundation` | `ClosedPath := Σ a : ℂ, Path a a`、`Cycle := ClosedPath →₀ ℤ`、`Cycle.trace`／`SupportedIn`／`Integrable`／`PiecewiseC1`、`cycleIntegral : Cycle →ₗ[ℤ] F` |
| `WindingIndex.lean` → `complex-analysis.integral.winding-number-foundation` | `windingNumber : Cycle → ℂ → ℂ`、`IsNullHomologousIn`／`IsHomologousIn`、`isNullHomologousIn_iff/_zero/_add`、`windingNumber_add/_sub/_single`（另加 `_smul/_neg/_zero`） |
| 绕数值域 = ℂ，不是 ℤ | 已遵；Entry 标题／summary 均未写"整数绕数"，整值性列入未完成边界 |
| `IsNullHomologousIn` 的 `SupportedIn` 合取项是定义一部分 | 已遵，见源码定义 |
| `IsHomologousIn` 直接用两 cycle 各自 `SupportedIn`，不用差形式 | 已遵 |
| 保留旧 `pathIntegral`／`PathIntegrable`／`scalarOneForm`，不做 M2 迁移 | 已遵，签名字节未改 |
| 类型类层级不抬高 | `banachPathIntegral` 只要求 `[NormedAddCommGroup F] [NormedSpace ℂ F]`；`windingNumber` 复值层自动满足 |
| `Cycle.trace` 只取像的并、不排除端点；三谓词保持独立 | 已遵 |

## 3. 概念六列表（教材解释层硬门）

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|---|
| Banach 值路径积分 | `∮_γ f(z) dz`，`f : ℂ → F` | `banachPathIntegral f γ := ∫ᶜ z in γ, banachOneForm f z` | `banachOneForm_apply`；`F = ℂ` 时 `banachPathIntegral_complex_eq_pathIntegral`（`rfl`） | Mathlib `curveIntegral` 对余域泛型，为**语义一致的正式承载**；`banachOneForm` 是既有 `scalarOneForm` 的泛化 | `cycleIntegral`；D2 | `complex-analysis.integral.banach-path-foundation` |
| 闭路（含基点） | 首尾相接的道路 | `ClosedPath := Σ a : ℂ, Path a a` | `.1` 基点、`.2 : Path c.1 c.1` | 底层 `Path` 为 Mathlib 正式承载；`Σ` 只做基点打包 | `Cycle.support` | `complex-analysis.integral.finite-cycle-foundation` |
| 有限 cycle | 闭路的有限 ℤ 线性组合 | `Cycle := ClosedPath →₀ ℤ` | `c ∈ γ.support`、`Finsupp.single` | `Finsupp`／`Finsupp.linearCombination` 语义一致，直接复用（本版 `support` 为结构字段，无需 `DecidableEq`） | `cycleIntegral` | 同上 |
| cycle 的 trace | 所有闭路像的并 | `Cycle.trace : Set ℂ` | `Cycle.mem_trace` | 无 Mathlib 对应，本库 `def` | 绕数量词 | 同上 |
| cycle 在 `U` 内 | 每片像含于 `U` | `Cycle.SupportedIn γ U` | `∀ c ∈ γ.support, Set.range c.2 ⊆ U` | `Set.range`／`⊆`，无专用结构 | `cycleIntegral_eq_zero_of_primitive`；`IsNullHomologousIn` | 同上 |
| 每片分段 C¹ | 有限拼接的整体 C¹ 道路 | `SandronesLibrary.Topology.Path.PiecewiseC1`（本库既有） | 构造子 `of_contDiffOn / trans / cast` | 本库 verified 谓词；Mathlib `ContDiffOn` 作后端 | 零同伦消费者 | `topology.homotopy.piecewise-c1-path` |
| cycle 积分（ℂ 与 Banach 值公共 carrier） | 逐片路径积分的 ℤ 加权和 | `cycleIntegral (f : ℂ → F) : Cycle →ₗ[ℤ] F` | `cycleIntegral_apply`、`cycleIntegral_single` | 后端 `Finsupp.linearCombination ℤ`；正式承载仍为 `curveIntegral` | `windingNumber` | `complex-analysis.integral.finite-cycle-foundation` |
| cycle 积分对 cycle 线性 | ℤ-线性是定义推论 | `cycleIntegral_add/_smul/_neg/_sub` | 线性映射 `map_add/map_smul/map_neg/map_sub` | 无新数学，纯 `LinearMap` API | 绕数线性 | 同上 |
| 绕数／index | `n(γ,w) = (2πi)⁻¹∮_γ dz/(z-w)` | `windingNumber (γ : Cycle) (w : ℂ) : ℂ` | 定义即展开；`windingNumber_add/_smul/_neg/_sub/_single` | **Mathlib 无对应**（v4.33 全树无 `winding`），必须自建；`Real.pi`／`Complex.I` 为常量后端 | `IsNullHomologousIn`；零同伦消费者 | `complex-analysis.integral.winding-number-foundation` |
| 域外绕数为零的量词 | cycle 在 `U` 内且 `∀ w ∉ U, n(γ,w)=0` | `IsNullHomologousIn γ U := γ.SupportedIn U ∧ …` | `isNullHomologousIn_iff`、`_zero`、`_add`（无条件） | 无 Mathlib 对应；`Set` 补集量词 + 本库 `SupportedIn` | `isNullHomologousIn_of_piecewiseC1_nullHomotopic` | 同上 |
| 相对同调 | 两 cycle 都在 `U` 内且域外指标相同 | `IsHomologousIn γ₁ γ₂ U := γ₁.SupportedIn U ∧ γ₂.SupportedIn U ∧ …` | `isHomologousIn_iff_windingNumber_eq` | 无 Mathlib 对应 | 后续残数定理／辐角原理的 cycle 前提 | 同上 |
| 连续端点相对同伦 | 固定端点的连续道路族 | Mathlib `Path.Homotopy` | 全像量词 `∀ z, pathHomotopySquare F z ∈ U` | Mathlib 正式承载 | 零同伦消费者 | `complex-analysis.path-integral.piecewise-c1-homotopy-invariance` |
| 全纯被积函数 | 开集上复可微 | `HolomorphicOnTextbook`（本库既有） | `holomorphicOnTextbook_iff_forall_differentiableAt` | 本库谓词；Mathlib `DifferentiableAt` 为桥 | `holomorphicOnTextbook_inv_sub` | `complex-analysis.holomorphic.definition` |

## 4. 公开签名四类归属

1. **语义一致的 Mathlib 正式公开承载**：`Path`、`Finsupp`／`Finsupp.linearCombination`、
   `curveIntegral` 及其 `_add`／`_smul`／`_neg`／`_trans`／`_symm`／`_refl`／`_cast`、
   `CurveIntegrable.trans/.symm`、`Path.Homotopy`、`ContinuousMap.HomotopyRel`。
2. **本库特殊定义的桥侧接口**：`ClosedPath`、`Cycle`、`Cycle.trace`／`PiecewiseC1`／`SupportedIn`／
   `Integrable`、`banachOneForm`、`BanachPathIntegrable`、`banachPathIntegral`、`cycleIntegral`、
   `windingNumber`、`IsNullHomologousIn`、`IsHomologousIn`；既有 `Path.PiecewiseC1` 与
   `HolomorphicOnTextbook` 同为桥侧。
3. **私有证明后端**：`Finsupp.mem_support_iff`／`sum_of_support_subset`、`Finset.sum_add_distrib`、
   `differentiableAt_id.sub_const`、`AdmissiblePath`（既有）、栅格同伦细分（既有）。
4. **超出课程层级的公开泄漏**：**无**。Banach carrier 只要求 `[NormedAddCommGroup F] [NormedSpace ℂ F]`，
   是路径积分自身的自然层级。

## 5. 定义链聚合 `#check` 与 Entry 声明映射

聚合文件 `/tmp/sandrones-library/check_WaveR1.lean` 同时 `import` 三个正式模块，`#check`
全部公开面并从 `banachOneForm` 到 `isNullHomologousIn_of_piecewiseC1_nullHomotopic` 串起完整
定义链，`lake env lean` 退出码 0（输出见 §10）。`#print axioms` 对
`banachOneForm`／`banachPathIntegral`／`cycleIntegral`／`windingNumber`／`IsNullHomologousIn`／
`IsHomologousIn`／`cycleIntegral_eq_zero_of_primitive`／`isNullHomologousIn_of_piecewiseC1_nullHomotopic`
均报 `[propext, Classical.choice, Quot.sound]`——涉及 ℝ 序结构（Playbook §3.3）的结构性 `choice`，
非本批新增形式化噪声。

`scripts.check_axioms.map_entry_to_decl` 现场结果（每 id 恰在一个文件）：

| Entry id | 文件 | 可审计公开声明数 |
|---|---|---|
| `complex-analysis.integral.banach-path-foundation` | `BanachPathIntegral.lean` | 15 |
| `complex-analysis.integral.finite-cycle-foundation` | `CycleCarrier.lean` | 23 |
| `complex-analysis.integral.winding-number-foundation` | `WindingIndex.lean` | 17 |

**核心定义未漏审**：三个模块只用 `abbrev/def/theorem/@[simp] theorem/protected theorem`，均在
`DECL_RE` 覆盖内；本批未引入 `instance`／`notation`／`class abbrev`／`deriving`／跨行 attribute，
故不触发冻结通知 §六 所述的 Main-side 审计器盲区。

## 6. 消费者放置说明（相对冻结原型的唯一增量）

冻结 §三列出的真实消费者
（`cycleIntegral_eq_zero_of_forall_piece_eq_zero`、`cycleIntegral_eq_zero_of_primitive`、
`holomorphicOnTextbook_inv_sub`、`cycleIntegral_eq_zero_of_piecewiseC1_nullHomotopic`、
`windingNumber_eq_zero_of_piecewiseC1_nullHomotopic`、`isNullHomologousIn_of_piecewiseC1_nullHomotopic`）
原在 `research_open` 的汇编原型 `check_D.lean`／`CycleFoundation.lean` 中。为满足 ROLE
"至少一个上层公开定理真实使用所选正式承载、不得建立无人使用的装饰别名"，本窗口把它们分配到
各自 Entry 的正式文件：

- `cycleIntegral` 的两个归零引理 → `CycleCarrier.lean`（`finite-cycle-foundation`）；
- 绕数域外归零与零同调消费者 → `WindingIndex.lean`（`winding-number-foundation`）。

这样每个 Entry id 的源码标记仍只出现在一个文件里（用 `map_entry_to_decl` 与
`subject_package` 的 semantics 门现场验证），且 `IsNullHomologousIn` 有了真实的非平凡实例。
未新增冻结面之外的公开载体，未改动任何冻结签名。

**文档修正**：内联原型中 `WindingIndex` 的模块注释仍是签名冻结**之前**的旧措辞（当时主张
"trace 排除"），与冻结后的 `SupportedIn` 合取定义不符。本窗口把该段改为准确表述：合取项是定义
的一部分、差形式被反例否决。

## 7. 验证记录（现场运行）

| 命令 | 结果 |
|---|---|
| `lake build SandronesLibrary.ComplexAnalysis.BanachPathIntegral SandronesLibrary.ComplexAnalysis.CycleCarrier SandronesLibrary.ComplexAnalysis.WindingIndex`（worktree 内） | **成功，2840 jobs**；无 error；仅 9 条 `linter.style.show` 警告（沿用冻结原型的 `show` 写法，与全库既有 linter 警告同类） |
| `lake env lean /tmp/sandrones-library/check_WaveR1.lean` | 退出码 0；完整定义链 `#check` + 8 条 `#print axioms` |
| `python3 scripts/subject_package.py --worktree … --base 7dffe37 --subject complex-analysis` | 见 §10 补记 |
| `git diff --check 7dffe37..HEAD` | 干净（cleanliness 门通过） |
| `df -h /`（构建前后） | 15–16G 可用，全程 ≥ 3G |

本窗口**未**运行全库 `lake build`（按 AGENTS §7，全库构建归 Main 集成阶段）。未运行
`lake update`／`lake exe cache get`；`.lake/packages` 已按要求符号链接到主工作树。

## 8. 子 Agent 与验收

本窗口未派子 Agent：批次只有 3 个 Lean 文件 + 3 篇文档，且三者共享冻结概念表与同一依赖闭包，
负责人直接实现并逐文件复核，避免同一 worktree 的 git index 与 `.lake/build` 单写者资源竞争。
所有数学陈述、前提、定义链、公开签名、Mathlib 角色与文档均由负责人本人逐条核对；无退回记录。

## 9. 给 Main 的共享文件变更建议（不在本分支修改）

- **`SandronesLibrary.lean`**：在现有 complex-analysis import 段（约 242–261 行）后追加
  `import SandronesLibrary.ComplexAnalysis.BanachPathIntegral`、`…CycleCarrier`、`…WindingIndex`
  （`WindingIndex` 已传递导入前两者，列全仅为与既有逐模块风格一致）。
- **`index/registry.json`** 新增 3 条（`axioms`／`proof_sha`／`dependedOnBy` 由生成器产生）：
  - `complex-analysis.integral.banach-path-foundation`，premises `[complex-analysis.integral.path]`，
    `provenance.ref = "ahlfors-complex-analysis-1979"`；
  - `complex-analysis.integral.finite-cycle-foundation`，premises
    `[complex-analysis.integral.banach-path-foundation, complex-analysis.path-integral.dyadic-assembly,
    complex-analysis.cauchy.primitive-from-path-independence-foundation, topology.homotopy.piecewise-c1-path]`；
  - `complex-analysis.integral.winding-number-foundation`，premises
    `[complex-analysis.integral.finite-cycle-foundation, complex-analysis.integral.path,
    complex-analysis.holomorphic.definition, complex-analysis.path-integral.piecewise-c1-homotopy-invariance]`。
  三篇 Entry 文档已按 id→叙述层路径规范落在 `docs/entries/complex-analysis/integral/<id>.md`。
- **`docs/ROADMAP-LONGTERM.md`**：§7 C2 表第 13 行 `complex-analysis.integral.finite-cycle-foundation`
  由"正式源码与 Entry 尚未提交"改为已交付；并补两行 `banach-path-foundation`、
  `winding-number-foundation`。§1 阶段表复分析仍 `C2🚧（C3⏸）`（本批是 C2 内的 cycle 载体，
  未关闭 C2，也未开 C3）。§Wave D D-1a 进展表 D1 由 `accepted_research` 改为 development 已交付。
- **`docs/MATHLIB-RADAR.md`**：建议为 `curveIntegral` 补"谁在用"——现在有
  `complex-analysis.integral.{banach-path-foundation,finite-cycle-foundation,winding-number-foundation}`
  三个消费者；并保留第 3420 行附近"Mathlib 无 `Complex.windingNumber`／残数"的记录。
- **`docs/LEAN-PLAYBOOK.md`**：暂无新教训需要固化（本批主要是复用 `curveIntegral` 与
  `Finsupp.linearCombination`，未踩新 tactic 坑）；若 Main 认可，可记录"无 `DecidableEq` 下标时用
  `mem_support_or` 取代 `Finsupp.support_add`"这一条。

## 10. 诚实边界与未完成

**本批已证**：Banach 值路径积分载体及其线性／拼接／反向／cast；有限 cycle 载体、逐片谓词、
ℤ-线性 cycle 积分及其展开／线性／支撑封闭；绕数的复值定义、ℤ-线性、单片公式；两个相对同调谓词、
展开刻画、零 cycle／加法封闭；`w ∉ U` 时 `(z-w)⁻¹` 全纯；零同伦 ⟹ cycle 积分／绕数为零 ⟹
零同调；求导沿 supported cycle 积分为零。

**本批未证，且不得写成已完成**：

- 绕数的整值性 `windingNumber γ w ∈ ℤ`（独立未证桥位）；
- `IsNullHomologousIn`／`IsHomologousIn` 与教材"同调"定义的**完全等价**（本批只给工作版本；差形式
  与链层面等价未证）；
- Laurent 级数、一般残数定理、辐角原理、Rouché；
- Dunford 值 `f(a)`、谱映射、谱投影、连续函数演算（属 F6.6b2／F8）；
- 任何第二套 cycle 或 Banach 值积分载体（公共 carrier 归本学科，D2 只消费）。

**保留的反例（不得删除）**：`trace (γ+δ) ⊆ trace γ ∪ trace δ` 的反向包含不成立。取闭路 `c`、
点 `w ∈ range c`、以 `w` 为圆心的小圆 `c'`，令 `γ := single c 1 + single c' 1`、`δ := single c (-1)`，
则 `γ + δ = single c' 1`，`trace (γ+δ)` 不含 `w` 而 `windingNumber (γ+δ) w = 1 ≠ 0`。这否决了
"差零同调"与"trace 排除"两种旧量词。

**下一批可稳定依赖的 API**：上面 §3 表格中三个 Entry 的公开声明即冻结面，D2 可消费
`banachOneForm`／`BanachPathIntegrable`／`banachPathIntegral`／`cycleIntegral`／`windingNumber`／
两个同调谓词及其引理。**不可依赖**：绕数整值性、同调完全等价、差形式谓词、任何残数／Laurent／
函数演算接口，以及尚未存在的"第二套载体"。

**subject_package 自检**：§1 的两提交后自检为 cleanliness／ownership／semantics／proof 四门
✅、coverage ❌（当时本 handoff 未提交）；本 handoff 提交后复跑结果补记如下。

## 11. subject_package 补记

命令：

```bash
python3 scripts/subject_package.py \
    --worktree /home/pisquare/czt/sandrones-library-complex-r1 \
    --base 7dffe37 --subject complex-analysis
```

在本 handoff 首次提交（其后的唯一改动是把本节文字回填，源码与 Entry 事实不变）上运行，
退出码 0：

```text
学科验收包 complex-analysis  (codex/complex-analysis-wave-r1 @ <handoff tip>)
  基线 7dffe37｜提交 3｜改动文件 7
  ✅ cleanliness
  ✅ ownership
  ✅ semantics
  ✅ proof
  ✅ coverage

  verdict: pass
```

异常清单为空。覆盖的 3 个新 Entry 的声明数与文件见 §5；三篇叙述层路径与 id 一致，均由
semantics 门确认。
