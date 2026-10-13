# 概率论 Wave R1 正式交接（Pr3.5 一般 iid CLT）

- subject：probability
- branch：`codex/probability-wave-r1`
- worktree：`/home/pisquare/czt/sandrones-library-probability-r1`
- base（Main 基线）：`49acfa0`（Wave R 并行窗口派工提交）
- gate：`development_open`（本批自 Wave R R-probability 窗口开工；与 §1.2 D8 的 `research_open`
  标记存在口径差异，见“权限与路线口径”）
- entries（2 条）：
  - `probability.central-limit-theorem`
  - `probability.convergence.distribution-bridge`
- formal sources：
  - `SandronesLibrary/Probability/CLTCenteredStandardized.lean`
  - `SandronesLibrary/Probability/DistributionConvergenceBridge.lean`
- documents：
  - `docs/entries/probability/clt/central-limit-theorem.md`
  - `docs/entries/probability/convergence/distribution-bridge.md`
- 本 handoff：`docs/handoffs/probability-wave-r1.md`

## 1. 范围与交付

本批完成 ROADMAP §9 Pr3 第 5 行 `probability.central-limit-theorem` 的**可开发部分**：

1. **一般 iid 中心极限定理（正方差）**：任意均值 `μ`、方差 `σ² > 0`、二阶矩有限的实值 iid
   序列，证明 `(σ√n)⁻¹∑_{k<n}(Xₖ-μ)` 的分布弱收敛到 `gaussianReal 0 1`。
2. **退化方差边界**：`Var[X₀]=0` 时证明 `(√n)⁻¹∑(Xₖ-μ)` 的分布弱收敛到 `gaussianReal 0 0`。
3. **随机变量层分布收敛桥**：把 `ProbabilityMeasure ℝ` 层弱收敛（已知目标 `gaussianReal 0 1`）
   组装为随机变量层的 `TendstoInDistribution`。
4. 上一条的真实消费者：一般 CLT 的随机变量层版本。

**证明策略是中心化标准化归约**：令 `Yₖ=(Xₖ-μ)/σ`，把一般情形化归到已集成的
`probability.clt.characteristic-foundation`。没有 import 或调用 Mathlib 的最终
`CentralLimitTheorem`，也没有重做特征函数/Taylor 展开。

未完成边界（不得当成已交付）：非同分布三角阵、Lindeberg–Feller 条件、Berry–Esseen 速度、多元与
函数型 CLT；任意点态特征函数极限 `φₙ→f`（`f` 在 0 连续）的存在性。因此本批**没有**完成 ROADMAP
字面意义上的“任意均值方差、退化方差边界与分布收敛桥的调查”之全部：方差为零与分布收敛桥已完成，
任意点态极限存在性未完成。

## 2. 提交

| commit | 内容 |
|---|---|
| `dbba195` | 两个 Lean 源模块 |
| `07b7bbb` | 两篇 Entry 文档 |
| `<handoff-commit>` | 本 handoff（提交后回填） |

## 3. 概念冻结表

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画或一手性质 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 分布收敛（随机变量层） | 推前分布弱收敛 | `MeasureTheory.TendstoInDistribution` | structure 的 `tendsto` 字段即 `ProbabilityMeasure` 弱收敛 | 语义一致，直接复用（已在 `probability.convergence.modes` 解释） | 本批桥与 CLT 消费者 | `probability.convergence.distribution-bridge` |
| 分布的测度载体 | 随机变量的分布律 | `lawProbabilityMeasure`（本库 `def`） | 展开为 `⟨P.map Y, _⟩` | 本库薄封装；桥侧接口，使弱收敛假设有统一载体 | `tendstoInDistribution_of_tendsto_law_gaussian` | 同上 |
| 中心化缩放和律 | `(σ√n)⁻¹∑(Xₖ-μ)` 的分布 | `centeredScaledSumLaw`（本库 `def`） | 展开为推前 `ProbabilityMeasure ℝ` | 本库教材定义；无对应 Mathlib 接口 | `iid_centeredScaled_clt` | `probability.central-limit-theorem` |
| 一般 iid CLT | 任意均值、正方差 iid 归一化趋标准正态 | `iid_centeredScaled_clt`（theorem） | 归约到已集成标准化核心 | 目标测度为已知 `gaussianReal 0 1` | `..._tendstoInDistribution` | 同上 |
| 退化方差 CLT | `σ²=0` 时中心化归一化趋 δ | `degenerateVariance_centeredSum_tendsto`（theorem） | 由 `ae_eq_integral_of_variance_eq_zero` 得几乎必然常数 | Mathlib `gaussianReal_zero_var`、`eventually_all` | 边界披露 | 同上 |
| 方差 | 二阶中心矩 | `ProbabilityTheory.variance` | `variance_eq_integral` | 语义一致，直接复用 | 主定理假设 | 同上 |
| 二阶矩有限 | `X₀ ∈ L²` | `MeasureTheory.MemLp (X 0) 2 P` | `MemLp.integrable`（得可积） | 语义一致，直接复用 | 主定理假设 | 同上 |

## 4. 公开签名扫描（四类归属）

1. **语义一致的正式公开承载**：`MeasureTheory.TendstoInDistribution`、
   `MeasureTheory.ProbabilityMeasure`、`ProbabilityTheory.variance`、`MeasureTheory.MemLp`、
   `MeasureTheory.gaussianReal`、`Filter.Tendsto`。课程文档逐一给出教材解释与 Lean 对照。
2. **本库特殊定义的桥侧接口**：`lawProbabilityMeasure`（推前分布载体，展开为 `⟨P.map Y,_⟩`）、
   `centeredScaledSumLaw`（中心化缩放和律载体）、
   `centeredScaledSumLaw_eq_normalizedSumLaw`（两载体同一性的方向清楚的桥）。
3. **私有证明后端**：`integral_div`、`integral_sub`、`integral_const`、`Measure.map_congr`、
   `Finset.aemeasurable_fun_sum`、`iIndepFun.comp`、`IdentDistrib.comp`、
   `IdentDistrib.ae_snd`、`ae_eq_integral_of_variance_eq_zero`、`Measure.map_const`、
   `Measure.isProbabilityMeasure_map`。均未成为课程公开概念，在此披露。
4. **越级公开泄漏**：无。没有引入最终 CLT、`TendstoInDistribution` 之外的随机变量收敛结构、三阶
   矩、三角阵或高维接口。没有匿名 `instance`（`check_axioms.py --blindspots` 新增盲区为零）。

## 5. 依赖、Mathlib 与 Entry 归属

- `probability.convergence.distribution-bridge`
  - premises：`[probability.convergence.modes]`
  - mathlib：`MeasureTheory.TendstoInDistribution`、`MeasureTheory.ProbabilityMeasure`、
    `MeasureTheory.Measure.isProbabilityMeasure_map`、`MeasureTheory.Measure.map_congr`
  - lean_file：`SandronesLibrary/Probability/DistributionConvergenceBridge.lean`
- `probability.central-limit-theorem`
  - premises：`[probability.clt.characteristic-foundation,
    probability.convergence.distribution-bridge]`
  - mathlib：`ProbabilityTheory.variance`、`ProbabilityTheory.variance_eq_integral`、
    `ProbabilityTheory.ae_eq_integral_of_variance_eq_zero`、`MeasureTheory.MemLp.integrable`、
    `MeasureTheory.gaussianReal_zero_var`、`MeasureTheory.ProbabilityMeasure`
  - lean_file：`SandronesLibrary/Probability/CLTCenteredStandardized.lean`

`provenance.ref` 均为 `kallenberg-modern-probability-2021`（`reference.bib:525` 已存在，无需新增
引用键）。章节定位写在 Entry 正文。

## 6. 负责人验收证据（真实输出）

### 6.1 定向构建（禁止全库 build）

```text
$ cd /home/pisquare/czt/sandrones-library-probability-r1
$ lake build SandronesLibrary.Probability.DistributionConvergenceBridge \
             SandronesLibrary.Probability.CLTCenteredStandardized
✔ [3161/3163] Built SandronesLibrary.Probability.Convergence (1.2s)
✔ [3162/3163] Built SandronesLibrary.Probability.DistributionConvergenceBridge (1.2s)
✔ [3163/3163] Built SandronesLibrary.Probability.CLTCenteredStandardized (1.5s)
Build completed successfully (3163 jobs).
```

零 error、零 warning。依赖闭包包含 `Probability/Convergence.lean`、
`Probability/CLTCharacteristicFoundation.lean`、`Probability/LevyContinuity.lean`。

### 6.2 联合导入 + `#check` + 公理探测

聚合文件 `/tmp/sandrones-library/aggregate.lean` 同时 import 本批两个模块，`#check` 11 个公开
声明并 `#print axioms` 5 个关键声明：

```text
$ lake env lean /tmp/sandrones-library/aggregate.lean
#check iIndepFun_centeredScaled / identDistrib_centeredScaled /
       integral_centeredScaled_eq_zero / integral_sq_centeredScaled_eq_one /
       centeredScaledSumLaw / centeredScaledSumLaw_eq_normalizedSumLaw /
       iid_centeredScaled_clt / iid_centeredScaled_clt_tendstoInDistribution /
       degenerateVariance_centeredSum_tendsto / lawProbabilityMeasure /
       tendstoInDistribution_of_tendsto_law_gaussian        —— 全部解析
#print axioms iid_centeredScaled_clt
  → [propext, Classical.choice, Quot.sound]
#print axioms iid_centeredScaled_clt_tendstoInDistribution
  → [propext, Classical.choice, Quot.sound]
#print axioms degenerateVariance_centeredSum_tendsto
  → [propext, Classical.choice, Quot.sound]
#print axioms tendstoInDistribution_of_tendsto_law_gaussian
  → [propext, Classical.choice, Quot.sound]
#print axioms centeredScaledSumLaw
  → [propext, Classical.choice, Quot.sound]
（无 sorryAx）
```

### 6.3 Entry 声明映射（`scripts.check_axioms.map_entry_to_decl`）

```text
CLTCenteredStandardized.lean
  probability.central-limit-theorem -> 9 个声明（仅本文件）
DistributionConvergenceBridge.lean
  probability.convergence.distribution-bridge -> 2 个声明（仅本文件）
```

一个 Entry 只对应一个 Lean 文件，标记不跨文件；两文件均只含一个标记。

### 6.4 占位与所有权

- `grep -rE "\b(sorry|admit|sorryAx|native_decide)\b"` 两个源文件：零命中。
- `git status --short`：仅新增本批 4 个文件；未触碰 `SandronesLibrary.lean`、`index/*`、
  `reference.bib`、`docs/MATHLIB-RADAR.md`、`docs/ROADMAP-*.md`、`docs/LEAN-PLAYBOOK.md`、
  `docs/entries/README.md`、`docs/entries/RANKINGS.md`、`scripts/**`、`README.md`、`AGENTS.md`。

### 6.5 学科验收包自检

```text
$ python3 scripts/subject_package.py \
    --worktree /home/pisquare/czt/sandrones-library-probability-r1 \
    --base 49acfa0 --subject probability
<见 §7 回填>
```

### 6.6 磁盘纪律

- 开工前 `df -h /`：可用 8.8G。
- 建 worktree + 符号链接 `.lake/packages` 后：可用 8.2G。
- 全部定向构建完成后 `.lake/build` 仅约 6.8M（Mathlib olean 复用主工作树 `.lake/packages`）。
- 未运行 `lake update`、`lake exe cache get`、全库 `lake build`；任何时点可用均高于 3G。

## 7. 学科验收包回填

（运行后由本节记录 verdict 与异常清单。）

## 8. 子 Agent 所有权与退回

本批**未派子 Agent**：交付面为两个强耦合的小模块（一般 CLT 直接消费分布收敛桥的载体），且同一
worktree 的 git index 与 `.lake/build` 是单写者资源，子 Agent 并发 lake 被显式禁止，拆分只会增加
串行协调成本。所有源码、文档与验证由学科负责人本人完成与复核。因此无子 Agent 退回记录。

## 9. Main 需更新的共享文件清单（建议，学科未改）

1. `SandronesLibrary.lean`：新增
   - `import SandronesLibrary.Probability.DistributionConvergenceBridge`
   - `import SandronesLibrary.Probability.CLTCenteredStandardized`
   建议放在 `Probability/` 导入块，`CLTCenteredStandardized` 放在其依赖之后。
2. `index/registry.json`：登记两条 Entry（id / family / kind / state / provenance / premises /
   mathlib 见 §5；`axioms`、`proof_sha` 由 `check_axioms.py` 生成）：
   - `probability.central-limit-theorem`，`kind: theorem`，
     `lean_file: Probability/CLTCenteredStandardized.lean`
   - `probability.convergence.distribution-bridge`，`kind: theorem`，
     `lean_file: Probability/DistributionConvergenceBridge.lean`
3. `docs/ROADMAP-LONGTERM.md` §9 Pr3 第 5 行与 §1 阶段表：建议把 `probability.central-limit-theorem`
   由笼统 🚧 细化为“iid 有限二阶矩、正方差与退化方差已完成，任意点态极限存在性未完成”；本批
   不宣称完成 D8 全部调查面。同时新增 `probability.convergence.distribution-bridge` 条目记录。
4. `docs/MATHLIB-RADAR.md`：建议收录 `ProbabilityMeasure` 弱收敛 → `TendstoInDistribution` 桥，
   以及 `ae_eq_integral_of_variance_eq_zero`、`gaussianReal_zero_var` 的新“谁在用”段落。
5. `reference.bib`：无需新增；两条 Entry 复用已有键 `kallenberg-modern-probability-2021`。
6. Examples：理论接口无需 Examples 阻塞；可在后续巡视中为标准正态极限补计算例（本批不登记）。

## 10. 每个学科 handoff 必须回答的路线问题

1. **本批推进哪个门**：`G-Pr` 已 ✅；本批推进 Phase 8 Pr3 极限定理，把一般 iid CLT 从
   `research_open` 推进到可开发交付。不新开门。
2. **公共定义归属**：`centeredScaledSumLaw` 归 `probability.central-limit-theorem`；
   `lawProbabilityMeasure` 归 `probability.convergence.distribution-bridge`。Mathlib 的
   `TendstoInDistribution`／`ProbabilityMeasure` 是正式承载；`norms` 无关的积分与 `map_congr`
   只是证明后端。
3. **子 Agent 所有权**：本批未派子 Agent（见 §8）。
4. **联合导入测试**：`/tmp/sandrones-library/aggregate.lean` 同时 import 两个模块并 `#check`
   11 个公开声明（见 §6.2）。
5. **下一批可稳定依赖的 API**：`lawProbabilityMeasure`、
   `tendstoInDistribution_of_tendsto_law_gaussian`、`centeredScaledSumLaw`、
   `iid_centeredScaled_clt`、`iid_centeredScaled_clt_tendstoInDistribution`、
   `degenerateVariance_centeredSum_tendsto`。**不可依赖**：任意点态特征函数极限存在性、三角阵
   Lindeberg–Feller、Berry–Esseen、多元/函数型 CLT。
6. **Main 更新建议与诚实边界**：见 §9 与“权限与路线口径”。

## 11. 权限与路线口径（诚实披露）

§1.2 D8 把 Pr3.5 一般 CLT 标为 `research_open`，措辞是“调查任意均值方差、退化方差边界与随机变量
分布收敛桥”。Wave R（`49acfa0`）另开 R-probability 窗口并要求学科交付可编译、可验收的批次。
本批按 Wave R 的交付要求以 `development_open` 执行，产出**已验证的 Lean 源码与 Entry**，而非仅调查
报告；因此与 D8 的旧权限标记存在口径差异。本批仍在 D8 划定的数学边界内：不使用 Mathlib 最终 CLT，
不把“任意点态极限”写成已证。建议 Main 在集成时同步 D8 与 Wave R 的权限口径。
