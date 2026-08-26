# Topology AT1-VK3b-01 handoff：单格方形边界词

## 范围与权限

- 分支：`codex/topology-foundations`。
- Main 基线：`679dc3f`；同步合并：`19ceaca`。
- 权限来源：`review-inbox/topology/main-679dc3f-vk3a-accepted-vk3b01-open.md`。
- 本批严格止于 VK3b-01：道路同伦参数方形、单格四边定向、单格提升、四角 connector、piece 内
  单格边界词及其 Pushout 像为单位元。
- VK3b-02 以后 common/switch shared edge、gauge、有限网格抵消、kernel 消失、单射和最终等价仍为
  `research_open`，没有迁入正式目录。

## 文件

- `SandronesLibrary/Topology/VanKampenHomotopySquareBoundary.lean`
- `docs/entries/topology/fundamental-group/van-kampen-cell-boundary.md`
- `docs/handoffs/topology-van-kampen-cell-boundary-at1-vk3b-01.md`

正式源码增加了统一版权头、模块 docstring 与
`topology.fundamental-group.van-kampen-cell-boundary` 的 `**Entry**` 标记；定义、定理签名和证明主体
与已验收 `/tmp/sandrones-library/vk3b-01-formal-candidate` 一致。Main 集成时再维护共享 aggregate、
Registry、ROADMAP、RANKINGS 和索引文件。

## 数学接口

1. `pathHomotopySquare` 明确 Mathlib `Path.Homotopy` 的第一坐标是同伦参数、第二坐标是道路参数，
   并公开四侧计算规则。
2. `squareGridHorizontalEdge`、`squareGridVerticalEdge` 和 `squareGridCellBoundary` 冻结所有小格采用的
   统一方向：下、上边从左到右，左、右边从下到上。
3. `gridCellMapInPiece` 用 VK3a 的 `cell_mem` 将整个标准单位方形提升到该格标签覆盖成员。
4. `gridCellBoundaryInPiece_eq_one` 用单位方形内部的显式收缩证明单格边界在 piece 基本群中为一。
5. 四角 connector 将四条几何边修正为公共覆盖基点处的群元素；`correctedLoop_reverse_eq_inv` 处理
   上、左两条反向边。
6. `gridCellPieceEdgeWord_eq_one` 得到左逆、上逆、右正、下正的非交换单格边界词。
7. `gridCellPushoutEdgeWord_eq_one` 只用 Pushout 单侧生成元同态保持乘法、逆元和单位元，将该关系
   送入二开覆盖 Pushout。

## 人工 tactic 审核

候选 `TACTIC-REVIEW.md` 已按 Main 的 `LEAN-TACTIC-REVIEW-GUIDE.md` 逐项核对：

- `fun_prop` 只证明网格边复合映射的连续性；
- `gridCellBoundary_mem` 的四个分支分别对应下、右、反向上、反向左边，并由 `D.cell_mem` 给出整条
  边的成员性；
- 显式单位方形收缩和 `Quotient.sound` 承担单格边界零伦的数学内容；
- 三次 `Path.correctedLoop_product` 严格按非交换顺序望远镜消去四角 connector；
- `simp` 只处理常值道路、反向拼接、群同态计算和括号，不证明任何相邻格内部边抵消。

本批使用的 tactic 均在 `LEAN-TACTIC-STATE-ATLAS.md` 已有代表；没有首次引入未覆盖的搜索 tactic。

## 验证证据

- `lake env lean SandronesLibrary/Topology/VanKampenHomotopySquareBoundary.lean`：通过，无输出。
- `lake build SandronesLibrary.Topology.VanKampenHomotopySquareBoundary`：1747 jobs 通过；这是目标模块依赖
  闭包，不是全库构建。
- `/tmp/sandrones-library/vk3b-01-formal-candidate/VK3b01Aggregate.lean` 在正式 import 路径下通过，
  `#check` 覆盖 24 个冻结代表接口。
- `scripts.check_axioms.map_entry_to_decl` 将该 Entry 精确关联到本文件 40 个公开声明。
- 五个代表性声明的 `#print axioms` 均只有 `propext`、`Classical.choice`、`Quot.sound`：
  `pathHomotopySquare`、`gridCellBoundaryInPiece_eq_one`、`correctedLoop_reverse_eq_inv`、
  `gridCellPieceEdgeWord_eq_one`、`gridCellPushoutEdgeWord_eq_one`。
- 正式源码禁用项扫描无 `sorry`、`admit`、`sorryAx`、`native_decide`、heartbeat override、
  `trace_state`、正式 `#check`、新增 `axiom` 或 `unsafe`。
- `git diff --check` 通过。

## 诚实边界

本批只能推出“每个小格自身的边界词为一”。相邻小格即使共享同一条几何边，也可能使用不同标签、
不同 connector 和不同 subtype 表示；因此不能从本批直接 `simp` 出内部边抵消。Main 验收 VK3b-01
前，不请求开放或正式迁移 VK3b-02 以后内容。
