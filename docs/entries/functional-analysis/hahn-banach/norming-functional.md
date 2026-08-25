---
id: functional-analysis.hahn-banach.norming-functional
kind: theorem
state: verified
title: 范数化泛函与对偶范数刻画
premises: [functional-analysis.hahn-banach.extension]
mathlib: [exists_dual_vector, exists_dual_vector'', ContinuousLinearMap.le_opNorm]
provenance: {source_type: book, ref: "buehler-salamon-functional-analysis-2018"}
---

# 动机

算子范数告诉我们任意单位范数泛函在向量 `x` 上的绝对值不超过 `‖x‖`。Hahn–Banach 定理的力量
在于这个上界总能取到：对偶空间不仅给出估计，而且能完整检测原空间的范数和非零向量。

# 教材定义与正式承载

向量 `x≠0` 的范数化泛函是连续线性泛函 `g : E →L[ℝ] ℝ`，满足 `‖g‖=1` 和 `g(x)=‖x‖`。
这直接由 Mathlib 的 `exists_dual_vector` 承载；零向量也可使用 `exists_dual_vector''` 获得
`‖g‖≤1` 的统一版本。对偶范数刻画在本条中不另建上确界对象，而是公开两项等价的可用事实：
闭单位球中所有泛函值都受 `‖x‖` 控制，并且其中至少一个精确取到该界。

# 陈述（自然语言）

每个非零向量都有范数一的连续线性泛函在其上取值 `‖x‖`。对任意向量，对偶闭单位球中的泛函值
绝对值均不超过 `‖x‖`，且该上界总被某个泛函取到。因此连续对偶能分离原空间中的点。

# 陈述（Lean 对照）

对应 `exists_norming_functional`、`exists_contracting_norming_functional`、
`norm_dual_apply_le_norm`、`exists_dual_unitBall_norm_eq` 和 `exists_dual_apply_ne_zero`。

# 思维脉络

在一维子空间 `span{x}` 上定义坐标泛函，使它把 `x` 映到 `‖x‖`；这个泛函的范数为一。
Hahn–Banach 等范数延拓把它扩展到整个空间，得到范数化泛函。反方向的普遍上界只是算子范数定义：
`‖g(x)‖≤‖g‖‖x‖`。将 `‖g‖≤1` 代入，再与取到上界的泛函结合，就得到对偶范数刻画。

# 自然语言 ↔ Lean 映射

- 连续对偶：`StrongDual ℝ E`，即 `E →L[ℝ] ℝ`。
- 单位范数：`‖g‖ = 1`；闭单位球：`‖g‖ ≤ 1`。
- 算子范数上界：`ContinuousLinearMap.le_opNorm`。
- 范数化泛函存在性：`exists_dual_vector ℝ x`。
- 包含零向量的统一版本：`exists_dual_vector'' ℝ x`。

# 依赖

直接依赖上一条 Hahn–Banach 等范数延拓。后续凸分离、零化子闭包和典范双对偶嵌入都会使用“对偶
分离点”这一出口。

# 应用与边界

本条固定实赋范空间，不要求 Banach 完备性。范数化泛函通常不唯一；严格凸性或光滑性条件下的
唯一性不在本条范围。这里的“对偶范数刻画”以普遍上界加取到性表达，没有声称无限维对偶单位球
在范数拓扑下紧致。
