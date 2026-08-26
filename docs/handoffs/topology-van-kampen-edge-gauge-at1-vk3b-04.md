# Topology handoff：AT1-VK3b-04 EdgeGauge

## 范围、基线与权限

- 分支：`codex/topology-foundations`；同步 Main `1c4d306`。
- 权限：`main-1c4d306-vk3b02-03-accepted-vk3b04-06-open.md`。
- 本批统一 common/switch 内部边 relation，建立纯群重基与有限边链 telescope；不含 07 的
  perimeter/row telescope、kernel、单射或同构。
- 依据 Main 预审完成 public-surface shrink：31 public、20 private。

## 文件与 Main-side 建议

- 源码：`SandronesLibrary/Topology/VanKampenEdgeGauge.lean`。
- Entry：`topology.fundamental-group.van-kampen-edge-gauge`，唯一 `lean_file` 为该源码。
- Main 顶层 import、Registry、ROADMAP/RADAR 和生成索引由 Main 集成。

## Public API 与直接消费者

| 声明 | 数学角色 | 直接下游消费者 |
|---|---|---|
| `twoCellBoundary_glue` | 两面词沿反向公共边的纯群粘合 | VK3b-07 perimeter 证明 |
| `rebaseEdge` | 端点 frame 下的定向边重基 | 05、07、08、11--15 |
| `rebaseEdge_one_changes` | 单位 frame 的一手计算律 | 公共构造计算接口 |
| `rebaseEdge_mul_start_eq_one` | 起 frame 为一时的二边合并式 | 07、08 |
| `edgeElements_eq_rebaseEdge_of_change_relations` | connector-change 关系转重基关系 | VK3b-11 |
| `eq_rebaseEdge_of_rebaseEdge_eq` | 反解一次重基方程 | VK3b-11 与本模块 common 分支 |
| `EdgeTransitions` | 内部边起终点 frame 变化数据 | 05--08、11--15 |
| `horizontalCommonEdgeTransitions` | 水平 common 分支 transition | 05、06、11、13 |
| `horizontalSwitchEdgeTransitions` | 水平 switch 分支 transition | 05、06、11 |
| `horizontalInternalEdgeTransitions` | 水平同/异标签统一 transition | 06--08、13、15 |
| `horizontalInternalEdge_relation` | 水平统一重基关系 | in-frame 出口；稳定局部 API |
| `verticalCommonEdgeTransitions` | 竖直 common 分支 transition | 05、06、11、13 |
| `verticalSwitchEdgeTransitions` | 竖直 switch 分支 transition | 05、06、13 |
| `verticalInternalEdgeTransitions` | 竖直同/异标签统一 transition | 06--08、13、15 |
| `verticalInternalEdge_relation` | 竖直统一重基关系 | 08 与 in-frame 出口 |
| `reverseEdgeChainProduct` | 道路约定下的反序有限边词 | 08、14 |
| `reverseEdgeChainProduct_eq_reverse_map_snd_prod` | 反序边词的列表乘积刻画 | 14 |
| `reverseEdgeChainProduct_append` | 拼接链的块次序公式 | 08 |
| `edgeChainEnd` | 从 transitions 计算链末 frame | 14、15 |
| `finLastOfPos` | 正长度有限下标的末元素 | 10、13--15 |
| `finLastOfPos_succ` | 后继长度末元素计算式 | 后续 dependent simplification |
| `edgeChainEnd_ofFn_of_pos` | 正长度 `ofFn` 链末 frame | 14、15 |
| `rebasedEdgeChainProduct` | 逐边重基后的反序边词 | 14 |
| `rebasedEdgeChainProduct_eq_rebaseEdge` | 列表链主 telescope | 14 |
| `rebasedEdgeChainProduct_eq_conj_of_end_eq` | 闭链只剩首 frame 共轭 | 稳定纯群最终出口 |
| `rebasedEdgeChainProduct_ofFn_eq_reverseEdgeChainProduct_of_pos` | 正长度 `Fin` telescope | 14 |
| `reverseDfoldl_eq_reverse_ofFn_prod` | `Fin.dfoldl` 与反序列表词一致 | 14 |
| `gridCellPushoutEdgeWord_rebase_eq_one` | 单格四边任意 frame 下仍为一 | 07 |
| `rebaseEdge_relation_in_frame` | 已有重基关系传播到外层 frame | 08 |
| `horizontalInternalEdge_relation_in_frame` | 水平内部边 relation 的 frame 传播 | 07 |
| `verticalInternalEdge_relation_in_frame` | 竖直内部边 relation 的 frame 传播 | 07 |

Main 点名的 `finLastOfPos`、`edgeChainEnd*`、`reverseDfoldl*` 均经 05--15 源码扫描确认有真实消费者，
所以保留公开；不是把实现辅助无条件暴露。

## Private proof plumbing

以下 20 项无跨模块引用并已改为 private：`rebaseEdge_mul`、`rebaseEdge_inv`、
`rebaseEdge_cycle_four`、两项 switch `*_pushout_rebase`、两项 `gridCellBased*OfLabel_self`、两项
`pushout_*OfLabel_eq`、两项 common `*_pushout_rebase`、四项 common/switch
`*_relation_transitions`、`edgeChainEnd_ofFn_succ`、非正长度 `rebased...ofFn` 中间式、
`rebaseCellBoundary`、`rebaseCellBoundary_eq_one`、`rebaseEdge_rebase`。

## 概念与公开签名分类

`Group`、`List.prod`、`Fin.dfoldl` 是纯群 telescope 的正式承载；`Monoid.PushoutI`、基本群和小格边
来自已解释的 VK3b 前层。`EdgeTransitions` 是本库必要的最小数据桥，只保存两个群元素，不复制边或
证明。标签分类和 20 项局部分支桥均隐藏为证明后端，没有新的全局实例或越级接口。

## 验证

- 正式模块独立构建：1753 jobs，零警告。
- 收缩候选 aggregate 通过；未修改 VK3b-05 候选直接消费收缩 `.olean` 并完整编译。
- 05--15 全候选文本扫描证明 20 项 private 无下游引用，并给出 31 项 public 的消费者清单。
- 正式 aggregate 检查统一 transition、有限链、`Fin`/`dfoldl`、单格重基与 in-frame 出口。
- 代表纯群证明只依赖 `propext`（正长度 `Fin` 出口另含 `Quot.sound`）；具体内部边证明不超过
  `propext`、`Classical.choice`、`Quot.sound`。
- Entry mapper 精确映射 31 项公开声明并自动跳过 20 项 private；禁用项、唯一声明与
  `git diff --check` 通过。
