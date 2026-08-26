# Topology handoff：AT1-VK3b-15b kernel letter word

## Scope and gate

- branch: `codex/topology-foundations`；
- formal dependency: 15a commit `33b02bb`；
- permission: automatic release train after 15a build and handoff；
- formal slice: one Lean source, one Entry, this handoff；
- next gate: 本批构建和 handoff 完成后自动开放 15c。

不修改 Main 共有 import、Registry、ROADMAP、RADAR 或 Playbook。

## Files and import

- `SandronesLibrary/Topology/VanKampenKernelWord.lean`；
- `docs/entries/topology/fundamental-group/van-kampen-kernel-word.md`；
- `docs/handoffs/topology-van-kampen-kernel-word-at1-vk3b-15b.md`。

源码只 import `SandronesLibrary.Topology.VanKampenResidualGauge`。

## Concept inventory

| 概念 | 教材语义 | Lean 正式承载 | 展开／桥 | Mathlib 角色 | 首个消费者 | Entry |
|---|---|---|---|---|---|---|
| global block endpoint | 全部 letter blocks 拼接后的末 frame | 前序 edge-chain endpoint | `leftBoundaryLetterBlockChain_end` | `Fin`/群运算 | frame comparison | 本 Entry |
| residual elimination | 同一势下 residual 相同使首末 frames 相等 | `leftBoundaryGlobalCombinedFrames_eq` | 复用 15a | Pushout 群承载等式 | kernel word | 本 Entry |
| nonempty kernel word | 零伦 concat loop 对应的非空 pushout word 为一 | `letterWord_eq_one_of_homotopy_of_nonempty` | 14c rebase + 15a endpoint | `Path.Homotopy`, `Monoid.PushoutI` | 15c kernel certificate | 本 Entry |
| constant connector computation | 常值端点 connector 不改变 loop 的基本群类 | `fundamentalGroup_fromPath_correctedLoop_refl` | 展开 corrected loop/fromPath | `FundamentalGroup` 正式承载 | 15c canonical-map bridge | 本 Entry |

## Public surface and Entry mapping

公开面为四项，恰为上表四个 Lean 声明。第四项不是 mapper 的意外吸入：它是 15c 的真实消费者桥，
已补独立 docstring 和同一 Entry marker。所有 grid/potential/cast 搬运助手保持 private。

## Public signature and reuse audit

- `Path.Homotopy`、`FundamentalGroup`、`Monoid.PushoutI`、`Fin`、`Group` 均为语义一致的正式承载；
- aligned subdivision、letter word、combined frames 和 residual gauge 为本库前序课程接口；
- private 后端只做 endpoint 下标、cast 与 telescope；
- 没有越级公开结构、重复 carrier、全局 instance 或 notation。

## Verification

- `lake build SandronesLibrary.Topology.VanKampenKernelWord`：1775 jobs，通过；
- `/tmp/VK3b15bAggregate.lean` 同时导入并 `#check` 四项公开 API，通过；
- 四项公理均为 `[propext, Classical.choice, Quot.sound]`；
- Entry mapper 精确得到 1 Entry / 4 public declarations，并跳过 private helpers；
- placeholder、新 `axiom`、越级公开结构、重复 carrier 和未披露 instance 扫描为空；
- `git diff --check` 通过。

## Honest boundary

本批只处理非空字母词。它尚不把任意 canonical-map kernel 元素表示成该类字母词，不证明 injectivity
和最终 `MulEquiv`；这些属于 15c。many-set/groupoid 和 disconnected-intersection 版本不在范围内。
