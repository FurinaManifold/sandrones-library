# S1 估计量、损失与风险接口审计

## 权限与结论

- gate：`statistics.estimator.definition` 当前为 `research_open`。
- 本批仅调查 Mathlib carrier 并冻结建议签名；不新增统计 Lean 模块、Entry 或 verified 声明。
- `/tmp/StatisticsEstimatorAudit.lean` 已成功检查本文列出的 carrier、构造、风险和 Bayes 接口。

结论：统计量／确定性估计量应由可测映射承载；随机化估计量应直接使用 Markov kernel。不要再建
`Estimator` 结构。损失函数直接取联合可测的 `ℓ : Θ → 𝓨 → ℝ≥0∞`。Mathlib 没有给逐参数风险
单独命名，而是原样使用积分；`avgRisk`、`bayesRisk` 和 `minimaxRisk` 已是成熟正式定义。

## 概念冻结建议

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | 拟定 Entry |
|---|---|---|---|---|---|---|
| 统计量 | 样本的可测函数 | `T : 𝓧 → 𝓨` 与 `Measurable T` | 不另建结构 | 与确定性估计量同 carrier，语义由目标空间解释 | 确定性 estimator kernel | `statistics.estimator.definition` |
| 随机化估计量 | 给定数据 `x` 后输出估计值的条件分布 | `κ : Kernel 𝓧 𝓨` 与 `[IsMarkovKernel κ]` | 每个 `κ x` 是概率测度 | 与 Mathlib 决策论完全一致 | 输出律与风险 | `statistics.estimator.definition` |
| 确定性估计量桥 | 输出唯一值 `T x` | `Kernel.deterministic T hT` | `isMarkovKernel_deterministic`；与模型复合等于 `P.map T` | 可测映射进入统一随机化接口 | 逐参数风险 | `statistics.estimator.definition` |
| 损失 | 真参数 `θ` 与行动 `y` 的非负代价 | `ℓ : Θ → 𝓨 → ℝ≥0∞`，下游保留 `Measurable (uncurry ℓ)` | 非负扩展实值避免先验可积性假设 | 不另建 loss structure | 风险积分 | `statistics.estimator.definition` |
| 逐参数风险 | 参数固定时的期望损失 | `∫⁻ y, ℓ θ y ∂((κ ∘ₖ P) θ)` | Mathlib 刻意不设独立 def | 复合 kernel 是估计输出在 `θ` 下的分布 | 平均风险／minimax | `statistics.estimator.definition` |
| 平均风险 | 逐参数风险关于先验 `π` 的平均 | `avgRisk ℓ P κ π` | 双重 `lintegral` 的定义性展开 | 成熟定义 | Bayes risk | `statistics.estimator.definition` |
| Bayes 风险 | 所有随机化估计量平均风险的下确界 | `bayesRisk ℓ P π` | 对 `κ` 与 `IsMarkovKernel κ` 的 `iInf` | 是 infimum，不自动存在最优估计量 | `IsBayesEstimator` | `statistics.estimator.definition` |

## 统计量与估计量的 carrier

教材中统计量是样本的可测函数。若其值被解释为未知量的估计，就称为确定性估计量；Lean 层没有
理由因教材称呼不同而复制 carrier：

```lean
T : 𝓧 → 𝓨
hT : Measurable T
```

Mathlib 决策论采用更一般的随机化估计量：

```lean
κ : Kernel 𝓧 𝓨
[IsMarkovKernel κ]
```

其中 `κ x` 是观察到 `x` 后估计输出的概率分布。确定性映射通过
`Kernel.deterministic T hT` 变为 Markov kernel。与数据生成模型 `P : Kernel Θ 𝓧` 复合后，
`(κ ∘ₖ P) θ` 是真实参数 `θ` 下估计输出的分布。确定性情形由
`Kernel.deterministic_comp_eq_map` 化为 `P.map T`，不应另造平行的风险理论。

一个关键签名边界是：单有 `κ : Kernel 𝓧 𝓨` 只保证可测的测度族，不保证每个纤维总质量一。
课程称其为随机化估计量时必须同时保留 `[IsMarkovKernel κ]`。Mathlib 的 `avgRisk` 定义本身接受
任意 kernel，但 `bayesRisk` 的下确界只量化 Markov kernels；本库公开教材接口时不能把这一差异
静默丢掉。

## 损失函数与逐参数风险

Mathlib 使用

```lean
ℓ : Θ → 𝓨 → ℝ≥0∞
```

作为损失。非负扩展实值允许风险为无穷，也免于在定义前强加可积性。`avgRisk` 的裸定义可以对任意
函数使用 `lintegral`，但 Fubini、posterior 与 Bayes estimator 等课程定理通常需要
`Measurable (Function.uncurry ℓ)`。建议正式 Entry 把联合可测性作为有意义损失的公开假设，而不把
它封装进新 structure。

给定模型 `P`、估计量 `κ` 和参数 `θ`，逐参数风险是

```lean
∫⁻ y, ℓ θ y ∂((κ ∘ₖ P) θ)
```

Mathlib 的 `Risk/Defs.lean` 明确说明没有为它另设定义，只在定理名中称为 risk。本库应尊重这个
决定：可提供教材注释和展开定理，但不再定义一个仅仅展开为该积分的 `risk`。

## 平均风险、Bayes 风险与最优估计量

`avgRisk ℓ P κ π` 定义为

\[
  \int_\Theta\int_{\mathcal Y}\ell(\theta,y)
  \,d((\kappa\circ P)_\theta)(y)\,d\pi(\theta).
\]

`bayesRisk ℓ P π` 是所有 Markov estimator kernels 的平均风险下确界。成熟定理
`bayesRisk_le_avgRisk` 表明任一合法估计量的平均风险都不小于 Bayes 风险。

`IsBayesEstimator ℓ P κ π` 表示 `κ` 实际达到这个下确界。它本身不把
`[IsMarkovKernel κ]` 放进定义，所以课程使用时仍须显式保留合法估计量条件。更强的
`IsArgminEstimator` 涉及 posterior、standard Borel 参数空间和可测 argmin 选择，已经超出本次定义
Entry；不能用其存在性假装一般 Bayes 最优估计量总存在。

`minimaxRisk` 也已存在，但建议仅在定义文档中说明，不在本窗口展开 minimax 定理；Main 当前只
开放 estimator definition 调研，一般估计和 minimax 定理仍冻结。

## 建议 development 批的最小组装

若 Main 将窗口转为 `development_open`，建议单一
`SandronesLibrary/Statistics/Estimator.lean` 完成：

1. 可测统计量通过 `Kernel.deterministic` 产生合法 Markov estimator；
2. `κ ∘ₖ P` 是给定参数下估计输出分布，并在确定性情形化为 `P.map T`；
3. 逐参数风险表达式及 `avgRisk` 的双积分展开；
4. `bayesRisk` 是对合法估计量的下确界，并复用 `bayesRisk_le_avgRisk`；
5. 一个真实消费者可取“确定性估计量也进入同一平均风险接口”，但不要提前证明 bias--variance、
   MLE、Fisher 信息或一般最优性结果。

## 不开放的内容

- 不定义 MLE 或处理密度版本在零测集上的逐点 argmax；
- 不定义 Fisher 信息或 Cramér--Rao；
- 不证明偏差--方差、相合性、充分性或一般 Bayes estimator 存在性；
- 不用有限／可数参数求和公式冒充一般统计实验；
- 不把 `IsBayesEstimator` 的等式误读为最优估计量必然存在。

## 后续门建议

请 Main 审核上述 carrier 表，特别确认正式 Entry 是否将随机化 estimator 作为主 carrier，并把可测
函数仅作为 deterministic bridge。若通过，再开放 `statistics.estimator.definition` 正式开发；
其余 S1/S2 定理继续各自等待门控。
