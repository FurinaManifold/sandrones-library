---
id: topology.fundamental-group.van-kampen-residual-gauge
family: topology.fundamental-group
variant: binary-open-cover-residual-gauge
kind: theorem
state: verified
title: van Kampen 边界 residual gauge 传播
summary: 比较顶点势与边界 frame 留下的右 gauge，并沿同伦方形三条边传播以消去整体 rebase 的端点差
premises: [topology.fundamental-group.van-kampen-rebased-letter-word]
mathlib: [Group, Fin, FundamentalGroup, Monoid.PushoutI]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

14c 只证明原输入字母词在全局首末 frames 下整体 rebase 后等于一。要恢复原字母词，必须证明这两个
frames 相对于同一套 vertex potentials 留下相同的 residual gauge；这正是教材方格消去证明中沿外边界
传播基点变换的代数内容。

# residual gauge

在任意群中，`potential⁻¹ * frame` 衡量选定 frame 相对于 vertex potential 剩下的右乘 gauge。
`potentialNormalizedFrame_eq_of_compatible` 说明：若一条边的 transition 同时由两端 potentials 给出，
并按同一 transition 搬运 frames，则 residual gauge 在边两端不变。

`potentialNormalizedFrame_eq_of_two_rebases` 给出等价的实用形式：同一 edge 被 potential pair 和 frame
pair 各自 rebase 为一，就能推出两端 residual gauges 相等。这里只使用群公理，不要求交换性。

# 方格边界传播

`combinedFrame_eq_of_target_and_normalized` 把目标 vertex potential 与已归一化 frame 的关系整理成
可沿网格边迭代的等式。随后在既有 `BinaryOpenCoverSquareSubdivision` 上依次沿底边、右边和顶边传播；
每一步复用前序模块已经证明的边 transition、基点 coercion 和 frame compatibility。

# 左端点比较

`BinaryOpenCoverSquareSubdivision.leftResidualGauge_bottom_eq_top` 是本批出口：左下角和左上角的
combined frames 相对于相应 vertex potentials 具有相同 residual gauge。它提供 15b 去掉 14c 整体
rebase 所需的端点等式，但本身还不声称任意 kernel 字母词为一。

# Lean 对照

```lean
theorem potentialNormalizedFrame_eq_of_compatible ...
theorem potentialNormalizedFrame_eq_of_two_rebases ...
theorem combinedFrame_eq_of_target_and_normalized ...
theorem BinaryOpenCoverSquareSubdivision.leftResidualGauge_bottom_eq_top ...
```

# 正式承载与 Mathlib 复用

群、有限索引、基本群和 `Monoid.PushoutI` 直接复用 Mathlib：它们分别精确承载非交换乘法、有限网格
坐标、道路同伦类群和二群沿公共群的 pushout。方格细分、vertex potential、combined frame 与 rebase
运算复用本库前序 Entry；本批不新建 carrier、instance、notation、基本群或 pushout。

# 证明思路

先在抽象群中把 transition 等式代入并正规化，得到单边 residual 不变性。几何部分把边界顶点确认为
覆盖基点，利用已经公开的基点 coercion 规则统一类型，再对三段有限边链逐项应用单边结论并 telescope。
最后拼接底、右、顶三段结果，得到左边界两个端点的比较。

# 边界

本条目只消除 residual gauge 差异。它不证明 kernel 字母词平凡、不证明规范同态单射，也不给出最终
van Kampen 同构；这些属于后续 15b 和 15c。定理针对已经标号并带齐前序证书的二开集方格细分，
不声称 many-set、groupoid 或交集不道路连通版本。
