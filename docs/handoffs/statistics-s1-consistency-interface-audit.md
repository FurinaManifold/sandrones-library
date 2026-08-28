# S1 估计量相合性接口审计

## 权限与结论

- gate：`statistics.estimator.consistency` 当前为 `research_open`。
- 本批只在 `/tmp/StatisticsConsistencyAudit.lean` 调查估计量序列、逐参数／一致相合量词和
  `TendstoInMeasure` 组装；没有新增正式模块、Entry 或 verified 声明。
- 临时文件已完整证明逐参数相合的偏差概率展开和 `L² → 概率` 充分条件，并类型检查一致相合的
  `ENNReal iSup` 量词；无错误、warning 或 `sorry`。

建议首批采用共同观测空间上的确定性估计量序列 `T : ℕ → 𝓧 → ℝ`。统计模型
`P : Kernel Θ 𝓧` 给出每个参数下的共同无限样本分布，`T n` 被理解为只使用前 `n` 份信息；本批不
额外形式化“只依赖前 n 个坐标”的 filtration／可测子代数条件。这样每个固定参数下所有 `T n` 都在
同一概率空间 `(𝓧,P θ)` 上，能够直接使用 `TendstoInMeasure`。

## 为什么首批不直接使用随机化 kernel 序列

随机化估计量 `κ n : Kernel 𝓧 ℝ` 只给出每个 `n` 的输出分布，未给出把所有随机化输出放在同一
概率空间上的 coupling。`TendstoInMeasure` 需要共同底空间上的函数序列，不能仅由一族边缘输出律
直接构造。可以用偏差概率趋零定义 kernel 序列相合，但那是分布族量词而不是原生
`TendstoInMeasure`。

因此建议当前条目以确定性估计量序列为主 carrier，并通过既有 `Kernel.deterministic` 理解为随机化
估计量的特例。随机化序列的一般 coupling 版本另行研究，不能静默混入。

## 概念冻结建议

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | 拟定 Entry |
|---|---|---|---|---|---|---|
| 估计量序列 | 每个样本量一个实值统计量 | `T : ℕ → 𝓧 → ℝ` | 每项可测／a.e. 强可测 | 共同观测空间使收敛 carrier 可组装 | 点态相合 | `statistics.estimator.consistency` |
| 估计目标 | 参数对应的真实实值 | `τ : Θ → ℝ` | 固定参数时为常函数 | 与偏差—方差条目一致 | 极限 | 同上 |
| 逐参数相合 | 每个固定参数下依概率收敛 | `∀ θ, TendstoInMeasure (P θ) T atTop (fun _ ↦ τ θ)` | 偏差概率展开 | 直接复用 Pr3 carrier | pointwise theorem | 同上 |
| 一致相合 | 偏差概率对参数一致趋零 | `∀ ε>0, Tendsto (fun n ↦ ⨆ θ, P θ bad(n,θ,ε)) atTop (𝓝 0)` | ENNReal 上确界 | 不能误写成 `∀ θ` pointwise | uniform theorem | 同上 |
| 均方相合 | `L²` 误差趋零 | `eLpNorm (T n - const (τ θ)) 2 (P θ) → 0` | `convergesInLp_inProbability` | 稳定正式 carrier | 概率相合充分条件 | 同上 |
| MSE 分解 | 方差加偏差平方 | 既有 `squaredError_integral_eq_variance_add_bias_sq` | 实积分恒等式 | 用于由 variance/bias 推 MSE | 均方相合 | 同上 |

## 建议逐参数签名

展开定理：

```lean
theorem pointwiseConsistency_iff
    (P : Kernel Θ 𝓧) [IsMarkovKernel P]
    (T : ℕ → 𝓧 → ℝ) (τ : Θ → ℝ) (θ : Θ) :
    TendstoInMeasure (P θ) T atTop (fun _ ↦ τ θ) ↔
      ∀ ε : ℝ, 0 < ε →
        Tendsto (fun n ↦ (P θ).real {x | ε ≤ |T n x - τ θ|}) atTop (𝓝 0)
```

这已在临时文件中由 `convergesInProbability_iff_measureReal_dist` 直接验证。

稳定的均方充分条件：

```lean
theorem pointwiseConsistent_of_L2
    (hT : ∀ n, AEStronglyMeasurable (T n) (P θ))
    (hL2 : Tendsto
      (fun n ↦ eLpNorm (T n - fun _ ↦ τ θ) 2 (P θ)) atTop (𝓝 0)) :
    TendstoInMeasure (P θ) T atTop (fun _ ↦ τ θ)
```

该签名已完整证明，直接复用本库 `convergesInLp_inProbability`。

## 一致相合量词

一致相合不是

```lean
∀ θ, pointwise consistent at θ
```

而是先对参数取最坏偏差概率，再令样本量趋于无穷。为避免 `ℝ` 缺少无条件完全格结构，建议保持
原始 `ENNReal` 测度：

```lean
∀ ε : ℝ, 0 < ε →
  Tendsto
    (fun n ↦ ⨆ θ,
      P θ {x | ENNReal.ofReal (ε ^ 2) ≤
        ENNReal.ofReal ((T n x - τ θ) ^ 2)})
    atTop (𝓝 0)
```

平方事件与绝对偏差事件在 `ε>0` 时等价；正式开发可选更易组装的一种并提供等价桥。上述 ENNReal
`iSup` 版本已在 `/tmp` 类型检查。要由 pointwise 推 uniform 必须有额外一致控制，不能自动获得。

## 偏差／MSE 充分条件

对固定 `θ`，若每个 `T n` 二次可积，则偏差—方差条目给出

\[
  \operatorname{MSE}_{\theta}(T_n)
  =\operatorname{Var}_{P_\theta}(T_n)
   +(\mathbb E_\theta T_n-\tau(\theta))^2.
\]

因此以下链条有效：

1. 方差趋零且偏差趋零；
2. 由连续乘法、平方和加法，实值 MSE 趁零；
3. 非负实积分经 `ofReal_integral_eq_lintegral_ofReal` 对应平方误差的 ENNReal `lintegral`；
4. 或将其识别为 `L²` seminorm 的平方，得到 `eLpNorm` 趋零；
5. 调用 `pointwiseConsistent_of_L2`，得到概率相合。

正式开发建议先发布已验证的 `L² → 概率` 结论，再补“MSE 趋零”和“variance+bias 趋零”两个
具名消费者。若 `eLpNorm` 与实值 MSE 的精确平方根归一化导致接口噪声，也可直接对平方误差使用本库
`markov_inequality`；不得把未完成的转换写成显然等式。

## 边界

- 共同观测空间版本不自动编码 `T n` 只依赖前 `n` 个样本；该适应性／坐标可测性条件后续单列。
- 一般变化样本空间 `𝓧 n` 的统计实验不能直接使用同一个 `TendstoInMeasure`，需要输出律偏差量词。
- 随机化 kernel 序列需要共同随机源或仅以边缘输出律定义相合，本批不冒充已解决。
- 不进入渐近正态、MLE 相合、Fisher、Cramér--Rao、充分性或一般最优性。

## 后续门建议

若 Main 接受共同观测空间、pointwise、uniform 与 `L²` 三层接口，可将
`statistics.estimator.consistency` 转为 `development_open`，正式文件建议为
`SandronesLibrary/Statistics/Consistency.lean`。MLE 等条目继续冻结。
