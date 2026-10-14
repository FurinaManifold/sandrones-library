---
id: number-theory.elementary.pell-all-positive
family: number-theory.elementary
variant: classification
kind: theorem
state: verified
title: 正 Pell 方程全体正解的分类
summary: 每个坐标非负的正解都是基本解的 Brahmagupta 幂，反之基本解的幂都是正解
premises: [number-theory.elementary.pell-equation, number-theory.elementary.pell-composition, number-theory.elementary.pell-positive-existence, number-theory.elementary.pell-fundamental-solution]
mathlib: [Pell.Solution₁, Pell.Solution₁.mk, Pell.Solution₁.ext, Pell.Solution₁.x_mul, Pell.Solution₁.y_mul, Pell.Solution₁.x_pow_pos, Pell.Solution₁.y_pow_succ_pos, Pell.IsFundamental, Pell.IsFundamental.eq_pow_of_nonneg, Pell.IsFundamental.subsingleton]
provenance:
  source_type: book
  ref: "hardy-wright-number-theory-2008"
---

# 动机

Brahmagupta 复合给出一个便宜的事实：把基本解反复与自身复合，得到的仍然是解。但“幂仍是解”
只说出了幂序列落在解集里，并没有说出解集里没有别的东西。Pell 方程的教材结论是更强的分类：
解集恰好就是这条幂序列。本条补的就是这个“反方向”的全称那一半。

# 直觉

在二次整数环里，`x² - d y² = 1` 的解对应 `ℤ√d` 中范数为 `1` 的单位元，基本解对应
`1 + √d` 的类似物，于是“所有正单位元都是基本单位的幂”来自单位群是无限循环群这一事实。
整数坐标版本要证明的是同一件事，但读者只需要理解复合，不需要理解单位群。

“正解”在这里指第二坐标非负的解。第二坐标为负的解是正解的逆（共轭），带符号的完整分类需要
整数次幂，属于另一条陈述。

# 陈述（自然语言）

设 `a` 是正 Pell 方程 `x² - d y² = 1` 的基本解，`b` 是它的一个解。则

- 若 `0 < b.x` 且 `0 ≤ b.y`，就存在自然数 `n` 使 `b = a^n`（幂按 Brahmagupta 复合迭代，`a^0` 为平凡解 `(1, 0)`）；
- 反之，对每个自然数 `n`，`a^n` 都满足 `0 < x` 与 `0 ≤ y`。

两句话合起来：以基本解为底，**坐标非负的解集与幂序列完全重合**。若把“正解”加强为教材常用的
非平凡正解（`1 < x`、`0 < y`），则指数可以加强为 `0 < n`。对正的非平方整数 `d`，这样的基本解存在，
所以分类是无条件可用的。

# 陈述（Lean 对照）

```lean
def PellSolution.pow (a : PellSolution d) : ℕ → PellSolution d
  | 0 => PellSolution.one d
  | n + 1 => (PellSolution.pow a n).comp a

theorem exists_pow_eq_of_fundamental {d : ℤ} {a : PellSolution d}
    (ha : IsFundamentalPellSolution a) {b : PellSolution d} (hx : 0 < b.x) (hy : 0 ≤ b.y) :
    ∃ n : ℕ, b = a.pow n

theorem pos_iff_exists_pow {d : ℤ} {a : PellSolution d} (ha : IsFundamentalPellSolution a)
    (b : PellSolution d) : (0 < b.x ∧ 0 ≤ b.y) ↔ ∃ n : ℕ, b = a.pow n

theorem exists_pos_pow_eq_of_fundamental {d : ℤ} {a : PellSolution d}
    (ha : IsFundamentalPellSolution a) {b : PellSolution d} (hx : 1 < b.x) (hy : 0 < b.y) :
    ∃ n : ℕ, 0 < n ∧ b = a.pow n

theorem exists_fundamental_pellSolution_pow_classification {d : ℤ} (hd : 0 < d)
    (hns : ¬IsSquare d) :
    ∃ a : PellSolution d, IsFundamentalPellSolution a ∧
      ∀ b : PellSolution d, (0 < b.x ∧ 0 ≤ b.y) ↔ ∃ n : ℕ, b = a.pow n
```

# 思维脉络（thinking trace）

证明不是重做分类，而是把本库的整数坐标接口搬到 Mathlib 已经验证过的群论分类上，再搬回来。
四个步骤：

1. **建桥**：`PellSolution.toMathlib` 把 `⟨x, y, h⟩` 送到 `Pell.Solution₁.mk x y h`。
   两条 `@[simp]` 引理说明桥保持两个坐标，`PellSolution.toMathlib_injective` 说明它是单射，
   因此 Mathlib 侧的等式可以安全地拉回本库。
2. **桥保运算**：`PellSolution.toMathlib_comp` 说明本库的复合对应 Mathlib 侧的乘法；
   对 `n` 归纳即得 `PellSolution.toMathlib_pow : (a.pow n).toMathlib = a.toMathlib ^ n`。
   （写这条归纳时踩到一个名字解析坑：本文件自己声明了 `PellSolution.pow_succ`，在
   `namespace SandronesLibrary.NumberTheory.Elementary` 下裸写 `pow_succ` 会被解析成本库那条，
   必须写成 `_root_.pow_succ` 才能指 Mathlib 的乘法幂引理。）
3. **桥保“基本”**：`PellSolution.isFundamental_toMathlib` 逐条对齐两个定义中相同的三个合取项；
   逆向的竞争者用 `⟨b.x, b.y, b.prop⟩` 现场构造。
4. **搬运结论**：`Pell.IsFundamental.eq_pow_of_nonneg` 给出非负解是基本解的非负次幂，
   过桥即得 `exists_pow_eq_of_fundamental`。反方向用 `Pell.Solution₁.x_pow_pos` 与
   `Pell.Solution₁.y_pow_succ_pos`（指数为零时第二坐标就是 `0`）。指数加强那一版只需注意
   指数为零会退化成平凡解，与 `1 < x` 矛盾。

`IsFundamentalPellSolution.subsingleton` 也是过桥得到的：Mathlib 已证基本解唯一。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| Brahmagupta 幂 | `PellSolution.pow a n` |
| 幂的递推 | `PellSolution.pow_succ` |
| 坐标非负的正解 | `0 < b.x ∧ 0 ≤ b.y` |
| 非平凡正解 | `1 < b.x ∧ 0 < b.y` |
| 是基本解的幂 | `∃ n : ℕ, b = a.pow n` |
| 桥（整数坐标 → 单位元） | `PellSolution.toMathlib` |
| 桥保持复合 | `PellSolution.toMathlib_comp` |
| 桥保持幂 | `PellSolution.toMathlib_pow` |
| Mathlib 的全称分类 | `Pell.IsFundamental.eq_pow_of_nonneg` |

# 依赖（人话版）

- `number-theory.elementary.pell-equation`：`PellSolution` 与方程本身。
- `number-theory.elementary.pell-composition`：`PellSolution.comp`，幂就是它的迭代。
- `number-theory.elementary.pell-fundamental-solution`：`IsFundamentalPellSolution` 与它的存在性；
  本条把“存在”升级为“存在且生成全体正解”。
- `Pell.IsFundamental.eq_pow_of_nonneg`：Mathlib 在单位元群上已经证好的全称那一半。
- `Pell.Solution₁.x_pow_pos` / `y_pow_succ_pos`：幂保持坐标非负，用于分类的反方向。

# 应用与陷阱

- 应用：把“求 Pell 方程的全部正解”化归为“找一个基本解，然后反复复合”，也说明基本解是唯一
  的规范生成元（`IsFundamentalPellSolution.subsingleton`）。
- 陷阱：**“幂仍是解”不是分类**。只证 `(a.pow n).equation` 是平凡的（它就是结构字段），
  真正的内容是 `exists_pow_eq_of_fundamental` 这个全称方向；本条两者都给，文档不把前者说成后者。
- 陷阱：结论只覆盖第二坐标非负的解。带符号的完整分类（`a = ±a₁^n`，`n : ℤ`）等价于
  Mathlib 的 `Pell.IsFundamental.eq_zpow_or_neg_zpow`，本条不重述，也没有为 `PellSolution`
  建立整数幂或群结构。
- 陷阱：本条只谈正方程 `x² - d y² = 1`。**负 Pell 方程 `x² - d y² = -1` 的可解性与本条无关**，
  不能由本条的幂分类暗示；它必须作为独立条目处理。
- 陷阱：`0 < b.x` 不能省成 `b.x ≠ 0`；`x = -1, y = 0` 也是解，但不在分类范围内。
- 公理画像：分类定理的 `#print axioms` 是 `[propext, Classical.choice, Quot.sound]`。其中
  `Classical.choice` 不是本条的数学内容，而是借道 Mathlib `Pell` 分类证明路径带进来的
  （`IsFundamental.eq_pow_of_nonneg` 一侧用到经典的可判定性与良序选取）。桥本身
  `PellSolution.toMathlib_pow` 只需 `[propext, Quot.sound]`，说明教材层的“复合—幂”部分是
  构造性的；按 Playbook §3.1，这属于“引用现成定理借道”，不是靠改写能消掉的形式化噪声。
