# Main review: real-analysis RA-F1 signed measures

- branch: `codex/real-analysis`
- reviewed_commit: `f856e0f`（源码）与 `ef88ec4`（handoff 回填）；`git status --short` 为空
- reviewer: main
- verdict: `accepted`
- reviewed_at: 2026-10-13

## 已通过

**范围与权限。** 本批对应 Wave D **D5**（RA-F1，`development_open` 等效）。交付为 9 个新增文件，
全在学科所有权内；未触碰任何 Main 共享文件。四个 Entry id 与四个 Lean 文件**一一对应**，Main 用
全库扫描独立确认**每个 id 只出现在自己文件里**——这正是我在 D1 派工里警告过的坑
（`linear-algebra.matrix.normal`、`abstract-algebra.poly.irreducible` 两个 id 跨文件），
本批没有重犯。

**四类概念的覆盖。** ROADMAP 对 RA-F1 的出口要求是"四类概念均有正式承载、教材解释、展开性质
和必要桥"，Main 逐类核对：

- **有符号测度**：正式承载直接复用 `MeasureTheory.SignedMeasure α = VectorMeasure α ℝ`，
  语义与教材"取实值、空集取零的 σ-可加集函数"一致。这是 Playbook 推荐的"语义一致就直接复用"，
  没有为制造本库名称重造同构结构。展开性质（空集零、非可测集零、有限可加、差集、补集、可数可加、
  有限并、下连续）齐备，且都附了前提（可测性、不交性），没有把前提静默省略。
- **正／负／全变差**：`totalVariation_eq_posPart_add_negPart`、`totalVariation_eq_variation`（到
  sup-over-partitions 定义的桥）、`totalVariation_univ_lt_top`、`null_of_totalVariation_zero`、
  `abs_apply_le_totalVariation`／`enorm_apply_le_totalVariation` 形成"承载→展开→桥→使用者"闭环。
- **Jordan 分解**：`jordan_decomposition` 存在性、`jordan_decomposition_unique` 与
  `jordan_decomposition_unique'` 唯一性、逐点 `jordan_apply_eq_posPart_real_sub_negPart_real`、
  双向构造 `toSignedMeasure`／`toJordanDecomposition`，并由此得到
  `jordan_decomposition_equiv : SignedMeasure α ≃ JordanDecomposition α`。Main 核对了
  `SignedMeasure.toSignedMeasure_injective` 确实是单射性来源，`≃` 不是硬凑的。
- **复测度**：`ComplexMeasure` 承载、`complexMeasure_re_add_im` 重构、`re`／`im` 到有符号测度的桥、
  `complexMeasure_equiv_signedMeasure` 与 `eq_zero_iff`／`ext` 使用者。

**课程量词与桥（本批真正的本库增量）。** `IsPositiveSet`／`IsNegativeSet`／`IsNullSet` 用显式
`∀` 量词按 Folland 3.1 陈述，而不是把 Mathlib 的限制序 `0 ≤[i] s` 当作定义——这一点很重要：
课程需要展示量词。桥 `isPositiveSet_iff_zero_le_restrict`、`isNegativeSet_iff_restrict_le_zero`
方向清楚且双向，`isNullSet_iff_isPositiveSet_and_isNegativeSet` 的数学也正确。Main 独立复核了
`IsPositiveSet.iUnion`／`IsNegativeSet.iUnion`：它们是**真实证明**（`disjointed` 不交化 +
`hasSum_of_disjoint_iUnion` + `tsum_nonneg`／`tsum_nonpos`），不是把 Mathlib 结论换个名字的
装饰别名。`exists_hahnDecomposition` 经本库正／负集桥得到，是后续 Jordan 与变差的教材入口。

**边界（本窗最关键的拒收点）。** Main 用 `grep` 独立扫描：`Radon`／`Nikodym`／`绝对连续` 的命中
**全部**是四个文档里的"边界免责声明"段落（说明 RA-F2 不在本 Entry、不得从本 Entry 推出），
源码中**没有任何 RA-F2 陈述**。`mutuallySingular` 只作为 `JordanDecomposition` 自身的字段出现，
属于 RA-F1 的 Jordan 分解内容，不是 RA-F2 的互奇异一般理论。负责人还主动披露了
`IsFiniteMeasure (c.variation)` 在 Mathlib 未注册（实测 `synthInstanceFailed`）、本批未证——
这是**诚实边界，不是缺陷**，我把它原样记进了 RADAR。

**验证真实性。** Main 在自己的集成 worktree 独立复验：四个模块构建通过；
`check_axioms.py --all --fix` 给出四个 Entry 的公理集并回写 Registry；无 `--fix` 复查通过；
全库 SKIP 集合仍未新增；`grep sorry/admit/sorryAx/native_decide` 无匹配；
`audit.py` 通过；`git diff --check` 干净；一次全库 `lake build` 通过。

**子 Agent 核查。** 负责人派了 3 个 depth-2 子 Agent（各写一个模块 + 对应 Entry 草稿），均无 git 写、
无并发 `lake`，构建与提交由负责人串行执行。负责人**实际退回并修好了 3 处**：两个模块头注释把
批次误标为"Folland RA-F2"（改为 RA-F1）、`totalVariation_union` 去掉无效 `have` 并改用真正使用
`hA` 的对称证明、冗余参数记 `_hB` 消 warning。退回记录具体到构造与参数，不是走过场，符合
SUBJECT-MAINTAINER-ROLE"子 Agent 的完成不是验收"。

## 可选择降级的接口

`SignedMeasureDefinition.lean` 中 `signedMeasure_empty`、`signedMeasure_not_measurable`、
`signedMeasure_union` 等若干条是对 Mathlib 性质的 **thin wrapper**（`:= s.empty`、
`VectorMeasure.of_union ...`）。它们有真实价值——把教材记号与 Mathlib 名称对上，且是本 Entry
的展开性质清单——但登记为 Playbook §4.1 的**瘦身候选**，不构成本批缺陷。判据不变：只要它们
仍被 Entry 文档的八段结构与后续条目真实引用，就保留。

## 不得越过的边界

- 本批只覆盖**有限、实值／复值**有符号测度与复测度；桥只到 `Measure.toSignedMeasure` 与
  `totalVariation : Measure α` 这一层，更深的分桥属 RA-F2。
- RA-F2（绝对连续、互奇异一般理论、Lebesgue 分解、Radon–Nikodym）**仍未开门**，不得由本批结果
  暗示其已完成。
- `IsFiniteMeasure (c.variation)` 未证（Mathlib 未注册实例），不得当成已有结论。
- ±∞ 扩展值与一般 Banach 值向量测度不在本批范围内。

## Main 集成时完成的归一化

- `SandronesLibrary.lean` 新增四个顶层 import（紧随 `RiemannAlgebra`）；
- `index/registry.json` 新增四个 Entry 记录（`family: real-analysis.signed-measure`、
  `variant: tao`）；
- `docs/MATHLIB-RADAR.md` 新增「有符号测度、Jordan 分解与复测度（RA-F1）」一节，登记五个 Mathlib
  结构／接口的角色与上游缺口；
- `docs/ROADMAP-LONGTERM.md`：§1 概览改为 `R1-R4✅ RA-F1✅；RA-F2–RA-F6🚧`，§6 的 RA-F1 行改 ✅
  并绑定四个 Entry id，D-1a 进展表登记本批交付与裁决；
- `docs/ROADMAP-examples.md`：E8.6 的开门口由 `RA-F1-F2` 改为 `RA-F1 ✅（RA-F2 未开）`，并补登
  正／负／全变差与复测度分解的必做计算；
- 派生文件按生成器重建：`docs/entries/README.md`（575 条目）、`index/rankings.json` 与
  `docs/entries/RANKINGS.md`，并与生成器输出逐字一致。

## 要求重跑的验证

无（学科侧无需返工）。Main 侧的生成器、公理审计、`audit.py`、`git diff --check` 与一次全库
`lake build` 在本集成提交前完成。
