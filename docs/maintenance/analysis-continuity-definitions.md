# 分析维护说明：连续性教材定义

## 现状与问题

`Analysis/Continuity.lean` 的基础条目直接使用 `ContinuousAt`、`ContinuousOn` 和
`UniformContinuousOn`。已有 `uniformContinuous_iff_eps_delta` 展开全域一致连续，但点连续、集合上
逐点连续以及集合上一致连续之间的量词差别没有在本库定义层并列展示。

## 本轮定义与桥

- `ContinuousAtTextbook f a`：给定基点 `a`，每个 ε 有一个 δ。
- `ContinuousOnTextbook f s`：对每个 `a∈s` 分别选择 δ，邻近点 `x` 也限制在 `s` 内。
- `UniformContinuousOnTextbook f s`：δ 只依赖 ε，同时控制 `s` 内所有点对 `x,y`。

分别证明与 `ContinuousAt`、`ContinuousOn`、`UniformContinuousOn` 双向等价。证明只使用
`Metric.continuousAt_iff`、`Metric.continuousOn_iff`、`Metric.uniformContinuousOn_iff` 和
`Real.dist_eq`，没有附加数学前提。

## 接口边界

本项为 M1 定义补充。常函数、四则运算、介值定理、最值定理、反函数连续和 Heine–Cantor 定理
继续使用 Mathlib 连续性接口。新增谓词负责讲清教材量词，不建立全库替换或旧接口退役计划。

三个新定义都是普通 `Prop`，不新增 notation、instance 或 simp 属性。全域连续可由逐点
`ContinuousAtTextbook` 表达；全域一致连续已有 `uniformContinuous_iff_eps_delta`，本轮不重复命名。

回滚点为 `5c98905`。共享 Registry、RADAR、ROADMAP、Playbook 和顶层 import 不在维护分支修改。
