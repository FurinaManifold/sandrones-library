---
id: statistics.information.cramer-rao
family: statistics.information
variant: textbook
kind: theorem
state: verified
title: Fisher 信息与 Cramér–Rao 下界
summary: 以支配测度上的实值密度族承载模型测度与 Fisher 信息，把微分与积分可交换写成显式正则条件，并证明 Cramér–Rao 下界及其教材形式
premises: [statistics.model.density, statistics.estimator.bias-variance]
mathlib: [ProbabilityTheory.Kernel.rnDeriv, MeasureTheory.integral, MeasureTheory.Measure.withDensity, MeasureTheory.integral_mul_norm_le_Lp_mul_Lq, ProbabilityTheory.variance]
provenance:
  source_type: book
  ref: "schervish-theory-statistics-1995"
---

# 动机

Cramér–Rao 下界说：无偏估计量的方差不可能小于 Fisher 信息的倒数。它的证明只有两行——

\[
  \operatorname{Cov}_\theta(T,s_\theta)=g'(\theta),
  \qquad
  \operatorname{Cov}_\theta(T,s_\theta)^2\le \operatorname{Var}_\theta(T)\operatorname{Var}_\theta(s_\theta)
  =\operatorname{Var}_\theta(T)I(\theta)
\]

——但第一行并不是自动的。它要求**微分与积分可交换**：

\[
  \frac{d}{d\theta}\int T\,p_\theta\,d\nu=\int T\,\frac{\partial p_\theta}{\partial\theta}\,d\nu .
\]

这是一条**实质假设**，不是技术细节。教材把它拆成"支撑集不随 `θ` 变 + 逐点可微 + 被可积控制
函数支配"再引用支配收敛定理；一旦支撑集随参数移动（例如均匀分布 `U(0,\theta)`），下界就失效。
因此本条目**不**把这条交换性默默替换成 Mathlib 的某个强定理，而是把它逐字写进公开签名：

* 结构 `IsRegularDominatedFamily` 的字段 `deriv_integral_swap`（密度侧）；
* 主定理 `cramerRao_lower_bound` 的假设 `hswap`（统计量侧）。

# 教材定义与量词

固定支配测度 `ν` 与实值密度族 `p : ℝ → 𝓧 → ℝ`。参数 `θ` 下的**模型测度**是

\[
  \mu_\theta=\nu\text{-}{\rm withDensity}\bigl(x\mapsto \mathrm{ofReal}\,p_\theta(x)\bigr).
\]

若 `p_θ ≥ 0` 且 `∫ p_θ dν = 1`，则 `μ_θ` 是概率测度（`isProbabilityMeasure_modelMeasure`）。
**得分函数** `s : ℝ → 𝓧 → ℝ` 是 `∂_θ log p_θ` 的正式承载。本条目**不**通过链式法则从 `p`
构造 `s`：`s` 是模型的一部分，被显式给出。

**Fisher 信息**取得分函数平方的模型期望：

\[
  I(\theta)=\int (s_\theta)^2\,p_\theta\,d\nu=E_\theta[s_\theta^2].
\]

**Cramér–Rao 下界**：设统计量 `T : 𝓧 → ℝ` 的均值函数是 `g(θ) = E_θ[T]`，若
`T` 与 `s_θ` 在 `μ_θ` 下二阶可积，且 `g` 满足交换性假设，则

\[
  g'(\theta)^2\le I(\theta)\operatorname{Var}_\theta(T).
\]

`I(θ) > 0` 时即教材形式 `g'(θ)² / I(θ) ≤ Var_θ(T)`；无偏（`g = id`）时即
`Var_θ(T) ≥ 1/I(θ)`。

# Lean 正式承载

```lean
noncomputable def modelMeasure (ν : Measure 𝓧) (p : ℝ → 𝓧 → ℝ) (θ : ℝ) : Measure 𝓧 :=
  ν.withDensity fun x => ENNReal.ofReal (p θ x)

structure IsRegularDominatedFamily (ν : Measure 𝓧) (p : ℝ → 𝓧 → ℝ)
    (s : ℝ → 𝓧 → ℝ) : Prop where
  aemeasurable_density : ∀ θ, AEMeasurable (p θ) ν
  nonneg_density : ∀ θ, 0 ≤ᵐ[ν] p θ
  integrable_density : ∀ θ, Integrable (p θ) ν
  density_integral_eq_one : ∀ θ, ∫ x, p θ x ∂ν = 1
  score_sq_integrable : ∀ θ, Integrable (fun x => (s θ x) ^ 2 * p θ x) ν
  deriv_integral_swap : ∀ θ,
    HasDerivAt (fun θ' => ∫ x, p θ' x ∂ν) (∫ x, s θ x * p θ x ∂ν) θ
```

最后一条字段就是"微分与积分可交换"，写成 `HasDerivAt` 的原始形式：总质量积分
`θ' ↦ ∫ x, p θ' x ∂ν` 在 `θ` 处可微，导数恰是 `∫ x, s θ x * p θ x ∂ν`。它**不**断言
`∫ s θ · p θ = 0`——后者是它的推论：

```lean
theorem score_integral_eq_zero (h : IsRegularDominatedFamily ν p s) (θ : ℝ) :
    ∫ x, s θ x * p θ x ∂ν = 0
```

因为 `θ' ↦ ∫ p θ'` 恒等于常数一（`density_integral_eq_one`），常数函数的导数为零，由导数
唯一性（`HasDerivAt.unique`）得到结论。这是交换性假设在证明中的第一次真实使用。

模型测度与密度加权积分之间由 `integral_modelMeasure` 桥接：

```lean
theorem integral_modelMeasure (h : IsRegularDominatedFamily ν p s) (θ : ℝ) (F : 𝓧 → ℝ) :
    ∫ x, F x ∂(modelMeasure ν p θ) = ∫ x, F x * p θ x ∂ν
```

它由 `withDensity` 的积分桥 `integral_withDensity_eq_integral_toReal_smul₀`（根命名空间） 与
`ENNReal.toReal_ofReal` 得到，是"密度的期望"与"密度的加权积分"两种写法的唯一接口。

主定理的结论左端写成 `deriv (densityMean ν p T) θ`，其中
`densityMean ν p T θ = ∫ x, T x * p θ x ∂ν` 是均值函数 `g`：

```lean
theorem cramerRao_lower_bound (h : IsRegularDominatedFamily ν p s) (T : 𝓧 → ℝ) (θ : ℝ)
    (hT : MemLp T 2 (modelMeasure ν p θ))
    (hs : MemLp (s θ) 2 (modelMeasure ν p θ))
    (hswap : HasDerivAt (densityMean ν p T) (∫ x, T x * s θ x * p θ x ∂ν) θ) :
    (deriv (densityMean ν p T) θ) ^ 2 ≤
      fisherInformation ν p s θ * variance T (modelMeasure ν p θ)
```

把左端写成 `deriv` 而不是直接写 `∫ T s p` 是刻意的：这样 `hswap` 在证明中通过
`HasDerivAt.deriv` 被**真正使用**（用来把 `g'(θ)` 识别为 `∫ x, T x * s θ x * p θ x ∂ν`），
而不是一条与结论无关的装饰性假设。

# 关键性质与证明思路

**柯西–施瓦茨。** `sq_integral_mul_le_integral_sq_mul_integral_sq` 证明

\[
  \Bigl(\int fg\,d\mu\Bigr)^2\le\Bigl(\int f^2\,d\mu\Bigr)\Bigl(\int g^2\,d\mu\Bigr),
\]

用 Mathlib 的 Hölder 不等式 `integral_mul_norm_le_Lp_mul_Lq`（`p = q = 2`）加绝对值积分不等式
证明，不经过 `Lp` 商空间、也不重造 `MemLp`。这是一条一般引理，与统计无关，放在本文件中是因为
它是 Cramér–Rao 的纯分析核心。

**主定理的组装。**

1. 由 `hswap` 与 `integral_modelMeasure` 把交换性搬到模型测度形式，再用 `HasDerivAt.deriv`
   把 `deriv (densityMean ν p T) θ` 改写为 `∫ x, T x * s θ x ∂μ`。
2. 由 `score_integral_eq_zero` 与 `integral_modelMeasure` 得 `∫ x, s θ x ∂μ = 0`。
3. 对 `f = T - E_θ T` 与 `g = s_θ` 用柯西–施瓦茨；左端展开时
   `∫ (T - E_θT)·s_θ = ∫ T·s_θ - E_θT·∫ s_θ = ∫ T·s_θ`（可积性由 `MemLp.integrable_mul`
   与 `Integrable.const_mul` 提供）。
4. 右端 `∫ (T - E_θT)² ∂μ` 用 `statistics.estimator.bias-variance` 的
   `squaredError_integral_eq_variance_add_bias_sq` 写成 `Var_θ(T) + 0`；
   `∫ (s_θ)² ∂μ` 用 `fisherInformation_eq_integral_modelMeasure` 换回 Fisher 信息。

**教材形式与无偏形式。** `cramerRao_variance_ge` 在 `I(θ) > 0` 时给出
`g'(θ)²/I(θ) ≤ Var_θ(T)`；`cramerRao_variance_ge_inv_of_unbiased` 在 `g = id`（无偏）时给出
`1/I(θ) ≤ Var_θ(T)`。`fisherInformation_nonneg` 说明 Fisher 信息非负。

# 与 `statistics.model.density` 的桥

本条目以实值密度族 `p` 为输入，而 `statistics.model.density` 冻结的是 kernel 的
`ℝ≥0∞` 值联合可测 Radon–Nikodym 密度。两者由
`modelMeasure_kernelDensity_eq` 对齐：

```lean
theorem modelMeasure_kernelDensity_eq (P : Kernel ℝ 𝓧) [IsMarkovKernel P] (ν : Measure 𝓧)
    [IsFiniteMeasure ν] [MeasurableSpace.CountableOrCountablyGenerated ℝ 𝓧]
    (hPν : ∀ θ, P θ ≪ ν) (θ : ℝ) :
    modelMeasure ν (fun θ x => (P.rnDeriv (Kernel.const ℝ ν) θ x).toReal) θ = P θ
```

右端的实值密度族就是本条目 `p` 在支配 kernel 模型上的标准取值：两个 `withDensity` 只在
`ν`-零测集上可能不同（`ℝ≥0∞` 密度取无穷的点），由 `statisticalModel_density_ne_top_ae` 排除。
这条桥说明 `statistics.model.density` 是本条目的真实前提，而不是概念上的邻居。

# Mathlib 角色分类

- `MeasureTheory.Measure.withDensity`：**语义一致的正式承载**。模型测度就是密度加权测度，不另建
  "概率密度"结构。
- `ProbabilityTheory.Kernel.rnDeriv`（经 `statistics.model.density`）：**桥侧接口**，把 kernel 模型的密度接到
  实值密度族；只在 `modelMeasure_kernelDensity_eq` 中出现。
- `MeasureTheory.integral_mul_norm_le_Lp_mul_Lq`：**私有证明后端**，柯西–施瓦茨的实现手段；
  公开结论是 `sq_integral_mul_le_integral_sq_mul_integral_sq`。
- `ProbabilityTheory.variance`：**语义一致的正式承载**，与偏差—方差条目共用同一方差载体。
- `HasDerivAt` / `HasDerivAt.deriv`：**语义一致的正式承载**，把"微分与积分可交换"写成原始
  ε-δ 形式（`HasDerivAt`），不使用 `deriv` 的隐式可微约定来掩盖假设。
- `integral_withDensity_eq_integral_toReal_smul₀`、
  `MeasureTheory.ofReal_integral_eq_lintegral_ofReal`：证明后端。

# 依赖与边界

依赖 `statistics.model.density`（`statisticalModel_withDensity_eq`、
`statisticalModel_density_ne_top_ae`）与 `statistics.estimator.bias-variance`
（`squaredError_integral_eq_variance_add_bias_sq`）。两条依赖都有真实的声明消费者。

**本条目不证明**：

- **不从 Mathlib 的支配收敛型微分定理推导交换性**，也不证明它在任何具体模型（指数族、正态族、
  均匀族）中成立。课程级的充分条件（支撑集不随 `θ` 变、逐点可微、被可积控制函数支配）到
  `deriv_integral_swap` 的推导登记为后续桥，而不是已完成的定理。
- 不证明 `s` 与密度对数导数 `∂_θ log p_θ` 的链式法则关系；`s` 是本条目的显式输入。
- 不把 `statistics.model.density` 的 `ℝ≥0∞` 值 kernel 密度自动转成实值 `p`：桥
  `modelMeasure_kernelDensity_eq` 只对齐两个测度，不证明 `IsRegularDominatedFamily` 的
  可积性与归一化字段对 kernel 密度成立（那需要 `∫⁻` 到 `∫` 的额外换算）。
- 不证明 Fisher 信息与支配测度 `ν` 的选择无关（不变量性质），也不给出多参数 Fisher 信息矩阵、
  渐近有效性或 Cramér–Rao 下界可达性的讨论。
- Mathlib 的 `deriv` 在不可微点约定取 `0`，因此主定理只在交换性假设 `hswap` 成立处有意义；
  本条目不使用 `deriv` 的隐式约定去"免费"获得可微性。
