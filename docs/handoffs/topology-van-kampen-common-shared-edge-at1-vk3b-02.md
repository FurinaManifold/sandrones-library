# Topology handoff：AT1-VK3b-02 同标签公共边

## 范围、基线与权限

- 分支：`codex/topology-foundations`；同步 Main `b0fd028`。
- 权限：`main-b0fd028-vk3b01-accepted-vk3b02-03-open.md`。
- 本批只处理同标签相邻小格的公共边与换 connector 关系。修正版候选已排除四项 switch-edge 声明；
  不含交集道路连通、Pushout relation、全局抵消、kernel、单射或同构。
- 直接依赖 Main 的 VK3b-01 `VanKampenHomotopySquareBoundary`。

## 文件与 Main-side 建议

- 源码：`SandronesLibrary/Topology/VanKampenCommonSharedEdge.lean`。
- Entry：`topology.fundamental-group.van-kampen-common-shared-edge`，唯一 `lean_file` 为上述源码。
- Main 顶层 import、Registry、ROADMAP/RADAR 与生成索引由 Main 集成。

## Public API 与直接消费者

| 声明 | 数学角色 | 直接下游消费者 |
|---|---|---|
| `correctedLoop_change_connectors` | 同一有向边在两套端点 connector 下的非交换群换基公式 | `CommonEdgeConnectorComparison.rightElement_eq` |
| `correctedLoop_cast` | 同时 transport 三条道路不改变修正环路 | 本文件 element 识别、VK3b-03 |
| `correctedLoop_cast_proof_irrel` | 独立端点等式证明下的 cast 稳定性 | VK3b-03 switch comparison |
| `horizontalCommonEdgeInPiece` | 水平相邻格共享竖边的共同 piece 提升 | 水平 comparison 与 VK3b-04 |
| `coe_horizontalCommonEdgeInPiece` | 水平公共边强制转换回环境空间的逐点计算 | edge equality 与后续几何识别 |
| `verticalCommonEdgeInPiece` | 竖直相邻格共享横边的共同 piece 提升 | 竖直 comparison 与 VK3b-04 |
| `CommonEdgeConnectorComparison` | 同一边、左右两套起终 connector 的通用数据 | 两方向 comparison；VK3b-03/04 |
| `CommonEdgeConnectorComparison.leftElement` | 左 connector 产生的修正边元素 | `rightElement_eq`、两方向 element 识别 |
| `CommonEdgeConnectorComparison.rightElement` | 右 connector 产生的修正边元素 | `rightElement_eq`、两方向 element 识别 |
| `CommonEdgeConnectorComparison.startChange` | 起点 connector-change 元素 | `rightElement_eq`、后续 transition |
| `CommonEdgeConnectorComparison.endChange` | 终点 connector-change 元素 | `rightElement_eq`、后续 transition |
| `CommonEdgeConnectorComparison.rightElement_eq` | `endChange⁻¹ * left * startChange = right` | 两方向 relation 与 VK3b-04 |
| `gridCellMapInPieceOfLabel` | 显式给定标签下的小格 piece 映射 | 端点 bridge、VK3b-03 |
| `coe_gridCellVertexInPieceOfLabel` | 显式标签小格顶点强制转换的计算式 | `gridCellMapInPieceOfLabel` 与端点 bridge |
| `coe_gridCellMapInPieceOfLabel` | 显式标签小格映射强制转换的计算式 | 小格边逐点识别 |
| `gridCellMapInPieceOfLabel_unitSquareGridVertex` | 显式标签映射在四角的计算式 | 八条端点 bridge |
| `horizontalCommonEdge_source_eq_left` | 水平公共边起点等于左格对应角 | 水平 comparison 构造 |
| `horizontalCommonEdge_source_eq_right` | 水平公共边起点等于右格对应角 | 水平 comparison 构造 |
| `horizontalCommonEdge_target_eq_left` | 水平公共边终点等于左格对应角 | 水平 comparison 构造 |
| `horizontalCommonEdge_target_eq_right` | 水平公共边终点等于右格对应角 | 水平 comparison 构造 |
| `verticalCommonEdge_source_eq_bottom` | 竖直公共边起点等于下格对应角 | 竖直 comparison 构造 |
| `verticalCommonEdge_source_eq_top` | 竖直公共边起点等于上格对应角 | 竖直 comparison 构造 |
| `verticalCommonEdge_target_eq_bottom` | 竖直公共边终点等于下格对应角 | 竖直 comparison 构造 |
| `verticalCommonEdge_target_eq_top` | 竖直公共边终点等于上格对应角 | 竖直 comparison 构造 |
| `verticalCommonEdgeConnectorComparison` | 竖直相邻格的通用 comparison 实例 | 后续竖直 relation/transition |
| `verticalCommonEdgeConnectorComparison_relation` | 竖直 comparison 的通用换基式 | `verticalCommonEdge_pieceElements_relation` |
| `coe_verticalCommonEdgeInPiece` | 竖直公共边强制转换回环境空间的逐点计算 | edge equality 与后续几何识别 |
| `verticalCommonEdge_eq_bottomCellEdge` | 公共边识别为下格局部边 | 左 element 识别 |
| `verticalCommonEdge_eq_topCellEdge` | 公共边识别为上格局部边 | 右 element 识别 |
| `gridCellBasedHorizontalEdgeInPieceOfLabel` | 显式标签下的单格水平 based edge | 竖直公共边 element 识别、VK3b-03 |
| `verticalCommonEdgeComparison_leftElement` | comparison 左元素等于下格真实边元素 | 最终竖直 relation |
| `verticalCommonEdgeComparison_rightElement` | comparison 右元素等于上格真实边元素 | 最终竖直 relation |
| `verticalCommonEdge_pieceElements_relation` | 竖直同标签公共边的稳定最终关系 | VK3b-04 edge gauge |
| `horizontalCommonEdgeConnectorComparison` | 水平相邻格的通用 comparison 实例 | 后续水平 relation/transition |
| `horizontalCommonEdgeConnectorComparison_relation` | 水平 comparison 的通用换基式 | 最终水平 relation |
| `horizontalCommonEdge_eq_leftCellEdge` | 公共边识别为左格局部边 | 左 element 识别 |
| `horizontalCommonEdge_eq_rightCellEdge` | 公共边识别为右格局部边 | 右 element 识别 |
| `horizontalCommonEdgeComparison_leftElement` | comparison 左元素等于左格真实边元素 | 中间/最终水平 relation |
| `gridCellBasedVerticalEdgeInPieceOfLabel` | 显式标签下的单格竖直 based edge | 水平公共边 element 识别、VK3b-03 |
| `horizontalCommonEdge_leftCell_relation` | 通用式先改写左格元素的中间公开关系 | `horizontalCommonEdge_pieceElements_relation` |
| `horizontalCommonEdgeComparison_rightElement` | comparison 右元素等于右格真实边元素 | 最终水平 relation |
| `horizontalCommonEdge_pieceElements_relation` | 水平同标签公共边的稳定最终关系 | VK3b-04 edge gauge |

上述表完整列出源码公开声明。端点 bridge 和显式标签 based-edge 接口存在真实跨模块消费者；没有把
switch-edge 或后续 gauge 状态提前公开。

## 概念与公开签名分类

| 概念 | 教材语义 | Lean 正式承载／刻画 | 复用或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|
| 同标签公共边 | 相邻两格共享的同一几何边且落在同一覆盖成员 | `horizontal/verticalCommonEdgeInPiece` 与 coercion 计算 | 本库几何桥；复用 `pathCodRestrict` | connector comparison | 本 Entry |
| connector change | 同一点两条基点连接所围成的基环路 | `startChange/endChange`，由常值中段 `correctedLoop` 给出 | 扩展中性 corrected-loop 语言 | `rightElement_eq` | 本 Entry |
| 公共边 comparison | 一条定向边及左右两套端点 connector | `CommonEdgeConnectorComparison` 字段与四派生元素 | Mathlib 无此依赖数据结构；本库真实需要 | 两方向 relation | 本 Entry |
| piece 基本群元素 | 覆盖成员内的修正边同伦类 | Mathlib `FundamentalGroup.fromPath` | 语义一致正式承载 | comparison elements | 基本群既有 Entry |

`Path.cast/trans/symm`、`FundamentalGroup` 和 `IsPathConnected` 是已解释的正式承载；subtype 道路提升
通过本库 `pathCodRestrict`。具体 `Quotient.mk`、proof irrelevance 和逐点 cast 只作证明后端。公开
签名没有交集道路连通或 Pushout，因此没有越过本批学科边界。

## 证明审核与验证

人工 tactic 审核覆盖换 connector 公式、cast 稳定、公共边成员、通用 comparison、edge equality、
cell-word element 识别与两个最终 relation。正式模块独立构建 1751 jobs 通过；修正版 VK3b-03
直接 import 正式 VK3b-02 并完整编译。formal aggregate 检查冻结的核心接口；Entry mapper 精确映射
42 项公开声明。换 connector、通用 comparison 与水平/竖直最终 relation 的代表公理集合均只有
`propext`、`Classical.choice`、`Quot.sound`。禁用项、switch-edge、交集道路连通、Pushout 泄漏及
`git diff --check` 扫描通过。
