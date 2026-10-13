# Handoff — 泛函分析 Wave R1：F6.7 有界自伴／正／正规／酉算子关系

> 学科：functional-analysis｜角色：学科负责人（Wave R1 并行窗口）｜分支：`codex/functional-analysis-wave-r1`
> worktree：`/home/pisquare/czt/sandrones-library-functional-r1`
> 基线：`7dffe37`（派工硬规则固定）｜权限：`development_open`

## 1. 范围与提交

本批领取 ROADMAP §8 F6 的开放条目
`functional-analysis.operator.selfadjoint-positive-normal`（F6.7）。F1–F5 与 F6.6a／F6.6b1
已集成；F6.6b2 依赖复分析 cycle carrier（仍 `research_open`），F6.8 连续函数演算与 F6.9 谱测度
按 ROADMAP 继续冻结，F7–F8 锁定。F6.7 只依赖已集成的 Hilbert 伴随／酉算子层（F3.3、F3.5）与
Mathlib 的星代数接口，因此是本轮依赖已满足的下一批。

提交（`git log --oneline 7dffe37..HEAD`）：

| 提交 | 说明 |
|---|---|
| `0c2eda7` | `feat(functional-analysis): add F6.7 self-adjoint/positive/normal/unitary relations` |
| `6af29f5` | `docs(functional-analysis): fix F6.7 narrative overclaim and unused mathlib name` |
| `75d35d7` | `refactor(functional-analysis): trim F6.7 to relation API, drop rename-only re-exports` |

文件清单（均为新建，全部在学科所有权目录内）：

- `SandronesLibrary/FunctionalAnalysis/SelfAdjointPositiveNormal.lean`（源码）
- `docs/entries/functional-analysis/operator/selfadjoint-positive-normal.md`（叙述层初稿）
- 本文件 `docs/handoffs/functional-analysis-wave-r1.md`

**基线同步说明**：Main 在本批开工后前进了 `42b8784`（`docs(main): disk-driven window
concurrency`，纯 docs 提交，未改源码／Registry／ROADMAP 状态）。派工硬规则要求以 `7dffe37`
为工作树基线与 `subject_package --base`，故本批未 rebase；`7dffe37..42b8784` 不含影响本批的
源码或条目状态变化。

## 2. 条目与文件映射

| Entry id | kind | state | Lean 文件 | 叙述层 |
|---|---|---|---|---|
| `functional-analysis.operator.selfadjoint-positive-normal` | theorem | staging（待 Main 登记） | `FunctionalAnalysis/SelfAdjointPositiveNormal.lean` | `docs/entries/functional-analysis/operator/selfadjoint-positive-normal.md` |

- 叙述层路径 = `docs/entries/` + id 以 `.` 分段（通过 `subject_package.py` 的 id→叙述层路径规范检查）。
- 一个 id 只对应一个 Lean 文件；该文件只有这一个 `> **Entry**` 标记。
- `provenance.ref = buehler-salamon-functional-analysis-2018`（已在 `reference.bib` 定义，
  教材 Bühler–Salamon, *Functional Analysis*, AMS GSM 191, 2018，第 5 章）。**无需新增 BibTeX key。**

## 3. 核心概念清单（六列表）

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 有界自伴算子 | `T = T*` | `IsSelfAdjoint T`（`star T = T`） | `isSelfAdjoint_iff_inner_symm` | 语义一致的正式公开承载；`star T = T†`（`ContinuousLinearMap.star_eq_adjoint`） | `selfAdjoint_isStarNormal`、`isSelfAdjoint_unitary_mul_self` | 本 Entry |
| 正算子 | `T=T*` 且 `∀x, ⟪Tx,x⟫≥0` | `ContinuousLinearMap.IsPositive T` | `isPositive_iff_selfAdjoint_inner_nonneg` | 语义一致的正式公开承载（`isPositive_iff'` 在完备空间与教材定义等价） | `positive_isSelfAdjoint`、`positive_isStarNormal` | 本 Entry |
| 正规算子 | `T T* = T* T` | `IsStarNormal T` | `isStarNormal_iff_adjoint_commute`、`isStarNormal_iff_norm_adjoint` | 语义一致的正式公开承载；`star T = T†` 给出交换／范数形式 | `isStarNormal_ker_adjoint`、`isStarNormal_range_orthogonal_ker` | 本 Entry |
| 酉算子 | 等距满射 ⇔ `U*U=UU*=1` | `unitary (E →L[𝕜] E)` 子群 | `unitary_adjoint_eq_inv` | 语义一致的正式公开承载；与 F3.5 `E ≃ₗᵢ[𝕜] E` 经 `Unitary.linearIsometryEquiv` 同构，`linearIsometryEquiv_mem_unitary` 给出桥；等距性由 Mathlib `Unitary.inner_map_map`／`norm_map` 与 F3.5 承载 | `unitary_isStarNormal`、`isSelfAdjoint_unitary_mul_self` | 本 Entry |
| 幂等算子（关系特例） | `T² = T` | `IsIdempotentElem T` | `idempotent_selfAdjoint_iff_isStarNormal` | 语义一致的正式公开承载；自伴与正规在幂等类上等价 | `idempotent_selfAdjoint_iff_isStarNormal` | 本 Entry |

普通载体 `E →L[𝕜] E`、`inner`、算子复合、`star` 已在既有 F1–F6 条目解释，不重复登记。
本批**没有新增 `def`／`structure`／`abbrev`**；所有正式承载均为 Mathlib 成熟接口的直接复用。

## 4. 公开签名四类扫描

本批新增公开声明全部是定理，无 `instance`、无公开 Mathlib 越级泄漏。签名中出现的 Mathlib 专用名归类：

1. **语义一致的正式公开承载**：`IsSelfAdjoint`、`ContinuousLinearMap.IsPositive`、`IsStarNormal`、
   `unitary`、`E ≃ₗᵢ[𝕜] E`、`IsIdempotentElem`。文档逐项说明量词、类型类假设与展开。
2. **本库桥侧接口**：`linearIsometryEquiv_mem_unitary`（连接 F3.5 `LinearIsometryEquiv` 与
   Mathlib `unitary`，方向：线性等距等价 ⟹ 酉元素）。语义无差异，故不建新 `def`。
3. **私有证明后端**：`ContinuousLinearMap.star_eq_adjoint`、`Unitary.star_eq_inv` 等，
   只在证明体内使用；已在模块文档中披露。
4. **越级泄漏**：无。本批只要求 `[RCLike 𝕜]` 与 `[CompleteSpace E]`，不要求 `CStarAlgebra`、
   `Fredholm`、`Measure` 等超出课程层级的结构。

未自动选择任何全局实例：源码未声明实例，也未通过 `attribute` 注入实例。

## 5. 定义链聚合 `#check`

聚合文件（`/tmp/sandrones-library/aggregate_f67.lean`）同时导入本批模块与 F3.3／F3.5 模块，
对“正式承载 → 展开／刻画 → 桥 → 上层使用者”逐项 `#check`，退出码 0：

- 正式承载：`IsSelfAdjoint`、`ContinuousLinearMap.IsPositive`、`IsStarNormal`、`unitary`、
  `ContinuousLinearMap.star_eq_adjoint`、`Unitary.linearIsometryEquiv`；
- 本批 14 个公开定理（见 §6）；
- 既有接口连接：`eq_adjoint_iff_inner_transfer`、`norm_adjoint_eq`、`unitary_adjoint_eq_inverse`。

## 6. Entry 声明映射

用 `scripts.check_axioms.map_entry_to_decl` 对源码做映射检查：id
`functional-analysis.operator.selfadjoint-positive-normal` 关联 14 个公开声明（无漏审、无跨文件）：

```
isSelfAdjoint_iff_inner_symm, isPositive_iff_selfAdjoint_inner_nonneg, positive_isSelfAdjoint,
isStarNormal_iff_adjoint_commute, isStarNormal_iff_norm_adjoint, isStarNormal_ker_adjoint,
isStarNormal_range_orthogonal_ker, selfAdjoint_isStarNormal, positive_isStarNormal,
idempotent_selfAdjoint_iff_isStarNormal, unitary_isStarNormal, unitary_adjoint_eq_inv,
isSelfAdjoint_unitary_mul_self, linearIsometryEquiv_mem_unitary
```

初版文件含 19 个定理，其中 5 个是纯改名再导出（`isSelfAdjoint_iff_adjoint_eq`＝`isSelfAdjoint_iff'`
的 `Iff.rfl`、`selfAdjoint_adjoint_eq`、`positive_inner_nonneg`、`mem_unitary_inner_map_map`、
`mem_unitary_norm_map`），已按独立审核意见删除（提交 `75d35d7`），只保留课程关系 API、展开刻画与桥。
被删事实在 Mathlib／F3.5 中已有承载并在叙述层说明，不丢失课程内容。

## 7. 公理与占位审计

- 禁用占位扫描：源码无 `sorry`／`admit`／`sorryAx`／`native_decide`（`subject_package` proof 门）。
- `#print axioms`（本批 13 个代表定理，`/tmp/sandrones-library/axioms_f67.lean`，退出码 0）均报告
  `[propext, Classical.choice, Quot.sound]`。其中 `Classical.choice` 是 `RCLike`／内积空间／ℝ-序
  实例的**结构性**公理（Playbook §3.3：`ℝ` 序实例定义体本身带 choice），非本批引入的新数学公理。
  与既有 F3.3／F3.5 条目一致。正式 `axioms` 字段由 Main 在登记后用
  `scripts/check_axioms.py --all --fix` 生成。

## 8. 已运行的验证命令

| 命令 | 结果 |
|---|---|
| `lake build SandronesLibrary.FunctionalAnalysis.SelfAdjointPositiveNormal` | ✅ 8716 jobs，无本文件 warning（修掉 unused section variable） |
| `lake env lean /tmp/sandrones-library/aggregate_f67.lean` | ✅ 退出码 0，全部 `#check` 通过 |
| `lake env lean /tmp/sandrones-library/axioms_f67.lean` | ✅ 退出码 0，公理集如 §7 |
| `git diff --check` | ✅ 干净 |
| `python3 scripts/subject_package.py --worktree ... --base 7dffe37 --subject functional-analysis` | 见 §10（交付前自检） |

学科不运行全库 `lake build`；全库构建由 Main 在集成阶段统一执行。

## 9. 子 Agent 所有权与负责人审核

- 本批只有 1 个可交付 Entry，采用**负责人自持源码**、两个**只读独立审核子 Agent**：
  - 子 Agent A（`4f8c1aac-…`）审核 Lean 源码陈述忠实性、重复度、类型类假设、占位与泄漏；
    结论：数学陈述忠实、类型类假设正确、卫生与边界通过；**发现** 19 条定理中 13 条是 Mathlib
    逐字改名再导出，真正新胶水 6 条，另有与 F3.5 的双载体平行 API。
  - 子 Agent B（`bc43fd48-…`）审核叙述层语义回译、front matter、premises、边界诚实性；
    结论：premises／provenance／边界／staging 均通过；**发现** 未使用的 `ContinuousLinearMap.adjoint_adjoint`
    被误列为“本条目使用”，以及“恰好等价于核与伴随核一致”属 overclaim。
- 两个子 Agent 均只读，未写 worktree，未参与验收；负责人逐条核对并修复（见 §11）。

## 10. subject_package 自检

命令：

```bash
python3 scripts/subject_package.py \
  --worktree /home/pisquare/czt/sandrones-library-functional-r1 \
  --base 7dffe37 --subject functional-analysis
```

结果：见交付末尾补记（verdict 与五组门明细）。

## 11. 负责人审核发现与处理

| 来源 | 发现 | 处理 | 提交 |
|---|---|---|---|
| 子 Agent A | 5 条纯改名再导出（`isSelfAdjoint_iff_adjoint_eq`＝`Iff.rfl`、`selfAdjoint_adjoint_eq`、`positive_inner_nonneg`、`mem_unitary_inner_map_map`、`mem_unitary_norm_map`）无课程增量 | 删除；保住的关系 API/刻画/桥改由 Mathlib 与 F3.5 承载并在叙述层说明 | `75d35d7` |
| 子 Agent A | 与 F3.5 `UnitaryOperator.lean` 双载体平行：`unitary_adjoint_eq_inv` vs `unitary_adjoint_eq_inverse` | 保留：载体不同（`unitary` 子群 + 一般 `RCLike` vs `E ≃ₗᵢ[ℝ] F`），且具一般标量域；已在模块与叙述层披露 | `75d35d7` |
| 子 Agent A | 保留的 8 条关系定理亦为 Mathlib 单引理出口 | 接受：ROADMAP F6.7 的交付即“四类算子的关系”，这些出口构成课程层公开 API；模块文档逐条解释教材语义，非无解释挂靠 | — |
| 子 Agent B | 叙述层 front matter／§依赖 误列未使用的 `ContinuousLinearMap.adjoint_adjoint` | 删除该名（正文与 `mathlib` 列表） | `6af29f5` |
| 子 Agent B | “正规恰好等价于核与伴随核一致”是 overclaim；“值域与核的正交分解”偏强 | 改为“蕴含”，注明反向不成立；改为“值域的正交补恰是核”，不再声称直和分解 | `6af29f5` |
| 负责人 | `positive_inner_nonneg` 的 `omit ... in` 位置与 docstring 冲突导致解析错误 | 改为 `omit` 在 docstring 之前；该定理随后按上表删除 | 构建期修复 |

## 12. 共享文件更新建议（Main 执行，学科不直接修改）

- `SandronesLibrary.lean`：新增 `import SandronesLibrary.FunctionalAnalysis.SelfAdjointPositiveNormal`。
- `index/registry.json`：登记 Entry `functional-analysis.operator.selfadjoint-positive-normal`，
  `lean_file: FunctionalAnalysis/SelfAdjointPositiveNormal.lean`，
  `premises: [functional-analysis.hilbert.adjoint, functional-analysis.hilbert.unitary]`，
  `provenance.ref: buehler-salamon-functional-analysis-2018`，`axioms`／`proof_sha` 由生成器产出。
- `docs/ROADMAP-LONGTERM.md`：F6 表的第 7 行标记为已集成；F6.7 从 🚧 移至 ✅（F6.8–F6.10 仍冻结／待门）。
- `docs/MATHLIB-RADAR.md`：建议为正式承载 `IsSelfAdjoint`、`ContinuousLinearMap.IsPositive`、
  `IsStarNormal`、`unitary` 增加“谁在用”段落（本 Entry 的关系链定理与幂等特例）。
- `reference.bib`：**无需新增**（复用既有 key）。
- `docs/entries/README.md`、`index/rankings.json`、`docs/entries/RANKINGS.md`：由 Main 生成器重建。

## 13. 下一批的稳定依赖与未完成边界

**可稳定依赖**（本批公开、已编译、有教材解释）：

- `isSelfAdjoint_iff_inner_symm`；
- `isPositive_iff_selfAdjoint_inner_nonneg`、`positive_isSelfAdjoint`、`positive_isStarNormal`；
- `isStarNormal_iff_adjoint_commute`、`isStarNormal_iff_norm_adjoint`、
  `isStarNormal_ker_adjoint`、`isStarNormal_range_orthogonal_ker`、`selfAdjoint_isStarNormal`；
- `unitary_isStarNormal`、`unitary_adjoint_eq_inv`、`isSelfAdjoint_unitary_mul_self`、
  `linearIsometryEquiv_mem_unitary`；
- `idempotent_selfAdjoint_iff_isStarNormal`。

**不可依赖／未完成**：

- 正规算子的谱定理与正交对角化、连续函数演算（F6.8）、投影值测度／有界正规谱定理（F6.9）均未触及；
  本批只给算子类的关系与刻画。
- F6.6b2（Dunford 积分组装）仍 `research_open`，等待复分析 finite-cycle carrier 进入 Main。
- F6.10 Gelfand 谱入口未开工。
- F7 无界算子、F8 半群仍锁定。
- 本批使用赋范算子上的二次型非负性 `ContinuousLinearMap.IsPositive`，**未**建立与
  `CStarAlgebra` 元素偏序的联系。

## 14. Playbook 教训（建议登记，由 Main 决定）

1. **`RCLike` 的序实例是 scoped**：一般 `𝕜` 上的 `0 ≤ z`（`z : 𝕜`）需要
   `open scoped ComplexOrder`，否则 `synthInstanceFailed: LE 𝕜`。`Mathlib.Analysis.InnerProductSpace.Positive`
   自身即如此打开。
2. **内积记法在本库环境下应写 `inner 𝕜 x y`**：`⟪x, y⟫_𝕜` 在 `open scoped InnerProduct` 下对
   一般 `RCLike 𝕜` 解析不稳定（解析错误并注入 `sorry` 占位），显式 `inner 𝕜` 稳定。既有
   `AdjointOperator.lean` 亦使用 `inner ℝ`。
3. **点记法误选泛型引理**：`hT.isSelfAdjoint_iff_isStarNormal`（`hT : IsIdempotentElem T`）会解析到
   C⋆-代数版本并要求 `Module ℂ (E →L[𝕜] E)` 而失败；须用全限定
   `ContinuousLinearMap.IsIdempotentElem.isSelfAdjoint_iff_isStarNormal hT`。
4. **`omit ... in` 必须写在 docstring 之前**：`/-- ... -/ omit ... in theorem` 报
   `unexpected token 'omit'`；正确顺序是 `omit ... in` 紧接声明、docstring 在其中。
