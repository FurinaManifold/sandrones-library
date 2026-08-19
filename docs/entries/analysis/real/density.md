---
id: analysis.real.density
family: analysis.real
variant: ecnu
kind: theorem
state: verified
title: 有理数在实数中稠密
summary: 任意两实数之间存在有理数
premises: []
mathlib: [exists_rat_btwn]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第一章（实数）"
---

# 动机

有理数"量少"（可数，见 settheory.cardinal.countable-rat）却无处不在：任意两个实数
之间都夹着一个有理数。这保证了**实数的每个局部都能被有理数逼近**——极限论里
"取有理数 δ"、"有理数逼近无理数"的论证全部依托于此。

# 直觉

无论 x < y 贴得多近，差 y - x > 0 是一条正的小缝；用阿基米德性质找一个足够大的
分母 n 使缝比 1/n 还宽，再找一个分子 m 落进缝里。于是 x < m/n < y。
有理数像沙子，实数像地面——地面每个缝隙里都有沙子。

# 陈述（自然语言）

对任意实数 x < y，存在有理数 q 使得 x < q < y。

# 陈述（Lean 对照）

```lean
theorem rational_dense (x y : ℝ) (hxy : x < y) : ∃ q : ℚ, x < (q : ℝ) ∧ (q : ℝ) < y := by
  exact exists_rat_btwn hxy
```

| 人话 | Lean |
|---|---|
| 存在有理数 q | `∃ q : ℚ, ...` |
| q 视为实数 | `(q : ℝ)`（强转） |
| 稠密性 | `exists_rat_btwn` |

# 思维脉络（thinking trace）

1. **构造分母**：用阿基米德性质（archimedean）取 n 使 1/n < y - x。
2. **取分子**：找整数 m 使 x·n < m < y·n（再一次用整数任意大/小的性质）。
3. **回代**：除以 n 得 x < m/n < y，令 q := m/n。
4. **形式化**：mathlib 的 `exists_rat_btwn` 把整个构造打包成多态定理
   （任意阿基米德序域），`exact` 直接完成。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 两实数间存在有理数 | `exists_rat_btwn hxy` |
| 有理数强转实数 | `(q : ℝ)` |

# 依赖（人话版）

无库内依赖（mathlib 打包了构造；概念上依托 `analysis.real.archimedean`）。

# 公理依赖（#print axioms）

```
rational_dense 依赖: [propext, Classical.choice, Quot.sound]
```

choice 有两个来源，均不可削减：
1. **结构必需**：类型含 `ℝ` 的序结构（`x < y`），mathlib 4.33 的 `ℝ` 序实例定义体经典构造；
2. **构造提取**：`exists_rat_btwn` 从"存在有理数"中提取 witness 也要选择。

# 应用与陷阱

**应用**：
- 用有理数逼近无理数：给定 x 与 ε>0，取 q ∈ (x, x+ε)。
- 单调函数不连续点至多可数（每个不连续点抓一个有理数"标记"）。
- 构造区间套、证明确界时用有理数"夹逼"。

**陷阱**：
- 稠密 ≠ 完备：ℚ 稠密于 ℝ 但不完备（确界原理只属于 ℝ）。
- 严格不等：`x < y` 才能保证有理数存在；`x = y` 时缝隙为零，没有有理数可夹。