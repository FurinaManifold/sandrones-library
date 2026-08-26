# Topology handoff：AT2-C1 covering-map definition layer

## Scope and gate

- branch: `codex/topology-foundations`；
- synchronized Main baseline: `77f6272`，merge commit `794eaf2`；
- permission: `main-961f4a6-permissions-expanded.md` 将 AT2-C1 设为 `development_open`；
- source: `SandronesLibrary/Topology/CoveringMapStandard.lean`；
- Entry: `topology.covering.definition-standard`。

本批新增一个模块、一篇课程 Entry 与本 handoff；不修改 R3b 文件、共有 import、Registry、ROADMAP、
RADAR、Playbook 或生成索引。

## Carrier decision and semantic difference

正式 carrier 直接复用 Mathlib `IsEvenlyCovered p x I` 与 `IsCoveringMap p`。不建立本库 covering-map
structure、abbrev、instance 或 coercion。

`IsEvenlyCovered` 展开为离散 `I`、包含 `x` 的开集 `U`、开原像和保持基投影的同胚
`p ⁻¹' U ≃ₜ U × I`。`IsCoveringMap` 在每点使用实际 fiber `p ⁻¹' {x}`。Mathlib 不要求满射并允许
空 fiber；课程文档显式区别教材常见满射约定。需要后者时接口保留独立 `Function.Surjective p`
假设，不复制 carrier。

## Concept inventory

| 概念 | 教材语义 | Lean 正式承载 | 展开／一手性质 | Mathlib 角色 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 均匀覆盖点 | 邻域原像分解为离散 sheets | `IsEvenlyCovered` | `isEvenlyCovered_iff_exists_open_product` | 正式承载 | covering definition | 本 Entry |
| 覆盖映射 | 每个基点均匀覆盖 | `IsCoveringMap` | `isCoveringMap_iff_every_point_evenlyCovered` | 正式承载 | all consequences | 本 Entry |
| 覆盖邻域乘积图 | `p⁻¹U ≃ U×fiber` 且第一投影为 p | `Homeomorph` | `coveringMap_exists_open_product_neighborhood` | 正式承载 | AT2-C2 | 本 Entry |
| 离散纤维 | 每个 sheet index 孤立 | `DiscreteTopology (p ⁻¹' {x})` | `coveringMap_discreteTopology_fiber` | 正式承载 | local uniqueness | 本 Entry |
| 局部同胚性质 | 每点附近 p 为同胚 | `IsLocalHomeomorph` | combined basic-properties theorem | 正式承载 | lift uniqueness | 本 Entry |
| 满射教材约定 | 每个基点有非空 fiber | `Function.Surjective p` 另列 | quotient-map theorem | 不并入 carrier | quotient consequence | 本 Entry |

公开签名中的 `Set.preimage`、`Homeomorph`、`DiscreteTopology`、`Continuous`、`IsOpenMap`、
`IsLocalHomeomorph`、`Function.Surjective` 与 `IsQuotientMap` 均为语义一致的 Mathlib 正式承载，并在
课程文档解释。没有私有高级后端或越级 typeclass；所有证明只是定义投影与 Mathlib 基础定理组合。

## Public surface and next interface

公开面为 6 项：两个核心定义展开、开乘积邻域提取、离散 fiber、连续/开/局部同胚组合性质、满射时
商映射。mapper 必须捕获全部 6 项且不吸入相邻 Entry。

C1 handoff 冻结后，按 Main 自动门 AT2-C2 转为 `development_open`。C2 可稳定依赖的 carrier 是
`IsCoveringMap p`，起始公开工具是本条目的 product-neighborhood 与 discrete-fiber 解释；道路提升本身
应优先直接复用 Mathlib `IsCoveringMap.liftPath` 及存在唯一性 API，禁止复制 covering 定义。

## Verification contract

已验证：

- 同步最新 Main 后运行 `lake build SandronesLibrary.Topology.CoveringMapStandard`：1107 jobs，通过；
- `/tmp/CoveringMapStandardAggregate.lean` 同时检查两个 carrier、两项展开、product chart、fiber、基础
  性质与满射 quotient consequence；在任意离散空间映射、额外满射 covering 和空 total-space covering
  三类语义实例上实际消费接口，通过；
- mapper 精确得到 1 Entry / 6 public theorems，无相邻 Entry 或 private 声明吸入；
- 六项公开结果公理均为 `[propext, Classical.choice, Quot.sound]`；
- 全名碰撞、placeholder、新 axiom、instance、notation、conflict 与 `git diff --check` 扫描通过。

## Honest boundary

本批只建立覆盖映射定义层和基础性质。它不证明道路提升、同伦提升、monodromy 或覆盖分类；也不声称
Mathlib carrier 自带满射。`IsCoveringMapOn` 与限制覆盖已有 Mathlib API，但不是本批课程公开面的核心，
留给需要相对基空间子集时另行登记。
