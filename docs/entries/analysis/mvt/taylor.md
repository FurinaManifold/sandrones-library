---
id: analysis.mvt.taylor
family: analysis.mvt
variant: rudin
kind: theorem
state: verified
title: 泰勒公式（Lagrange 余项）
summary: f 在 [a,b] 上 n 阶光滑，存在 x' 于 x₀、x 之间使 f x = Taylor 多项式 + f⁽ⁿ⁺¹⁾(x')(x−x₀)ⁿ⁺¹/(n+1)!
premises: [analysis.mvt.lagrange, analysis.derivative.chain-rule]
mathlib: [taylor_mean_remainder_lagrange, taylorWithinEval, iteratedDerivWithin]
provenance:
  source_type: book
  ref: Rudin, Principles of Mathematical Analysis, Thm 5.15（Taylor 定理，Lagrange 余项）
---

# analysis.mvt.taylor

- **家族**: `analysis.mvt`
- **变体**: rudin（Rudin《Principles of Mathematical Analysis》）
- **状态**: verified
- **一句话**: 光滑函数在一点可用其 Taylor 多项式近似，余项由更高阶导数控制（Lagrange 余项）。

## 直觉

反复用中值定理把"函数减 Taylor 多项式"的差消掉：余项正是某一中间点的 (n+1) 阶导数乘 (x−x₀)ⁿ⁺¹/(n+1)!。Rudin 5.15 的陈述即此。

## 陈述（Lean 对照）

`∃ x' ∈ Set.uIoo x₀ x, f x - taylorWithinEval f n (Set.uIcc x₀ x) x₀ x = iteratedDerivWithin (n+1) f (Set.uIcc x₀ x) x' * (x - x₀) ^ (n+1) / ↑(n+1).factorial`

其中 `taylorWithinEval f n s x₀ x` 是 n 阶 Taylor 多项式在 x 处的值（Rudin 记号 P(β)）。

## 依赖（人话版）

premises: analysis.mvt.lagrange（中值定理族）、analysis.derivative.chain-rule；
mathlib: taylor_mean_remainder_lagrange、taylorWithinEval、iteratedDerivWithin。

## 应用与陷阱

- Taylor 定理是数值逼近、凸性判定、极值二阶判据的基石。
- mathlib 用 `taylorWithinEval`（PolynomialModule 求值）与 `iteratedDerivWithin`（区间内 n 阶导数），
  与 Rudin 的 P(t)=Σ f⁽ᵏ⁾(α)/k!·(t−α)ᵏ 一一对应。
- 区间记号 `Set.uIcc x₀ x`（unordered interval）自动处理 x₀ < x 与 x < x₀ 两种情况。
