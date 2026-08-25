# F1 泛函分析基础设计 RFC

## 基线与范围

- 分支：`codex/functional-analysis`
- 当前 Main 基线：`8d5d823`；已按最新解释层规则 rebase
- ROADMAP 批次：F1 赋范空间与连续线性算子
- 依赖门：L5、T3、R4 已进入 Main；本批完成后建议打开 F2。

本窗只覆盖赋范／Banach 基础、连续线性算子、算子空间、Banach 值级数和闭子空间商空间。

## Playbook 语义复用修正

Main `8d5d823` 明确：教材解释层不要求为语义一致的 Mathlib 概念再造本库名字。初版 RFC 错误地
计划自建有界线性算子谓词、算子范数和绝对可和谓词；这些接口与 Mathlib 语义一致，现已撤回。

## 正式承载冻结

| 概念 | 教材语义 | Lean 正式承载 | 展开／刻画 | 复用说明 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 赋范／Banach 空间 | 范数线性空间；Cauchy 列收敛 | 已验收 `NormedLinearSpace`、`BanachSpace` | 范数公理、Cauchy 判据 | 复用 Topology 条目 | 连续线性算子 | 复用既有 Entry |
| 连续线性算子 | 线性且连续 | `ContinuousLinearMap` | 存在全局范数界；底层连续 | 语义完全一致，直接公开 | 有界与连续等价 | `functional-analysis.operator.continuous-linear-map` |
| 算子范数 | 最小全局范数界 | `Norm.norm` on `ContinuousLinearMap` | 基本估计与最小界性质 | Mathlib 定义正是算子范数 | 算子空间完备性 | `functional-analysis.operator.space` |
| 向量值绝对可和 | 范数级数可和 | `Summable (fun n ↦ ‖f n‖)` | 展开即教材量词 | 无语义差异，不建谓词 | Banach 中绝对可和推出可和 | `functional-analysis.series.summable` |
| 闭线性子空间 | 线性子空间且闭 | `Submodule` 加 `IsClosed` | 线性封闭与极限封闭 | 直接公开并解释 | 商 Banach 空间 | `functional-analysis.subspace.quotient` |

## 文件与顺序

1. `Operator.lean`：解释 `ContinuousLinearMap`；证明全局界刻画及线性映射有界／连续等价。
2. `OperatorSpace.lean`：直接使用正式算子范数，证明最小界性质和算子空间完备性。
3. `BanachSeries.lean`：直接使用 `Summable`，陈述 Banach 值绝对可和推出可和。
4. `Quotient.lean`：解释闭 `Submodule` 与商范数，转正商 Banach 完备性。

不新增同构的结构、谓词、范数或级数包装。只有发现 Mathlib 与教材量词确实不同时，才另立本库
定义并记录差异。

## 共有文件与边界

Registry、顶层 import、RADAR 和 ROADMAP 状态由 Main 集成。F2/F3/F4 仍锁定；本批不提前使用
Baire、开映射、闭图、Hahn--Banach 或 Hilbert 投影理论。
