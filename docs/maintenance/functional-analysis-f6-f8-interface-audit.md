# F6–F8 锁定阶段接口调查

- 审计基线：Mathlib 当前 checkout（Main `837e93f`）
- 权限：仅书目与接口调查；F6、F7、F8 均未获正式开发权限
- 课程顺序：Bühler–Salamon Chapters 5–7；F6 依赖 F5/C1，F7 依赖 F4–F6/R4，F8 依赖 F7/R4

## F6 Banach 代数与有界谱理论

成熟后端包括 `spectrum`、`resolventSet`、`spectralRadius`，以及
`spectrum.isOpen_resolventSet`、`spectrum.isCompact`、谱半径范数界和谱半径公式相关接口。
有界 Hilbert 算子可作为连续线性自同态代数使用；`Analysis.InnerProductSpace.Spectrum` 已含
自伴／紧算子的谱与特征值结果，C*-代数目录另有连续函数演算基础设施。

这里的风险不是“没有 Mathlib”，而是后端过强且分散：Banach 代数基础、一般谱、紧算子谱、
Hilbert 紧自伴谱定理和连续函数演算必须拆窗，不能用最终谱定理替代教材定义与依赖链。F5 紧算子
尚未集成且 C1 门未核验，故目前不创建 F6 Entry。

## F7 无界算子

`Mathlib.Analysis.InnerProductSpace.LinearPMap` 已提供部分线性映射承载 `E →ₗ.[𝕜] F`，包含定义域、
伴随、稠密定义域、自伴与闭性的一部分接口；其中已有 `IsSelfAdjoint.dense_domain` 和
`IsSelfAdjoint.isClosed`。这适合作为 Hilbert 无界算子的候选后端。

缺口是 ROADMAP 所需的完整课程链尚未以单一成熟 API 呈现：一般 Banach 空间无界算子、图范数、
预解集、Cayley 变换及无界谱测度接口需要逐项审计。尤其不能把有界算子的 `IsSelfAdjoint`／
`ContinuousLinearMap.adjoint` 与部分线性映射的无界伴随混称。F6 未完成，故不创建 F7 Entry。

## F8 强连续半群

对 Mathlib `Analysis` 与 `Topology` 的文件名和符号检索未发现成熟的 `C₀` 算子半群、无穷小生成元、
Hille–Yosida 或 Duhamel 课程级承载。`Topology.Algebra.Semigroup` 是拓扑半群基础，不能代替
`t ↦ T(t)` 的强连续算子半群。

Bochner 积分和 `StronglyMeasurable` 等测度论后端存在，但它们只覆盖 F8.7 的积分前置，不提供
生成元或半群定理。因此 F8 若未来解锁，应先登记 foundation/bridge 并设计承载；当前绝不能用函数族
加若干量词临时包装后宣称 Hille–Yosida 已形式化。

## 给 Main 的解锁建议

1. F5 紧算子定义层集成、C1 完成后，只开放 F6.1–F6.3（Banach 代数、谱定义、非空紧致）。
2. F6 的紧算子谱与紧自伴谱定理等待 F5 正式接口；函数演算另开窗口。
3. F7 先以 `LinearPMap` 做独立承载 RFC，再决定一般 Banach 与 Hilbert 两条路线是否分开。
4. F8 保持冻结，直到找到或设计稳定的强连续半群／生成元承载。
