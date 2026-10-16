# F05　functional-analysis / 批次 `F66b2-F`

> **本文件由 `scripts/dispatch_brief.py` 从 pack 渲染，请勿手改**——要改范围或边界就改权威源（ROADMAP / AGENTS / Playbook）再重新生成。

| 项 | 值 |
|---|---|
| worktree | `/home/pisquare/czt/sandrones-library-f05-functional-analysis` |
| 分支 | `codex/f05-functional-analysis` |
| 基线 | `94421807384d5ae159d14629b9c97a456d1dd9bb` |
| 学科 / 批次 | `functional-analysis` / `F66b2-F` |
| 角色 | `subject-maintainer` |
| 本窗 pack 数 | 1 |

开工先读 `docs/LEAN-PLAYBOOK.md` **§10（并行窗口派工规程）**，再读你自己的 pack 文件原文。

## 1. 范围（本窗要做的 Entry）

| Entry id | 内容 | 前置 | Lean 文件 | pack_id |
|---|---|---|---|---|
| `functional-analysis.functional-calculus.holomorphic` | Dunford 积分、代数同态与谱映射（`research_open`） | complex cycle foundation、resolvent integral | `SandronesLibrary/FunctionalAnalysis/FunctionalCalculusHolomorphic.lean` | `functional-analysis-F66b2-F-functional-analysis.functional-calculus.holomorphic` |

**目标一句话**（pack 里唯一手写的字段，逐条抄录）：

- `functional-analysis.functional-calculus.holomorphic`：在既有 F66b2 签名冻结研究上推进 Dunford 积分的组装、单位与代数性质原型，记录对同调 Cauchy 的真实依赖

## 2. 文件所有权（从 AGENTS §3 推导，pack 原文）

**可写：**

- `SandronesLibrary/FunctionalAnalysis/**`
- `docs/entries/functional-analysis/**`
- `docs/handoffs/functional-analysis-*.md`
- `docs/maintenance/functional-analysis-*.md`
- `traces/lean/functional-analysis/**`
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
| 6a | `functional-analysis.functional-calculus.holomorphic-neighborhood` | 谱邻域全纯谓词、交集见证与代数正例 ✅ |
| 6b1 | `functional-analysis.functional-calculus.resolvent-integrand` | 预解恒等式、预解函数全纯性与 Dunford 被积函数 ✅ |
| 8 | `functional-analysis.functional-calculus.continuous` | 自伴／正规算子的连续函数演算 |

> out_of_scope 是同族但**本批明确不做**的条目：不得顺手实现，也不得改动它们的文件；越界即升级。

## 4. 前置闭包（从 Registry 推导）

闭包深度 2；Mathlib 状态：`unverified_hint`。

| 深度 | Entry id | Lean 文件 |
|---|---|---|
| d0 | `complex-analysis.integral.finite-cycle-foundation` | `SandronesLibrary/ComplexAnalysis/CycleCarrier.lean` |
| d0 | `functional-analysis.functional-calculus.holomorphic-neighborhood` | `SandronesLibrary/FunctionalAnalysis/HolomorphicNeighborhood.lean` |
| d0 | `functional-analysis.functional-calculus.resolvent-integrand` | `SandronesLibrary/FunctionalAnalysis/HolomorphicResolventIntegrand.lean` |
| d1 | `complex-analysis.cauchy.primitive-from-path-independence-foundation` | `SandronesLibrary/ComplexAnalysis/PrimitiveFromPathIntegral.lean` |
| d1 | `complex-analysis.holomorphic.definition` | `SandronesLibrary/ComplexAnalysis/Holomorphic.lean` |
| d1 | `complex-analysis.integral.banach-path-foundation` | `SandronesLibrary/ComplexAnalysis/BanachPathIntegral.lean` |
| d1 | `complex-analysis.path-integral.dyadic-assembly` | `SandronesLibrary/ComplexAnalysis/DyadicPathIntegralAssembly.lean` |
| d1 | `functional-analysis.spectrum.definition` | `SandronesLibrary/FunctionalAnalysis/SpectrumDefinition.lean` |
| d1 | `functional-analysis.spectrum.nonempty-compact` | `SandronesLibrary/FunctionalAnalysis/SpectrumNonemptyCompact.lean` |
| d1 | `topology.homotopy.piecewise-c1-path` | `SandronesLibrary/Topology/PiecewiseC1Path.lean` |
| d2 | `complex-analysis.cauchy.smooth-homotopy-foundation` | `SandronesLibrary/ComplexAnalysis/HomotopyInvariance.lean` |
| d2 | `complex-analysis.integral.path` | `SandronesLibrary/ComplexAnalysis/PathIntegral.lean` |
| d2 | `functional-analysis.banach-algebra.foundation` | `SandronesLibrary/FunctionalAnalysis/BanachAlgebraFoundation.lean` |
| d2 | `topology.homotopy.path-polygonal-approximation` | `SandronesLibrary/Topology/PathPolygonalApproximation.lean` |
| d2 | `topology.homotopy.unit-interval-mesh` | `SandronesLibrary/Topology/UnitIntervalMesh.lean` |

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

- `functional-analysis.functional-calculus.holomorphic`：`traces/lean/functional-analysis/functional-analysis.functional-calculus.holomorphic.jsonl`
- schema：`sandrones-lean-attempt/1`；join key 字段：`pack_id`
- 每条 attempt 记录必须带同一个 pack_id，否则该轨迹无法与上下文配对。

## 8. 冻结声明（目标文件里已冻结、不得改签名的声明）

本目标文件里没有冻结声明（新文件从零开始）。

> 签名先冻结再填证明（AGENTS §5 sorry 框架法）；改签名必须升级。

## 9. 窗口手写残量（`--note`，无法从权威源推导的判断）

> 本节是简令里**唯一**手写部分，与 pack 的推导字段分开标注，便于日后审计漂移。

先读旧 codex/functional-analysis-f66b2 分支的已提交 handoff；不能重做已经冻结的设计当新结果。泛函只消费复分析 carrier；缺同调 Cauchy 的性质保留命名义务，不能塞为装饰假设宣称已证。F6.8/F6.9/F7/F8 不开放。

---

派工坐标与全部推导字段见 `docs/dispatch/f05-f05-functional-analysis.md` 对应的 pack 文件；简令与 pack 不一致时**以 pack 为准**，并报告 Main 重新生成简令。
