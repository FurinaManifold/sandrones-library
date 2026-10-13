---
id: probability.convergence.distribution-bridge
family: probability.convergence
variant: textbook
kind: theorem
state: verified
title: 分布收敛的随机变量桥
summary: 把 ProbabilityMeasure ℝ 层的弱收敛与已知极限分布组装成随机变量层的 TendstoInDistribution
premises: [probability.convergence.modes]
mathlib: [MeasureTheory.TendstoInDistribution, MeasureTheory.ProbabilityMeasure, MeasureTheory.Measure.isProbabilityMeasure_map, MeasureTheory.Measure.map_congr]
provenance:
  source_type: book
  ref: "kallenberg-modern-probability-2021"
---

# 教材陈述

依分布收敛（弱收敛）在教材中有两种等价说法：随机变量序列 `Yₙ` 的分布弱收敛到 `Z` 的分布；或者
推前概率测度 `law(Yₙ)` 在弱拓扑下收敛到 `law(Z)`。本库在
`probability.convergence.modes` 中把后者作为正式承载，直接复用 Mathlib 的
`MeasureTheory.TendstoInDistribution`。

本条目补齐分析链需要的另一侧接口：当特征函数、紧性或 Fourier 方法已经在
`ProbabilityMeasure ℝ` 层建立弱收敛，并且已经知道极限随机变量的分布时，如何回到
`TendstoInDistribution`。

# 为什么需要这条桥

`TendstoInDistribution` 是一个 `structure`，公开字段包括每项的 a.e. 可测性、极限的 a.e. 可测性
以及推前概率测度的 `Tendsto`。围绕特征函数得到的结论天然是**测度层**的弱收敛，无法直接匹配只
接受 `TendstoInDistribution` 的下游定理（例如连续映射定理或 Slutsky 型组合）。本桥把两者对齐，
避免下游各自重复组装该结构。

# 正式承载与记号

- `lawProbabilityMeasure Y hY : ProbabilityMeasure ℝ`：把随机变量 `Y` 的推前分布打包成概率测度，
  其中 `hY` 是 a.e. 可测性。它把“分布”与“总质量为 1”两件事一次记录，使弱收敛结论有统一的
  `ProbabilityMeasure ℝ` 载体。
- `tendstoInDistribution_of_tendsto_law_gaussian`：桥定理本身。

两者都是围绕 Mathlib 现有结构的薄组装，没有新建收敛概念或复制弱收敛拓扑。

# 桥的方向与假设

桥的假设是：

\[
  \forall n,\;
  \mathrm{law}(Y_n)\Rightarrow N(0,1),
  \qquad
  \mathrm{law}(Z)=N(0,1).
\]

结论是 `TendstoInDistribution Y atTop Z (fun _ ↦ P) P'`。关键观察是：`TendstoInDistribution` 的
`tendsto` 字段本来就只要求推前概率测度的弱收敛；把 `law(Z)` 改写为 `gaussianReal 0 1` 之后，
弱收敛假设恰好就是所需证明。因此桥是定义上的一步组装，而不是需要额外紧性或唯一性的定理。

# 与一般目标测度的关系

本条目把目标固定为标准正态 `gaussianReal 0 1`，因为当前概率极限定理的分析链只产生这一目标。
接口本身没有数学上的特殊性；若后续需要一般目标 `ν : ProbabilityMeasure ℝ`，可用相同方式把
`𝓝 ⟨gaussianReal 0 1, _⟩` 换成 `𝓝 ν` 并把 `hZlaw` 改成 `P'.map Z = ν`。本批不预先泛化，以免
引入没有真实使用者的接口。

# 上层使用者

`probability.central-limit-theorem` 的
`iid_centeredScaled_clt_tendstoInDistribution` 是本桥的真实使用者：它先用一般 iid CLT 得到
`ProbabilityMeasure ℝ` 层的弱收敛，再调用本桥的 Gaussian 版本得到随机变量层的
`TendstoInDistribution`。

# 依赖与边界

- 库内前提：`probability.convergence.modes`（提供 `TendstoInDistribution` 的教材解释与
  连续映射等消费者）。
- Mathlib 正式承载：`TendstoInDistribution`、`ProbabilityMeasure`、
  `Measure.isProbabilityMeasure_map`、`Measure.map_congr`。
- 边界：桥只接收**已经建立**的弱收敛假设；它不证明紧性、不证明极限测度的存在性，也不处理极限
  分布未知的情形。目标测度固定为 `gaussianReal 0 1`。
