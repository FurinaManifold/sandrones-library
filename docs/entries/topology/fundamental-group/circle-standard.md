---
id: topology.fundamental-group.circle-standard
family: topology.fundamental-group
variant: exponential-lift-winding
kind: theorem
state: staging
title: 圆周基本群与整数绕数
summary: 通过指数覆盖的道路提升终点定义绕数同态，证明其双射并得到圆周基本群同构于整数加法群
premises: [topology.fundamental-group.operations-standard, topology.fundamental-group.triviality-standard]
mathlib: [Circle.exp, Circle.isAddQuotientCoveringMap_exp, IsCoveringMap.liftPath, IsAddQuotientCoveringMap.fundamentalGroupToMulOpposite]
provenance:
  source_type: book
  ref: "hatcher-algebraic-topology-2002"
---

# 动机

圆周是第一个基本群非平凡的空间。环路沿指数覆盖 `exp : ℝ → S¹` 从零开始提升后，终点必为
`2π` 的整数倍；这个整数就是绕数。计算 `π₁(S¹)` 的关键不是直接宣布它同构于整数，而是证明绕数
只依赖端点固定同伦类、与环路乘法相容、能够区分所有同伦类，并且每个整数都能实现。

# 直觉

实直线在指数映射下每隔 `2π` 回到同一点，因此覆盖变换是平移 `x ↦ n·2π+x`。环路的提升从零
出发，走完后落在哪个覆盖层就记录了它绕圆周几圈。同伦提升保证端点在端点固定同伦下不变；实直线
单连通保证同一提升终点的环路类相同；实直线路径连通则允许连接零与任意 `n·2π`，给出任意绕数。

# 陈述（自然语言）

`2π` 的整数倍子群与整数加法群等价。每条以 `1` 为基点的圆周环路有一条从 `0` 出发的连续提升，
投影后逐点恢复原环路。其同伦类的绕数等于 `n` 当且仅当提升终点是 `n·2π`。绕数给出从圆周基本群
到整数乘法标记群 `Multiplicative ℤ` 的群同态；该同态单射且满射，所以圆周基本群是无限循环群。

# 陈述（Lean 对照）

```lean
def circleDeckIntEquiv : AddSubgroup.zmultiples (2 * Real.pi) ≃+ ℤ

def circleLoopLift (g : Path (1 : Circle) 1) : C(unitInterval, ℝ)

theorem circleLoopLift_exp (g : Path (1 : Circle) 1) (t : unitInterval) :
    Circle.exp (circleLoopLift g t) = g t

def circleWindingHom : FundamentalGroup Circle 1 →* Multiplicative ℤ

theorem circleWindingHom_eq_iff_lift_endpoint (g : Path (1 : Circle) 1) (n : ℤ) :
    circleWindingHom (FundamentalGroup.fromPath (Path.Homotopic.Quotient.mk g)) =
        Multiplicative.ofAdd n ↔ circleLoopLift g 1 = n • (2 * Real.pi)

def circleFundamentalGroupEquivInt : FundamentalGroup Circle 1 ≃* Multiplicative ℤ
```

# 思维脉络（thinking trace）

先用 `AddSubgroup.mem_zmultiples_iff` 把每个覆盖变换唯一写成 `n • 2π`；唯一性来自 `2π ≠ 0`。
`Circle.isCoveringMap_exp.liftPath` 选择从零出发的提升，`liftPath_zero` 与 `liftPath_lifts` 给出初值和
投影公式。Mathlib 的商覆盖 monodromy 把道路同伦商作用在覆盖纤维上；本库把该作用通过明确构造的
deck-group/整数等价转成 `circleWindingHom`，再证明它恰由提升终点刻画。单射使用覆盖空间 `ℝ` 的
单连通性，满射使用其道路连通性。最终只用 `MulEquiv.ofBijective` 打包此前公开证明的双射同态。

# 自然语言 ↔ Lean 映射

“圆周”是复数单位圆子类型 `Circle`，基点是 `1`；“指数覆盖”是 `Circle.exp` 及
`Circle.isAddQuotientCoveringMap_exp`；“覆盖变换群”是 `AddSubgroup.zmultiples (2 * Real.pi)`；
“从零提升”是 `circleLoopLift`；“绕数”是 `circleWindingHom` 的整数值；基本群采用乘法记号，所以
整数加法群用 `Multiplicative ℤ` 承载。`MulOpposite` 只修正范畴/monodromy 的复合次序，不改变整数值。

# 依赖（人话版）

本条目依赖已冻结的道路同伦商、基本群 carrier 与群运算。Mathlib 提供语义一致的标准 `Circle`、
覆盖映射、道路/同伦提升和商覆盖 monodromy 后端；本库公开建立 `2πℤ ≃ ℤ`、具体提升、终点刻画与
绕数同态，使这些后端不被静默当作最终课程结论。Hatcher Section 1.1 的圆周计算是教材路线；
这里专门使用圆周指数覆盖，不把一般覆盖空间理论作为 T4 的新课程条目。

# 应用与陷阱

群同构目标写成 `Multiplicative ℤ`，不是说整数改用了乘法运算，而是让加法群与 Lean 的基本群乘法
签名对齐。`circleLoopLift` 只针对基点 `1` 且初始提升点固定为 `0`；改变基点或初始覆盖层需要额外
共轭/平移处理。最终等价不是 `IsAddQuotientCoveringMap.fundamentalGroupEquiv` 的别名：源码只使用
其下层 monodromy 同态、单射和满射定理，并公开验证具体整数值就是提升终点。一般 van Kampen 和
覆盖空间课程仍属于后续代数拓扑，不因本条目的圆周专门化而宣称完成。
