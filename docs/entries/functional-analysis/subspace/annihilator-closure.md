---
id: functional-analysis.subspace.annihilator-closure
kind: theorem
state: staging
title: 连续零化子、双零化子与子空间闭包
premises: [functional-analysis.convex.separation, functional-analysis.hahn-banach.norming-functional]
mathlib: [StrongDual.polarSubmodule, StrongDual.mem_polarSubmodule, Submodule.topologicalClosure]
provenance: {source_type: book, ref: "Bühler–Salamon, Functional Analysis, Section 2.3.4"}
---

# 动机

要判断一个向量是否属于子空间，只看原空间坐标往往不方便。连续线性泛函提供另一种测试：收集所有
在子空间上恒为零的泛函，再检查它们是否也都在给定向量上取零。Hahn–Banach 分离说明，这种测试
精确识别的不是任意子空间本身，而是它的拓扑闭包。

# 教材定义与正式承载

子空间 `S` 的连续零化子是 `{f ∈ E* | ∀x∈S, f(x)=0}`。Mathlib 已以
`StrongDual.polarSubmodule ℝ S` 承载它，并由 `StrongDual.mem_polarSubmodule` 给出全称量词展开。
这里的 `polarSubmodule` 对可数倍封闭集合把通常极集不等式强化为严格的取零条件，因此正是连续
零化子，不是单位极集。Mathlib 的 `Submodule.dualAnnihilator` 使用全部代数对偶，在无限维拓扑
问题中会直接恢复代数子空间而非闭包，故不作为本条正式承载。

# 陈述（自然语言）

零化子反转子空间包含关系。向量 `x` 属于 `S` 的拓扑闭包，当且仅当每个在 `S` 上恒为零的连续
线性泛函也在 `x` 上取零。特别地，若 `S` 闭，则这些连续泛函的共同零点恰好就是 `S`。

# 陈述（Lean 对照）

零化子成员刻画、反单调性、闭包双零化子刻画和闭子空间特例分别对应
`mem_continuousAnnihilator_iff`、`continuousAnnihilator_anti`、
`mem_topologicalClosure_iff_forall_annihilator` 与 `mem_closedSubspace_iff_forall_annihilator`。

# 思维脉络

若 `x` 在闭包中，任何消灭 `S` 的连续泛函，其核是包含 `S` 的闭集，因而也包含 `x`。反之，若
`x` 不在闭子空间 `closure S` 中，闭凸集分离定理给出一个连续泛函把 `x` 与该子空间严格分开。
由于子空间对任意实数缩放封闭，一个在线性子空间上有统一严格上界的线性泛函只能在那里恒为零；
而它在 `x` 上非零，于是检测到 `x` 不属于闭包。

# 自然语言 ↔ Lean 映射

- 连续对偶：`StrongDual ℝ E`。
- 连续零化子：`StrongDual.polarSubmodule ℝ S`。
- 零化量词：`StrongDual.mem_polarSubmodule`。
- 子空间闭包：`S.topologicalClosure`。
- 闭核：`f.isClosed_ker`。
- 外点分离：`separate_closed_convex_point`。

# 依赖

依赖凸分离窗口，以及连续对偶分离点的 Hahn–Banach 语言。下一条典范双对偶嵌入会用相同的求值
配对解释自反性；F4 弱拓扑也会把这些共同核视为基本闭集。

# 应用与边界

本条使用连续对偶，所以得到拓扑闭包；若改用全部代数对偶，结论和证明语义会改变。空间无需 Banach
完备，但必须是实赋范空间以使用当前分离链。本条没有声称零化子在对偶空间的哪一种弱或范数拓扑
下满足额外闭性，也没有提前使用 F4 的弱星拓扑。
