# Pr3 弱大数律接口与 Chebyshev 证明链审计

## 权限与结论

- gate：`probability.law-large-numbers.weak` 当前为 `research_open`。
- 本批只在 `/tmp/WeakLawFramework.lean` 冻结签名与证明链；不新增正式概率论模块、Entry 或 verified
  声明。
- 临时文件编译结果仅有一个预期的 `sorry` warning，没有接口或类型错误。

建议正式定理采用独立同分布的实值随机变量序列、二阶矩有限假设和从 `0` 开始的 `Finset.range n`
样本和，并以 `TendstoInMeasure` 陈述概率收敛。证明必须走方差可加性与 Chebyshev，不调用更强的
Mathlib 强大数律反推弱大数律。

## 建议冻结签名

```lean
theorem weakLaw_of_iid_finiteVariance
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ)
    (hX : MemLp (X 0) 2 μ)
    (hindep : iIndepFun X μ)
    (hident : ∀ i, IdentDistrib (X i) (X 0) μ μ) :
    TendstoInMeasure μ
      (fun (n : ℕ) ω ↦ (n : ℝ)⁻¹ * ∑ i ∈ Finset.range n, X i ω)
      atTop (fun _ ↦ ∫ ω, X 0 ω ∂μ)
```

`n = 0` 时样本均值按 Lean 的逆元和空和约定为零。这只是序列的首项，不影响 `atTop` 极限；正式
证明可在最终估计中进入 `1 ≤ n` 的尾部，而无需把序列改成 `n + 1` 并制造教材下标偏移。

## 概念冻结表

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | 拟定 Entry |
|---|---|---|---|---|---|---|
| 独立随机变量族 | 任意有限子族联合独立 | `iIndepFun X μ` | `iIndepFun.indepFun` 给出两两独立 | 比结论所需的两两独立稍强，但准确承载教材 iid | 有限和方差 | `probability.law-large-numbers.weak` |
| 同分布 | 每个 `X i` 与 `X 0` 推前分布相同 | `IdentDistrib (X i) (X 0) μ μ` | `memLp_iff`、`integral_eq`、`variance_eq` | 直接复用，避免分别假设相同期望和方差 | 样本均值 | 同上 |
| 有限方差 | 二次可积 | `MemLp (X 0) 2 μ` | 经同分布传给所有 `X i` | 概率测度有限，二次可积也提供一阶可积性 | Chebyshev | 同上 |
| 样本均值 | 前 `n` 项和除以 `n` | `(n : ℝ)⁻¹ * ∑ i ∈ range n, X i ω` | `range n = {0,…,n-1}` | 不另造 process 定义 | WLLN | 同上 |
| 概率收敛 | 每个正阈值的偏差概率趋零 | `TendstoInMeasure μ ... atTop ...` | `convergesInProbability_iff_measureReal_dist` | 与既有 Pr3 carrier 完全一致 | WLLN 结论 | 同上 |

## 已核对的精确接口

- `IdentDistrib.memLp_iff`：从 `X 0` 向每个 `X i` 传递 `MemLp _ 2 μ`；
- `IdentDistrib.integral_eq`：每项期望等于 `X 0` 的期望；
- `IdentDistrib.variance_eq`：每项方差等于 `X 0` 的方差；
- `iIndepFun.indepFun`：从全族独立提取有限和所需的两两 `IndepFun`；
- `IndepFun.variance_sum`：二次可积且两两独立时，有限和方差等于方差之和；
- `variance_const_mul`：样本均值的方差按 `n⁻²` 缩放；
- `SandronesLibrary.Probability.chebyshev_inequality`：把偏差事件概率控制为
  `Var / ε²`；
- `convergesInProbability_iff_measureReal_dist`：把每个阈值下的实测度趋零组装回
  `TendstoInMeasure`。

## 正式证明链

1. 由 `hident i` 与 `hX` 得到每个 `X i` 二次可积、期望相同且方差相同。
2. 对 `Finset.range n`，由 `hindep.indepFun` 建立所需的 pairwise `IndepFun`，再用
   `IndepFun.variance_sum` 得
   `Var[∑ i<n, X i] = n * Var[X 0]`。
3. 用有限和积分线性与 `IdentDistrib.integral_eq` 得样本均值在 `n ≥ 1` 时的期望等于
   `∫ X 0 ∂μ`。
4. 用 `variance_const_mul` 得样本均值方差为 `Var[X 0] / n`；正式化时可先保留
   `(n : ℝ)⁻¹ ^ 2 * (n * Var[X 0])`，在 `0 < n` 的尾部化简，避免在 `n = 0` 除法上纠缠。
5. 对任意 `ε > 0` 应用本库 Chebyshev 不等式，得到偏差事件的 `ENNReal` 测度上界，其实数版本
   由常数乘 `1/n` 控制并趋于零。
6. 用夹逼得到每个阈值的 `μ.real` 偏差概率趋零，再通过
   `convergesInProbability_iff_measureReal_dist` 得到 `TendstoInMeasure`。

## 边界与拒绝的捷径

- 两两独立已足够完成方差法 WLLN，但教材条目要求 iid；首个公开签名保留 `iIndepFun`，不把更弱
  推广冒充冻结目标。以后可另设两两独立同均值同方差的内部推广。
- 不调用 `ProbabilityTheory.strong_law_ae` 或 `strong_law_Lp`。它们虽在 Mathlib 中可用，但强大数律
  在本路线仍冻结，用它证明 WLLN 会倒置课程依赖并隐藏 Chebyshev 证明骨架。
- 本批不调查非同分布、三角阵、只要求一阶矩、Banach 值随机变量、强大数律、特征函数或 CLT。
- 正式开发前 Main 仍需确认上述签名及 `n = 0` 的首项约定；当前没有正式库声明。

## 后续门建议

若 Main 通过本审计，可将 `probability.law-large-numbers.weak` 转为 `development_open`，正式文件建议
固定为 `SandronesLibrary/Probability/WeakLaw.lean`。强大数律、特征函数与 CLT 仍分别保持冻结。
