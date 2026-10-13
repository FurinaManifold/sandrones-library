# Main review: functional-analysis F6.6b1 resolvent integrand

- branch: `codex/functional-analysis-f66b1`
- reviewed_commit: `d914d30`（`git status --short` 为空，单 commit）
- reviewer: main
- verdict: `accepted`
- reviewed_at: 2026-10-13

## 已通过

**范围与权限。** 本批对应 Wave D **D2**（`development_open`），Entry
`functional-analysis.functional-calculus.resolvent-integrand`。交付只有三个新增文件，全部落在学科
所有权内；未触碰任何 Main 共享文件。

**数学陈述。** Main 逐条复核了 13 个公开声明：

- `resolvent_sub_resolvent_same`：**第一预解恒等式**。Main 独立核对了符号：
  `R z - R w = R z ((w-a) - (z-a)) R w = (w-z) · R z R w`，与源码和文档一致。前提
  `hz : z ∈ resolventSet ℂ a`、`hw : w ∈ resolventSet ℂ a` 是必要的——`Ring.inverse` 在不可逆处
  约定为零，少了前提公式不成立。该恒等式确实不在 Mathlib 中（Mathlib 只有第二预解恒等式
  `spectrum.resolvent_sub_resolvent`），属于本库真实补充。
- `resolvent_mul_comm`：主张对**全部** `z, w : ℂ` 无条件成立。Main 独立核对：`z·1-a` 与 `w·1-a`
  恒交换，故其环逆交换；不可逆处 `Ring.inverse = 0` 仍交换。结论强度与证明相符，文档也写明了
  这条比 `resolvent_sub_resolvent_same` 前提更弱，没有虚假降级。
- 解析层四条与 Dunford 被积函数五条：均为对 Mathlib
  `spectrum.hasDerivAt_resolvent_const_left`、`spectrum.isOpen_resolventSet`、
  `DifferentiableOn.smul`、`DifferentiableOn.analyticOnNhd`、`ContinuousOn.integrableOn_compact`
  的真实组装，无一处把 Mathlib 结论改强。`analyticsOnNhd` 一步正确使用了预解集开性——这正是
  "逐点可微升为全纯"所需的额外输入，没有被静默省略。

**边界（本窗最关键的拒收点）。** Main 用 `grep` 独立扫描源码中 `cycle`／`winding`／`绕数`／
`f(a)`：命中只出现在第 13、20、110 行的模块文档注释里，**公开签名与证明体均无**。本批确实只做了
不依赖 cycle 的解析部分，符合 inbox 通知
`main-f66-resolvent-integrand-development-open.md` 明令的"不得定义有限 cycle、绕数、cycle 积分、
Dunford 值 `f(a)`、选择无关性、代数同态、谱映射、复合、谱投影或连续函数演算"。

**教材解释层。** `docs/entries/functional-analysis/functional-calculus/resolvent-integrand.md`
（179 行）给出教材定义、量词、对象层级，逐项说明 `resolventSet`／`resolvent`／`Ring.inverse` 的
Mathlib 角色，并有一张"教材 `R(z,a)` ↔ Lean 承载"对照表。文档结构与同门
`holomorphic-neighborhood.md` 一致，Main 未作重排。

**前提真实性。** Main 独立核验 `premises` 两条都是真实库内依赖，不是装饰：
`HolomorphicResolventIntegrand` → `HolomorphicNeighborhood` → `SpectrumNonemptyCompact` →
`SpectrumDefinition`。且 `functional-analysis.spectrum.definition` 的桥
（`resolvent_eq_ringInverse`、`mem_resolventSet_iff_isUnit`）正是文档对照表里引用的两条展开，
被本条目真实消费。**没有重复概率批那次"列出了源码里不存在的未用前提"的问题。**

**验证真实性。** Main 在自己的集成 worktree 独立复验，未复述学科报告：

- `lake build SandronesLibrary.FunctionalAnalysis.HolomorphicResolventIntegrand`
  → `Build completed successfully (2902 jobs).`，exit 0；
- `python3 scripts/check_axioms.py --all --fix` → 该 Entry 实际公理
  `['Classical.choice', 'Quot.sound', 'propext']`，回写 Registry；随后无 `--fix` 复查通过；
- 全库 SKIP 集合与本批开工前的基线**完全一致**（仍只有
  `linear-algebra.vector-space.dimension`、`real-analysis.riemann.cont-integrable` 两条），
  本批未引入任何新的审计盲区；
- `grep -E "sorry|admit|sorryAx|native_decide"` → 无匹配；
- `python3 scripts/audit.py` → `审计通过：571 个条目 OK`；`git diff --check` 干净。

**子 Agent 核查。** 负责人派了 3 个 depth-2 子 Agent（API 先例审计／Entry 文档作者／对抗性数学
复核），均无 git 写、无并发 `lake`；负责人自行完成模块实现与全部串行构建、复核后对文档作了两处
编辑并如实记录。子 Agent 的"完成"没有被当作验收，符合 SUBJECT-MAINTAINER-ROLE。

## 可选择降级的接口

无。本批没有出现越级公开泄漏：公开签名只要求 `[NormedRing A] [NormedAlgebra ℂ A]`，解析层再加
`[CompleteSpace A]`，都是预解算子自身的自然层级。

## 不得越过的边界

- 本条目只在紧集上证明了被积函数可积，**没有组装积分**。任何后续窗口不得把
  `integrableOn_resolventIntegrand_compact` 说成"Dunford 积分已存在"。
- 完整 Dunford 演算（F6.6b2）仍为 `research_open`。下一窗口"沿 cycle 集成"依赖复分析尚未集成的
  公共有限 cycle／绕数／Banach 值路径积分 carrier；handoff 已写 `integration_waits_for`，
  该边界保留。
- 负责人记录的易碎点保留在案：`resolvent_sub_resolvent_same` 的两处 `rfl` 依赖 `resolvent`
  当前定义体。陈述本身不依赖，但若 Mathlib 改定义体需同步；这是诚实披露，不是缺陷。

## Main 集成时完成的归一化

- Entry 文档 front matter `state: staging` → `verified`；
- `SandronesLibrary.lean` 新增顶层 import（紧随 `HolomorphicNeighborhood`）；
- `index/registry.json` 新增本 Entry 记录（`family: functional-analysis.operator`、
  `variant: resolvent-integrand`，与同门 `holomorphic-neighborhood` 惯例一致）；
- `docs/MATHLIB-RADAR.md` 新增「预解恒等式与 Dunford 被积函数（F6.6b1）」一节，登记本批复用的
  Mathlib 接口与上游缺口（Mathlib 无第一预解恒等式、无 `Complex.windingNumber`、无复分析
  `residue`）；
- `docs/ROADMAP-LONGTERM.md`：§F6 的 6b1 行由 `development_open` 改 ✅；
- `docs/ROADMAP-examples.md`：E11.8 补登"两个谱参数处预解元的第一预解恒等式与乘法交换的具体
  验算"及其反例辨析（不可省去 `z,w ∈ resolventSet`）；
- 派生文件按生成器重建：`docs/entries/README.md`（571 条目）、`index/rankings.json` 与
  `docs/entries/RANKINGS.md`（参排 569 条），并与生成器输出逐字一致。

## 要求重跑的验证

无（学科侧无需返工）。Main 侧的生成器、公理审计、`audit.py`、`git diff --check` 与一次全库
`lake build` 在本集成提交前完成。
