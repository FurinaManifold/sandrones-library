# E9　examples / 批次 `E1`

> **本文件由 `scripts/dispatch_brief.py` 从 pack 渲染，请勿手改**——要改范围或边界就改权威源（ROADMAP / AGENTS / Playbook）再重新生成。

| 项 | 值 |
|---|---|
| worktree | `/home/pisquare/czt/sandrones-library-examples-e1` |
| 分支 | `codex/examples-e1` |
| 基线 | `bc8d4feb59f639aa440d7719466297d918e9dd28` |
| 学科 / 批次 | `examples` / `E1` |
| 角色 | `subject-maintainer` |
| 本窗 pack 数 | 4 |

开工先读 `docs/LEAN-PLAYBOOK.md` **§10（并行窗口派工规程）**，再读你自己的 pack 文件原文。

## 1. 范围（本窗要做的 Entry）

| Entry id | 内容 | 前置 | Lean 文件 | pack_id |
|---|---|---|---|---|
| `examples.settheory.set-operations` | （计划中新条目：尚未登记 Registry） | — | `SandronesLibrary/Examples/SetTheory/SetOperations.lean` | `examples-E1-examples.settheory.set-operations` |
| `examples.settheory.functions` | （计划中新条目：尚未登记 Registry） | — | `SandronesLibrary/Examples/SetTheory/Functions.lean` | `examples-E1-examples.settheory.functions` |
| `examples.settheory.quotients` | （计划中新条目：尚未登记 Registry） | — | `SandronesLibrary/Examples/SetTheory/Quotients.lean` | `examples-E1-examples.settheory.quotients` |
| `examples.settheory.countability` | （计划中新条目：尚未登记 Registry） | — | `SandronesLibrary/Examples/SetTheory/Countability.lean` | `examples-E1-examples.settheory.countability` |

**目标一句话**（pack 里唯一手写的字段，逐条抄录）：

- `examples.settheory.set-operations`：集合运算正例（并交差补、De Morgan）与反例（A∪B=A∪C 推不出 B=C）
- `examples.settheory.functions`：映射性质正例（像/原像、单射/满射/双射）与反例（像不保持交）
- `examples.settheory.quotients`：等价关系与商的正例（模 n 同余类）与反例（不同代表元给同一商元素）
- `examples.settheory.countability`：可数性正例（ℕ×ℕ 配对、整数枚举、可数并）与反例（无限不必不可数）

## 2. 文件所有权（从 AGENTS §3 推导，pack 原文）

**可写：**

- `SandronesLibrary/Examples/**`
- `docs/entries/examples/**`
- `docs/handoffs/examples-*.md`
- `docs/maintenance/examples-*.md`
- `traces/lean/examples/**`
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
| d0 | `settheory.set.operations.complement-union` | `SandronesLibrary/SetTheory/Set.lean` |
| d0 | `settheory.set.operations.inter-distrib` | `SandronesLibrary/SetTheory/Set.lean` |
| d1 | `settheory.set.ext` | `SandronesLibrary/SetTheory/Set.lean` |

**Mathlib 候选**（计划模式下是**未验证提示**，不是已确认承载——先 `#check` 实测）：

```
Set.union_inter_distrib_right
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

- 路径：`traces/lean/examples/examples.settheory.set-operations.jsonl`
- schema：`sandrones-lean-attempt/1`；join key 字段：`pack_id`
- 每条 attempt 记录必须带同一个 pack_id，否则该轨迹无法与上下文配对。

## 8. 冻结声明（目标文件里已冻结、不得改签名的声明）

本批目标文件里没有冻结声明（新文件从零开始）。

> 签名先冻结再填证明（AGENTS §5 sorry 框架法）；改签名必须升级。

## 9. 窗口手写残量（`--note`，无法从权威源推导的判断）

> 本节是简令里**唯一**手写部分，与 pack 的推导字段分开标注，便于日后审计漂移。

**正例与反例都要有**——这是 Examples 学科的存在意义。反例要么 Lean 化，要么在叙述层给出
可核对的显式构造，**不得只写"存在反例"**。数值／低维计算必须是**真计算**
（`norm_num`／`decide`／显式求值），不是把公式抄一遍。

**E0.4 的影响审计单独成节**：哪些保留、哪些迁移、下游影响如何——ROADMAP 明确要求
"不破坏下游"。

**本窗不做 E1.8（递归与增长）**：它是 ST3 的实例化，等集合论 ST3 纵深窗口的成果落地后再排。
**理论模块不得依赖 Examples**（反向依赖是硬伤）；不扩建理论学科目录。

**权威范围表**是 `docs/ROADMAP-examples.md`（E0 与 E1 两节），不是本简令的范围表。

---

派工坐标与全部推导字段见 `docs/dispatch/e9-examples-e1.md` 对应的 pack 文件；简令与 pack 不一致时**以 pack 为准**，并报告 Main 重新生成简令。
