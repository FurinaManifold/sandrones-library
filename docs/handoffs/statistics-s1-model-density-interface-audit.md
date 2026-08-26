# S1 统计模型、密度与 Radon--Nikodym 接口审计

## 权限与结论

本文件只执行 Main 开放的 `research_open` 接口审计，不新增统计学 Lean 模块、Entry、估计量或一般
估计定理。结论是：S1 不应先自建一个与 Mathlib 决策论平行的 `StatisticalModel` 结构；可测参数化
统计实验已有成熟正式承载 `P : ProbabilityTheory.Kernel Θ 𝓧`，模型中每个 `P θ` 为概率测度的条件
由 `[IsMarkovKernel P]` 承载。

## 教材语义与正式承载

| 概念 | 教材定义／语义 | Lean 候选承载 | 展开／一手性质 | 复用或桥 | 首个真实使用者 | 当前门 |
|---|---|---|---|---|---|---|
| 统计模型 | 样本空间上一族由 `θ` 编号的概率测度 | `P : Kernel Θ 𝓧` 与 `[IsMarkovKernel P]` | `IsMarkovKernel.isProbabilityMeasure θ` | 直接复用 Mathlib 决策论的数据生成 kernel | `avgRisk`／`bayesRisk`／`minimaxRisk` | definition 待 Main 开放 |
| 任意参数族 | 教材有时不要求参数依赖可测 | 给 `Θ` 取离散可测结构后进入 kernel，或另设轻量桥 | 需证明 family 到 kernel 的可测性 | 不宜直接另造主 carrier | 一般模型到决策模型桥 | Main 需决定是否公开 |
| 支配模型 | 存在参考测度 `ν`，使每个 `P θ ≪ ν` | 点态 `P θ ≪ ν`；参考 kernel `Kernel.const Θ ν` | 每参数绝对连续 | 固定参考测度转常 kernel | likelihood | density definition 待开放 |
| 点态 RN 密度 | `dPθ/dν`，只在 `ν`-a.e. 意义唯一 | `(P θ).rnDeriv ν` | `withDensity_rnDeriv_eq`、积分重建 | Measure 级 API 支持一般 Lebesgue 分解条件 | 单参数概率计算 | 可用但不足以直接做联合似然 |
| 联合可测密度 | `(θ,x) ↦ dPθ/dν(x)` 可测 | `Kernel.rnDeriv P (Kernel.const Θ ν)` | `Kernel.measurable_rnDeriv`、逐参数与 Measure RN a.e. 相等 | 直接复用 kernel RN，不逐参数选择版本 | likelihood／Bayes risk | 需满足真实类型类边界 |
| 随机变量 PDF | 分布相对参考测度的 RN 密度 | `HasPDF X ℙ ν`、`pdf X ℙ ν` | `map_eq_withDensity_pdf`、LOTUS | 适用于单个随机变量分布，不是参数模型 carrier | 分布例子 | S1 模型层只引用，不替代 model density |

## 为什么模型应优先使用 Markov kernel

Mathlib 的决策论已经把：

- 数据生成机制写成 `P : Kernel Θ 𝓧`；
- 随机化估计量写成 `κ : Kernel 𝓧 𝓨`；
- 损失写成 `ℓ : Θ → 𝓨 → ℝ≥0∞`；
- 平均风险、Bayes 风险和 minimax 风险分别写成 `avgRisk`、`bayesRisk`、`minimaxRisk`。

因此若本库另建携带同一族测度的 `StatisticalModel`，后续每个估计定理都必须再造桥，且很容易丢失
参数可测性。`Kernel` 本身就是“到测度空间的可测函数”，`IsMarkovKernel` 精确补上每个纤维总质量
为一。教材不要求参数可测时，可以把参数集赋予离散可测结构；是否把这一桥公开，应由 Main 在
definition 开发门开启前确定，而不是现在静默固定。

## 两种 RN 密度不能混用

### Measure 级

对单个 `P θ` 与参考测度 `ν`，`Measure.rnDeriv` 给出 `𝓧 → ℝ≥0∞`。在
`HaveLebesgueDecomposition (P θ) ν` 和 `P θ ≪ ν` 下，

`ν.withDensity ((P θ).rnDeriv ν) = P θ`。

这足以重建每个固定参数下的概率，但分别选择的密度不自动保证 `(θ,x)` 联合可测。因此它不能直接
支撑一般 likelihood、风险积分或 Bayesian posterior 的参数积分。

### Kernel 级

`Kernel.rnDeriv P Q θ x` 被专门构造成 `(θ,x)` 联合可测，并满足：

- `Kernel.measurable_rnDeriv`；
- `Kernel.rnDeriv_eq_rnDeriv_measure`：逐参数与 Measure 级 RN 导数 `Q θ`-a.e. 相等；
- `Kernel.withDensity_rnDeriv_eq`：若 `P θ ≪ Q θ`，则用该密度重建 `P θ`；
- `Kernel.setLIntegral_rnDeriv`：可测集合上的积分等于 `P θ` 的概率。

对固定支配测度取 `Q = Kernel.const Θ ν`，就得到课程真正需要的联合可测 likelihood 版本。

## 不可隐藏的类型类边界

1. `Kernel.rnDeriv` 要求
   `MeasurableSpace.CountableOrCountablyGenerated Θ 𝓧`。这是联合可测版本的真实存在边界，不能从
   公开签名中删除。
2. 当前重建和逐纤维一致性 API 使用 `[IsFiniteKernel P] [IsFiniteKernel Q]`。Markov 模型 `P`
   自动有限；固定参考测度 `ν` 若要直接变成这样的 `Q`，应至少是有限测度。一般仅 σ-有限参考
   测度可使用 Measure 级 RN，但转成联合可测 kernel likelihood 还需要额外桥或等价有限参考测度。
3. RN 密度取值于 `ℝ≥0∞`，不是未经证明就取 `ℝ`。只有先证明密度有限 a.e. 后才能安全使用
   `.toReal`。
4. 密度只在参考测度 a.e. 意义唯一。似然比、MLE 和 Fisher 信息必须避免依赖任意零测集上的版本。
5. `HasPDF`／`pdf` 描述单个随机变量的推前分布；它不能替代参数化模型及其联合密度。

## 建议的 S1 开发顺序

1. `statistics.model.definition`：直接公开 `Kernel Θ 𝓧` + `IsMarkovKernel` 的教材解释，并给出
   “每个纤维是概率测度”的展开；不建新 carrier。
2. 在同一或独立 density Entry 中冻结“由有限参考测度支配”的版本：`P θ ≪ ν`，likelihood 使用
   `Kernel.rnDeriv P (Kernel.const Θ ν)`，保留 countable/countably-generated 假设。
3. 证明联合可测、逐参数重建、积分为一和 a.e. 唯一性后，才开放 likelihood/MLE。
4. `statistics.estimator.definition` 应复用 Mathlib 的随机化 estimator `Kernel 𝓧 𝓨`；确定性估计量
   通过 `Kernel.deterministic` 进入统一接口。
5. 一般估计定理继续冻结；先由 Main 决定是否需要“任意非可测参数族 → 离散参数 kernel”的公开桥。

## 已核验接口

临时文件 `/tmp/StatisticsModelDensityAudit.lean` 已成功 `#check`：`Kernel`、`IsMarkovKernel`、
`avgRisk`、`bayesRisk`、`minimaxRisk`、`HasPDF`、`pdf`、Measure 级 RN 重建，以及 Kernel 级
`rnDeriv`、联合可测性、逐参数一致性、重建与集合积分公式。没有新增正式源码或越过 S1 研究门。
