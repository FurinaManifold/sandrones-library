---
id: topology.orientation.vector-space
kind: theorem
state: verified
title: "有限维实向量空间的定向"
premises: ["topology.normed-space.def", "linear-algebra.det.mul"]
mathlib: ["Orientation", "Orientation.map", "Orientation.map_eq_iff_det_pos", "Orientation.map_eq_neg_iff_det_neg", "Basis.orientation"]
provenance:
  source_type: book
  ref: "有限维实向量空间的定向与保向坐标变换"
---

# 动机

多元积分和微分形式不仅关心坐标变换把集合映到哪里，还关心它是否把“正方向”翻转。
例如平面反射保持面积，却把逆时针方向变成顺时针方向。定向正是记录这一区别的数据。

# 直觉

在 `n` 维空间中，把两个有序基视为同向，当它们之间的换基矩阵行列式为正；若
行列式为负，则视为反向。所有有序基因此恰分成两个定向类。

# 陈述（自然语言）

有限维实向量空间的有序基诱导一个定向。维数与 `n` 相等时，每个线性自同构要么
保持指定定向，要么反转它；前者等价于行列式为正，后者等价于行列式为负。任意
有序基都可通过调整最后一个基向量，使其符合预先指定的定向。

# 陈述（Lean 对照）

`VectorOrientation E n` 包装 `Orientation ℝ E (Fin n)`；
`IsOrientationPreserving` 与 `IsOrientationReversing` 分别比较
`Orientation.map (Fin n) f o` 与 `o`、`-o`。两个行列式判据直接给出教材中的
正向与反向判别法。

# 思维脉络（thinking trace）

顶次交替形式在换基时乘以行列式。只保留其正射线，正倍数不改变定向，负倍数则
落入相反射线；所以换基对定向的作用完全由行列式符号决定。

# 自然语言 ↔ Lean 映射

- 有序基诱导定向：`orientationOfBasis`
- 保向线性自同构：`IsOrientationPreserving`
- 反向线性自同构：`IsOrientationReversing`
- 行列式符号判据：`isOrientationPreserving_iff_det_pos`、
  `isOrientationReversing_iff_det_neg`
- 调整基以符合定向：`adjustedBasis_has_orientation`

# 依赖（人话版）

依赖有限维实线性空间、基、顶次交替形式和行列式。赋范结构不是定向本身所必需，
但分析层的微分形式与 Fréchet 导数在赋范空间中使用这一接口。

# 应用与陷阱

该条目只定义向量空间及线性坐标变换的定向，不等同于一般拓扑流形的可定向性。
后者还需证明不同局部坐标图之间的转换在重叠区域上保向。积分换元中的绝对值
`|det|` 不依赖定向；只有第二型积分和 Stokes 型公式才需要固定方向并追踪符号。
