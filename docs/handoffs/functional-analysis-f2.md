# F2 Banach 三大定理 handoff

- 分支：`codex/functional-analysis`
- Main 基线：`b82e9d4`（`git rebase main`）
- 设计 RFC：`docs/maintenance/functional-analysis-f2-design.md`
- 当前阶段：Baire、Banach–Steinhaus 已接受，开映射已提交；闭图完成验证，有界逆待开发

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
