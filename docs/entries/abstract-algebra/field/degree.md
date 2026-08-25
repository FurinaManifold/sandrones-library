---
id: abstract-algebra.field.degree
family: abstract-algebra.field
variant: textbook
kind: theorem
state: verified
title: 域扩张次数、有限扩张与塔式公式
summary: 显式有限线性组合和域基；扩张次数的唯一性与正性；有限扩张必代数；塔式公式
premises: [abstract-algebra.field.extension]
mathlib: [LinearIndependent, Module.Basis, Module.finrank, Module.Basis.smulTower]
provenance:
  source_type: book
  ref: 本科抽象代数中的域扩张次数、有限扩张与塔式公式
---

# 动机

域扩张的次数是目标域作为基域向量空间的维数。A3.5 已把基域嵌入写成显式
`FieldEmbedding K L`；本条目继续沿用这一选择，直接用有限和表达标量组合，避免让全局
`Algebra` 实例静默决定底域作用。

# 教材定义

相对于嵌入 `e : FieldEmbedding K L`，系数 `cᵢ : K` 对向量 `vᵢ : L` 的有限线性组合定义为

```text
∑ i ∈ s, e(cᵢ) * vᵢ.
```

若所有有限零关系的系数都为零，则向量族线性无关；若每个 `L` 中元素都是某个有限线性组合，
则该族张成 `L`。同时满足二者便是 `FieldBasis e v`。当指标为 `Fin n` 时，
`HasExtensionDegree e n` 表示存在一组含 `n` 个向量的有限域基。

`FiniteFieldExtension e` 表示存在某个自然数次数；`AlgebraicExtension e` 表示目标域每个元素均
满足 A3.5 的 `AlgebraicElement e`。

# 主要结果

- `Fin n` 基与一般有限支撑基定义等价，并且每个元素存在唯一坐标。
- 同一显式扩张的任意两组有限基长度相同，因此扩张次数唯一。
- 域扩张不存在零次基，任何存在的次数严格为正。
- 恒等扩张以 `1` 为一元基，其次数恰为一。
- 有限域扩张必为代数扩张。
- 若 `[L:K]=m`、`[M:L]=n`，则乘积族 `f(bᵢ)cⱼ` 是 `M/K` 的基；重编号后得到
  `[M:K]=mn`，从而两层有限扩张的复合仍有限。

# Lean 承载与私有桥

| 教材对象 | 公开承载 | 私有验证后端 |
|---|---|---|
| 有限线性组合 | `fieldLinearCombination` | 局部标量和 |
| 线性无关 | `FieldLinearlyIndependent` | Mathlib `LinearIndependent` |
| 张成 | `FieldSpans` | `Submodule.span` |
| 域基 | `FieldBasis`、`FinFieldBasis` | `Module.Basis` |
| 次数关系 | `HasExtensionDegree e n` | `Module.finrank` |
| 塔乘积基 | `towerBasisFamily` | `Module.Basis.smulTower` |

公开声明只量化域、显式 `FieldEmbedding`、普通函数、有限集和自然数，不出现 `Algebra`、
`Module`、`Submodule`、Mathlib `LinearIndependent` 或 `Basis`。证明内部由 `e.toRingHom.toAlgebra`
局部构造标量结构，并首先验证其 `algebraMap` 等于给定嵌入。这样 Mathlib 只验证教材定义的正确
实现，不改变公开语义。

# 证明结构

线性无关桥使用有限关系刻画，张成桥使用真正的有限支撑组合刻画；二者组装成 Mathlib 基，再以
有限基数与 `finrank` 比较两组基长度。零维排除直接观察空和只能为零，无法表示域中的一。

有限扩张给出有限基，从而在私有后端得到有限维实例；有限维代数上的元素均代数，再把其非零
湮灭多项式沿显式求值桥返回 A3.5 定义。

塔式公式不是只包装维数乘法等式：先由两层基构造显式乘积族 `f(bᵢ)cⱼ`，以
`Basis.smulTower` 验证它是复合扩张的基，再用 `finProdFinEquiv` 把 `Fin m × Fin n` 重编号为
`Fin (m*n)`。

# 边界与陷阱

- 扩张次数相对于具体嵌入 `e`；不能只由两个域类型确定。
- 无限扩张没有被强制编码为自然数零；`HasExtensionDegree` 是有限次数关系。
- `Fin 0` 不能张成非平凡域，因此任何有限扩张次数至少为一。
- 一般指标族的张成必须量化有限支撑，不能写成未经定义的无限和。
- A3.7 分裂域窗口仍由 Main 冻结，本条目不提前引入分裂、正规、可分或 Galois 概念。
