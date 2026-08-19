---
id: analysis.real.archimedean
kind: theorem
state: verified
title: 阿基米德性质
premises: []
mathlib: [exists_nat_gt, div_lt_iff₀]
provenance:
  source_type: book
  ref: "Rudin, Principles of Mathematical Analysis, Def 1.17 / Ch1"
---

# 动机

实数轴上的序有一个看似平凡却极其深刻的性质：**没有"无穷大数"和"无穷小数"**。
如果你有一个非常小的正数 x（比如 10⁻¹⁰⁰），和一个非常大的数 y（比如 10¹⁰⁰），
把 x 乘以某个正整数 n 总能超过 y——n 只要取到 10²⁰⁰ 就行。

这个性质叫**阿基米德性质**（Archimedean property）。它排除了"无穷小量"（infinitesimal）
的存在，是数学分析中所有涉及"ε-δ""取整""向下取整"推理的基础。
没有它，微积分的地基就塌了——比如"任何正数都能被放大到超过任何数"一旦失败，
极限、连续性、确界原理的证明都会瓦解。

# 直觉

一句话：**整数在实数中"无界"。**

"阿基米德序域"的要点是：给定任意正数 x，序列 x, 2x, 3x, ... 最终会超过任何固定的 y。
等价地：**任意实数 y/x 都小于某个自然数**——这正是 `exists_nat_gt` 说的。

证明的直觉路径：把"放大步长超过目标"翻译成"整数超过比值"。
因为 x > 0，两边同乘 x 不改变不等号方向，所以这两个命题是同一个命题。

# 陈述（自然语言）

对任意正实数 x 与任意实数 y，存在自然数 n，使得 n·x > y。

# 陈述（Lean 对照）

```lean
theorem archimedean_property (x y : ℝ) (hx : 0 < x) : ∃ n : ℕ, y < n * x
```

| 人话 | Lean |
|---|---|
| 对任意正实数 x | `(x : ℝ) (hx : 0 < x)` |
| 对任意实数 y | `(y : ℝ)` |
| 存在自然数 n | `∃ n : ℕ` |
| n·x > y | `y < n * x`（注意这里的 n 隐式升格为 `↑n : ℝ`） |

# 思维脉络（thinking trace）

1. **目标重写**：想找 n 使得 `y < n*x`。手里唯一可用的武器是 `exists_nat_gt`：
   `∀ z, ∃ n, z < n`——任意实数 z 都会被某个自然数超过。
2. **桥**：要让 n 同时满足两个不等式，自然把 `exists_nat_gt` 用在 z = y/x 上。
   这样得到 `y/x < n`。
3. **回去**：`y/x < n` 和 `y < n*x` 只差一个"同乘 x"。因为 hx : 0 < x，
   乘法保持序方向，两者等价。这一步 mathlib 的 `div_lt_iff₀ hx` 一步完成。
4. **为什么不分段**：朴素思路会分 y > 0 和 y ≤ 0 两段讨论（y ≤ 0 时取 n = 1 就够）。
   但 `exists_nat_gt` 对**所有**实数都成立，包括负数，所以分段是多余的。
   识别"武器适用范围"能省掉一整段证明——这是证明中常见的省力技巧。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 实数系 | `ℝ` |
| 阿基米德序 | `Archimedean ℝ`（类型类实例，由 `Mathlib` 自动提供） |
| 任意实数被自然数超过 | `exists_nat_gt : ∀ z : ℝ, ∃ n : ℕ, z < ↑n` |
| c > 0 时 a/c < b ⇔ a < b·c | `div_lt_iff₀ : (b / c < a) ↔ b < a * c` |

# 依赖（人话版）

无库内依赖。它直接引用 mathlib 的两个事实：

1. `exists_nat_gt`：由 `Archimedean ℝ` 类型类实例提供——实数作为完备序域的
   阿基米德性质已经被 mathlib 形式化在地基里。
2. `div_lt_iff₀`：有序域中"除以正数"与"乘正数"的可逆性。

# 公理依赖（#print axioms）

```
archimedean_property 依赖: [propext, Classical.choice, Quot.sound]
```

**注意差异**：教科书证明阿基米德性质时不会提选择公理——它只是"实数系性质"。
但形式化证明（经由 `exists_nat_gt` / `div_lt_iff₀` 背后的经典构造）**实际使用了
`Classical.choice`**。这正是"绝对严格"与教科书隐式假设的差异所在：
Lean 如实揭露了证明实际依赖的公理，哪怕教科书层面它"看起来"是构造性的。
这也是为什么本库每个条目都登记 `axioms` 字段——严格性不靠信任，靠检查。

# 应用与陷阱

**应用**：
- 确界原理、柯西列的构造、取整（floor/ceiling）存在性都以阿基米德性质为支撑。
- "存在 n 使得 1/n < ε"（收敛定义的基石）是它的直接推论。
- 后续条目 `analysis.completeness.monotone-convergence` 会复用它。

**陷阱**：
- **记法陷阱**：`n * x` 中 n 是 `ℕ`，Lean 自动插值 `↑n`。写证明时若忘记升格，
  类型检查会报"期望 ℝ"。这是初学者最常见的错误。
- **方向陷阱**：`div_lt_iff₀` 前提是 `0 < c`；若 c < 0，不等号要反向。
  不要把"乘正数保序"错用在负数上。
- **思维陷阱**：以为阿基米德性质只在"y > 0"时需要证明。事实上它对任意 y 都成立，
  不需要分段——这是"武器适用范围比直觉假设更宽"的经典例子。
