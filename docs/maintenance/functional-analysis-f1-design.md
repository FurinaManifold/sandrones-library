# F1 泛函分析基础设计 RFC

## 基线与范围

- 分支：`codex/functional-analysis`
- Main 基线：`fe232a4`
- ROADMAP 批次：F1 赋范空间与连续线性算子
- 依赖门：L5、T3、R4 已进入 Main；本批完成后建议打开 F2。

本窗只覆盖赋范／Banach 基础、连续线性算子、算子空间、Banach 值级数和闭子空间商空间。
不提前进入 Baire、Banach--Steinhaus、开映射、闭图、Hahn--Banach 或 Hilbert 投影理论。

## 已验收定义，不重复建设

ROADMAP 的 `functional-analysis.normed.definition` 与现有
`topology.normed-space.def` 数学内容重合。后者已经提供：

- `NormedLinearSpace` 与 `BanachSpace` 教材入口；
- 范数非负、正定、三角不等式和数乘相容性；
- 范数收敛、范数 Cauchy 判据及 Banach 完备性的真实使用者；
- 到 Mathlib `NormedSpace`、`CompleteSpace` 的透明承载说明。

因此 F1 直接 import 并依赖该已验收入口，不创建第二套赋范空间结构，也不新增一个只改命名的
`functional-analysis.normed.definition` Lean Entry。建议 Main 集成时把 ROADMAP 第 1 项标为
“复用 `topology.normed-space.def`”，避免一条数学定义对应两个 Registry id。

## F1 新概念冻结

| 概念 | 本库教材定义 | 一手性质 | Mathlib 桥／承载 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|
| 有界线性算子 | `IsBoundedLinearOperator T := ∃ C ≥ 0, ∀ x, ‖T x‖ ≤ C * ‖x‖` | 零算子、和与复合保持有界 | 与线性映射连续性、`ContinuousLinearMap` 具名桥 | 连续、局部有界、全局有界等价 | `functional-analysis.operator.continuous-linear-map` |
| 算子范数 | 所有全局界的下确界；实现细节先在临时框架验证 | `‖T x‖ ≤ ‖T‖‖x‖` 与最小界性质 | Mathlib CLM norm 为计算承载并证明相等 | 算子空间范数与完备性 | `functional-analysis.operator.space` |
| 向量值绝对可和 | `VectorSeriesAbsolutelySummable f := Summable (fun n ↦ ‖f n‖)` | 尾项范数控制部分和差 | `Summable` 是已验收级数承载 | Banach 中绝对可和推出可和 | `functional-analysis.series.summable` |
| 闭线性子空间 | 线性子空间载体加拓扑闭性；优先复用已验收线性子空间入口 | 零元、加法、数乘封闭及极限封闭 | `Submodule`／`Submodule.Quotient` 仅作结构承载 | 商空间范数与完备性 | `functional-analysis.subspace.quotient` |

`ContinuousLinearMap` 不直接冒充教材定义。课程主入口先陈述线性映射的全局范数界，再证明它与
连续性等价，并提供到 Mathlib 打包对象的构造／遗忘桥。若算子范数的下确界定义在 Lean 中需要
额外非空或有界证明，这些证明属于本 Entry，而不是改用透明别名规避定义。

## 文件所有权与实施顺序

1. `SandronesLibrary/FunctionalAnalysis/Operator.lean`
   - 有界线性算子谓词；
   - 连续、局部有界、全局有界等价；
   - `ContinuousLinearMap` 双向桥。
2. `SandronesLibrary/FunctionalAnalysis/OperatorSpace.lean`
   - 算子范数定义／刻画；
   - 算子空间范数结构和完备性。
3. `SandronesLibrary/FunctionalAnalysis/BanachSeries.lean`
   - 向量值绝对可和定义；
   - Banach 空间中绝对可和推出可和。
4. `SandronesLibrary/FunctionalAnalysis/Quotient.lean`
   - 闭线性子空间教材入口；
   - 商范数与商 Banach 空间。

每个文件独立拥有其 Entry；不把同一 Registry id 跨文件拆分。定义层文件先通过聚合组装测试，
才开发依赖它的算子空间、级数和商空间结论。

## 公开签名分类预案

- `NormedAddCommGroup`、`NormedLinearSpace`、`BanachSpace`：已验收概念的底层承载。
- `LinearMap`：线性代数阶段已验收的线性映射承载。
- `ContinuousLinearMap`：只允许出现在具名桥、计算承载或兼容定理中。
- `Summable`、`HasSum`：已验收级数承载；新课程谓词负责明确范数绝对可和语义。
- `Submodule.Quotient`／`NormedSpace.Quotient`：候选底层商类型承载；必须先给闭子空间与商范数的
  教材语义，并在 handoff 中列出泄漏边界。
- 不新增全局 instance 或 simp attribute，除非它们仅作用于本库新结构且在 handoff 中披露。

## 验收与诚实边界

每个新概念必须同时通过“定义／一手性质／桥／上层使用者”聚合 `#check` 和 Entry 映射检查。
学科负责人只运行目标模块及依赖闭包；Registry、顶层 import、RADAR、ROADMAP 状态和全库构建
留给 Main 集成。

RFC 完成只冻结接口，不代表 F1 已实现。尤其不能因为 Mathlib 已有 `ContinuousLinearMap`、
算子范数或商 Banach instance，就把薄包装登记为课程完成。
