# F4.9 均值遍历定理接口调查

- 分支：`codex/functional-analysis`
- Main 基线：`d2dc95f`
- 权限：F4 编号较后的弱紧致工具 `research_open`
- 状态：教材范围、Mathlib 缺口与候选签名调查；不提交正式定理

## 教材范围

本调查通过 Bühler--Salamon PDF 页面图像核对 Section 3.6：

- PDF 159--161（印刷页 144--146）：遍历测度、极点刻画与 Von Neumann 均值遍历应用；
- PDF 163--167（印刷页 148--152）：Theorem 3.6.9 及其八步证明。

Theorem 3.6.9 的对象是实 Banach 空间上的有界线性自映射 `T`，假设存在 `c ≥ 1` 使所有幂
`‖T^n‖ ≤ c`。令

```text
Sₙ = (1/n) * sum_{k=0}^{n-1} T^k.
```

教材证明：

1. `Sₙ x` 收敛当且仅当有弱收敛子列；
2. 收敛点集合 `Z` 是闭的 `T`-不变线性子空间，并且
   `Z = ker(1-T) ⊕ closure(im(1-T))`；若 `X` 自反，则 `Z = X`；
3. 极限给出有界投影 `S : Z → Z`，满足 `ST = TS = S² = S` 和 `‖S‖ ≤ c`。

Theorem 3.6.5 的 `Lᵖ` 遍历结论是该抽象定理在 Koopman 算子上的应用，不应与抽象算子定理合并
为同一 Entry。遍历测度极点刻画还涉及测度论，亦不属于本窗口的最小泛函分析入口。

## Mathlib 覆盖

Mathlib 已有：

- `birkhoffSum`、`birkhoffAverage`：迭代和与平均的通用承载；
- `Function.IsFixedPt.tendsto_birkhoffAverage`：固定点上的平均；
- `tendsto_birkhoffAverage_apply_sub_birkhoffAverage`：望远镜差；
- `LinearMap.tendsto_birkhoffAverage_of_ker_subset_closure`：收缩算子加给定投影的范数空间版本；
- `ContinuousLinearMap.tendsto_birkhoffAverage_orthogonalProjection`：Hilbert 空间中 `‖T‖ ≤ 1`
  时收敛到固定点子空间的正交投影。

当前锁定 Mathlib 中未找到 Salamon Theorem 3.6.9 的一般 power-bounded Banach 版本，也未找到其
“弱收敛子列 iff 范数收敛”、一般收敛域直和分解或自反空间处处收敛结论。Hilbert 收缩版本不能
替代这些核心部分：它要求内积结构和单步收缩，并预先使用正交投影。

## 正式承载候选

| 教材概念 | 候选 Lean 承载 | 说明 |
|---|---|---|
| 幂有界 | `∃ c : ℝ, 1 ≤ c ∧ ∀ n, ‖T ^ n‖ ≤ c` | 当前未发现成熟专用谓词；先冻结量词，不急建别名 |
| Cesàro 平均 `Sₙ x` | `birkhoffAverage ℝ T id n x` | 与教材公式一致，注意 `n = 0` 的 Lean 总定义 |
| 固定点空间 | `T.eqLocus (1 : E →L[ℝ] E)` | 等价于 `ker (1-T)`；优先复用 |
| 差分像闭包 | `(T - 1).range.topologicalClosure` 或集合 closure | 需统一符号方向；`range(T-1)=range(1-T)` |
| 收敛域 | `{x | ∃ y, Tendsto (birkhoffAverage ℝ T id · x) atTop (𝓝 y)}` | 课程量词首次出现，正式窗口可能需要具名定义 |
| 极限投影 | 收敛域子类型上的 `ContinuousLinearMap` | 必须在先证明极限唯一、线性和一致有界后构造 |

## 教材证明与现有依赖

```text
幂一致有界
  -> ‖Sₙ‖ ≤ c 与 Sₙ(1-T) -> 0
  -> fixed space 与 closure(range(1-T)) 的直和、和空间闭
  -> 直和上的范数收敛
  -> 弱收敛子列 iff 范数收敛
       |
       +-- Eberlein--Šmulian：自反空间中有界序列抽取弱收敛子列
       v
     自反空间上处处收敛
  -> 极限投影 S，ST = TS = S² = S，‖S‖ ≤ c
```

新提交 `64de52d` 的 Eberlein--Šmulian 四项等价正好提供教材 Step 8 所需的“自反 + 有界序列
推出弱收敛子列”。因此 F4.9 正式开发必须等待 F4.7 集成或在 handoff 标记
`integration_waits_for: functional-analysis.eberlein-smulian`。

## 建议冻结的批次

建议拆为两个可独立审核的窗口：

1. `mean-ergodic.decomposition`：幂有界、Cesàro 平均、收敛域、固定点加差分像闭包分解，以及
   弱子列判据；
2. `mean-ergodic.reflexive`：调用 F4.7 得到自反空间处处收敛，并构造极限投影。

若 ROADMAP 只保留一个 Entry，也应在同一模块内先冻结上述定义链，不能只包装 Mathlib 的 Hilbert
最终定理。`Lᵖ` Koopman 应用、遍历测度与 Birkhoff 点态定理均留在概率/动力系统路线。

## 边界

- 不创建第二套 Birkhoff average；直接使用 Mathlib `birkhoffAverage`；
- 不把 `‖T‖ ≤ 1` Hilbert 特例写成 power-bounded Banach 一般结果；
- 不在 `research_open` 下修改正式源码或登记 verified Entry；
- 不把测度论应用提前并入泛函分析基础条目。
