# 道路拼接 handoff

## 批次范围

- 源码：`SandronesLibrary/Topology/Path.lean`。
- Entry：`topology.homotopy.path-concatenation-foundation`。
- 本批新增单位区间半段缩放、拼接函数、连续性证明与 `Path.trans`。

## 教材概念清单

| 概念 | 本库教材定义 | 定义展开／一手性质 | Mathlib 桥 | 首个真实使用者 | 源码 Entry |
|---|---|---|---|---|---|
| 半区参数缩放 | `UnitInterval.leftDouble/rightDouble` | 值分别为 `2t`、`2t-1` | 无 | `Path.transFun` | `topology.homotopy.path-concatenation-foundation` |
| 道路拼接函数 | `Path.transFun` | `transFun_of_le/not_le` | 无 | `Path.trans` | `topology.homotopy.path-concatenation-foundation` |
| 道路拼接 | `Path.trans` | `continuous_transFun`、端点证明与 `trans_apply_of_le/not_le` | 无 | 后续道路同伦 | `topology.homotopy.path-concatenation-foundation` |

## 审核边界

- 证明从本库 `continuous_from_unitInterval_iff` 展开连续性，分别处理左半区、右半区和中点。
- 中点证明实际使用 `gamma.target` 与 `delta.source`，不是隐藏调用现成粘合定理。
- tactic import 只处理实数算术；公开签名不含 Mathlib 拓扑、连续映射或道路结构。
- `Path.trans` 是 `noncomputable`，原因仅为实数序的分支判定。

## 后续路线

以 `Path.trans` 为一手使用者搭建道路同伦与重新参数化；在此之前不要把结合律或单位律误写成严格道路相等。
