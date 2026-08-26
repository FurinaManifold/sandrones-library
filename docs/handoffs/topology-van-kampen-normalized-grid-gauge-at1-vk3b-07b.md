# Topology handoff：AT1-VK3b-07b NormalizedGridGauge

## 范围、基线与权限

- 分支：`codex/topology-foundations`；直接依赖 07a 学科提交 `fd72676`，Main 集成为 `bf6ebcf`。
- 开工基线：merge `bc2c367` 同步到 `main@bf6ebcf`。
- 权限：`main-0637ee9-vk3b06-accepted-07-08-open.md` 的 `development_open`，并满足 Main 要求的
  “07a 进入 Main 后继续 07b”依赖门。
- 本批止于二维 gauge 与左右 holonomy 相等；不包含 08 right anchoring、kernel、单射或同构。
- public surface 从 36 public / 1 private 收缩为 17 public / 20 private。

## 文件与 Main-side 建议

- 源码：`SandronesLibrary/Topology/VanKampenNormalizedGridGauge.lean`。
- Entry：`topology.fundamental-group.van-kampen-normalized-grid-gauge`。
- 顶层 import、Registry、生成索引和 ROADMAP 由 Main 集成。

## Public API 与直接消费者

| 声明 | 数学角色 | 直接消费者 |
|---|---|---|
| `gridCellVertexInPiece_bottom_eq_basepoint` | 最下行格角等于基点 | 11、15 |
| `gridCellVertexInPiece_top_eq_basepoint` | 最上行格角等于基点 | 11、15 |
| `coe_gridCellTopEdge_eq` | 顶边 ambient 道路识别 | 15 |
| `gridCellVertexInPiece_right_eq_basepoint` | 最右列格角等于基点 | 15 |
| `coe_gridCellRightEdge_eq` | 右边 ambient 道路识别 | 15 |
| `intersectionBasepoint_eq_gridCellVertexInPiece_of_eq_basepoint` | 交集基点映入格角的 dependent 识别 | 11、15 |
| `gridCellBasepointPotential` | 基点参考的格角 Pushout potential | 11、15 |
| `gridCellBottomBoundaryPotential` | 最下边界格角 potential | 15 |
| `gridCellBottomEdge_rebase_eq_one` | 底边按 boundary potentials 重基后为一 | 15 |
| `gaugeNormalizedRowFrames` | 单行水平规范化 frames | 08a |
| `gaugeNormalizedRowFrames_compatible` | 上述 frames 水平相容 | 08a |
| `gaugeNormalizedRowFrames_horizontal_edges` | 每格上下横边重基为一 | 08a |
| `gaugeGridLeftBoundaryWordAt` | 二维 gauge 左累计 holonomy | 本模块最终出口 |
| `gaugeGridRightBoundaryWordAt` | 二维 gauge 右累计 holonomy | 本模块最终出口 |
| `gaugeGridBoundaryWordsAt_left_eq_right` | 每个完成行层级左右累计词相等 | 本模块高层接口 |
| `gaugeGridFullBoundary_left_eq_right` | 完整网格左右 holonomy 相等 | 07b 最终课程出口 |
| `framedFullRow_leftEdge_eq_rightEdge` | 任意横边归一 frames 的完整行左右相等 | 08b |

## Private proof plumbing

20 项 private 包括：bottom edge coercion、常值底边构造及识别；单行 frame 前缀构造；规范单行 prefix/
full-row words 消去；带指定顶部的行提升；二维行 frames 递归及其相容、顶部、竖边、底部证明；二维
prefix/full-row words 消去；二维完整行状态；以及 Main 点名的通用
`framedRowPrefix_horizontal_words_eq_one`。后者只有同文件 full-row theorem 消费，08+ 无直接引用。

## 接口边界

本模块直接复用 07a 的 `CellVertexFrames`，没有第二套 frame structure。从 08a 起，源码、Entry、handoff
和 aggregate 都不需要 `FramedHorizontalRowPrefixState`、`framedHorizontalRowPrefixState` 或任何
`framedRowPrefix_*` 名称；只消费 `framedFullRow_leftEdge_eq_rightEdge` 等完整行高层接口。

## 验证

- 收缩研究候选直接消费正式 07a 并完整编译。
- 该候选 `.olean` 下，未修改 08a 与 08b 依次完整编译；08 源码 prefix-name 搜索为零。
- 正式目标构建、Entry mapper、代表性公理、禁用项和 `git diff --check` 在提交前复核。
- Main 复验确认原临时 `VK3b07Aggregate.lean` 仍检查 07a 后来转为 private 的
  `FocusedBoundary.attachRight`，因此该临时 aggregate 不是本批通过证据；正式模块与未修改 08a
  的直接消费构建才是本批接口验证依据。
- 验证产生的临时 07b/08a `.olean` 已精确清理。
