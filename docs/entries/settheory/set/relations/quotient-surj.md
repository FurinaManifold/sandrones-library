---
id: settheory.set.relations.quotient-surj
family: settheory.set.relations
variant: ecnu
kind: theorem
state: verified
title: 商映射满射
summary: 商映射 x ↦ ⟦x⟧ 是满射
premises: []
mathlib: [Quotient.mk_surjective]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第一章（预备知识）"
---

# 动机

建立商集后，商映射 `π : x ↦ ⟦x⟧` 是最基本的对象。要理解商集"长得像什么"，
第一个问题是：商集里有没有"凭空冒出来"的元素？

商映射**满射**保证没有：商集里**每个元素都来自原集合的某个代表元**。
这保证了"商集不会比原集合更大"（在覆盖意义上），也为"任何商集上的函数
都可以还原为原集合上的函数"铺平道路（`Quotient.lift` 的可用性）。

# 直觉

商映射把每个原元素送到它所在的等价类。因为每个等价类里**至少有一个元素**
（至少它自己），所以每个商点 `⟦x⟧` 都有"原型" x。商集只是"合并"，不"凭空创造"。

# 陈述（自然语言）

对等价关系 ≈，映射 x ↦ ⟦x⟧ 是满射：每个商元素都等于某个原元素的商值。

# 陈述（Lean 对照）

```lean
theorem quotient_surjective {α : Type*} (s : Setoid α) :
    Function.Surjective (Quotient.mk s)
```

| 人话 | Lean |
|---|---|
| 商映射 | `Quotient.mk s` |
| 满射 | `Function.Surjective`（∀ q, ∃ x, 值 = q） |

# 思维脉络（thinking trace）

1. **展开满射**：`∀ q : Quotient s, ∃ x : α, ⟦x⟧ = q`。固定任意商元素 q。
2. **商类型的归纳原理**：商类型的每个元素 q 都是"某个 x 的 ⟦x⟧"
   （`Quotient.inductionOn`）。这不是额外假设，而是商类型定义的一部分。
3. **结论**：那个 x 就是我们要找的代表元。所以商映射满射。
4. **证明为 `exact Quotient.mk_surjective`**：mathlib 已把它打包。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 商集每个元素有代表元 | `Quotient.inductionOn` / `Quotient.mk_surjective` |
| 从商值回到代表元 | `Quotient.exists_rep`（∀ q, ∃ x, ⟦x⟧ = q） |

# 依赖（人话版）

无库内依赖。

# 应用与陷阱

**应用**：
- 在商集上定义函数（`Quotient.lift`）：先在原集合上定义，再验证"等价类内值不变"。
- 实数构造：商出来的实数是"满的"——每个实数都有柯西序列代表。
- 商空间的维数论证（抽象代数/线性代数阶段）。

**陷阱**：
- **思维陷阱**：满射不代表单射。商映射把等价类压成一点，一般不是单射（除非 ≈ 是恒等）。
- **应用陷阱**：要在商集上定义函数，满射性是"每个点都能溯源"的保证，但还要
  `Quotient.lift` 的相容性检查（等价元素要映到相同值），两个缺一不可。
