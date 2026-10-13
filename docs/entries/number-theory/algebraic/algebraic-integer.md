---
id: number-theory.algebraic.algebraic-integer
family: number-theory.algebraic
variant: textbook
kind: definition
state: verified
title: 代数整数与整闭包
summary: 代数整数是整元素；整元素对加、减、乘封闭构成整闭包子环，并且 ℚ 中的代数整数恰为整数
premises: []
mathlib: [IsIntegral, integralClosure, IsIntegralClosure, IsIntegrallyClosed, GCDMonoid.toIsIntegrallyClosed, Polynomial.eval₂]
provenance:
  source_type: book
  ref: "ireland-rosen-number-theory-1990"
---

# 动机

数域里并非所有元素都像整数那样「良好」。要复刻 `ℤ ⊂ ℚ` 的关系，必须挑出数域中在 `ℤ` 上整
的元素，它们就是代数整数。整元素对加、减、乘封闭，因此能组成一个环——整闭包。本节先把
「整」这个概念、它的首一多项式判据、封闭性，以及「有理整数只能是整数」这条经典结论固定下来。

# 直觉

「整」的定义来自整数的一个显著特征：`n ∈ ℤ` 是首一多项式 `X - n` 的零点。把这一特征推广到
任意环扩张：`x` 是整的，如果它是某个首一多项式的零点。首一是关键——去掉首一会把 `1/2` 之类
元素也算进来，破坏整性。整元素对加减乘封闭，直观上是因为「整」等价于「由 `x` 生成的模有限
生成」，而有限生成模在运算下保持有限。

# 陈述（自然语言）

设 `R → A` 是交换环的代数。

1. `x ∈ A` 在 `R` 上整，当且仅当存在首一多项式 `p ∈ R[X]` 使 `p(x) = 0`；
2. 全体整元素构成子代数 `integralClosure R A`，其成员恰为整元素；
3. 基环元素的像是整的，整数在任意 `R`-代数中也是整的；
4. 整元素对加、乘、取负、减封闭；
5. `ℤ` 是整闭的；
6. 有理数 `q` 在 `ℤ` 上整当且仅当 `q` 是整数。

# 陈述（Lean 对照）

```lean
theorem isIntegral_iff_monic {x : A} :
    IsIntegral R x ↔ ∃ p : R[X], p.Monic ∧ Polynomial.eval₂ (algebraMap R A) x p = 0

theorem isIntegral_iff_mem_integralClosure {x : A} :
    x ∈ integralClosure R A ↔ IsIntegral R x

theorem isIntegral_add (hx : IsIntegral R x) (hy : IsIntegral R y) : IsIntegral R (x + y)
theorem isIntegral_mul (hx : IsIntegral R x) (hy : IsIntegral R y) : IsIntegral R (x * y)

theorem int_isIntegrallyClosed : IsIntegrallyClosed ℤ

theorem isIntegral_rat_iff (q : ℚ) : IsIntegral ℤ q ↔ ∃ n : ℤ, (n : ℚ) = q
```

正式承载是 Mathlib 的 `IsIntegral`（整元素谓词）、`integralClosure`（整闭包子代数）与
`IsIntegrallyClosed`（整闭环）。本文件的自建公开名只是同义再陈述与组合结论，不含新的数学定义。

# 思维脉络（thinking trace）

1. 教材「整 = 首一多项式零点」被 Mathlib 的 `IsIntegral` 取作定义，因此
   `isIntegral_iff_monic` 直接是 `Iff.rfl`，用来把定义亮给读者。
2. 整闭包在 Lean 中是一个 `Subalgebra`，`mem_integralClosure_iff` 就是 `Iff.rfl`；本文件把它
   作为「谓词 ↔ 子代数成员」的桥。
3. 封闭性四条由整闭包的子环结构导出；它们合起来说明整元素集合是子环。
4. `ℤ` 整自：一般结论是 GCD 整环整闭，`ℤ` 是 GCD 整环，实例
   `GCDMonoid.toIsIntegrallyClosed` 即给出。
5. 有理定理：`IsIntegrallyClosed.algebraMap_eq_of_integral` 把 `ℚ` 中的整元素拉回
   `algebraMap ℤ ℚ` 的像，即整数；反向用 `isIntegral_intCast`。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| `x` 在 `R` 上整 | `IsIntegral R x` |
| 首一多项式零点 | `∃ p : R[X], p.Monic ∧ Polynomial.eval₂ (algebraMap R A) x p = 0` |
| 整闭包 | `integralClosure R A` |
| 整元素构成子环 | `IsIntegral.add`、`IsIntegral.mul` 等 |
| `ℤ` 整闭 | `IsIntegrallyClosed ℤ` |
| 有理代数整数是整数 | `isIntegral_rat_iff q` |

# 依赖（人话版）

- `IsIntegral`：Mathlib 的整元素谓词，与教材定义一致，是正式承载。
- `integralClosure`：`R` 在 `A` 中的整闭包子代数；成员的刻画是 `Iff.rfl`。
- `IsIntegrallyClosed`：整闭环的谓词；`ℤ` 的实例由 GCD 整环一般结论得到。
- `Polynomial.eval₂` / `p.Monic`：多项式在代数中的取值与首一性，用于判据的正向陈述。
- 本条目没有库内前提；它被 N2.3 的整数环作为承载依赖。

# 应用与陷阱

- 应用：N2.3 的整数环就是 `integralClosure ℤ K`；本节的有理定理说明 `𝓞_ℚ = ℤ`。
- 陷阱：整 ≠ 代数。代数只要求某个非零多项式零点，整要求**首一**多项式；`1/2` 在 `ℤ` 上代数
  但不整。
- 陷阱：一般环上「整闭包」未必是整闭的；本条只陈述整闭包的封闭性与 `ℤ` 的整闭性，不声称
  任意整闭包整闭。
- 未完成边界：不涉及范数与迹、判别式、Dedekind 整环；这些属于 N2.4 及以后。
