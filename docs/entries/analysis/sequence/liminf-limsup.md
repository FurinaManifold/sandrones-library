---
id: analysis.sequence.liminf-limsup
family: analysis.sequence
variant: ecnu
kind: theorem
state: verified
title: 上极限与下极限
summary: liminf ≤ limsup；liminf = limsup ⟺ 序列收敛
premises: [analysis.sequence.bounded]
mathlib: [Filter.liminf_le_limsup, tendsto_of_liminf_eq_limsup]
provenance:
  source_type: book
  ref: 华东师大《数学分析》第五版 第一卷 第二章 §1-§3 数列极限
---

# analysis.sequence.liminf-limsup

- **家族**: `analysis.sequence`
- **变体**: ecnu（华东师大《数学分析》第五版）
- **状态**: verified
- **一句话**: 有界序列有 liminf ≤ limsup；两者相等 ⟺ 序列收敛到公共值。
- **Lean 名**: `liminf_le_limsup_seq`、`tendsto_of_liminf_eq_limsup_seq`

## 动机（为什么要这条）

不收敛的序列（如 (−1)ⁿ）也能谈"最终的上/下起伏范围"——上极限是最高的
聚积上限、下极限是最低的聚积下限。NaN 兼两个工具：
1. 给出**不收敛时的量化描述**（范围有多大、在两个边界处如何振荡）；
2. 把"收敛"诊断压缩成一条等式 `liminf = limsup`。

## 直觉

- **limsup** = "任何尾巴都跳不过去的最矮天花板"：它不理会开头，只盯死后续 sup 的下确界。
- **liminf** = "任何尾巴都跌不破的最高地板"：盯死后续 inf 的上确界。
- 天花板从不可能低过地板（liminf ≤ limsup）；两者重合为 a ⟺ 天花板地板都塌缩到 a ⟺ 全队最终只在 a 附近。

## 自然语言 ↔ Lean 映射

| 中文 | Lean |
|---|---|
| 序列的（滤子上）上/下极限 | `limsup u atTop` / `liminf u atTop` |
| 上/下两向的滤子有界 | `IsBoundedUnder (·≤·) atTop u` / `(·≥·)` |
| liminf ≤ limsup | `Filter.liminf_le_limsup` |
| 两极限相等 ⟹ 收敛 | `tendsto_of_liminf_eq_limsup` |

> 口径注：教科书把 limsup 定义为"后部上确界的极限"（suxp of tails），
> mathlib 的 `limsup u f` 直接是 `sInf (range (fun N => sSup (u 从 N 起的尾部)))`——等价，且不用先证尾部收敛。

## 思维脉络

1. `liminf_le_limsup_seq`：直接应用滤子版本的 `Filter.liminf_le_limsup`，
   把"有界"喂成它需要的两个 `IsBoundedUnder`（上/下向）。
2. `tendsto_of_liminf_eq_limsup_seq`：把 `liminf = a ∧ limsup = a` 交给
   `tendsto_of_liminf_eq_limsup`，再由 ordertopology 给出 `Tendsto u atTop (𝓝 a)`。
   这个定理本质上是序语言的完备：天花板地板收口 = 收敛。

## 依赖

- `analysis.sequence.bounded`（口径：两向滤子有界）。

## 应用与陷阱

- 陷阱：limsup/liminf **不需要序列收敛才存在**——有界就存在（这是它比普通极限好用之处）。
- 陷阱：两个方向都有限才算有界：只给一个方向的界，liminf/limsup 可能跑到 ±∞。
- 用途：证明收敛时，先证"liminf ≥ a 且 limsup ≤ a"，再利用 liminf ≤ limsup 夹出两等；
  或反过来用"收敛 ⟹ liminf = limsup = 极限"做终止性判据。
- 对偶：limsup u = −liminf (−u)（本批不展开，RF 详尽视需要再补）。

## 形式化层

```lean
theorem liminf_le_limsup_seq {u : ℕ → ℝ}
    (hU : IsBoundedUnder (· ≤ ·) atTop u) (hL : IsBoundedUnder (· ≥ ·) atTop u) :
    liminf u atTop ≤ limsup u atTop := by
  exact Filter.liminf_le_limsup (f := atTop) (u := u) hU hL

theorem tendsto_of_liminf_eq_limsup_seq {u : ℕ → ℝ} {a : ℝ}
    (hU : IsBoundedUnder (· ≤ ·) atTop u) (hL : IsBoundedUnder (· ≥ ·) atTop u)
    (hinf : liminf u atTop = a) (hsup : limsup u atTop = a) :
    Tendsto u atTop (𝓝 a) := by
  exact tendsto_of_liminf_eq_limsup (f := atTop) (u := u) (a := a) hinf hsup hU hL
```

**公理依赖（#print axioms）**

```
liminf_le_limsup_seq / tendsto_of_liminf_eq_limsup_seq 依赖: [propext, Classical.choice, Quot.sound]
```

**结构必需（无法削减）**：类型含 ℝ 的拓扑/序实例（§3.3），choice 来自实例实现路径。

## mathlib 参考

- `Filter.liminf_le_limsup`（有界序列 liminf ≤ limsup）
- `tendsto_of_liminf_eq_limsup`（liminf = limsup ⟹ 收敛，序拓扑）