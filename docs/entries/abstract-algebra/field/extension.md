---
id: abstract-algebra.field.extension
family: abstract-algebra.field
variant: textbook
kind: theorem
state: verified
title: 域扩张、生成中间域、代数元与最小多项式
summary: 显式域嵌入；子域和中间域集合；单扩张；代数元、超越元与最小多项式
premises: [abstract-algebra.ring.def, abstract-algebra.poly.factorization]
mathlib: [RingHom, Polynomial.eval₂, minpoly]
provenance:
  source_type: book
  ref: 本科抽象代数中的域扩张、代数元和最小多项式
---

# 动机

讨论一个域相对于另一个域的代数性质时，必须明确底域如何嵌入目标域。若把嵌入藏在全局实例
中，同一对域之间的不同嵌入便无法区分，子域、代数元和最小多项式的“相对于谁”也会变得模糊。
本条目因此从显式域嵌入出发，建立后续扩张次数、分裂域和 Galois 理论共同使用的教材语言层。

# 定义链

`FieldEmbedding K L` 由函数 `K → L`、本库 `RingHomomorphism` 谓词和单射性组成。
`SubfieldSet S` 表示 `S` 含零和一并对加、乘、负及非零逆元封闭；
`IntermediateFieldSet e S` 进一步要求 `S` 包含嵌入 `e` 的全部像。

由集合 `S` 生成的中间域定义为所有包含 `S` 的中间域集合之交。沿嵌入 `e` 的异系数求值
`evaluateOver e p a` 把 `K` 系数多项式在 `L` 中的 `a` 处求值。若某个非零多项式求值为零，
则 `a` 是代数元；否则为超越元。

`MinimalPolynomialOf e a p` 逐条写出最小多项式的教材泛性质：`p` 首一、在 `a` 处消失，且
整除每一个在 `a` 处消失的多项式。单扩张则表示某个元素生成的中间域就是整个目标域。

# 主要结果

- 恒等域嵌入与嵌入复合仍是域嵌入，域嵌入保持逆元。
- 全集及任意一族子域／中间域的交仍满足相应封闭性。
- 生成中间域包含生成集合和基域像，并满足最小性与单调性。
- `evaluateOver` 对常数、不定元、加法和乘法满足标准求值公式。
- 基域像中的每个元素都是代数元；超越性等价于每个非零多项式求值非零。
- 每个代数元都有唯一的最小多项式；该多项式非零且不可约。
- 单生成元属于其生成中间域，单扩张由生成中间域等于全集刻画。

# Lean 承载与桥接边界

| 教材概念 | 本库正式承载 | 证明后端 |
|---|---|---|
| 域嵌入 | `FieldEmbedding K L` | 私有 `RingHom` 桥 |
| 子域 | `SubfieldSet S` | 纯集合封闭性 |
| 中间域 | `IntermediateFieldSet e S` | 纯集合封闭性与值域包含 |
| 生成中间域 | `generatedIntermediateFieldSet e S` | 交集式泛性质 |
| 异系数求值 | `evaluateOver e p a` | `Polynomial.eval₂` |
| 代数／超越元 | `AlgebraicElement`、`TranscendentalElement` | 非零湮灭多项式 |
| 最小多项式关系 | `MinimalPolynomialOf e a p` | 私有局部 `Algebra` 与 `minpoly` 桥 |
| 单扩张 | `SimpleExtension e a` | 生成中间域等于全集 |

公开课程定理不量化 Mathlib `Algebra`、`IntermediateField` 或 `Module`。证明最小多项式存在和
不可约时，文件在私有桥中由显式 `FieldEmbedding` 局部构造 `Algebra`，证明其 `algebraMap`
确实等于给定嵌入，再调用 `minpoly`；该后端不会成为下游课程 API 的隐式前提。

# 证明思路

子域与中间域部分逐项把封闭律穿过任意交。生成中间域的包含性和最小性直接来自交集式定义，
单调性则由最小性与生成集合包含性组装。基域像代数性使用一次多项式 `X-C x`，并通过本条目
已证明的求值公式计算其值为零。

对代数元，私有桥把其非零湮灭多项式解释为局部 Mathlib 代数结构下的整性；Mathlib `minpoly`
随即给出首一、零化及整除泛性质。本库先证明任意两个满足 `MinimalPolynomialOf` 的多项式严格
相等，再用该唯一性识别 `minpoly`，从而得到不可约性。

# 边界与陷阱

- 域扩张依赖指定嵌入；只写“`L/K`”而不固定嵌入，在形式化中是不充分的。
- `SubfieldSet` 不自动包含基域像；相对扩张的中间域必须使用 `IntermediateFieldSet e`。
- 生成中间域对非零逆元封闭，不等同于只由环运算生成的子环。
- 超越元没有经典意义下的最小多项式；本库的存在定理显式要求 `AlgebraicElement e a`。
- A3.5 不讨论扩张次数、塔式公式、分裂域或可分性，这些分别属于后续条目。
