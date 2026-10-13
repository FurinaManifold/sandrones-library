# Pr3 Lévy 连续性与 CLT 特征函数基础 Main 验收

- 学科 staging：`codex/probability`（本批无独立 worktree）
- 学科提交：`fbc5afd`（前置接口审计 `c087066`）
- 已接入 main：`8d98886`
- Main 集成提交：本批共享状态提交
- Entry：`probability.characteristic-function.levy-continuity`、`probability.clt.characteristic-foundation`
- 来源：`kallenberg-modern-probability-2021`
- Verdict：`accepted_main_docs`

## 数学与接口裁决

**数学成立、强度诚实。** 逐项核对：

- `LevyContinuity.lean`：`probabilityMeasure_tendsto_iff_charFun` 在 `ProbabilityMeasure ℝ` 上给出
  “弱收敛 ↔ 特征函数逐点收敛”，与教材 Lévy 连续性定理同强度；`tight_of_charFun_tendsto_continuousAt_zero`
  在 `ContinuousAt f 0` 下只推出 `IsTightMeasureSet`，**没有**把任意点态极限 `f` 冒充为某个概率测度的
  特征函数。文档解释了“已知目标测度版为何无需额外连续性前提”，与接口审计的判断一致。
- `CLTCharacteristicFoundation.lean`：四个声明构成真实证明链——iid 有限和乘积公式化为单项幂
  （`normalizedSum_charFun_eq_pow`）、`ProbabilityMeasure ℝ` 推前打包（`normalizedSumLaw`）、
  二阶 Taylor 小量到指数极限（`centeredVarianceOne_charFun_pow_tendsto`）、经**本库** Lévy iff 反向
  得到标准正态弱收敛。文件未 import `Mathlib.Probability.CentralLimitTheorem`，未调用
  `tendstoInDistribution_inv_sqrt_mul_sum`。
- 边界如实在文档与 handoff 中声明：只做中心零、二阶矩一；一般均值方差、方差零退化边界与
  `TendstoInDistribution` 桥未完成，一般 CLT 在 ROADMAP 中保持 `research_open`。

`LevyContinuity.lean` 的两条定理证明体是 `exact` Mathlib 接口，属 Playbook §4.1 的**瘦身维护候选**
（`structural` 类），不影响本批数学裁决；后续按 §15.2 节奏复核是否改写为库内推导。

## Main 发现并修正：CLT 条目一处无据前提

交付的 front matter 把 `probability.law-large-numbers.strong` 列为
`probability.clt.characteristic-foundation` 的 premise，但：

1. 该名字只出现在这一行，`CLTCharacteristicFoundation.lean` 与整篇 Entry 文档再无提及；
2. 学科自己的接口审计“概念六列表”与 handoff“概念冻结表”列出的前置只有归一化和律、独立和乘积、
   二阶展开、标准正态目标，**不含**大数律；
3. 证明链不经过强大数律。

这是一条无据依赖边，会污染 `dependedOnBy` 与排行。Main 按“Registry 从源码与学科冻结表重建”的职责
把它从 Registry 记录与本篇 front matter 中移除（保留 `probability.characteristic-function.levy-continuity`
唯一前提），并在 `../review-inbox/probability/main-pr3-clt-premise-correction.md` 留档，供学科在后续
批次自查前提前提声明。数学陈述与证明强度未因此改动。

## 独立复验

- 两模块在 main 工作树独立构建成功（`lake build SandronesLibrary.Probability.LevyContinuity
  SandronesLibrary.Probability.CLTCharacteristicFoundation` → 3214 jobs），无新增 warning。
- 无 `sorry`／`admit`／`native_decide`；`check_axioms.py` 两条目公理均为标准三项。

## Main 规范化

补顶层导入两条、Registry 两条目、`docs/MATHLIB-RADAR.md` 的 Lévy/CLT 段 Mathlib 锚点，并在
ROADMAP §9 把 Pr3.4b1／4b2 标为已集成、把一般 CLT 指向窗口 D8。
