---
id: analysis.limits.asymptotic
kind: theorem
state: verified
title: "指数、对数与幂函数的渐进比较"
premises: [analysis.special-functions.basic, analysis.special-functions.log, analysis.limits.classical]
mathlib: ["Real.tendsto_log_atTop", "Real.isLittleO_log_id_atTop", "Real.tendsto_exp_div_pow_atTop", "Real.isLittleO_pow_exp_atTop"]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

在 \(x\to+\infty\) 时：

- \(\log x\to+\infty\)；
- \(\log x=o(x)\)，即对数相对于恒等函数是高阶无穷小；
- 对每个固定的 \(n\in\mathbb N\)，\(e^x/x^n\to+\infty\)；
- 等价地，\(x^n=o(e^x)\)。

这些结论形式化为 `Tendsto` 与 `IsLittleO`，为后续无穷小阶比较和积分估计提供接口。
