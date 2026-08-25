# 道路分支 handoff

## 批次范围

- 新模块：`SandronesLibrary/Topology/PathConnected.lean`。
- Entry：`topology.connectedness.path-components-foundation`。
- 不修改学科负责人禁改的聚合 import、Registry 或 ROADMAP。

## 教材概念清单

| 概念 | 本库教材定义 | 定义展开／一手性质 | Mathlib 桥 | 首个真实使用者 | 源码 Entry |
|---|---|---|---|---|---|
| 道路连接 | `Joined` | `joined_refl`、`Joined.symm/trans`、`joined_equivalence` | 无 | `pathComponent`、`Joined.map` | `topology.connectedness.path-components-foundation` |
| 道路分支 | `pathComponent` | `mem_pathComponent_iff`、`pathComponent_eq_iff_joined`、相交分支相等 | 无 | `image_pathComponent_subset` | `topology.connectedness.path-components-foundation` |
| 道路连通子集 | `IsPathConnected` | 展开为本库子空间内的道路 | 无 | `isPathConnected_singleton`、`IsPathConnected.image` | `topology.connectedness.path-components-foundation` |

## 定义审核

- `IsPathConnected τ s` 使用 `subspace s τ` 上的 subtype 道路，不允许道路离开 `s`。
- `joined_equivalence` 实际调用本库 `Path.refl/symm/trans`，是道路拼接的首个下游使用。
- `IsPathConnected.image` 通过本库 `continuous_subtype_mk` 把映射提升到像子空间，再实际调用
  `Path.map`，所以像中道路不会逸出像集。
- 道路分支相等与相交定理只使用已经证明的 `Joined` 对称性和传递性，没有挂靠 Mathlib 的
  quotient、connected component 或 path component。
- 尚未声称 `pathComponent τ a` 道路连通；该证明需要尚未建设的子道路限制接口。

## Main 接入建议

验收后由 Main 将模块加入聚合 import 和 Registry，并把道路限制／重新参数化列为后续依赖。
