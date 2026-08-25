# Topology AT1-VK2 handoff：二开集 van Kampen 规范同态满射

## 范围与权限

- 分支：`codex/topology-foundations`。
- Main 基线：`275a6e2`；学科分支同步提交：`4c33273`。
- 权限来源：`review-inbox/topology/main-vk1-accepted-vk2-development-open.md`、
  `main-275a6e2-sync-notice.md` 与 `main-vk2-80f0bdf-followup-review.md`。
- VK2 为 `development_open`。本批同时交付有限带标签段、交集切换点连接、有限修正环路词、
  `Monoid.PushoutI` 规范映射及其满射；不进入 VK3 的单射／同构证明。

## 文件

- `SandronesLibrary/Topology/VanKampenSurjectivity.lean`
- `docs/entries/topology/fundamental-group/van-kampen-surjectivity.md`
- `docs/maintenance/topology-at1-van-kampen-interface.md`
- `docs/handoffs/topology-van-kampen-surjectivity-at1-vk2.md`

建议 Main 集成时把新模块加入 `SandronesLibrary.lean`，并把 Entry
`topology.fundamental-group.van-kampen-surjectivity` 从 `staging` 登记为已验证；学科分支不修改共享
聚合文件、Registry 或 ROADMAP。

## 核心概念清单

| 概念 | 教材语义 | Lean 正式承载 | Mathlib 角色 | 首个真实使用者 |
|---|---|---|---|---|
| 覆盖成员与交集包含 | `U∩V → U,V → X` | 三组连续映射及诱导基本群同态 | `FundamentalGroup.map` | `binaryOpenCoverPieceMaps_compat` |
| 合并自由积 | 两侧基本群沿交集基本群合并 | `binaryVanKampenPushout` | `Monoid.PushoutI` | `binaryVanKampenCanonicalMap` |
| 规范同态 | 两侧包含诱导到环境基本群 | `binaryVanKampenCanonicalMap` | `PushoutI.lift/lift_of` | 满射定理 |
| 顶点连接 | 公共基点到各网格顶点的道路 | `BasedConnectors` | `IsPathConnected.joinedIn` | `segmentPieceLoop` |
| 单段修正环路 | `cᵢ · pᵢ · cᵢ₊₁⁻¹` | `segmentPieceLoop` | 道路同伦商与基本群 | `pushoutSegmentWord` |
| 有限带标签词 | 每个 VK1 段给出一侧生成元 | `pushoutSegmentWord` | `Fin.dfoldl`, `PushoutI.of` | `canonicalMap_pushoutSegmentWord` |
| 有限抵消 | 修正词恢复原环路 | `correctedLoopWord_eq_loop` | `Path.concat` 与商上的 `cast` | 满射定理 |

每条 VK1 段可视为一个同标签块；满射只需这一有限块词，不要求把相邻同标签段压缩成极大块。

## 公开签名与复用审核

- 正式承载：Mathlib `FundamentalGroup`、`Path.Homotopic.Quotient`、`Monoid.PushoutI`、连续映射和
  子类型；没有自建第二套基本群、自由积或道路同伦商。
- 本库新增：覆盖专用的连续包含、规范同态、基点连接证书、修正环路词及满射定理。它们均由最终
  满射证明真实调用，不是无使用者的包装别名。
- 证明后端：`IsPathConnected.joinedIn`、`Path.Homotopic.Quotient.map_comp`、`Fin.dfoldl`、
  `Monoid.PushoutI.lift_of` 和 VK1 的 `concatSubpaths_homotopic`。
- Bool 依赖类型曾导致临时原型在对标签 `cases` 后失配；正式版以
  `segmentPieceLoopOfLabel b (hb : D.label i = b)` 固定标签，再由非依赖包装调用，未保留失败写法。
- 端点 transport 不以依赖 `rw` 强行改写；两个独立 quotient 引理先处理首末 cast，再恢复原环路。

## 数学陈述和诚实边界

公开满射定理假设 `U,V` 开、`U∪V=Set.univ`、公共基点属于二者，并且 `U,V,U∩V` 道路连通。
结论仅为 `Function.Surjective binaryVanKampenCanonicalMap`。它不提供 `MonoidHom.ker` 的刻画，不证明
单射、群同构、范畴推送的拓扑保持性质或一般多开集版本。VK3 继续保持 `research_open`。

## 验证

- `lake env lean SandronesLibrary/Topology/VanKampenSurjectivity.lean`：通过。
- `lake build SandronesLibrary.Topology.VanKampenSurjectivity`：通过；仅构建新模块依赖闭包，共
  `1745 jobs`，没有 linter 警告。这不是全库构建。
- `/tmp/sandrones-library/VanKampenSurjectivityAggregate.lean`：通过；联合导入正式模块并 `#check`
  全部 33 条本库公开声明和六个核心 Mathlib 接口。
- `scripts.check_axioms.map_entry_to_decl`：Entry 精确映射 33 条公开声明，没有跨文件吸入。
- 11 条代表性公开定理的 `#print axioms` 均只出现 `propext`、`Classical.choice`、`Quot.sound`。
- Entry 恰有规定的八节；正式交付文件的 `sorry`、`admit`、`sorryAx`、`native_decide`、冲突标记
  扫描无结果；无新增全局或局部 `instance`；`git diff --check` 通过。

学科负责人不运行全库构建；Main 集成后负责共享聚合和全库门。

## 子 Agent 与负责人审核

本批未派子 Agent。学科负责人亲自完成 Mathlib 接口核对、正式证明、文档和全部模块级验证。
