# F04　complex-analysis / 批次 `Homology-F`

> **本文件由 `scripts/dispatch_brief.py` 从 pack 渲染，请勿手改**——要改范围或边界就改权威源（ROADMAP / AGENTS / Playbook）再重新生成。

| 项 | 值 |
|---|---|
| worktree | `/home/pisquare/czt/sandrones-library-f04-complex-analysis` |
| 分支 | `codex/f04-complex-analysis` |
| 基线 | `94421807384d5ae159d14629b9c97a456d1dd9bb` |
| 学科 / 批次 | `complex-analysis` / `Homology-F` |
| 角色 | `subject-maintainer` |
| 本窗 pack 数 | 1 |

开工先读 `docs/LEAN-PLAYBOOK.md` **§10（并行窗口派工规程）**，再读你自己的 pack 文件原文。

## 1. 范围（本窗要做的 Entry）

| Entry id | 内容 | 前置 | Lean 文件 | pack_id |
|---|---|---|---|---|
| `complex-analysis.cauchy.homology` | ⏳ **C2 补遗，C3 开门前置**：同调形式 Cauchy 定理（null-homologous cycle ⇒ 积分为零）与绕数整值性。第 15 行已披露的边界；残数定理的标准证明把它化归为该桥，否则只能挂靠 Mathlib | `IsNullHomologousIn`、`Finsupp`、`Real.pi` | `SandronesLibrary/ComplexAnalysis/CauchyHomology.lean` | `complex-analysis-Homology-F-complex-analysis.cauchy.homology` |

**目标一句话**（pack 里唯一手写的字段，逐条抄录）：

- `complex-analysis.cauchy.homology`：为同调形式 Cauchy 定理冻结可组装公开签名，探索完整证明并交付原型和诚实边界

## 2. 文件所有权（从 AGENTS §3 推导，pack 原文）

**可写：**

- `SandronesLibrary/ComplexAnalysis/**`
- `docs/entries/complex-analysis/**`
- `docs/handoffs/complex-analysis-*.md`
- `docs/maintenance/complex-analysis-*.md`
- `traces/lean/complex-analysis/**`
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
| 3 | `complex-analysis.cauchy.triangle` | 任意开集内的局部三角形 Cauchy--Goursat 定理 ✅ |
| 4 | `complex-analysis.cauchy.homotopy` | ✅ **2026-10-13 收口**：单连通开域上的同伦形式 Cauchy 定理——拓扑桥「`IsSimplyConnected` ⇒ 域内相对同伦」、路径无关、原函数存在、闭分段 `C¹` 道路积分为零 |
| 5 | `complex-analysis.cauchy.formula` | Cauchy 积分公式 ✅ |
| 6 | `complex-analysis.cauchy.derivatives` | 高阶导数公式与 Cauchy 估计 ✅ |
| 8 | `complex-analysis.cauchy.triangle-ball` | 圆盘内三角形边界积分为零 ✅（foundation） |
| 9 | `complex-analysis.cauchy.path-independence-primitive` | 已有原函数时路径无关 ✅（foundation） |
| 10 | `complex-analysis.cauchy.smooth-homotopy-foundation` | 给定 C² 相对端点同伦时路径积分不变 ✅（foundation） |
| 11 | `complex-analysis.cauchy.primitive-from-path-independence-foundation` | 由 admissible 道路积分无关构造原函数 ✅（foundation） |
| 12 | `complex-analysis.cauchy.admissible-path-connectivity-foundation` | 开连通域内从基点到各点存在有限分段正则道路 ✅（foundation） |

> out_of_scope 是同族但**本批明确不做**的条目：不得顺手实现，也不得改动它们的文件；越界即升级。

## 4. 前置闭包（从 Registry 推导）

闭包深度 2；Mathlib 状态：`unverified_hint`。

| 深度 | Entry id | Lean 文件 |
|---|---|---|
| d0 | `complex-analysis.cauchy.homotopy` | `SandronesLibrary/ComplexAnalysis/CauchyHomotopy.lean` |
| d0 | `complex-analysis.integral.finite-cycle-foundation` | `SandronesLibrary/ComplexAnalysis/CycleCarrier.lean` |
| d0 | `complex-analysis.integral.winding-number-foundation` | `SandronesLibrary/ComplexAnalysis/WindingIndex.lean` |
| d1 | `complex-analysis.cauchy.admissible-path-connectivity-foundation` | `SandronesLibrary/ComplexAnalysis/AdmissiblePathConnectivity.lean` |
| d1 | `complex-analysis.cauchy.primitive-from-path-independence-foundation` | `SandronesLibrary/ComplexAnalysis/PrimitiveFromPathIntegral.lean` |
| d1 | `complex-analysis.holomorphic.definition` | `SandronesLibrary/ComplexAnalysis/Holomorphic.lean` |
| d1 | `complex-analysis.integral.banach-path-foundation` | `SandronesLibrary/ComplexAnalysis/BanachPathIntegral.lean` |
| d1 | `complex-analysis.integral.path` | `SandronesLibrary/ComplexAnalysis/PathIntegral.lean` |
| d1 | `complex-analysis.path-integral.dyadic-assembly` | `SandronesLibrary/ComplexAnalysis/DyadicPathIntegralAssembly.lean` |
| d1 | `complex-analysis.path-integral.piecewise-c1-homotopy-invariance` | `SandronesLibrary/ComplexAnalysis/PiecewiseC1HomotopyInvariance.lean` |
| d1 | `topology.homotopy.homotopy-square-grid` | `SandronesLibrary/Topology/HomotopySquareGrid.lean` |
| d1 | `topology.homotopy.piecewise-c1-path` | `SandronesLibrary/Topology/PiecewiseC1Path.lean` |
| d2 | `complex-analysis.cauchy.smooth-homotopy-foundation` | `SandronesLibrary/ComplexAnalysis/HomotopyInvariance.lean` |
| d2 | `complex-analysis.path-integral.finite-raw-grid-boundary` | `SandronesLibrary/ComplexAnalysis/FiniteRawOpenPathGridBoundary.lean` |
| d2 | `topology.homotopy.indexed-open-cover-square-subdivision` | `SandronesLibrary/Topology/IndexedOpenCoverSquareSubdivision.lean` |
| d2 | `topology.homotopy.path-homotopy-standard` | `SandronesLibrary/Topology/PathHomotopyStandard.lean` |
| d2 | `topology.homotopy.path-polygonal-approximation` | `SandronesLibrary/Topology/PathPolygonalApproximation.lean` |
| d2 | `topology.homotopy.piecewise-c1-dyadic-alignment` | `SandronesLibrary/Topology/PiecewiseC1DyadicAlignment.lean` |
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

- `complex-analysis.cauchy.homology`：`traces/lean/complex-analysis/complex-analysis.cauchy.homology.jsonl`
- schema：`sandrones-lean-attempt/1`；join key 字段：`pack_id`
- 每条 attempt 记录必须带同一个 pack_id，否则该轨迹无法与上下文配对。

## 8. 冻结声明（目标文件里已冻结、不得改签名的声明）

本目标文件里没有冻结声明（新文件从零开始）。

> 签名先冻结再填证明（AGENTS §5 sorry 框架法）；改签名必须升级。

## 9. 窗口手写残量（`--note`，无法从权威源推导的判断）

> 本节是简令里**唯一**手写部分，与 pack 的推导字段分开标注，便于日后审计漂移。

只能消费现有 cycle 与复值 windingNumber；禁止把绕数未经证明地改为整数。优先解决 C3 的同调 Cauchy 门，不另造积分 carrier，也不提前做 Laurent 或残数。

---

派工坐标与全部推导字段见 `docs/dispatch/f04-f04-complex-analysis.md` 对应的 pack 文件；简令与 pack 不一致时**以 pack 为准**，并报告 Main 重新生成简令。
