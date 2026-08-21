---
id: analysis.real.inf
family: analysis.real
variant: ecnu
kind: theorem
state: verified
title: 下确界原理
summary: 非空有下界集的下确界存在且是所有下界中最大的
premises: [analysis.real.bounded-sets.bdd-below]
mathlib: [sInf, IsGLB, isGLB_csInf]
provenance:
  source_type: book
  ref: 华东师大《数学分析》第五版 第一卷 第二章（数列极限·预备）
---

# analysis.real.inf

- **家族**: `analysis.real`
- **变体**: ecnu（华东师大《数学分析》第五版）
- **状态**: verified
- **一句话**: 非空且有下界的集合，其下确界存在，且是所有下界里最大的。

## 动机（为什么要这条）

确界原理（`analysis.real.sup`）讲"非空有上界 ⇒ 有上确界"。
但数学里镜像方向一样常用：刻划"序列几乎不会跌破多少"，或"取最小"时用下确界。
教材作为确界原理的推论一句带过，这里显式落一条，好让后续证明直接调用。

## 直觉

- 上确界 = "被压住时的天花板"：集合顶不到但它之上的都是上界里最小的。
- 下确界 = "被托住时的地板"：集合踩在它上面，任何比它高的"地板"都不再是下界。
- 把 `sup` 的图景上下翻转，就是 `inf`。没有新想法，只有新方向。

## 自然语言 ↔ Lean 映射

| 中文 | Lean |
|---|---|
| 下确界 = 下界且 ≥ 一切下界 | `IsGLB s (sInf s)` |
| 把确界原理倒过来（下界+非空） | `isGLB_csInf hne hbdd` |

## 思维脉络

1. 教科书"确界原理"说的其实是一件事：条件完备格提供 `sInf`（下确界算子），
   且保证它是下界、是最大下界——这由 `isGLB_csInf` 一句确认。
2. 证明和 `sup_lub` 完全对称：换掉"上"变"下"，`IsLUB` 变 `IsGLB`，其余原样。
3. 一个提醒：`sInf` 对"空集/无下界"也有定义（拿 0 之类兜底），
   但性质定理只在非空 + 有下界时保证"真下确界"，条件不能省。
   （这是一年级最容易丢条件的地方。）

## 依赖

- `analysis.real.bounded-sets.bdd-below`

## 应用与陷阱

- 完整表述三要素缺一不可：`s.Nonempty`（非空）+ `BddBelow s`（有下界）→ `IsGLB s (sInf s)`。
- 常用的等价写法：`sInf s ≤ x ⟺ ∀ y, y 是下界 → y ≤ x`，在证明"下确界是某个值"时更顺手。

## 形式化层

```lean
theorem inf_glb (s : Set ℝ) (hne : s.Nonempty) (hbdd : BddBelow s) : IsGLB s (sInf s) := by
  exact isGLB_csInf hne hbdd
```

**公理依赖（#print axioms）**

```
inf_glb 依赖: [propext, Classical.choice, Quot.sound]
```

**结构必需（无法削减）**：
1. 类型含 `ℝ` 序结构（`≤`），ℝ 序实例定义体经典构造（Playbook §3.3）；且
2. 条件完备格的"下确界存在"构造本质经典（与 `sSup` 同源）。

## mathlib 参考

- `sInf`, `IsGLB`, `isGLB_csInf`