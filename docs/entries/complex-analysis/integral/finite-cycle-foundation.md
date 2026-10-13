---
id: complex-analysis.integral.finite-cycle-foundation
family: complex-analysis.integral
variant: finite-formal-sum
kind: definition
state: verified
title: 有限 cycle 载体与 ℤ-线性 cycle 积分
summary: 以闭路的有限整数系数形式和张成 cycle 载体，定义 trace 等谓词与对 cycle 逐片积分的 ℤ-线性 cycle 积分，并给出求导积分归零的首个上层消费者
premises: [complex-analysis.integral.banach-path-foundation, complex-analysis.path-integral.dyadic-assembly, complex-analysis.cauchy.primitive-from-path-independence-foundation, topology.homotopy.piecewise-c1-path]
mathlib: [Finsupp, Finsupp.linearCombination, Finsupp.linearCombination_single, Finsupp.mem_support_iff, Finsupp.sum_of_support_subset, Finset.sum_add_distrib]
provenance:
  source_type: book
  ref: "ahlfors-complex-analysis-1979"
---

# 动机

Cauchy 定理、辐角原理与残数定理的教材陈述都建立在"闭曲线（cycle）"之上：一条曲线在区域内的
积分不变性只能对闭路讲，而一般拓扑论证中的"一个 cycle 与另一个同调"是闭路的**有限整数系数
线性组合**。因此需要先把"有限条闭路的 ℤ 线性组合"这个教材对象建成 Lean 载体，并让"沿 cycle
积分"内建为其上的 ℤ-线性映射，后续绕数、同调谓词与残数定理才有一个稳定的公共接口。

# 直觉

闭路就是首尾相接的道路；把基点也打包进数据，得到 `ClosedPath`。有限个 ℤ 系数组合正是一个
以闭路为下标、支撑有限的整值函数，即 `ClosedPath →₀ ℤ`。沿 cycle 积分 = 对每个出现的闭路取
其（Banach 值）路径积分，再按整数系数加权求和；这恰好是 `Finsupp.linearCombination ℤ`，于是
"积分对 cycle 线性"不是一条需要另证的定理，而是定义的直接推论。

# 陈述（自然语言）

- **闭路** `ClosedPath := Σ a : ℂ, Path a a`：基点 `c.1` 与一条 `c.2 : Path c.1 c.1` 一起存储。
- **cycle** `Cycle := ClosedPath →₀ ℤ`：闭路的有限 ℤ 系数形式和张。
- **逐片谓词**：`Cycle.trace`（所有闭路像的并）、`Cycle.PiecewiseC1`（每片分段 C¹）、
  `Cycle.SupportedIn γ U`（每片的像含于 `U`）、`Cycle.Integrable f γ`（每片可积）。
- **cycle 积分** `cycleIntegral f : Cycle →ₗ[ℤ] F`，取值 `γ.sum (fun c n => n • banachPathIntegral f c.2)`。
- 由构造即得 `cycleIntegral_add/_smul/_neg/_sub`；单点 `cycleIntegral_single` 与
  `cycleIntegral_apply` 给出展开；`cycleIntegral_add_integrand` 在逐片可积下给出对被积函数的线性。
- 谓词对加法封闭：`Cycle.PiecewiseC1.add`、`Cycle.SupportedIn.add`、`Cycle.Integrable.add`。
- **首个上层消费者**：若每条闭路的路径积分都为零，则 `cycleIntegral f γ = 0`；由此，若 `γ` 分段
  C¹、`γ.SupportedIn U`，且 `f` 在 `U` 上有原函数 `g`（`∀ z ∈ U, HasDerivAt g (f z) z`）并在 `U`
  上连续，则 `cycleIntegral f γ = 0`——这正是"导数沿闭 cycle 的积分为零"。

# 陈述（Lean 对照）

```lean
abbrev ClosedPath : Type := Σ a : ℂ, Path a a
abbrev Cycle : Type := ClosedPath →₀ ℤ

def Cycle.trace (γ : Cycle) : Set ℂ := {w | ∃ c ∈ γ.support, w ∈ Set.range c.2}
def Cycle.PiecewiseC1 (γ : Cycle) : Prop := ∀ c ∈ γ.support, Path.PiecewiseC1 c.2
def Cycle.SupportedIn (γ : Cycle) (U : Set ℂ) : Prop := ∀ c ∈ γ.support, Set.range c.2 ⊆ U
def Cycle.Integrable (f : ℂ → F) (γ : Cycle) : Prop := ∀ c ∈ γ.support, BanachPathIntegrable f c.2

noncomputable def cycleIntegral (f : ℂ → F) : Cycle →ₗ[ℤ] F :=
  Finsupp.linearCombination ℤ (fun c : ClosedPath => banachPathIntegral f c.2)

theorem cycleIntegral_eq_zero_of_forall_piece_eq_zero
    (h : ∀ c ∈ γ.support, banachPathIntegral f c.2 = 0) : cycleIntegral f γ = 0
theorem cycleIntegral_eq_zero_of_primitive (hC1 : γ.PiecewiseC1) (hUγ : γ.SupportedIn U)
    (hg : ∀ z ∈ U, HasDerivAt g (f z) z) (hf : ContinuousOn f U) : cycleIntegral f γ = 0
```

# 思维脉络（thinking trace）

表示选 `ClosedPath →₀ ℤ` 由本版 Mathlib 的一个决定因素拍板：`Finsupp.support` 是**结构字段**，
访问 `γ.support`、`c ∈ γ.support`、`Finsupp.single` 都**不需要** `DecidableEq ClosedPath`；而
`Path a a` 没有 `DecidableEq`，若改用需要可判定相等的表示就会卡死。选 `Finsupp.linearCombination`
则让 cycle 积分的 ℤ-线性由线性映射 API 免费得到，无需逐条重证。

"谓词对加法封闭"不能靠 `Finsupp.support_add`（那需要 `DecidableEq`），而是先证
`mem_support_or : c ∈ (γ+δ).support → c ∈ γ.support ∨ c ∈ δ.support`，再逐片落回各加项。同理，
把 `γ.sum` 写成只遍历支撑的和用 `Finsupp.sum_of_support_subset`，这样
`cycleIntegral_add_integrand` 才能把三个和放到同一支撑上再用 `Finset.sum_add_distrib`。

求导归零消费者是刻意保留的**真实使用者**：它串起 `Cycle.PiecewiseC1`／`SupportedIn`、
`admissiblePath_of_piecewiseC1` 与 `pathIntegral_eq_sub_of_primitive_of_admissiblePath`，证明载体
不是装饰别名，而是原函数路线的实际入口。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 闭路（含基点） | `ClosedPath`，`.1` 是基点、`.2 : Path c.1 c.1` |
| 有限整数系数闭路和 | `Cycle := ClosedPath →₀ ℤ` |
| cycle 的轨迹 | `Cycle.trace`，展开 `Cycle.mem_trace` |
| 每片在 `U` 内 | `Cycle.SupportedIn` |
| 每片分段 C¹ | `Cycle.PiecewiseC1` |
| 每片可积 | `Cycle.Integrable` |
| 沿 cycle 积分、ℤ-线性 | `cycleIntegral`、`cycleIntegral_add/_smul/_neg/_sub` |
| 求导沿闭 cycle 积分为零 | `cycleIntegral_eq_zero_of_primitive` |

# 依赖（人话版）

载体与积分建立在 `complex-analysis.integral.banach-path-foundation` 的 Banach 值路径积分之上；
分段 C¹ 谓词来自本库 verified 的 `topology.homotopy.piecewise-c1-path`；求导归零消费者调用
`complex-analysis.path-integral.dyadic-assembly` 的 `admissiblePath_of_piecewiseC1`（把分段 C¹ 道路
升级为 admissible）与 `complex-analysis.cauchy.primitive-from-path-independence-foundation` 的端点
公式。"每片在 `U` 内"与"每片可积"只是 `Set.range ⊆ U` 与 `CurveIntegrable` 的逐片合取，没有引入
新的高阶结构。

# 应用与陷阱

`Cycle.trace` 只取像的并、**不排除端点**；两条 cycle 相加时 `trace (γ+δ) ⊆ trace γ ∪ trace δ`，
但**反向包含不成立**——对消会缩小支撑（`single c 1 + single c (-1) = 0`）。因此一切"支撑"性质都
必须用 `c ∈ γ.support` 表述，而不能用 `trace` 代替；这也是 `mem_support_or` 存在的原因。
`cycleIntegral_add_integrand` 只对被积函数的加法给线性，且需要逐片可积假设；不要把
`cycleIntegral` 误读成"对 `f` 也自动 ℂ-线性"的映射。最后一个消费者需要 `γ.PiecewiseC1` 与
`γ.SupportedIn U` 同时成立，并额外要求 `f` 在 `U` 连续；它**不**声称任意闭 cycle 的积分只由
端点决定，也未触及同调不变性——那是绕数／同调层（`complex-analysis.integral.winding-number-foundation`）
的事。
