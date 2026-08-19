---
id: settheory.function.inject-surject.bijective-iff-inverse
family: settheory.function.inject-surject
variant: ecnu
kind: theorem
state: verified
title: 双射 ⟺ 有逆映射
summary: f 双射恰有 g:左逆∧右逆
premises: []
mathlib: [Function.bijective_iff_has_inverse]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第一章（预备知识）"
---

# 动机

"双射 = 一一对应 = 可逆"是函数论的核心直觉：正是可逆函数允许我们"解方程"或因变量反求自变量。
这一条把双射的两个分量（单射、满射）拧成一个等价的整体刻画——双射 ⟺ 有（左右同时回收的）逆。

# 直觉

- 单射：`f a₁ = f a₂` 必推出 `a₁ = a₂`（不碰撞），保证**每个象有唯一原象**。
- 满射：每个目标元素都有原象（无遗漏），保证**所有元素都能被回溯**。
- 两者一起：每个 b ∈ β 都恰有一个"源头" `g(b)`，`g` 就是反方向走，左逆右逆同时成立。

# 陈述（自然语言）

函数 f : α → β 是双射，当且仅当存在 g : β → α 使得 g∘f = id 且 f∘g = id。

# 陈述（Lean 对照）

```lean
theorem bijective_iff_inverse {α β : Type*} (f : α → β) :
    Function.Bijective f ↔
      ∃ g : β → α, Function.LeftInverse g f ∧ Function.RightInverse g f
```

| 人话 | Lean |
|---|---|
| 双射 | `Function.Bijective f`（= 单射 ∧ 满射） |
| 左逆（g∘f=id） | `Function.LeftInverse g f` |
| 右逆（f∘g=id） | `Function.RightInverse g f` |

# 思维脉络（thinking trace）

1. **⇒（双射 ⟹ 有逆）**：对每个 b ∈ β，满射性给出原象；单射性保证唯一。定义
   `g b := 那个唯一的原象`，构造出的 g 左逆右逆同时成立。
2. **⇐（有逆 ⟹ 双射）**：左逆给单射（`f a₁=f a₂` 两边作用 g），右逆给满射
   （给定任何 b，a := g b 就是 f 的原象）。
3. **本质**：左右逆同时存在 = 反向走法不冲突（左逆保证"返回不分裂"，
   右逆保证"覆盖不回空"）。
4. **形式化**：`Function.bijective_iff_has_inverse` 是 mathlib 打包好的完整对应
   （含唯一性论证），直接 `exact`。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 双射等价于可逆 | `Function.bijective_iff_has_inverse` |
| 反函数 | 逆 g，即 `f⁻¹`（在 Lean 里多用 `Function.InvFun` 记号） |

# 依赖（人话版）

无库内依赖。

# 公理依赖（#print axioms）

```
bijective_iff_inverse 依赖: [Classical.choice]
```

构造性的"有逆⟹单射满射"是纯逻辑；但"双射⟹有逆"要**从存在性中选出**逆映射
（满射给每个 b 一个原象），这一步经 `Function.bijective_iff_has_inverse`
的证明实际调用了 `Classical.choice`。教科书版本"构造 g(b) := f⁻¹(b)"
看似显式，其实依赖"对每个 b 唯一存在一个原象"——形式化把这份选择显式化了。

# 应用与陷阱

**应用**：
- 反函数存在性判据（分析里严格递增连续函数）。
- 可数性论证（双射 ℤ↔ℕ、ℚ×ℚ↔ℕ）的统一语言。
- 线性代数里"维数相同⇔有线性同构"的思想原型。

**陷阱**：
- **单有左逆不算双射**：只单射 ⇒ 左逆存在但无右逆（目标有遗漏）。只满射 ⇒ 右逆（需选择公理）但左逆未必。
- **左右的顺序**：`LeftInverse g f` 是 `g ∘ f = id`（先 f 后 g）。写反了含义完全不同。
- 分析后续常用**严格单调 + 连续 ⇒ 双射**的合成判据，勿把"双射 ⟺ 可逆"与连续性混谈。