---
id: functional-analysis.bidual.reflexive
kind: theorem
state: verified
title: 典范双对偶嵌入与自反性
premises: [functional-analysis.hahn-banach.norming-functional, functional-analysis.subspace.annihilator-closure]
mathlib: [NormedSpace.inclusionInDoubleDual, NormedSpace.inclusionInDoubleDualLi, NormedSpace.dual_def]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

一个向量可以由所有连续线性泛函在它上的取值来识别。因此 `x` 自然地决定一个作用在
连续对偶上的泛函 `f ↦ f x`。自反性问的是：双对偶中是否还有不来自原空间向量的元素。

# 教材定义与正式承载

Mathlib 的 `NormedSpace.inclusionInDoubleDual ℝ E` 是连续线性映射
`E →L E**`，它在 `x` 上的值是求值泛函 `f ↦ f x`。
`NormedSpace.inclusionInDoubleDualLi` 是同一张图的线性等距打包。本条直接把
`Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)` 作为“`E` 自反”的正式表达，不另建本地
谓词。Mathlib 中无命名空间里的 `Module.IsReflexive` 指全部代数对偶上的双对偶满射，不是这里
Banach 空间的连续自反性，因而不挂靠该 class。

# 陈述（自然语言）

典范双对偶嵌入在 `f` 上的取值为 `f(x)`，并且保持范数，因此总是单射。它满射当且仅当每个
连续双对偶元都能写成在某个向量上的求值；此时表示向量由单射性唯一确定。

# 陈述（Lean 对照）

求值展开、范数保持、单射性、自反性量词展开和唯一表示分别对应 `bidual_evaluation`、
`norm_bidual_evaluation`、`bidual_evaluation_injective`、
`reflexive_iff_every_bidual_is_evaluation` 与 `existsUnique_bidual_evaluation`。

# 思维脉络

求值公式是典范嵌入的定义展开。Hahn–Banach 产生的范数化泛函表明这张图保持范数，所以不同
向量不会有相同的双对偶像。满射性展开后，“每个双对偶元来自求值”就是它的元素化陈述；
表示的唯一性则由典范嵌入的单射性给出。

# 自然语言 ↔ Lean 映射

- 连续对偶：`StrongDual ℝ E`。
- 连续双对偶：`StrongDual ℝ (StrongDual ℝ E)`。
- 典范嵌入：`NormedSpace.inclusionInDoubleDual ℝ E`。
- 典范等距嵌入：`NormedSpace.inclusionInDoubleDualLi ℝ`。
- 自反性：上述典范嵌入的 `Function.Surjective`。

# 依赖

范数保持的 Mathlib 证明使用 Hahn–Banach 范数化泛函。上一条的零化子语言解释了为什么连续对偶能
分离原空间的点。后续可分性条目会比较原空间与对偶的可分性。

# 应用与边界

本条只冻结范数双对偶和自反性的定义层。“自反 Banach 空间的闭单位球弱紧”及其逆向需要弱拓扑、
弱星拓扑和 Banach–Alaoglu，属于尚锁定的 F4，不在本窗借 Mathlib 强定理提前完成。本条也不声称
一般 Banach 空间都自反；典型反例和 `L¹`／`L∞` 边界留给具体空间条目。
