# Main review：概率论 Pr1 foundations

- reviewed commit: `91369fa`
- verdict: `accepted`
- reviewed at: 2026-08-26

## 验收结论

八个条目依次建立概率测度、随机变量、分布、期望、矩、事件独立、变量独立和基础不等式。源码直接
复用 `IsProbabilityMeasure`、`Measurable`、`Measure.map`、Bochner `integral`、`variance`、
`IndepSet` 与 `IndepFun`；各 Entry 均解释教材含义与 Mathlib 的全定义退化边界，没有重造核心载体。

Main 重建八个模块，并对每个 Entry 执行公开声明公理审计。新增源码无 `sorry`、`admit`、
`native_decide` 或新增 `axiom`。Markov、Chebyshev 与 Jensen 均保留真实可测性、可积性、二阶矩和
凸性条件，没有用退化定义制造无条件结论。

## 后续权限

G-Pr 打开。Pr2 现开放两个第一窗：条件期望定义／存在，以及过滤定义；二者文件所有权不重叠。
条件期望 definition 构建并形成 handoff 后，tower 和 independence 按顺序自动放行。Martingale 等待
条件期望与过滤接口同时稳定，可选停止继续冻结。统计 S1 只开放模型、密度与 RN 接口审计，暂不开放
一般估计定理开发。
