---
id: settheory.function.image-preimage.preimage-inter
family: settheory.function.image-preimage
variant: ecnu
kind: theorem
state: verified
title: 原像保交
summary: f⁻¹[B ∩ C] = f⁻¹[B] ∩ f⁻¹[C]
premises: [settheory.set.ext]
mathlib: [Set.preimage_inter]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第一章（预备知识）"
---

# 动机

与"原像保并"配套：原像对集合运算**全通**。要证"原像保交"，步骤结构与保并完全平行——
只是把"或"换成"且"。把它单独列出来，是因为它与"像保交失败"形成对照：
原像是分析的工具，像不是，这条对照值得刻在脑子里。

# 直觉

`x ∈ f⁻¹[B ∩ C]` 意思是 `f x` 同时落在 B 和 C 里。
"同时"是逐点的，搬回原像就是"x 同时在 f⁻¹[B] 和 f⁻¹[C] 里"。

# 陈述（自然语言）

f⁻¹[B ∩ C] = f⁻¹[B] ∩ f⁻¹[C]。

# 陈述（Lean 对照）

```lean
theorem preimage_inter {α β : Type*} (f : α → β) (B C : Set β) :
    f ⁻¹' (B ∩ C) = f ⁻¹' B ∩ f ⁻¹' C
```

| 人话 | Lean |
|---|---|
| 原像 | `f ⁻¹' B` |
| 交 | `B ∩ C`（逐点"且"） |

# 思维脉络（thinking trace）

1. **目标**：集合等式 → `ext x` 降到逐元素。
2. **读原像**：`x ∈ f ⁻¹' S` ⟺ `f x ∈ S`。
3. **两边展开**：`f x ∈ B ∩ C` ⟺ `f x ∈ B ∧ f x ∈ C`，而右边正是 `x ∈ f⁻¹[B] ∧ x ∈ f⁻¹[C]`。
4. **结构**：与 preimage-union 一字之差——`Or` 换成 `And`。证明的骨架完全复用。
   （在 Lean 里两个方向的 `rintro`/`exact` 几乎是在"原样搬运"合取的两个分量。）

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 从"属于交"拆出两半 | `rintro ⟨hfB, hfC⟩` |
| 组装"属于交" | `exact ⟨hfB, hfC⟩` |

# 依赖（人话版）

- `settheory.set.ext`：外延性。

# 应用与陷阱

**应用**：
- 连续性证明里"开集族交"的论证；函数空间、点集拓扑中处处使用。
- 与 preimage-union、preimage-complement 合起来 = "原像是集合运算的同态"，
  这是拓扑/测度论定义"好函数"（连续/可测）的全部支撑。

**陷阱**：
- **与像对比**：`f⁻¹[B ∩ C] = f⁻¹[B] ∩ f⁻¹[C]` 恒真；但 `f[B ∩ C] = f[B] ∩ f[C]`
  只在 f 单射时成立（一般只有 `f[B∩C] ⊆ f[B]∩f[C]`）。这不对称是初学者最常翻车的地方。
- **方向陷阱**：证明"属于交"时两个方向都要求**同时**给出两个分量，缺一个都不行。
