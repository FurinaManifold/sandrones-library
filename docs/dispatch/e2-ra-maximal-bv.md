# E2　real-analysis / 批次 `RA-F3F5`

> **本文件由 `scripts/dispatch_brief.py` 从 pack 渲染，请勿手改**——要改范围或边界就改权威源（ROADMAP / AGENTS / Playbook）再重新生成。

| 项 | 值 |
|---|---|
| worktree | `/home/pisquare/czt/sandrones-library-ra-maximal-bv` |
| 分支 | `codex/real-analysis-maximal-bv` |
| 基线 | `bc8d4feb59f639aa440d7719466297d918e9dd28` |
| 学科 / 批次 | `real-analysis` / `RA-F3F5` |
| 角色 | `subject-maintainer` |
| 本窗 pack 数 | 5 |

开工先读 `docs/LEAN-PLAYBOOK.md` **§10（并行窗口派工规程）**，再读你自己的 pack 文件原文。

## 1. 范围（本窗要做的 Entry）

| Entry id | 内容 | 前置 | Lean 文件 | pack_id |
|---|---|---|---|---|
| `real-analysis.covering-lemma` | （计划中新条目：尚未登记 Registry） | — | `SandronesLibrary/RealAnalysis/CoveringLemma.lean` | `real-analysis-RA-F3F5-real-analysis.covering-lemma` |
| `real-analysis.maximal-function` | （计划中新条目：尚未登记 Registry） | — | `SandronesLibrary/RealAnalysis/MaximalFunction.lean` | `real-analysis-RA-F3F5-real-analysis.maximal-function` |
| `real-analysis.monotone-function` | （计划中新条目：尚未登记 Registry） | — | `SandronesLibrary/RealAnalysis/MonotoneFunction.lean` | `real-analysis-RA-F3F5-real-analysis.monotone-function` |
| `real-analysis.bounded-variation` | （计划中新条目：尚未登记 Registry） | — | `SandronesLibrary/RealAnalysis/BoundedVariation.lean` | `real-analysis-RA-F3F5-real-analysis.bounded-variation` |
| `real-analysis.absolute-continuity-function` | （计划中新条目：尚未登记 Registry） | — | `SandronesLibrary/RealAnalysis/AbsoluteContinuityFunction.lean` | `real-analysis-RA-F3F5-real-analysis.absolute-continuity-function` |

**目标一句话**（pack 里唯一手写的字段，逐条抄录）：

- `real-analysis.covering-lemma`：先冻结覆盖引理接口签名，作为极大函数弱型估计的前置
- `real-analysis.maximal-function`：交付 Hardy–Littlewood 极大函数的教材定义、弱型 (1,1) 估计与可测性边界，保留课程证明骨架
- `real-analysis.monotone-function`：交付单调函数的间断结构、a.e. 可导性与 Stieltjes 测度桥
- `real-analysis.bounded-variation`：交付有界变差定义、Jordan 分解（BV = 增 − 增）与全变差的关系
- `real-analysis.absolute-continuity-function`：交付绝对连续函数定义、与 BV／Lipschitz 的关系及 a.e. 导数

## 2. 文件所有权（从 AGENTS §3 推导，pack 原文）

**可写：**

- `SandronesLibrary/RealAnalysis/**`
- `docs/entries/real-analysis/**`
- `docs/handoffs/real-analysis-*.md`
- `docs/maintenance/real-analysis-*.md`
- `traces/lean/real-analysis/**`
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
| d0 | `real-analysis.measure.def` | `SandronesLibrary/RealAnalysis/Measure.lean` |
| d1 | `real-analysis.measure.sigma-algebra` | `SandronesLibrary/RealAnalysis/Measure.lean` |

**Mathlib 候选**（计划模式下是**未验证提示**，不是已确认承载——先 `#check` 实测）：

```
IsUnifLocDoublingMeasure
VitaliFamily
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

- 路径：`traces/lean/real-analysis/real-analysis.covering-lemma.jsonl`
- schema：`sandrones-lean-attempt/1`；join key 字段：`pack_id`
- 每条 attempt 记录必须带同一个 pack_id，否则该轨迹无法与上下文配对。

## 8. 冻结声明（目标文件里已冻结、不得改签名的声明）

本批目标文件里没有冻结声明（新文件从零开始）。

> 签名先冻结再填证明（AGENTS §5 sorry 框架法）；改签名必须升级。

## 9. 窗口手写残量（`--note`，无法从权威源推导的判断）

> 本节是简令里**唯一**手写部分，与 pack 的推导字段分开标注，便于日后审计漂移。

**本节的硬约束（ROADMAP §6 原文，Main 会逐条核）**

- **RA-F3 不得只包装 `ae_lebesguePoint` 或最终微分强定理**：必须保留覆盖／弱型估计、
  简单函数或 `L¹` 逼近、坏集测度控制以及通向 a.e. 结论的证明骨架。做不到就把强度诚实登记为
  foundation／bridge，**不能宣称整条 Folland 定理已完成**。
- 交付证据须明确：正／有符号／复测度类型、标量、有限性或 σ-有限性、`a.e.` 依赖的哪个测度、
  积分类型（`lintegral`／Bochner／区间积分）、等式是处处／a.e.／测度相等。
  **自然语言不得把 a.e. 结论写成逐点结论。**
- 教材 Folland 2nd ed.，文献键 `folland-real-analysis-1999` 已存在，勿新增；章节定位写 Entry 正文。

**窗口判断**：F3 与 F5 相互独立，建议两个子 Agent 分头做、文件不重叠；
`real-analysis.covering-lemma` 是 F3 的前置，**先冻结签名**再让上层并行（AGENTS §1.2）。

**本窗不做**：RA-F4（Lebesgue 点与微分定理）、RA-F6（FTC 的 a.e. 版本）——它们依赖本窗成果。
`real-analysis.absolute-continuity-function` 的自然前置 `real-analysis.bounded-variation`
是同批条目，Main 预生成 pack 时尚未登记，你按 §10.3 自行补 pack。

---

派工坐标与全部推导字段见 `docs/dispatch/e2-ra-maximal-bv.md` 对应的 pack 文件；简令与 pack 不一致时**以 pack 为准**，并报告 Main 重新生成简令。
