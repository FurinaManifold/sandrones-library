# settheory / ST3deep —— 窗口 handoff

> 批次：`ST3deep`（E7 窗口）｜学科：`settheory`｜角色：`subject-maintainer`
> worktree：`/home/pisquare/czt/sandrones-library-st3-deep`｜分支：`codex/settheory-st3-deep`
> 基线：`bc8d4feb59f639aa440d7719466297d918e9dd28`｜交付提交：`529e0e3`（+ 本 handoff 提交）

## 1. 现场

- `git branch --show-current` → `codex/settheory-st3-deep`
- `git log --oneline -2` → `529e0e3 feat(settheory): ST3 纵深两条…`、`bc8d4fe feat(dispatch): 派工文档改为脚本渲染…`
- 提交数：2（交付提交 + 本 handoff/叙述层修订提交）；工作区交付后清洁（除 Main 共享文件外只新增本窗文件）。
- 未同步 Main：本窗按简令在 `bc8d4fe` 基线上作业，未 push、未 rebase（简令禁止 push；同步门留给 Main 集成时处理）。

## 2. 交付

| Entry id | Lean 文件（新增） | 行数 | 叙述层（新增） | 公开声明 |
|---|---|---|---|---|
| `settheory.googology.hereditary-encoding-order` | `SandronesLibrary/SetTheory/HereditaryEncodingOrderGeneral.lean` | 97 | `docs/entries/settheory/googology/hereditary-encoding-order.md` | `hereditaryNatEncode_baseChange_omegaValue`、`canonicalBaseChangeReencoding_preserves` |
| `settheory.googology.hydra-general-descent` | `SandronesLibrary/SetTheory/HydraGeneralDescent.lean` | 630 | `docs/entries/settheory/googology/hydra-general-descent.md` | `ordNadd`、`ordNadd_zero_right/left`、`ordNadd_comm`、`ordNadd_assoc`、`ordNadd_one`、`ordNadd_lt_ordNadd_right/left`、`hydraGeneralOrdinal`、`forestGeneralOrdinal`、`hydraGeneralOrdinal_node`、`forestGeneralOrdinal_cons/nil/append/replicate`、`hydraGeneralOrdinal_head`、`forestGeneralOrdinal_lt_of_child_lt`、`forestGeneralOrdinal_replicate_lt`、`forestGeneralOrdinal_remove_head`、`hydraStep_generalOrdinal_lt`、`hydraOrdinal_not_general_descent` |

未改动任何既有文件；未触碰 `scope.out_of_scope` 的 8 条 🔒 条目；未改已集成的 Goodstein／Hydra 状态文件。

**公理画像**（`#print axioms` 逐条实测）：两条主定理与 Hydra 反例均为
`[propext, Classical.choice, Quot.sound]`，与同族既有 Entry 一致；无 `sorryAx`。
占位扫描（`sorry`/`admit`/`sorryAx`/`native_decide`）在两个新文件中均无命中。

## 3. 验证（负责人亲自复跑）

- `lake env lean SandronesLibrary/SetTheory/HereditaryEncodingOrderGeneral.lean` → exit 0，无输出。
- `lake env lean SandronesLibrary/SetTheory/HydraGeneralDescent.lean` → exit 0，无输出。
- `lake build SandronesLibrary.SetTheory.HereditaryEncodingOrderGeneral`（子 Agent 交付后由负责人并入定向构建链）
  与 `lake build SandronesLibrary.SetTheory.HydraGeneralDescent` → `Build completed successfully`（1037–1041 jobs），
  无新增 linter warning（`linter.style.show` 一处已按提示改用 `change`；未使用 simp 参数已清理）。
- 关键 `#check`：
  - `hereditaryNatEncode_baseChange_omegaValue : {b c : ℕ} → 2 ≤ b → b ≤ c → (n : ℕ) → (encode c ((encode b n).eval c)).omegaValue = (encode b n).omegaValue`
  - `hydraStep_generalOrdinal_lt : {stage : ℕ} → {before after : Hydra} → Hydra.Step stage before after → hydraGeneralOrdinal after < hydraGeneralOrdinal before`
  - `hydraOrdinal_not_general_descent : ∃ before after, Hydra.Step 1 before after ∧ hydraOrdinal before < hydraOrdinal after`
- Entry ↔ 声明映射：两条叙述层的「陈述（Lean 对照）」逐字给出上表主声明；源码 docstring 的
  `> **Entry**:` 标记与 id 一一对应。
- `git diff --cached --check` → 无输出（无空白错误）。

## 4. pack 与 trace

| pack_id | pack 文件 | trace 路径 | 记录数（accepted / error） |
|---|---|---|---|
| `settheory-ST3deep-settheory.googology.hereditary-encoding-order` | `traces/packs/settheory-ST3deep-settheory.googology.hereditary-encoding-order.json` | `traces/lean/settheory/settheory.googology.hereditary-encoding-order.jsonl` | 1 / 0（负责人批级验收记录） |
| `settheory-ST3deep-settheory.googology.hereditary-encoding-order-enc` | `traces/packs/…-hereditary-encoding-order-enc.json` | `traces/lean/settheory/settheory.googology.hereditary-encoding-order-enc.jsonl` | 6 / 1（子 Agent 逐轮 + 负责人独立复验） |
| `settheory-ST3deep-settheory.googology.hydra-general-descent` | `traces/packs/settheory-ST3deep-settheory.googology.hydra-general-descent.json` | `traces/lean/settheory/settheory.googology.hydra-general-descent.jsonl` | 9 / 7 |

`python3 scripts/lean_trace.py check traces/lean/settheory/` → `检查 3 个文件、24 条记录：通过`；
`summary --subject settheory` → `2 个任务、24 条尝试；accepted 16 / error 8`。

**派子 Agent 的说明**：本窗只有 encoding 一条派给了子 Agent，因此为该 Entry 另建了带 `--worker enc`
的 pack（join key 唯一，避免与维护者 pack 共用 `trace.path` 而漏记录）；hydra 一条由负责人亲自完成，
未派子 Agent，故没有额外的 worker pack。

## 5. subject_package 五门原文

```
学科验收包 settheory  (codex/settheory-st3-deep @ 2f4f93d4f)
  基线 bc8d4fe｜提交 2｜改动文件 11
  ✅ cleanliness
  ✅ ownership
  ✅ semantics
  ✅ proof
  ✅ coverage
  ✅ traces（软门）：本批含 51 条验证尝试记录
  ✅ packs（软门）：pack 与 trace 的 pack_id 已配对，trace.path 指针正确

  verdict: pass
```

（`traces`／`packs` 两行原文：`✅ traces（软门）：本批含 51 条验证尝试记录`、
`✅ packs（软门）：pack 与 trace 的 pack_id 已配对，trace.path 指针正确`。
51 = 本窗 settheory 24 条 + 仓库内其他窗口既有轨迹；软门按仓库口径统计。）

## 6. 子 Agent 与负责人审核发现

- 子 Agent（`enc`）交付 encoding 条目，报告「无弱化、无占位、`lake env lean` clean」。
  负责人**独立复跑**了编译、逐条读了公开陈述与叙述层，并核对 `#print axioms`：全部与报告一致，未退回。
  独立复核中发现并记录的事实：子 Agent 的 `#print axioms` 探针在 `lake env lean` 下无法 import 新模块
  （无 olean），它改为「复制文件 + 追加探针」完成核查；负责人随后用 `lake build` 产出 olean 后重跑了
  正式探针（见 §3）。
- 负责人亲自完成 hydra 条目，并抓到两处**必须记录的失败轨迹**：
  1. 旧度量 `hydraOrdinal` 在一般位置砍头时**上升**（反例树已固化成定理 `hydraOrdinal_not_general_descent`）；
     这说明简令要求「消除最右脊柱限制」不能靠给旧度量加假设，必须换度量。
  2. 新度量的关键是自然和（Hessenberg 和）；mathlib 4.33 没有 `nadd`，故库内用
     `Ordinal.CNF.coeff`/`eval` 自建并证明其代数律。试错过程中还确认了三条工具链事实：
     `rw` 每次只改写第一个匹配（与 `simp only` 不同）、`Finsupp.filter_add_filter_not` 需要可交换系数
     （对 `Ordinal` 值不可用）、`chop` 的 `do` 记号编译成 `Bind.bind` + 自动匹配子，必须显式展开
     并用 `Option.bind_eq_some_iff` 拆存在量词。
- pack 与任务的路径口径差异（供 Main 修生成器）：pack 的 `ownership.writable` 写
  `SandronesLibrary/Settheory/**`（小写 t），实际路径是 `SandronesLibrary/SetTheory/**`；
  子 Agent 按任务明令的精确路径写入，未越界。

## 7. 诚实边界

- `hereditary-encoding-order`：只证**换底重编码保持 `omegaValue`**（对 `2 ≤ b ≤ c` 全称，
  不是把 `B^(B^k)` 特例改名）。**未**证明无条件 Goodstein 单步下降
  （`canonicalGoodsteinStep_omega_lt`）、序列终止、PA 不可证性；这些分别属于
  `goodstein-ordinal-descent` / `goodstein-termination` / `goodstein-pa-independence`（本批 out_of_scope）。
- `hydra-general-descent`：只证**单步严格下降**（对任意深度、任意头位置、任意阶段复制），
  **未**证明游戏终止或强度边界（`hydra-termination` 仍 🔒）。新度量 `hydraGeneralOrdinal` 与旧度量
  `hydraOrdinal` 并存：旧文件一行未改，新能力只在新文件里。
- 新公开概念 `ordNadd`（自然和）是**库内自建**：mathlib 无 `nadd`，本库用 CNF 系数加法定义，
  文档已说明 `Ordinal.CNF` 只是定义机制、公开接口是本库的 `ordNadd`。
- 未做全库 `lake build`（学科负责人不做），只做定向模块构建。

## 8. 共享更新建议（Registry / ROADMAP，由 Main 执行）

两条 Entry 的 Registry 记录建议（`premises` 只列库内 Entry；`mathlib` 只列实测通过的载体）：

```json
{"id": "settheory.googology.hereditary-encoding-order", "kind": "theorem", "state": "verified",
 "title": "一般换底重编码保持 omegaValue",
 "premises": ["settheory.googology.canonical-goodstein-state",
              "settheory.googology.hereditary-natural-encoding",
              "settheory.googology.hereditary-natural-encoding-same-block-order"],
 "mathlib": ["Nat.mul_add_div", "Nat.mul_add_mod", "Nat.div_eq_of_lt", "Nat.mod_eq_of_lt"],
 "provenance": {"source_type": "book", "ref": "pohlers-proof-theory-1989"},
 "lean_file": "SetTheory/HereditaryEncodingOrderGeneral.lean",
 "nl_file": "docs/entries/settheory/googology/hereditary-encoding-order.md"}

{"id": "settheory.googology.hydra-general-descent", "kind": "theorem", "state": "verified",
 "title": "一般 Hydra 单步的序数下降",
 "premises": ["settheory.googology.hydra-ordinal-assignment",
              "settheory.ordinal.power-bridge"],
 "mathlib": ["Ordinal.CNF.eval", "Ordinal.CNF.coeff", "Ordinal.CNF.coeff_eval",
             "Ordinal.CNF.eval_lt", "Ordinal.opow_mul_lt_opow", "Ordinal.lt_omega0"],
 "provenance": {"source_type": "book", "ref": "kirby-paris-independence-1982"},
 "lean_file": "SetTheory/HydraGeneralDescent.lean",
 "nl_file": "docs/entries/settheory/googology/hydra-general-descent.md"}
```

- ROADMAP §12 表第 3、7 行可从 🚧 改为 ✅（两条纵深已完成），并解锁第 4、8 条的下一批；
  本窗**未**自行改 ROADMAP（Main 共享文件）。
- 叙述层 front matter 采用**块式** `provenance:`（`scripts/subject_package.py` 的
  `front_matter()` 只识别行首 `ref:`）；同族既有条目用的是行内式
  `provenance: {source_type: …, ref: …}`。front matter 统一是 Main 职责，这里只报告差异。
- `reference.bib` 未改：两条都复用已存在的 `pohlers-proof-theory-1989`（Goodstein 侧）
  与 `kirby-paris-independence-1982`（Hydra 侧）。
