# F6.6 谱邻域全纯输入 Main 验收

- 学科提交：`efda4de`
- 学科签名修正：`25e8950`
- Main 接收提交：`f1cc927`
- Entry：`functional-analysis.functional-calculus.holomorphic-neighborhood`
- Verdict：`accepted_main_docs`

## 数学与接口裁决

`HolomorphicOnNhdSpectrum a f` 在显式 `[CompleteSpace A]` 下精确保留教材量词：存在包含
`spectrum ℂ a` 的开集，且 `f` 在该开集上复可微。初始提交只要求复赋范代数；跟进提交
`25e8950` 已按 Main 冻结签名将 carrier 收紧为一般复 Banach 代数。

两个输入的见证开集可能不同；`exists_inter` 先取交集，再证明加法与乘法封闭，因此没有静默把
不同见证当成同一个集合。常函数、恒等函数和复多项式给出了真实消费者。

本批没有定义 Dunford 积分、cycle、winding、germ quotient、函数演算同态或谱映射，也没有用
Mathlib 的连续 `cfc` 冒充全纯函数演算。完整 F6.6 仍为 `research_open`，复积分 cycle 的载体仍归
复分析路线所有。

## Main 规范化

Main 补入顶层导入、Registry、ROADMAP 完成标记和 Examples 巡视项。这些属于共享状态维护，不构成
学科返工。最终验收以 Main 上的公理审计、Registry 审计、整库构建和干净工作树为准。
