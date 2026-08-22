---
id: analysis.special-functions.log
kind: theorem
state: verified
title: "对数函数的基本性质"
premises: [analysis.special-functions.basic, analysis.continuity.definition, analysis.derivative.const]
mathlib: ["Real.continuousOn_log", "Real.strictMonoOn_log", "Real.log_mul", "Real.exp_log", "Real.log_exp", "Real.hasDerivAt_log"]
provenance:
  source_type: textbook
  ref: "数学分析 I：对数函数的基本性质"
---

# 内容

本批次整理自然对数在正半轴上的教材层性质：连续性、严格单调性、乘法加法公式，以及它和指数函数互为反函数的关系。还保留导数公式
\( (\log x)'=1/x \)；该公式在库中对所有非零点成立，本批次重点使用正半轴上的版本。

对正数 \(x,y\)，有
\[
\log(xy)=\log x+\log y,\qquad
\exp(\log x)=x,
\]
并且对任意实数 \(x\)，
\[
\log(\exp x)=x.
\]

所有证明均为有限的函数性质调用，不使用级数展开。
