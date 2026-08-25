---
id: analysis.trigonometric.tan-identities
kind: theorem
state: verified
title: "正切的和差与倍角公式"
premises: [analysis.trigonometric.add-sub, analysis.trigonometric.double-half]
mathlib: ["Real.tan_add", "Real.tan_sub", "Real.tan_two_mul"]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

本条目登记正切和角、差角公式。公式中的极点条件被完整保留：两角都避开正切极点，或两角同时为极点。
\[
\tan(x+y)=\frac{\tan x+\tan y}{1-\tan x\tan y},
\qquad
\tan(x-y)=\frac{\tan x-\tan y}{1+\tan x\tan y}.
\]

此外登记正切倍角公式
\[
\tan(2x)=\frac{2\tan x}{1-\tan^2x}.
\]
