# F2 Banach 三大定理 handoff

- 分支：`codex/functional-analysis`
- Main 基线：`8d8a111`（`git rebase main`）
- 设计 RFC：`docs/maintenance/functional-analysis-f2-design.md`
- 当前阶段：F2 前十项已由 Main 集成；可分性／对偶为最后开放窗口

## 具体自反空间实例窗

- 沿用 `Function.Surjective (NormedSpace.inclusionInDoubleDual ℝ E)`，不建立本地 `Reflexive` 类。
- 有限维正例通过代数对偶与连续对偶的线性等价及 `Subspace.dual_finrank_eq` 证明。
- 完备实内积空间正例直接通过 `InnerProductSpace.toDual` 的 Riesz 等价证明。
- `c₀`、`ℓ¹`、`ℓ∞` 只记录为待 API 审计边界；本窗不建立替代序列空间，也不声称其非自反性已在库内形式化。
- `lake build SandronesLibrary.FunctionalAnalysis.ReflexiveExamples`：8721 jobs 通过；两个公开定理的
  公理依赖均为 `propext`、`Classical.choice`、`Quot.sound`，Entry 精确映射为两个声明。

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

## 范数化泛函窗

- 正式承载直接采用 `StrongDual`、`exists_dual_vector` 与 `exists_dual_vector''`，不建立本地
  “范数化泛函”结构。
- 对偶范数刻画公开为闭单位球上的普遍上界加取到性，避免为单一结论复制上确界定义。
- 上层使用者给出连续对偶分离点；不要求空间完备，也不声称范数化泛函唯一或对偶单位球范数紧致。
- `lake build SandronesLibrary.FunctionalAnalysis.NormingFunctional`：8716 jobs 通过；警告只来自既有依赖。
- 聚合 `#check` 覆盖连续对偶、两项 Mathlib 存在定理、算子范数上界与五个公开声明；Entry 精确
  映射为五个声明。
- 五个声明的公理依赖均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。

## 凸分离窗

- `Convex`、`StrongDual`、`gauge` 与几何 Hahn–Banach 定理均直接作为正式接口或证明后端；
  不建立本地凸集、半空间或 Minkowski 泛函定义。
- 教材接口覆盖含零开凸邻域与外点、两个不交开凸集、闭凸集与外点，以及闭凸集的半空间交刻画。
- 一般两个闭凸集的严格分离仍需要额外紧致性或距离条件，本窗不作过强陈述。
- `lake build SandronesLibrary.FunctionalAnalysis.ConvexSeparation`：8717 jobs 通过；警告只来自既有依赖。
- 聚合 `#check` 覆盖 `Convex`、`gauge`、两项 Mathlib 分离主定理与四个公开声明；Entry 精确映射
  为四个声明。
- 四个声明的公理依赖均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。

## 零化子与闭包窗

- 连续零化子直接采用 `StrongDual.polarSubmodule ℝ S`；量词由 `mem_polarSubmodule` 展开。
- 明确排除只使用代数对偶的 `Submodule.dualAnnihilator`，因为本窗目标是拓扑闭包刻画。
- 凸分离真实用于证明“全部连续零化子共同核 = 子空间闭包”，并给出闭子空间特例。
- `lake build SandronesLibrary.FunctionalAnalysis.AnnihilatorClosure`：8718 jobs 通过；警告只来自既有依赖。
- 聚合 `#check` 覆盖连续零化子承载、量词展开、子空间闭包与四个公开声明；Entry 精确映射为
  四个声明。
- 四个声明的公理依赖均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。

## 双对偶与自反性窗

- 典范嵌入和其等距打包直接采用 `NormedSpace.inclusionInDoubleDual` 与
  `NormedSpace.inclusionInDoubleDualLi`，不建立本地映射。
- Banach 空间自反性直接表达为典范嵌入的 `Function.Surjective`；明确不误用全部代数对偶上的
  `Module.IsReflexive`。
- 弱紧闭单位球刻画依赖 F4，本窗只记录边界，不借 Mathlib 强定理提前完成。
- `lake build SandronesLibrary.FunctionalAnalysis.BidualReflexive`：8719 jobs 通过；警告只来自既有依赖。
- 聚合 `#check` 覆盖典范嵌入、求值展开、等距打包与五个公开声明；Entry 精确映射为五个
  声明。
- 五个声明的公理依赖均为 `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与
  `git diff --check` 通过。

## 可分性与对偶窗

- 可分性直接采用 `TopologicalSpace.SeparableSpace`，连续对偶直接采用 `StrongDual`，不建立改名谓词。
- 公开链覆盖可分自反空间的双对偶可分、对偶可分推原空间可分，以及可分自反空间的对偶可分。
- 核心逆向蕴含用可数稠密对偶族选取近似取范向量，再由“共同连续零化子为零”推出可数生成子空间稠密。
- 一般“原空间可分 推对偶可分”为假；`ℓ1`/`ℓ∞` 边界在教材文档披露。弱星可度量化和弱紧单位球仍留给 F4。
- `lake build SandronesLibrary.FunctionalAnalysis.SeparableDual`：8720 jobs 通过；警告只来自既有依赖。
- 聚合 `#check` 覆盖可分性、连续对偶、可数稠密集、近似取范、可分线性生成、零化子闭包与三个公开声明。
- Entry `functional-analysis.separable.dual` 精确映射为三个公开声明；三者公理依赖均为
  `propext`、`Classical.choice`、`Quot.sound`；禁用占位扫描与 `git diff --check` 通过。

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
