# Topology handoff：AT2-C4a covering monodromy

## Scope and gate

- branch: `codex/topology-foundations`；
- synchronized Main baseline: `921a888`，merge `4e4986c`；
- C3 subject commit: `3ef7d4c`，已由 Main 接受；
- interface approval: `main-at2-c4-interface-audit-approved.md`；
- source: `SandronesLibrary/Topology/CoveringMonodromyStandard.lean`；
- Entry: `topology.covering.monodromy-standard`。

本批新增一个模块、一篇 Entry 与本 handoff；不修改 C1--C3、C4b/C5、Registry、ROADMAP 或顶层
import。C4b 只在本 handoff 冻结后自动开工。

## Reuse and public surface

Mathlib 已有 `monodromy`、`monodromyPerm`、恒等／复合／双射规律。本批不重定义或同义包装它们，
只新增两个课程桥：代表道路的 monodromy 等于 C2 标准提升终点；基环路提升闭合 iff monodromy 固定
初始 fiber 点。

公开面精确 2 项，无 private helper、新 carrier、instance、coercion 或 notation。Mathlib 道路同伦商、
fiber subtype 和基本群作用都是语义一致的正式公开承载，不构成越级泄漏。

## Composition and inverse convention

`cov.monodromy_trans_apply gamma gamma' e` 的右侧是先 `monodromy gamma e`，再
`monodromy gamma'`；这与 `Path.trans` 先走左道路再走右道路一致。`gamma.symm` 给出反向 transport，
由 trans、refl 得到与原 transport 互逆；`monodromy_bijective` 已统一承载可逆性。Entry 明文说明这些
方向，不增加四个同义 wrapper。

## Verification contract

- `lake build SandronesLibrary.Topology.CoveringMonodromyStandard`：1818 jobs，通过；
- `/tmp/CoveringMonodromyStandardAggregate.lean` 同时检查 Mathlib monodromy carrier、refl/trans/
  bijective、`monodromyPerm`、C2 标准提升与两项新桥；实际消费 closed→fixed 及先左后右的 trans 公式；
- mapper 精确得到 1 Entry / 2 public declarations；没有吸入 C2/C3 或 Mathlib 声明；
- 两项公开结果公理均为 `[propext, Classical.choice, Quot.sound]`；
- Entry 为精确八段，源码、Markdown 与拟登记 Registry id 一致；
- placeholder、新 axiom、instance、notation、冲突标记、全名碰撞与 `git diff --check` 扫描通过。

## Honest boundary and next gate

本批不陈述全局映射提升判据、simply connected 推论、universal cover 或覆盖分类。C4b 在本 handoff
冻结后自动 `development_open`，须独立文件、Entry、handoff 与提交。
