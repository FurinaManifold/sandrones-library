# Topology handoff：T4-R3b-D finite raw open path grid

## Scope and gate

- branch: `codex/topology-foundations`；
- Main baseline: `346bf00`，同步合并提交 `55cc854`；
- direct foundations: verified `PiecewiseC1Path` 与 extraction commit `16c9041`；
- permission: `main-961f4a6-permissions-expanded.md`，D 在 extraction 后独立 `development_open`；
- Entry: `topology.homotopy.finite-raw-open-path-grid`。

D 不依赖 A/B/C 的公开声明；adapter 直接消费共同的数据字段，便于各批独立复验。本批新增一个模块、
一篇 Entry 与本 handoff，不修改共有文件。

## Mathematical object and adapter

`FiniteRawOpenPathGrid E` 是任意实赋范线性空间上的有限原始方格：顶点、统一向右／向上的原始道路、
逐格开集、四侧 range inclusion 和整张网格四条外边的 PiecewiseC1 证书。
`finiteRawOpenPathGrid_of_squareSubdivisionData` 将共享方形网格、indexed cell labels、逐格 membership
与外边正则性直接组装为该 carrier。

carrier 有意允许 `steps = 0`，此时全部 cell/edge family 为空；真实 subdivision adapter 明确保留
`0 < steps`。不额外存一个在退化情形无语义用途的 positivity proof。

## Concept inventory and signature audit

| 概念 | 教材语义 | Lean 正式承载 | 展开／性质 | Mathlib 角色 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 有限方格 | 二维有限顶点、边与格 | `FiniteRawOpenPathGrid` | structure projections | 本库 ownership carrier | R3b-E | 本 Entry |
| 原始有向边 | 向右横道路与向上竖道路 | Mathlib `Path` | endpoint-indexed fields | 正式承载 | incidence fields | 本 Entry |
| 格开集 incidence | 四侧道路像落入格开集 | `IsOpen` 与 `Set.range ... ⊆ ...` | 四个 membership fields | 正式承载 | local primitive attachment | 本 Entry |
| 外边分段 C1 | 整张方格边界可积分 | 既有 `Path.PiecewiseC1` | 四个 boundary fields | 本库 verified 谓词 | R3b-F | 本 Entry |
| square-data adapter | 参数方形数据组装为 raw grid | `finiteRawOpenPathGrid_of_squareSubdivisionData` | 四侧 `unitSquareCellPoint` 代入 | 共享方格 API | carrier constructor | 本 Entry |

公开签名扫描没有 `Complex`、path integral、exact form、primitive、完备性或有限维结构。`Path`、
`IsOpen`、`Set.range`、`Fin`、`NormedAddCommGroup` 和 `NormedSpace` 均为语义一致正式承载；新 structure
只组织本证明链特有的 ownership 数据。没有 instance、notation 或 coercion。

## Entry ownership and verification

已验证：

- `lake build SandronesLibrary.Topology.FiniteRawOpenPathGrid`：2124 jobs，通过；
- `/tmp/FiniteRawOpenPathGridAggregate.lean` 同时检查正式承载、structure、关键字段、adapter，并实际
  构造 `steps = 0` 的语义实例，通过；
- mapper 精确得到 1 Entry / 2 public declarations，包括 core structure 与 adapter；
- structure、adapter 与退化实例的公理均为 `[propext, Classical.choice, Quot.sound]`；
- 源码无 Complex/path-integral/primitive 依赖；全名碰撞、placeholder、新 axiom、instance、notation、
  conflict 与 `git diff --check` 扫描通过。

## Honest boundary

本批没有为内部共享边选择分段 C1 替换，没有附加 primitive，也没有定义或证明道路积分公式。R3b-E
负责解析数据层，R3b-F 负责有限和与同伦不变性。不得把此 carrier 宣称为一般 cubical complex，亦
不得由外边证书推断内部格边正则。
