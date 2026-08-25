---
id: analysis.special-functions.log-tan-pow
kind: theorem
state: verified
title: "对数、正切、幂函数与反三角函数"
premises: [analysis.special-functions.basic, analysis.continuity.definition, analysis.derivative.const]
mathlib: ["Real.log_mul", "Real.continuousOn_log", "Real.hasDerivAt_log", "Real.hasDerivAt_tan", "Continuous.pow", "HasDerivAt.pow", "Real.continuous_arctan", "Real.hasDerivAt_arctan", "Real.tan_arctan", "Real.continuous_arcsin", "Real.continuous_arccos", "Real.hasDerivAt_arcsin", "Real.hasDerivAt_arccos"]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

本批次补充对数、正切、自然幂函数与反三角函数的教材层性质，包括对数乘法公式、正半轴连续性、导数公式，自然幂函数的连续性和导数，以及反正切、反正弦、反余弦的连续性和导数。

其中反正切满足
\[
\tan(\arctan x)=x,\qquad
(\arctan x)'=\frac{1}{1+x^2}.
\]
反正弦、反余弦在不触及端点 \(\pm1\) 的内部点分别满足
\[
(\arcsin x)'=\frac1{\sqrt{1-x^2}},\qquad
(\arccos x)'=-\frac1{\sqrt{1-x^2}}.
\]
