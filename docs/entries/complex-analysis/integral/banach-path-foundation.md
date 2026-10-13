---
id: complex-analysis.integral.banach-path-foundation
family: complex-analysis.integral
variant: banach-valued
kind: definition
state: verified
title: Banach 值路径积分的基础载体
summary: 在 Mathlib 泛型 curveIntegral 之上给出 Banach 值被积函数的路径积分载体，并证明 F=ℂ 时定义性地回到既有标量 pathIntegral
premises: [complex-analysis.integral.path]
mathlib: [curveIntegral, CurveIntegrable, ContinuousLinearMap.smulRight, curveIntegral_add, curveIntegral_smul, curveIntegral_trans, curveIntegral_symm, curveIntegral_cast]
provenance:
  source_type: book
  ref: "ahlfors-complex-analysis-1979"
---

# 动机

教材里的路径积分 `∫_γ f(z) dz` 通常先对复值被积函数写出，但 Cauchy 理论的后续层——尤其
是 Dunford 函数演算中的预解被积函数 `z ↦ f(z) • (a - z)⁻¹`——需要沿道路积分**取值在 Banach
空间**的函数。Mathlib 的 `curveIntegral` 本来就对余域泛型，本库的 `PathIntegral` 却只把标量
情形暴露成 `scalarOneForm`／`pathIntegral`。本条把这个泛型情形包装成一个诚实的公共载体，使
后续 cycle／绕数层与 D2 不必各自重造一套路径积分接口。

# 直觉

复值一形式 `f(z) dz` 在切向量 `v` 上取值 `v * f(z)`。对 Banach 空间 `F` 值函数，唯一自然的
推广是把标量乘法换成作用：`v ↦ v • f(z)`。沿道路积分仍用 Mathlib 的曲线积分。当 `F = ℂ` 时
它逐字就是原来的标量一形式，所以两者不是"两套接口"，而是同一接口的不同特化。

# 陈述（自然语言）

设 `F` 是复 Banach 空间（只需 `[NormedAddCommGroup F] [NormedSpace ℂ F]`），`f : ℂ → F`。
定义一形式 `banachOneForm f z = (v ↦ v • f z)`、可积性谓词 `BanachPathIntegrable f γ`，以及
路径积分 `banachPathIntegral f γ := ∫ᶜ z in γ, banachOneForm f z`。则：

- `F = ℂ` 时 `banachPathIntegral f γ = pathIntegral f γ`（定义性相等，不需要额外证明）；
- 对可积的被积函数，积分在 `f + g`、`c • f`、`-f` 上分别等于积分之和、倍积、相反数；
- 常道路积分为零，反向变号，同端点拼接相加，端点 cast 不变。

# 陈述（Lean 对照）

```lean
def banachOneForm (f : ℂ → F) : ℂ → ℂ →L[ℂ] F :=
  fun z => ContinuousLinearMap.smulRight (1 : ℂ →L[ℂ] ℂ) (f z)

def BanachPathIntegrable (f : ℂ → F) (γ : Path a b) : Prop :=
  CurveIntegrable (banachOneForm f) γ

def banachPathIntegral (f : ℂ → F) (γ : Path a b) : F :=
  ∫ᶜ z in γ, banachOneForm f z

@[simp] theorem banachPathIntegral_complex_eq_pathIntegral (f : ℂ → ℂ) (γ : Path a b) :
    banachPathIntegral (F := ℂ) f γ = pathIntegral f γ

theorem banachPathIntegral_add (hf : BanachPathIntegrable f γ) (hg : BanachPathIntegrable g γ) :
    banachPathIntegral (fun z => f z + g z) γ = banachPathIntegral f γ + banachPathIntegral g γ
theorem banachPathIntegral_smul (c : ℂ) : banachPathIntegral (fun z => c • f z) γ = c • banachPathIntegral f γ
theorem banachPathIntegral_trans (hγ hδ) : banachPathIntegral f (γ.trans δ) = banachPathIntegral f γ + banachPathIntegral f δ
theorem banachPathIntegral_symm : banachPathIntegral f γ.symm = -banachPathIntegral f γ
theorem banachPathIntegral_cast : banachPathIntegral f (γ.cast hc hd) = banachPathIntegral f γ
```

# 思维脉络（thinking trace）

关键是**不要**重造积分结构。Mathlib 的 `curveIntegral (ω : E → E →L[𝕜] F)` 已经对余域 `F` 泛型，
所需的线性、拼接、反向、const path 引理全部现成。因此本条的 `banachOneForm` 直接写成
`smulRight (1) (f z)`，与既有 `scalarOneForm` 的定义在同一构造子上，`F = ℂ` 时两者
definitionally equal，对照定理 `rfl` 即可。其余引理都只是把 `banachPathIntegral` 的定义展开成
`curveIntegral`，再调用 Mathlib 对应引理；被积函数的线性通过 `banachOneForm` 的逐点相等
`funext z; ext; simp [smul_add]` 归约到一形式的线性，再落到 `curveIntegral_add`。

类型类层级刻意保持最小：`banachPathIntegral` 只要求 `[NormedAddCommGroup F] [NormedSpace ℂ F]`，
不需要 `CompleteSpace F`——Bochner 曲线积分在紧区间上自有其可积性理论。`windingNumber` 的复值层
自动满足所需假设。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 作用一形式 `v ↦ v • f(z)` | `banachOneForm f z` |
| 沿道路可积 | `BanachPathIntegrable f γ`（桥到 `CurveIntegrable`） |
| Banach 值路径积分 `∫_γ f dz` | `banachPathIntegral f γ` |
| 标量特化回到既有积分 | `banachPathIntegral_complex_eq_pathIntegral` |
| 被积函数线性 | `banachPathIntegral_add / _smul / _neg` |
| 拼接、反向、端点转换 | `banachPathIntegral_trans / _symm / _cast` |

# 依赖（人话版）

本条只依赖 `complex-analysis.integral.path` 提供的既有标量 `pathIntegral`／`scalarOneForm`，
以及 Mathlib 的 `curveIntegral` 及其线性／拼接／反向／cast 引理。`pathIntegral`、
`PathIntegrable`、`scalarOneForm` 的签名一字未改，本条对它们是纯增量。

# 应用与陷阱

本条是**新增泛化**，不是对旧 API 的迁移：`pathIntegral` 保留，`banachPathIntegral` 通过
`F = ℂ` 对照桥与之相接，属 AGENTS §10 的 M1 级；将来若要做 M2 迁移，须先出 RFC 与影响图。
`F = ℂ` 桥是 `rfl`，这依赖 `banachOneForm` 与 `scalarOneForm` 的定义形状，改动其中任一方的
定义会破坏该桥。不要把本条读作"向量值绕数"或"复 Banach 代数演算"——它只提供路径积分载体，
不涉及 cycle、绕数、`f(a)`、谱映射或任何函数演算。
