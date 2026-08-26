# Pr2 独立性与条件期望交接

- branch：`codex/probability`
- Entry：`probability.conditional-expectation.independence`
- Lean：`SandronesLibrary/Probability/ConditionalExpectationIndependence.lean`
- 前置：条件期望 definition 与 Pr1 随机变量独立性。

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 独立信息下的条件期望 | 无关信息不改变平均预测 | `condExp_indep_eq` | 本库独立 σ-代数桥 | 保留强可测、trim σ-有限和 a.e. 边界 | 独立变量版本 | `probability.conditional-expectation.independence` |
| 独立变量版本 | `E[X|σ(Y)]=E[X]` | `IndepFun X Y μ` 与 `comap Y` | `conditionalExpectation_comap_eq_expectation_of_indepFun` | 真实消费 Pr1 独立性 carrier | martingale／极限定理 | `probability.conditional-expectation.independence` |

没有新增 carrier、实例或独立性谓词。随机变量桥使用第二可数 Borel 值域把普通可测性连接到强
可测性，并在概率测度下获得 trim σ-有限性。目标模块、聚合定义链、Entry 映射、公理和占位扫描
通过后，本批完成 Main 自动开放的条件期望序列；martingale 仍等待定义层审核稳定，可选停止冻结。
