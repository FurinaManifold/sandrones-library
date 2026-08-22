---
id: real-analysis.riemann.ftc
kind: theorem
state: verified
title: "自建 Riemann 积分的微积分基本定理"
premises: ["real-analysis.riemann.eq-lebesgue", "real-analysis.calculus.ftc", "real-analysis.calculus.ftc-differentiate"]
mathlib: ["intervalIntegral.integral_of_le", "eventually_gt_nhds", "HasDerivAt.congr_of_eventuallyEq"]
provenance:
  source_type: book
  ref: "数学分析 II：微积分基本定理与 Newton–Leibniz 公式"
---

# 内容

本条目把已经建立在 Mathlib 区间积分上的两种微积分基本定理，转写成本库自建
Darboux–Riemann 积分的教材陈述。

第二形式是 Newton–Leibniz 公式：若 `a<b`，`f` 在 `[a,b]` 上连续，并且
`F'(x)=f(x)`，则

\[
  \operatorname{riemannIntegral}(f,a,b)=F(b)-F(a).
\]

第一形式固定下端点 `a`：若 `f` 在实线上连续，则对每个 `x>a`，

\[
  \frac{d}{dx}\operatorname{riemannIntegral}(f,a,x)=f(x).
\]

# 证明思路

Newton–Leibniz 公式是纯粹的数值适配。先用连续函数的积分值桥把
`riemannIntegral f a b` 改写成 `Ioc a b` 上的 Lebesgue 积分，再用
`intervalIntegral.integral_of_le` 识别为有向区间积分，最后调用
`RealAnalysis.Calculus.ftc_2`。

变上限公式还需要处理一个局部接口问题。本库的积分值桥只对严格次序 `a<u` 陈述，
而导数考察 `x` 的整个邻域。由 `a<x` 可知 `u>a` 在 `x` 的某个邻域内最终成立；
因此在该邻域内，函数

`u ↦ riemannIntegral f a u`

与 Mathlib 的变上限区间积分函数

`u ↦ ∫ t in a..u, f t`

相等。`RealAnalysis.Calculus.ftc_1_right` 给出后者的导数，再通过
`HasDerivAt.congr_of_eventuallyEq` 的导数局部性把结论转移到前者。

# Lean 对照

- `riemannIntegral_eq_sub_of_hasDerivAt`：Newton–Leibniz 公式；
- `hasDerivAt_riemannIntegral_right`：变上限 Riemann 积分的导数。

这里没有重新证明 Mathlib 的 FTC；本文件的职责仅是把已验证的区间积分定理与自建
Riemann 积分定义对齐。

# 边界

- Newton–Leibniz 版本要求 `a<b`，与本库严格递增 Darboux 分划的定义一致。
- 第一形式当前采用全局连续性，以保持教材接口简洁；数学上可进一步弱化为目标点附近
  连续，并且在相关闭区间上连续。
- 这里只处理正向区间。反向有向积分应在后续统一扩展自建 Riemann 积分的端点约定。

# 公理依赖

由注册审计脚本从两个带 Entry 标记的定理读取并合并。
