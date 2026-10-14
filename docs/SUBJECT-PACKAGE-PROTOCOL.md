# 分层审核与学科验收包协议（Main 减负工程）

> 设计来源：`docs/reports/project-introduction/project-introduction.md` §7「数百 Agent：分层审核，
> 把 Main 变成发布与治理层」与 §8「集成怎样不压垮 Main：五项具体工程安排」。
> 本文件是那两节的**可执行落地**：把「学科验收包」与「候选批次发布门」写成命令、产物和职责边界。
> 事实源不变：数学以源码+编译器为准，进度以 `ROADMAP-LONGTERM.md` 为准，Entry 身份以
> `index/registry.json` 为准。

## 0. 目标与不变量

目标：Main 不再逐份重读聊天、猜谁审过、手工补条目；**常规、稳定接口内的批次由学科验收，
Main 只审异常、跨学科接口与最终发布**。这不是放权数学，而是把"谁有能力判断什么"写清楚。

不变量（任何层级都不得放宽）：

1. 一个 Entry id 只对应一个 Lean 文件；源码标记、叙述层 id、Registry id 一致。
2. 学科交付不得触碰 Main 共享文件（AGENTS §3）。
3. `axioms`／`proof_sha`／`dependedOnBy` 只由生成器产出，禁止手工填。
4. 数学判断（语义对应、证明真实性、覆盖范围）永远由人负责；脚本只做**契约/签名/所有权/证据**
   的机械核对，脚本通过 ≠ 数学通过。

## 1. 三层职责

| 层 | 谁 | 交付物 | 机器可查 | 人必须判断 |
|---|---|---|---|---|
| 小组 | 学科负责人 + 2–3 个 worker | 已提交的学科批次（证明+文档+依赖+公理+复验记录） | 部分 | 语义回译、证明路线 |
| 学科集成 | 学科维护人 | **学科验收包**（`scripts/subject_package.py` JSON）+ handoff | 契约/所有权/证据 | 联合导入、实例影响、教材边界、跨小组冲突 |
| 发布 | Main（唯一写者） | 候选批次发布回执（`scripts/release_gate.py` JSON）+ 集成提交 | 全流水线 | 跨学科 API、额外公理、例外、最终发布 |

`docs/SUBJECT-PACKAGE-PROTOCOL.md`（本文件）是这一分工的权威说明；出现分歧时以本文件 +
对应 `docs/roles/*-ROLE.md` 为准。

## 2. 三道门与自动化边界（introduction §5）

- **A 有没有表达原文**：脚本能查「id 唯一、叙述层存在、`provenance.ref` 是合规 key、源码标记
  与文档 id 一一对应、标记不跨文件」；**不能**查"Lean 陈述是否忠实原文"。非作者语义回译仍由人做。
- **B 有没有真正证明**：脚本能查「无 `sorry/admit/sorryAx/native_decide`、每个 id 至少映射到
  一个公开声明、公理集已由 `check_axioms.py` 生成」；**不能**查"是否把待证结论藏进前提/定义字段"。
- **C 有没有完成承诺范围**：脚本能列「每个 id 的真实声明数、改动文件、handoff 是否存在」；
  **不能**判断"覆盖比例是否诚实"。

## 3. 学科验收包（`scripts/subject_package.py`）

学科维护人在交付前（或 Main 在接收前）运行：

```bash
python3 scripts/subject_package.py \
    --worktree /home/pisquare/czt/sandrones-library-<subject> \
    --base <学科分支基线 commit> \
    --subject <学科名> \
    --out docs/subject-packages/<subject>-<batch>.json
```

产出 JSON（schema `sandrones-subject-package/1`）含五组门与一份**异常清单**：

1. `cleanliness`：worktree 清洁、`git diff --check` 干净；
2. `ownership`：未触碰 Main 共享文件；
3. `semantics`：id 唯一、节点完整、`provenance.ref` 合规、标记不跨文件；
4. `proof`：无禁用占位、每个 id 至少一个公开声明；
5. `coverage`：逐 Entry 声明数 + `docs/handoffs/*.md` 存在。

包内另有一块 **`traces`（Lean 验证轨迹语料，Playbook §8）**，当前为**软门**：

- `present`：`traces/lean/` 下有合法 JSON Lines 记录，附记录条数；
- `missing`：本批改动了 `SandronesLibrary/**/*.lean` 却没有任何 trace 记录——给提示，
  **不单独否决策包**，但 Main 会据此追问；确无验证试错过程的批次须在 handoff 显式写明；
- `invalid`：记录不是合法 JSON Lines（每行须可独立 `json.loads`）；
- `n/a`：本批未改动 Lean 源码，不要求 trace。

轨迹的写入者、字段与三条铁律见 `docs/LEAN-PLAYBOOK.md` §8；写入与校验工具为
`scripts/lean_trace.py append|check|summary`。积累一轮真实语料后，由 Main 复核质量并决定
是否把软门转为硬门。

包内还有一块 **`packs`（派工上下文包，Playbook §9）**，同为**软门**：

- `pack_ids`：本批提交到 `traces/packs/` 的 pack 清单；
- `duplicate_pack_ids`：同一个 `pack_id` 出现在多个 pack 文件里。`pack_id` 是
  `(pack, trace)` 的 join key，重复即不唯一——同一 Entry 派多个 worker 时必须用
  `context_pack.py build --worker <短标签>` 让两者都带上后缀（Playbook §9.4）；
- `referenced_by_traces`：trace 记录里实际引用的 `pack_id`；
- `missing_for_referenced`：被引用却没有对应 pack 文件的 `pack_id`——这会打断
  `(观测, 动作, 反馈)` 样本的配对，Main 必须追问；
- `trace_path_mismatch`：pack 的 `trace.path` 指针与实际记录不符（文件不存在，或该文件里
  没有一条带本 pack `pack_id` 的记录）。消费方是顺着 `trace.path` 找记录的，指针错就会
  **静默漏样本**——CA1 试点里 verify pack 的指针指向 lead 的 jsonl，会漏掉 14 条；
- `invalid`：pack 不是合法 JSON、缺 `pack_id`、schema 不对或 `task.goal_nl` 为空。

pack 由负责人用 `scripts/context_pack.py build` 生成（`task.goal_nl` 是唯一手写字段），
是子 Agent 的开工输入；其每条 trace 记录必须带同一个 `pack_id`。`context_pack.py check`
还会**真校验 `pack_sha256`**（口径：除 `generated_at` 外并自排除 `pack_sha256` 本身）。

`verdict` 为 `pass` 时，Main 只需抽检异常清单之外的内容；`needs_changes` 时**只处理列出的异常**。
退出码：`0`=pass，`1`=needs_changes。

## 4. 候选批次发布门（`scripts/release_gate.py`）

Main 把已验收的学科提交 cherry-pick 到 main 后运行：

```bash
python3 scripts/release_gate.py --package docs/subject-packages/<subject>-<batch>.json
# 快速模式（省略全库 build，用于迭代）：加 --skip-build
```

行为（对应 §8 第 3 项「按候选批次合并，而非相信旧构建」）：

1. 核对候选（main 工作树）清洁，且每个包的提交确已在 main（`git cherry` patch-id）；
2. 在**候选整体**上按 AGENTS §6 顺序重跑：`extract_registry_references` → `update_dependency_graph`
   → `gen_entries_index` → `gen_entry_rankings` → `check_axioms --all --fix` → `check_axioms --all`
   → `audit` → `git diff --check` → `lake build`；
3. 逐步记录 rc/耗时/输出尾部，写回执 `docs/releases/release-receipt-<ts>.json`；
4. 任一步失败即 `fail`，并按步骤名**拆分定位**受影响批次。

**目标分支一旦前进（基线变化），必须重新排队重跑**，不得沿用旧回执。回执是"这一次候选"的证据，
不是长期通行证。

## 5. 控制在制品（§8 第 4 项）

- 每个学科窗口同时最多 **1 个待发布批次**；语义审核积压时**停止派发新证明**，优先复验与返工。
- 观察指标：首次通过率、返工率、等待时间、专家审核时间、构建成本、论文覆盖，而非只看产出量。
- 系统速度受最慢环节（数学审阅者）限制，worker 数量不是瓶颈。

## 6. 可恢复台账（§8 第 5 项）

- 学科窗口的状态由**已提交成果 + handoff**承载，不依赖聊天窗口常驻；接班者按 handoff 继续。
- Main 侧台账 = `docs/subject-packages/*.json`（学科包）+ `docs/releases/*.json`（发布回执）；
  两者都是可机器读的结构化记录，替代聊天摘要。
- worker 失联时先阻止旧进程继续写（单写者资源：git index 与 `.lake/build`），再依据包/回执重新派工。

## 7. 与既有规程的关系

- 本协议**不替代** `AGENTS.md` §6（派生数据重建顺序）、§7（学科交付门）、§8（Main 验收顺序）。
  它把 §7/§8 的机械部分自动化，并把"Main 审什么"收敛为：**异常清单 + 跨学科接口 + 最终发布**。
- 回执与包是 Main 侧工具产物，属 Main 共享文件范畴；学科只**提供**包所需的事实（提交、handoff），
  不直接写 `docs/subject-packages/` 或 `docs/releases/`。
