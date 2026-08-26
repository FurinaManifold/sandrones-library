---
id: topology.homotopy.homotopy-square-grid
family: topology.homotopy
variant: endpoint-relative-homotopy-uniform-square-grid
kind: theorem
state: research
title: 道路同伦方形与一致网格边
summary: 将端点相对道路同伦表示为连续参数方形，并定义一致网格的顶点、小格参数化和有向边及其四侧计算规则
premises: [topology.homotopy.path-homotopy-standard, topology.homotopy.unit-interval-mesh]
mathlib: [Path.Homotopy, Path, ContinuousMap, Set.Icc.convexComb]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

道路同伦给出一个单位方形上的连续映射。后续的方格细分、van Kampen 单格关系和连续同伦下的复道路
积分不变性都需要统一约定两个坐标的含义，并在同一有限网格上复用完全相同的顶点和有向边。

# 定义与结论

`pathHomotopySquare` 将 Mathlib 的 `Path.Homotopy p q` 看成连续映射，其中第一坐标是同伦参数、第二
坐标是道路参数；四条计算规则给出左右两条道路以及上下两个固定端点。

`squareGridVertex`、`unitSquareCellPoint`、`squareGridHorizontalEdge` 和 `squareGridVerticalEdge` 在正整数
`N` 的一致网格上分别定义顶点、小格的双参数点、从左到右的横边和从下到上的竖边。四条外边识别
定理证明：道路同伦方形的左右列正是 `p`、`q` 的相应网格子段，而上下行是端点处的常值道路。

# Lean 对照与教材语义

Mathlib `Path.Homotopy` 是端点相对的道路同伦：每个中间切片仍是从同一起点到同一终点的道路。
本库没有重写它的 carrier；`pathHomotopySquare` 只是把其已有连续映射显式暴露为
`C(unitInterval × unitInterval, X)`。`Path` 同样直接承载具有固定端点的连续道路，`ContinuousMap`
承载参数方形。`Set.Icc.convexComb` 在单位区间内线性插值，因此恰好给出教材中的等距网格边与闭格
参数化；正性前提 `0 < N` 排除除以零并保证相邻网格点存在。

# 自然语言 ↔ Lean 映射

“同伦参数方形”对应 `pathHomotopySquare`；四侧限制对应其四个 `@[simp]` 定理；“一致网格顶点”对应
`squareGridVertex`；“第 `(i,j)` 个闭格内的点”对应 `unitSquareCellPoint`；统一向右、向上的有向边
分别对应 `squareGridHorizontalEdge`、`squareGridVerticalEdge`；同伦方形四条外侧的网格子段识别
对应四个 `squareGrid*Edge_pathHomotopySquare_*` 定理。

# 证明思路

方形接口直接展开 Mathlib 同伦的连续映射，并用其端点相对计算规则得到四侧值。网格顶点复用本库
`unitIntervalMeshPoint`；横边和竖边只在一个坐标上用区间凸组合移动。外边识别定理把固定坐标代入，
再使用同伦四侧的计算规则。这里没有紧致性、Lebesgue 数或基本群论证。

# 依赖

道路同伦及其端点相对语义来自 `topology.homotopy.path-homotopy-standard`，一致一维网格来自
`topology.homotopy.unit-interval-mesh`。Mathlib 的 `Path.Homotopy`、`Path`、`ContinuousMap` 和
`Set.Icc.convexComb` 都是语义一致的正式承载，而非私有证明捷径；上层方格细分和单格边界定理
实际直接使用本条目的网格点与边。

# 应用与边界

本接口同时服务 van Kampen 方格证明与复道路积分的 dyadic-grid 证明，因而放在中性的 `Topology`
命名空间。本条目不定义单格边界词、覆盖标签、基本群或 Pushout，也不证明 van Kampen 定理。
它也不从连续同伦推出任何逐格 `C¹` 性质；后续复分析路线只能在额外的分片光滑假设下使用积分接口。

# 来源说明

Hatcher 第一章提供端点相对道路同伦及 van Kampen 方形论证的拓扑语境。将参数方形离散成统一有限
网格是形式化证明的共享实现层；本条目只冻结坐标、方向和四侧计算，不把它冒充教材中的独立具名
定理。
