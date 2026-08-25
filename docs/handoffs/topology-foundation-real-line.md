# 实直线与单位区间 handoff

## 分支与范围

- 分支：`codex/topology-foundations`。
- 新源码：`SandronesLibrary/Topology/RealLine.lean`。
- 新条目：`docs/entries/topology/foundation/real-line.md`。
- Entry id：`topology.foundation.real-line`。
- 本 review 批次接收顺序第一项：`1bfe5fa`。基础结构批次已经 Main 验收；不得用整个分支区间
  代替本提交范围。

## 公开定义

- `realLine` 用 ε-邻域直接定义实直线拓扑。
- `UnitInterval` 是 `0 ≤ t ∧ t ≤ 1` 的 subtype，端点为 `UnitInterval.zero/one`。
- `unitInterval` 由本库 `subspace` 构造；`continuous_unitInterval_val` 使用本库连续性。
- `isOpen_realBall` 与 `isOpen_unitInterval_iff` 为分段连续和道路拼接提供 ε 语言。
- `continuous_from_unitInterval_iff` 将本库连续性完整转写为逐点相对 ε 判据。

## 后端边界与负责人审核

- 模块不导入 `MathlibBridge`，也不使用 Mathlib 拓扑、度量空间或单位区间结构。
- 检查交集半径使用 `min` 且两侧严格为正；任意并从实际包含点的成员取得半径。
- 检查单位区间没有重新声明一套开集公理，而是依赖已验收的本库子空间拓扑。

## 教材概念清单

| 概念 | 本库教材定义 | 定义展开／一手性质 | Mathlib 桥 | 首个真实使用者 | 源码 Entry |
|---|---|---|---|---|---|
| 实直线拓扑 | `realLine` | ε-开集定义、`isOpen_realBall` | 无 | `unitInterval` | `topology.foundation.real-line` |
| 单位区间 | `UnitInterval` | `zero/one` 端点 | 无 | `unitInterval`、`Path` | `topology.foundation.real-line` |
| 单位区间拓扑 | `unitInterval` | `isOpen_unitInterval_iff` | 无 | `Path.continuous` | `topology.foundation.real-line` |
| 参数反射 | `UnitInterval.reflect` | 交换端点、反射自反、连续 | 无 | `Path.symm` | `topology.foundation.real-line` |

## 公开签名扫描与定义链

- 公开签名只出现普通载体 `ℝ`、`Set`、subtype 和本库 `TextbookTopology/Continuous`；没有 Mathlib
  专用拓扑 structure、class、Prop 或课程性运算，因此四类扫描中无第 2–4 类泄漏。
- 定义链聚合应同时检查 `realLine`、`isOpen_realBall`、`UnitInterval`、`unitInterval`、
  `isOpen_unitInterval_iff`、`continuous_from_unitInterval_iff`、`continuous_unitInterval_reflect` 与
  使用者 `Path.symm`。
- Main 已在 `76d770f` 扩展声明映射器；`UnitInterval.reflect` 及其带点性质均已完成映射和公理
  复验，不再存在声明解析门。

## Main 共有文件建议

- 顶层 import 建议置于 `Topology.Constructions` 后。
- Registry 登记 `topology.foundation.real-line`，作为道路与同伦的参数空间依赖。

## 下一批

下一批定义本库 `Path` 与 `Loop`，先完成常值道路；逆道路和拼接必须通过本库连续性证明参数变换
连续，不得借 Mathlib `Path.symm` 或 `Path.trans`。
