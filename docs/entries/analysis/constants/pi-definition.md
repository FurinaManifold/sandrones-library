---
id: analysis.constants.pi-definition
kind: definition
state: verified
title: "圆周率 π 的定义接口与基本特殊值"
premises: [analysis.special-functions.basic, analysis.special-functions.tan-pow]
mathlib: ["Real.pi_pos", "Real.pi_ne_zero", "Real.sin_pi", "Real.cos_pi", "Real.two_pi_pos"]
provenance:
  source_type: textbook
  ref: "数学分析 I：三角函数与圆周率"
---

# 内容

本条目定义教材层圆周率接口 `pi := Real.pi`，并证明
\[
0<\pi,\qquad \pi\ne0,\qquad 2\pi>0.
\]

同时登记基本特殊值
\[
\sin\pi=0,\qquad \cos\pi=-1.
\]

这里先固定 `π` 的命名和基本三角值；`π` 的无理性另列为需要额外算术工具的后续批次。
