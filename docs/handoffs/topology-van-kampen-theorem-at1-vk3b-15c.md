# Topology handoff：AT1-VK3b-15c binary Seifert--van Kampen theorem

## Scope and gate

- branch: `codex/topology-foundations`；
- formal dependencies: VK2 surjectivity and 15b commit `f72e7f4`；
- permission: automatic release train after 15b build and handoff；
- formal slice: one Lean source, one Entry, this handoff；
- result: AT1-VK3b binary open-cover theorem proof chain closes here.

不修改 Main 共有 import、Registry、ROADMAP、RADAR 或 Playbook。

## Files and import

- `SandronesLibrary/Topology/VanKampenTheorem.lean`；
- `docs/entries/topology/fundamental-group/van-kampen-theorem.md`；
- `docs/handoffs/topology-van-kampen-theorem-at1-vk3b-15c.md`。

源码只 import `SandronesLibrary.Topology.VanKampenKernelWord`；满射通过其依赖闭包复用已验收 VK2。

## Concept inventory

| 概念 | 教材语义 | Lean 正式承载 | 展开／桥 | Mathlib 角色 | 首个消费者 | Entry |
|---|---|---|---|---|---|---|
| canonical map | 两局部基本群的像在交集相容所诱导同态 | 前序 `binaryVanKampenCanonicalMap` | letter-word/concat-loop bridge | `Monoid.PushoutI`, `FundamentalGroup` | kernel certificate | 本 Entry |
| kernel certificate | kernel 元素的字母表示及 concat loop 零伦 | existence theorem | VK2 word representation + quotient equality | `Path.Homotopy` | kernel-unit theorem | 本 Entry |
| injectivity | kernel 只有单位元 | `Function.Injective` | group-hom kernel criterion | 群同态接口 | final equivalence | 本 Entry |
| binary van Kampen equivalence | pushout 群与整体基本群同构 | `MulEquiv` | `MulEquiv.ofBijective` | 语义一致的群同构承载 | computation rules | 本 Entry |
| generator computation | 同构在两侧生成元上等于包含诱导映射 | `binaryVanKampenCanonicalEquiv_of` | canonical-map rules | `Monoid.PushoutI.of` | downstream topology | 本 Entry |

## Public surface and Entry mapping

公开面预期为 8 项：canonical-map/concat-loop 桥、kernel 证书、kernel-unit、单射、最终 `MulEquiv` 及
三个消去／计算接口。内部逐列表乘积证明和由 kernel-unit 推单射的纯群助手保持 private。

核心 `noncomputable def binaryVanKampenCanonicalEquiv` 已由 mapper 捕获。最终映射严格为
1 Entry / 8 public declarations；private 列表归纳和 kernel 代数助手被正确跳过，没有相邻 Entry 吸入。

## Public signature and reuse audit

- `Path`、`FundamentalGroup`、`Monoid.PushoutI`、`IsOpen`、`IsPathConnected`、`MulEquiv` 均为语义一致
  的正式 Mathlib 承载，并已在课程文档解释；
- canonical map、letter word、concat loop 和 kernel elimination 是本库前序接口；
- private 后端只做列表归纳和群同态 kernel 代数；
- 未泄漏方格实现字段，未新增 carrier、instance 或 notation，未调用 Mathlib 中不存在的最终 van
  Kampen package 代替本库证明链。

## Verification

- `lake build SandronesLibrary.Topology.VanKampenTheorem`：1776 jobs，通过；
- `VK3b15Aggregate.lean` 同时解析 15a--15c 核心 API、既有 VK2 满射、最终等价和三个计算接口；
- aggregate 的空字母词与单字母词 sanity checks 通过；
- 最终等价及消去接口公理为 `[propext, Classical.choice, Quot.sound]`；
- Entry mapper 精确得到 1 Entry / 8 public declarations，包括核心 `noncomputable def`；
- 三批联合映射严格为 4 / 4 / 8，文件与 Entry 一一对应；
- placeholder、新 `axiom`、越级接口、重复结构和未披露 instance 扫描为空；
- `git diff --check` 通过。

## Honest boundary

最终结果是 binary path-connected open-cover 版本。many-set、groupoid、disconnected intersection、
naturality 和非开覆盖推广没有证明，不能由本 Entry 的标题推断出来。
