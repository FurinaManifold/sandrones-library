# Topology handoff：AT2-C5a semilocally simply connected definition layer

## Scope and permission

- branch: `codex/topology-foundations`；
- synchronized Main baseline: `f731132`，merge `072de9c`；
- signature approval: `main-at2-c5a-signature-approved-development-open.md`；
- source: `SandronesLibrary/Topology/SemilocallySimplyConnectedStandard.lean`；
- Entry: `topology.covering.semilocally-simply-connected-standard`。

本批新增一个模块、一篇 Entry 与本 handoff；不修改 C1--C4、Registry、ROADMAP、Playbook 或顶层
import。C5b--C5g 没有正式源码。

## Frozen six-item surface

1. `SemilocallySimplyConnectedAt`：唯一点态主定义；
2. `SemilocallySimplyConnectedSpace`：Prop-valued class，只有逐点字段；
3. `semilocallySimplyConnectedAt_iff_exists_open_loops`；
4. `semilocallySimplyConnectedSpace_iff_forall_exists_open_loops`；
5. `semilocallySimplyConnectedSpace_of_stronglyLocallyContractible`；
6. `semilocallySimplyConnectedSpace_of_simplyConnected`。

源码没有第二个 loops predicate/class，也没有任何新 `instance`。两个强假设桥严格按 Main 决定发布为
普通 theorem；没有 `LocallyContractibleSpace → ...` 桥。

## Concept and signature inventory

| 概念 | Lean carrier | 分类 | 假设 | 首个消费者 |
|---|---|---|---|---|
| 点态半局部单连通 | open `U` + inclusion fundamental-group range `=⊥` | 本库必要新定义 | topology | loops iff / C5c |
| 全局性质 | Prop-valued class with pointwise field | 本库必要 class | topology | future C5c |
| 小环路表述 | explicit `∀ q, map q=1` | 展开桥，不是 carrier | topology | textbook users |
| fundamental-group inclusion | `FundamentalGroup.map` | Mathlib/既有正式承载 | continuous subtype val | main definition |
| 强局部可缩 | `StronglyLocallyContractibleSpace` | Mathlib 正式承载 | stronger local property | implication theorem |
| 单连通 | `SimplyConnectedSpace` | Mathlib 正式承载 | stronger global property | implication theorem |

公开签名没有 `PathConnectedSpace`、`LocallyPathConnectedSpace`、covering、quotient、universal cover 或
分类结构泄漏。唯一新增 class 是当前教材概念本身，且未增加自动推导实例。

## Verification contract

- `lake build SandronesLibrary.Topology.SemilocallySimplyConnectedStandard`：1821 jobs，通过；
- `/tmp/SemilocallySimplyConnectedStandardAggregate.lean` 同时检查 `FundamentalGroup.map`、点态定义、
  class 及字段、两个展开 iff 和两个强假设 theorem；实际从点态证书消费 loops 展开，并分别以显式
  局部 class 证书消费 simply-connected 与 strongly-locally-contractible 桥，证明无需全局 instance；
- mapper 精确得到 1 Entry / 6 public declarations，与 Main 冻结表面完全一致；没有吸入生成字段、
  Mathlib 声明或相邻 C4 Entry；
- class 本身不依赖公理；其余五项均只依赖 `[propext, Classical.choice, Quot.sound]`；
- Entry 为精确八段，源码、Markdown 与拟登记 Registry id 一致；
- placeholder、第二 loops predicate、新 axiom、instance、notation、冲突标记、全名碰撞与
  `git diff --check` 扫描通过。

## Honest boundary and next gate

本批没有把局部道路连通、局部可缩和半局部单连通混为一谈。C5a handoff 冻结后，C5b 只自动转
`research_open`；允许 `/tmp` 道路类商 carrier 与 equivalence relation 原型，仍不得迁移正式源码，
须另交签名 handoff。
