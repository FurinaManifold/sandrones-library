---
id: analysis.integral.examples
kind: theorem
state: verified
title: "初等函数的 Riemann 定积分公式"
premises: ["real-analysis.riemann.ftc", "real-analysis.riemann.parts-substitution", "analysis.special-functions.basic"]
mathlib: ["hasDerivAt_pow", "Real.hasDerivAt_exp", "Real.hasDerivAt_sin", "Real.hasDerivAt_cos"]
provenance:
  source_type: book
  ref: "数学分析 II：Newton–Leibniz 公式的基本计算例"
---

# 内容

本条目收录一元积分学中最常用的四类初等函数定积分公式，并增加一个线性三角换元例。
所有结论使用本库自建的 `riemannIntegral`。

## 自然数幂

对任意 `n : ℕ` 和 `a<b`，

\[
 \int_a^b x^n\,dx=
 \frac{b^{n+1}}{n+1}-\frac{a^{n+1}}{n+1}.
\]

Lean 中取原函数 `x ↦ x^(n+1)/(n+1)`。由于 `n+1` 为正整数，其实数嵌入非零，
导数化简为 `x^n`。

## 指数和三角函数

\[
\int_a^b e^x\,dx=e^b-e^a,
\qquad
\int_a^b \cos x\,dx=\sin b-\sin a,
\]

\[
\int_a^b \sin x\,dx=\cos a-\cos b.
\]

三式分别使用原函数 `exp`、`sin` 和 `-cos`，直接调用上一批已经对齐自建积分的
Newton–Leibniz 公式。

## 线性三角换元

当 `c>0` 时，令 `t=cx+d`，由 Riemann 换元公式得到

\[
 \int_a^b c\cos(cx+d)\,dx
 =\sin(cb+d)-\sin(ca+d).
\]

这个例子显式调用 `riemannIntegral_comp_mul_deriv`，用于确认复合函数、导数因子和
换元后端点的方向都与教材公式一致。

# Lean 对照

- `riemannIntegral_pow`：自然数幂；
- `riemannIntegral_exp`：指数函数；
- `riemannIntegral_cos`：余弦函数；
- `riemannIntegral_sin`：正弦函数；
- `riemannIntegral_const_mul_cos_affine`：线性三角换元。

# 边界

- 当前公式按自建 Darboux 分划约定要求 `a<b`。
- 幂函数结果先覆盖教材最基础的自然数指数。负整数幂和一般实幂需要定义域避开零或
  限制在正半轴，适合后续特殊函数积分批次。
- 线性换元暂取 `c>0`，使换元后端点保持正向；`c<0` 需要先建立自建积分的反向区间约定。

# 公理依赖

由注册审计脚本从五个相关 Lean 定理合并得到。
