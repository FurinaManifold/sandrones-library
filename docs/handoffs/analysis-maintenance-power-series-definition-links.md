# Analysis maintenance handoff：幂级数与一般级数定义挂靠

- 基线：Main `9572873`
- Entry：`analysis.power-series.definition`
- 影响等级：M1；新增三条定义桥，并让一个既有上层定理经过一般级数教材层。

## 定义链

| 幂级数概念 | 一般级数概念 | 桥 | 真实使用者 |
|---|---|---|---|
| `HasSumAt a c x s` | `SeriesHasSum (term a c x) s` | `hasSumAt_iff_seriesHasSum` | `ConvergesAt` 的存在量词定义 |
| `ConvergesAt a c x` | `SeriesConvergent (term a c x)` | `convergesAt_iff_seriesConvergent` | `absolutelyConvergesAt_imp_convergesAt` |
| `AbsolutelyConvergesAt a c x` | `SeriesAbsolutelyConvergent (term a c x)` | `absolutelyConvergesAt_iff_seriesAbsolutelyConvergent` | `absolutelyConvergesAt_imp_convergesAt` |

前两条是定义相同的透明等价；第三条复用一般级数绝对收敛到 `Summable |term|` 的已验收桥。
普通自然顺序收敛继续允许条件收敛，不建立到 Mathlib 无条件 `HasSum`／`Summable` 的错误等价。

## 公开签名分类

- `SeriesHasSum`、`SeriesConvergent`、`SeriesAbsolutelyConvergent`：已验收的本库教材定义。
- `Summable`：第三条桥的证明后端，且保留在历史绝对收敛定义展开中。
- `Tendsto`、`Finset.range`：自然部分和定义的底层载体。
- 无新增公开例外。

## 验证

- `PowerSeries` 定向构建、七项定义链聚合 `#check`、Entry audit 和公理审计通过。
- Entry 映射覆盖 19 个声明；禁用占位扫描与 `git diff --check` 通过。
