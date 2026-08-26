# Topology handoff：AT1-VK3b-08a RowAnchoring

## 范围、基线与权限

- 分支：`codex/topology-foundations`；直接依赖 Main `c104b53` 的正式 VK3b-07b。
- 开工基线：merge `bbe813e` 同步到 `main@c104b53`。
- 权限：`main-vk3b08a-public-surface-approved-formal-migration-open.md` 的
  `accepted_for_formal_migration`。
- 本批止于单行右锚定与 frame 唯一性；不包含 08b 二维传播、左边界消失、kernel、单射或同构。
- public surface 经 Main 预审冻结为 10 public / 6 private。

## 文件与 Main-side 建议

- 源码：`SandronesLibrary/Topology/VanKampenRowAnchoring.lean`。
- Entry：`topology.fundamental-group.van-kampen-row-anchoring`。
- 顶层 import、Registry、生成索引和 ROADMAP 由 Main 集成。

## Public API 与直接消费者

| 声明 | 数学角色 | 直接消费者 |
|---|---|---|
| `CellVertexFrames.mulRight` | bottom/top 两层分别统一右乘 gauge | 本模块通用 frames 接口 |
| `rebaseEdge_mulRight` | 两端统一右乘使重基边共轭 | 本模块纯群核心 |
| `rebaseEdge_mulRight_eq_one` | 共轭保持已归一化边为一 | 本模块、08b |
| `HorizontalCellFramesCompatible.mulRight` | 统一右乘保持水平相容 | 本模块通用 frames 接口 |
| `rightAnchoredRowFrames` | 将规范单行最右 frames 锚定到指定值 | 08b |
| `rightAnchoredRowFrames_compatible` | 右锚定行仍水平相容 | 08b |
| `rightAnchoredRowFrames_horizontal_edges` | 右锚定保持每格横边为一 | 08b |
| `rightAnchoredRowFrames_right_edge_eq_one` | 最右真实竖边归一化为一 | 08b |
| `rebaseEdge_startFrame_unique` | 固定 end frame 时 start frame 唯一 | 08b |
| `rebaseEdge_endFrame_unique` | 固定 start frame 时 end frame 唯一 | 本 Entry 对称教材结论 |

## Private proof plumbing

6 项 private 为 `rowFramesMulRight`、`rowFramesMulRight_compatible`、`anchorRowFramesRight`、
`anchorRowFramesRight_last_bottomRight`、`anchorRowFramesRight_last_topRight`、
`anchorRowFramesRight_compatible`。它们只实现最终 `rightAnchoredRowFrames`，08b--15 无直接引用。

## 接口边界

本模块直接复用 07b 的 `gaugeNormalizedRowFrames`、compatibility 与 horizontal-edges，不读取任何
row-prefix 名称。没有第二套 frame structure。前四项纯群/frames 接口无拓扑参数，具体网格实例化只
需要已有道路连通假设，不增加开性或覆盖全空间条件。

## 验证

- 正式 08a 目标构建通过（1758 jobs，零 warning）；未修改 08b 直接消费正式 08a，Lean 编译通过。
- public surface 为 10 public / 6 private；Entry mapper 与实际公理由 Main 集成时复核。
- row-prefix 与禁用项扫描、唯一声明和 `git diff --check` 通过。
