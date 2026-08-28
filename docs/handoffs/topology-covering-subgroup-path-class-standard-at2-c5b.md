# Topology handoff：AT2-C5b subgroup path-class carrier

## Scope and permission

- branch: `codex/topology-foundations`；
- synchronized Main baseline: `c3e8de2`，merge `deb2c8b`；
- signature approval: `main-at2-c5b-signature-approved-development-open.md`；
- source: `SandronesLibrary/Topology/CoveringSubgroupPathClassStandard.lean`；
- Entry: `topology.covering.subgroup-path-class-standard`。

本批只新增一个模块、一篇 Entry 与本 handoff。不修改顶层 import、Registry、ROADMAP、RADAR、
Playbook 或自动生成文件。

## Frozen surface

正式面严格是 Main 批准的 dependent endpoint based-path carrier、`prepend`、反作用律、orbit relation、
refl/symm/trans、等价关系、setoid、quotient carrier、endpoint equality 与 endpoint projection。

未迁入 `/tmp/CoveringSubgroupPathClassDifferenceBridge.lean` 中完成的教材差环路 iff；没有 topology
instance、continuity、local chart 或 covering-map 结论。C5c 继续冻结。

## Concept inventory

| 概念 | 教材语义 | Lean 正式承载 | 展开／性质 | 复用或桥 | 首个消费者 | Entry |
|---|---|---|---|---|---|---|
| 变终点 based path class | 从 `x0` 出发、终点可变的端点固定道路同伦类 | 本库 dependent structure `CoveringSubgroupBasedPath` | `endpoint`、`path` fields | path 字段直接复用 Mathlib quotient | `prepend` | 本 Entry |
| 子群起点拼接 | 在道路前拼接 `H` 中 loop | 本库 `prepend` | `prepend_one`、`prepend_mul` | 基本群元素与道路类定义性一致 | `Related` | 本 Entry |
| 轨道等价 | 相差一次子群 loop 起点拼接 | 本库 `Related` | refl/symm/trans | structure equality 承担 endpoint transport | `orbitSetoid` | 本 Entry |
| 道路类商 | 子群作用的轨道集合 | `Quotient orbitSetoid` | quotient constructor/eliminator | 复用 Mathlib `Quotient` | `projection` | 本 Entry |
| 端点投影 | 轨道类映到公共终点 | 本库 `projection` | `endpoint_eq_of_related` | `Quotient.lift` 后端 | future C5c | 本 Entry |

## Public signature scan

- `Path.Homotopic.Quotient`：语义一致的正式公开承载；此前道路同伦商 Entry 已解释，本 Entry 解释
  变终点 dependent 使用。
- `FundamentalGroup`、`Subgroup`：语义一致的正式公开承载；本批给定 `H ≤ π₁(X,x0)`。
- `Equivalence`、`Setoid`、`Quotient`：轨道等价与类型商的标准 Lean 承载；教材正文逐层解释。
- `TopologicalSpace X`：道路与基本群的必要环境结构；没有给新 carrier 泄漏 topology instance。
- 本库新 structure/relation 的必要性：Mathlib 没有“给定基本群子群的变终点道路类轨道商”专用
  carrier；它们不是现有结构的改名包装。
- 私有后端：无额外高阶结构；`Quotient.lift` 只出现在 projection 定义体。

## Multiplication and coset audit

`fundamentalGroup_mul_toPath` 已解释 Mathlib 乘法反序。源码逐项核对
`(h * k).1 = k.1.trans h.1`，因此证明的反作用律为
`prepend (h*k) a = prepend k (prepend h a)`。基点 fiber 的轨道相应为右陪集 `gH`。源码、Entry 与
Main signature review 三处方向一致。

## Verification contract

- `lake build SandronesLibrary.Topology.CoveringSubgroupPathClassStandard`：1739 jobs，通过；
- `/tmp/CoveringSubgroupPathClassStandardAggregate.lean`：同时 `#check` Mathlib 正式承载、本库 structure
  fields、prepend/relation/refl-symm-trans、setoid、quotient 与 projection，并实际组装一次反作用律、
  relation 自反消费者、setoid 与 projection；exit 0，无 warning；
- Entry mapper：精确得到 1 Entry / 13 public declarations，包含 structure、两个核心 def、五个作用／
  等价性质、setoid、endpoint lemma、quotient 与 projection；没有生成 field、Mathlib 声明或相邻 Entry；
- `/tmp/CoveringSubgroupPathClassStandardAxioms.lean`：13 项均只依赖
  `[propext, Classical.choice, Quot.sound]`；
- 正式源码扫描没有 `sorry`、`admit`、`sorryAx`、`native_decide`、新 `axiom`、`instance` 或
  `notation`；全名无重复，`git diff --check` 通过；
- 学科负责人按协议没有运行全库 build，留给 Main 集成阶段。

## Shared-file integration checklist for Main

- add top-level import `SandronesLibrary.Topology.CoveringSubgroupPathClassStandard`；
- Registry id: `topology.covering.subgroup-path-class-standard`；
- ROADMAP: AT2-C5b 完成后仅按 Main 决定开放 C5c；
- RADAR: 记录 `Path.Homotopic.Quotient`/`FundamentalGroup` 为正式承载，本库只新增 subgroup orbit
  carrier；
- regenerate README/rankings/axiom fields and run Main audit/full build。

## Honest boundary

本批不是覆盖映射的构造。`CoveringSubgroupPathClass` 只有类型商和集合层 endpoint projection；下游
不得依赖连续性、局部 chart、covering property、fiber-coset equivalence 或覆盖分类结论。
