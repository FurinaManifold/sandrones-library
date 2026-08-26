# Topology AT1-VK3a handoff：二开集覆盖方格细分

## 范围与权限

- 分支：`codex/topology-foundations`。
- 数学、源码与文档提交：`04d47b1`。
- Main 基线：`d5144c6`；同步提交：`4e4507d`。
- 权限来源：`review-inbox/topology/main-vk2-accepted-vk3a-open.md`。
- AT1-VK3a 为 `development_open`：本批只交付一致二维网格、逐格 Bool 标签、整格像包含和异标签
  公共边落在交集。VK3b 的四边定向、边界词、内部边抵消和单射仍为 `research_open`。

## 文件

- `SandronesLibrary/Topology/VanKampenSquareSubdivision.lean`
- `docs/entries/topology/fundamental-group/van-kampen-square-subdivision.md`
- `docs/handoffs/topology-van-kampen-square-subdivision-at1-vk3a.md`

建议 Main 集成时加入共享聚合并把 Entry 从 `staging` 登记为已验证；学科分支不修改 Registry、
ROADMAP 或 RADAR。旧 `docs/maintenance/` 研究文件不属于本批集成文件。

## 核心概念清单

| 概念 | 教材语义 | Lean 正式承载 | Mathlib 角色 | 首个真实使用者 |
|---|---|---|---|---|
| 二维闭格参数 | 第 `(i,j)` 个 `1/N` 方格 | `unitSquareCellPoint` | `Icc.convexComb` | `cell_mem` |
| 有限带标签方格网格 | 正整数网格与逐格覆盖选择 | `BinaryOpenCoverSquareSubdivision` | `Fin`, Bool | 两条公共边定理 |
| 方格存在性 | 足够细网格逐格落入覆盖 | `exists_binaryOpenCoverSquareSubdivision` | Lebesgue 数、乘积度量 | 后续零同伦细分 |
| 水平标签切换 | 公共竖边落在交集 | `horizontalSwitchEdge_mem_intersection` | Bool 分类 | VK3b 换片关系 |
| 竖直标签切换 | 公共横边落在交集 | `verticalSwitchEdge_mem_intersection` | Bool 分类 | VK3b 换片关系 |

## 公开签名与复用审核

- 直接复用 VK1 的 `unitIntervalMeshPoint`、相邻网格距离和 `binaryOpenCoverPiece`；未复制一维网格或
  覆盖标签语义。
- 连续方形直接承载为 Mathlib `C(unitInterval × unitInterval, X)`；未自建 Homotopy 或方形映射。
- 新结构只冻结二维有限标签和整格包含数据；两条公共边定理是 VK3b 的真实输入。
- Lebesgue 数与乘积度量只是存在性后端，不泄漏为目标空间假设。
- `/tmp` 中四边定向、单格收缩和覆盖成员基本群关系继续属于 VK3b 研究，不迁入本批正式文件。

## 数学陈述和诚实边界

存在性假设 `U,V` 开且连续方形每点属于二者之一；不要求 `U∪V=Set.univ`，所以接口也可用于只覆盖
该方形像的局部情形。公共边结论给出整条边的逐点交集成员性，而非只给端点。没有构造边界环路，
不证明内部边成对抵消、规范同态单射、群同构或完整 van Kampen 定理。

## 验证

- `lake env lean SandronesLibrary/Topology/VanKampenSquareSubdivision.lean`：通过。
- `lake build SandronesLibrary.Topology.VanKampenSquareSubdivision`：1736 jobs 通过且无 linter 警告；
  这是模块依赖闭包，不是全库构建。
- `/tmp/sandrones-library/VanKampenSquareSubdivisionAggregate.lean`：联合导入并 `#check` 五条本库公开
  声明、两条 VK1 复用接口和五个 Mathlib 承载／证明后端，通过。
- `scripts.check_axioms.map_entry_to_decl`：Entry 精确映射五条公开声明，没有跨文件吸入。
- 三条公开定理的公理均为 `propext`、`Classical.choice`、`Quot.sound`。
- Entry 恰有规定的八节；正式交付文件的禁用占位和冲突标记扫描无结果；无新增全局或局部
  `instance`；`git diff --check` 通过。

## 子 Agent 与负责人审核

本批未派子 Agent。学科负责人亲自完成 Mathlib 复用审核、原型迁移、文档与模块级验证。
