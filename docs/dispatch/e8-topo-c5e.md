# E8　topology / 批次 `AT2C5e`

> **本文件由 `scripts/dispatch_brief.py` 从 pack 渲染，请勿手改**——要改范围或边界就改权威源（ROADMAP / AGENTS / Playbook）再重新生成。

| 项 | 值 |
|---|---|
| worktree | `/home/pisquare/czt/sandrones-library-topo-c5e` |
| 分支 | `codex/topology-at2-c5e` |
| 基线 | `bc8d4feb59f639aa440d7719466297d918e9dd28` |
| 学科 / 批次 | `topology` / `AT2C5e` |
| 角色 | `subject-maintainer` |
| 本窗 pack 数 | 1 |

开工先读 `docs/LEAN-PLAYBOOK.md` **§10（并行窗口派工规程）**，再读你自己的 pack 文件原文。

## 1. 范围（本窗要做的 Entry）

| Entry id | 内容 | 前置 | Lean 文件 | pack_id |
|---|---|---|---|---|
| `topology.covering.subgroup-construction-recovery` | （计划中新条目：尚未登记 Registry） | — | `SandronesLibrary/Topology/CoveringSubgroupConstructionRecovery.lean` | `topology-AT2C5e-topology.covering.subgroup-construction-recovery` |

**目标一句话**（pack 里唯一手写的字段，逐条抄录）：

- `topology.covering.subgroup-construction-recovery`：研究窗：消掉 Wave R1 原型残留的三个 sorry（initSegMap 连续性、总空间道路连通、子群恢复）

## 2. 文件所有权（从 AGENTS §3 推导，pack 原文）

**可写：**

- `SandronesLibrary/Topology/**`
- `docs/entries/topology/**`
- `docs/handoffs/topology-*.md`
- `docs/maintenance/topology-*.md`
- `traces/lean/topology/**`
- `traces/packs/**`

**只读（改了即越界）：**

- `SandronesLibrary.lean`
- `index/registry.json`
- `index/rankings.json`
- `reference.bib`
- `docs/entries/README.md`
- `docs/entries/RANKINGS.md`
- `docs/MATHLIB-RADAR.md`
- `docs/ROADMAP-*.md`
- `docs/LEAN-PLAYBOOK.md`
- `docs/subject-packages/**`
- `docs/releases/**`
- `docs/world-formula/**`
- `README.md`
- `AGENTS.md`
- `scripts/**`

禁用占位：`sorry`, `admit`, `sorryAx`, `native_decide`。writable 之外一律只读；需要改动即升级，不自行扩权。

## 3. 批次边界（本批明确不做 = `scope.out_of_scope`，由 ROADMAP 推导）

| 批次 | Entry id | ROADMAP 内容 |
|---|---|---|
| — | — | 无同族兄弟条目 |

> out_of_scope 是同族但**本批明确不做**的条目：不得顺手实现，也不得改动它们的文件；越界即升级。

## 4. 前置闭包（从 Registry 推导）

闭包深度 2；Mathlib 状态：`unverified_hint`。

| 深度 | Entry id | Lean 文件 |
|---|---|---|
| d0 | `topology.covering.pointed-recovered-subgroup` | `SandronesLibrary/Topology/CoveringSubgroupRecoveryStandard.lean` |
| d0 | `topology.covering.subgroup-path-class-standard` | `SandronesLibrary/Topology/CoveringSubgroupPathClassStandard.lean` |
| d1 | `topology.covering.definition-standard` | `SandronesLibrary/Topology/CoveringMapStandard.lean` |
| d1 | `topology.fundamental-group.functoriality-standard` | `SandronesLibrary/Topology/FundamentalGroupFunctorialityStandard.lean` |
| d1 | `topology.fundamental-group.operations-standard` | `SandronesLibrary/Topology/FundamentalGroupOperationsStandard.lean` |
| d2 | `topology.fundamental-group.carrier-standard` | `SandronesLibrary/Topology/FundamentalGroupCarrierStandard.lean` |
| d2 | `topology.homotopy.equivalence-standard` | `SandronesLibrary/Topology/HomotopyEquivalenceStandard.lean` |

**Mathlib 候选**（计划模式下是**未验证提示**，不是已确认承载——先 `#check` 实测）：

```
FundamentalGroup
```

## 5. Playbook 必读节（指回去读，不复制正文）

| 锚点 | 标题 | 行号 |
|---|---|---|
| `§0` | 工作流铁律（Step 3 遇到困难时，按此顺序） | LNone |
| `§1.1` | `exact` 报类型不匹配时，先用 `exact?` / `apply?` / `rw?` 问编译器（由原 §3.17 提升） | LNone |
| `§1.2` | `No goals to be solved`：直接把多余的 tactic 删掉，别干别的（由原 §3.14 提升） | LNone |
| `§1.3` | `lake build` 的增量失误：改顶层 import 的子模块后，顶层 olean 可能不刷新（由原 §3.10 提升） | LNone |
| `§3` | 公理纪律（Classical.choice 最小化）（由原 §3.5–3.9 提升合并） | LNone |
| `§8` | Lean 验证轨迹语料（JSON）：底层子 Agent 的强制留痕 | LNone |

## 6. 预算与升级（Playbook §0）

```json
{
  "max_attempts_per_goal": 5,
  "source": "docs/LEAN-PLAYBOOK.md §0.4（5 次试错硬规则）",
  "escalate_when": [
    "同一目标连续编译失败 ≥ 5 次（含接口不匹配）→ 停止盲试，拆子 todo 或上报负责人",
    "需要改动 frozen.may_not_change 中的任何签名 → 立即升级，不得自行修改",
    "需要写 ownership.writable 之外的路径 → 立即升级",
    "目标本身疑似表述有误（需要改陈述而非改证明）→ 立即升级"
  ],
  "trace_duty": {
    "schema": "sandrones-lean-attempt/1",
    "when": "每次把 tactic 块交给编译器之后立刻追加，失败尝试同样要留",
    "source": "docs/LEAN-PLAYBOOK.md §8.2"
  }
}
```

## 7. 轨迹（Playbook §8）

- 路径：`traces/lean/topology/topology.covering.subgroup-construction-recovery.jsonl`
- schema：`sandrones-lean-attempt/1`；join key 字段：`pack_id`
- 每条 attempt 记录必须带同一个 pack_id，否则该轨迹无法与上下文配对。

## 8. 冻结声明（目标文件里已冻结、不得改签名的声明）

本批目标文件里没有冻结声明（新文件从零开始）。

> 签名先冻结再填证明（AGENTS §5 sorry 框架法）；改签名必须升级。

## 9. 窗口手写残量（`--note`，无法从权威源推导的判断）

> 本节是简令里**唯一**手写部分，与 pack 的推导字段分开标注，便于日后审计漂移。

**先读任务书**：`../review-inbox/topology/main-at2-c5e-wave-r1-research-still-open.md`。
Wave R1 原型含 3 个 `sorry`，未过「无占位原型」门，故 `research_open` 维持。本窗唯一目标就是消掉：

- **E1** `initSegMap` 的连续性；
- **E2** 总空间的**道路连通性**；
- **E3** `recoveredSubgroup (subgroupPointedCovering H) = H`。

**预算预警**：E2 最可能吃掉全部预算。连续五次失败就停、拆更小框架；做不完就**如实报告卡点**，
这比硬凑一个假证明有价值得多。零 `sorry` 的判定要用 `#print axioms` 逐条验（Playbook §3.6）。

**硬边界**：不得重放旧 `TextbookTopology`／旧 `Path` 载体；不得顺手声称任意 covering 的反向互逆；
C5f–C5g 继续冻结；研究窗不写 `SandronesLibrary/`。

---

派工坐标与全部推导字段见 `docs/dispatch/e8-topo-c5e.md` 对应的 pack 文件；简令与 pack 不一致时**以 pack 为准**，并报告 Main 重新生成简令。
