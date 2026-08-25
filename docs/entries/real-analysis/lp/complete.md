---
id: real-analysis.lp.complete
kind: theorem
state: verified
title: "Lᵖ空间的完备性"
premises: ["real-analysis.lp.basic", "real-analysis.lp.minkowski"]
mathlib: ["MeasureTheory.Lp.instCompleteSpace", "CompleteSpace.complete"]
provenance: {source_type: book, ref: "folland-real-analysis-1999"}
---

# 动机

分析中常用一列近似函数逼近目标对象。要保证 `Lᵖ` 范数下的 Cauchy 近似不会逃出
函数空间，必须证明 `Lᵖ` 完备。这个结论称为 Riesz–Fischer 定理，它使 `Lᵖ`
成为 Banach 空间，也是泛函分析和偏微分方程中极限论证的基础。

# 直觉与证明脉络

经典证明从 Cauchy 列抽取一个快速收敛子列，使相邻项范数之和有限。Minkowski
不等式控制这些差分的部分和；由单调收敛构造几乎处处收敛的代表元，再用 Fatou
或控制估计证明极限仍属于 `Lᵖ`，最后由原列的 Cauchy 性恢复整列收敛。

Mathlib 已在 `MeasureTheory.Lp.instCompleteSpace` 中完成上述构造及 `p=∞` 的边界
情况。本库将其转正为教材空间 `LpSpace` 的完备性，并另给出 Cauchy 列版本。

# 陈述

设值域 `E` 是完备赋范加法群，且 `1≤p≤∞`。那么 `LpSpace E p μ` 是完备空间；
等价地，其中每个 Cauchy 序列都在 `Lᵖ` 范数拓扑下收敛到某个 `Lᵖ` 元素。

# Lean 对照

- `completeSpace_lp` 返回 `CompleteSpace (LpSpace E p μ)`；
- `cauchySeq_tendsto_lp` 展开为 `CauchySeq u → ∃ f, Tendsto u atTop (𝓝 f)`；
- `p≥1` 以 `[Fact (1 ≤ p)]` 提供，因为 `LpSpace` 的范数、度量和拓扑实例在类型
  检查阶段就需要这个条件。

# 依赖与应用

数学证明依赖 Minkowski 不等式及测度收敛工具；形式化入口依赖 `Lᵖ` 基础定义。
应用时若已有 `hp : 1 ≤ p`，先写 `letI : Fact (1 ≤ p) := ⟨hp⟩`，之后即可使用
完备空间实例和所有通用 Banach 空间结论。

# 陷阱

极限是按几乎处处相等取商后的 `LpSpace` 元素，不是自动选定的逐点函数。若需要
具体代表元，还要通过 `Lp` 的强制转换或 `MemLp.toLp` 接口，并只主张几乎处处性质。
