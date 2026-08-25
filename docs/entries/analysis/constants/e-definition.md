---
id: analysis.constants.e-definition
kind: definition
state: verified
title: "自然常数 e 的定义与基本范围"
premises: [analysis.special-functions.basic, analysis.special-functions.log]
mathlib: ["Real.exp_pos", "Real.exp_one_gt_two", "Real.exp_one_lt_three", "Real.log_exp"]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 内容

本条目定义
\[
e := \exp(1).
\]

并证明
\[
0<e,\qquad 2<e<3,\qquad \log e=1.
\]

这里的 `e` 是自然常数的命名接口；`e` 的无理性需要级数或积分中的额外算术估计，另列为后续条目。
