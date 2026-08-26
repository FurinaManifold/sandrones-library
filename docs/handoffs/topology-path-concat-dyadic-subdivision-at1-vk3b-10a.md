# Topology handoff：AT1-VK3b-10a PathConcatDyadicSubdivision

## 范围、基线与权限

- 分支：`codex/topology-foundations`；提交前同步 merge `48a7949`，包含最新 `main@55ffaa5`。
- 直接依赖：VK3b-09 `VanKampenLetterWord` 已由 Main 以共享集成 `f479b2a` 接收。
- 权限：`main-vk3b10a-interface-approved-dependency-gated.md`；09 入 Main 后 10a 自动转为
  `development_open`。
- 本批止于受约束方格细分、dyadic breakpoint、concat segment 同伦与字母覆盖成员提升；不包含
  aligned block grid、cell-label 比较、kernel 或 van Kampen 单射。

## 文件与 Main-side 建议

- 源码：`SandronesLibrary/Topology/PathConcatDyadicSubdivision.lean`。
- Entry：`docs/entries/topology/homotopy/path-concat-dyadic-subdivision.md`，id
  `topology.homotopy.path-concat-dyadic-subdivision`。
- 顶层 import、Registry、依赖图、ROADMAP、RADAR 与派生索引由 Main 集成。

## 概念链与 Mathlib 角色

| 概念 | 教材语义 | Lean 正式承载／刻画 | Mathlib 角色 | 首个使用者 |
|---|---|---|---|---|
| 受约束方格细分 | 足够细且步数为指定整数倍 | `exists_binaryOpenCoverSquareSubdivision_steps_multiple` | 本库 VK3a 结构；紧致性工具为证明后端 | concat-multiple existence |
| dyadic scale | 左结合 concat 断点的共同分母 | `pathConcatDyadicScale n = 2^n` | `ℕ` 算术为正式承载 | breakpoint numerator |
| dyadic breakpoint | 第 `r` 个真实 concat 时间断点 | numerator / scale；相邻严格递增 | `unitInterval` 为正式承载 | `Path.concat_breakpoint_apply` |
| dyadic segment | 相邻真实断点间的子道路 | `Path.concatDyadicSegment` | `Path.subpath`、`Path.Homotopic` 为正式承载 | segment homotopy/membership |
| 字母 piece segment | segment 提升到对应覆盖成员 | `binaryVanKampenLetterDyadicSegmentInPiece` | subtype `Path` 为正式承载 | 10b 与 11 的 aligned connector |

公开签名中的 `Path`、`Path.concat`、`Path.subpath`、`Path.Homotopic`、`Fin` 和
`BinaryOpenCoverSquareSubdivision` 都是语义一致的正式公开承载；没有第二套道路或错误的等长分段
结构。Lebesgue number、实数距离估计和私有半区展开只作为证明后端。

## Public API 与 implementation boundary

Entry mapper 在学科提交时映射 14 public；Main 集成时根据真实 10b 消费审计，将 dyadic scale 正性、
breakpoint numerator 末端和 breakpoint 末端三项稳定计算规则提升为公开，最终为 17 public：两个受约束
细分存在性；dyadic scale 及正性；breakpoint numerator、上界、相邻严格递增与末端；实际 breakpoint
及末端；concat breakpoint 取值；dyadic segment、同伦与 membership；字母 segment membership、
覆盖成员内提升及其代表同伦。

其余 16 个自然数、半区与 segment 递归 proof helper 保持 private。公开的三条计算规则是 10b 的真实
共享依赖，不是把全部内部化简规则误暴露成课程 API。

## 验证

- `lake build SandronesLibrary.Topology.PathConcatDyadicSubdivision`：1761 jobs，通过，零 warning。
- 10a aggregate：学科提交时 14 项公开 `#check` 全部通过；Main 集成时补验三条稳定计算规则，最终
  17 项公开接口通过。`n = 1,2,3` 的 numerator 列表分别计算为
  `[0,2]`、`[0,2,4]`、`[0,2,4,8]`，三输入相邻 block 长度为 `[2,2,4]`。
- Entry mapper 最终映射 17 public；禁用占位、冲突标记、重复道路承载与 `git diff --check` 复验。

## 下游接口审计

Main 对旧研究期 10b 候选复核后确认它真实消费 `pathConcatDyadicScale_pos`、
`pathConcatBreakpoint_last`、`pathConcatBreakpointNumerator_last`；三项已经提升为公开，10b 无需局部
重复证明。其余 private helper 仍不得跨模块消费。

## 诚实边界

本批证明了真实 dyadic segment 的端点相对同伦和逐点成员性，但没有把不同 blocks 的局部网格索引
flatten 成完整全局边列表，也没有建立 aligned subdivision certificate。它没有比较 cell Bool 标签与
字母标签，不证明 kernel 字母词零伦、规范同态单射或最终 van Kampen 同构。`Path.concat` 的断点不能
替换成等长 `r/n`。
