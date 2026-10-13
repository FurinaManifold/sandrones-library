# RA-F1 有符号测度／Jordan 分解／正负与全变差／复测度 正式交接

- entries（4 条，1 Entry ↔ 1 Lean 文件）：
  - `real-analysis.signed-measure.definition`
  - `real-analysis.signed-measure.variation`
  - `real-analysis.signed-measure.jordan-decomposition`
  - `real-analysis.signed-measure.complex`
- branch：`codex/real-analysis`
- synced Main / 基线：`a621303`（建 worktree 时 Main 尖端；本批未 rebase，开工时 `git log` 现场核对）
- gate：`development_open`（ROADMAP D5 行标 🚧 可开工）
- formal sources（4 个新文件，未改任何既有 `RealAnalysis/*.lean`）：
  - `SandronesLibrary/RealAnalysis/SignedMeasureDefinition.lean`
  - `SandronesLibrary/RealAnalysis/SignedMeasureVariation.lean`
  - `SandronesLibrary/RealAnalysis/SignedMeasureJordan.lean`
  - `SandronesLibrary/RealAnalysis/SignedMeasureComplex.lean`
- documents：`docs/entries/real-analysis/signed-measure/{definition,variation,jordan-decomposition,complex}.md`
  + 本 handoff
- 未改任何 Main 共享文件（仅在本 handoff 给建议）
- 本批交付 commit：`f856e0f`（4 Lean + 4 Entry 草稿 + 本 handoff）；
  紧随其后另有仅更新本 handoff 中该 commit 号的文档提交

## 1. 依赖门（路线问题 1）

RA-F1 的开工门是“正测度与积分主线已验收”（R1–R4，Main 已登记）。本批**不新开门**，而是完成
RA-F1 自身出口“四类概念均有正式承载、教材解释、展开性质和必要桥”。本批只暴露两个接入既有一维
正测度主线的入口：`Measure.toSignedMeasure`（有限正测度 → 有符号测度）与
`SignedMeasure.totalVariation : Measure α` 的 `IsFiniteMeasure` 实例。**RA-F2**（绝对连续、
互奇异一般理论、Lebesgue 分解、Radon–Nikodym）仍 🚧，本批任何文件都没有实现或宣称它完成。

## 2. 公共定义所有权与 Mathlib 角色（路线问题 2）

- 公共定义层单一拥有者：`SignedMeasureDefinition.lean`。它定义 `IsPositiveSet`、`IsNegativeSet`、
  `IsNullSet`（课程 `∀` 量词）及其与 Mathlib 限制序的桥；`SignedMeasureVariation/Jordan/Complex`
  只消费、不重复定义，避免重复结构与跨文件 Entry。
- **直接复用的 Mathlib 正式承载**（语义一致的推荐做法，不重造同构定义）：
  `MeasureTheory.SignedMeasure`（= `VectorMeasure α ℝ`）、`MeasureTheory.JordanDecomposition`、
  `MeasureTheory.ComplexMeasure`（= `VectorMeasure α ℂ`）、`SignedMeasure.totalVariation`、
  `VectorMeasure.variation`、`ComplexMeasure.re/im`、`Measure.toSignedMeasure`。
- **本库桥侧接口**：`IsPositiveSet`/`IsNegativeSet`/`IsNullSet` ↔ `0 ≤[i] ·`/`· ≤[i] 0`；
  `totalVariation_eq_variation`（Jordan 和 ↔ sup-over-partitions）；
  `jordan_decomposition_iff`；`complexMeasure_re_add_im`。
- **私有证明后端**：`VectorMeasure.of_union/of_sdiff/of_compl/m_iUnion/of_biUnion_finset/
  tendsto_vectorMeasure_iUnion_atTop_nat`、`SignedMeasure.exists_compl_positive_negative`、
  `SignedMeasure.norm_le_totalVariation`、`SignedMeasure.null_of_totalVariation_zero`、
  `ComplexMeasure.re_apply/im_apply`、`Complex.re_add_im`。
- **越级公开泄漏**：无。`variation` 需要 `ENormedAddCommMonoid ℝ` 实例，但该实例只在 `s.variation`
  的内部类型类合成中出现，未进入本库公开签名的假设。

## 3. 概念冻结表

| 概念 | 教材语义（Folland 2nd ed. §3.1） | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|---|
| 有符号测度 | 实值 σ-可加集函数，`ν(∅)=0` | `MeasureTheory.SignedMeasure α` | `signedMeasure_empty/union/sdiff/compl/iUnion/iUnion_finset/tendsto_iUnion` | 语义一致，直接复用 `VectorMeasure α ℝ` | `IsPositiveSet.iUnion`、`exists_hahnDecomposition` | definition |
| 正集／负集／零集 | 可测集，其可测子集上 `ν ≥ 0`／`≤ 0`／`= 0` | 本库 `IsPositiveSet`/`IsNegativeSet`/`IsNullSet` | 量词展开；`isPositiveSet_iff_zero_le_restrict` 等 | Mathlib 无具名谓词，用限制序作桥 | `IsPositiveSet.iUnion`、`exists_hahnDecomposition` | definition |
| 正测度 → 有符号测度 | 有限正测度视为有符号测度 | `Measure.toSignedMeasure` | `measure_toSignedMeasure_apply_measurable` | 接入 R4 主线的入口桥 | `variation`/`jordan` 的下游 | definition |
| 正变差／负变差 `ν⁺,ν⁻` | Jordan 正／负部，互奇异有限测度 | `JordanDecomposition.posPart`/`negPart` | `totalVariation_eq_posPart_add_negPart` | 语义一致，直接复用 | `abs_apply_le_totalVariation` | variation |
| 全变差 `｜ν｜` | `ν⁺+ν⁻`；也等于 `sup Σ｜ν(Eⱼ)｜` | `SignedMeasure.totalVariation` + `VectorMeasure.variation` | `totalVariation_apply`；桥 `totalVariation_eq_variation` | 语义一致；`variation` 是 sup 版本 | `abs_apply_le_totalVariation`、`null_of_totalVariation_zero` | variation |
| Jordan 分解 | 唯一 `ν = ν⁺ − ν⁻`，两部分互奇异 | `JordanDecomposition` + `toJordanDecomposition`/`toSignedMeasure` | `jordan_toSignedMeasure_eq_posPart_sub_negPart`、`jordan_apply_eq_posPart_real_sub_negPart_real` | 语义一致，直接复用；桥 `jordan_decomposition_iff` | `jordan_decomposition_unique'`、`jordan_exists_hahnDecomposition` | jordan-decomposition |
| 复测度 | ℂ-值 σ-可加集函数 | `MeasureTheory.ComplexMeasure α` | `complexMeasure_re_add_im` | 语义一致，直接复用 `VectorMeasure α ℂ` | `complexMeasure_eq_zero_iff`、`complexMeasure_ext` | complex |
| 复测度实／虚部 | `ν = ν_r + i ν_i`，各为有符号测度 | `ComplexMeasure.re`/`im` | `complexMeasure_re_apply`/`im_apply` | 直接复用线性映射 | `complexMeasure_toComplexMeasure_re_im` | complex |

## 4. 公开签名扫描（四类归属）

- **第 1 类（语义一致的正式承载）**：`SignedMeasure`、`VectorMeasure`、`JordanDecomposition`、
  `Measure`、`IsFiniteMeasure`、`ComplexMeasure`、`ComplexMeasure.re/im`、`SignedMeasure.totalVariation`、
  `VectorMeasure.variation`、`SignedMeasure.toJordanDecomposition`、`JordanDecomposition.toSignedMeasure`、
  `SignedMeasure.toComplexMeasure`、`ComplexMeasure.equivSignedMeasure`。各 Entry 文档均给出教材
  定义、量词与类型类假设。
- **第 2 类（本库特殊定义的桥）**：`IsPositiveSet`/`IsNegativeSet`/`IsNullSet` 及其 `iff` 桥
  （课程量词 ↔ Mathlib 限制序）；`totalVariation_eq_variation`；`jordan_decomposition_iff`；
  `complexMeasure_re_add_im`、`complexMeasure_toComplexMeasure_re_im`。
- **第 3 类（私有证明后端）**：见第 2 节；它们只在证明体内出现，未成为课程公开概念。
- **第 4 类（越级公开泄漏）**：无。没有引入泛函分析级结构、没有无故要求高阶类型类。
- 无全局 `instance` 声明、无冲突标记、无 `sorry`/`admit`/`sorryAx`/`native_decide`。

## 5. 定义链聚合与 Entry 声明映射（路线问题 4）

聚合文件 `/tmp/sandrones-library/RA_F1_Aggregate.lean` 联合导入 4 个模块，并同时 `#check`
每一概念的“正式承载 → 展开／刻画 → 必要的桥 → 上层使用者”：
- 承载：`MeasureTheory.SignedMeasure/JordanDecomposition/ComplexMeasure`、`totalVariation`、
  `JordanDecomposition.posPart/negPart`；
- 展开：`signedMeasure_empty/union/iUnion/tendsto_iUnion`、`IsPositiveSet/IsNegativeSet/IsNullSet`、
  `totalVariation_eq_posPart_add_negPart/apply`、`jordan_*_eq_posPart_*`、`complexMeasure_re_add_im/re_apply`；
- 桥：三条 `is*Set_iff_*`、`measure_toSignedMeasure_*`、`totalVariation_eq_variation、
  totalVariation_univ_lt_top`、`jordan_decomposition_iff/equiv`、`complexMeasure_*_toComplexMeasure`、
  `complexMeasure_equiv_signedMeasure`；
- 使用者：`exists_hahnDecomposition`、`IsPositiveSet/IsNegativeSet.iUnion`、
  `abs/enorm_apply_le_totalVariation`、`null_of_totalVariation_zero`、`totalVariation_union`、
  `jordan_decomposition[_unique/_unique'/exists_hahnDecomposition]`、
  `complexMeasure_apply_toComplexMeasure/eq_zero_iff/ext/apply_eq_zero_iff`。
命令 `lake env lean /tmp/sandrones-library/RA_F1_Aggregate.lean` 退出码 0，全部 `#check` 通过；
`#print axioms` 取 `IsPositiveSet.iUnion`、`abs_apply_le_totalVariation`、
`jordan_decomposition_unique'`、`complexMeasure_apply_eq_zero_iff`，四者均仅含
`propext`、`Classical.choice`、`Quot.sound`。

Entry 声明映射（用 `scripts/check_axioms.py` 的 `map_entry_to_decl` 现场运行）：
- `definition` → 23 个声明；`variation` → 11；`jordan-decomposition` → 11；`complex` → 11。
- 每个文件只映射到唯一 Entry，无跨文件吸入；`def`（`IsPositiveSet` 等、两个 `≃`）均被
  `DECL_RE`（`theorem|lemma|def|abbrev|structure|class|inductive|opaque`）识别，**无声明类型盲区**。
- Markdown id、源码 `> **Entry**:` 标记、拟登记 Registry id、唯一 `lean_file` 四者一致。

## 6. 子 Agent 所有权、提交与退回（路线问题 3）

公共定义层（`SignedMeasureDefinition.lean`）由负责人亲自撰写并 `lake build` 冻结（8706 jobs，exit 0），
之后才派生 3 个 depth-2 子 Agent，文件所有权互不重叠：

| 子 Agent | 所有权（.lean + doc） | 自验证 | 负责人复核结果 |
|---|---|---|---|
| `d50ac1d7`（variation） | `SignedMeasureVariation.lean` + `variation.md` | `lake env lean` exit 0 | 数学/声明通过；**退回 2 处并已就地修复**：① 头注释误写 “Folland RA-F2” → “RA-F1”；② `totalVariation_union` 用无效的 `have _ : MeasurableSet (A∪B)` 消除 unused 变量，改为真用 `hA` 的对称证明（并保留 `hB` 为冗余假设，重命名 `_hB` 消除 warning）。 |
| `ba572142`（jordan） | `SignedMeasureJordan.lean` + `jordan-decomposition.md` | `lake env lean` exit 0 | 11 条声明与文档通过；两处实现偏差（全限定名、显式单射版本）合理，无需返工。 |
| `f9a11d81`（complex） | `SignedMeasureComplex.lean` + `complex.md` | `lake env lean` exit 0 | 数学/声明通过；**退回 1 处并已就地修复**：头注释误写 “Folland RA-F2 的一部分” → “RA-F1”；另修正 `complexMeasure_ext` 长行 warning。 |

子 Agent 未做任何 git 写操作、未跑 `lake build`，未碰其它文件；所有 `lake build` 与
`git add/commit` 由负责人串行执行。子 Agent 报告不作为验收，以上结论均经负责人重新编译与逐条复核。

## 7. 验证命令与结果（原文）

- `lake build SandronesLibrary.RealAnalysis.SignedMeasureDefinition SandronesLibrary.RealAnalysis.SignedMeasureVariation SandronesLibrary.RealAnalysis.SignedMeasureJordan SandronesLibrary.RealAnalysis.SignedMeasureComplex`
  → `Build completed successfully (8709 jobs)`，exit 0，无 warning（修掉 long-line 与 unused 后）。
  单模块：Definition `8706 jobs`、Variation `8707 jobs`，均 exit 0。
- `lake env lean /tmp/sandrones-library/RA_F1_Aggregate.lean` → exit 0，全部 `#check` 输出如上；
  4 项 `#print axioms` 均为 `[propext, Classical.choice, Quot.sound]`。
- `map_entry_to_decl`：4 文件分别映射 23/11/11/11 个声明，无跨文件吸入。
- `grep -rn "sorry\|admit\|sorryAx\|native_decide"` → 无命中；冲突标记 → 无；全局 `instance` → 无。
- `git diff --check`（暂存后 `git diff --cached --check`）→ 干净；结束时 `git status --short` 为空。
- 磁盘：构建前后 `df -h /` 均为约 11G 可用，未触 3G 下限；未跑 `lake update`/`cache get`，
  `.lake/packages` 符号链接未动。

## 8. 下一批可依赖／不可依赖（路线问题 5）

**可稳定依赖（已编译、签名冻结）**：
- `SandronesLibrary.RealAnalysis.SignedMeasure` 命名空间下的全部公开声明：
  `SignedMeasure α` 恒指 `MeasureTheory.SignedMeasure α`；`IsPositiveSet/IsNegativeSet/IsNullSet`
  及其桥；`exists_hahnDecomposition`；`measure_toSignedMeasure_apply_measurable`；
  `totalVariation_eq_variation`、`totalVariation_apply`、`abs/enorm_apply_le_totalVariation`、
  `totalVariation_univ_lt_top`；`jordan_decomposition`、`jordan_decomposition_iff`、
  `jordan_decomposition_unique'`；`complexMeasure_re_add_im`、`complexMeasure_equiv_signedMeasure`。

**明确不可依赖（未完成／未冻结）**：
- RA-F2 全部：绝对连续、互奇异一般理论（`⟂ₘ` 的一般判据）、Lebesgue 分解、Radon–Nikodym；
- 复测度全变差**有限性**：`IsFiniteMeasure (c.variation)` 在当前 Mathlib 未注册（实测
  `synthInstanceFailed`），本批未提供该实例；
- 取值 ±∞ 的扩展有符号测度、Banach 空间值向量测度的一般理论；
- 本批未运行全库 `lake build`（属 Main）。

## 9. Main 更新建议（路线问题 6）

- 顶层 imports（加入 `SandronesLibrary.lean`）：
  - `import SandronesLibrary.RealAnalysis.SignedMeasureDefinition`
  - `import SandronesLibrary.RealAnalysis.SignedMeasureVariation`
  - `import SandronesLibrary.RealAnalysis.SignedMeasureJordan`
  - `import SandronesLibrary.RealAnalysis.SignedMeasureComplex`
- Registry：新增 4 条 Entry，`lean_file` 分别为 `RealAnalysis/SignedMeasureDefinition.lean`、
  `RealAnalysis/SignedMeasureVariation.lean`、`RealAnalysis/SignedMeasureJordan.lean`、
  `RealAnalysis/SignedMeasureComplex.lean`；`premises` 见下；`provenance.ref` 均为
  已存在的 `"folland-real-analysis-1999"`；`mathlib` 由各 Entry front matter 提供（只列真实名称）。
  - `real-analysis.signed-measure.definition`：premises `[]`
  - `real-analysis.signed-measure.variation`：premises `[real-analysis.signed-measure.definition]`
  - `real-analysis.signed-measure.jordan-decomposition`：premises `[real-analysis.signed-measure.definition]`
  - `real-analysis.signed-measure.complex`：premises `[real-analysis.signed-measure.definition]`
- RADAR：登记 `MeasureTheory.SignedMeasure`、`MeasureTheory.JordanDecomposition`、
  `MeasureTheory.ComplexMeasure`、`SignedMeasure.totalVariation`、`VectorMeasure.variation`
  为“已正式承载（教材解释见对应 Entry）”。
- ROADMAP §6：RA-F1 行由 🚧 推进到“本批交付、待 Main 验收”（验收通过后按 Main 流程置 ✅）；
  RA-F2 保持 🚧，不在本批开门。
- 文献：无需新增 `reference.bib` 条目（Folland 2nd ed. 已存在）。若 Main 想补 Folland §3.1–3.2
  的章节定位，写在 Entry 正文，不新增 BibTeX。

## 10. 诚实边界与未完成项

- 只做**有限、实值／复值**有符号测度与复测度；±∞ 扩展值情形不在本批。
- 四类概念的“必要桥”只到达 `Measure.toSignedMeasure` 与 `totalVariation : Measure α` 这一层；
  与既有 R4 主线的更深入桥（如由密度构造、绝对连续）属 RA-F2，未做。
- 复测度全变差有限性未注册（见 §8），文档已如实披露，未把它写成已证结论。
- 子 Agent 的 Lean 仅以只读 `lake env lean` 自检；正式 `lake build` 与全部验收由负责人串行完成。
- 本批未运行全库 `lake build`、未运行 `audit.py --all`、未改 Registry/RADAR/ROADMAP/共享文档；
  这些是 Main 集成职责。
