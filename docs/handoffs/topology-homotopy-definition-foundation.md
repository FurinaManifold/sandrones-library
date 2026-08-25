# 同伦定义 handoff

## 批次范围

- 新模块：`SandronesLibrary/Topology/Homotopy.lean`。
- Entry：`topology.homotopy.definition-foundation`。
- 本批只建立定义、外延性和自反性，不提前声称同伦已成为等价关系。

## 教材概念清单

| 概念 | 本库教材定义 | 定义展开／一手性质 | Mathlib 桥 | 首个真实使用者 | 源码 Entry |
|---|---|---|---|---|---|
| 一般同伦 | `Homotopy` | `Homotopy.ext`、`Homotopy.refl/refl_apply`、`Homotopy.symm` | 无 | `PathHomotopy` | `topology.homotopy.definition-foundation` |
| 相对端点道路同伦 | `PathHomotopy` | `source_fixed/target_fixed`、`PathHomotopy.refl/symm` | 无 | 后续道路拼接律 | `topology.homotopy.definition-foundation` |

## 定义审核

- 同伦定义域使用本库 `product τX unitInterval`，不是函数柯里化后省略联合连续性。
- `PathHomotopy` 除时间端面外，明确记录整个时间方向上的源点和目标点固定条件。
- 常值同伦连续性实际经过 `continuous_fst` 和 `Continuous.comp`；逆同伦实际经过
  `continuous_prod_mk`、`continuous_unitInterval_reflect` 和复合。
- 公开签名不含 Mathlib 专用拓扑 structure、class、Prop 或课程性运算。

## 后续路线

下一批建立时间拼接的二维分段连续性，从而给出一般同伦与道路同伦的传递性。
