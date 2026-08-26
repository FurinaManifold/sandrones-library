# Pr2 条件期望塔式性质交接

- branch：`codex/probability`
- Entry：`probability.conditional-expectation.tower`
- Lean：`SandronesLibrary/Probability/ConditionalExpectationTower.lean`
- 前置：`probability.conditional-expectation.definition`

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 塔式性质 | 嵌套条件化等于直接向较粗信息条件化 | `condExp_condExp_of_le` | 本库 `conditionalExpectation_tower` | 直接复用成熟证明并保留 a.e.／trim 边界 | martingale | `probability.conditional-expectation.tower` |

本批不新建 carrier 或实例。目标模块、临时聚合、Entry 映射、公理与占位扫描通过后，可按 Main
既定顺序进入 `probability.conditional-expectation.independence`。Main 需添加顶层 import、Registry、
ROADMAP 和公理元数据；可选停止仍冻结。
