# Pr3 弱大数律正式交接

- entry：`probability.law-large-numbers.weak`
- branch：`codex/probability`
- synced Main：`42ace17`
- gate：`development_open`
- formal source：`SandronesLibrary/Probability/WeakLaw.lean`
- files：
  - `SandronesLibrary/Probability/WeakLaw.lean`
  - `docs/entries/probability/law-large-numbers/weak.md`
  - `docs/handoffs/probability-pr3-weak-law.md`

## 概念冻结表

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 全族独立 | 任意有限子族独立 | `iIndepFun X μ` | `iIndepFun.indepFun` 提取两两独立 | 语义一致，直接复用 | `iid_sum_variance` | `probability.law-large-numbers.weak` |
| 同分布 | 每项推前分布等于基准项 | `IdentDistrib (X i) (X 0) μ μ` | `memLp_iff`、`integral_eq`、`variance_eq` | 语义一致，直接复用 | 二次可积、期望和方差传递 | 同上 |
| 有限方差 | 基准项二次可积 | `MemLp (X 0) 2 μ` | `iid_memLp_of_memLp_zero` | 不另造 finite-variance 谓词 | Chebyshev | 同上 |
| 样本均值 | 前 `n` 项和除以 `n` | 明示 `(n : ℝ)⁻¹ * ∑ i ∈ range n, X i` | 期望和方差两个公开引理 | 不建无人使用的 process def | WLLN | 同上 |
| 概率收敛 | 每个正阈值的偏差概率趋零 | `TendstoInMeasure` | `convergesInProbability_iff_measureReal_dist` | 复用 Pr3 已登记 carrier | 最终定理 | 同上 |
| Chebyshev 控制 | 偏差概率不超过方差除阈值平方 | 本库 `chebyshev_inequality` | ENNReal 上界转 `Measure.real` | 真实调用本库已有不等式 | 最终夹逼 | 同上 |

## 公开签名扫描

- 正式公开承载：`MemLp`、`iIndepFun`、`IdentDistrib`、`variance`、Bochner `integral`、
  `TendstoInMeasure`；均在 Entry 中解释教材语义。
- 本库展开与消费者：逐项二次可积、和二次可积、和方差、样本均值二次可积、和期望、样本均值
  期望、样本均值方差及最终 WLLN 共八个声明，形成完整定义—计算—收敛链。
- 私有证明后端：函数空间有限和外延、`ENNReal.toReal_mono`、eventually-atTop 尾部与实数夹逼。
- 越级泄漏：无；没有调用 `strong_law_ae`、特征函数或 CLT。

## 负责人验收

- 证明先在 `/tmp/WeakLawFramework.lean` 组装冻结签名，再在 `/tmp/WeakLawHelpers.lean` 逐项消除
  下层目标并验证完整定理，之后才移入正式文件。
- `lake build SandronesLibrary.Probability.WeakLaw`：通过（2961 jobs）。
- `/tmp/WeakLawAggregate.lean` 同时 `#check` iid carrier、本库 Chebyshev 及八个公开声明：通过。
- `scripts.check_axioms.map_entry_to_decl`：唯一 id 精确映射八个声明，没有跨 Entry 吸入。
- 八项 `#print axioms` 均只含 `propext`、`Classical.choice`、`Quot.sound`，无 `sorryAx`。
- 正式源码禁用占位扫描及 `git diff --check`：通过。

## 诚实边界与 Main 建议

- `n=0` 仅是零首项；正式证明在 `1≤n` 的尾部使用正样本量公式。
- 定理按冻结签名使用 iid 与二次可积性；没有冒充一阶矩、非同分布或向量值推广。
- Main 集成时请登记唯一 id、导入 `WeakLaw.lean`、更新 ROADMAP，并保持强大数律、特征函数与 CLT
  的冻结门。学科分支不修改共享文件。
