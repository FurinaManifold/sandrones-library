# F07　settheory / 批次 `ST3next-F`

> **本文件由 `scripts/dispatch_brief.py` 从 pack 渲染，请勿手改**——要改范围或边界就改权威源（ROADMAP / AGENTS / Playbook）再重新生成。

| 项 | 值 |
|---|---|
| worktree | `/home/pisquare/czt/sandrones-library-f07-settheory` |
| 分支 | `codex/f07-settheory` |
| 基线 | `94421807384d5ae159d14629b9c97a456d1dd9bb` |
| 学科 / 批次 | `settheory` / `ST3next-F` |
| 角色 | `subject-maintainer` |
| 本窗 pack 数 | 2 |

开工先读 `docs/LEAN-PLAYBOOK.md` **§10（并行窗口派工规程）**，再读你自己的 pack 文件原文。

## 1. 范围（本窗要做的 Entry）

| Entry id | 内容 | 前置 | Lean 文件 | pack_id |
|---|---|---|---|---|
| `settheory.googology.hydra-termination` | 一般 Hydra 游戏终止及强度边界 | 🔒 | `SandronesLibrary/SetTheory/GoogologyHydraTermination.lean` | `settheory-ST3next-F-settheory.googology.hydra-termination` |
| `settheory.computability.diagonal-flip-instance` | 实现并验证翻转编译闭包 | 🔒 | `SandronesLibrary/SetTheory/ComputabilityDiagonalFlipInstance.lean` | `settheory-ST3next-F-settheory.computability.diagonal-flip-instance` |

**目标一句话**（pack 里唯一手写的字段，逐条抄录）：

- `settheory.googology.hydra-termination`：基于已经集成的一般 Hydra 单步下降构造无条件终止原型与精确强度边界
- `settheory.computability.diagonal-flip-instance`：研究当前 NatProgram 的翻转编译闭包并冻结签名，区分元层 runner 与可计算的程序编译器

## 2. 文件所有权（从 AGENTS §3 推导，pack 原文）

**可写：**

- `SandronesLibrary/SetTheory/**`
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
| 3 | `settheory.googology.hereditary-encoding-order` | ✅ 2026-10-14 集成：对任意 `2 ≤ b ≤ c` 与任意 `n` 证明换底重编码保持 `omegaValue`；推论把 `CanonicalGoodsteinState` 的命名义务 `CanonicalBaseChangeOmegaCompatible` 由假设升级为定理。**边界：未证无条件 Goodstein 单步下降、序列终止与 PA 边界**（分属仍 🔒 的三条） |
| 4 | `settheory.googology.goodstein-ordinal-descent` | 从局部借位推广到一般正规 Goodstein 步骤 |
| 5 | `settheory.googology.goodstein-termination` | 用序数良基性证明完整序列终止 |
| 6 | `settheory.googology.goodstein-pa-independence` | 精确形式化 PA 不可证性边界 |
| 7 | `settheory.googology.hydra-general-descent` | ✅ 2026-10-14 集成：对**任意**合法 `Hydra.Step`（任意深度、任意头位置、任意阶段复制）证明 `hydraGeneralOrdinal` 严格下降，彻底去掉最右脊柱证书。**关键数学**：旧度量 `hydraOrdinal`（列表序求和）**不可能**覆盖一般步骤——父内非最右砍头被吸收律 `1+B=B` 吃掉，反例树使序数从 `ω^ω` 升到 `ω^ω·2`，已固化为定理 `hydraOrdinal_not_general_descent`；解法是换用自然和（Hessenberg 和，Mathlib 4.33 无 `nadd`，库内自建并证其代数律）。**边界：只证单步，未证终止**（`hydra-termination` 仍 🔒）；新旧度量并存，旧文件一行未改 |
| 12 | `settheory.googology.busy-beaver-uncomputable` | 从停机问题完成不可计算性归约 |
| 9 | `settheory.computability.universal-machine-instance` | ✅ 为当前 `NatProgram` 构造通用 runner（编码／解码／`universalNatInterpreter`／输出等价；noncomputable 元层，不含自解释器与停机判定，Wave R1 `c424c95`） |
| 11 | `settheory.computability.halting-undecidable` | 去除结构参数的停机不可判定定理 |

> out_of_scope 是同族但**本批明确不做**的条目：不得顺手实现，也不得改动它们的文件；越界即升级。

## 4. 前置闭包（从 Registry 推导）

### 4.1 `settheory.googology.hydra-termination`

闭包深度 2；Mathlib 状态：`unverified_hint`。

| 深度 | Entry id | Lean 文件 |
|---|---|---|
| d0 | `settheory.googology.hydra-general-descent` | `SandronesLibrary/SetTheory/HydraGeneralDescent.lean` |
| d1 | `settheory.googology.hydra-ordinal-assignment` | `SandronesLibrary/SetTheory/HydraOrdinalAssignment.lean` |
| d1 | `settheory.ordinal.power-bridge` | `SandronesLibrary/SetTheory/OrdinalPowerBridge.lean` |
| d2 | `settheory.googology.hydra-game-step` | `SandronesLibrary/SetTheory/Hydra.lean` |
| d2 | `settheory.ordinal.addition` | `SandronesLibrary/SetTheory/Ordinal.lean` |
| d2 | `settheory.ordinal.exponentiation` | `SandronesLibrary/SetTheory/Ordinal.lean` |

### 4.2 `settheory.computability.diagonal-flip-instance`

闭包深度 2；Mathlib 状态：`unverified_hint`。

| 深度 | Entry id | Lean 文件 |
|---|---|---|
| d0 | `settheory.computability.universal-machine-instance` | `SandronesLibrary/SetTheory/UniversalMachineInstance.lean` |
| d1 | `settheory.computability.binary-machine-coding` | `SandronesLibrary/SetTheory/BinaryMachineCoding.lean` |
| d1 | `settheory.computability.universal-interpreter-spec` | `SandronesLibrary/SetTheory/PartialComputability.lean` |
| d2 | `settheory.computability.partial-nat-computable` | `SandronesLibrary/SetTheory/PartialComputability.lean` |
| d2 | `settheory.googology.binary-machine` | `SandronesLibrary/SetTheory/GoogologyComputability.lean` |

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

- `settheory.googology.hydra-termination`：`traces/lean/settheory/settheory.googology.hydra-termination.jsonl`
- `settheory.computability.diagonal-flip-instance`：`traces/lean/settheory/settheory.computability.diagonal-flip-instance.jsonl`
- schema：`sandrones-lean-attempt/1`；join key 字段：`pack_id`
- 每条 attempt 记录必须带同一个 pack_id，否则该轨迹无法与上下文配对。

## 8. 冻结声明（目标文件里已冻结、不得改签名的声明）

**`settheory.googology.hydra-termination`**（`SandronesLibrary/SetTheory/GoogologyHydraTermination.lean`）：

本目标文件里没有冻结声明（新文件从零开始）。

**`settheory.computability.diagonal-flip-instance`**（`SandronesLibrary/SetTheory/ComputabilityDiagonalFlipInstance.lean`）：

本目标文件里没有冻结声明（新文件从零开始）。

> 签名先冻结再填证明（AGENTS §5 sorry 框架法）；改签名必须升级。

## 9. 窗口手写残量（`--note`，无法从权威源推导的判断）

> 本节是简令里**唯一**手写部分，与 pack 的推导字段分开标注，便于日后审计漂移。

本轮只解除研究权限，不自动解除正式源码门。Hydra 必须使用新自然和度量，不回退旧 hydraOrdinal；不得把 noncomputable 元层 runner 当程序内解释器或停机算法。

---

派工坐标与全部推导字段见 `docs/dispatch/f07-f07-settheory.md` 对应的 pack 文件；简令与 pack 不一致时**以 pack 为准**，并报告 Main 重新生成简令。
