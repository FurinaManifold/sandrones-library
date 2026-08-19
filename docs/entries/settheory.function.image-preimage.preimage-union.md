---
id: settheory.function.image-preimage.preimage-union
family: settheory.function.image-preimage
variant: ecnu
kind: theorem
state: verified
title: 原像保并
summary: f⁻¹[B ∪ C] = f⁻¹[B] ∪ f⁻¹[C]
premises: [settheory.set.ext]
mathlib: [Set.preimage_union]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第一章（预备知识）"
---

# 动机

从分析的第一天起，你就在用原像 `f⁻¹`：`f⁻¹[开集]` 是不是开集、`f⁻¹[[a,b]]` 表示什么、
连续性用"开集的原像是开集"来刻画……

原像这么好用，是因为它**对集合运算"全通"**：把并、交、补的原像一一对应回原像的并、交、补。
这一条证明的就是并的情形。相比之下，**像 `f[-]` 只保并不保交**——这正是原像在拓扑与测度论里
地位更高的原因。

# 直觉

`x ∈ f⁻¹[B ∪ C]` 意思是 `f x` 落在 B 或 C 里。
"或"是逐点的，所以可以原样搬回"x 在 f⁻¹[B] 或 f⁻¹[C] 里"。
本质上这是一句套了层"f x"外套的逻辑恒等式。

# 陈述（自然语言）

f⁻¹[B ∪ C] = f⁻¹[B] ∪ f⁻¹[C]。

# 陈述（Lean 对照）

```lean
theorem preimage_union {α β : Type*} (f : α → β) (B C : Set β) :
    f ⁻¹' (B ∪ C) = f ⁻¹' B ∪ f ⁻¹' C
```

| 人话 | Lean |
|---|---|
| 原像 | `f ⁻¹' B`（读作"f 逆映射下的原像"） |
| x 在原像里 | `x ∈ f ⁻¹' B`，等价于 `f x ∈ B` |

# 思维脉络（thinking trace）

1. **集合等式** → 外延性 `ext x`（settheory.set.ext），降到逐元素。
2. **读原像**：`x ∈ f ⁻¹' S` 就是 `f x ∈ S`（`Set.mem_preimage`）。
   所以两个方向都只是"f x 属于 B 还是 C"的搬运。
3. **⇒ 方向**：`f x ∈ B ∪ C`，分两支：`f x ∈ B`（原像并的左支）或 `f x ∈ C`（右支）。
4. **⇐ 方向**：任一支 `f x ∈ B` 或 `f x ∈ C`，都并进 `f x ∈ B ∪ C`。
5. **为什么这么平凡**：∪ 的定义是逐点的逻辑或；原像只是把点的"位置"从 β 换到 α。
   集合运算和原像都逐点发生，于是等式在每一点都只是同一句逻辑。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| x 在原像中 | `Set.mem_preimage : x ∈ f ⁻¹' s ↔ f x ∈ s` |
| 属于并，分两支 | `rcases h with hB | hC` |
| 构造并的一支 | `Or.inl` / `Or.inr` |

# 依赖（人话版）

- `settheory.set.ext`：外延性——集合等式的统一入口。

# 应用与陷阱

**应用**：
- 连续性的开集刻画（第五章）：`f` 连续 ⟺ 开集的原像是开集，依赖"原像保并、保交、保补"全部成立。
- 测度论中可测函数的定义同样用原像的"全通"性质。

**陷阱**：
- **像与原像的区别（最重要）**：`f⁻¹[B ∪ C] = f⁻¹[B] ∪ f⁻¹[C]` 对**原像**成立；
  但 `f[B ∩ C] = f[B] ∩ f[C]` 对**像一般不成立**（f 不单射时左右可能不等）。
  原像是"保并保交保补"的，像是"只保并不保交"的。
- **记号陷阱**：`f⁻¹` 不是指逆函数（逆函数要 f 是双射）。`f⁻¹[B]` 即使 f 不单射不满射也有意义。
