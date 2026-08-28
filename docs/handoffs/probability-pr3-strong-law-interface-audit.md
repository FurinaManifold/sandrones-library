# Pr3 强大数律接口与截断证明边界审计

## 权限与结论

- gate：`probability.law-large-numbers.strong` 当前为 `research_open`。
- 本批仅调查 Mathlib carrier、最小矩条件、a.e. 结论和已有 Etemadi 截断证明；不新增正式模块、
  Entry 或 verified 声明。
- `/tmp/StrongLawAudit.lean` 已成功导入并检查 `strong_law_aux1` 至 `aux7`、
  `strong_law_ae_real`、Banach 值 `strong_law_ae`，并完整验证建议的 pairwise 与 iid 两层签名；无
  错误、warning 或 `sorry`。

结论：实值强大数律的最小教材矩条件是一阶可积 `Integrable (X 0) μ`，不是 WLLN 中的二次可积。
Mathlib 已经形式化 Etemadi 的更强版本，只要求两两独立。课程主接口可同时保留这个最小定理和
`iIndepFun` 的标准 iid 消费者；不能把调用最终 theorem 的一行 wrapper 当作已经解释了截断证明。

## 概念冻结建议

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | 拟定 Entry |
|---|---|---|---|---|---|---|
| 两两独立 | 任意两个不同随机变量独立 | `Pairwise (Function.onFun (fun f g ↦ f ⟂ᵢ[μ] g) X)` | 直接量化 `i ≠ j` | Mathlib Etemadi 定理的最小独立性 | 最小 SLLN | `probability.law-large-numbers.strong` |
| iid 独立性 | 全族联合独立 | `iIndepFun X μ` | `iIndepFun.indepFun` 推出两两独立 | 标准教材 carrier，作为最小定理消费者 | iid SLLN | 同上 |
| 同分布 | 每项推前分布等于基准项 | `∀ i, IdentDistrib (X i) (X 0) μ μ` | 传递可积性与截断分布 | 与 WLLN 一致，直接复用 | 截断期望与尾部 | 同上 |
| 最小矩条件 | `E|X₀|<∞` | `Integrable (X 0) μ` | 同分布传给全部项 | 不误用 `MemLp _ 2` | 截断与正负部分 | 同上 |
| 样本均值 | 前 `n` 项和除以 `n` | `(n : ℝ)⁻¹ * ∑ i ∈ range n, X i ω` | 与 WLLN 相同首项约定 | 不另建 process def | a.s. 极限 | 同上 |
| 几乎必然收敛 | 除零测集外逐点收敛 | `∀ᵐ ω ∂μ, Tendsto ... atTop (𝓝 E[X₀])` | 既有 `almostSurelyConverges_iff_ae_tendsto` | 与 Pr3 carrier 一致 | SLLN 结论 | 同上 |
| 截断 | 在随指标增长的区间内裁剪随机变量 | `ProbabilityTheory.truncation` | `strong_law_aux1`–`aux5` | 作为已有证明骨架，不建立重复 truncation | 非负 SLLN | 同上 |

## 建议冻结签名

Etemadi 的最小实值版本：

```lean
theorem strongLaw_of_pairwise_independent_integrable
    (X : ℕ → Ω → ℝ) (hint : Integrable (X 0) μ)
    (hindep : Pairwise (Function.onFun (fun f g ↦ f ⟂ᵢ[μ] g) X))
    (hident : ∀ i, IdentDistrib (X i) (X 0) μ μ) :
    ∀ᵐ ω ∂μ,
      Tendsto (fun n : ℕ ↦ (n : ℝ)⁻¹ * ∑ i ∈ range n, X i ω)
        atTop (𝓝 (∫ ω, X 0 ω ∂μ))
```

标准 iid 消费者只把 `iIndepFun` 降到两两独立：

```lean
theorem strongLaw_of_iid_integrable
    (X : ℕ → Ω → ℝ) (hint : Integrable (X 0) μ)
    (hindep : iIndepFun X μ)
    (hident : ∀ i, IdentDistrib (X i) (X 0) μ μ) :
    ∀ᵐ ω ∂μ, Tendsto ...
```

虽然 `strong_law_ae_real` 本身可在任意测度上陈述并在非零情形内部推出概率测度性质，课程正式
签名是否显式保留 `[IsProbabilityMeasure μ]` 可由 Main 决定。建议教材公开层保留该实例以明确
语境，而把无实例版本披露为 Mathlib 后端的额外强度；最小性重点应放在一阶矩和 pairwise 独立，
不是省略“概率空间”语义。

## Mathlib 截断证明地图

Mathlib 的 `StrongLaw.lean` 不是一个无证明的最终 API，而是完整实现了 Etemadi 路线：

1. `strong_law_aux1`：对非负变量，以 `truncation (X i) i` 控制几何子列上的中心化波动；结论是
   eventually 的 `ε · ⌊cⁿ⌋` 控制。
2. `strong_law_aux2`：把上述波动整理为相对于几何样本量的 `IsLittleO`。
3. `strong_law_aux3`：证明截断和的期望与 `n E[X₀]` 之差是 `o(n)`；这里使用同分布与一阶可积。
4. `strong_law_aux4`：合并随机波动和期望误差，得到几何子列上的中心化截断和 `o(n)`。
5. `strong_law_aux5`：证明截断和与原和之差 a.s. 为 `o(n)`，这是尾部可求和／Borel--Cantelli
   作用的位置。
6. `strong_law_aux6`：由前述三块得到几何子列样本均值收敛。
7. `strong_law_aux7`：对非负变量利用部分和单调性填补几何子列间隙，得到全体自然数上的收敛。
8. `strong_law_ae_real`：把一般实值变量分成正部与负部，分别调用非负版本后相减。

因此后续正式条目可以直接复用 `strong_law_ae_real` 保证 kernel 证明的可信性，但 Entry 和公开辅助
接口必须保留上述截断—几何子列—填隙—正负部分语义链，不能只写“由 Mathlib 强大数律 exact”。

## Banach 值边界

Mathlib 的 `strong_law_ae` 已推广到完备实赋范空间，仍只要求一阶 Bochner 可积、两两独立和同分布；
其内部先用简单函数逼近处理强可测版本，再传回原随机变量。当前概率教材路线的首个 SLLN 条目建议
保持实值，与 WLLN 及标量期望接口对齐。Banach 值版本可作为后续推广披露，但不能让高阶类型类
进入首个公开签名。

`strong_law_Lp` 是另一条更强的 `Lᵖ` 收敛结论，需要 `1 ≤ p < ∞` 和 `MemLp`；它不是 a.s. SLLN
的一阶矩最小假设，也不应替代本条目的截断证明。

## 边界

- 本审计不新增或复制 `truncation`，不调用 SLLN 证明 CLT，也不进入特征函数。
- 不把相互独立与两两独立混为一谈：`iIndepFun` 是标准 iid 的强 carrier，Etemadi 定理只消费其
  两两后果。
- 不声称一阶矩以下仍成立，不处理非同分布 Kolmogorov 条件、三角阵、遍历定理或稳定律。
- `n=0` 的零首项与 WLLN 相同，只影响有限个指标。

## 后续门建议

若 Main 接受两层签名和上述证明地图，可将 `probability.law-large-numbers.strong` 转为
`development_open`，正式文件建议为 `SandronesLibrary/Probability/StrongLaw.lean`。特征函数与
中心极限定理继续冻结。
