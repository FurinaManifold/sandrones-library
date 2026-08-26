# Topology handoff：AT1-VK3b-14c actual left boundary to rebased input word

## Scope and gate

- branch target: `codex/topology-foundations`；
- dependency: subject `d02801d` / formal 14b；
- synchronized Main baseline: `2283535`；
- permission: automatic release train item 6；
- formal slice: one source, one Entry, this handoff；
- frozen: residual-gauge elimination、15a--15c、kernel、injectivity、final equivalence。

## Files and import

- `SandronesLibrary/Topology/VanKampenRebasedLetterWord.lean`；
- `docs/entries/topology/fundamental-group/van-kampen-rebased-letter-word.md`；
- `docs/handoffs/topology-van-kampen-rebased-letter-word-at1-vk3b-14c.md`。

源码只 import `SandronesLibrary.Topology.VanKampenGlobalBlockTelescope`。不修改共享 import、Registry、
ROADMAP、RADAR 或 Playbook。

## Concept inventory

| 概念 | 教材含义 | Lean 承载 | 分类 | 消费者 | 边界 |
|---|---|---|---|---|---|
| real block concat | 最左网格细边拼接恢复输入 dyadic segment | `Path.Homotopic` | 几何桥 | word identification | 非严格 Path 等式 |
| reverse fold bridge | 两层反序恢复原列表正序积 | 任意群定理 | 通用代数 | 14c/15 | 不用交换律 |
| rebased input word | 实际网格左边界等于原字母词整体 rebase | Pushout 等式 | telescope 出口 | 15a | 保留 residual frames |
| grid cancellation | 右锚定左边界为一 | `rebasedLetterWord_eq_one` | 本批最终定理 | 15a | 不推出原 word = 1 |

## Public surface: 6 public / 8 private

公开六项：

1. `PathConcatAlignedSquareSubdivision.leftBoundaryConcatDyadicSegment_homotopic`；
2. `reverseDfoldl_reverse_get_eq_map_prod`；
3. `binaryVanKampenLetterWord_eq_map_prod`；
4. `PathConcatAlignedSquareSubdivision.leftBoundaryFramedBlocks_eq_rebaseWord`；
5. `PathConcatAlignedSquareSubdivision.leftBoundaryAllFramedCellEdges_eq_rebaseWord`；
6. `PathConcatAlignedSquareSubdivision.rebasedLetterWord_eq_one`。

八个 private（除特别说明外在 `PathConcatAlignedSquareSubdivision` namespace）：

1. `leftBoundarySegmentGridEdge`；
2. `leftBoundarySegmentGridEdge_eq_subpath`；
3. `leftBoundarySegmentGridConcat`；
4. `leftBoundarySegmentGridConcat_homotopic_subpath`；
5. `leftBoundaryConcatDyadicSegment`；
6. `mk_leftBoundaryConcatDyadicSegment_eq`；
7. `correctedLoop_leftBoundaryConcatDyadicSegment_eq`；
8. `reverseLeftBoundaryLetterBlockChain_eq_word`。

15a 只读取公开 combined endpoint frames、`rebasedLetterWord_eq_one` 和必要顺序桥，不展开八个实现助手。

## Semantic audit

真实 block 拼接只声称与原 segment 端点相对同伦，正确处理不同参数化。两条顺序定理把 block 内
reverse edge product、reverse blocks 和原 letters 的正序 word 严格连接；证明适用于任意非交换群。

`leftBoundaryAllFramedCellEdges_eq_rebaseWord` 左侧是真实二维网格左边界，右侧是原
`binaryVanKampenLetterWord letters` 的一次全局 rebase。调用 08b 左边界消失仅得到

```text
rebaseEdge globalStart globalEnd word = 1,
```

没有偷换成 `word = 1`。

## Verification

```text
lake build SandronesLibrary.Topology.VanKampenRebasedLetterWord
✔ [1773/1773] Built SandronesLibrary.Topology.VanKampenRebasedLetterWord
Build completed successfully (1773 jobs).
```

- 目标构建 zero warnings；
- 通用 reverse-fold 桥公理为 `[propext, Quot.sound]`；真实左边界 rebase 与最终
  `rebasedLetterWord_eq_one` 的公理均为 `[propext, Classical.choice, Quot.sound]`；
- 未修改的 15a 真实消费者
  `/tmp/sandrones-library/vk3b-15-formal-candidate/SandronesLibrary/Topology/VanKampenResidualGauge.lean`
  直接对正式 14c 编译，exit code 0、无输出；
- 表面严格为 6 public / 8 private；
- placeholder、新 `axiom`、carrier/instance/notation/import 与 `git diff --check` 扫描通过。

## Honest boundary

本批不证明 residual start/end frames 相等或平凡，不证明 kernel word 为一、规范同态 injectivity 或
最终 van Kampen equivalence。
