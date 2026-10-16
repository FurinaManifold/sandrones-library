# F11　statistics / 批次 `S2entry-F`

> **本文件由 `scripts/dispatch_brief.py` 从 pack 渲染，请勿手改**——要改范围或边界就改权威源（ROADMAP / AGENTS / Playbook）再重新生成。

| 项 | 值 |
|---|---|
| worktree | `/home/pisquare/czt/sandrones-library-f11-statistics` |
| 分支 | `codex/f11-statistics` |
| 基线 | `94421807384d5ae159d14629b9c97a456d1dd9bb` |
| 学科 / 批次 | `statistics` / `S2entry-F` |
| 角色 | `subject-maintainer` |
| 本窗 pack 数 | 2 |

开工先读 `docs/LEAN-PLAYBOOK.md` **§10（并行窗口派工规程）**，再读你自己的 pack 文件原文。

## 1. 范围（本窗要做的 Entry）

| Entry id | 内容 | 前置 | Lean 文件 | pack_id |
|---|---|---|---|---|
| `statistics.testing.definition` | 检验、两类错误与功效 | measurable decision | `SandronesLibrary/Statistics/TestingDefinition.lean` | `statistics-S2entry-F-statistics.testing.definition` |
| `statistics.testing.neyman-pearson` | Neyman–Pearson 引理 | likelihood ratio | `SandronesLibrary/Statistics/NeymanPearson.lean` | `statistics-S2entry-F-statistics.testing.neyman-pearson` |

**目标一句话**（pack 里唯一手写的字段，逐条抄录）：

- `statistics.testing.definition`：冻结一般统计检验、两类错误、功效的可测决策接口并交付无占位原型
- `statistics.testing.neyman-pearson`：研究 Neyman-Pearson 引理的随机化检验阈值与边界情形，冻结签名及证明义务

## 2. 文件所有权（从 AGENTS §3 推导，pack 原文）

**可写：**

- `SandronesLibrary/Statistics/**`
- `docs/entries/statistics/**`
- `docs/handoffs/statistics-*.md`
- `docs/maintenance/statistics-*.md`
- `traces/lean/statistics/**`
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
| 2 | `statistics.testing.neyman-pearson` | Neyman–Pearson 引理 |
| 3 | `statistics.testing.likelihood-ratio` | 广义似然比检验入口 |
| 1 | `statistics.testing.definition` | 检验、两类错误与功效 |

> out_of_scope 是同族但**本批明确不做**的条目：不得顺手实现，也不得改动它们的文件；越界即升级。

## 4. 前置闭包（从 Registry 推导）

### 4.1 `statistics.testing.definition`

闭包深度 2；Mathlib 状态：`unverified_hint`。

| 深度 | Entry id | Lean 文件 |
|---|---|---|
| d0 | `statistics.model.definition` | `SandronesLibrary/Statistics/Model.lean` |
| d0 | `statistics.model.density` | `SandronesLibrary/Statistics/Density.lean` |
| d1 | `probability.space.definition` | `SandronesLibrary/Probability/Space.lean` |

### 4.2 `statistics.testing.neyman-pearson`

闭包深度 2；Mathlib 状态：`unverified_hint`。

| 深度 | Entry id | Lean 文件 |
|---|---|---|
| d0 | `statistics.model.definition` | `SandronesLibrary/Statistics/Model.lean` |
| d0 | `statistics.model.density` | `SandronesLibrary/Statistics/Density.lean` |
| d1 | `probability.space.definition` | `SandronesLibrary/Probability/Space.lean` |

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

- `statistics.testing.definition`：`traces/lean/statistics/statistics.testing.definition.jsonl`
- `statistics.testing.neyman-pearson`：`traces/lean/statistics/statistics.testing.neyman-pearson.jsonl`
- schema：`sandrones-lean-attempt/1`；join key 字段：`pack_id`
- 每条 attempt 记录必须带同一个 pack_id，否则该轨迹无法与上下文配对。

## 8. 冻结声明（目标文件里已冻结、不得改签名的声明）

**`statistics.testing.definition`**（`SandronesLibrary/Statistics/TestingDefinition.lean`）：

本目标文件里没有冻结声明（新文件从零开始）。

**`statistics.testing.neyman-pearson`**（`SandronesLibrary/Statistics/NeymanPearson.lean`）：

本目标文件里没有冻结声明（新文件从零开始）。

> 签名先冻结再填证明（AGENTS §5 sorry 框架法）；改签名必须升级。

## 9. 窗口手写残量（`--note`，无法从权威源推导的判断）

> 本节是简令里**唯一**手写部分，与 pack 的推导字段分开标注，便于日后审计漂移。

S1 已验收，Main 本轮仅开放 S2 入口研究；不能把 likelihood 在 RN 零测集上的版本选择抹掉，也不能静默排除随机化阈值或 size=0/1 边界。未准正式开发。

---

派工坐标与全部推导字段见 `docs/dispatch/f11-f11-statistics.md` 对应的 pack 文件；简令与 pack 不一致时**以 pack 为准**，并报告 Main 重新生成简令。
