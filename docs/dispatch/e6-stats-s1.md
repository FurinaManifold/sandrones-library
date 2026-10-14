# E6　statistics / 批次 `S1rest`

> **本文件由 `scripts/dispatch_brief.py` 从 pack 渲染，请勿手改**——要改范围或边界就改权威源（ROADMAP / AGENTS / Playbook）再重新生成。

| 项 | 值 |
|---|---|
| worktree | `/home/pisquare/czt/sandrones-library-stats-s1` |
| 分支 | `codex/statistics-s1-rest` |
| 基线 | `bc8d4feb59f639aa440d7719466297d918e9dd28` |
| 学科 / 批次 | `statistics` / `S1rest` |
| 角色 | `subject-maintainer` |
| 本窗 pack 数 | 2 |

开工先读 `docs/LEAN-PLAYBOOK.md` **§10（并行窗口派工规程）**，再读你自己的 pack 文件原文。

## 1. 范围（本窗要做的 Entry）

| Entry id | 内容 | 前置 | Lean 文件 | pack_id |
|---|---|---|---|---|
| `statistics.method-of-moments` | 矩估计 | moments | `SandronesLibrary/Statistics/MethodOfMoments.lean` | `statistics-S1rest-statistics.method-of-moments` |
| `statistics.information.cramer-rao` | Fisher 信息与 Cramér–Rao | 微分与积分交换 | `SandronesLibrary/Statistics/CramerRao.lean` | `statistics-S1rest-statistics.information.cramer-rao` |

**目标一句话**（pack 里唯一手写的字段，逐条抄录）：

- `statistics.method-of-moments`：交付矩估计的定义与一致性前提，写清模型族可测性与矩存在性
- `statistics.information.cramer-rao`：交付 Cramér–Rao 下界，把微分与积分可交换的正则条件显式写进签名

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
| 1 | `statistics.model.definition` | 统计模型、样本与参数族 ✅ |
| 1b | `statistics.model.density` | 支配模型与联合可测 Radon--Nikodym 密度 ✅ |
| 2 | `statistics.estimator.definition` | 统计量、估计量与风险 ✅ |
| 3 | `statistics.estimator.bias-variance` | 偏差—方差分解 ✅ |
| 4 | `statistics.estimator.consistency` | 共同观测空间上的逐参数相合与 `L²` 充分条件 ✅ |
| 5 | `statistics.sufficiency.definition` | 充分统计量与重构入口 ✅ |
| 7 | `statistics.maximum-likelihood` | ✅ 似然函数与最大似然估计（Wave R1）：RN 密度承载似然、`IsMaximumLikelihoodEstimator` 用 a.e. argmax 定义并给出订单／存在性；未含支配字段，可测选择与相合性／渐近正态性未证 |
| 8 | `statistics.information.cramer-rao` | Fisher 信息与 Cramér–Rao |
| 1 | `statistics.testing.definition` | 检验、两类错误与功效 |
| 2 | `statistics.testing.neyman-pearson` | Neyman–Pearson 引理 |
| 3 | `statistics.testing.likelihood-ratio` | 广义似然比检验入口 |
| 4 | `statistics.confidence-set` | 置信集合与覆盖概率 |
| 5 | `statistics.regression.linear-model` | 线性模型与最小二乘 |
| 6 | `statistics.regression.gauss-markov` | Gauss–Markov 定理 |
| 7 | `statistics.regression.normal-equations` | 正规方程与可识别性 |
| 8 | `statistics.regression.inference` | 正态误差下区间与检验 |

> out_of_scope 是同族但**本批明确不做**的条目：不得顺手实现，也不得改动它们的文件；越界即升级。

## 4. 前置闭包（从 Registry 推导）

闭包深度 2；Mathlib 状态：`unverified_hint`。

| 深度 | Entry id | Lean 文件 |
|---|---|---|
| d0 | `statistics.estimator.definition` | `SandronesLibrary/Statistics/Estimator.lean` |
| d0 | `statistics.model.definition` | `SandronesLibrary/Statistics/Model.lean` |
| d1 | `probability.space.definition` | `SandronesLibrary/Probability/Space.lean` |

**Mathlib 候选**（计划模式下是**未验证提示**，不是已确认承载——先 `#check` 实测）：

```
MeasureTheory.integral
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

- 路径：`traces/lean/statistics/statistics.method-of-moments.jsonl`
- schema：`sandrones-lean-attempt/1`；join key 字段：`pack_id`
- 每条 attempt 记录必须带同一个 pack_id，否则该轨迹无法与上下文配对。

## 8. 冻结声明（目标文件里已冻结、不得改签名的声明）

本批目标文件里没有冻结声明（新文件从零开始）。

> 签名先冻结再填证明（AGENTS §5 sorry 框架法）；改签名必须升级。

## 9. 窗口手写残量（`--note`，无法从权威源推导的判断）

> 本节是简令里**唯一**手写部分，与 pack 的推导字段分开标注，便于日后审计漂移。

**本窗关键在 Cramér–Rao 的诚实边界**：它依赖"微分与积分可交换"，这是一个**实质假设**，
不是技术细节。必须把所需正则条件**显式写进签名**，而不是默默引用 Mathlib 的某个强定理；
做不到就把强度登记为 foundation／bridge，并在叙述层的「未完成边界」写清。

**ROADMAP §10 的要求**：「不在测度/可测性前提不清时使用非正式"密度最大化"」——
矩估计同样要写清模型族的可测性与矩存在性前提。

**本窗不做 S2**（检验与回归 🔒）：`statistics.testing.*`、`confidence-set`、`regression.*`
全部不做；S2 依赖 S1 整体完成，开门由 Main 决定。

---

派工坐标与全部推导字段见 `docs/dispatch/e6-stats-s1.md` 对应的 pack 文件；简令与 pack 不一致时**以 pack 为准**，并报告 Main 重新生成简令。
