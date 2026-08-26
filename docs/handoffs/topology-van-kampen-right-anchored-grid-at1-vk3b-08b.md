# Topology handoff：AT1-VK3b-08b RightAnchoredGrid

## 范围、基线与权限

- 分支：`codex/topology-foundations`；直接依赖 Main `26b2092` 的正式 VK3b-08a。
- 开工基线：merge `68ec4b7` 同步到 `main@26b2092`。
- 权限：`main-vk3b08b-public-surface-approved-dependency-gated.md`；08a 进入 Main 后已自动转为
  `development_open`。
- 本批止于二维右锚定与完整左边界 holonomy 消去；不包含 VK3b-09 letter word、kernel、单射或同构。
- Main 已冻结 10 public / 12 private 的接口。

## 文件与 Main-side 建议

- 源码：`SandronesLibrary/Topology/VanKampenRightAnchoredGrid.lean`。
- Entry：`topology.fundamental-group.van-kampen-right-anchored-grid`。
- 顶层 import、Registry、生成索引和 ROADMAP 由 Main 集成。

## Public API 与直接消费者

| 声明 | 数学角色 | 直接消费者 |
|---|---|---|
| `VerticalCellFramesCompatible` | 单格上下两行的竖直 frame 相容 | 12、13 |
| `rightAnchoredGridRowFramesAt` | 二维右锚定 frames | 09、12--14 |
| `rightAnchoredGridRowFramesAt_compatible` | 每行水平相容 | 09、12、14 |
| `rightAnchoredGridRowFramesAt_vertical_compatible` | 相邻行逐列竖直相容 | 12、13 |
| `rightAnchoredGridRowFramesAt_horizontal_edges` | 每格横边为一 | 12 |
| `rightAnchoredGridRowFramesAt_right_edge_eq_one` | 每行最右边为一 | 12 |
| `rightAnchoredGridFullRow_leftEdge_eq_leftmost` | completed-row 左端高层投影 | 14 |
| `rightAnchoredGridLeftBoundaryWordAt` | 左边界累计词 | 14 |
| `rightAnchoredGridFullLeftBoundary_eq_reverseRows` | 完整高度 reverse-row telescope | 14 |
| `rightAnchoredGridFullLeftBoundary_eq_one` | 完整左边界 holonomy 为一 | 14 |

## Private proof plumbing

12 项 private：两个纯群下降 helper；抽象/具体 vertical compatibility 组装；last-to-all 与行间传播；
reanchor；逐行 full-row 左边为一；prefix reverseRows；prefix 左边界为一。VK3b-09--15 无直接引用。

## 接口边界

本模块复用 07a full-row 高层投影、07b 横边归一化与 08a frame 唯一性，不读取任何 row-prefix 名称，
也没有第二套 frame structure。后继行最右锚点严格保持
`vertical.endChange * lower.topRight` 的非交换次序；左边界列表使用 `reverseEdgeChainProduct`。

## 验证

- 正式 08b 目标构建通过（1759 jobs，零 warning）；Entry mapper 精确映射 10 public 并跳过
  12 private。
- aggregate 检查二维 frames、四项相容/归一性质、completed-row 投影与两个最终 telescope 出口，
  代表性公理不超过 `propext`、`Classical.choice`、`Quot.sound`。
- 未修改 09 直接消费正式 08b，完整编译通过；12--15 declaration-level 消费表覆盖全部十项 public。
- 禁用项、prefix 零引用、唯一声明和 `git diff --check` 通过。
