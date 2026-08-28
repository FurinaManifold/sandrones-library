# Pr3 四种随机变量收敛模式接口审计

## 权限与结论

- gate：`probability.convergence.modes` 当前仅为 `research_open`。
- 本批只冻结 Mathlib carrier、教材展开、蕴含关系和建议签名；不新增 Lean 模块、Entry 或 verified
  声明。
- `/tmp/ProbabilityConvergenceModesAudit.lean` 已成功检查本文列出的全部正式 API。

结论：四种模式不应统一塞进一个自建枚举或结构。Mathlib 已分别提供最贴近数学语义的表达；本库
开发时应以薄桥整理它们，并证明经典单向蕴含链。

## 概念冻结建议

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | 拟定 Entry |
|---|---|---|---|---|---|---|
| 几乎处处收敛 | 除零测集外逐点收敛 | `∀ᵐ ω ∂μ, Tendsto (fun n ↦ X n ω) atTop (𝓝 (Z ω))` | 直接展开，不另建 carrier | Mathlib 没有必要的独立结构；保留 a.e. filter 语义 | a.s. 推概率收敛 | `probability.convergence.modes` |
| 概率收敛 | 对每个 `ε>0`，偏差超过 `ε` 的概率趋零 | `TendstoInMeasure μ X atTop Z` | `tendstoInMeasure_iff_dist`／`tendstoInMeasure_iff_measureReal_dist` | 在概率测度上就是教材的 convergence in probability | 概率推分布收敛 | `probability.convergence.modes` |
| `Lᵖ` 收敛 | `‖Xₙ-Z‖ₚ → 0` | `Tendsto (fun n ↦ eLpNorm (X n - Z) p μ) atTop (𝓝 0)` | 直接以当前 `eLpNorm` API 表达 | 不使用旧 `snorm` 名，也不强迫函数先打包为 `Lp` | `Lᵖ` 推概率收敛 | `probability.convergence.modes` |
| 分布收敛 | 随机变量的律弱收敛 | `TendstoInDistribution X atTop Z μs μ` | 结构字段给出 a.e. 可测性和 `ProbabilityMeasure` 中的 `Tendsto` | 直接复用，允许样本空间／测度随指标变化 | 连续映射定理、CLT | `probability.convergence.modes` |

## 四个正式接口的真实形状

### 几乎处处收敛

课程中的“几乎必然收敛”直接写成

```lean
∀ᵐ ω ∂μ, Tendsto (fun n ↦ X n ω) atTop (𝓝 (Z ω))
```

这里 a.e. 量词属于测度 `μ`，内部是值域拓扑中的普通 filter 收敛。开发时可为教材可读性提供
一个 `..._iff_ae_tendsto` 定理，但不应复制成新的 opaque 定义。由 a.s. 收敛推出概率收敛时，
Mathlib 的 `tendstoInMeasure_of_tendsto_ae` 还要求有限测度和各 `X n` a.e. 强可测；概率空间自动满足
有限测度条件。

### 概率收敛

`TendstoInMeasure μ X l Z` 的底层定义使用扩展距离：对每个 `ε > 0`，集合
`{ω | ε ≤ edist (X i ω) (Z ω)}` 的测度沿 `l` 趋于零。度量值域下
`tendstoInMeasure_iff_dist` 给出教材版本；有限测度下
`tendstoInMeasure_iff_measureReal_dist` 把集合测度转成实数。

“in measure” 对一般测度和“in probability” 对概率测度使用同一个正式 carrier 是语义复用，
不是概念缺失。本库不应再定义 `TendstoInProbability` 平行结构。

### `Lᵖ` 收敛

对普通函数最直接的表达是

```lean
Tendsto (fun n ↦ eLpNorm (X n - Z) p μ) atTop (𝓝 0)
```

`eLpNorm` 取值 `ℝ≥0∞`，同时覆盖有限指数和 `p = ∞`。由 `Lᵖ` 收敛推出概率收敛的成熟定理是
`tendstoInMeasure_of_tendsto_eLpNorm`；它要求 `p ≠ 0`、值域为 `NormedAddCommGroup`，以及各项和
极限 a.e. 强可测。若输入已经属于 `Lp E p μ`，另有 `tendstoInMeasure_of_tendsto_Lp`，但课程定义
不应为了复用该定理而把普通随机变量接口强制改成商空间元素。

### 分布收敛

`TendstoInDistribution` 是现成 Prop-valued structure，字段包括：

1. 每个 `X i` 对其源测度 a.e. 可测；
2. 极限随机变量 a.e. 可测；
3. 推前概率测度 `map (X i) (μ i)` 在 `ProbabilityMeasure E` 的弱拓扑中趋于极限律。

它比课程最初需要的同一概率空间版本更一般：源空间 `Ω i` 和测度 `μ i` 可以随 `i` 改变。开发层
应以固定源空间为常用特化，但不能另造一个更窄 carrier 取代正式定义。弱收敛拓扑可由
`ProbabilityMeasure.tendsto_iff_forall_lintegral_tendsto` 展开为对所有有界连续测试函数的积分收敛。

## 经典蕴含链与不可逆边界

建议 development 批至少公开并组装：

1. a.s. 收敛 `→` 概率收敛：复用 `tendstoInMeasure_of_tendsto_ae`；
2. `Lᵖ` 收敛（`p ≠ 0`）`→` 概率收敛：复用
   `tendstoInMeasure_of_tendsto_eLpNorm`；
3. 概率收敛 `→` 分布收敛：复用 `TendstoInMeasure.tendstoInDistribution`；
4. a.s. 收敛 `→` 分布收敛：可直接复用 `tendstoInDistribution_of_ae_tendsto`，或由前两层组装；
5. 概率收敛序列存在 a.s. 收敛子列：复用 `TendstoInMeasure.exists_seq_tendsto_ae`；
6. 连续映射定理：复用 `TendstoInDistribution.continuous_comp`，作为分布收敛的首个上层消费者。

逆命题一般不成立：分布收敛不推出概率收敛，概率收敛不保证原序列 a.s. 收敛，也不推出任意
`Lᵖ` 收敛。正式文档必须明确“存在 a.s. 收敛子列”不能误写成整个序列 a.s. 收敛。

## 建议开发签名边界

- 第一版固定序列指标为 `ℕ`、filter 为 `atTop`，便于与教材四种模式对齐；底层 carrier 仍保留
  Mathlib 的一般 filter 版本。
- a.s.、概率和 `Lᵖ` 模式可先共享同一概率空间；分布模式应展示正式 carrier 支持不同源空间，
  再给同空间特化。
- 值域至少取带 Borel 结构的度量空间；`Lᵖ` 蕴含另需加法范数结构。
- 不将 a.e. 可测、a.e. 强可测、Borel 条件或 filter 的 `NeBot`／countably generated 假设从公开
  签名中删掉。
- 不在本 Entry 提前证明 LLN、特征函数唯一性或 CLT；它只建立这些定理共同使用的收敛语言。

## 后续门建议

请 Main 审核本 carrier 表和签名边界。若转为 `development_open`，建议单一 formal source
`SandronesLibrary/Probability/Convergence.lean`，Entry id 保持
`probability.convergence.modes`；先完成四种展开和蕴含链，再决定弱大数律窗口是否开放。
