# Topology handoff：AT1-VK3b-05 VertexPotential

## 范围、基线与权限

- 分支：`codex/topology-foundations`；依赖前一独立提交 `895d097`。
- 权限：`main-1c4d306-vk3b02-03-accepted-vk3b04-06-open.md`。
- 本批建立 connector cocycle、potential transition 与同标签中央 coherence；不包含 06 混合标签统一、
  07 telescope、kernel、单射或同构。
- public surface 经 06 及 11--15 引用审计收缩为 40 public、23 private。

## 文件与 Main-side 建议

- 源码：`SandronesLibrary/Topology/VanKampenVertexPotential.lean`。
- Entry：`topology.fundamental-group.van-kampen-vertex-potential`，唯一 `lean_file` 为上述源码。
- 两个最终 potential 构造只在本模块声明一次；Main 顶层 import、Registry 与生成文件由 Main 集成。

## Public API 与直接消费者

| 声明 | 数学角色 | 直接下游消费者 |
|---|---|---|
| `connectorChange` | 同一点两 connector 的基本群变化 | 06、07、11--15 |
| `connectorChange_mul` | connector change cocycle | 本模块通用定律 |
| `connectorChange_self` | 自身变化为一 | 通用计算接口 |
| `connectorChange_reverse` | 反向变化为逆元 | common potential 证明 |
| `fundamentalGroup_map_connectorChange` | 连续映射自然性 | VK3b-11 |
| `map_connectorChange_mul` | 群同态下的 cocycle | VK3b-13 |
| `startChange_eq_connectorChange` | comparison 起点 change 的语义 | common potential 证明 |
| `endChange_eq_connectorChange` | comparison 终点 change 的语义 | common potential 证明 |
| `connectorChange_square` | 四 connector 的方格 cocycle | 中央 coherence 核心 |
| `transitionFromPotentials` | `target * source⁻¹` transition | 06、11--15 |
| `rebaseEdge_transitionFromPotentials` | potential transition 下的重基化简 | 常值边规范化 |
| `connectorChange_eq_transitionFromPotentials` | change 等于参考 potential 比值 | common/switch potential |
| `rebase_correctedLoop_refl_eq_one` | 常值中段修正环路重基后为一 | 映射版本 |
| `map_transitionFromPotentials` | 群同态保持 potential transition | 通用自然性接口 |
| `map_rebaseEdge` | 群同态保持重基 | 07、15 的边界映射链 |
| `map_rebase_correctedLoop_refl_eq_one` | 常值修正环路的映射重基为一 | 后续稳定版本 |
| `map_rebase_correctedLoop_eq_one_of_segment_eq_refl` | 已知中段严格常值时的映射结论 | cast 版本 |
| `map_rebase_correctedLoop_eq_one_of_cast_eq_refl` | 中段经端点 cast 后常值时重基为一 | 07、15 |
| `transitionFromPotentials_self` | 同 potential transition 为一 | 计算接口 |
| `transitionFromPotentials_mul` | potential transition 严格复合 | VK3b-13 |
| `transitionFromPotentials_square` | 方格两路 transition 相等 | edge square |
| `rebaseEdge_potential_transition` | potential frame 下重基展开 | 稳定纯群接口 |
| `edgeTransitions_gridVertex_square` | 四边 transition 来自四 potential 时的方格关系 | VK3b-06 |
| `horizontalSwitchEdgeTransitions_start_potential` | 水平 switch 起 change 的 potential 表示 | VK3b-06 |
| `horizontalSwitchEdgeTransitions_end_potential` | 水平 switch 终 change 的 potential 表示 | VK3b-06 |
| `verticalSwitchEdgeTransitions_start_potential` | 竖直 switch 起 change 的 potential 表示 | 06、13 |
| `verticalSwitchEdgeTransitions_end_potential` | 竖直 switch 终 change 的 potential 表示 | 06、13 |
| `transitionFromConnectorPotentials` | connector potentials 直接产生 transition | common 证明 |
| `map_transitionFromConnectorPotentials` | 其群同态版本 | common 证明 |
| `map_startChange_inv` | comparison 起 change 逆元映射为直接 change | 06、11、13 |
| `map_endChange_inv` | comparison 终 change 逆元映射为直接 change | 06、11、13 |
| `map_startChange_inv_eq_potentials` | 起 change 逆元等于 potential 比值 | 06、11--13 |
| `map_endChange_inv_eq_potentials` | 终 change 逆元等于 potential 比值 | 06、11--13 |
| `connectorChange_cast` | endpoint transport 下 change 稳定 | 11、15 |
| `connectorChange_cast_proof_irrel` | 独立等式证明下的 cast 稳定 | VK3b-06 |
| `horizontalCommonEdgeConnectorComparisonOfLabel` | 显式 Bool 标签的水平 common comparison | VK3b-06 |
| `verticalCommonEdgeConnectorComparisonOfLabel` | 显式 Bool 标签的竖直 common comparison | VK3b-06 |
| `commonCentralTransition_square_of_label` | 全同标签中央 transition 方格关系 | VK3b-06 |
| `binaryOpenCoverVertexPotentialFromIntersection` | 交集规范 connector 参考的 vertex potential | VK3b-11--13 |
| `binaryOpenCoverConnectorPotential` | 同 piece 任意参考 connector 的 potential | VK3b-11、13 |

## Private proof plumbing

23 项 private 包括：`map_connectorChange_square`；四条 common transition 中间 change 定理；抽象
`commonEdgeComparisons_gridVertex_square`；三条未包装中央顶点识别；六条 label-cast coercion；三条
OfLabel 中央顶点识别及四条中央 connector 识别。它们只服务本文件最终
`commonCentralTransition_square_of_label`，06 及以后没有直接引用。

## 概念与签名分类

Mathlib `Path`、`FundamentalGroup`、`MonoidHom` 和 `Monoid.PushoutI` 是正式承载；本库
`connectorChange`、`transitionFromPotentials` 及两个 potential 构造填补具体组合接口。依赖类型 cast
与私有中央识别链属于证明后端。无新实例、重复 potential 定义或越过混合标签边界的接口。

## 验证

- 收缩候选与正式模块分别完整编译；正式构建 1754 jobs，零警告。
- 未修改 VK3b-06 候选直接消费收缩 05 `.olean` 并完整编译。
- 06 及 11--15 引用矩阵确认 40 public 的消费者并证明 23 private 无下游引用。
- 正式 aggregate 检查 connector cocycle、potential 群律、映射/重基桥、06 中央出口及两个最终构造。
- 纯群 potential/square 证明只依赖 `propext`；具体道路与 Pushout 接口不超过标准
  `propext`、`Classical.choice`、`Quot.sound`。
- Entry mapper 精确映射 40 public 并跳过 23 private；两个最终 potential 构造全库各唯一声明。
- 禁用项、唯一声明和 `git diff --check` 通过。
