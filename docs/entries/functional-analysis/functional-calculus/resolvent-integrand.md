---
id: functional-analysis.functional-calculus.resolvent-integrand
family: functional-analysis.operator
variant: resolvent-integrand
kind: definition
state: staging
title: 预解恒等式与 Dunford 被积函数
summary: 在尚未引入 cycle 时先建立第一预解恒等式、预解映射在预解集上的全纯性，以及 Dunford 被积函数在紧集上的 Bochner 可积性
premises: [functional-analysis.functional-calculus.holomorphic-neighborhood, functional-analysis.spectrum.definition]
mathlib: [resolvent, resolventSet, spectrum, Ring.inverse, Ring.inverse_sub_inverse, Commute.ringInverse_ringInverse, Algebra.commute_algebraMap_left, spectrum.hasDerivAt_resolvent_const_left, spectrum.isOpen_resolventSet, DifferentiableOn, AnalyticOnNhd, DifferentiableOn.smul, DifferentiableOn.analyticOnNhd, ContinuousOn, IsCompact, IntegrableOn, volume, ContinuousOn.integrableOn_compact]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机：先把积分号里面的东西搞清楚

设 `A` 是复 Banach 代数，`a : A`。教材（Bühler–Salamon）的全纯函数演算（Dunford 演算）要把
一个在谱 `spectrum ℂ a` 的邻域上全纯的函数 `f`，沿一条围绕谱的有限 cycle 积分

`z ↦ f z • (z·1 - a)⁻¹`，

从而把标量函数 `f` 提升为代数元素 `f(a)`。这条路线依赖两个尚未就绪的部件：一是预解算子
`(z·1-a)⁻¹` 的代数恒等式与解析性质，二是复分析学科持有的公共 Banach 值路径积分/cycle carrier。

本条只发展第一个部件。在**尚未定义任何 cycle、绕数或路径积分**的阶段，就已经可以证明：预解
映射在预解集上全纯，被积函数在共同有效开集上复可微且连续，并且它在紧集上 Bochner 可积。
这些是后续真正沿紧路径积分所必需的解析前提；它们本身不是积分，也不给出 `f(a)`。

# 定义：预解集、预解映射与 Dunford 被积函数

沿用本库 `functional-analysis.spectrum.definition` 已冻结的 Mathlib 承载：

- `resolventSet ℂ a = {z | IsUnit (algebraMap ℂ A z - a)}`，即教材中 `z·1 - a` 可逆的全体复数；
- `spectrum ℂ a = (resolventSet ℂ a)ᶜ`；
- `resolvent a z = (algebraMap ℂ A z - a)⁻¹ʳ = Ring.inverse (algebraMap ℂ A z - a)`。

这里 `algebraMap ℂ A z` 正是教材中的标量 `z` 作用在单位元上的结果 `z·1`。`Ring.inverse` 是环上
**总函数**形式的逆：在可逆元处取真正的双边逆，在其余处约定为零。因此凡是用到真正逆元的公式都
必须显式携带 `z ∈ resolventSet ℂ a`；而在谱点上 `resolvent a z = 0`。

**第一预解恒等式**（本节新证）。对 `z, w ∈ resolventSet ℂ a`，预解元之差的乘积公式为

`resolvent a z - resolvent a w = (w - z) • (resolvent a z * resolvent a w)`。

**Dunford 被积函数**。本模块把教材被积函数组装为一个 `def`：

```lean
noncomputable def resolventIntegrand (a : A) (f : ℂ → ℂ) : ℂ → A :=
  f • resolvent a
```

即逐点 `z ↦ f z • resolvent a z`（标量函数对代数值函数的逐点 `smul`）。它只组装标量函数与
预解映射，本身不含 cycle、路径或积分。

# 已证定理（Lean 精确名称）

预解恒等式与乘法次序（只需 `[NormedRing A] [NormedAlgebra ℂ A]`）：

- `resolvent_sub_resolvent_same`：`resolvent a z - resolvent a w =
  (w - z) • (resolvent a z * resolvent a w)`，前提 `hz : z ∈ resolventSet ℂ a`、
  `hw : w ∈ resolventSet ℂ a`；
- `resolvent_mul_comm`：`resolvent a z * resolvent a w = resolvent a w * resolvent a z`，
  **不带**预解集假设；
- `resolvent_sub_resolvent_same_mul_comm`：同一第一预解恒等式，但乘积写成
  `(w - z) • (resolvent a w * resolvent a z)`。

预解映射的解析性（此后需 `[CompleteSpace A]`）：

- `differentiableOn_resolvent`：`DifferentiableOn ℂ (resolvent a) (resolventSet ℂ a)`；
- `differentiableAt_resolvent`：若 `z ∈ resolventSet ℂ a`，则 `DifferentiableAt ℂ (resolvent a) z`；
- `analyticOnNhd_resolvent`：`AnalyticOnNhd ℂ (resolvent a) (resolventSet ℂ a)`；
- `continuousOn_resolvent`：`ContinuousOn (resolvent a) (resolventSet ℂ a)`。

Dunford 被积函数，在共同有效开集 `U ∩ resolventSet ℂ a` 上：

- `differentiableOn_resolventIntegrand`：若 `DifferentiableOn ℂ f U`，则
  `DifferentiableOn ℂ (resolventIntegrand a f) (U ∩ resolventSet ℂ a)`；
- `continuousOn_resolventIntegrand`：同上假设下的 `ContinuousOn`；
- `HolomorphicOnNhdSpectrum.resolventIntegrand_differentiableOn`：从本库谓词
  `HolomorphicOnNhdSpectrum a f` 出发，返回见证开邻域 `U`（满足 `IsOpen U`、
  `spectrum ℂ a ⊆ U`、`DifferentiableOn ℂ f U`）以及被积函数在 `U ∩ resolventSet ℂ a` 上的可微性；
- `HolomorphicOnNhdSpectrum.resolventIntegrand_continuousOn`：同样从
  `HolomorphicOnNhdSpectrum a f` 出发给出连续性。

紧集上的 Bochner 可积性：

- `integrableOn_resolventIntegrand_compact`：若 `K` 紧、`K ⊆ U`、`K ⊆ resolventSet ℂ a` 且
  `DifferentiableOn ℂ f U`，则 `IntegrableOn (resolventIntegrand a f) K volume`。

# 与教材预解算子 R(z, a) 的对应

教材的 `R(z, a) = (z·1 - a)⁻¹` 与本库使用的 Mathlib 载体逐项对应如下。

| 教材概念 | 教材语义 | Lean 正式承载 | 展开／刻画 | Mathlib 角色 |
|---|---|---|---|---|
| 预解集 | `{z : z·1-a 可逆}` | Mathlib `resolventSet ℂ a` | `mem_resolventSet_iff_isUnit` | 语义一致的正式承载 |
| 预解算子 `R(z,a)` | `(z·1-a)⁻¹` | Mathlib `resolvent a` | `resolvent_eq_ringInverse`；预解集上满足双边逆 | 语义一致的正式承载 |
| 谱 `σ(a)` | 预解集补集 | Mathlib `spectrum ℂ a` | `spectrum_eq_compl_resolventSet` | 语义一致的正式承载 |
| 总函数逆 | 不可逆处取零 | Mathlib `Ring.inverse` | `resolvent a z = (z·1-a)⁻¹ʳ` | 语义一致的正式承载（总函数约定） |
| 第一预解恒等式 | `R(z)-R(w)=(w-z)R(z)R(w)` | 本模块 `resolvent_sub_resolvent_same` | 直接恒等式 | 本库补充定理 |
| 预解映射全纯 | `R` 在预解集上复可微 | Mathlib `DifferentiableOn` / `AnalyticOnNhd` | `spectrum.hasDerivAt_resolvent_const_left` 给出导数值 | Mathlib 私有分析后端，本模块只需组装 |
| Dunford 被积函数 | `z ↦ f(z)•R(z,a)` | 本库 `resolventIntegrand a f` | `f • resolvent a` | 本库 `def`，无整体对应的 Mathlib 对象 |
| 紧集上可积 | Bochner 可积 | Mathlib `IntegrableOn` | `ContinuousOn.integrableOn_compact` | Mathlib 积分接口复用 |

导数的具体形式来自 Mathlib 已证的
`spectrum.hasDerivAt_resolvent_const_left`：在预解集上

`HasDerivAt (resolvent a) (-resolvent a k ^ 2) k`，

与教材 `R'(z) = -R(z)²` 一致。需要注意 Mathlib 已有的是
`spectrum.resolvent_sub_resolvent`，它是**第二预解恒等式**（两个不同元素、同一个谱参数）；
本模块补上的是**第一预解恒等式**（同一个元素、两个谱参数）以及预解元的乘法交换性。

`resolvent_mul_comm` 的交换性覆盖**全部** `z, w : ℂ`，不只预解集上的点：因为 `Ring.inverse` 把
不可逆元的逆约定为零，而 `z·1 - a` 与 `w·1 - a` 恒交换，故乘积次序可交换这一点无条件成立。

# 证明思路（教材语言）

- **第一预解恒等式。** 对可逆元 `a' = z·1-a`、`b' = w·1-a` 使用 Mathlib 的
  `Ring.inverse_sub_inverse`，得到
  `a'⁻¹ - b'⁻¹ = a'⁻¹ * (b' - a') * b'⁻¹`。这里 `b' - a' = (w·1-a) - (z·1-a) = (w-z)·1`，
  于是标量因子 `(w-z)` 提出来，即得 `(w-z) • (resolvent a z * resolvent a w)`。
- **乘法交换。** `algebraMap ℂ A z`、`algebraMap ℂ A w` 都与 `a` 中心交换
  （`Algebra.commute_algebraMap_left`），因此 `z·1-a` 与 `w·1-a` 交换；由
  `Commute.ringInverse_ringInverse` 得预解元的逆也交换。不可逆时 `Ring.inverse = 0`，仍交换。
- **可微与全纯。** 预解映射的导数由 Mathlib 的 `spectrum.hasDerivAt_resolvent_const_left` 直接
  给出；`DifferentiableAt.differentiableWithinAt` 升为 `DifferentiableOn`，再借预解集的开性
  `spectrum.isOpen_resolventSet` 与 `DifferentiableOn.analyticOnNhd` 得到解析性，最后
  `DifferentiableOn.continuousOn` 得到连续性。
- **被积函数。** 标量侧 `f` 限制到 `U` 的可微性与预解映射限制到 `resolventSet ℂ a` 的可微性，
  通过积法则 `DifferentiableOn.smul` 组合成 `U ∩ resolventSet ℂ a` 上的可微性；连续性随之由
  `DifferentiableOn.continuousOn` 得到。
- **紧集可积。** 在上述共同紧集 `K` 上被积函数连续，紧集上的连续函数可积由
  `ContinuousOn.integrableOn_compact` 给出，即 `IntegrableOn`。这里复平面上的积分仍是 Mathlib
  现有的 Bochner 积分，本模块没有另建一套 Banach 值积分结构。

# Lean 对照

- `resolvent_sub_resolvent_same`、`resolvent_sub_resolvent_same_mul_comm`：第一预解恒等式及其
  交换次序形式；
- `resolvent_mul_comm`：两个谱参数处预解元的乘法交换（无条件）；
- `differentiableOn_resolvent`、`differentiableAt_resolvent`、`analyticOnNhd_resolvent`、
  `continuousOn_resolvent`：预解映射在预解集上的可微、逐点可微、解析与连续；
- `resolventIntegrand`：Dunford 被积函数的定义 `f • resolvent a`；
- `differentiableOn_resolventIntegrand`、`continuousOn_resolventIntegrand`：共同有效开集上的
  可微性与连续性；
- `HolomorphicOnNhdSpectrum.resolventIntegrand_differentiableOn`、
  `HolomorphicOnNhdSpectrum.resolventIntegrand_continuousOn`：从谱邻域全纯谓词出发的存在型结论；
- `integrableOn_resolventIntegrand_compact`：紧集上的 Bochner 可积性。

# 依赖

前提（只列库内 Entry）：

- `functional-analysis.functional-calculus.holomorphic-neighborhood`：提供
  `HolomorphicOnNhdSpectrum a f` 及其量词结构，本模块的命名空间定理真实消费它；
- `functional-analysis.spectrum.definition`：提供 `spectrum`、`resolventSet`、`resolvent` 的
  定义与基本展开桥。

使用的 Mathlib 名称（本节已逐项说明角色）：`resolvent`、`resolventSet`、`spectrum`、
`Ring.inverse`、`Ring.inverse_sub_inverse`、`Commute.ringInverse_ringInverse`、
`Algebra.commute_algebraMap_left`、`spectrum.hasDerivAt_resolvent_const_left`、
`spectrum.isOpen_resolventSet`、`DifferentiableOn.smul`、`DifferentiableOn.analyticOnNhd`、
`ContinuousOn.integrableOn_compact`、`IntegrableOn`。其中 `resolvent`、`resolventSet`、
`spectrum`、`Ring.inverse` 是语义一致的正式承载；`spectrum.hasDerivAt_resolvent_const_left`
等是复用的分析后端；本库新增的公开对象只有 `resolventIntegrand` 定义与本节列出的定理。

# 诚实边界

本模块**没有**定义有限 cycle、绕数、cycle/路径积分，也**没有**定义 Dunford 值 `f(a)`、选择
无关性、代数同态、谱映射、复合、谱投影或连续函数演算；它也没有另建第二套 Banach 值积分结构。
被积函数只是被证明在紧集上可积，积分本身尚未组装。

公共的 Banach 值路径积分/cycle carrier 仍归复分析学科所有；沿 carrier 组装积分的窗口是后续
F6.6b2。`HolomorphicOnNhdSpectrum` 在本模块被真实复用：两个命名空间定理直接消费它以取得见证
开邻域，并非所有结论都需要调用者事先固定同一个定义域。

本条目是随新模块提交的课程文档**初稿**，供 Main 审阅；它尚未登记进 `index/registry.json`，
`state` 记为 `staging`，不代表已经集成进 Main 教材或全局构建。精确八段重排、front matter
统一和 Registry 登记由 Main 完成。
