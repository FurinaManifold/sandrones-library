# Analysis definition-clarity maintenance 总 handoff

## 接收方式

本分支与 Main 已分叉，**只能按下列顺序 cherry-pick，不能 merge 整个分支**：

1. `1942df8`、`53b7d38`、`507485c`：数列收敛定义窗口及范围纠偏；
2. `9e630ea`：Cauchy 列定义窗口；
3. `5c98905`：函数有限点极限定义窗口；
4. `9bda755`：连续性定义窗口；
5. `89d78ce`：一元导数定义窗口；
6. `6d2f9c9`：自然顺序级数定义窗口；
7. `69034eb`：Fréchet 导数定义窗口；
8. `d9c5854`：Main R1–R5 的 Entry、影响证据、成果号和审计边界返工；
9. 包含本总 handoff 与 review 处理记录的分支 tip 提交。

明确排除 `a4984d7`、`a9d90a5`：其等价内容已由 Main 以 `52e1703`、`df17dd5` 接收，再次
cherry-pick 会重复。Main 接收时不得使用 merge，也不得从 `a4984d7` 开始整段拣取。

## Review 闭环

- Review：`docs/reviews/analysis-maintenance-definition-clarity-main-review.md`
- R1：六个定义 Entry 的前置标记和声明归属已由 `map_entry_to_decl` 复核。
- R2/R5：本文件是唯一接收顺序；各 handoff 已写成果提交号。
- R3：Cauchy 与函数极限影响图、premises、导入闭包和旧接口计数已补齐；定义审计边界已同步。
- R4：连续性和级数的新定义与桥已进入正确 Entry。

## 验证与边界

六个修改模块使用同一锁定依赖的现成缓存直接类型检查通过；381 个条目 audit 通过；禁用占位扫描
和 `git diff --check` 通过。既有 Mathlib API 不退役、不要求使用计数归零。Main 集成后仍需更新
Registry/RADAR/ROADMAP，运行公理审计和一次全库 build。

## Round 3 教材使用者

- 数列收敛／Cauchy：`sequenceConvergesTo_unique`、`sequenceConvergesTo_sequenceIsCauchy`。
- 函数极限：`functionConvergesToAt_unique`。
- 连续性：`continuousAtTextbook_const`、
  `continuousOnTextbook_of_forall_continuousAtTextbook`、
  `continuousOnTextbook_of_uniformContinuousOnTextbook`。
- 导数：`hasDerivativeAtTextbook_unique`。
- 级数：`seriesHasSum_unique`、`seriesConvergent_of_seriesHasSum`、
  `seriesConvergent_of_seriesAbsolutelyConvergent`。
- Fréchet 导数：`hasFrechetDerivativeAtTextbook_unique`。

这些是最小真实教材使用者，不要求替换既有 Mathlib 定理接口。

## 逐概念六列表

| 概念 | 本库教材定义 | 展开／一手性质 | Mathlib 桥 | 首个真实使用者 | 源码 Entry |
|---|---|---|---|---|---|
| 数列收敛 | `SequenceConvergesTo` | `sequenceConvergesTo_iff_epsilon_N` | `sequenceConvergesTo_iff_tendsto` | `sequenceConvergesTo_unique` | `analysis.sequence.definition` |
| Cauchy 列 | `SequenceIsCauchy` | `sequenceIsCauchy_iff_epsilon_N` | `sequenceIsCauchy_iff_cauchySeq` | `sequenceConvergesTo_sequenceIsCauchy` | `analysis.sequence.cauchy` |
| 有限点函数极限 | `FunctionConvergesToAt` | `functionConvergesToAt_iff_epsilon_delta` | `functionConvergesToAt_iff_tendsto` | `functionConvergesToAt_unique` | `analysis.func-limit.definition` |
| 点连续 | `ContinuousAtTextbook` | 定义本身的 ε-δ 展开 | `continuousAtTextbook_iff_continuousAt` | `continuousAtTextbook_const` | `analysis.continuity.definition` |
| 集合上连续 | `ContinuousOnTextbook` | 定义本身的逐点 ε-δ 展开 | `continuousOnTextbook_iff_continuousOn` | `continuousOnTextbook_of_forall_continuousAtTextbook` | `analysis.continuity.definition` |
| 集合上一致连续 | `UniformContinuousOnTextbook` | 定义本身的统一 δ 展开 | `uniformContinuousOnTextbook_iff_uniformContinuousOn` | `continuousOnTextbook_of_uniformContinuousOnTextbook` | `analysis.continuity.definition` |
| 一元导数 | `HasDerivativeAtTextbook` | 去心差商极限 | `hasDerivativeAtTextbook_iff_hasDerivAt` | `hasDerivativeAtTextbook_unique` | `analysis.derivative.definition` |
| 自然顺序级数和 | `SeriesHasSum` | 自然部分和 `Tendsto` | `hasSum_seriesHasSum`；绝对可和时 iff | `seriesHasSum_unique` | `analysis.series.basic` |
| 级数收敛 | `SeriesConvergent` | 存在 `SeriesHasSum` | 经 `HasSum` 的单向桥 | `seriesConvergent_of_seriesHasSum` | `analysis.series.basic` |
| 绝对收敛 | `SeriesAbsolutelyConvergent` | 绝对值级数收敛 | `seriesAbsolutelyConvergent_iff_summable_abs` | `seriesConvergent_of_seriesAbsolutelyConvergent` | `analysis.series.basic` |
| Fréchet 导数 | `HasFrechetDerivativeAtTextbook` | 余项比值趋零 | `hasFrechetDerivativeAtTextbook_iff_hasFDerivAt` | `hasFrechetDerivativeAtTextbook_unique` | `analysis.multivariable.frechet` |

## Mathlib 四类归属与历史排除

- 等价桥目标：`Tendsto`、`CauchySeq`、`ContinuousAt`、`ContinuousOn`、
  `UniformContinuousOn`、`HasDerivAt`、`HasFDerivAt`。
- 条件或单向桥目标：`HasSum`、`Summable`；自然顺序条件收敛不与无条件求和混同。
- 数据载体：`ContinuousLinearMap`、`Finset.range`。
- 证明后端：对应的 Mathlib 极限、连续性、微分与无限求和定理。

排除范围：未修改的历史公开定理仍可使用上述 Mathlib 谓词，因为本维护只补教材定义及至少一个
真实使用者，不授权破坏旧 API。它们不是第五类，也不进入退役或使用计数归零计划。

## Entry 映射摘要

- `analysis.sequence.definition`：数列定义、展开、`Tendsto` 桥、教材极限唯一。
- `analysis.sequence.cauchy`：Cauchy 定义、展开、桥、收敛推出 Cauchy 及旧完备性接口。
- `analysis.func-limit.definition`：函数极限定义、ε-δ 展开、桥、教材极限唯一。
- `analysis.continuity.definition`：三种定义、三条桥及三个教材一手性质；`continuousOn_Icc` 已移出。
- `analysis.derivative.definition`：差商定义、桥、教材导数唯一。
- `analysis.series.basic`：三种自然顺序定义、方向正确的桥、三个教材上层性质及原基础级数定理。
- `analysis.multivariable.frechet`：Fréchet 定义、桥、教材唯一性及原全微分基础定理。
