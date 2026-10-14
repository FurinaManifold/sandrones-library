# RA-F3F5 覆盖引理／极大函数／单调函数／有界变差／绝对连续 正式交接

- entries（5 条，1 Entry ↔ 1 Lean 文件）：
  - `real-analysis.covering-lemma`（RA-F3 冻结前置，负责人亲自交付）
  - `real-analysis.maximal-function`（RA-F3，子 Agent `f3max`）
  - `real-analysis.monotone-function`（RA-F5，子 Agent `f5mono`）
  - `real-analysis.bounded-variation`（RA-F5，子 Agent `f5bvac`）
  - `real-analysis.absolute-continuity-function`（RA-F5，子 Agent `f5bvac`）
- branch：`codex/real-analysis-maximal-bv`
- worktree：`/home/pisquare/czt/sandrones-library-ra-maximal-bv`
- 基线：`bc8d4feb59f639aa440d7719466297d918e9dd28`（建 worktree 时 Main 尖端；本批未 rebase，开工时现场 `git log` 核对）
- gate：`development_open`（ROADMAP §6 RA-F3／RA-F5 行标 🚧）
- formal sources（5 个新文件，**未改任何既有 `.lean`**）：
  - `SandronesLibrary/RealAnalysis/CoveringLemma.lean`（243 行，17 公开声明）
  - `SandronesLibrary/RealAnalysis/MaximalFunction.lean`（437 行，17 公开声明 + 3 private）
  - `SandronesLibrary/RealAnalysis/MonotoneFunction.lean`（336 行，23 公开声明）
  - `SandronesLibrary/RealAnalysis/BoundedVariation.lean`（317 行，26 公开声明）
  - `SandronesLibrary/RealAnalysis/AbsoluteContinuityFunction.lean`（303 行，22 公开声明）
  - 合计 **105 条公开声明**，全部带 `> **Entry**: <id>` 标记，逐文件映射见 §5
- documents：`docs/entries/real-analysis/{covering-lemma,maximal-function,monotone-function,bounded-variation,absolute-continuity-function}.md` + 本 handoff
- 未改任何 Main 共享文件（仅在本 handoff 给建议）；`git status` 只有未跟踪新文件，无 `M`/`A`/`D`

## 0. 本窗不做（越界即升级）

RA-F4（Lebesgue 点与 Lebesgue 微分定理）、RA-F6（FTC 的 a.e. 版本与 Newton–Leibniz 表示）
**依赖本窗成果**，本窗明确不做；不做 ℝⁿ 版本；不声称复刻 Folland 的 `3ⁿ` 常数。

## 1. 依赖门与批次边界

- RA-F3 开工门（ROADMAP §6）：RA-F2 已完成 ✅ + **覆盖引理接口冻结**。本窗按简令 §9「窗口判断」
  先由负责人交付并冻结 `real-analysis.covering-lemma` 的签名（`CoveringLemma.lean` 单独编译通过
  并 commit `b8a294d`），再派上层 `real-analysis.maximal-function`。
- RA-F5 开工门：RA-F2 已完成 ✅ + 一维测度接口验收（`real-analysis.measure.*`、
  `real-analysis.calculus.ftc`、`real-analysis.signed-measure.*` 已在 Registry）。
- 本批 pack `scope.out_of_scope` 为空（ROADMAP 无同族兄弟条目被排除）；实际边界是 ROADMAP §6
  批次表的 RA-F4／RA-F6。

## 2. 概念冻结表

| 概念 | 教材语义（Folland 2nd ed.） | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|---|
| 开区间（量词域） | 「含某点的开区间」的量化域 | 本库 `Covering.OpenInterval`（`l u lt`） | `toSet` / `center` / `radius` / `ball_center_radius` | Mathlib 无对应结构；桥到 `ball` | `exists_disjoint_interval_subfamily_covering_enlargement` | covering-lemma |
| 覆盖引理（τ-放大） | 半径有界的区间族可抽出不交子族，原族被 τ-放大覆盖 | 本库 `exists_disjoint_interval_subfamily_covering_enlargement` | 见 §5 冻结签名 | 后端 `Vitali.exists_disjoint_subfamily_covering_enlargement_ball`（私有） | `maximalFunction_weak_type` | covering-lemma |
| 坏集测度控制 | 原并集测度 ≤ τ·不交子族总测度 | 本库 `volume_iUnion_le_mul_tsum` | 见 §5 | `measure_iUnion_le`、`Set.PairwiseDisjoint.countable_of_nonempty_interior`（私有） | `maximalFunction_weak_type` | covering-lemma |
| Hardy–Littlewood 极大函数 | `Hf(x) = sup_{I ∋ x} (1/\|I\|)∫_I \|f\|` | 本库 `MaximalFunction.maximalFunction : (ℝ→ℝ) → ℝ → ℝ≥0∞` | 定义体即 `⨆` over `OpenInterval` | Mathlib **没有**极大函数算子（Main 已实测确认），自建 | `maximalFunction_weak_type` | maximal-function |
| 极大函数可测性边界 | `Hf` 下半连续 ⟹ Borel 可测 | `isOpen_lt_maximalFunction` / `lowerSemicontinuous_maximalFunction` / `measurable_maximalFunction` | `{c < Mf} = ⋃_{c<avg I} I.toSet` | 私有后端 `isOpen_iUnion`、`measurable_of_Ioi` | 同 Entry | maximal-function |
| 弱型 `(1,1)` 估计 | `m({Hf > α}) ≤ C‖f‖₁/α` | `maximalFunction_weak_type`（常数 4，一维） | 见 §5 | 消费本库覆盖引理（非 Mathlib 最终定理） | `maximalFunction_weak_type_sub` | maximal-function |
| 单调函数 | `x ≤ y ⟹ f x ≤ f y` | Mathlib `Monotone` / `MonotoneOn` | `monotone_iff_forall_le`（`Iff.rfl`） | 语义一致，直接复用 | `countable_jumpPoints` 等 | monotone-function |
| 跳跃结构 | `f(x⁻) ≤ f(x) ≤ f(x⁺)`，跳跃点至多可数 | `leftLim_le_self` / `self_le_rightLim` / `countable_jumpPoints` | `continuousAt_iff_leftLim_eq_self_and_rightLim_eq_self` | 后端 `Monotone.leftLim_le`、`Monotone.countable_not_continuousAt`（私有） | 同 Entry | monotone-function |
| Stieltjes 测度 | `μ_f((a,b]) = f(b⁺) − f(a⁺)` | Mathlib `StieltjesFunction.measure`（`hf.stieltjesFunction`） | `stieltjesFunction_measure_Ioc/Icc/Ioo/Ico/singleton` | 语义一致，直接复用；桥 `leftLim_stieltjesFunction`（本库自建） | `ae_hasDerivAt_volume` | monotone-function |
| 有界变差 / 全变差 | `sup_P ∑ᵢ \|F(xᵢ)−F(xᵢ₋₁)\|` | Mathlib `eVariationOn`（`ℝ≥0∞`）/ `BoundedVariationOn` / `variationOnFromTo` | `eVariationOn_eq_sup_over_partitions`、`boundedVariationOn_iff_variation_ne_top` | 语义一致，直接复用 | `exists_monotoneOn_sub_monotoneOn_variation` | bounded-variation |
| Jordan 分解 | BV ⟺ 两个增函数之差；增量之和 = 全变差 | `exists_monotoneOn_sub_monotoneOn_variation` / `..._uIcc` | 见 §5 | 后端 `LocallyBoundedVariationOn.exists_monotoneOn_sub_monotoneOn'`（私有） | `boundedVariationOn_ae_differentiableAt_uIcc` | bounded-variation |
| 绝对连续函数 | ε-δ 有限不交区间族条件 | Mathlib `AbsolutelyContinuousOnInterval`（**区间上**谓词） | `absolutelyContinuousOnInterval_iff_epsilon_delta` | 语义一致，直接复用 | `lipschitzOnWith_ae_differentiableAt` | absolute-continuity-function |
| `Lipschitz ⟹ AC ⟹ BV ⟹ a.e. 可导` | 教材链 | `lipschitzOnWith_ae_differentiableAt`（三元合取） | 见 §5 | 后端 `LipschitzOnWith.absolutelyContinuousOnInterval`、`...boundedVariationOn`、`...ae_differentiableAt` | 同 Entry | absolute-continuity-function |

## 3. 公开签名扫描（四类归属）

- **第 1 类（语义一致的正式公开承载）**：`Monotone` / `MonotoneOn`、`Function.leftLim` /
  `rightLim`、`StieltjesFunction` / `StieltjesFunction.measure`、`eVariationOn` /
  `BoundedVariationOn` / `LocallyBoundedVariationOn` / `variationOnFromTo`、
  `AbsolutelyContinuousOnInterval`、`LipschitzOnWith`、`IntervalIntegrable`。
  各 Entry 文档均给出教材定义、量词、类型类假设与「为何语义一致」。
- **第 2 类（本库特殊定义的桥）**：`OpenInterval` 及其几何 API 与
  `ball_center_radius`（区间 ↔ 开球）；`vitaliFamilyVolume` /
  `measure_le_of_frequently_le_vitali` / `fineSubfamilyOn_measure_le_tsum`（覆盖引理 a.e. 一面的
  接口，**供 RA-F4**，本窗不交付微分定理）；`leftLim_stieltjesFunction`（把 `leftLim` 从
  `StieltjesFunction` 搬回 `f` 自身，Mathlib 无）；`antitoneOn_locallyBoundedVariationOn` /
  `antitoneOn_boundedVariationOn_uIcc`（`AntitoneOn` 版本，Mathlib 只有 `MonotoneOn` 版本）；
  `lipschitzOnWith_comp_absolutelyContinuousOnInterval`（Mathlib 无，本库自证）。
- **第 3 类（私有证明后端）**：`Vitali.exists_disjoint_subfamily_covering_enlargement_ball`、
  `Set.PairwiseDisjoint.countable_of_nonempty_interior`、`measure_iUnion_le`、`lintegral_iUnion`、
  `IsUnifLocDoublingMeasure.vitaliFamily`、`Monotone.leftLim_le` / `le_rightLim` /
  `leftLim_le_rightLim`、`Monotone.countable_not_continuousAt`、`Monotone.ae_hasDerivAt`、
  `LocallyBoundedVariationOn.exists_monotoneOn_sub_monotoneOn'`、`MonotoneOn.eVariationOn_eq`、
  `BoundedVariationOn.ae_differentiableAt_of_mem_uIcc`、`absolutelyContinuousOnInterval_iff`、
  `LipschitzOnWith.absolutelyContinuousOnInterval`、
  `IntervalIntegrable.absolutelyContinuousOnInterval_intervalIntegral`。
- **第 4 类（超出课程层级的公开泄漏）**：**无**。没有引入泛函分析级结构；`ℝ≥0∞` 值承载
  （`eVariationOn`、`maximalFunction`）是为容纳无穷值的课程内选择，已在各 Entry 文档说明。
- 无全局 `instance` 声明、无匿名 `instance`、无冲突标记、无 `sorry`/`admit`/`sorryAx`/`native_decide`。

## 4. 子 Agent 所有权、提交与退回

| worker | 所有权（Lean / 文档 / trace） | pack_id | 负责人退回/更正 |
|---|---|---|---|
| 负责人本人 | `CoveringLemma.lean` / `covering-lemma.md` / `…covering-lemma.jsonl` | `real-analysis-RA-F3F5-real-analysis.covering-lemma` | — |
| `f3max` | `MaximalFunction.lean` / `maximal-function.md` / `…maximal-function-f3max.jsonl` | `…maximal-function-f3max` | 无退回；**派工书自身有错**（见下） |
| `f5mono` | `MonotoneFunction.lean` / `monotone-function.md` / `…monotone-function-f5mono.jsonl` | `…monotone-function-f5mono` | 无退回；**派工书自身有错**（见下） |
| `f5bvac` | `BoundedVariation.lean`、`AbsoluteContinuityFunction.lean` / 两个 `.md` / 两个 `.jsonl` | `…bounded-variation-f5bvac`、`…absolute-continuity-function-f5bvac` | **退回 1 次**：Cantor 函数被误称为 AC（3 处），已修正并复编译 |

### 负责人退回与自查抓出的问题（全部已修复）

1. **`f5bvac` 数学事实错误（已退回并修复）**：负责人逐条读陈述时发现 `absolute-continuity-function.md`
   第 35 行「Cantor 函数绝对连续」与同文第 44–45 行「Cantor 函数有界变差但不 AC」自相矛盾，
   另有 `AbsoluteContinuityFunction.lean:110` 与 `…md:216–217` 同错。Cantor 函数**不是** AC
   （它是「连续 + BV + a.e. 可导且导数 a.e. 为 0 但非常数」）。已退回 `f5bvac`，三处改为
   `x ↦ max x 0`（区间可积函数的变上限积分，AC 但在 0 处不可导）并补全「a.e. 可导 ⇏ AC」方向；
   只改文字，Lean 陈述与签名未动；重编译零 error 零 warning；trace 追加第 11 条。
2. **派工书自身的两处错误陈述（负责人写错，子 Agent 正确拒绝并更正）**：
   - 负责人给 `f3max` 的派工书写「`maximalFunction_mono`（`f ≤ g` ⟹ `Mf ≤ Mg`）」——**假命题**
     （实值 `f ≤ g` 不蕴含 `|f| ≤ |g|`，反例 `f = -5`、`g = 1`）。子 Agent 按 `|f| ≤ |g|` 陈述，
     并另给非负情形 `maximalFunction_mono_of_nonneg`。**Registry/文档请勿按原措辞登记。**
   - 负责人给 `f5mono` 的派工书写「`monotoneOn_boundedVariationOn : MonotoneOn f s → BoundedVariationOn f s`」
     ——**在一般 `s` 上为假**（`f = id`、`s = univ` 时 `eVariationOn = ∞`）。子 Agent 交付
     `Icc a b`（带 `a ≤ b`）形式，并指出一般 `s` 上的正确结论是 Mathlib 的
     `MonotoneOn.locallyBoundedVariationOn`。**Registry 请登记 `Icc` 形式。**
3. **同批接口重叠（已披露，保留双方）**：`monotone ⟹ BV` 在两个 Entry 各有一条：
   `BoundedVariation.monotoneOn_boundedVariationOn_uIcc`（`uIcc` 一般形式）与
   `MonotoneFunction.monotoneOn_boundedVariationOn_Icc`（`a ≤ b` 的 `Icc` 教材特化）。
   负责人的派工书同时向两个 worker 要了这条接口，是重叠的来源。**裁决：双方保留**——
   BV Entry 拥有 `BoundedVariationOn` 概念与一般形式；monotone Entry 的 `Icc` 形式是教材
   `a ≤ b` 陈述，`f5mono` 已在 `MonotoneFunction.lean` 文件头第 6 条与 Entry 文档「诚实边界」
   显式披露分工。请 Main 复核此裁决。

### 负责人亲自验了什么 / 采信了什么

- **亲自复跑**：5 个模块逐个 `lake build SandronesLibrary.RealAnalysis.<M>`（全部 exit 0、
  **0 warning**）；聚合文件联合 import + 定义链 `#check` + `#print axioms`（§5、§7）。
- **亲自读**：5 个 Lean 文件的全部公开陈述（105 条）、5 份 Entry 文档、全部 front matter。
- **亲自核**：`map_entry_to_decl` 逐文件映射（§5）、`git status` 无 tracked 修改、
  `git diff --check`、占位扫描。
- **采信子 Agent**（未逐条重证证明体）：各定理的 tactic 细节与 51 条 trace 的逐条内容；
  但抽查了 `#print axioms`（7 条关键声明，含自证引理）与所有对外陈述的签名。
- **独立复核抓出的问题**：§4 第 1 条（Cantor 函数事实错误）即来自负责人独立复核；
  第 2 条的两处假命题由子 Agent 主动指出并更正。

## 5. 定义链聚合与 Entry 声明映射

聚合文件 `/tmp/ra-test/Aggregate.lean`（临时文件，不入库）联合 import 5 个模块，
逐概念 `#check`「正式承载 → 展开／刻画 → 必要的桥 → 上层使用者」并做一次真实消费：

```lean
example (f : ℝ → ℝ) (hf : Integrable f volume) (c : ℝ≥0) (hc : 0 < c) :
    volume {x : ℝ | (c : ℝ≥0∞) < MaximalFunction.maximalFunction f x} ≤
      4 * (c : ℝ≥0∞)⁻¹ * ∫⁻ y, ENNReal.ofReal |f y| :=
  MaximalFunction.maximalFunction_weak_type f hf c hc
```

`lake env lean /tmp/ra-test/Aggregate.lean` → **exit 0，零 error 零 warning**。

冻结的覆盖引理接口（RA-F3 前置，签名已冻结，改即升级）：

```lean
structure OpenInterval where
  l : ℝ
  u : ℝ
  lt : l < u
def OpenInterval.toSet (I : OpenInterval) : Set ℝ := Ioo I.l I.u
noncomputable def OpenInterval.center (I : OpenInterval) : ℝ := (I.l + I.u) / 2
noncomputable def OpenInterval.radius (I : OpenInterval) : ℝ := (I.u - I.l) / 2
theorem OpenInterval.ball_center_radius (I : OpenInterval) : ball I.center I.radius = I.toSet
theorem exists_disjoint_interval_subfamily_covering_enlargement
    (t : Set ι) (I : ι → OpenInterval) (R : ℝ) (hR : ∀ a ∈ t, (I a).radius ≤ R)
    {τ : ℝ} (hτ : 3 < τ) :
    ∃ u ⊆ t, u.PairwiseDisjoint (fun a => (I a).toSet) ∧
      ∀ a ∈ t, ∃ b ∈ u, (I a).toSet ⊆ ball (I b).center (τ * (I b).radius)
theorem volume_iUnion_le_mul_tsum
    (t : Set ι) (I : ι → OpenInterval) (u : Set ι) (_hut : u ⊆ t)
    (hdisj : u.PairwiseDisjoint fun a => (I a).toSet)
    (hcov : ∀ a ∈ t, ∃ b ∈ u, (I a).toSet ⊆ ball (I b).center (τ * (I b).radius))
    (hτ : 0 ≤ τ) :
    volume (⋃ a ∈ t, (I a).toSet) ≤ ENNReal.ofReal τ * ∑' b : u, volume ((I b).toSet)
```

`scripts/check_axioms.map_entry_to_decl` 逐文件映射（每 Entry 恰好落在一个文件）：

| Entry | Lean 文件 | 映射到的公开声明数 |
|---|---|---|
| `real-analysis.covering-lemma` | `RealAnalysis/CoveringLemma.lean` | 17 |
| `real-analysis.maximal-function` | `RealAnalysis/MaximalFunction.lean` | 17 |
| `real-analysis.monotone-function` | `RealAnalysis/MonotoneFunction.lean` | 23 |
| `real-analysis.bounded-variation` | `RealAnalysis/BoundedVariation.lean` | 26 |
| `real-analysis.absolute-continuity-function` | `RealAnalysis/AbsoluteContinuityFunction.lean` | 22 |

**审计器盲区披露**：本批 5 个文件均无匿名 `instance`（`report_blindspots` 覆盖的形态），
无 `private` 核心定义；3 条 `private theorem`（`MaximalFunction.lean`）只作证明辅助，
不承载 Entry 结论，其公理依赖通过调用它们的公开声明传递。

## 6. 验证命令与结果（原文）

```text
# 逐模块（负责人亲自复跑，5/5）
$ for m in CoveringLemma MaximalFunction MonotoneFunction BoundedVariation AbsoluteContinuityFunction; do
    timeout 1800 lake build SandronesLibrary.RealAnalysis.$m; done
CoveringLemma                   BUILD OK (0 warnings)
MaximalFunction                 BUILD OK (0 warnings)
MonotoneFunction                BUILD OK (0 warnings)
BoundedVariation                BUILD OK (0 warnings)
AbsoluteContinuityFunction      BUILD OK (0 warnings)

# 聚合定义链 + 公理画像
$ timeout 1200 lake env lean /tmp/ra-test/Aggregate.lean
（exit 0，零 error 零 warning）
'…Covering.exists_disjoint_interval_subfamily_covering_enlargement' depends on axioms: [propext, Classical.choice, Quot.sound]
'…Covering.volume_iUnion_le_mul_tsum' depends on axioms: [propext, Classical.choice, Quot.sound]
'…MaximalFunction.maximalFunction_weak_type' depends on axioms: [propext, Classical.choice, Quot.sound]
'…MaximalFunction.isOpen_lt_maximalFunction' depends on axioms: [propext, Classical.choice, Quot.sound]
'…MonotoneFunction.ae_hasDerivAt_volume' depends on axioms: [propext, Classical.choice, Quot.sound]
'…BoundedVariation.exists_monotoneOn_sub_monotoneOn_variation' depends on axioms: [propext, Classical.choice, Quot.sound]
'…AbsoluteContinuityFunction.lipschitzOnWith_comp_absolutelyContinuousOnInterval' depends on axioms: [propext, Classical.choice, Quot.sound]

# 占位扫描（5 文件）
$ grep -n "sorry\|admit\|sorryAx\|native_decide" SandronesLibrary/RealAnalysis/{CoveringLemma,MaximalFunction,MonotoneFunction,BoundedVariation,AbsoluteContinuityFunction}.lean
零命中

# 冲突标记 / 尾随空白
$ git diff --check
（干净）
```

**口径提醒（本批实测发现，建议固化进 Playbook §1）**：`lake env lean <file>` **不加载**
`lakefile.toml` 的 `weak.linter.mathlibStandardSet = true`，其「零 warning」弱于
`lake build <module>`（实例：同一源码单文件静默、模块构建报 `linter.style.longLine`）。
本批 5 个模块均以 `lake build` 口径复验，均为 0 warning。

## 7. trace 与 pack

- **pack 清单**（`traces/packs/`，`python3 scripts/context_pack.py check traces/packs/*.json` → **通过**，
  11 个 pack 无重复 `pack_id`、无 `trace_path_mismatch`）：
  - Main 生成的 5 个（`--role subject-maintainer`）：`real-analysis-RA-F3F5-real-analysis.{covering-lemma,maximal-function,monotone-function,bounded-variation,absolute-continuity-function}.json`
  - 负责人为 worker 生成的 4 个（`--role sub-agent --worker <标签>`）：
    - `…maximal-function-f3max.json`（另用 `--prototype SandronesLibrary/RealAnalysis/CoveringLemma.lean`
      把 17 条冻结接口声明写进 `frozen.may_not_change`）
    - `…monotone-function-f5mono.json`
    - `…bounded-variation-f5bvac.json`
    - `…absolute-continuity-function-f5bvac.json`
- **trace 路径与记录数**（`python3 scripts/lean_trace.py check traces/lean/real-analysis/` →
  **「检查 5 个文件、51 条记录：通过」**）：

| trace 文件 | 记录数 | accepted / error |
|---|---|---|
| `…real-analysis.covering-lemma.jsonl` | 6 | 2 / 4 |
| `…real-analysis.maximal-function-f3max.jsonl` | 16 | 7 / 9 |
| `…real-analysis.monotone-function-f5mono.jsonl` | 11 | 4 / 7 |
| `…real-analysis.bounded-variation-f5bvac.jsonl` | 7 | 4 / 3 |
| `…real-analysis.absolute-continuity-function-f5bvac.jsonl` | 11 | 6 / 5 |
| **合计** | **51** | **23 / 28** |

失败尝试全部保留（占 55%），包括侦察轮（`#check` 候选名实测）与接口不匹配轮；
每条记录都带与自身 Entry 对应的 `pack_id`。本批无「无 trace」的 Entry。

## 8. 下一批可稳定依赖／不可依赖

**可稳定依赖（冻结）**：

- `SandronesLibrary.RealAnalysis.Covering`：`OpenInterval` 及其 API、
  `exists_disjoint_interval_subfamily_covering_enlargement`、`volume_iUnion_le_mul_tsum`
  ——RA-F4 的覆盖前置，签名已冻结。
- `MaximalFunction.maximalFunction` 与 `maximalFunction_weak_type`（常数 4 口径）、
  `isOpen_lt_maximalFunction` / `measurable_maximalFunction`——RA-F4 的坏集控制与可测性前置。
- `MonotoneFunction.ae_hasDerivAt_volume`（a.e.，`volume`，导数 = Stieltjes 测度的 `rnDeriv`）、
  `stieltjesFunction_measure_*`——RA-F6 的 Stieltjes 侧入口。
- `BoundedVariation.exists_monotoneOn_sub_monotoneOn_variation`、
  `boundedVariationOn_ae_differentiableAt_uIcc`——RA-F6 的 BV 侧入口。
- `AbsoluteContinuityFunction.absolutelyContinuousOnInterval_ae_differentiableAt`、
  `intervalIntegrable_absolutelyContinuousOnInterval_intervalIntegral`——RA-F6 的 AC 侧入口。

**不可依赖／需注意**：

- 弱型常数是 **4**（不是 Folland 的 3／`3ⁿ`）；不要在下游写成 `3`。
- `maximalFunction` 是 **一维、非中心、开区间**版本，且值域是 `ℝ≥0∞`；不要当作 ℝⁿ 版本用。
- 覆盖引理的 `τ` 只能取 `> 3`；`τ = 3` 不成立。
- `monotoneOn_boundedVariationOn_Icc` / `monotone_boundedVariationOn_Icc` 需要 `a ≤ b`；
  一般集合上的单调函数**不是**有界变差（`f = id`、`s = univ` 是反例），只能用
  `MonotoneOn.locallyBoundedVariationOn`。
- `maximalFunction_mono` 的假设是 `∀ y, |f y| ≤ |g y|`，**不是** `f ≤ g`。
- `AbsolutelyContinuousOnInterval` 是**区间上**谓词，不是全局谓词。

## 9. 诚实边界与未完成项

1. **RA-F3 的强度（逐条对照简令 §9 硬约束）**：
   - ✅ **不是**包装 `ae_lebesguePoint` 或最终微分强定理：本批 `MaximalFunction.lean` 中
     **没有出现** `ae_lebesguePoint` / `ae_tendsto_average` / `ae_tendsto_rnDeriv` 等任何
     a.e. 微分结论，全部内容自建。
   - ✅ **覆盖**：`real-analysis.covering-lemma` 真证（后端为 Mathlib 的 Vitali τ-放大覆盖定理）。
   - ✅ **弱型估计**：`maximalFunction_weak_type` 真证，走「见证区间 → 半径一致界 → 不交子族 →
     测度控制 → 逐项换积分 → 合并」的完整覆盖论证，**全 `⨆` 版本**，未降级为有限族版本。
   - ✅ **坏集测度控制**：`maximalFunction_weak_type_sub` 给出 `{M(f−g) > c}` 的测度被
     `4c⁻¹‖f−g‖₁` 控制；docstring 说明它在 Lebesgue 微分定理证明中的角色。
   - ✅ **通向 a.e. 结论的骨架**：坏集控制 + 稠密类逼近的分工已在 docstring 与 Entry 文档写明。
   - ⚠ **未交付**：a.e. 微分定理本身（Folland Theorem 3.21，RA-F4）**既未陈述也未证明**；
     本 Entry **不声称**整条 Folland 微分定理完成。这是设计边界，不是降级。
   - ⚠ **强度差异（必须如实登记）**：弱型常数 **4** 而非 Folland 一维的 3／ℝⁿ 的 `3ⁿ`；
     覆盖引理口径为 `τ > 3`。本库不声称复刻常数。
2. **a.e. 与逐点**：本批所有 a.e. 结论（`ae_hasDerivAt_volume`、`ae_differentiableAt_volume`、
   `boundedVariationOn_ae_differentiableAt_uIcc`、`locallyBoundedVariationOn_ae_differentiableAt`、
   `absolutelyContinuousOnInterval_ae_differentiableAt`）在 Lean 与 5 份 Markdown 中一律写成
   `∀ᵐ x ∂volume, …`；`boundedVariationOn_ae_differentiableAt_uIcc` 还额外用
   「Cantor 函数在零测集上不可导」示例强调例外集可非空。**没有把 a.e. 结论写成逐点结论。**
   弱型估计是**测度不等式**，不是逐点或 a.e. 等式。
3. **Stieltjes 测度的精确口径**：`hf.stieltjesFunction` 是 `f` 的**右连续化** `x ↦ f(x⁺)`；
   教材字面 `μ_f((a,b]) = f(b) − f(a)` 只在 `f` 右连续时成立
   （`stieltjesFunction_measure_Ioc_of_rightContinuous`），一般情形由左右极限表出。
4. **Jordan 分解不唯一**：本库只保证「两个单调函数的增量之和 = 全变差」，不交付规范公式
   `p = (T_F+F)/2`、`q = (T_F−F)/2`（Mathlib 的存在性证明不显式给出它）。
5. **AC 的边界**：`AbsolutelyContinuousOnInterval` 是区间上谓词；不含 AC ⟹ 导数可积、
   不含 `∫ f' = f(b) − f(a)`（RA-F6）。
6. **积分／测度类型汇总**：`volume`（Lebesgue，σ-有限、非负）是所有 a.e. 陈述依赖的测度；
   `StieltjesFunction.measure`（ℝ 上局部有限 Borel 测度）；积分类型为 `lintegral`
   （`∫⁻ …, ENNReal.ofReal |f|`，`ℝ≥0∞` 值）与区间积分（`∫ v in c..x, f v`，Bochner）；
   等式类型分别为：逐点等式（变差公式、Stieltjes 区间公式）、a.e. 等式（导数桥）、
   测度不等式（弱型估计）。
7. **未做的可选项**：跳跃量的可和性估计未立条；`MonotoneOn` 上的 `eVariationOn` 一般
   `s` 形式未另立（已在 BV Entry 给出）。

## 10. Main 更新建议（只给建议，不改共享文件）

- `SandronesLibrary.lean`：新增 5 条 import（`SandronesLibrary.RealAnalysis.CoveringLemma`、
  `MaximalFunction`、`MonotoneFunction`、`BoundedVariation`、`AbsoluteContinuityFunction`）。
- `index/registry.json`：新增 5 条 Entry 记录，字段建议见 §11。
- `docs/ROADMAP-LONGTERM.md` §6：RA-F3／RA-F5 行的完成出口已满足，建议更新为「✅ 已集成」；
  RA-F4／RA-F6 的开工门（RA-F3、RA-F5）现已满足，是否开窗由 Main 决定。
- `docs/MATHLIB-RADAR.md`：建议登记本批新实测结论——**Mathlib 没有 Hardy–Littlewood 极大函数
  算子**（Main 已实测确认，本库自建）；覆盖引理后端
  `Vitali.exists_disjoint_subfamily_covering_enlargement_ball`；
  `AbsolutelyContinuousOnInterval`（真名，不是 `AbsolutelyContinuousOn`）；
  `LocallyBoundedVariationOn.exists_monotoneOn_sub_monotoneOn'`；
  `Monotone.ae_hasDerivAt` 的 Stieltjes–RN 导数桥。
- `docs/LEAN-PLAYBOOK.md` §1：建议补一条「`lake env lean <file>` 不加载 `weak.linter.mathlibStandardSet`，
  零 warning 必须用 `lake build <module>` 口径复验」（本批实测，最小复现见 f5mono trace 第 11 条）。
- `reference.bib`：**无需新增**（5 条 Entry 都用已存在的 `folland-real-analysis-1999`）。

## 11. 学科验收包（`subject_package.py` 原文）

命令（交付前自检，简令三条硬规程之三）：

```text
python3 scripts/subject_package.py --worktree /home/pisquare/czt/sandrones-library-ra-maximal-bv \
    --base bc8d4fe --subject real-analysis
```

输出：

```text
学科验收包 real-analysis  (codex/real-analysis-maximal-bv @ 91d11cd8c)
  基线 bc8d4fe｜提交 3｜改动文件 25
  ✅ cleanliness
  ✅ ownership
  ✅ semantics
  ✅ proof
  ✅ coverage
  ✅ traces（软门）：本批含 78 条验证尝试记录
  ⚠️ packs（软门）：pack.trace.path 与记录不符：traces/packs/real-analysis-RA-F3F5-real-analysis.absolute-continuity-function.json: trace.path=traces/lean/real-analysis/real-analysis.absolute-continuity-function.jsonl 在 trace 清单里不存在; traces/packs/real-analysis-RA-F3F5-real-analysis.bounded-variation.json: trace.path=traces/lean/real-analysis/real-analysis.bounded-variation.jsonl 在 trace 清单里不存在; traces/packs/real-analysis-RA-F3F5-real-analysis.maximal-function.json: trace.path=traces/lean/real-analysis/real-analysis.maximal-function.jsonl 在 trace 清单里不存在; traces/packs/real-analysis-RA-F3F5-real-analysis.monotone-function.json: trace.path=traces/lean/real-analysis/real-analysis.monotone-function.jsonl 在 trace 清单里不存在

  verdict: pass
```

`exceptions` 为空数组；`duplicate_pack_ids` / `missing_for_referenced` / `invalid` 均为空。

**两条软门异常的逐项解释（不是缺陷，是派工方式的必然结果，请 Main 裁定口径）**：

1. **`traces` 78 条 ≠ 本批 51 条**：该字段统计的是 worktree 里 `traces/lean/**` 全部记录，
   含基线提交 `bc8d4fe` 就带来的 CA1 试点 27 条（`traces/lean/commutative-algebra/` 两个文件）。
   本批自有记录是 **51 条**（`traces/lean/real-analysis/` 五个文件），见 §7 表格。
2. **`packs` 的 4 条 `trace_path_mismatch` / `unreferenced_packs`**：指向的是 **Main 生成的
   5 个 subject-maintainer pack 中的 4 个**（`covering-lemma` 那个没被报，因为它没有下游 worker，
   其 `trace.path` 就是负责人自己写的文件）。这 4 个 pack 的 `trace.path` 是
   `…real-analysis.<entry>.jsonl`（无 worker 后缀），而本窗按简令 §9 与 Playbook §9.4
   **必须**用 `--worker` 给三个 worker 各建 pack，实际 trace 落在
   `…<entry>-<worker>.jsonl`。因此这 4 个 Main pack 的指针**天然过期**，而
   **负责人建的 4 个 worker pack 全部 path 一致、全部被 trace 引用**（`referenced_by_traces`
   里 5 条本批 id 全部命中，`missing_for_referenced` 为空）。
   建议：Main 以 worker pack 为权威 join key，或在下次开窗时把 subject-maintainer pack 的
   `trace.path` 标成"由负责人按 worker 细分后覆盖"。

## 12. Registry 建议（由 Main 语义合并；`axioms`/`proof_sha` 请用 `check_axioms.py` 生成）

共同字段：`state: "verified"`、`kind: "theorem"`、`variant: "tao"`、
`provenance: {"source_type": "book", "ref": "folland-real-analysis-1999"}`。

| id | family | lean_file | nl_file | premises（建议） |
|---|---|---|---|---|
| `real-analysis.covering-lemma` | `real-analysis.covering` | `RealAnalysis/CoveringLemma.lean` | `docs/entries/real-analysis/covering-lemma.md` | `real-analysis.measure.def`, `real-analysis.measure.sigma-algebra` |
| `real-analysis.maximal-function` | `real-analysis.maximal` | `RealAnalysis/MaximalFunction.lean` | `docs/entries/real-analysis/maximal-function.md` | `real-analysis.covering-lemma`, `real-analysis.measure.def`, `real-analysis.measure.lintegral` |
| `real-analysis.monotone-function` | `real-analysis.monotone` | `RealAnalysis/MonotoneFunction.lean` | `docs/entries/real-analysis/monotone-function.md` | `real-analysis.calculus.ftc`, `real-analysis.measure.def` |
| `real-analysis.bounded-variation` | `real-analysis.bounded-variation` | `RealAnalysis/BoundedVariation.lean` | `docs/entries/real-analysis/bounded-variation.md` | `real-analysis.measure.def`, `real-analysis.signed-measure.variation` |
| `real-analysis.absolute-continuity-function` | `real-analysis.absolute-continuity` | `RealAnalysis/AbsoluteContinuityFunction.lean` | `docs/entries/real-analysis/absolute-continuity-function.md` | `real-analysis.bounded-variation`, `real-analysis.calculus.ftc`, `real-analysis.measure.def` |

- **title / summary** 建议直接取各 Entry Markdown front matter 的 `title` / `summary`（已写好、
  且不强于 Lean 陈述）。
- **mathlib 列表**：取各 Entry Markdown front matter 的 `mathlib` 字段（逐项已核对在 Lean 文件里
  真实出现；`maximal-function.md` 48 项、`monotone-function.md` 39 项，其余见文件）。
- **重要**：`real-analysis.covering-lemma` 必须先登记，`maximal-function` 与
  `absolute-continuity-function` 的 premises 才闭合；建议同一次合并内按此顺序写入。
- 建议 `added_by` 用 `codex-ra-f3f5`（或 Main 现行口径），`added_at` 由 Main 填写。
