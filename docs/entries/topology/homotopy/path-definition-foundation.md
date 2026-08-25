---
id: topology.homotopy.path-definition-foundation
family: topology.homotopy
variant: textbook-unit-interval
kind: definition
state: verified
title: 道路与环路的库内定义
summary: 将道路定义为本库单位区间到本库拓扑空间的连续映射，并定义常值道路、连续像和环路
premises: [topology.foundation.real-line]
mathlib: []
provenance:
  source_type: book
  ref: "Hatcher, Algebraic Topology, Section 1.1"
---

# 动机

道路、同伦和单连通性是复分析全局 Cauchy 理论的拓扑基础。它们不能以 Mathlib `Path` 为未解释的公开起点。本条使用已经构造的实单位区间和连续性，冻结本库自己的道路核心接口。

# 直觉

道路是在单位时间内连续移动的轨迹：时间零位于起点，时间一位于终点。环路是最终回到起点的道路。空间之间的连续映射会把整条道路逐点送到目标空间中的一条道路。

# 陈述（自然语言）

在拓扑空间 `(X,τX)` 中，从 `a` 到 `b` 的道路由函数 `γ:[0,1]→X`、其连续性、`γ(0)=a` 和 `γ(1)=b` 组成。常值函数给出从 `a` 到自身的道路。若 `f:X→Y` 连续，则 `f∘γ` 是从 `f(a)` 到 `f(b)` 的道路。以 `a` 为基点的环路是从 `a` 到 `a` 的道路。

# 陈述（Lean 对照）

```lean
structure Path (τX : TextbookTopology X) (a b : X) where
  toFun : UnitInterval → X
  continuous : Continuous unitInterval τX toFun
  source : toFun UnitInterval.zero = a
  target : toFun UnitInterval.one = b

def Path.refl (τX) (a) : Path τX a a
def Path.map (γ : Path τX a b) (f : X → Y) (hf : Continuous τX τY f) :
  Path τY (f a) (f b)
```

# 思维脉络（thinking trace）

先从开集原像定义证明常函数连续，再把函数、连续性和端点等式打包为 `Path`。常值道路直接使用常函数连续性。道路的连续像使用连续映射复合定理；两个新端点等式分别由原道路的 `source` 与 `target` 化简得到。

# 自然语言 ↔ Lean 映射

“单位时间”对应 `UnitInterval`；“连续轨迹”对应字段 `toFun` 与 `continuous`；“起点/终点”对应 `source`、`target`；“停留不动”对应 `Path.refl`；“连续映射下的道路”对应 `Path.map`；“基点环路”对应透明定义 `Loop τX a := Path τX a a`，常值环路对应 `loopRefl`。

# 依赖（人话版）

本条只依赖本库实单位区间、拓扑与连续映射定义，以及本库证明的连续复合和常函数连续性。没有导入 `MathlibBridge`，没有使用 Mathlib `Path`、`ContinuousMap` 或单位区间结构。

# 应用与陷阱

当前 foundation 只冻结道路、环路、常值道路和连续像；尚未定义逆道路与拼接，因此不能把本条冒充 ROADMAP 中完整的 `topology.homotopy.path-loop`。后续操作必须证明相应分段参数函数在本库意义下连续，不能直接转调 Mathlib 道路操作。
