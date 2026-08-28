# S1 偏差—方差正式交接

- entry：`statistics.estimator.bias-variance`
- branch：`codex/probability`
- synced Main：`ff5be05`
- gate：`development_open`
- formal source：`SandronesLibrary/Statistics/BiasVariance.lean`
- files：
  - `SandronesLibrary/Statistics/BiasVariance.lean`
  - `docs/entries/statistics/estimator/bias-variance.md`
  - `docs/handoffs/statistics-s1-bias-variance.md`

## 概念冻结表

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 实值估计量 | 输出为实数的随机化规则 | `κ : Kernel 𝓧 ℝ`、`[IsMarkovKernel κ]` | 输出律 `(κ ∘ₖ P) θ` | 复用 estimator carrier | 风险消费者 | `statistics.estimator.bias-variance` |
| 实值目标 | 参数对应的待估计值 | `τ : Θ → ℝ` | 可测时平方损失联合可测 | 不限制为恒等参数 | 平方损失 | 同上 |
| 偏差 | 输出均值减目标 | `∫ y, y ∂((κ ∘ₖ P) θ) - τ θ` | 直接表达式 | 不建一行同义 def | 偏差平方 | 同上 |
| 方差 | 输出律下的二阶中心矩 | `Var[id; (κ ∘ₖ P) θ]` | `variance_eq_sub` | 语义一致，直接复用 | 分解右端 | 同上 |
| 二阶矩 | 平方可积 | `MemLp id 2 ((κ ∘ₖ P) θ)` | 桥到平方误差可积 | 逐参数显式保留 | 风险分解 | 同上 |
| 平方风险 | 平方损失的期望 | ENNReal `lintegral` | `ofReal_integral_eq_lintegral_ofReal` | 与 estimator 风险接口一致 | 最终定理 | 同上 |

## 公开签名扫描

- 正式公开承载：`Kernel`、`IsMarkovKernel`、`MemLp`、`variance`、实值 `integral`、ENNReal
  `lintegral`；Entry 已逐项解释。
- 本库桥与消费者：平方损失联合可测、一般概率测度 MSE 恒等式、Markov estimator 输出律风险分解
  共三个公开声明。
- 私有后端：`memLp_two_iff_integrable_sq`、积分线性、`variance_eq_sub` 和
  `ofReal_integral_eq_lintegral_ofReal`。
- 越级泄漏：无；未出现 posterior、argmin、MLE、Fisher、Cramér--Rao 或一般最优性。

## 负责人验收

- `/tmp/StatisticsBiasVarianceAudit.lean` 先完整组装三层签名并消除全部 `sorry`，无 warning 后才移入
  正式文件。
- `lake build SandronesLibrary.Statistics.BiasVariance`：通过（2989 jobs）。
- `/tmp/StatisticsBiasVarianceAggregate.lean` 同时 `#check` carrier 与三个公开声明：通过。
- `scripts.check_axioms.map_entry_to_decl`：唯一 id 精确映射三个声明，无跨 Entry 吸入。
- 三项 `#print axioms` 仅含 `propext`、`Classical.choice`、`Quot.sound`，无 `sorryAx`。
- 正式源码禁用占位扫描与 `git diff --check`：通过。

## 诚实边界与 Main 建议

- 仅实值、平方损失、逐参数风险；无向量值或先验平均推广。
- 二阶矩是显式假设，Markov 性不蕴含矩存在。
- Main 集成时请登记唯一 id、导入 `BiasVariance.lean` 并更新 ROADMAP；其余统计条目保持各自门控。
