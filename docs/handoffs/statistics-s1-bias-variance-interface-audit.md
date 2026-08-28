# S1 偏差—方差分解接口审计

## 权限与结论

- gate：`statistics.estimator.bias-variance` 当前为 `research_open`。
- 本批只在 `/tmp/StatisticsBiasVarianceAudit.lean` 调查实值随机化估计量、平方损失和风险分解；没有
  新增正式统计模块、Entry 或 verified 声明。
- 临时文件中的联合可测平方损失、一般概率测度分解和 estimator-kernel 风险消费者三项均已消除
  `sorry`，`lake env lean` 无错误或 warning。

建议沿既有随机化估计量 carrier：模型 `P : Kernel Θ 𝓧` 与实值估计量 `κ : Kernel 𝓧 ℝ` 都保留
`IsMarkovKernel`。真实目标是 `τ : Θ → ℝ`。在固定参数 `θ` 下，估计输出分布为
`νθ = (κ ∘ₖ P) θ`，二阶矩条件准确写成 `MemLp id 2 νθ`。

## 概念冻结建议

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | 拟定 Entry |
|---|---|---|---|---|---|---|
| 实值估计量 | 输出落在实数的随机化决策规则 | `κ : Kernel 𝓧 ℝ`、`[IsMarkovKernel κ]` | 输出律 `(κ ∘ₖ P) θ` | 复用 estimator Entry，不建新结构 | 偏差与风险 | `statistics.estimator.bias-variance` |
| 估计目标 | 参数对应的真实实数值 | `τ : Θ → ℝ` | 平方损失可测时要求 `Measurable τ` | 不限于估计参数本身 | 平方损失 | 同上 |
| 偏差 | 输出均值减真实目标 | `(∫ y, y ∂((κ ∘ₖ P) θ)) - τ θ` | 保持原生表达式 | 暂不另造只有一行展开的 `bias` def | 偏差平方项 | 同上 |
| 方差 | 输出律下围绕自身均值的二阶中心矩 | `Var[id; (κ ∘ₖ P) θ]` | `variance_eq_sub` | 语义一致，直接复用 | 分解右端 | 同上 |
| 平方损失 | `(y-τθ)²` 的非负代价 | `ENNReal.ofReal ((y - τ θ) ^ 2)` | 联合可测性定理 | 与 estimator 的 ENNReal loss 接口一致 | 逐参数风险 | 同上 |
| 均方风险 | 平方损失关于输出律的期望 | 原生 `lintegral` | 桥到实值积分后分解 | 不另建同义 pointwise risk | 分解左端 | 同上 |

## 建议冻结签名

一般概率测度层先证明纯数学恒等式：

```lean
theorem squaredError_integral_eq_variance_add_bias_sq
    (ν : Measure Ω) [IsProbabilityMeasure ν]
    (Y : Ω → ℝ) (hY : MemLp Y 2 ν) (a : ℝ) :
    ∫ ω, (Y ω - a) ^ 2 ∂ν =
      Var[Y; ν] + (∫ ω, Y ω ∂ν - a) ^ 2
```

再以真实 estimator 输出律消费它：

```lean
theorem estimator_squaredLossRisk_eq_variance_add_bias_sq
    (P : Kernel Θ 𝓧) [IsMarkovKernel P]
    (κ : Kernel 𝓧 ℝ) [IsMarkovKernel κ]
    (τ : Θ → ℝ) (θ : Θ)
    (hκ : MemLp id 2 ((κ ∘ₖ P) θ)) :
    ∫⁻ y, ENNReal.ofReal ((y - τ θ) ^ 2) ∂((κ ∘ₖ P) θ) =
      ENNReal.ofReal
        (Var[id; (κ ∘ₖ P) θ] +
          (∫ y, y ∂((κ ∘ₖ P) θ) - τ θ) ^ 2)
```

平方损失联合可测性另由 `Measurable τ` 推出，避免在纯点态分解中加入不需要的全局参数可测条件。

## 已验证的证明链

1. `MemLp Y 2 ν` 经 `MemLp.integrable` 给出一阶可积，经
   `memLp_two_iff_integrable_sq` 给出 `Y²` 可积。
2. 点态展开 `(Y-a)² = Y² - 2aY + a²`，使用 `integral_add`、`integral_sub`、
   `integral_const_mul` 和概率测度的 `integral_const` 计算均方误差。
3. `variance_eq_sub hY` 把 `E[Y²]-E[Y]²` 识别为方差，环恒等式留下
   `(E[Y]-a)²`。
4. 对 estimator 输出律，Markov kernel 复合实例保证每个纤维是概率测度。
5. `MemLp id 2 νθ` 与常函数的二次可积性推出 `(id-τθ)²` 可积；
   `ofReal_integral_eq_lintegral_ofReal` 把实值非负积分精确桥接回已有 ENNReal pointwise-risk 接口。
6. `squaredLoss_jointlyMeasurable` 已由 `fun_prop` 验证 `Measurable τ` 时二元平方损失联合可测。

## 边界

- 本批只处理实值目标和实值估计输出；向量值偏差、协方差矩阵和一般二次型损失未开放。
- 分解是逐参数结论，不自动给出先验平均风险或 Bayes 风险的可积交换版本。
- `MemLp id 2 ((κ ∘ₖ P) θ)` 是每个要使用的参数处的真实二阶矩条件；不从 Markov 性错误推出。
- 没有证明无偏性、最小方差无偏估计、Cramér--Rao、相合性、MLE、Fisher 信息或一般最优估计量
  存在性。

## 后续门建议

若 Main 接受上述 carrier 与签名，可将 `statistics.estimator.bias-variance` 转为
`development_open`，正式文件建议为 `SandronesLibrary/Statistics/BiasVariance.lean`。其余统计推断
条目继续各自冻结。
