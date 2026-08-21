---
id: analysis.sequence.monotone-convergence
family: analysis.sequence
variant: ecnu
kind: theorem
state: verified
title: 单调有界收敛定理
summary: 单调递增且值域有上界的序列收敛到其值域的上确界
premises: [analysis.real.sup]
mathlib: [tendsto_atTop_ciSup, Real.isLUB_sSup]
provenance:
  source_type: book
  ref: 华东师大《数学分析》第五版 第一卷 第二章 §3 数列极限存在的条件（定理 2.9）
---

# analysis.sequence.monotone-convergence

- **家族**: `analysis.sequence`
- **变体**: ecnu（华东师大《数学分析》第五版）
- **状态**: verified
- **一句话**: 单调递增 + 有上界 ⇒ 收敛，且极限就是上确界。

## 动机（为什么要这条）

这是第一个"存在性"定理：不靠猜出极限，而靠"单调 + 有界"就断定收敛。
它是证明"某序列收敛但极限值未知"的通用手段，
也是后继证明中柯西准则、e 的定义、级数收敛判据的地基。

## 直觉

- 序列"不回头的上升"（单调递增）又"被天花板挡着"（有上界）。
  天花板（上确界 sSup）处一定越来越挤——否则可以再往上。
- 极限 = sSup（值域的上确界），不是猜出来的，是**确界原理**保证存在的。
- 关键接力：**确界原理（第二章）→ 此处（第三章）**。在 ℚ 里这条定理
  会失败（如 1, 1.4, 1.41, … 无上确界极限），完备性的第一战。

## 自然语言 ↔ Lean 映射

| 中文 | Lean |
|---|---|
| 单调递增 | `Monotone u` |
| 值域有上界 | `BddAbove (Set.range u)` |
| 收敛到上确界 | `Tendsto u atTop (𝓝 (sSup (Set.range u)))` |
| 上确界即最小上界 | `IsLUB (Set.range u) (sSup (Set.range u))` |

## 思维脉络

1. 有上界 → `sSup` 存在（`Real.isLUB_sSup`，即确界原理的实战化）。
2. mathlib 的 `tendsto_atTop_ciSup` 给"单调 + 有上界 ⇒ 收敛到 ⨆ u"。
3. `⨆ i, u i`（索引上确界）与 `sSup (Set.range u)`（值域上确界）是同一个数
   （`IsLUB.ciSup_eq` 桥接），于是定理干脆直接写成收敛到 `sSup`。
4. 同时把 `IsLUB` 也一并给出——"极限 = 上确界"这个更强结论一起封装。

## 依赖

- `analysis.real.sup`（确界原理：非空有上界集有上确界）。

## 应用与陷阱

- 两个条件缺一不可：单调不保证收敛（若上界不存在则发散到 +∞）；
  有上界不保证收敛（如 (−1)ⁿ 有界但不单调）。
- 单调递减 + 有下界的镜像结论由"取负"得到（华东师大定理 2.10）。
- 使用套路：先证单调（比较相邻项）+ 证有界 → 立刻得收敛，极限名即 sSup。

## 形式化层

```lean
theorem monotone_convergence {u : ℕ → ℝ} (hu : Monotone u)
    (hb : BddAbove (Set.range u)) :
    Tendsto u atTop (𝓝 (sSup (Set.range u))) ∧ IsLUB (Set.range u) (sSup (Set.range u)) := by
  constructor
  · rw [← (Real.isLUB_sSup (Set.range_nonempty u) hb).ciSup_eq]
    exact tendsto_atTop_ciSup hu hb
  · exact Real.isLUB_sSup (Set.range_nonempty u) hb
```

**公理依赖（#print axioms）**

```
monotone_convergence 依赖: [propext, Classical.choice, Quot.sound]
```

**结构必需（无法削减）**：
1. ℝ 的拓扑/序实例（§3.3）；
2. 单调收敛本身依赖确界原理的构造性实现（`sSup` 走条件完备格的经典选择，
   与 `analysis.real.sup` 同源）。

## mathlib 参考

- `tendsto_atTop_ciSup`（单调+有上界 ⇒ 收敛到索引上确界），
  `Real.isLUB_sSup`, `IsLUB.ciSup_eq`