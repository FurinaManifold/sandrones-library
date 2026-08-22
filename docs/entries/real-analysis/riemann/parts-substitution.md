---
id: real-analysis.riemann.parts-substitution
kind: theorem
state: verified
title: "Riemann 积分的分部积分与换元法"
premises: ["real-analysis.riemann.eq-lebesgue", "real-analysis.riemann.ftc", "analysis.special-functions.basic"]
mathlib: ["intervalIntegral.integral_mul_deriv_eq_deriv_mul", "intervalIntegral.integral_comp_mul_deriv"]
provenance:
  source_type: book
  ref: "数学分析 II：分部积分、换元积分与指数函数例题"
---

# 内容

本条目为自建 `riemannIntegral` 建立两条基本计算法则。

分部积分公式为

\[
 \int_a^b u(x)v'(x)\,dx
 =u(b)v(b)-u(a)v(a)-\int_a^b u'(x)v(x)\,dx.
\]

换元公式为

\[
 \int_a^b g(\varphi(x))\varphi'(x)\,dx
 =\int_{\varphi(a)}^{\varphi(b)}g(t)\,dt.
\]

当前自建 Riemann 积分只为严格正向区间建立了桥梁，因此换元公式显式要求
`a<b` 和 `φ(a)<φ(b)`。

# 实现路线

两个公式都采用薄适配层结构：

1. 连续性证明所有被积函数均可使用 `riemannIntegral_eq_interval`；
2. 把自建积分改写为 Mathlib 有向区间积分；
3. 分别调用 `intervalIntegral.integral_mul_deriv_eq_deriv_mul` 和
   `intervalIntegral.integral_comp_mul_deriv`；
4. 公式中的每个区间积分再由桥梁识别回自建 Riemann 积分。

Mathlib 在这里提供的是 Lebesgue 区间积分运算法则，不是 Riemann 积分定义；自建
积分能够使用这些法则，依赖的是前面已经证明的积分值相等定理。

# 教材例题

模块同时证明两个具体公式，以检验抽象接口的参数方向和函数组合均正确。

## 分部积分：`∫ x eˣ dx`

取 `u(x)=x`、`v(x)=eˣ`，则 `u'=1`、`v'=eˣ`。调用新建分部积分公式后，剩余的
`∫eˣ` 由 Newton–Leibniz 公式计算，得到

\[
 \int_a^b xe^x\,dx=be^b-ae^a-(e^b-e^a).
\]

Lean 定理名为 `riemannIntegral_id_mul_exp`。

## 线性换元：`∫ c exp(cx+d) dx`

当 `c>0` 时，令 `φ(x)=cx+d`。端点次序由 `a<b` 和 `c>0` 保持。调用换元公式后，
右侧成为指数函数在 `[ca+d,cb+d]` 上的积分，再用 Newton–Leibniz 公式得到

\[
 \int_a^b c e^{cx+d}\,dx=e^{cb+d}-e^{ca+d}.
\]

Lean 定理名为 `riemannIntegral_const_mul_exp_affine`。

# Lean 对照

- `riemannIntegral_mul_deriv_eq_deriv_mul`：分部积分；
- `riemannIntegral_comp_mul_deriv`：换元法；
- `riemannIntegral_id_mul_exp`：分部积分例题；
- `riemannIntegral_const_mul_exp_affine`：线性换元例题。

# 后续

下一批 `analysis.integral.examples` 应系统补齐多项式、指数、正弦、余弦和幂函数的
数值积分。本条目的两个例子只负责展示分部积分与换元接口。

# 公理依赖

由注册审计脚本从本条目 Entry 标记关联的四个定理合并得到。
