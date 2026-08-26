# Topology handoff：AT1-VK3b-03 异标签公共边

## 范围、基线与权限

- 分支：`codex/topology-foundations`；同步 Main `96cfc1c`，merge `5cf4abf`。
- 权限：`main-b0fd028-vk3b01-accepted-vk3b02-03-open.md`。
- 本批依赖前一独立提交 `44ccb9d`，只处理异标签公共边、交集 connector、两侧 normalized image 与
  水平/竖直 Pushout relation。
- 不统一同/异标签 transition，不做全网格 telescope、kernel、单射或 van Kampen 同构。

## 文件与 Main-side 建议

- 源码：`SandronesLibrary/Topology/VanKampenSwitchSharedEdge.lean`。
- Entry：`topology.fundamental-group.van-kampen-switch-shared-edge`，唯一 `lean_file` 为上述源码。
- Main 顶层 import、Registry、ROADMAP/RADAR 和生成索引由 Main 集成。

## Public API 与直接消费者

| 声明 | 数学角色 | 直接下游消费者 |
|---|---|---|
| `horizontalSwitchEdgeInIntersection` | 水平异标签公共边的交集道路 | intersection element、piece image |
| `verticalSwitchEdgeInIntersection` | 竖直异标签公共边的交集道路 | intersection element、piece image |
| `coe_horizontalSwitchEdgeInIntersection` | 水平交集边的 ambient 计算式 | piece/coercion 与 edge equality |
| `coe_verticalSwitchEdgeInIntersection` | 竖直交集边的 ambient 计算式 | piece/coercion 与 edge equality |
| `binaryOpenCoverIntersectionConnector` | 交集基点到任意交点的规范 connector | 两方向 intersection element |
| `binaryOpenCoverIntersectionConnector_basepoint` | 基点 connector 严格化为常值道路 | perimeter/gauge 后续化简 |
| `binaryOpenCoverIntersectionPathToPiece` | 交集道路映入指定覆盖成员 | connector/edge piece images |
| `coe_binaryOpenCoverIntersectionPathToPiece` | 上述映射的 ambient 计算式 | 映射与道路识别 |
| `binaryOpenCoverIntersectionConnectorInPiece` | 交集 connector 在成员内的像 | 四套 connector comparison |
| `coe_binaryOpenCoverIntersectionConnectorInPiece` | 成员 connector 的 ambient 计算式 | endpoint/edge equality |
| `binaryOpenCoverBasepoint_eq_intersectionToPiece` | 两种成员基点表示相等 | connector basepoint cast |
| `binaryOpenCoverIntersectionConnectorInPiece_basepoint` | 成员内基点 connector 为常值 | 后续边界规范化 |
| `coe_binaryOpenCoverIntersectionToPiece` | 交集点 inclusion 的 ambient 计算 | endpoint bridge |
| `horizontalSwitchEdgeInPiece` | 水平交集公共边映入任一成员 | normalized piece image |
| `verticalSwitchEdgeInPiece` | 竖直交集公共边映入任一成员 | normalized piece image |
| `coe_horizontalSwitchEdgeInPiece` | 水平成员边的 ambient 计算 | cell-edge equality |
| `coe_verticalSwitchEdgeInPiece` | 竖直成员边的 ambient 计算 | cell-edge equality |
| `binaryVanKampenPushout_of_intersection_eq` | 交集基本群元素的两侧 Pushout 像相等 | 两方向 pushout image equality |
| `horizontalSwitchEdgeIntersectionElement` | 水平公共边的交集基本群元素 | `horizontalSwitchEdge_pushout_images_eq` |
| `verticalSwitchEdgeIntersectionElement` | 竖直公共边的交集基本群元素 | `verticalSwitchEdge_pushout_images_eq` |
| `horizontalSwitchEdge_pushout_images_eq` | 水平交集元素的两成员像在 Pushout 中相等 | normalized equality |
| `verticalSwitchEdge_pushout_images_eq` | 竖直交集元素的两成员像在 Pushout 中相等 | normalized equality |
| `fundamentalGroup_map_correctedLoop` | 基本群诱导映射保持修正环路 | 两方向 piece-image map 定理 |
| `horizontalSwitchEdgePieceImage` | 水平交集修正边在指定成员中的像 | map/normalized 接口 |
| `horizontalSwitchEdgePieceImage_eq_map` | 水平 piece image 等于交集元素的诱导像 | Pushout equality |
| `verticalSwitchEdgePieceImage` | 竖直交集修正边在指定成员中的像 | map/normalized 接口 |
| `verticalSwitchEdgePieceImage_eq_map` | 竖直 piece image 等于交集元素的诱导像 | Pushout equality |
| `horizontalSwitchEdge_pieceImages_pushout_eq` | 两侧水平 piece images 在 Pushout 中相等 | normalized equality |
| `verticalSwitchEdge_pieceImages_pushout_eq` | 两侧竖直 piece images 在 Pushout 中相等 | normalized equality |
| `horizontalSwitchEdge_left_source_eq` | 左格角 connector 与公共边起点对齐 | left comparison |
| `horizontalSwitchEdge_left_target_eq` | 左格角 connector 与公共边终点对齐 | left comparison |
| `horizontalSwitchLeftConnectorComparison` | 左格 connector 与交集 connector 的 comparison | left relation |
| `horizontalSwitchLeftConnectorComparison_relation` | 水平左 comparison 换基式 | left piece relation |
| `horizontalSwitchEdge_right_source_eq` | 右格角 connector 与公共边起点对齐 | right comparison |
| `horizontalSwitchEdge_right_target_eq` | 右格角 connector 与公共边终点对齐 | right comparison |
| `horizontalSwitchRightConnectorComparison` | 右格 connector 与交集 connector 的 comparison | right relation |
| `horizontalSwitchRightConnectorComparison_relation` | 水平右 comparison 换基式 | right piece relation |
| `horizontalSwitchEdgePieceImageNormalized` | 按真实标签规范化的水平成员像 | normalized/最终 relation |
| `horizontalSwitchLeftComparison_leftElement_normalized` | 左 comparison 的公共元素识别 | left piece relation |
| `horizontalSwitchRightComparison_leftElement_normalized` | 右 comparison 的公共元素识别 | right piece relation |
| `horizontalSwitchEdgePieceImageNormalized_eq` | 规范像等于任意指定标签像 | normalized Pushout equality |
| `horizontalSwitchEdgeInLeftPiece_eq_cellEdge` | 成员公共边识别为左格真实边 | left right-element 识别 |
| `horizontalSwitchLeftComparison_rightElement` | 左 comparison 右元素为左格边元素 | left piece relation |
| `horizontalSwitchLeft_pieceElement_relation` | 左格边元素与 normalized common 的关系 | 最终水平 relation |
| `horizontalSwitchEdgeInRightPiece_eq_cellEdge` | 成员公共边识别为右格真实边 | right right-element 识别 |
| `horizontalSwitchRightComparison_rightElement` | 右 comparison 右元素为右格边元素 | right piece relation |
| `horizontalSwitchRight_pieceElement_relation` | 右格边元素与 normalized common 的关系 | 最终水平 relation |
| `horizontalSwitchEdge_normalized_pushout_eq` | 两真实标签 normalized 像在 Pushout 中相等 | 最终水平 relation |
| `edgeElements_eq_of_change_relations` | 两换基式与共同元素等式的纯群消元 | 两个最终 relation、VK3b-04 |
| `horizontalSwitchEdge_pushout_relation` | 水平异标签公共边最终 Pushout 关系 | VK3b-04 edge gauge |
| `verticalSwitchEdge_bottom_source_eq` | 下格 connector 与竖直公共边起点对齐 | bottom comparison |
| `verticalSwitchEdge_bottom_target_eq` | 下格 connector 与竖直公共边终点对齐 | bottom comparison |
| `verticalSwitchEdge_top_source_eq` | 上格 connector 与竖直公共边起点对齐 | top comparison |
| `verticalSwitchEdge_top_target_eq` | 上格 connector 与竖直公共边终点对齐 | top comparison |
| `verticalSwitchBottomConnectorComparison` | 下格 connector 与交集 connector comparison | bottom relation |
| `verticalSwitchBottomConnectorComparison_relation` | 竖直下 comparison 换基式 | bottom piece relation |
| `verticalSwitchTopConnectorComparison` | 上格 connector 与交集 connector comparison | top relation |
| `verticalSwitchTopConnectorComparison_relation` | 竖直上 comparison 换基式 | top piece relation |
| `verticalSwitchEdgePieceImageNormalized` | 按真实标签规范化的竖直成员像 | normalized/最终 relation |
| `verticalSwitchBottomComparison_leftElement_normalized` | 下 comparison 的公共元素识别 | bottom piece relation |
| `verticalSwitchTopComparison_leftElement_normalized` | 上 comparison 的公共元素识别 | top piece relation |
| `verticalSwitchEdgePieceImageNormalized_eq` | 竖直规范像等于指定标签像 | normalized Pushout equality |
| `verticalSwitchEdgeInBottomPiece_eq_cellEdge` | 成员公共边识别为下格真实边 | bottom right-element 识别 |
| `verticalSwitchBottomComparison_rightElement` | 下 comparison 右元素为下格边元素 | bottom piece relation |
| `verticalSwitchBottom_pieceElement_relation` | 下格边与 normalized common 的关系 | 最终竖直 relation |
| `verticalSwitchEdgeInTopPiece_eq_cellEdge` | 成员公共边识别为上格真实边 | top right-element 识别 |
| `verticalSwitchTopComparison_rightElement` | 上 comparison 右元素为上格边元素 | top piece relation |
| `verticalSwitchTop_pieceElement_relation` | 上格边与 normalized common 的关系 | 最终竖直 relation |
| `verticalSwitchEdge_normalized_pushout_eq` | 两真实标签竖直 normalized 像相等 | 最终竖直 relation |
| `verticalSwitchEdge_pushout_relation` | 竖直异标签公共边最终 Pushout 关系 | VK3b-04 edge gauge |

表中 70 项与 Entry mapper 一一对应；后续可以由 VK3b-04 只选择稳定的最终 relation 与必要 connector
change 接口，不需要重新暴露本文件内部证明状态。

## 概念与公开签名分类

| 概念 | 教材语义 | Lean 正式承载／刻画 | 复用或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|
| 异标签公共边 | 相邻格公共边因标签不同而同时落在 `U∩V` | 两个 `*SwitchEdgeInIntersection` 与 coercion | 本库桥，复用 VK3a 整边成员性 | intersection element | 本 Entry |
| 交集 connector | 从公共基点到交集点的道路 | `binaryOpenCoverIntersectionConnector`，基点计算式严格化 | Mathlib `IsPathConnected.joinedIn` 选路，本库冻结规范 | comparisons | 本 Entry |
| Pushout 交集识别 | 同一交集群元素的两侧像在 amalgamated free product 相等 | `binaryVanKampenPushout_of_intersection_eq` | Mathlib `Monoid.PushoutI.of_apply_eq_base` 正式代数承载 | image equality | 本 Entry |
| normalized piece image | 交集修正边映入真实标签成员后的统一表示 | 两类 `*PieceImageNormalized` | 本库连接几何与 Pushout | 最终 relation | 本 Entry |

公开签名中的 `IsPathConnected (U ∩ V)` 正是选择 connector 所需教材前提；`Path`、
`FundamentalGroup.map/fromPath` 和 `Monoid.PushoutI` 是已解释的正式承载。Bool 分类、商代表元计算、
cast 与 proof irrelevance 是证明后端。没有开放性、覆盖全空间或全局 telescope 泄漏。

## 证明审核与验证

人工 tactic 审核覆盖整边交集成员、交集选路、Pushout 唯一识别、诱导映射保持 corrected loop、Bool
方向分类、纯非交换群消元与两个最终关系。新 tactic linter 在正式基线上发现一处宽泛 `simp` 与一处
命令内空行；已改为精确 `simp only` 加显式 Bool 分支并清除格式警告，重建零警告。

正式模块独立构建 1752 jobs 通过。formal aggregate 检查 18 项冻结核心接口；尚未开放正式迁移的
VK3b-04 研究候选直接 import 本模块并完整编译，证明两个最终 relation 是真实下一层接口而非装饰。
Pushout 交集识别、诱导映射、纯群消元与两个最终 relation 的公理集合不超过 `propext`、
`Classical.choice`、`Quot.sound`（纯群消元仅 `propext`）。Entry mapper 精确映射 70 项公开声明；
禁用项、唯一声明与 `git diff --check` 通过。
