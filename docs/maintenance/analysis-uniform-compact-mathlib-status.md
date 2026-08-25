# 分析维护 RFC：`uniform-compact` 的 Mathlib 状态说明

## 现状与问题

公开定理 `continuousOn_compact_uniformContinuousOn` 位于
`SandronesLibrary/Analysis/Continuity.lean`，签名是：非空紧集上连续的实值函数在该集合上一致连续。
证明体独立展开逐点连续、有限子覆盖和有限正半径最小值，没有调用 Mathlib 的 Heine–Cantor 主定理。

课程文档此前写成“mathlib 无此定理”。这一事实判断已经不正确：当前锁定的 Mathlib 在
`Topology/UniformSpace/HeineCantor.lean` 中提供
`IsCompact.uniformContinuousOn_of_continuous`，而且结论更一般，不限于实值函数。

## 接口角色与语义对照

- 本库接口：独立教材证明版本，显式展示有限子覆盖与最小半径构造。
- Mathlib 接口：同一 Heine–Cantor 结论的通用现成定理。
- 两者数学方向一致；本轮不需要新增 `old_iff_new`，因为没有定义迁移或公开签名变化。
- 本库多出的 `s.Nonempty` 前提来自当前有限最小值证明组织，不表示 Mathlib 定理需要非空性。

## 影响图

- Lean 直接声明：`continuousOn_compact_uniformContinuousOn`。
- 下游 Registry：`real-analysis.riemann.cont-integrable`、`real-analysis.riemann.eq-lebesgue`。
- 下游源码：`RealAnalysis/Riemann.lean` 的连续函数 Darboux 可积证明。
- 文档直接引用：`real-analysis/riemann/cont-integrable.md`、`eq-lebesgue.md`。
- 共享状态：`docs/MATHLIB-RADAR.md` 仍含同一条过时的“mathlib 无此定理”说明。
- 无 notation、instance、simp 属性或 typeclass 隐式依赖；本轮不改变任何 Lean 声明。

## 等级、兼容和回滚

影响等级为 M0：只更正课程文档对证明角色的描述，公开定理名、签名、证明体、Entry id 与依赖图均不变。
回滚点是维护前 main `ee0c97f`。若回滚，只会恢复错误说明，不影响编译。

## 本轮修改与边界

本轮把课程文档改为：“Mathlib 已有同结论；本库保留独立教材式证明，且证明体没有调用该主定理”。
作为学科维护者，不直接修改 Main 共有文件 `docs/MATHLIB-RADAR.md`；handoff 要求 Main 同步更正。
本轮不删除独立证明、不收窄非空前提，也不把证明替换成一行 Mathlib 调用。
