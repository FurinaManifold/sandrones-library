# number-theory / N1plus 学科 handoff

> 窗口：E3 `number-theory / N1plus`（简令 `docs/dispatch/e3-nt-n1plus.md`，由 pack 渲染）
> worktree：`/home/pisquare/czt/sandrones-library-nt-n1plus`｜分支 `codex/number-theory-elementary-plus`
> 基线 `bc8d4feb59f639aa440d7719466297d918e9dd28`｜角色 `subject-maintainer`

## 1. 现场

| 项 | 值 |
|---|---|
| worktree | `/home/pisquare/czt/sandrones-library-nt-n1plus` |
| 分支 | `codex/number-theory-elementary-plus` |
| 基线 | `bc8d4feb59f639aa440d7719466297d918e9dd28` |
| HEAD | `4d29076`（交付提交；前一条 `1acd409` 是 pell-all-positive + pack/trace 的先行提交） |
| 提交数 | 2 |
| 改动 | 23 文件、+3920 行（`git diff --stat bc8d4fe..HEAD`） |
| 工作区 | `git status --short` 为空；`git diff --check` 无输出 |
| 磁盘 | worktree 31M；`/` 剩余 217G |
| 同步 Main | 未 push、未 rebase（基线即 Main 派工时的 `bc8d4fe`；本窗未改任何 Main 共享文件） |

## 2. 交付

四条 Entry 全部**真证交付，无降级、无 foundation 兜底**。

| Entry id | Lean 文件 | 行数 | 公开声明 | 公理画像 | 强度 |
|---|---|---|---|---|---|
| `number-theory.elementary.convergent-best` | `SandronesLibrary/NumberTheory/Elementary/ConvergentBest.lean` | 532 | 19 | propext, Classical.choice, Quot.sound | verified：收敛子 ⇒ 最佳有理逼近（`n ≥ 1`） |
| `number-theory.elementary.sqrt-periodic-cf` | `.../SqrtPeriodicCF.lean` | 653 | 23 | 同上（`IsEventuallyPeriodic.mul_period` 只需 propext） | verified：√d 数位最终周期 + 周期上界 `L ≤ 2d` + `d=a²+1` 周期 1 |
| `number-theory.elementary.pell-cf-bridge` | `.../PellCFBridge.lean` | 296 | 2（另 3 条 private） | 同上 | verified：方向 I 真证；方向 II 只到 Pell 形式上界（`≤`） |
| `number-theory.elementary.pell-all-positive` | `.../PellAllPositive.lean` | 202 | 16 | 同上（桥 `toMathlib_pow` 只需 propext, Quot.sound） | verified：**全称那一半**真证（每个非负坐标正解都是基本解的幂） |

叙述层：`docs/entries/number-theory/elementary/{convergent-best,sqrt-periodic-cf,pell-cf-bridge,pell-all-positive}.md`
（191 / 181 / 168 / 127 行，均为 front matter + 八节；`convergent-best.md` 另加「与 Legendre 判据的方向关系」专节）。

本窗 4 条目标对应 ROADMAP §11 N1+ 表第 1–4 行，**第 5 行 `negative-pell` 未做**（简令明文 out_of_scope），
未碰 N2/N3，未碰 `number-theory.elementary.negative-pell` 的任何文件。

### 概念清单（本批首次成为公开前提/结论的核心名词）

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 连分数完全商 `ξₙ` | `ξ₀=ξ`，`ξₙ₊₁=(fract ξₙ)⁻¹` | 本库 `cfCompleteQuotient` | `cfCompleteQuotient_zero/succ`、`cfCompleteQuotient_add` | Mathlib 无此层（`GenContFract.of_sqrt` 实测不存在） | `cfDigit`、主定理 | sqrt-periodic-cf |
| 数位（部分商）`aₙ` | `⌊ξₙ⌋` | 本库 `cfDigit` | `cfDigit_zero` | 自建 | 主定理、`d=a²+1` 特例 | sqrt-periodic-cf |
| 最终周期 | `∃N L>0, ∀n≥N, a(n+L)=a n` | 本库 `IsEventuallyPeriodic` | `mono`、`mul_period` | 自建 | 主定理、上界、判据 | sqrt-periodic-cf |
| continuant 整数对 `(pₙ,qₙ)` | 收敛子的未约分分子分母 | 本库 `continuantNumerator` / `continuantDenominator` | `nums_eq_*` / `dens_eq_*`、`continuant_determinant` | `GenContFract.nums/dens`（ℝ 值）是**私有证明后端**，公开接口给 ℤ 版 | `convergent_isBestRationalApproximation` | convergent-best |
| Brahmagupta 幂 | 基本解反复与自身复合，`a^0=(1,0)` | 本库 `PellSolution.pow` | `pow_zero` / `pow_succ` | 桥 `toMathlib_pow` 对应 `Pell.Solution₁` 的乘法幂 | `exists_pow_eq_of_fundamental` | pell-all-positive |
| 整数坐标 → 单位元 | 解 ↔ `ℤ√d` 中范数 1 的单位元 | 本库 `PellSolution.toMathlib` | `toMathlib_x/y`、`toMathlib_injective` | `Pell.Solution₁.mk`（**桥侧接口**，双向可搬运） | `toMathlib_comp`、分类定理 | pell-all-positive |

### 公开签名四类扫描（本批新增/修改的全部公开声明）

1. **语义一致的正式公开承载**：`PellSolution`、`IsFundamentalPellSolution`、`continuedFractionConvergent`、
   `IsBestRationalApproximation`、`rationalApproximationError`、`IsLegendreApproximation`（全部为前置 Entry，本批不改签名）。
2. **本库特殊定义的桥侧接口**：`PellSolution.toMathlib`（整数坐标 ↔ `ℤ√d` 单位元）、
   `continuantNumerator` / `continuantDenominator`（`GenContFract.nums/dens` 的 ℤ 版抽取）、
   `continuedFractionConvergent_succ_eq`（完全商与收敛子递推对齐）、`cfCompleteQuotient_add`（Gauss 迭代的加法公式）。
3. **私有证明后端**：`GenContFract.*` 全套（`contsAux_recurrence`、`sub_convs_eq`、`SimpContFract.determinant`、
   `abs_sub_convs_le` 等）、`Pell.IsFundamental.eq_pow_of_nonneg`、`Pell.Solution₁` 的 `CommGroup` 实例、
   `PellCFBridge.lean` 的 3 条 `private` 引理、`SqrtPeriodicCF.lean` 的 12 条 `private` 引理（`sqrtCFState_spec`/`_bounds`/鸽笼等）。
4. **超出课程层级的公开泄漏**：**无**。公开签名里没有出现高于初等数论层级的结构（`ℝ` 序、`ℚ`、`ℤ`、`ℕ → ℤ` 序列
   属课程载体；`Pell.Solution₁` 只出现在被显式声明为桥的 `PellSolution.toMathlib` 中）。

## 3. 验证

### 3.1 定向构建（负责人亲自跑，非采信子 Agent 报告）

```
$ lake build SandronesLibrary.NumberTheory.Elementary.ConvergentBest \
             SandronesLibrary.NumberTheory.Elementary.SqrtPeriodicCF \
             SandronesLibrary.NumberTheory.Elementary.PellCFBridge \
             SandronesLibrary.NumberTheory.Elementary.PellAllPositive
Build completed successfully (1914 jobs).
```
（各模块单独构建也均通过：ConvergentBest 1874 jobs、SqrtPeriodicCF 1874 jobs、PellCFBridge 1911 jobs、PellAllPositive 1885 jobs。）

### 3.2 聚合导入 + 定义链组装（`/tmp/opencode/n1plus_agg.lean`）

同时 import 本批 4 个模块，逐条 `#check` 四类归属：正式承载（`continuedFractionConvergent`、
`IsBestRationalApproximation`、`PellSolution`、`IsFundamentalPellSolution`、`cfCompleteQuotient`）、
展开/刻画（`continuedFractionConvergent_succ`、`PellSolution.pow_succ`、`cfCompleteQuotient_succ`、
`IsEventuallyPeriodic.mul_period`、`dens_lt_dens_succ`）、必要的桥（`continuant_determinant`、
`convergent_den_le_continuantDenominator`、`PellSolution.toMathlib_pow`、
`cfDigit_eventuallyPeriodic_of_completeQuotient_eq`、`cfCompleteQuotient_add`）、
上层使用者（本批 9 条主定理）。全部解析成功，无装饰别名、无重复结构。

### 3.3 公理画像（`#print axioms`，sorryAx 探针）

9 条主定理（`convergent_isBestRationalApproximation`、`cfDigit_sqrt_eventuallyPeriodic`、
`exists_cfDigit_sqrt_period_le`、`cfDigit_sqrt_sq_add_one`、`pellSolution_ratio_isConvergent`、
`convergent_pellForm_bounded`、`exists_pow_eq_of_fundamental`、`pos_iff_exists_pow`、
`exists_fundamental_pellSolution_pow_classification`）全部为
`[propext, Classical.choice, Quot.sound]`，**无 `sorryAx`**。
`Classical.choice` 按 Playbook §3.3 属 ℝ 序结构底线与 Mathlib 证明路径借道，已在各 Entry 叙述层注明。

### 3.4 语义抽查（非平凡性，不是只 `#check` 大定理）

- `PellSolution.pow` 真是 Brahmagupta 迭代：`decide` 验证 `(3,2)^2=(17,12)`、`(3,2)^3=(99,70)`（对应 `(3+2√2)ⁿ`）。
- `d = 2` 时把真解 `(3,2)` 经 `exists_fundamental_pellSolution_pow_classification` 收进某个基本解的幂序列。
- `d = 2` 时 `pellSolution_ratio_isConvergent` 给出 `3/2` 是 `√2` 的收敛子。
- `√2` 的第 1 个收敛子是 `IsBestRationalApproximation`（用 Mathlib `irrational_sqrt_two`）。

### 3.5 机械检查

- 禁用占位扫描：4 个 `.lean` + 4 个 `.md` 全部 `grep -nE "sorry|admit|sorryAx|native_decide"` **零命中**。
- 声明↔Entry 映射（`scripts.check_axioms.map_entry_to_decl`）：4 个文件各**恰好一个 Entry id**，无跨文件、无漏审：
  ConvergentBest 19 条、SqrtPeriodicCF 23 条、PellCFBridge 2 条（private 按设计跳过）、PellAllPositive 16 条。
- `git diff --check`：无输出。
- 冲突标记扫描：无。

## 4. pack 与 trace

### 4.1 pack（9 个，`python3 scripts/context_pack.py check traces/packs/*.json` → 「检查 9 个 pack：通过」）

| pack_id | 角色 | trace.path |
|---|---|---|
| `number-theory-N1plus-number-theory.elementary.convergent-best` | subject-maintainer（简令原 pack） | `traces/lean/number-theory/number-theory.elementary.convergent-best.jsonl` |
| `number-theory-N1plus-number-theory.elementary.sqrt-periodic-cf` | 同上 | `.../number-theory.elementary.sqrt-periodic-cf.jsonl` |
| `number-theory-N1plus-number-theory.elementary.pell-cf-bridge` | 同上 | `.../number-theory.elementary.pell-cf-bridge.jsonl` |
| `number-theory-N1plus-number-theory.elementary.pell-all-positive` | 同上 | `.../number-theory.elementary.pell-all-positive.jsonl` |
| `number-theory-N1plus-number-theory.elementary.convergent-best-cf-best` | sub-agent（`--worker cf-best`） | `.../number-theory.elementary.convergent-best-cf-best.jsonl` |
| `number-theory-N1plus-number-theory.elementary.sqrt-periodic-cf-sqrt-cf` | sub-agent（`--worker sqrt-cf`） | `.../number-theory.elementary.sqrt-periodic-cf-sqrt-cf.jsonl` |
| `number-theory-N1plus-number-theory.elementary.pell-cf-bridge-pell-bridge` | sub-agent（`--worker pell-bridge`） | `.../number-theory.elementary.pell-cf-bridge-pell-bridge.jsonl` |

（另有 2 个其它学科窗口的历史 pack 在同目录，不属本批。）

三个子 Agent 各有一个带 `--worker` 后缀的独立 pack，`pack_id` 与 `trace.path` 都带后缀，
不存在 join key 竞争；负责人视角的记录写在简令原 pack 的 trace 文件里（同一 Entry 两条线各有独立文件）。

### 4.2 trace（`python3 scripts/lean_trace.py check traces/lean/number-theory/` → 「检查 7 个文件、60 条记录：通过」）

```
traces/lean/number-theory: 7 个任务、60 条尝试
  accepted: 26
  error: 34
  - number-theory.elementary.convergent-best: 13 次尝试
  - number-theory.elementary.pell-all-positive: 6 次尝试
  - number-theory.elementary.pell-cf-bridge: 21 次尝试
  - number-theory.elementary.sqrt-periodic-cf: 20 次尝试
```

失败尝试一条未丢（error 占 57%）。含侦察轮（`#check` 探针）共 4 条，
其中「`GenContFract.of_sqrt` 与 `Pell.Solution.xp` 不存在」是 `error` 记录，
决定了 `sqrt-periodic-cf` 自建数位层、`pell-cf-bridge` 不引用 Mathlib 周期的边界判断。

## 5. subject_package 原文

```
（见下方粘贴；命令：python3 scripts/subject_package.py --worktree /home/pisquare/czt/sandrones-library-nt-n1plus --base bc8d4fe --subject number-theory）
```

## 6. 子 Agent 与负责人审核发现

### 6.1 切分与派工

| 子 Agent | pack（带 `--worker`） | 独占文件 | 结果 |
|---|---|---|---|
| `cf-best` | `...-convergent-best-cf-best` | `ConvergentBest.lean` + 其 md | 主定理真证（无降级），12 条 trace（accepted 4 / error 8） |
| `sqrt-cf` | `...-sqrt-periodic-cf-sqrt-cf` | `SqrtPeriodicCF.lean` + 其 md | 第二层主目标真证（未走兜底），19 条 trace（error 12 / accepted 7） |
| `pell-bridge` | `...-pell-cf-bridge-pell-bridge` | `PellCFBridge.lean` + 其 md | 方向 I 真证、方向 II 有界，20 条 trace（accepted 10 / error 10） |
| 负责人本人 | `...-pell-all-positive`（简令原 pack） | `PellAllPositive.lean` + 其 md | 全称分类真证，6 条 trace（accepted 4 / error 2） |

### 6.2 负责人**亲自**复验的内容（不采信报告）

1. 4 个模块逐个 `lake build` + 4 模块联合构建；
2. 聚合文件同时 import 4 模块并逐条 `#check` 定义链四类归属；
3. 9 条主定理 `#print axioms`（无 sorryAx）+ 5 处语义抽查（含 `decide` 钉住幂的数值语义）；
4. 逐条读数学陈述：`convergent_isBestRationalApproximation` 的 `1 ≤ n`、`convergent_pellForm_bounded` 的 `≤`、
   `exists_cfDigit_sqrt_period_le` 的 `L ≤ 2d`、`exists_pow_eq_of_fundamental` 的 `0 < b.x ∧ 0 ≤ b.y`；
5. 占位扫描、声明↔Entry 映射、`git diff --check`。

### 6.3 抓出并退回/修复的问题

| # | 问题 | 谁发现 | 处置 |
|---|---|---|---|
| 1 | 简令 §9 把 `convergent-best` 的方向写成「最佳逼近 ⇒ 是收敛项」；该命题对库内**第一类**定义**为假**（`√2` 的 `4/3`） | 负责人（开工侦察） | 已上报 Main，Main 裁定「简令错、按 ROADMAP 执行」并已修 notes/窗口定义；本批按 ROADMAP 交付 |
| 2 | pack 的 Mathlib 候选 `GenContFract.of_sqrt`、`Pell.Solution.xp` **实测不存在** | 负责人 | 已上报 Main（Main 复测 10 窗口 42 候选，13 条不存在，已加 `#check` 门禁）；本批据此调整边界 |
| 3 | `SqrtPeriodicCF.lean` 原 docstring 把 `L ≤ 2d` 说成「不超过判别式的两倍」，理由「判别式至少为 d」**对非平方因子 d 为假**（`d=18` 时 disc=8<d） | 负责人（读陈述） | 已退回子 Agent；子 Agent 改了定理 docstring 与 docs，**但漏了文件头第 16 行**，负责人补改（现为「**不是**判别式界」） |
| 4 | 负责人自己在派工提示里把 `¬ IsBestRationalApproximation (√2) (4/3)` 写成「加分项」——该命题为**假** | 子 Agent `cf-best`（拒绝执行并回报） | 未写成定理；文档改为「`IsBestRationalApproximation (√2) (4/3)` 为真、逆命题为假」并显式标注未形式化 |
| 5 | `pell-cf-bridge.md` 的 `premises` 多列了未被引用的 `pell-positive-existence` | 负责人（符号扫描） | 已删，现为 `[continued-fraction-convergent, legendre-criterion, pell-equation]` |
| 6 | 子 Agent 交付前 `hd : 1 < d` 把定理弄窄 | 负责人（读草稿） | 已退回改为 `0 < d` + `hns`（`hns` 现真正用于导出 `1 < d`） |

**采信子 Agent、未逐行复算的部分**（如实声明）：各文件内部引理的 tactic 细节、
`private` 引理的证明体、以及叙述层里两处**未形式化**的数值反例（`√2` 的 `4/3`、
`ξ=[0;100,1,1,…]` 的第 1 个收敛子 `1/100`）——这两处我独立做了数值复核（`4/3` 误差 `0.08088…` < `3/2` 的
`0.08579…`；`1/100` 误差 `6.14×10⁻⁵` > 阈值 `5×10⁻⁵`），与文档一致，但**均未写成 Lean 定理**。

## 7. 诚实边界

- **四条都是 `verified`，没有 foundation／bridge 降级**；但各自强度不同，已逐条登记：
  - `convergent-best`：`n ≥ 1` 不可去（`n=0` 为假，反例 `ξ=1.7`）；结论是第一类最佳逼近，
    核心引理其实是更强的第二类形式，文档已写明「强度不超出核心引理」。
  - `sqrt-periodic-cf`：**一般 d 的 √d 周期性真证**（不是特例冒充一般）；定量只到 `L ≤ 2d`，
    **`2d` 不是判别式界**；周期长度与判别式的精确关系（基本单位、类数、负 Pell 可解性）**未形式化**。
  - `pell-cf-bridge`：**方向 II 只是上界**（`≤ 2√d + 1`，非严格），**不是**「收敛子都是 Pell 解」，
    更**不是**「√d 收敛子产生 Pell 解」；「周期末端收敛子 = 基本解」**未做**（需周期层，且 Mathlib 无 `GenContFract.of_sqrt`）。
  - `pell-all-positive`：覆盖第二坐标**非负**的解；带符号的完整分类（`a = ±a₁^n`, `n : ℤ`）等价于
    Mathlib `eq_zpow_or_neg_zpow`，**未重述**，也未给 `PellSolution` 建群/整数幂。
- **负 Pell 单列**：本批 4 条**都不涉及** `x² - d y² = -1`，任何一条都不能被读成负 Pell 的结论；
  `number-theory.elementary.negative-pell` 本窗未做、未碰其文件。
- **未形式化的说明**：`√2` 的 `4/3` 反例与 `1/100` 反例只在文档里作数值说明，已显式标注「未形式化，不冒充已证结论」。
- **未做的其它事**：未改 `SandronesLibrary.lean`（顶层 import 待 Main 补）、未改 `index/registry.json`／
  `reference.bib`／ROADMAP（只给建议）、未 push、未删 worktree。

## 8. 协议反馈

1. **pack 的 `mathlib` 候选清单过窄且无机械校验**。本批 4 条实际用到约 60 个 Mathlib 名字，
   而 pack 只给 1–2 个；且给出的两个（`GenContFract.of_sqrt`、`Pell.Solution.xp`）**不存在**。
   建议：`context_pack.py` 增加 `--mathlib-extra`，或在开窗前对候选名做一次 `#check` 门禁
   （Main 已在修 `open_window.py`）。
2. **pack 缺 import 闭包信息**。`GenContFract.terminates_iff_rat` 名字存在但不在
   `Mathlib.NumberTheory.DiophantineApproximation.ContinuedFractions` 闭包内，子 Agent 白烧一轮侦察。
   建议 pack 增加字段「候选名是否在本 Entry 的 import 闭包内」。
3. **前置模块 olean 未预建**。worktree 里 `ContinuedFractions.olean` 一度不存在，`import SandronesLibrary...`
   直接报 "object file does not exist"。建议写进简令：开窗前先 `lake build <前置模块>`。
4. **trace schema 建议增可选字段 `insight`**（一句话语义级教训）。本批最贵的两个坑——
   「`rw [h]` 会把 `h` 自身在目标右侧出现的同名子项一并重写，把目标变成假命题」、
   「`set` 会把假设里的表达式一并折叠，随后的 `rw [← hs]` 报 `No goals to be solved`」——
   在 `attempt_code`/`compiler_feedback` 里只能间接体现，进不了 Playbook §5 的沉淀格式。
5. **同 worktree 多写者**：本窗负责人 + 3 个子 Agent 共用物理目录（AGENTS §3 说"禁止多个写者共享物理目录"），
   实测可用（各写各的文件、只在 `/tmp` 迭代、最后由负责人一次性 `lake build`），但 `.lake/build` 与 git index
   确实是单写者资源。建议协议明确：**子 Agent 只写自己的文件 + 只追加自己的 trace，不跑 `git`、不跑裸 `lake build`**；
   负责人串行提交。
6. **`private` 引理与审计器**：`check_axioms.py` 按设计跳过 `private` 声明，本批 15 条 private 引理因此不被 probe，
   公理经公开定理传递，行为符合预期；但 `map_entry_to_decl` 的"最近前置 marker"规则会让**未标 marker 的声明**
   继承更早 Entry——`Pell.lean` 里 `IsFundamentalPellSolution` 因此被算进 `pell-positive-existence`
   （其叙述层却在 `pell-fundamental-solution.md`）。Main 已确认由 Main 侧修 marker。

## 附：共享文件更新建议（只建议，不改）

- **`SandronesLibrary.lean`**：在本批 4 模块交付后按依赖顺序追加（当前根模块只到第 19 行 `Elementary.Pell`）：
  ```lean
  import SandronesLibrary.NumberTheory.Elementary.ConvergentBest
  import SandronesLibrary.NumberTheory.Elementary.SqrtPeriodicCF
  import SandronesLibrary.NumberTheory.Elementary.PellCFBridge
  import SandronesLibrary.NumberTheory.Elementary.PellAllPositive
  ```
- **`reference.bib`**：无需新增，4 条都用已存在的 `hardy-wright-number-theory-2008`（`reference.bib` L82）。
- **`docs/ROADMAP-LONGTERM.md` §11 N1+ 表**：第 1–4 行可由 🔲/🚧 更新为已完成，并保留各自的「剩余边界」文字
  （第 2 行的 `L ≤ 2d` 不是判别式界、第 3 行的周期末端未做、第 4 行的非负坐标边界）；
  第 5 行 `negative-pell` 保持未开始。
- **`Pell.lean` 的 marker 漂移**：给 `IsFundamentalPellSolution` 补 `> **Entry**: number-theory.elementary.pell-fundamental-solution`（Main 已认领）。

## 附：Registry 建议（Main 侧合并后跑 `check_axioms.py --all --fix` 生成 `axioms`／`proof_sha`／`dependedOnBy`）

### 1. `number-theory.elementary.convergent-best`

```json
{
  "id": "number-theory.elementary.convergent-best",
  "kind": "theorem",
  "state": "verified",
  "title": "连分数收敛子的最佳逼近性",
  "summary": "无理数的每个 n ≥ 1 阶收敛子在其分母预算内误差最小",
  "premises": [
    "number-theory.elementary.continued-fraction-convergent",
    "number-theory.elementary.best-rational-approximation"
  ],
  "mathlib": [
    "GenContFract.of", "GenContFract.contsAux", "GenContFract.nums", "GenContFract.dens",
    "GenContFract.convs", "GenContFract.contsAux_recurrence",
    "GenContFract.of_partNum_eq_one_and_exists_int_partDen_eq",
    "GenContFract.succ_nth_fib_le_of_nth_den", "GenContFract.sub_convs_eq",
    "GenContFract.conv_eq_num_div_den", "GenContFract.of_correctness_of_terminates",
    "SimpContFract.determinant", "Real.convs_eq_convergent", "Rat.den_dvd"
  ],
  "provenance": { "source_type": "book", "ref": "hardy-wright-number-theory-2008" },
  "lean_file": "NumberTheory/Elementary/ConvergentBest.lean",
  "nl_file": "docs/entries/number-theory/elementary/convergent-best.md",
  "added_by": "codex-nt-n1plus",
  "added_at": "2026-10-14T00:00:00Z"
}
```

### 2. `number-theory.elementary.sqrt-periodic-cf`

```json
{
  "id": "number-theory.elementary.sqrt-periodic-cf",
  "kind": "theorem",
  "state": "verified",
  "title": "√d 连分数展开的最终周期性",
  "summary": "√d 的数位序列最终周期，且存在周期 L ≤ 2d（显式上界）",
  "premises": [
    "number-theory.elementary.continued-fraction-convergent",
    "number-theory.elementary.continued-fraction-recursion"
  ],
  "mathlib": [
    "Int.fract", "Int.floor", "Int.self_sub_floor", "Int.floor_eq_iff", "Int.le_floor",
    "Int.mul_ediv_cancel'", "Int.card_Icc", "irrational_sqrt_intCast_iff", "Irrational.ne_rat",
    "Real.lt_sqrt", "Real.sqrt_lt'", "Real.sq_sqrt",
    "Finset.exists_ne_map_eq_of_card_lt_of_maps_to", "Function.iterate_add_apply", "one_lt_inv₀"
  ],
  "provenance": { "source_type": "book", "ref": "hardy-wright-number-theory-2008" },
  "lean_file": "NumberTheory/Elementary/SqrtPeriodicCF.lean",
  "nl_file": "docs/entries/number-theory/elementary/sqrt-periodic-cf.md",
  "added_by": "codex-nt-n1plus",
  "added_at": "2026-10-14T00:00:00Z"
}
```

### 3. `number-theory.elementary.pell-cf-bridge`

```json
{
  "id": "number-theory.elementary.pell-cf-bridge",
  "kind": "theorem",
  "state": "verified",
  "title": "连分数与 Pell 解的桥",
  "summary": "正 Pell 解的比值必是 √d 的收敛子；反方向只给出收敛子的 Pell 形式上界",
  "premises": [
    "number-theory.elementary.continued-fraction-convergent",
    "number-theory.elementary.legendre-criterion",
    "number-theory.elementary.pell-equation"
  ],
  "mathlib": [
    "GenContFract.abs_sub_convs_le", "GenContFract.conv_eq_num_div_den",
    "GenContFract.of_correctness_of_terminatedAt", "GenContFract.of_den_mono",
    "GenContFract.succ_nth_fib_le_of_nth_den", "GenContFract.terminated_stable",
    "GenContFract.contsAux_recurrence", "GenContFract.of_h_eq_floor",
    "GenContFract.of_partNum_eq_one", "GenContFract.partNum_eq_s_a",
    "GenContFract.num_eq_conts_a", "GenContFract.den_eq_conts_b",
    "GenContFract.nth_cont_eq_succ_nth_contAux",
    "GenContFract.IntFractPair.exists_succ_get?_stream_of_gcf_of_get?_eq_some",
    "Real.convergent", "Real.convs_eq_convergent", "Real.sq_sqrt", "Real.sqrt_lt_sqrt",
    "Rat.den_div_eq_of_coprime", "Rat.den_dvd", "Rat.num_div_den", "Rat.cast_injective",
    "Rat.intCast_div_eq_divInt", "Int.isCoprime_iff_gcd_eq_one", "Int.gcd_def", "Int.le_of_dvd",
    "sq_lt_sq", "abs_add_le", "abs_sub_comm", "one_div_le_one_div_of_le", "div_lt_div_of_pos_left"
  ],
  "provenance": { "source_type": "book", "ref": "hardy-wright-number-theory-2008" },
  "lean_file": "NumberTheory/Elementary/PellCFBridge.lean",
  "nl_file": "docs/entries/number-theory/elementary/pell-cf-bridge.md",
  "added_by": "codex-nt-n1plus",
  "added_at": "2026-10-14T00:00:00Z"
}
```

### 4. `number-theory.elementary.pell-all-positive`

```json
{
  "id": "number-theory.elementary.pell-all-positive",
  "kind": "theorem",
  "state": "verified",
  "title": "正 Pell 方程全体正解的分类",
  "summary": "每个坐标非负的正解都是基本解的 Brahmagupta 幂，反之基本解的幂都是正解",
  "premises": [
    "number-theory.elementary.pell-equation",
    "number-theory.elementary.pell-composition",
    "number-theory.elementary.pell-positive-existence",
    "number-theory.elementary.pell-fundamental-solution"
  ],
  "mathlib": [
    "Pell.Solution₁", "Pell.Solution₁.mk", "Pell.Solution₁.ext", "Pell.Solution₁.x_mul",
    "Pell.Solution₁.y_mul", "Pell.Solution₁.x_pow_pos", "Pell.Solution₁.y_pow_succ_pos",
    "Pell.IsFundamental", "Pell.IsFundamental.eq_pow_of_nonneg", "Pell.IsFundamental.subsingleton"
  ],
  "provenance": { "source_type": "book", "ref": "hardy-wright-number-theory-2008" },
  "lean_file": "NumberTheory/Elementary/PellAllPositive.lean",
  "nl_file": "docs/entries/number-theory/elementary/pell-all-positive.md",
  "added_by": "codex-nt-n1plus",
  "added_at": "2026-10-14T00:00:00Z"
}
```

四条 `axioms` 均由负责人 `#print axioms` 实测为 `["Classical.choice", "Quot.sound", "propext"]`
（生成器会重算，以其为准）。
