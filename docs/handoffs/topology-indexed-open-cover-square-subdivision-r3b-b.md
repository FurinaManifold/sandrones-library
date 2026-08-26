# Topology handoff：T4-R3b-B indexed open-cover square subdivision

## Scope and gate

- branch: `codex/topology-foundations`；
- Main baseline: `346bf00`，同步合并提交 `55cc854`；
- direct foundation: shared square-grid extraction commit `16c9041`；
- permission: `main-961f4a6-permissions-expanded.md`，B 在 extraction 后独立 `development_open`；
- Entry: `topology.homotopy.indexed-open-cover-square-subdivision`。

B 不依赖 A；二者只是后续 F 的并列输入。本批新增一个模块、一篇 Entry 与本 handoff，不修改共有
文件或既有二开集 subdivision。

## Mathematical result and API choice

对连续方形像的任意 indexed 开覆盖及调用者指定 `minimumDepth`，唯一公开定理返回
`n ≥ minimumDepth`、`Fin (2^n) × Fin (2^n)` 标签和每个闭格的逐点从属证书。消费者获得 definitionally
为 `2^n` 的 indices，而不用穿过私有 carrier 保存的 `steps = 2^n` 等式。

没有公开一个较弱的 depth-zero convenience theorem，也不公开内部 subdivision structure；这样避免
维护平行接口和下游 transport。

## Concept inventory and public signature

| 概念 | 教材语义 | Lean 正式承载 | 展开／性质 | Mathlib 角色 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| indexed 开覆盖 | 每个点落入某个指标开集 | `W : ι → Set X`、`∀ k, IsOpen (W k)`、`∀ z, ∃ k, H z ∈ W k` | 公开量词本身 | `Set`/`IsOpen` 正式承载 | subdivision theorem | 本 Entry |
| 连续参数方形 | `I² → X` 连续 | `ContinuousMap` | `H.continuous` | 正式承载 | pullback cover | 本 Entry |
| Lebesgue 数 | 小球从属于覆盖成员 | private 调用 `lebesgue_number_lemma_of_metric` | 紧致单位方形上应用 | 私有证明后端 | label choice | 本 Entry |
| dyadic 方格 | 边长 `2^-n` 的统一闭格 | 共享 `unitSquareCellPoint` | `n ≥ minimumDepth` 与 cell membership | 凸组合和有限 index 正式承载 | R3b-F | 本 Entry |

公开签名没有度量空间、二开集 Bool、复数、微分、积分或局部原函数假设。目标空间只要求
`TopologicalSpace X`。内部经典选择、乘积距离和 Lebesgue 数不会成为课程接口。

## Ownership and verification

源码只 import `SandronesLibrary.Topology.HomotopySquareGrid`。mapper 应精确映射唯一公开 theorem；private
carrier 与所有 proof helper 不进入 Entry。仓库无同名声明、全局 instance、notation 或 attribute 改动。

已执行：

- `lake build SandronesLibrary.Topology.IndexedOpenCoverSquareSubdivision`：1658 jobs，通过；
- `/tmp/IndexedOpenCoverSquareSubdivisionAggregate.lean` 检查 `ContinuousMap`、`IsOpen`、共享 cell
  参数化、最终定理及任意 lower-depth 的直接组装，通过；
- mapper 精确得到 1 Entry / 1 public theorem，private carrier 与 helpers 均未吸入；
- 最终定理公理为 `[propext, Classical.choice, Quot.sound]`；
- placeholder、新 axiom、instance、notation、全名碰撞、冲突标记与 `git diff --check` 扫描通过。

## Honest boundary

本条目只构造有限统一方格及逐格标签。它不提供 many-cover nerve、局部有限细分、相邻格公共边
比较、道路正则性或积分结论。后续消费者必须另行组合 A 的边界 C1 对齐和 C--F 的积分论证；禁止
从这里推断全局 relative-`C²` 同伦方形。
