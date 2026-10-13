---
id: analysis.complex.definition
kind: definition
state: partial
title: 复数的定义与基本运算
premises: []
mathlib: [Complex, Complex.ext_iff, Complex.normSq, Complex.sq_norm]
provenance:
  source_type: book
  ref: ahlfors-complex-analysis-1979
---

# 复数的定义与基本运算

## 定义

复数是两个实数组成的有序对 `(x,y)`，通常写成

`z = x + yi`，

其中 `x` 是实部，`y` 是虚部，虚数单位 `i` 满足 `i²=-1`。本库的 `mk x y`
直接构造这个复数，并与 mathlib 的复数类型 `ℂ` 对齐，因此后续复分析和代数中的
复数结论可以使用同一种对象。

## 基本公式

- 判等：`z=w` 当且仅当实部、虚部分别相等；
- 加法：`(x+yi)+(u+vi)=(x+u)+(y+v)i`；
- 乘法：`(x+yi)(u+vi)=(xu-yv)+(xv+yu)i`；
- 共轭：`conj(x+yi)=x-yi`；
- 模平方：`|x+yi|²=x²+y²`；
- 与共轭相乘：`z·conj(z)=|z|²`，结果是非负实数。

## Lean 接口

核心定义和结论位于 `SandronesLibrary/Analysis/Complex.lean`：

- `mk`、`mk_re`、`mk_im`；
- `ext_iff`、`existsUnique_real_imag`；
- `mk_add`、`mk_mul`；
- `I_eq_mk`、`I_sq`；
- `conj_mk`、`mul_conj`、`norm_sq`。
