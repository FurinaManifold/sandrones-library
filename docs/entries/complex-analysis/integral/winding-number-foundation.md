---
id: complex-analysis.integral.winding-number-foundation
family: complex-analysis.integral
variant: index-and-homology
kind: definition
state: verified
title: cycle 的绕数与相对同调基础谓词
summary: 用 (2πi)⁻¹∮ dz/(z-w) 定义 cycle 的复值绕数、给出其 ℤ-线性与相对同调谓词，并由分段 C¹ 零同伦消费者证明首个非平凡同调实例
premises: [complex-analysis.integral.finite-cycle-foundation, complex-analysis.integral.path, complex-analysis.holomorphic.definition, complex-analysis.path-integral.piecewise-c1-homotopy-invariance]
mathlib: [Finsupp.single, Real.pi, Complex.I, HasDerivAt, differentiableAt_id, IsOpen]
provenance:
  source_type: book
  ref: "ahlfors-complex-analysis-1979"
---

# 动机

绕数（index）`n(γ, w)` 是 Cauchy 积分公式、辐角原理与残数定理的共同语言：它衡量一条闭路
围绕点 `w` 带符号地转了多少圈。教材用它把"积分与路径无关"讲成"绕数不变"，并在域 `U` 外
给出"绕数为零"的量词，从而陈述同调形式的 Cauchy 定理。本条把绕数与两个"相对同调"谓词建成
公共接口，供后续残数定理与泛函分析的 cycle 消费者使用。

# 直觉

绕数的定义就是那个积分本身：`n(γ, w) = (2πi)⁻¹ ∮_γ dz/(z-w)`。由于 `cycleIntegral` 已对 cycle
是 ℤ-线性的，绕数也就自动对 cycle 线性。教材所谓"`γ` 在 `U` 内零同调"，指的是 `γ` 落在 `U`
内、且 `U` 外每一点的绕数都为零；两个 cycle 同调，指它们都在 `U` 内且在 `U` 外绕数处处相等。

# 陈述（自然语言）

- `windingNumber γ w := (2πi)⁻¹ * cycleIntegral (fun z => (z - w)⁻¹) γ`，值域是 **ℂ**。
- ℤ-线性：`windingNumber_add`、`windingNumber_smul`、`windingNumber_neg`、`windingNumber_zero`、
  `windingNumber_sub`；单片公式 `windingNumber_single`。
- `IsNullHomologousIn γ U := γ.SupportedIn U ∧ ∀ w, w ∉ U → windingNumber γ w = 0`；
  `IsHomologousIn γ₁ γ₂ U := γ₁.SupportedIn U ∧ γ₂.SupportedIn U ∧ ∀ w ∉ U, n(γ₁,w)=n(γ₂,w)`。
- 展开刻画 `isNullHomologousIn_iff`／`isHomologousIn_iff_windingNumber_eq`；零 cycle 零同调
  `isNullHomologousIn_zero`；零同调**无条件**对加法封闭 `isNullHomologousIn_add`。
- 上层消费者：一条 cycle 的每片若在 `U` 内零同伦（方形像留在 `U`），则其在 `U` 上的全纯被积函数
  的 cycle 积分为零、`U` 外绕数为零，因而 `γ` 在 `U` 内零同调。

# 陈述（Lean 对照）

```lean
noncomputable def windingNumber (γ : Cycle) (w : ℂ) : ℂ :=
  (2 * (Real.pi : ℂ) * Complex.I)⁻¹ * cycleIntegral (fun z : ℂ => (z - w)⁻¹) γ

def IsNullHomologousIn (γ : Cycle) (U : Set ℂ) : Prop :=
  γ.SupportedIn U ∧ ∀ w : ℂ, w ∉ U → windingNumber γ w = 0

def IsHomologousIn (γ₁ γ₂ : Cycle) (U : Set ℂ) : Prop :=
  γ₁.SupportedIn U ∧ γ₂.SupportedIn U ∧
    ∀ w : ℂ, w ∉ U → windingNumber γ₁ w = windingNumber γ₂ w

theorem isNullHomologousIn_add (hγ : IsNullHomologousIn γ U) (hδ : IsNullHomologousIn δ U) :
    IsNullHomologousIn (γ + δ) U
theorem windingNumber_eq_zero_of_piecewiseC1_nullHomotopic (hU : IsOpen U) (hw : w ∉ U)
    (hC1 : γ.PiecewiseC1) (hnull : ...) : windingNumber γ w = 0
theorem isNullHomologousIn_of_piecewiseC1_nullHomotopic (hU : IsOpen U) (hC1 : γ.PiecewiseC1)
    (hUγ : γ.SupportedIn U) (hnull : ...) : IsNullHomologousIn γ U
```

# 思维脉络（thinking trace）

**值域定为 ℂ，不是 ℤ。** 教材会说 `n(γ,w)` 是整数，但"整值性"是一条**尚未证明**的独立定理。
若把公开签名写成 `ℤ`，就比 Lean 的结论强，因此这里定义成复值，整值性单列为未证明的桥位。
这也让加法、`ℤ`-齐次、取反等引理直接从 `cycleIntegral` 的线性映射 API 得到。

**`SupportedIn` 合取项是定义的一部分。** `windingNumber` 是总函数：即使 `w` 落在 cycle 的轨迹上，
`(z - w)⁻¹` 在该点无定义，绕数取值只是 junk。若谓词只写 `∀ w ∉ U, n = 0`，当轨迹的一部分在 `U`
之外时就会对 junk 值作断言。把 `γ.SupportedIn U` 合取进定义，从来源上排除了这种声称。

**为什么不用"差零同调"形式。** 最初设想 `IsHomologousIn` 用 `IsNullHomologousIn (γ₁-γ₂) U`，
但差会**对消**支撑：`trace (γ+δ)` 一般**不包含** `trace γ ∪ trace δ`，于是差形式既在 `γ₁` 单独
轨迹处留下 junk，又使加法定理需要无法自然满足的支撑包含前提。反例：取闭路 `c`、点 `w ∈ range c`
和以 `w` 为圆心的小圆 `c'`，令 `γ := single c 1 + single c' 1`、`δ := single c (-1)`，则
`γ + δ = single c' 1`，`trace (γ+δ)` 不含 `w` 而 `n(γ+δ,w)=1≠0`。故 `IsHomologousIn` 冻结为**直接
形式**：两个 cycle 各自 `SupportedIn`，而不是差形式。该反例长期保留在本条与 handoff 中。

**消费者链。** `holomorphicOnTextbook_inv_sub` 说明在 `w ∉ U` 时 `(z-w)⁻¹` 在 `U` 上全纯；把它
与既有的 `pathIntegral_eq_zero_of_piecewiseC1_nullHomotopyWithin` 组合，得到零同伦下 cycle 积分
为零，从而绕数为零、`IsNullHomologousIn` 成立。这是 `IsNullHomologousIn` 的首个非平凡实例。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 绕数 `n(γ,w)` | `windingNumber γ w : ℂ` |
| 对 cycle ℤ-线性 | `windingNumber_add/_smul/_neg/_sub/_zero` |
| 单片闭路的绕数 | `windingNumber_single` |
| cycle 在 `U` 内零同调 | `IsNullHomologousIn γ U` |
| 两 cycle 在 `U` 内同调 | `IsHomologousIn γ₁ γ₂ U` |
| 域外绕数为零 | 定义中的 `∀ w, w ∉ U → windingNumber γ w = 0` |
| 零同伦 ⟹ 零同调 | `isNullHomologousIn_of_piecewiseC1_nullHomotopic` |

# 依赖（人话版）

绕数建立在 `complex-analysis.integral.finite-cycle-foundation` 的 `cycleIntegral` 与
`complex-analysis.integral.path` 的 `pathIntegral` 之上；`(z-w)⁻¹` 的全纯性用
`complex-analysis.holomorphic.definition` 的 `HolomorphicOnTextbook`（桥到 Mathlib `DifferentiableAt`）；
零同伦消费者复用 `complex-analysis.path-integral.piecewise-c1-homotopy-invariance` 的
`pathIntegral_eq_zero_of_piecewiseC1_nullHomotopyWithin`。Mathlib 侧只用到 `Real.pi`、`Complex.I`、
`IsOpen`、`differentiableAt_id.sub_const` 与 `HasDerivAt`。

# 应用与陷阱

**不得**把 `windingNumber γ w` 说成"整数绕数"或把整值性列为已完成前提——整值性 `n(γ,w) ∈ ℤ`
本批未证。**不得**宣称 `IsNullHomologousIn` 已与教材"同调"定义完全等价：本条只给了工作版本
（域外绕数为零 + 轨迹在域内），差形式与链层面的等价未证。定义累加时不能用 `trace` 代替
`SupportedIn`（见上反对消反例）。`windingNumber` 在轨迹上取值无教材意义，凡使用它都必须带上
`SupportedIn` 或 `w ∉ U` 这类前提。本条不涉及 Laurent 级数、一般残数定理、辐角原理、Rouché，
也不涉及 Dunford 值 `f(a)`、谱映射或连续函数演算。
