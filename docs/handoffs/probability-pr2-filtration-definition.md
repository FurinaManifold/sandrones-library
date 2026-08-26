# Pr2 过滤与适应性定义层交接

## 批次

- Entry：`probability.filtration.definition`。
- Lean：`SandronesLibrary/Probability/Filtration.lean`。
- 文档：`docs/entries/probability/filtration/definition.md`。
- staging：`codex/probability`；只使用唯一负责人 worktree。

## 概念与承载

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 过滤 | 单调增加的环境子 σ-代数族 | `MeasureTheory.Filtration` | 本库 `filtration_mono`、`filtration_le` | 直接复用 carrier，不造平行结构 | `adapted_measurable_later` | `probability.filtration.definition` |
| 适应过程 | `X i` 关于 `𝓕 i` 可测 | `MeasureTheory.Adapted` | 定义性 iff、过去对未来可测、环境可测 | 使用 Mathlib 4.33 普通可测语义 | `adapted_measurable_later` | `probability.filtration.definition` |

没有新增 filtration、process 或 adapted carrier，也没有新增 global instance。定义层只要求
`Preorder ι`，没有收紧为线性序。

## 版本边界

Mathlib 4.33 的 `Adapted` 是普通可测性；旧的强可测版本现名 `StronglyAdapted`。自然过滤需要
额外可度量 Borel／强可测条件，右连续化和停时也属于后续批次，均未泄漏进当前公开签名。

## Main 共有文件建议

- 顶层 import `SandronesLibrary.Probability.Filtration`。
- Registry 登记本 Entry，并将 ROADMAP 对应项转 verified。
- Martingale 定义可在条件期望和本接口都稳定后开放。

## 验证与协作

- 模块级构建和临时聚合 `#check` 通过；代表性定理公理只有 `propext`、`Quot.sound`，没有
  额外非经典公理。
- 正式代码由负责人写入唯一概率论 worktree；一个只读子 Agent 只负责 Mathlib API 调研，未创建
  或修改任何 worktree／文件。
- 已同步本地权威 Main `455fe35`；远端引用异常同条件期望 handoff 所述，留给 Main 核查。
