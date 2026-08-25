# 分析维护说明：数项级数教材定义

## 现状与关键语义差别

`Analysis/Series.lean` 此前写明直接使用 `Summable`、`HasSum` 和有限集部分和，课程文档把
`Summable`/`HasSum` 直接称为级数收敛与级数和。但教材中的实数项级数首先固定自然顺序部分和；
条件收敛级数在重排后可能改变和。Mathlib 的 `HasSum` 使用有限子集滤子，表达无条件求和，不能与
自然顺序收敛无条件画等号。

## 本轮定义

```lean
def SeriesHasSum (f : ℕ → ℝ) (s : ℝ) : Prop :=
  Tendsto (fun N => ∑ n ∈ Finset.range N, f n) atTop (𝓝 s)

def SeriesConvergent (f : ℕ → ℝ) : Prop :=
  ∃ s, SeriesHasSum f s

def SeriesAbsolutelyConvergent (f : ℕ → ℝ) : Prop :=
  SeriesConvergent (fun n => |f n|)
```

## Mathlib 桥及方向

- `hasSum_seriesHasSum`：`HasSum f s → SeriesHasSum f s`，总是成立。
- `seriesHasSum_iff_hasSum_of_summable_abs`：假设绝对值项 `Summable` 时双向等价。
- `seriesAbsolutelyConvergent_iff_summable_abs`：教材绝对收敛与绝对值项 `Summable` 双向等价。

不存在无条件的 `SeriesHasSum f s ↔ HasSum f s`：条件收敛的实数级数给出反例边界。这不是桥尚未
证明，而是两种概念确实不同。

## 接口边界

本项为 M1 定义补充，同时记录一个不可忽略的语义差别：新 `SeriesHasSum` 不是旧 `HasSum` 的
改名，因此二者同时保留；既有几何级数、判别法、Cauchy 准则和重排定理继续使用 Mathlib 接口。
没有替换或退役计划。

本轮不重写现有定理，不定义级数的数值算子，不处理一般拓扑群求和。新定义均为普通 `Prop`，
不增加 notation、instance 或 simp 属性。共享状态由 Main 更新。回滚点为 `89d78ce`。
