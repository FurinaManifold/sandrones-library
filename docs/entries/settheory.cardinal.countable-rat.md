---
id: settheory.cardinal.countable-rat
family: settheory.cardinal
variant: ecnu
kind: theorem
state: verified
title: 有理数可数
summary: 有理数集是可数的
premises: [settheory.cardinal.countable-def]
mathlib: [Countable ℚ]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第一章（预备知识）"
---

# 动机

有理数"看起来"比自然数稠密得多（任意两个有理数之间夹着无穷多个有理数），
但出人意料的是：**有理数可以数得过来**。这是 Cantor 的第一次"反直觉"：
稠密并不等于不可数。

这个事实在分析里是基石——有理数可数 + 有理数稠密，意味着实数可由可数多
个"有理浮标"逼近（回想确界、序列极限的构造）。它与"实数不可数"形成对照，
是 Cantor 理论第一次惊艳亮相。

# 直觉

分数 p/q 由**两个**自然数 (p, q) 决定。关键观察：**两个 ℕ 可以编进一个 ℕ**。
走"高度"路线：把所有分数按 |p| + q（分子分母的"个头"）分层，
第 0 层有限个，第 1 层有限个，…… 每层有限，层可数，合并起来仍然可数。

另一种看图方式：把 (p, q) 排成无穷矩阵，沿对角线扫描（(0,0),(1,0),(0,1),(2,0)...）
——对角线法是"给可数份可数材料编队"的标准做法。

# 陈述（自然语言）

有理数集是可数集：存在单射 ℚ → ℕ。

# 陈述（Lean 对照）

```lean
theorem countable_rat : Countable ℚ := by
  infer_instance
```

| 人话 | Lean |
|---|---|
| 有理数可数 | `Countable ℚ`（mathlib 已构造实例） |
| 自动拿到实例 | `infer_instance` |

# 思维脉络（thinking trace）

1. **问题的形状**：分数 = 两个整数的配对 + 约分（去重）。先把"两个自然数编码"
   解决掉，再处理符号约分。
2. **配对 ℕ×ℕ 可数**：Cantor 配对函数/对角线枚举。这是"可数×可数=可数"的种子，
   countable-union 的本质也是它。
3. **塞进 ℤ/ℚ**：分子分母允许负号，但 ℤ 也由两个 ℕ 生成，所以整体仍可数。
4. **形式化**：mathlib 已把这个构造做成 `Countable ℚ` 实例，`infer_instance` 一步到位。
   数学脑回路（分层/对角线）保留在叙述层——形式化层引高层结论，是合理的分工。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 可数性判据 | `countable_iff_injective_nat`（countable-def） |
| 自动实例 | `infer_instance` |

# 依赖（人话版）

- `settheory.cardinal.countable-def`：可数的判定刻画在思维上承托"构造单射"的说理。

# 公理依赖（#print axioms）

```
countable_rat 依赖: [propext, Classical.choice, Quot.sound]
```

**注意差异**：教科书讲"有理数可数"从不提选择公理——对角线/配对是显式构造。
但 mathlib 的 `Countable ℚ` 实例经由经典逻辑内部使用了 `Classical.choice`
（从"存在枚举"中实取一个枚举的环节）。形式化如实记录了教科书忽略的这一细节。

# 应用与陷阱

**应用**：
- 实数的可数稠密子集（有理数）：分析里用有理数近似实数。
- 级数理论：把可数多项按可数指标求和时，重组顺序有保证。
- 与实数不可数对照：确立"可数与不可数的分界线"。

**陷阱**：
- **思维陷阱**：稠密 ⟹ 不可数？错。有理数稠密但可数。可数性是"编号能力"，
  与稠密性无关。
- **思维陷阱**：可数×可数仍可数（对角线），但可数^可数（如 ℕ→ℕ 函数全体）就不可数。
  别把"配对"直觉过度推广。