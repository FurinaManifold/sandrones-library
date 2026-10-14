# E1　commutative-algebra / 批次 `CA1b2`

> **本文件由 `scripts/dispatch_brief.py` 从 pack 渲染，请勿手改**——要改范围或边界就改权威源（ROADMAP / AGENTS / Playbook）再重新生成。

| 项 | 值 |
|---|---|
| worktree | `/home/pisquare/czt/sandrones-library-ca-b2` |
| 分支 | `codex/commutative-algebra-b2` |
| 基线 | `bc8d4feb59f639aa440d7719466297d918e9dd28` |
| 学科 / 批次 | `commutative-algebra` / `CA1b2` |
| 角色 | `subject-maintainer` |
| 本窗 pack 数 | 3 |

开工先读 `docs/LEAN-PLAYBOOK.md` **§10（并行窗口派工规程）**，再读你自己的 pack 文件原文。

## 1. 范围（本窗要做的 Entry）

| Entry id | 内容 | 前置 | Lean 文件 | pack_id |
|---|---|---|---|---|
| `commutative-algebra.module.generated` | 子集生成子模及最小性 | CA1.definition | `SandronesLibrary/CommutativeAlgebra/Module/Generated.lean` | `commutative-algebra-CA1b2-commutative-algebra.module.generated` |
| `commutative-algebra.module.quotient` | 商模、自然投影与商映射泛性质 | CA1.definition | `SandronesLibrary/CommutativeAlgebra/Module/Quotient.lean` | `commutative-algebra-CA1b2-commutative-algebra.module.quotient` |
| `commutative-algebra.module.direct-sum` | 内外直和及分解判据 | CA1.definition | `SandronesLibrary/CommutativeAlgebra/Module/DirectSum.lean` | `commutative-algebra-CA1b2-commutative-algebra.module.direct-sum` |

**目标一句话**（pack 里唯一手写的字段，逐条抄录）：

- `commutative-algebra.module.generated`：交付子集生成子模的教材定义、最小性刻画与 Mathlib 承载分类
- `commutative-algebra.module.quotient`：交付商模、自然投影与商映射的泛性质（不只是类型别名包装）
- `commutative-algebra.module.direct-sum`：交付内直和与外直和的定义、分解判据及两者的桥

## 2. 文件所有权（从 AGENTS §3 推导，pack 原文）

**可写：**

- `SandronesLibrary/CommutativeAlgebra/**`
- `docs/entries/commutative-algebra/**`
- `docs/handoffs/commutative-algebra-*.md`
- `docs/maintenance/commutative-algebra-*.md`
- `traces/lean/commutative-algebra/**`
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
| CA1 | `commutative-algebra.module.definition` | 模、子模与模同态的教材定义及 Mathlib 桥 ✅ `verified`（2026-10-13 集成，11 声明） |
| CA1 | `commutative-algebra.module.quotient` | 商模、自然投影与商映射泛性质 |
| CA1 | `commutative-algebra.module.isomorphism-theorems` | 模的三大同构定理 |
| CA1 | `commutative-algebra.module.direct-sum` | 内外直和及分解判据 |
| CA2 | `commutative-algebra.module.finite-generation` | 有限生成模及生成元变换 |
| CA2 | `commutative-algebra.module.free` | 自由模、基与秩 |
| CA2 | `commutative-algebra.module.exact-sequence` | 模同态序列、正合性、分裂正合 |
| CA2 | `commutative-algebra.module.projective` | 投射模及提升性质 |
| CA2 | `commutative-algebra.module.injective` | 内射模及延拓性质 |
| CA2 | `commutative-algebra.module.flat` | 平坦模与张量保持单射 |

> out_of_scope 是同族但**本批明确不做**的条目：不得顺手实现，也不得改动它们的文件；越界即升级。

## 4. 前置闭包（从 Registry 推导）

闭包深度 2；Mathlib 状态：`unverified_hint`。

| 深度 | Entry id | Lean 文件 |
|---|---|---|
| d0 | `commutative-algebra.module.definition` | `SandronesLibrary/CommutativeAlgebra/Module/Definition.lean` |
| d1 | `abstract-algebra.ring.def` | `SandronesLibrary/AbstractAlgebra/Ring.lean` |
| d1 | `abstract-algebra.ring.ideal` | `SandronesLibrary/AbstractAlgebra/Ring.lean` |
| d1 | `linear-algebra.vector-space.def` | `SandronesLibrary/LinearAlgebra/VectorSpace.lean` |
| d1 | `linear-algebra.vector-space.subspace` | `SandronesLibrary/LinearAlgebra/Subspace.lean` |

**Mathlib 候选**（计划模式下是**未验证提示**，不是已确认承载——先 `#check` 实测）：

```
Submodule.mem_span
Submodule.span
Submodule.span_eq
Submodule.span_le
Submodule.span_mono
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

- 路径：`traces/lean/commutative-algebra/commutative-algebra.module.generated.jsonl`
- schema：`sandrones-lean-attempt/1`；join key 字段：`pack_id`
- 每条 attempt 记录必须带同一个 pack_id，否则该轨迹无法与上下文配对。

## 8. 冻结声明（目标文件里已冻结、不得改签名的声明）

本批目标文件里没有冻结声明（新文件从零开始）。

> 签名先冻结再填证明（AGENTS §5 sorry 框架法）；改签名必须升级。

## 9. 窗口手写残量（`--note`，无法从权威源推导的判断）

> 本节是简令里**唯一**手写部分，与 pack 的推导字段分开标注，便于日后审计漂移。

**已就位**：`commutative-algebra.module.definition` 已于 2026-10-14 集成（11 声明、无 sorry）。
先读 `SandronesLibrary/CommutativeAlgebra/Module/Definition.lean` 与
`docs/entries/commutative-algebra/module/definition.md`，沿用其文件头、docstring 体例
（每条声明带 `> **Entry**: <id>`）、四类角色分类写法与两条桥的引用方式。**不要重复实现已有内容。**

**出口条件（超出 pack 推导的部分）**

1. 商模必须给出自然投影的**泛性质**，不能只是 `Submodule.Quotient` 的类型别名包装；
2. 直和要区分**内直和**与**外直和**并给出分解判据；
3. 同构定理三条（第一/第二/第三）必须各有完整证明链，不得只包装 Mathlib 结论；
4. `commutative-algebra.module.isomorphism-theorems` **仅在 quotient 验收通过后**开工，
   它的 pack 由你按 §10.3 生成（其前置 `…module.quotient` 当时尚未登记，Main 无法预生成）。

**难点**：本版 Mathlib 的商模接口在 `Submodule.Quotient` 一侧且命名不直观；`Ideal R` 是
`@[reducible] def Ideal R := Submodule R R`。开工第一步 `#check`/`#print` 候选名，别按记忆写。

---

派工坐标与全部推导字段见 `docs/dispatch/e1-ca-b2.md` 对应的 pack 文件；简令与 pack 不一致时**以 pack 为准**，并报告 Main 重新生成简令。
