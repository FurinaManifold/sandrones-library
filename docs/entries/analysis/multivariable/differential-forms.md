---
id: analysis.multivariable.differential-forms
kind: theorem
state: verified
title: "微分形式、外微分与连续楔积"
premises: ["linear-algebra.tensor-exterior", "analysis.multivariable.frechet",
  "topology.orientation.vector-space"]
mathlib: ["ContinuousAlternatingMap.compContinuousLinearMap", "extDeriv", "extDeriv_add",
  "extDeriv_smul", "extDeriv_constOfIsEmpty", "extDeriv_extDeriv", "extDeriv_pullback",
  "extDeriv_apply", "AlternatingMap.domCoprod", "AlternatingMap.domCoprod'",
  "AlternatingMap.mkContinuous", "LinearMap.mk₂", "LinearMap.mkContinuous₂"]
provenance:
  source_type: book
  ref: "经典微分几何：微分形式与外微分"
---

# 动机

切向量描述运动方向，余切向量描述沿方向的线性测量；微分形式把这种测量推广到
有向长度、面积和体积。它们是第二型曲线积分、曲面积分以及 Green、Gauss、Stokes
公式的统一语言。

# 直觉

`k`-形式 `ω` 在每一点 `x` 接收 `k` 个切向量，并交替、连续、逐变量线性地输出实数。
拉回把目标空间上的形式沿映射搬回源空间；外微分把 `k`-形式升为 `k+1`-形式，
并满足 `d(dω)=0`。

# 陈述（自然语言）

- 实函数自然视为零次形式。
- 映射 `f : E → F` 通过导数把 `F` 上的形式拉回到 `E`。
- 外微分关于形式的加法和常数数乘线性。
- 函数作为零次形式的外微分就是其 Fréchet 微分对应的一次形式。
- 二次外微分恒为零：`d²=0`。
- 对充分光滑的映射，外微分与拉回交换：`d(f*ω)=f*(dω)`。
- 恰当形式必为闭形式，闭形式的光滑拉回仍为闭形式。
- 外微分可写成逐个删去方向并按 `(-1)ⁱ` 求和的教材交替公式。
- 忘掉连续性后，两个交替形式可按 shuffle 公式作楔积；该运算对两个变量分别可加，
  并且任一因子为零时楔积为零。
- 有限 shuffle 和满足显式算子范数界，因此代数楔积可重新打包为连续交替映射，
  从而定义真正的微分形式楔积 `formWedge`。
- 连续楔积在两个变量上分别可加，并有左右零元；有限指标等价可用于连续交替映射
  和微分形式的次数重编号。
- 楔积被进一步打包为带显式范数界的连续双线性算子 `wedgeContinuousBilinear`。
- 两个点可微微分形式的楔积仍然点可微。

# 陈述（Lean 对照）

核心定义为 `DifferentialForm`、`functionAsZeroForm`、`formPullback` 和
`exteriorDerivative`。主要定理为 `exteriorDerivative_zeroForm`、
`exteriorDerivative_squared_zero` 与 `exteriorDerivative_pullback`。
闭形式与恰当形式由 `IsClosedForm`、`IsExactForm` 表示，并有
`exactForm_isClosed`、`closedForm_pullback` 和 `exteriorDerivative_apply`。
楔积的代数层由 `AlgebraicDifferentialForm`、`forgetFormContinuity`、
`alternatingWedge` 和 `algebraicFormWedge` 给出，并公开左右加法性与零元定理。
连续层由 `alternatingWedge_summand_bound`、`alternatingWedge_bound`、
`continuousAlternatingWedge` 与 `formWedge` 给出。
连续层双线性接口为 `continuousAlternatingWedge_add_left/right` 与
`formWedge_add_left/right`；`continuousAlternatingReindex` 和 `reindexForm`
负责把结合方式不同的相同总次数统一到同一个 `Fin` 指标类型。
`wedgeLinearMap` 与 `wedgeContinuousBilinear` 分别给出代数和连续双线性封装。
`NormalizedAlternatingSpace` 隔离 mathlib 半范数/范数实例选择，
`differentiableAt_formWedge` 经该规范模型证明楔积保持点可微性。

# 思维脉络（thinking trace）

形式的点态对象采用连续交替映射，以便直接使用 Fréchet 微分。拉回在点 `x` 用
`Df(x)` 预合成目标形式；外微分则对形式场先作 Fréchet 微分，再对方向变量交替化。
二阶导数的对称性与交替化相消，从而得到 `d²=0`。
楔积先由 `AlternatingMap.domCoprod` 对 shuffle 求带符号和，再用
`TensorProduct.lid` 将两个实数的张量积收缩为乘积。这里暂时只忘掉连续性，
先把代数构造和连续性估计分开；随后对每个 shuffle 项应用两个因子的算子范数界，
再对有限和使用三角不等式，最后由 `AlternatingMap.mkContinuous` 恢复连续结构。

# 自然语言 ↔ Lean 映射

- `Ωᵏ(E)` ↔ `DifferentialForm E k`
- `ωₓ(v₁,…,vₖ)` ↔ `formValue ω x v`
- `f*ω` ↔ `formPullback f ω`
- `dω` ↔ `exteriorDerivative ω`
- `ω∧η`（代数层）↔ `algebraicFormWedge ω η`
- `ω∧η`（连续形式）↔ `formWedge ω η`
- 次数等式下的形式重编号 ↔ `reindexForm`

# 依赖（人话版）

依赖赋范线性空间、连续交替多重线性映射、Fréchet 导数以及此前建立的外代数语言。

# 应用与陷阱

- 当前定义域是赋范向量空间，不是一般流形；流形版本需先建立切丛和坐标图兼容性。
- `formPullback` 使用全导数；在不可微点 mathlib 的 `fderiv` 按默认值处理，因此实际
  定理必须带相应可微或光滑假设。
- `d²=0` 需要二阶光滑性，不能只从一次可微推出。
- 当前楔积已经完成代数构造、有限 shuffle 范数估计和连续性封装；外微分 Leibniz
  法则所需的双线性与可微性前置也已完成；积分所需的线性定向已经由拓扑层提供，
  并在本模块包装为正向线性重参数化。分次组合恒等式和 Poincaré 引理仍属于下一批。
  de Rham 上同调不在本条目及本阶段范围内，已移至后续微分几何/代数拓扑路线。
