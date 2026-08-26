# Topology handoff：AT1-VK3b-06 MixedVertexCoherence

## 范围、基线与权限

- 分支：`codex/topology-foundations`；正式依赖提交为 `5ae0046`。
- Main 基线：以 merge `20e0798` 同步到 `25eee79` 后迁移本批。
- 权限：`main-1c4d306-vk3b02-03-accepted-vk3b04-06-open.md` 的 `development_open`。
- 本批只建立中央交集对象、混合/同标签分支的文件内组装，以及最终统一方格出口；不包含 07
  perimeter/row telescope、kernel、单射或等价。
- 经 07--15 declaration-level 引用审计，公共面收缩为 9 public、39 private。

## 文件与 Main-side 建议

- 源码：`SandronesLibrary/Topology/VanKampenMixedVertexCoherence.lean`。
- Entry：`topology.fundamental-group.van-kampen-mixed-vertex-coherence`，唯一 `lean_file` 建议指向上述源码。
- 顶层 import、Registry、生成索引、RADAR/ROADMAP 由 Main 集成时维护。

## Public API 与直接消费者

| 声明 | 数学角色 | 直接下游消费者 |
|---|---|---|
| `centralVertex_mem_intersection_of_not_all_eq` | 混合标签中央点属于交集 | 构造公开 `centralIntersectionVertex` |
| `centralIntersectionVertex` | 规范中央交集 subtype 点 | 本模块几何对象；构造 potentials |
| `coe_centralIntersectionVertex` | 上述点在 ambient 空间中的值 | 公开对象 simp 接口 |
| `centralIntersectionConnector` | 交集基点到中央点的规范 connector | 公开几何对象；07--15 暂无直接引用 |
| `gridCellVertexPotentialFromIntersection` | 任意交集参考产生格角 potential | 07、11--13 |
| `connectorChange_cast_four_endpoints_right` | 四端点 transport 的可复用规范化 | 11、13 |
| `gridCellVertexPotentialFromIntersectionOfLabel` | 显式标签承载的格角 potential | 11、13 |
| `gridCellVertexPotentialFromIntersectionOfLabel_eq` | 显式标签 transport 的 proof independence | 11、13 |
| `centralInternalTransitions_square` | 任意标签的统一中央 transition 方格 | 07、08 |

## Private proof plumbing

39 项 private 包括四个方向的中央点-to-piece 识别、四个命名中央 potentials、交集 connector/cast
中间引理、八条 switch-side potential 识别及四条聚合、四条 common-edge 识别、四条真实 internal
edge 识别、mixed 分支方格，以及全同标签分支的 common transition 包装与组装。它们只证明最终
`centralInternalTransitions_square`，07--15 没有直接消费者。

## 概念与签名分类

Mathlib 的 `Path`、`FundamentalGroup`、`MonoidHom`、`Monoid.PushoutI` 继续作为正式承载；本模块没有
替代这些结构。公开交集点/connector 是几何对象，两个 potential 构造和 cast 引理是后续真实消费的
组合接口，`centralInternalTransitions_square` 是唯一 coherence 出口。Bool 分支只区分覆盖标签，
不以有限枚举替代一般非交换群证明。

## 验证计划与证据

- 收缩研究候选完整编译；aggregate 只 `#check` 九项 public，并验证 16 种标签排列的分支覆盖。
- 未修改 07 `VanKampenFramedGridBoundary` 直接消费收缩后的正式接口并完整编译。
- 08 的直接独立编译需要尚未迁入正式库的 07b `VanKampenRowAnchoring`；其源码引用只指向最终
  `centralInternalTransitions_square`，不据此越过 release train。
- 正式目标模块、临时 aggregate、代表性公理、Entry mapper、禁用项与 `git diff --check` 在提交前复核。
