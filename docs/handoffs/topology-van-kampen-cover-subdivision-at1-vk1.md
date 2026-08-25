# Topology AT1-VK1 handoff：二开集覆盖道路细分

## 范围与权限

- 分支：`codex/topology-foundations`
- 数学与文档提交：`7db1ab9`。
- Main 基线：`1af9a64`，以 merge 方式同步，学科分支同步提交为 `d9c6b5c`。
- 权限来源：`review-inbox/topology/main-7cc53d9-f2c3-r2-accepted-and-at1-permissions.md`、
  `main-26817dd-sync-and-at1-open.md` 与 `main-1af9a64-sync-notice.md`。
- 正式范围严格限于 AT1-VK1：二开集覆盖下有限带标签 `Path.subpath` 数据、逐段像归属、标签切换
  顶点落在交集以及有限拼接同伦。

## 文件

- `SandronesLibrary/Topology/VanKampenCoverSubdivision.lean`
- `docs/entries/topology/fundamental-group/van-kampen-cover-subdivision.md`
- `docs/handoffs/topology-van-kampen-cover-subdivision-at1-vk1.md`

建议 Main 集成时把模块加入 `SandronesLibrary.lean`，并登记 Entry
`topology.fundamental-group.van-kampen-cover-subdivision`；学科分支不修改共享聚合文件或 Registry。

## 核心概念清单

| 概念 | 教材语义 | Lean 正式承载 | 展开／刻画 | Mathlib 角色 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 二元覆盖标签 | `false/true` 分别选 `U/V` | `binaryOpenCoverPiece` | 按 Bool 分支定义 | 本库特殊有限数据 | `BinaryOpenCoverSubdivision.subpath_mem` | 本 Entry |
| 一致单位区间网格 | 第 `i` 点为 `i/N` | `unitIntervalMeshPoint` | 首末点、相邻有序、相邻距离公式 | `unitInterval` 为语义一致承载 | `exists_binaryOpenCoverSubdivision` | 本 Entry |
| 子道路 | 原道路在闭子区间上的线性重参数化 | Mathlib `Path.subpath` | `subpath_range` 使用 `range_subpath_of_le` | 语义一致的正式承载 | `BinaryOpenCoverSubdivision` | 本 Entry |
| 有限带标签细分 | 正整数段数、逐段标签与包含证明 | `Path.BinaryOpenCoverSubdivision` | 字段 `steps/steps_pos/label/subpath_mem` | 本库新增课程结构 | `switchVertex_mem_intersection` | 本 Entry |
| 有限子道路拼接 | 按网格顺序拼接各段 | Mathlib `Path.concat` | `concatSubpaths_homotopic` | 语义一致的正式承载 | 同名公开定理 | 本 Entry |
| 端点相对道路同伦 | 拼接道路可在固定端点下变形为全段子道路 | Mathlib `Path.Homotopic` | `Path.Homotopic.concat_subpath` | 已有课程承载和桥侧定理 | `concatSubpaths_homotopic` | 本 Entry |

## 公开签名与复用审核

- 第 1 类正式承载：`Path`、`Path.subpath`、`Path.concat`、`Path.Homotopic`、`unitInterval`、
  `IsOpen`、`Set.Icc`。文档逐项说明教材语义；没有为 Mathlib 现成子道路重造同构结构。
- 第 2 类本库接口：`binaryOpenCoverPiece`、`unitIntervalMeshPoint`、
  `Path.BinaryOpenCoverSubdivision`，用于冻结有限标签数据和一致网格证书。
- 第 3 类证明后端：`lebesgue_number_lemma_of_metric`、`Real.exists_nat_pos_inv_lt`、
  `Set.Icc.convexComb` 与经典有限选择；这些不加强原空间的公开假设。
- 第 4 类公开泄漏：未发现。
- RFC 中试验过的自建 `affineUnitInterval/pathSegment` 已废弃且没有迁入；正式源码真实调用
  `Path.subpath`、`Path.range_subpath_of_le`、`Path.concat` 和 `Path.Homotopic.concat_subpath`。

## 数学陈述和诚实边界

存在性只假设 `U,V` 开且道路逐点属于二者之一；不要求空间 `X` 可度量，因为 Lebesgue 数只应用于
参数空间 `unitInterval`。切换顶点结论要求显式给出两个段共享该顶点及标签不同。拼接结果以首末网格
点之间的全段 `p.subpath` 为右端，并由独立 simp 定理确认网格首末为 `0,1`。

本批没有构造 van Kampen 典范映射，不证明满射、单射、推送性质或基本群同构。AT1-VK2、VK3 和
T4-R3 仍是 `research_open`，不能稳定依赖它们。

## 验证

- `lake env lean SandronesLibrary/Topology/VanKampenCoverSubdivision.lean`：通过。
- `lake build SandronesLibrary.Topology.VanKampenCoverSubdivision`：通过，构建该模块依赖闭包
  `1735 jobs`；这不是全库构建。
- `/tmp/sandrones-library/VanKampenCoverSubdivisionAggregate.lean`：通过；同时导入正式模块并
  `#check` 十一条本库公开声明，以及 `Path.subpath`、`Path.range_subpath_of_le`、`Path.concat`、
  `Path.Homotopic.concat_subpath`、`lebesgue_number_lemma_of_metric` 五个真实复用接口。
- `scripts.check_axioms.map_entry_to_decl`：Entry 精确映射十一条公开声明，包括核心 `structure`，
  没有吸入相邻 Entry。
- 七项代表性 `#print axioms` 均为 `propext`、`Classical.choice`、`Quot.sound`。
- 正式三文件的 `sorry`、`admit`、`sorryAx`、`native_decide`、冲突标记扫描通过；无新增全局
  `instance`，无 `affineUnitInterval/pathSegment`；`git diff --check` 通过。
- 学科负责人未运行全库 `lake build`，留给 Main 集成后执行。

## 子 Agent 与负责人审核

本批未派子 Agent。学科负责人亲自检查了临时原型、Mathlib 复用边界、正式迁移、课程文档和全部
验证；Main 可直接按上述文件和提交复验。
