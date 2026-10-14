# E7　settheory / 批次 `ST3deep`

> **本文件由 `scripts/dispatch_brief.py` 从 pack 渲染，请勿手改**——要改范围或边界就改权威源（ROADMAP / AGENTS / Playbook）再重新生成。

| 项 | 值 |
|---|---|
| worktree | `/home/pisquare/czt/sandrones-library-st3-deep` |
| 分支 | `codex/settheory-st3-deep` |
| 基线 | `bc8d4feb59f639aa440d7719466297d918e9dd28` |
| 学科 / 批次 | `settheory` / `ST3deep` |
| 角色 | `subject-maintainer` |
| 本窗 pack 数 | 2 |

开工先读 `docs/LEAN-PLAYBOOK.md` **§10（并行窗口派工规程）**，再读你自己的 pack 文件原文。

## 1. 范围（本窗要做的 Entry）

| Entry id | 内容 | 前置 | Lean 文件 | pack_id |
|---|---|---|---|---|
| `settheory.googology.hereditary-encoding-order` | 已有全局严格保序、底数幂精确秩、`B^(B^k)` 参数族借位与规范状态；继续证明一般换底重编码保持 `omegaValue` | 🚧 | `SandronesLibrary/SetTheory/HereditaryEncodingOrderGeneral.lean` | `settheory-ST3deep-settheory.googology.hereditary-encoding-order` |
| `settheory.googology.hydra-general-descent` | 消除最右脊柱证书限制，覆盖一般游戏步骤 | 🚧 | `SandronesLibrary/SetTheory/HydraGeneralDescent.lean` | `settheory-ST3deep-settheory.googology.hydra-general-descent` |

**目标一句话**（pack 里唯一手写的字段，逐条抄录）：

- `settheory.googology.hereditary-encoding-order`：证明一般换底重编码保持 omegaValue，消除已证特例的限制
- `settheory.googology.hydra-general-descent`：消除最右脊柱证书限制，覆盖一般 Hydra 游戏步骤的下降

## 2. 文件所有权（从 AGENTS §3 推导，pack 原文）

**可写：**

- `SandronesLibrary/Settheory/**`
- `docs/entries/settheory/**`
- `docs/handoffs/settheory-*.md`
- `docs/maintenance/settheory-*.md`
- `traces/lean/settheory/**`
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
| 1 | `settheory.googology.primitive-recursive-class` | ✅ 冻结原始递归函数类（教科书 `Nat.Primrec'` 承载）并证明有界和／有界积／迭代闭包；Ackermann 非原始递归与无界 μ 仍 🔒（Wave R1 `c424c95`） |
| 2 | `settheory.googology.ackermann-domination` | 支配全部原始递归函数及非原始递归性 |
| 4 | `settheory.googology.goodstein-ordinal-descent` | 从局部借位推广到一般正规 Goodstein 步骤 |
| 5 | `settheory.googology.goodstein-termination` | 用序数良基性证明完整序列终止 |
| 6 | `settheory.googology.goodstein-pa-independence` | 精确形式化 PA 不可证性边界 |
| 7 | `settheory.googology.hydra-general-descent` | 消除最右脊柱证书限制，覆盖一般游戏步骤 |
| 8 | `settheory.googology.hydra-termination` | 一般 Hydra 游戏终止及强度边界 |
| 12 | `settheory.googology.busy-beaver-uncomputable` | 从停机问题完成不可计算性归约 |

> out_of_scope 是同族但**本批明确不做**的条目：不得顺手实现，也不得改动它们的文件；越界即升级。

## 4. 前置闭包（从 Registry 推导）

闭包深度 2；Mathlib 状态：`unverified_hint`。

| 深度 | Entry id | Lean 文件 |
|---|---|---|
| d0 | `settheory.googology.goodstein-reencoding` | `SandronesLibrary/SetTheory/Goodstein.lean` |
| d0 | `settheory.googology.hereditary-natural-encoding` | `SandronesLibrary/SetTheory/HereditaryNatEncoding.lean` |
| d0 | `settheory.googology.hereditary-natural-encoding-strict-order` | `SandronesLibrary/SetTheory/HereditaryNatEncodingOrder.lean` |
| d1 | `settheory.googology.goodstein-certified-state` | `SandronesLibrary/SetTheory/Goodstein.lean` |
| d1 | `settheory.googology.goodstein-step` | `SandronesLibrary/SetTheory/Googology.lean` |
| d1 | `settheory.googology.hereditary-base` | `SandronesLibrary/SetTheory/Googology.lean` |
| d1 | `settheory.googology.hereditary-natural-encoding-same-block-order` | `SandronesLibrary/SetTheory/HereditaryNatEncodingOrder.lean` |
| d2 | `settheory.googology.primitive-recursion` | `SandronesLibrary/SetTheory/Googology.lean` |

**Mathlib 候选**（计划模式下是**未验证提示**，不是已确认承载——先 `#check` 实测）：

```
Ordinal
Ordinal.opow
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

- 路径：`traces/lean/settheory/settheory.googology.hereditary-encoding-order.jsonl`
- schema：`sandrones-lean-attempt/1`；join key 字段：`pack_id`
- 每条 attempt 记录必须带同一个 pack_id，否则该轨迹无法与上下文配对。

## 8. 冻结声明（目标文件里已冻结、不得改签名的声明）

本批目标文件里没有冻结声明（新文件从零开始）。

> 签名先冻结再填证明（AGENTS §5 sorry 框架法）；改签名必须升级。

## 9. 窗口手写残量（`--note`，无法从权威源推导的判断）

> 本节是简令里**唯一**手写部分，与 pack 的推导字段分开标注，便于日后审计漂移。

**「一般化」必须是真的消除限制**，这是本窗唯一的验收要点：
- `hereditary-encoding-order` 要证**一般换底重编码保持 `omegaValue`**（不只是已证的特例）；
- `hydra-general-descent` 要覆盖**一般游戏步骤**（不只是最右脊柱证书）。
做不到就诚实登记为 foundation／bridge，**不得把特例写成一般定理**。

**难度预警**：这两条是序数下降 + 良基递归，试错成本高。按 AGENTS §5 先在
`/tmp/sandrones-library/` 建 `sorry` 框架、把每个 `sorry` 列成 todo 再逐个消解；
同一子证明连续五次失败就停止盲试、拆更小框架。**失败尝试必须写进 trace**——本窗的失败轨迹
对语料价值极高，别只留成功路径。

**不改已集成的 Goodstein／Hydra 状态文件**（已 verified 的部分）；新增能力放新文件。

---

派工坐标与全部推导字段见 `docs/dispatch/e7-st3-deep.md` 对应的 pack 文件；简令与 pack 不一致时**以 pack 为准**，并报告 Main 重新生成简令。
