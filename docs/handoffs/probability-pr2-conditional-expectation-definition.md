# Pr2 条件期望定义层交接

## 批次

- Entry：`probability.conditional-expectation.definition`。
- Lean：`SandronesLibrary/Probability/ConditionalExpectation.lean`。
- 文档：`docs/entries/probability/conditional-expectation/definition.md`。
- staging：`codex/probability`；只使用唯一负责人 worktree。

## 概念与承载

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 条件期望 | 子 σ-代数可测且保持其可测集合上的积分 | `MeasureTheory.condExp` | 强可测、可积、集合积分、a.e. 唯一性 | 直接复用 carrier；本库给教材命名桥 | `conditionalExpectation_setIntegral` | `probability.conditional-expectation.definition` |
| 全期望 | 条件期望与原变量积分相同 | 本库 `expectation_conditionalExpectation` | 由上一行在 `univ` 上的积分刻画推出 | 不依赖不可积时积分取零的退化捷径 | tower | `probability.conditional-expectation.definition` |
| 自身可测保持 | 已由条件信息决定的变量不改变 | `condExp_of_aestronglyMeasurable'` | a.e. 等式 | 本库只固定教材方向和真实条件 | tower | `probability.conditional-expectation.definition` |
| 常量保持 | 常量的条件期望仍为常量 | `condExp_const` | 概率测度特化 | 直接复用，不造常量规则 | independence | `probability.conditional-expectation.definition` |

没有新增条件期望 carrier、存在谓词或 global instance。公开桥只整理教材语义和真实假设。

## 诚实边界

- `condExp` 的异常分支会退化为零；本批没有把总函数误写成无条件存在定理。
- 正常积分刻画保留 `m ≤ m₀`、`SigmaFinite (μ.trim hm)` 和 `Integrable X μ`。
- 自身可测结论保持 a.e. 等式。
- tower 和 independence 尚未在本批实现；按 Main 已批准顺序，本 handoff 完成后可依次开发。

## Main 共有文件建议

- 顶层 import `SandronesLibrary.Probability.ConditionalExpectation`。
- Registry 登记本 Entry，并将 ROADMAP 对应项转 verified。
- RADAR 记录 `condExp` 在子 σ-代数关系、trim σ-有限性或可积性失败时退化为零。

## 验证与协作

- 模块级构建和临时聚合 `#check` 通过；代表性定理公理只有 `propext`、`Classical.choice`、
  `Quot.sound`，没有额外非经典公理。
- 正式代码由负责人写入唯一概率论 worktree；一个只读子 Agent 只负责 Mathlib API 调研，未创建
  或修改任何 worktree／文件。
- 本批开始时同步本地权威 Main `455fe35`。GitHub `origin/main` 指向无共同祖先的旧历史且缺少当前
  ROLE／Pr1，不作为本轮多负责人协作基线；请 Main 后续核查远端引用。
