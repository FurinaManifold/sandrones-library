# E4　number-theory / 批次 `N2res`

> **本文件由 `scripts/dispatch_brief.py` 从 pack 渲染，请勿手改**——要改范围或边界就改权威源（ROADMAP / AGENTS / Playbook）再重新生成。

| 项 | 值 |
|---|---|
| worktree | `/home/pisquare/czt/sandrones-library-nt-n2-research` |
| 分支 | `codex/number-theory-algebraic-research` |
| 基线 | `bc8d4feb59f639aa440d7719466297d918e9dd28` |
| 学科 / 批次 | `number-theory` / `N2res` |
| 角色 | `subject-maintainer` |
| 本窗 pack 数 | 1 |

开工先读 `docs/LEAN-PLAYBOOK.md` **§10（并行窗口派工规程）**，再读你自己的 pack 文件原文。

## 1. 范围（本窗要做的 Entry）

| Entry id | 内容 | 前置 | Lean 文件 | pack_id |
|---|---|---|---|---|
| `number-theory.algebraic.norm-trace` | 范数与迹 | `Algebra.norm/trace` | `SandronesLibrary/NumberTheory/Algebraic/NormTrace.lean` | `number-theory-N2res-number-theory.algebraic.norm-trace` |

**目标一句话**（pack 里唯一手写的字段，逐条抄录）：

- `number-theory.algebraic.norm-trace`：研究窗：为 N2.4–N2.15 给出签名冻结提案与无占位原型，起点是范与迹

## 2. 文件所有权（从 AGENTS §3 推导，pack 原文）

**可写：**

- `SandronesLibrary/NumberTheory/**`
- `docs/entries/number-theory/**`
- `docs/handoffs/number-theory-*.md`
- `docs/maintenance/number-theory-*.md`
- `traces/lean/number-theory/**`
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
| 1 | `number-theory.algebraic.number-field` | ✅ 数域与有限扩张 |
| 2 | `number-theory.algebraic.algebraic-integer` | ✅ 代数整数与整闭包 |
| 3 | `number-theory.algebraic.ring-of-integers` | ✅ 整数环（分式域／整闭／秩） |
| 5 | `number-theory.algebraic.discriminant` | 判别式与整基 |
| 6 | `number-theory.algebraic.dedekind` | 整数环的 Dedekind 性 |
| 7 | `number-theory.algebraic.fractional-ideal` | 分式理想 |
| 8 | `number-theory.algebraic.ideal-factorization` | 非零理想唯一分解 |
| 9 | `number-theory.algebraic.class-group` | 理想类群与类数 |
| 10 | `number-theory.algebraic.prime-decomposition` | 分解、分歧、惯性 |
| 11 | `number-theory.algebraic.minkowski` | Minkowski 嵌入与界 |
| 12 | `number-theory.algebraic.unit-theorem` | Dirichlet 单位定理 |
| 13 | `number-theory.algebraic.valuation` | 离散赋值与局部化 |
| 14 | `number-theory.algebraic.padic-completion` | p-进数与完备化 |
| 15 | `number-theory.algebraic.local-field-entry` | 局部域与局部—整体入口 |

> out_of_scope 是同族但**本批明确不做**的条目：不得顺手实现，也不得改动它们的文件；越界即升级。

## 4. 前置闭包（从 Registry 推导）

闭包深度 2；Mathlib 状态：`unverified_hint`。

| 深度 | Entry id | Lean 文件 |
|---|---|---|
| d0 | `number-theory.algebraic.number-field` | `SandronesLibrary/NumberTheory/Algebraic/NumberField.lean` |
| d0 | `number-theory.algebraic.ring-of-integers` | `SandronesLibrary/NumberTheory/Algebraic/RingOfIntegers.lean` |
| d1 | `number-theory.algebraic.algebraic-integer` | `SandronesLibrary/NumberTheory/Algebraic/AlgebraicInteger.lean` |

**Mathlib 候选**（计划模式下是**未验证提示**，不是已确认承载——先 `#check` 实测）：

```
Algebra.norm
Algebra.trace
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

- 路径：`traces/lean/number-theory/number-theory.algebraic.norm-trace.jsonl`
- schema：`sandrones-lean-attempt/1`；join key 字段：`pack_id`
- 每条 attempt 记录必须带同一个 pack_id，否则该轨迹无法与上下文配对。

## 8. 冻结声明（目标文件里已冻结、不得改签名的声明）

本批目标文件里没有冻结声明（新文件从零开始）。

> 签名先冻结再填证明（AGENTS §5 sorry 框架法）；改签名必须升级。

## 9. 窗口手写残量（`--note`，无法从权威源推导的判断）

> 本节是简令里**唯一**手写部分，与 pack 的推导字段分开标注，便于日后审计漂移。

**本窗权限是 `research_open`，不产生可集成交付。** 出口见 Playbook §10.4：签名冻结提案 +
无占位 `/tmp` 原型（原型允许 `sorry`，但每个 `sorry` 必须列条目说明在等什么）+ 接口契约 +
诚实边界。**不要写 `SandronesLibrary/` 下的正式文件，不要改 Registry。**

**本窗的关键判定**：`dedekind`／`fractional-ideal`／`ideal-factorization`／`class-group`
这一串是类群与唯一分解的前置。ROADMAP §1.2 Wave C 明文「未有 Dedekind／分式理想定义前，
不登记类群和唯一分解」——RFC 必须把这条依赖链与"哪些能在现有 Mathlib 上做到课程强度、
哪些只能登记 foundation／bridge"说清楚。

**起点**：N2.1–N2.3 已集成（`number-theory.algebraic.{number-field, algebraic-integer,
ring-of-integers}`），先读它们的 Lean 与叙述层，它们决定 N2.4+ 的接口起点。

---

派工坐标与全部推导字段见 `docs/dispatch/e4-nt-n2-research.md` 对应的 pack 文件；简令与 pack 不一致时**以 pack 为准**，并报告 Main 重新生成简令。
