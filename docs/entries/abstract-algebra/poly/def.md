---
id: abstract-algebra.poly.def
family: abstract-algebra.poly
variant: rotman
kind: theorem
state: verified
title: 多项式环与整除性
summary: 多项式外延性；根的定义；因式定理(X-a整除⟺根)；R整环⟹R[X]整环；单位元=非零常数
premises: [abstract-algebra.ring.def]
mathlib: [Polynomial.ext, Polynomial.dvd_iff_isRoot, Polynomial.isDomain_iff, Polynomial.isUnit_iff]
provenance:
  source_type: book
  ref: Rotman, Advanced Modern Algebra, Ch 2（多项式）
---

# abstract-algebra.poly.def

- **家族**: `abstract-algebra.poly`
- **变体**: rotman
- **状态**: verified
- **一句话**: 多项式由系数决定；X−a 整除 ⟺ a 是根。

## 直觉

多项式环 R[X] 的元素由各项系数决定（外延性）。代入求值 `eval` 是核心运算。
因式定理：X−a 整除 p ⟺ p(a)=0（a 是根）。R 整环时 R[X] 也整环；多项式环单位元恰是非零常数。

## 陈述（教材记号）

`poly_ext`：系数全等 ⟹ 多项式相等。`is_root_iff_eval_eq_zero`：根的定义。
`dvd_X_sub_C_iff_isRoot`：X−C a ∣ p ⟺ a 是根（因式定理）。
`poly_is_domain_of_is_domain`：R 整环 ⟹ R[X] 整环。
`poly_isUnit_iff`：p 可逆 ⟺ p 是非零常数。

## 依赖（人话版）

前提：abstract-algebra.ring.def。mathlib 的 `Polynomial R` 是多项式类型，`X` 不定元、`C` 常数嵌入；
`Polynomial.dvd_iff_isRoot` 是因式定理，`isUnit_iff` 给单位元刻画。

## 应用与陷阱

- `p.IsRoot a` 与 `p.eval a = 0` 是 definitional 相等的（rfl）。
- `[CommRing R] [IsDomain R]` 下 `IsDomain R[X]` 可 `infer_instance`。
