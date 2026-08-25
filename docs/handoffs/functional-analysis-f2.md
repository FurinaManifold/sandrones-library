# F2 Banach 三大定理 handoff

- 分支：`codex/functional-analysis`
- Main 基线：`bdc17a6`（`git rebase main`）
- 设计 RFC：`docs/maintenance/functional-analysis-f2-design.md`
- 当前阶段：F2 前五项已由 Main 集成；Hahn–Banach 延拓窗口完成验证

## Hahn–Banach 延拓窗

- 代数支配形式直接采用 `exists_extension_of_le_sublinear`；公开输入展开正齐次、次可加和支配
  三组量词，不建立本地 `Sublinear` 包装结构。
- 赋范形式直接采用 `exists_extension_norm_eq` 与 `StrongDual`，覆盖等范数延拓及不增范数推论。
- 部分线性映射 `LinearPMap` 只在证明后端用于把 `S →ₗ[ℝ] ℝ` 组成 Mathlib 所需承载，不泄漏为
  课程公开概念。
- `lake build SandronesLibrary.FunctionalAnalysis.HahnBanach`：8715 jobs 通过；警告只来自既有依赖。
- 聚合 `#check` 覆盖部分映射后端、两项 Mathlib 主定理与三个公开声明；Entry 精确映射为三个声明。
- 三个声明的公理依赖均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。

## 有界逆窗

- 正式承载为 `LinearEquiv`、逆 `e.symm` 和 `ContinuousLinearEquiv`；没有本地逆算子结构。
- `lake build SandronesLibrary.FunctionalAnalysis.InverseOperator`：8714 jobs 通过；仅重放既有警告。
- 五模块联合聚合 `#check` 覆盖全部正式承载、依赖链和定量上层使用者。
- 五个 Entry 分别精确映射为 2、2、3、3、3 个公开声明；有界逆三个声明的 `#print axioms` 均为
  `propext`、`Classical.choice`、`Quot.sound`。
- 全 F2 禁用占位扫描与 `git diff --check` 通过。

## Main-side 集成建议

- 新增 `Baire`、`BanachSteinhaus`、`OpenMapping`、`ClosedGraph`、`InverseOperator` 顶层 imports。
- 登记五个 ROADMAP 冻结 id，并补相应 Registry、RADAR、ROADMAP 状态和生成索引。
- F2 接收后可解除 F4 对 F2 一侧的依赖门；F4 仍需等待 F3 完成。

## 闭图窗

- 正式承载为 `LinearMap.graph` 与 `IsClosed`；没有建立闭图算子包装结构。
- `lake build SandronesLibrary.FunctionalAnalysis.ClosedGraph`：8713 jobs 通过；仅重放既有警告。
- 聚合 `#check` 覆盖图、闭性、Mathlib 主定理和三个公开声明；Entry 精确映射为三个声明。
- 三个声明的 `#print axioms` 均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。

## 开映射窗

- `IsOpenMap` 是语义一致正式承载，展开为开集像仍开；`Topology.IsQuotientMap` 是直接上层推论。
- `lake build SandronesLibrary.FunctionalAnalysis.OpenMapping`：8712 jobs 通过；仅重放既有警告。
- 聚合 `#check` 覆盖正式承载、Mathlib 主定理和三个公开声明；Entry 精确映射为三个声明。
- 三个声明的 `#print axioms` 均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。

## 范围与边界

- 本批依次覆盖 Baire、Banach–Steinhaus、开映射、闭图和有界逆。
- 正式承载均直接采用语义一致的 Mathlib 接口，不建立平行结构或谓词。
- F3 已由 Main 单独解锁但本分支保持 F2 连续依赖链；F4 保持锁定。共有 Registry、RADAR、
  ROADMAP 和顶层 import 由 Main 集成。

## Baire 窗

- 正式承载：`BaireSpace`；展开为可数稠密开集之交稠密。
- 上层使用者：可数闭集覆盖必有一项具有非空内部。
- `lake build SandronesLibrary.FunctionalAnalysis.Baire`：8708 jobs 通过；只有教材
  `BanachSpace` 语境中的未使用线性结构提示和既有 Topology 格式警告。
- 聚合 `#check` 覆盖 `BaireSpace`、其教材展开和两个公开使用者；Entry 精确映射为两个声明。
- 两个声明的 `#print axioms` 均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。

## Banach–Steinhaus 窗

- 点态有界直接保留 `∀ x, ∃ C, ∀ i, ‖g i x‖ ≤ C`，没有建立包装谓词。
- `lake build SandronesLibrary.FunctionalAnalysis.BanachSteinhaus`：8711 jobs 通过；仅重放既有警告。
- 聚合 `#check` 覆盖算子承载、Baire 前置、Mathlib 主定理和两个公开声明；Entry 精确映射为两个
  声明。
- 两个声明的 `#print axioms` 均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。
