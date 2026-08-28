# S1 统计量、估计量与风险定义交接

- entry：`statistics.estimator.definition`
- branch：`codex/probability`
- synced Main：`0195869`
- formal source：`SandronesLibrary/Statistics/Estimator.lean`
- files：
  - `SandronesLibrary/Statistics/Estimator.lean`
  - `docs/entries/statistics/estimator/definition.md`
  - `docs/handoffs/statistics-s1-estimator-definition.md`

## 概念冻结表

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 统计量／确定性估计量 | 样本的可测函数 | `T : 𝓧 → 𝓨`、`Measurable T` | 不另建结构 | 经 `Kernel.deterministic` 进入统一接口 | `deterministicEstimator_isMarkov` | `statistics.estimator.definition` |
| 随机化估计量 | 数据给定时估计输出的条件概率分布 | `κ : Kernel 𝓧 𝓨`、`[IsMarkovKernel κ]` | `estimatorOutput_isMarkov` | 语义一致，直接复用；Markov 条件显式保留 | 输出分布与风险 | `statistics.estimator.definition` |
| 确定性桥 | 输出集中在 `T x` | `Kernel.deterministic T hT` | `deterministicEstimator_outputDistribution` | 复用 `Kernel.deterministic_comp_eq_map` | `avgRisk_deterministic` | `statistics.estimator.definition` |
| 损失 | 参数与行动的联合可测非负代价 | `ℓ : Θ → 𝓨 → ℝ≥0∞`、`Measurable (uncurry ℓ)` | `measurable_loss_section` | 不建 Loss 结构；ENNReal 允许无限风险 | 逐参数风险 | `statistics.estimator.definition` |
| 逐参数风险 | 固定参数下损失的期望 | `∫⁻ y, ℓ θ y ∂((κ ∘ₖ P) θ)` | 保持原生积分 | 遵从 Mathlib 不另设同义 `risk` 的设计 | `avgRisk_eq_lintegral_pointwiseRisk` | `statistics.estimator.definition` |
| 平均风险 | 逐参数风险关于先验的平均 | `avgRisk ℓ P κ π` | 双重 `lintegral` 展开 | 语义一致，直接复用 | Bayes 风险下界 | `statistics.estimator.definition` |
| Bayes 风险 | 所有 Markov 估计量平均风险的下确界 | `bayesRisk ℓ P π` | `bayesRisk_le_estimator_avgRisk` | 语义一致；不暗示下确界达到 | `isBayesEstimator_iff` | `statistics.estimator.definition` |
| Bayes 估计量 | 达到 Bayes 风险的估计量 | `IsBayesEstimator ℓ P κ π` | 等式展开 | 只刻画达到，不证明存在 | `isBayesEstimator_iff` | `statistics.estimator.definition` |

## 公开签名扫描

- 正式公开承载：`Kernel`、`IsMarkovKernel`、`avgRisk`、`bayesRisk`、`IsBayesEstimator`、
  `Kernel.deterministic`、`Kernel.map`、kernel 复合和 `lintegral`；均在 Entry 中给出教材语义与边界。
- 本库桥：仅具名定理连接确定性映射、输出推前与统一风险；没有新建重复 carrier 或同义风险定义。
- 私有证明后端：`Kernel.deterministic_comp_eq_map`、`bayesRisk_le_avgRisk` 和 Markov kernel 的复合实例。
- 越级泄漏：无；没有 posterior、standard Borel、argmin measurable selection 或一般最优估计量存在性。

## 负责人验收

- `/tmp/StatisticsEstimatorFramework.lean` 先完成八项上层组装；初始框架只报八个 `sorry` warning，
  随后逐项消除并整体验证通过。
- `lake build SandronesLibrary.Statistics.Estimator`：通过（2968 jobs）。
- `/tmp/StatisticsEstimatorAggregate.lean` 同时导入并 `#check` 正式 carrier、展开、桥和八个公开
  声明：通过。
- `scripts.check_axioms.map_entry_to_decl`：唯一 id 精确映射八个公开声明，没有跨 Entry 吸入。
- 八个声明的 `#print axioms` 均只含 `propext`、`Classical.choice`、`Quot.sound`，无 `sorryAx`。
- 正式源码禁用占位扫描与 `git diff --check`：通过。

## 诚实边界与 Main 建议

- 本批没有定义逐参数 `risk`，没有把普通 kernel 静默称为估计量，也没有声称 Bayes 下确界达到。
- 偏差—方差、相合性、MLE、Fisher、充分性、Cramér--Rao 与一般最优性继续冻结。
- Main 集成时请登记唯一 Registry id `statistics.estimator.definition`，`lean_file` 指向
  `SandronesLibrary/Statistics/Estimator.lean`，并更新 ROADMAP 的门状态；学科分支不修改共享文件。
