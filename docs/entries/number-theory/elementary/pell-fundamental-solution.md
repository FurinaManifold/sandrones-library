---
id: number-theory.elementary.pell-fundamental-solution
family: number-theory.elementary
variant: least-positive
kind: theorem
state: verified
title: Pell 基本解存在
summary: 正非平方参数存在第一坐标最小的正非平凡 Pell 解
premises: [number-theory.elementary.pell-equation, number-theory.elementary.pell-positive-existence]
mathlib: [Pell.IsFundamental, Pell.IsFundamental.exists_of_not_isSquare, Pell.Solution₁.mk, Pell.Solution₁.prop, Pell.Solution₁.x_mk]
provenance:
  source_type: book
  ref: "Ireland--Rosen, A Classical Introduction to Modern Number Theory, Section 17.5"
---

# 动机

正 Pell 方程通常有许多正解。为了描述全部解或进行递推，需要选定一个规范起点：在所有非平凡
正解中第一坐标最小的那个解，称为基本解。

# 直觉

先由存在性知道正解集合非空，再利用自然数的良序性挑出最小 `x`。方程和 `y>0` 随所选解保留。
“最小第一坐标”比任意选择一个解更稳定，也与传统 Pell 理论中的生成元一致。

# 陈述（自然语言）

基本解 `a` 满足：

- `1 < a.x`；
- `0 < a.y`；
- 对每个 `1 < b.x` 的 Pell 解 `b`，都有 `a.x ≤ b.x`。

正非平方参数 `d` 总存在这样的基本解。最小性把“众多正解”固定到一个规范起点。

# 陈述（Lean 对照）

```lean
def IsFundamentalPellSolution (a : PellSolution d) : Prop :=
  1 < a.x ∧ 0 < a.y ∧
    ∀ b : PellSolution d, 1 < b.x → a.x ≤ b.x

theorem exists_fundamentalPellSolution {d : ℤ} (hd : 0 < d) (hns : ¬IsSquare d) :
    ∃ a : PellSolution d, IsFundamentalPellSolution a
```

# 思维脉络（thinking trace）

Mathlib 的 `Pell.IsFundamental.exists_of_not_isSquare` 给出打包基本解。为验证它对本库所有
`PellSolution` 的最小性，证明把任意坐标解临时送入 `Pell.Solution₁.mk`，使用 Mathlib 的最小性，
再把结论拉回整数坐标。

1. `obtain ⟨a, ha⟩ := ...` 取得内部基本解及其三部分性质。
2. `refine` 先组装本库解、`x>1`、`y>0`，只留下对任意本库竞争者的最小性目标。
3. `let b' := Pell.Solution₁.mk ...` 把竞争者桥接到 Mathlib 的打包类型。
4. `simpa [b'] using hb` 借助 `Pell.Solution₁.x_mk` 把坐标正性搬过去。
5. `ha.2.2 hb'` 应用内部最小性，第二个 `simpa [b']` 再把结论搬回本库坐标。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 基本解谓词 | `IsFundamentalPellSolution a` |
| 对所有竞争解最小 | `∀ b, 1 < b.x → a.x ≤ b.x` |
| 构造内部打包解 | `Pell.Solution₁.mk b.x b.y b.equation` |
| 留下尚待证明的目标 | `refine ⟨..., ?_⟩` |
| 化简桥接定义 | `simpa [b'] using ...` |

# 依赖（人话版）

- `Pell.IsFundamental.exists_of_not_isSquare`：Mathlib 的基本解存在性。
- `Pell.Solution₁.mk` / `x_mk`：在整数坐标解和内部解之间建立局部桥。
- `Pell.Solution₁.prop`：把内部基本解的方程拉回本库。
- `number-theory.elementary.pell-positive-existence`：解释正解集合为何非空；正式 Lean 证明直接复用更强的 Mathlib 基本解定理。

# 应用与陷阱

Mathlib 还证明全体打包解在符号意义下都是基本解的整数次幂。本条公开接口尚未给
`PellSolution` 建立完整交换群和整数幂，因此只转正“基本解存在与最小性”，不虚报全体解分类。
同样，本条没有证明基本解来自 `√d` 的连分数周期。

- 应用：作为以后在坐标接口上建立幂生成与解分类的规范生成元。
- 陷阱：最小化的是 `x`，不是先最小化 `y`；定义中的 `y>0` 用来固定符号。
- 陷阱：存在性不等于已证明唯一性；唯一性需要再由相同 `x` 与 Pell 方程推出相同正 `y`。
