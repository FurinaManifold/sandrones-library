# Topology handoff：AT1-VK3b-15a residual-gauge elimination

## Scope and gate

- branch: `codex/topology-foundations`；
- dependency: Main 已集成 VK3b-01--14c；
- permission: `development_open`，15a--15c automatic release train；
- formal slice: one Lean source, one Entry, this handoff；
- next gate: 15a 在学科 worktree 构建并形成完整 handoff 后自动开放 15b。

本批不修改 `SandronesLibrary.lean`、Registry、ROADMAP、RADAR、Playbook 或其他 Main 共有文件。

## Files and import

- `SandronesLibrary/Topology/VanKampenResidualGauge.lean`；
- `docs/entries/topology/fundamental-group/van-kampen-residual-gauge.md`；
- `docs/handoffs/topology-van-kampen-residual-gauge-at1-vk3b-15a.md`。

源码只 import `SandronesLibrary.Topology.VanKampenRebasedLetterWord`。

## Concept inventory

| 概念 | 教材语义 | Lean 正式承载 | 展开／桥 | Mathlib 角色 | 首个消费者 | Entry |
|---|---|---|---|---|---|---|
| residual gauge | frame 相对于 vertex potential 的剩余右乘因子 | 群元素 `p⁻¹ * f` | 两条通用传播定理 | `Group` 精确承载非交换代数 | boundary propagation | 本 Entry |
| normalized edge | 两端数据对同一边的 rebase 为一 | 本库 `rebaseEdge` | `potentialNormalizedFrame_eq_of_two_rebases` | 群正规化为证明后端 | residual comparison | 本 Entry |
| combined frame | intersection/piece frame 的 Pushout 组合 | 前序 `gridCellCombinedFrame` | target-and-normalized bridge | `Monoid.PushoutI` 承载二群 pushout | boundary telescope | 本 Entry |
| boundary residual telescope | 沿底、右、顶传播到左上角 | `leftResidualGauge_bottom_eq_top` | 复用有限边链证书 | `Fin` 承载有限网格索引 | 15b kernel word | 本 Entry |

## Public surface and Entry mapping

预期公开面严格为四项：

1. `potentialNormalizedFrame_eq_of_compatible`；
2. `potentialNormalizedFrame_eq_of_two_rebases`；
3. `combinedFrame_eq_of_target_and_normalized`；
4. `BinaryOpenCoverSquareSubdivision.leftResidualGauge_bottom_eq_top`。

其余几何搬运和三段边界传播助手均为 private。`map_entry_to_decl` 精确映射上述 4 项，跳过全部
private helpers；源码、Markdown 与拟登记 Registry id 均为
`topology.fundamental-group.van-kampen-residual-gauge`，没有跨文件或相邻 Entry 吸入。

## Public signature and reuse audit

- `Group`、`Fin`、`FundamentalGroup`、`Monoid.PushoutI` 属于语义一致的正式 Mathlib 承载；
- `BinaryOpenCoverSquareSubdivision`、potentials、frames、`rebaseEdge` 属于前序本库课程接口；
- private helpers 只作基点 cast、有限链 telescope 与群正规化，不形成新课程概念；
- 没有公开高阶结构泄漏，没有新 instance、carrier 或 notation，也没有重造基本群和 pushout。

## Verification

- `lake build SandronesLibrary.Topology.VanKampenResidualGauge`：1774 jobs，通过；
- `/tmp/VK3b15aAggregate.lean` 同时导入并 `#check` 四项公开 API，通过；
- 三条通用群定理公理为 `[propext]`，边界 telescope 为
  `[propext, Classical.choice, Quot.sound]`；
- Entry mapper 精确得到 1 Entry / 4 public declarations；
- placeholder、新 `axiom`、越级公开结构和重复 carrier 扫描为空；
- `git diff --check` 通过。

## Honest boundary

15a 只证明 residual gauge 的边界传播；不把最终 van Kampen equivalence 回填为前提。kernel 字母词为一、
规范同态单射及最终同构仍留给 15b/15c。many-set、groupoid 和非道路连通交集版本不在本批范围。
