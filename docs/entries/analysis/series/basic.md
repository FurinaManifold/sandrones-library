---
id: analysis.series.basic
family: analysis.series
variant: textbook
kind: theorem
state: verified
title: 数项级数的自然顺序定义与基础性质
summary: 定义自然顺序部分和、收敛和绝对收敛，并准确区分教材级数与 Mathlib 无条件求和
premises: [analysis.sequence.definition, analysis.sequence.cauchy]
mathlib: [HasSum, Summable, HasSum.tendsto_sum_nat, hasSum_iff_tendsto_nat_of_summable_norm]
provenance:
  source_type: textbook
  ref: "ecnu-mathematical-analysis-5"
---

# 动机

教材中的数项级数是按固定顺序累加的部分和序列。Mathlib 的 `HasSum` 则通过所有有限子集组成的
滤子定义求和，天然不依赖枚举顺序。对绝对收敛级数两者一致，但条件收敛级数不能随意重排。
因此必须先把自然顺序定义写清楚，再说明何时能够使用 Mathlib 的更强接口。

# 直觉

把前 `N` 项相加得到部分和 `S_N`。若 `S_N` 随 `N→∞` 趋于 `s`，就说级数按当前顺序和为 `s`；
只要求存在某个 `s` 就是收敛。若把每项换成绝对值后仍收敛，就是绝对收敛，它消除了正负抵消，
因而允许使用与顺序无关的求和接口。

# 陈述（自然语言）

- `SeriesHasSum f s`：自然顺序部分和趋于 `s`。
- `SeriesConvergent f`：存在某个自然顺序部分和极限。
- `SeriesAbsolutelyConvergent f`：绝对值级数按自然顺序收敛。
- `HasSum f s` 总能推出 `SeriesHasSum f s`。
- 在绝对值项可和的前提下，`SeriesHasSum f s` 与 `HasSum f s` 等价。
- 教材绝对收敛与 `Summable (fun n => |f n|)` 等价。

# 陈述（Lean 对照）

```lean
def SeriesHasSum (f : ℕ → ℝ) (s : ℝ) : Prop :=
  Tendsto (fun N => ∑ n ∈ Finset.range N, f n) atTop (𝓝 s)

def SeriesConvergent (f : ℕ → ℝ) : Prop := ∃ s, SeriesHasSum f s

def SeriesAbsolutelyConvergent (f : ℕ → ℝ) : Prop :=
  SeriesConvergent (fun n => |f n|)

theorem hasSum_seriesHasSum (h : HasSum f s) : SeriesHasSum f s

theorem seriesHasSum_iff_hasSum_of_summable_abs
    (habs : Summable (fun n => |f n|)) :
    SeriesHasSum f s ↔ HasSum f s
```

# 思维脉络（thinking trace）

1. `Finset.range N` 固定前 `N` 个自然数指标，`Tendsto ... atTop` 正是部分和序列极限。
2. `HasSum.tendsto_sum_nat` 从有限集滤子收敛得到自然顺序子网收敛，所以正向桥无条件成立。
3. 反向一般不成立：自然顺序条件收敛不保证任意有限集累加方式收敛到同一值。
4. `hasSum_iff_tendsto_nat_of_summable_norm` 在范数项可和时恢复双向桥；实数范数由
   `Real.norm_eq_abs` 化为绝对值。
5. 对非负绝对值项，`hasSum_iff_tendsto_nat_of_nonneg` 证明教材绝对收敛与 Mathlib 可和等价。

# 自然语言 ↔ Lean 映射

| 自然语言 | Lean |
|---|---|
| 前 `N` 项部分和 | `∑ n ∈ Finset.range N, f n` |
| 按自然顺序和为 `s` | `SeriesHasSum f s` |
| 级数按自然顺序收敛 | `SeriesConvergent f` |
| 绝对收敛 | `SeriesAbsolutelyConvergent f` |
| Mathlib 无条件和为 `s` | `HasSum f s` |
| Mathlib 无条件可和 | `Summable f` |

# 依赖（人话版）

- `analysis.sequence.definition`：部分和本身是实数列，其收敛使用普通数列极限。
- `analysis.sequence.cauchy`：部分和 Cauchy 条件是级数判别的重要形式。
- `HasSum.tendsto_sum_nat`：从 Mathlib 求和得到自然顺序部分和极限。
- `hasSum_iff_tendsto_nat_of_summable_norm`：绝对可和条件下的反向桥。
- `hasSum_iff_tendsto_nat_of_nonneg`：非负级数自然部分和与 Mathlib 求和的桥。

# 应用与陷阱

- 应用：几何级数、绝对收敛判别和绝对收敛重排可以继续直接使用 `HasSum`/`Summable`。
- 陷阱：不能无条件声称 `SeriesHasSum f s ↔ HasSum f s`；条件收敛级数是反例。
- 陷阱：`Finset.range N` 包含 `0,...,N-1`，不是包含第 `N` 项的 `0,...,N`。
- 边界：本条只定义自然数指标实数级数；一般拓扑群的无条件求和仍由 Mathlib 接口承担。
