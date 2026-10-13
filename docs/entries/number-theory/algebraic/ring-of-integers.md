---
id: number-theory.algebraic.ring-of-integers
family: number-theory.algebraic
variant: textbook
kind: definition
state: verified
title: 数域的整数环
summary: 整数环是数域中在 ℤ 上整的元素全体；它以该数域为分式域、整闭，且秩等于扩张次数
premises: ["number-theory.algebraic.number-field", "number-theory.algebraic.algebraic-integer"]
mathlib: [NumberField.RingOfIntegers, IsIntegralClosure, IsFractionRing, IsIntegrallyClosed, NumberField.RingOfIntegers.rank, Module.finrank]
provenance:
  source_type: book
  ref: "ireland-rosen-number-theory-1990"
---

# 动机

有了数域和代数整数，就能把它们组装成代数数论真正的主角：整数环 `𝓞_K`。它把 `ℤ ⊂ ℚ` 的关系
提升到 `𝓞_K ⊂ K`，并且携带分式域、整闭性、有限自由模等结构。后续的范数、迹、判别式、
Dedekind 性、理想唯一分解都以整数环为载体。

# 直觉

整数环就是「数域里所有代数整数」。因为代数整数对加减乘封闭（上一节），它们自然构成一个环；
又因为它包含 `ℤ` 且在 `K` 中极大，取分式就回到整个 `K`。最像 `ℤ` 的性质是整闭：`K` 中在
`𝓞_K` 上整的元素不会再超出 `𝓞_K`。此外 `𝓞_K` 作为 `ℤ`-模是有限自由模，秩就是扩张次数——
这正是「整基」概念的来源。

# 陈述（自然语言）

设 `K` 是数域，`𝓞_K` 是 `K` 中在 `ℤ` 上整的元素全体。

1. `K` 中的 `x` 在 `ℤ` 上整，当且仅当它来自某个 `y ∈ 𝓞_K`；
2. 给定整元素 `x : K`，可以构造 `𝓞_K` 中的元素，且强制转换回 `K` 还是 `x`；
3. `𝓞_K` 中的元素在 `K` 中是整的；
4. `𝓞_K → K` 是单射；
5. `𝓞_K` 是 `ℤ` 在 `K` 中的整闭包；
6. `K` 是 `𝓞_K` 的分式域；
7. `𝓞_K` 是整闭的；
8. `𝓞_K` 作为 `ℤ`-模的秩等于 `[K : ℚ]`。

# 陈述（Lean 对照）

```lean
theorem ringOfIntegers_mem_iff (K : Type*) [Field K] {x : K} :
    IsIntegral ℤ x ↔ ∃ y : NumberField.RingOfIntegers K, (algebraMap _ K) y = x

def ringOfIntegersMk (K : Type*) [Field K] (x : K) (hx : IsIntegral ℤ x) :
    NumberField.RingOfIntegers K

theorem ringOfIntegers_isIntegralClosure (K : Type*) [Field K] :
    IsIntegralClosure (NumberField.RingOfIntegers K) ℤ K

theorem ringOfIntegers_isFractionRing (K : Type*) [Field K] [NumberField K] :
    IsFractionRing (NumberField.RingOfIntegers K) K

theorem ringOfIntegers_isIntegrallyClosed (K : Type*) [Field K] [NumberField K] :
    IsIntegrallyClosed (NumberField.RingOfIntegers K)

theorem ringOfIntegers_rank (K : Type*) [Field K] [NumberField K] :
    Module.finrank ℤ (NumberField.RingOfIntegers K) = Module.finrank ℚ K
```

Lean 的正式承载是 `NumberField.RingOfIntegers K`，其定义就是整闭包 `integralClosure ℤ K`。
本文件不新建同构定义，只把它与 `IsIntegral` 谓词桥接并陈述其基本结构性质。

# 思维脉络（thinking trace）

1. `𝓞_K` 在 Mathlib 中已经是 `integralClosure ℤ K`，与教材定义一致，故直接复用。
2. 成员刻画由 `IsIntegralClosure.isIntegral_iff` 给出：`IsIntegral ℤ x ↔ ∃ y, algebraMap y = x`。
3. 构造入口 `ringOfIntegersMk` 就是子类型构造 `⟨x, hx⟩`，其强制转换由 `rfl` 关闭。
4. 整闭性、分式域、整闭包三条性质都是 Mathlib 已注册的实例，本文件以具名定理公开。
5. 秩等式取 `NumberField.RingOfIntegers.rank`；它是「整基」讨论的秩部分。
6. 整基的存在性与具体构造不在本条，留作后续批次。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 整数环 `𝓞_K` | `NumberField.RingOfIntegers K` |
| `x` 是 `K` 中的代数整数 | `IsIntegral ℤ x` |
| `x` 来自整数环 | `∃ y : 𝓞_K, algebraMap y = x` |
| 由整元素构造整数环元素 | `ringOfIntegersMk K x hx` |
| `𝓞_K` 是整闭包 | `IsIntegralClosure (𝓞 K) ℤ K` |
| `K` 是 `𝓞_K` 的分式域 | `IsFractionRing (𝓞 K) K` |
| `𝓞_K` 整闭 | `IsIntegrallyClosed (𝓞 K)` |
| 秩 = 扩张次数 | `ringOfIntegers_rank K` |

# 依赖（人话版）

- 库内前提 `number-theory.algebraic.number-field`：`𝓞_K` 的存在性、分式域与秩等式都需要
  `NumberField K`。
- 库内前提 `number-theory.algebraic.algebraic-integer`：`𝓞_K` 的元素定义与成员刻画依赖
  `IsIntegral ℤ`。
- `NumberField.RingOfIntegers`：Mathlib 的整数环类型，定义为 `integralClosure ℤ K`。
- `IsIntegralClosure`、`IsFractionRing`、`IsIntegrallyClosed`：整数环的三条结构性质承载。
- `Module.finrank` 与 `NumberField.RingOfIntegers.rank`：秩等式。

# 应用与陷阱

- 应用：后续范数、迹、判别式、Dedekind 性与理想唯一分解都将以 `𝓞_K` 为载体。
- 陷阱：整数环一般**不是**域（`RingOfIntegers.not_isField`），也不是 `K` 的同构副本；它是
  `K` 的子环，`𝓞_K → K` 单射。
- 陷阱：本条只给出秩；「整基存在」与「判别式」属于 N2.4/N2.5，不得由秩等式冒充。
- 未完成边界：未涉及 Dedekind 性（N2.6）、分式理想（N2.7）、类群（N2.9）；也未给出任何
  具体数域的整数环计算。
