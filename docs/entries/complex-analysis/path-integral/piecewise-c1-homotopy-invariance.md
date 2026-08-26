---
id: complex-analysis.path-integral.piecewise-c1-homotopy-invariance
family: complex-analysis.path-integral
variant: continuous-endpoint-relative-homotopy-piecewise-c1-boundary
kind: theorem
state: verified
title: 分段 C1 边界的连续相对同伦积分不变性
summary: 对开集内全像受控的连续端点相对道路同伦，证明全纯函数沿两条分段 C1 边界道路的积分相等，并推出零同伦闭路积分为零
premises: [complex-analysis.path-integral.finite-raw-grid-boundary, topology.homotopy.piecewise-c1-dyadic-alignment, topology.homotopy.indexed-open-cover-square-subdivision]
mathlib: [Path.Homotopy, Path, IsOpen, DifferentiableOn, Complex.IsExactOn, Metric.ball]
provenance:
  source_type: book
  ref: "ahlfors-complex-analysis-1979"
---

# 动机

复积分的基本同伦不变性不应要求整个二维同伦方形可微：教材证明只把连续方形细分到足够小，使每格
落在拥有局部 primitive 的开集，再沿格边积分。真正需要正则性的只是最终被积分的有限条一维道路。
本条目用分段 C1 边界与连续端点相对同伦给出这一接口，避免不成立的全局 relative-`C²` 方形假设。

# 教材陈述

设 `U ⊆ ℂ` 开，`f` 在 `U` 上全纯。若 `gamma`、`delta` 是从 `a` 到 `b` 的分段 C1 道路，存在一个
保持两个端点的连续道路同伦从 `gamma` 到 `delta`，并且整个同伦像包含于 `U`，则
`∫_gamma f(z) dz = ∫_delta f(z) dz`。特别地，若分段 C1 闭路在 `U` 中零同伦，则其积分为零。

# Lean 定理与边界

```lean
theorem pathIntegral_eq_of_piecewiseC1_homotopyWithin
    (hU : IsOpen U) (hf : HolomorphicOnTextbook f U)
    (hgamma : Path.PiecewiseC1 gamma) (hdelta : Path.PiecewiseC1 delta)
    (F : gamma.Homotopy delta)
    (hF : ∀ z, pathHomotopySquare F z ∈ U) :
    pathIntegral f gamma = pathIntegral f delta

theorem pathIntegral_eq_zero_of_piecewiseC1_nullHomotopyWithin ... :
    pathIntegral f gamma = 0
```

同伦只要求 Mathlib `Path.Homotopy` 的连续性和端点相对条件；没有二维 C1/C2 假设。两条边界道路仍
必须是本库 `Path.PiecewiseC1`。结论不覆盖任意 rectifiable curve，也不移除同伦全像位于 `U` 的前提。

# 自然语言 ↔ Lean 映射

“端点相对连续同伦”由 Mathlib `Path.Homotopy` 承载，并由 `pathHomotopySquare` 暴露参数方形；“全像
位于 U”是显式逐点量词 `hF`；“分段 C1 边界”对应 `Path.PiecewiseC1`；“全纯”使用课程入口
`HolomorphicOnTextbook`，证明中经既有桥得到 `DifferentiableOn`；“积分相等”使用既有 `pathIntegral`。
零同伦推论的目标道路是 `Path.refl a`。

# 证明思路

先从两条 PiecewiseC1 证明各取 dyadic 深度并共同加细。对同伦像中每点，在 `U` 内选一个开球；indexed
Lebesgue-number subdivision 取不低于共同深度的 `2^n` 方格，使每格落在一个球。共享方格数据与四条
外边 PiecewiseC1 桥组装成 `FiniteRawOpenPathGrid ℂ`。

全纯性给出 `DifferentiableOn`；限制到每个所选球后，Mathlib 的局部 primitive 定理给出逐格
`Complex.IsExactOn`。E 的网格定理消去内部边并得到外边界积分和为零；上下边是端点常值道路，左右边
严格识别为 `gamma`、`delta` 的 dyadic 小段。C 的有限和组装最终恢复整道路积分相等。零同伦结论把
`delta` 取常道路并化简其积分。

# 正式承载与定义链

`Path.Homotopy`、`Path`、`IsOpen`、`DifferentiableOn`、`Metric.ball` 与 `Complex.IsExactOn` 均为 Mathlib
中语义一致的正式承载；课程文档分别解释其端点相对、开集微分和局部 primitive 含义。本库新增的
PiecewiseC1、dyadic alignment、indexed subdivision、raw grid 和积分 assembly 是已独立验收的必要
桥层，最终定理真实消费全部 A/B/C/D/E 接口。没有新 carrier、instance 或 notation。

# 应用与陷阱

零同伦推论可直接用于可缩闭路的积分消失；配合道路拼接可继续建立端点无关等结论。不能把“同伦
连续”误读为“同伦的每条内部横／竖切片自动分段 C1”：证明恰恰通过开集内一维 replacement 绕开此
错误。定理也不声明整个 `U` 上存在全局 primitive；逐格 local primitives 只在有限和中使用。

# 来源与诚实边界

Ahlfors 提供复积分同伦不变性与局部 Cauchy 理论的解析路线；Hatcher 第一章提供端点相对道路同伦的
拓扑对象层。Lean 证明采用 dyadic grid、indexed balls 和 explicit finite telescope 来实现教材中的
“充分细分并消去内部边”。它不替代既有更强假设的 C2 同伦定理，也不声称两条实现路径定义相同；
本条目的新增价值正是连续同伦加分段 C1 边界这一更合教材的接口。
