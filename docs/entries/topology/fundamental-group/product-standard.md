---
id: topology.fundamental-group.product-standard
family: topology.fundamental-group
variant: based-binary-product
kind: theorem
state: staging
title: 积空间的基本群
summary: 在指定积基点处由积道路和两个坐标投影构造基本群乘法等价，并给出正反方向的道路商公式
premises: [topology.fundamental-group.operations-standard]
mathlib: [FundamentalGroupoidFunctor.prodIso, Path.Homotopic.prod, Path.Homotopic.projLeft, Path.Homotopic.projRight]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

空间 `X × Y` 中以 `(x,y)` 为基点的环路，逐点就是一条 `X` 中以 `x` 为基点的环路和一条 `Y`
中以 `y` 为基点的环路。端点固定同伦也逐坐标分解，因此预期
`π₁(X × Y,(x,y)) ≅ π₁(X,x) × π₁(Y,y)`。本条目把这个坐标分解落实到道路同伦商和群运算，而不只
给出一个抽象存在的群同构。

# 直觉

正向映射把两个环路在每个参数时刻配成一对，形成积空间环路。反向映射分别取第一、第二坐标。
投影积道路立即恢复两个因子；反过来，把任意积空间道路的两个投影重新配对，也恢复原道路。道路
拼接逐坐标进行，所以这对互逆映射保持基本群乘法。

# 陈述（自然语言）

对任意拓扑空间 `X,Y` 和指定基点 `x,y`，两个坐标投影诱导同态
`π₁(X×Y,(x,y)) → π₁(X,x)×π₁(Y,y)`。基本群胚的积比较同构在该基点给出反向乘法等价。它把
`(g,h)` 送到积道路类 `prod g h`，投影同态把 `k` 送到 `(projLeft k, projRight k)`；这两个方向的
复合分别是恒等同态。

# 陈述（Lean 对照）

```lean
noncomputable def fundamentalGroupProdProjections (x : X) (y : Y) :
    FundamentalGroup (X × Y) (x, y) →* FundamentalGroup X x × FundamentalGroup Y y

noncomputable def fundamentalGroupProdMulEquiv (x : X) (y : Y) :
    FundamentalGroup X x × FundamentalGroup Y y ≃* FundamentalGroup (X × Y) (x, y)

theorem fundamentalGroupProdMulEquiv_apply (x : X) (y : Y) (g) (h) :
    fundamentalGroupProdMulEquiv x y (g, h) = Path.Homotopic.prod g h

theorem fundamentalGroupProdProjections_apply (x : X) (y : Y) (k) :
    fundamentalGroupProdProjections x y k =
      (Path.Homotopic.projLeft k, Path.Homotopic.projRight k)
```

# 思维脉络（thinking trace）

Mathlib 的 `FundamentalGroupoidFunctor.prodIso` 比目标更强：它说明整个基本群胚保持二元积。本库在
对象 `(mk x,mk y)` 的自同态上真实调用其正向函子的 `map`，而不是只在文档列名。逆向明确使用两个
道路商投影。`projLeft_prod`、`projRight_prod` 和 `prod_projLeft_projRight` 证明双向互逆；
`comp_prod_eq_prod_comp` 结合 F2a 已解释的范畴复合/基本群乘法反序，证明正向映射保持乘法。

# 自然语言 ↔ Lean 映射

“积基点”对应 `(x,y)`；“积道路类”对应 `Path.Homotopic.prod`；“坐标投影类”对应
`Path.Homotopic.projLeft/projRight`；“基本群胚保持积”对应 `FundamentalGroupoidFunctor.prodIso`；
“基本群之积”使用 Lean 类型积上逐分量群结构；正向等价是 `fundamentalGroupProdMulEquiv`，反向
同态是 `fundamentalGroupProdProjections`。

# 依赖（人话版）

本条目依赖已冻结的道路同伦商、基本群 carrier 和 F2a 群运算。Mathlib 的 `prodIso`、积道路和投影
道路商与教材语义一致，作为正式承载直接复用；本库新增的是指定基点的群级接口、作用公式和双向
复合公式。无需连通、单连通或局部道路连通假设，因为陈述始终固定基点并只比较该基点的环路类。

# 应用与陷阱

结论是指定基点的群同构，不是未指定基点的“基本群”对象相等。若改变某个因子的基点，需要另用
道路给出的基点变换，并会出现共轭依赖。源码中乘法保持证明的道路拼接次序看似反向，是因为 F2a
已经说明基本群作为范畴自同态群采用 `p * q = q.trans p`；这不是积公式的额外交换性假设。本条目
只处理有限二元积，不宣称任意无限积或一般极限均已形成课程接口。
