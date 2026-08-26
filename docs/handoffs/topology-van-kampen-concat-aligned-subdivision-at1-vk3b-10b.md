# Topology handoff：AT1-VK3b-10b PathConcatAlignedSubdivision

## 范围、基线与权限

- 分支：`codex/topology-foundations`；同步 merge `9fe099b`，包含 `main@f69f890`。
- 直接依赖：VK3b-10a 已由 Main 以共享集成 `f69f890` 接收，最终接口为 17 public / 16 private。
- 权限：`main-f69f890-vk3b10a-accepted-10b-open.md`，10b 为 `development_open`。
- 本批止于 block grid、flatten、aligned certificate、左边界细边点态识别和 letter-piece membership；
  不包含 path gauge comparison、cell-label 比较、kernel 或 van Kampen 单射。

## 文件与 Main-side 建议

- 源码：`SandronesLibrary/Topology/PathConcatAlignedSubdivision.lean`。
- Entry：`docs/entries/topology/fundamental-group/van-kampen-concat-aligned-subdivision.md`，id
  `topology.fundamental-group.van-kampen-concat-aligned-subdivision`。
- 顶层 import、Registry、依赖图、ROADMAP、RADAR 与派生索引由 Main 集成。

## 概念链与 Mathlib 角色

| 概念 | 教材语义 | Lean 正式承载／刻画 | Mathlib 角色 | 首个使用者 |
|---|---|---|---|---|
| block grid | 一个 dyadic block 中的细网格点／边 | length、local/global index definitions | `Fin`、`ℕ` 为正式承载 | flatten 与 11 letter blocks |
| block flatten | 所有局部边依序覆盖全局边 | `pathConcatSegmentGridEdgeIndices_flatten` | `List.ofFn`/`flatten` 为正式承载 | certificate flatten |
| mesh point | block 内细点对应真实时间参数 | `pathConcatSegmentMeshPoint_eq_convexComb` | `unitInterval` convex combination | fine-subpath homotopy |
| dyadic grid segment | 一个 block 所有细 subpaths 的拼接 | `Path.concatDyadicGridSegment_homotopic` | `Path.concat`、`subpath`、同伦为正式承载 | aligned geometric layer |
| aligned certificate | 方格细分与 dyadic 参数的精确对齐 | `PathConcatAlignedSquareSubdivision` | 本库必要桥结构，不复制道路/方格 | 11--15 |
| left-boundary letter edge | 实际左边界细边等于字母细 subpath | 三个最终 `leftBoundary*` 出口 | 既有 Path 与方格边承载 | 11/12 |

公开签名中的 `Path`、`Path.subpath`、`Path.Homotopic`、`Fin`、`List` 与
`BinaryOpenCoverSquareSubdivision` 都是语义一致的正式承载。新 structure 只保存既有方格细分、正
refinement factor 和精确步数等式，是必要桥；没有第二套道路、同伦或方格定义。

## Public API 与 private boundary

按 `main-vk3b10b-formal-source-preaudit-public-surface.md`，以下六项保持 private：
`pathConcatBreakpoint_last_of_pos`、`repeatedMeshBreakpoint`、
`unitIntervalMeshPoint_repeatedMeshBreakpoint`、`contiguousRanges_ofFn`、
`Path.concatSegmentFineInterval_mem`、`Path.concatSegmentMeshPoint_mem`。

Entry mapper 对其余公开声明作名称级映射得到 34 项。Main 预审文字写“24 public / 6 private”，但同一
通知明确要求“只将上述六项改 private，其余保留 public”；当前候选共有 40 个声明，因此机械结果为
34 public / 6 private。源码严格按六名称裁决执行，未擅自再隐藏 11--15 的真实消费者或公开结构必要
计算规则；请 Main 集成时确认数字笔误并以名称清单及 mapper 结果为准。

## 真实消费者

11--15 直接消费 block length/positivity、local/global indices、mesh-point endpoint/convex-combination、
fine-subpath homotopy、aligned structure/existence、certificate flatten/首末/接缝、mesh-point castSucc/succ
以及三个左边界几何出口。正式 10b 收口后，未修改的 11 首模块
`VanKampenLetterBlockWord.lean` 已直接 import 正式 10b 并零输出编译通过。

## 验证

- `lake build SandronesLibrary.Topology.PathConcatAlignedSubdivision`：1762 jobs，通过，零 warning；
  flexible `simp at hsteps` 已改为定向 `simpa only [Nat.mul_zero] using hsteps`。
- Entry mapper：34 public；六个指定 helper 均跳过。
- 10b aggregate、代表性公理、禁用占位、冲突标记、重复承载和 `git diff --check` 在提交前复验。

## 诚实边界

本批证明 block-local edges 覆盖完整全局边，并把左边界真实细边识别为字母道路的细 subpath；它没有
证明方格 cell Bool 标签等于字母标签。也没有建立两种标签的 Pushout 比较、path gauge coherence、
kernel 字母词零伦、规范同态单射或最终 van Kampen 同构。三输入 block 长度为 `[2,2,4]`，不能改成
等长三分。
