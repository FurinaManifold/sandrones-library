# F08　commutative-algebra / 批次 `CA2base-F`

> **本文件由 `scripts/dispatch_brief.py` 从 pack 渲染，请勿手改**——要改范围或边界就改权威源（ROADMAP / AGENTS / Playbook）再重新生成。

| 项 | 值 |
|---|---|
| worktree | `/home/pisquare/czt/sandrones-library-f08-commutative-algebra` |
| 分支 | `codex/f08-commutative-algebra` |
| 基线 | `94421807384d5ae159d14629b9c97a456d1dd9bb` |
| 学科 / 批次 | `commutative-algebra` / `CA2base-F` |
| 角色 | `subject-maintainer` |
| 本窗 pack 数 | 3 |

开工先读 `docs/LEAN-PLAYBOOK.md` **§10（并行窗口派工规程）**，再读你自己的 pack 文件原文。

## 1. 范围（本窗要做的 Entry）

| Entry id | 内容 | 前置 | Lean 文件 | pack_id |
|---|---|---|---|---|
| `commutative-algebra.module.finite-generation` | 有限生成模及生成元变换 | CA1 | `SandronesLibrary/CommutativeAlgebra/ModuleFiniteGeneration.lean` | `commutative-algebra-CA2base-F-commutative-algebra.module.finite-generation` |
| `commutative-algebra.module.free` | 自由模、基与秩 | CA1/L1 | `SandronesLibrary/CommutativeAlgebra/ModuleFree.lean` | `commutative-algebra-CA2base-F-commutative-algebra.module.free` |
| `commutative-algebra.module.exact-sequence` | 模同态序列、正合性、分裂正合 | CA1 | `SandronesLibrary/CommutativeAlgebra/ModuleExactSequence.lean` | `commutative-algebra-CA2base-F-commutative-algebra.module.exact-sequence` |

**目标一句话**（pack 里唯一手写的字段，逐条抄录）：

- `commutative-algebra.module.finite-generation`：交付有限生成模与生成元变换的教材定义链
- `commutative-algebra.module.free`：交付自由模、基与秩的教材承载、刻画与消费者
- `commutative-algebra.module.exact-sequence`：交付模同态正合与分裂正合的定义、刻画和组装定理

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
| CA1 | `commutative-algebra.module.generated` | 子集生成子模及最小性 ✅（2026-10-14，15 声明） |
| CA1 | `commutative-algebra.module.quotient` | 商模、自然投影与商映射泛性质 ✅（2026-10-14，18 声明；唯一自证定理 `quotient_liftQ_exists_unique`） |
| CA1 | `commutative-algebra.module.isomorphism-theorems` | 模的三大同构定理 ✅（2026-10-14，22 声明；**自建完整链，零调用 Mathlib 现成等价**） |
| CA1 | `commutative-algebra.module.direct-sum` | 内外直和及分解判据 ✅（2026-10-14，22 声明；两项内直和 + 一般族分解，无 n 元判据） |
| CA2 | `commutative-algebra.module.free` | 自由模、基与秩 |
| CA2 | `commutative-algebra.module.exact-sequence` | 模同态序列、正合性、分裂正合 |
| CA2 | `commutative-algebra.module.projective` | 投射模及提升性质 |
| CA2 | `commutative-algebra.module.injective` | 内射模及延拓性质 |
| CA2 | `commutative-algebra.module.flat` | 平坦模与张量保持单射 |
| CA2 | `commutative-algebra.module.finite-generation` | 有限生成模及生成元变换 |

> out_of_scope 是同族但**本批明确不做**的条目：不得顺手实现，也不得改动它们的文件；越界即升级。

## 4. 前置闭包（从 Registry 推导）

### 4.1 `commutative-algebra.module.finite-generation`

闭包深度 2；Mathlib 状态：`unverified_hint`。

| 深度 | Entry id | Lean 文件 |
|---|---|---|
| d0 | `commutative-algebra.module.generated` | `SandronesLibrary/CommutativeAlgebra/Module/Generated.lean` |
| d1 | `commutative-algebra.module.definition` | `SandronesLibrary/CommutativeAlgebra/Module/Definition.lean` |
| d2 | `abstract-algebra.ring.def` | `SandronesLibrary/AbstractAlgebra/Ring.lean` |
| d2 | `abstract-algebra.ring.ideal` | `SandronesLibrary/AbstractAlgebra/Ring.lean` |
| d2 | `linear-algebra.vector-space.def` | `SandronesLibrary/LinearAlgebra/VectorSpace.lean` |
| d2 | `linear-algebra.vector-space.subspace` | `SandronesLibrary/LinearAlgebra/Subspace.lean` |

### 4.2 `commutative-algebra.module.free`

闭包深度 2；Mathlib 状态：`unverified_hint`。

| 深度 | Entry id | Lean 文件 |
|---|---|---|
| d0 | `commutative-algebra.module.definition` | `SandronesLibrary/CommutativeAlgebra/Module/Definition.lean` |
| d1 | `abstract-algebra.ring.def` | `SandronesLibrary/AbstractAlgebra/Ring.lean` |
| d1 | `abstract-algebra.ring.ideal` | `SandronesLibrary/AbstractAlgebra/Ring.lean` |
| d1 | `linear-algebra.vector-space.def` | `SandronesLibrary/LinearAlgebra/VectorSpace.lean` |
| d1 | `linear-algebra.vector-space.subspace` | `SandronesLibrary/LinearAlgebra/Subspace.lean` |

### 4.3 `commutative-algebra.module.exact-sequence`

闭包深度 2；Mathlib 状态：`unverified_hint`。

| 深度 | Entry id | Lean 文件 |
|---|---|---|
| d0 | `commutative-algebra.module.definition` | `SandronesLibrary/CommutativeAlgebra/Module/Definition.lean` |
| d0 | `commutative-algebra.module.quotient` | `SandronesLibrary/CommutativeAlgebra/Module/Quotient.lean` |
| d1 | `abstract-algebra.ring.def` | `SandronesLibrary/AbstractAlgebra/Ring.lean` |
| d1 | `abstract-algebra.ring.ideal` | `SandronesLibrary/AbstractAlgebra/Ring.lean` |
| d1 | `linear-algebra.vector-space.def` | `SandronesLibrary/LinearAlgebra/VectorSpace.lean` |
| d1 | `linear-algebra.vector-space.subspace` | `SandronesLibrary/LinearAlgebra/Subspace.lean` |

## 5. Playbook 必读节（指回去读，不复制正文）

| 锚点 | 标题 | 行号 |
|---|---|---|
| `§0` | 工作流铁律（Step 3 遇到困难时，按此顺序） | LNone |
| `§1.1` | `exact` 报类型不匹配时，先用 `exact?` / `apply?` / `rw?` 问编译器（由原 §3.17 提升） | LNone |
| `§1.2` | `No goals to be solved`：直接把多余的 tactic 删掉，别干别的（由原 §3.14 提升） | LNone |
| `§1.3` | `lake build` 的增量失误：改顶层 import 的子模块后，顶层 olean 可能不刷新（由原 §3.10 提升） | LNone |
| `§3` | 公理纪律（Classical.choice 最小化）（由原 §3.5–3.9 提升合并） | LNone |
| `§8` | Lean 验证轨迹语料（JSON）：底层子 Agent 的强制留痕 | LNone |
| `§2.13` | 带 `if` 的递归 def：`by_cases` + `simp only` + `dif_pos/dif_neg`（由原 §3.13 提升） | LNone |

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

- `commutative-algebra.module.finite-generation`：`traces/lean/commutative-algebra/commutative-algebra.module.finite-generation.jsonl`
- `commutative-algebra.module.free`：`traces/lean/commutative-algebra/commutative-algebra.module.free.jsonl`
- `commutative-algebra.module.exact-sequence`：`traces/lean/commutative-algebra/commutative-algebra.module.exact-sequence.jsonl`
- schema：`sandrones-lean-attempt/1`；join key 字段：`pack_id`
- 每条 attempt 记录必须带同一个 pack_id，否则该轨迹无法与上下文配对。

## 8. 冻结声明（目标文件里已冻结、不得改签名的声明）

**`commutative-algebra.module.finite-generation`**（`SandronesLibrary/CommutativeAlgebra/ModuleFiniteGeneration.lean`）：

本目标文件里没有冻结声明（新文件从零开始）。

**`commutative-algebra.module.free`**（`SandronesLibrary/CommutativeAlgebra/ModuleFree.lean`）：

本目标文件里没有冻结声明（新文件从零开始）。

**`commutative-algebra.module.exact-sequence`**（`SandronesLibrary/CommutativeAlgebra/ModuleExactSequence.lean`）：

本目标文件里没有冻结声明（新文件从零开始）。

> 签名先冻结再填证明（AGENTS §5 sorry 框架法）；改签名必须升级。

## 9. 窗口手写残量（`--note`，无法从权威源推导的判断）

> 本节是简令里**唯一**手写部分，与 pack 的推导字段分开标注，便于日后审计漂移。

三条相对独立，适合三个 worker；projective/injective 留下一批，flat 仍等张量积。优先解释现有 Mathlib 正式承载，不制造同构包装结构。

---

派工坐标与全部推导字段见 `docs/dispatch/f08-f08-commutative-algebra.md` 对应的 pack 文件；简令与 pack 不一致时**以 pack 为准**，并报告 Main 重新生成简令。
