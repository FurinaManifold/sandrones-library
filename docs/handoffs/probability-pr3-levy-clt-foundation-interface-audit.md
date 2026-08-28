# Pr3 Lévy 连续性与 CLT 前置接口审计

- branch：`codex/probability`
- synced Main：`d780483`（merge 后当前学科基线）
- gate：`probability.characteristic-function.levy-continuity-foundation = research_open`
- temporary prototype：`/tmp/LevyCLTFoundationFramework.lean`
- formal source：无；研究阶段没有写入 `SandronesLibrary/`

## 审计结论

Mathlib 的有限维 Lévy 收敛理论已经提供精确的概率测度接口；首批实值前置无需复制弱收敛拓扑：

```lean
ProbabilityMeasure.tendsto_iff_tendsto_charFun
```

在 `μ n μ₀ : ProbabilityMeasure ℝ` 上准确陈述

```text
μₙ weakly tends to μ₀
↔ for every t, charFun (μₙ) t tends to charFun μ₀ t.
```

当目标 `μ₀` 已经是概率测度时，它的特征函数自动连续，故这个 iff 不需要再显式传入零点连续性。
若只知道特征函数趋于任意函数 `f`，Mathlib 的
`isTightMeasureSet_of_tendsto_charFun` 要求 `ContinuousAt f 0` 才推出紧性；仅有逐点极限不足以宣称
存在极限概率分布。这一区分必须在课程入口中保留。

## 概念六列表

| 概念 | 教材定义／语义 | Lean 正式承载候选 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | 拟定 Entry |
|---|---|---|---|---|---|---|
| 概率测度弱收敛 | 对有界连续测试函数积分收敛 | `Tendsto μ atTop (𝓝 μ₀)` on `ProbabilityMeasure ℝ` | ProbabilityMeasure 拓扑 | 直接复用，不另造分布收敛结构 | Lévy iff | `probability.characteristic-function.levy-continuity` |
| Lévy 正向 | 弱收敛推出特征函数逐点收敛 | `tendsto_iff_tendsto_charFun`.mp | 复指数是有界连续测试函数 | Mathlib 完整证明 | 分布极限检验 | 同上 |
| Lévy 反向 | 目标特征函数逐点收敛推出弱收敛 | `tendsto_iff_tendsto_charFun`.mpr | 紧性加特征函数唯一性 | 复用 Prokhorov/char-poly 后端 | 归一化和 | 同上 |
| 任意点态极限 | `φₙ→f` 且 `f` 在零点连续 | `isTightMeasureSet_of_tendsto_charFun` | 先只推出测度族紧 | 不能冒充已识别极限测度 | existence 前置 | 同上 |
| 归一化和律 | `(√n)⁻¹ Σ_{k<n}Xₖ` 的分布 | `ProbabilityMeasure ℝ` 推前 | `normalizedSumLaw` 临时构造 | 推前概率实例来自 a.e. 可测 | characteristic power | `probability.clt.characteristic-foundation`（候选） |
| 独立和乘积 | 独立有限和的特征函数为乘积 | `iIndepFun.charFun_map_fun_finsetSum_eq_prod` | iid 后乘积化为 n 次幂 | 复用已验收特征函数 carrier | normalized sum | 同上 |
| 二阶展开 | 中心 0、二阶矩 1 时 `φ(u)=1-u²/2+o(u²)` | `taylor_charFun_two` | `isLittleO` at `𝓝 0` | 不要求三阶矩 | power limit | 同上 |
| 标准正态目标 | `N(0,1)` 特征函数为 `exp(-t²/2)` | `gaussianReal 0 1`、`charFun_gaussianReal` | 参数代入并化简 | 直接复用标准概率测度 | Lévy target | 同上 |

## Lévy 定理的准确边界

`ProbabilityMeasure.tendsto_of_tendsto_charFun` 的输入已经是目标概率测度 `μ₀` 的特征函数，因此它
不会解决“任意点态极限函数是不是特征函数”这个独立存在性问题。一般版本的教材逻辑是：

1. `φₙ(t) → f(t)`；
2. `f` 在 `0` 连续，且由 `φₙ(0)=1` 得 `f(0)=1`；
3. 先由积分估计得到紧性；
4. 对收敛子列识别其特征函数为 `f`；
5. 用特征函数唯一性证明所有子列极限相同。

Mathlib 的 `isTightMeasureSet_of_tendsto_charFun` 实现第 3 步；已知目标测度版的 iff 封装第 3–5 步。
首批公开接口应优先提供已知目标概率测度版，任意 `f` 的存在性版本另行评估，不得删去
`ContinuousAt f 0`。

## 归一化和与乘积公式

临时定理 `normalizedSum_charFun_eq_pow` 在 `iIndepFun X P` 和逐项
`IdentDistrib (X i) (X 0)` 下证明

```text
charFun law((√n)⁻¹ Σ_{k<n} Xₖ) t
  = (charFun law(X₀) ((√n)⁻¹ t))^n.
```

证明顺序是：缩放公式 → 独立有限和乘积 → 同分布把每个乘子改成第零项。可测性逐项从
`IdentDistrib` 提取。这里没有调用最终 CLT。

## 二阶 Taylor 到指数极限

`taylor_charFun_two` 在 `P[Z]=0`、`P[Z²]=1` 下给出

```text
charFun law(Z) u = 1 - u²/2 + o(u²),  u → 0.
```

令 `u=t/√n`，则 `u→0` 且 `u²=t²/n`。临时定理
`centeredVarianceOne_charFun_pow_tendsto` 将小量估计传给
`tendsto_pow_exp_of_isLittleO_sub_add_div`，得到

```text
(charFun law(Z) (t/√n))^n → exp(-t²/2).
```

这一步只需二阶矩，不误加三阶矩或 Berry--Esseen 条件。

## 无最终 CLT 的原型链

`normalizedSum_probabilityMeasure_tendsto_standardGaussian` 把上述两项组装：

1. 用 `normalizedSumLaw` 把每个归一化和的推前测度打包成 `ProbabilityMeasure ℝ`；
2. 独立同分布公式把其特征函数改写为幂；
3. 二阶 Taylor 证明该幂逐点趋于 `exp(-t²/2)`；
4. `charFun_gaussianReal` 将其识别为 `gaussianReal 0 1` 的特征函数；
5. 调用 `ProbabilityMeasure.tendsto_iff_tendsto_charFun` 的反向得到弱收敛。

原型显式 import Lévy、Taylor、Gaussian 与独立特征函数模块，没有 import
`Mathlib.Probability.CentralLimitTheorem`，也没有调用
`tendstoInDistribution_inv_sqrt_mul_sum` 或最终 CLT 包装。

验证：

- 定向构建 `Mathlib.MeasureTheory.Measure.LevyConvergence` 与 Gaussian 依赖通过（3154 jobs）；
- `lake env lean /tmp/LevyCLTFoundationFramework.lean` 零错误、零 warning；
- 占位与最终 CLT 名称扫描零命中。

## 诚实边界与开发建议

- 原型只处理中心为零、二阶矩为一的实值 iid 情形；一般均值和方差的中心化标准化尚未冻结。
- 当前结论是 `ProbabilityMeasure ℝ` 的弱收敛。与本库 `TendstoInDistribution` 随机变量 carrier 的
  桥应另列公开消费者，不能混成定义相等。
- 方差为零的退化情形、任意方差目标 `gaussianReal 0 v`、三角阵与 Lindeberg 条件不在本批。
- 最终 CLT 仍冻结。本 handoff 建议先开放 Lévy 已知目标测度 iff、归一化和特征函数幂公式和
  centered variance-one pointwise limit；是否同时开放弱收敛组装由 Main 冻结。
