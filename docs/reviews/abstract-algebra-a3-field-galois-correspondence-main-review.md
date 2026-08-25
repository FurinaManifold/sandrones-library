# Main review：A3.9b 有限 Galois 基本对应

- reviewed_commit: `0955c98`
- integrated_commit: `b7c7de8`
- verdict: `accepted_main_docs`
- reviewed_at: 2026-08-25

本批沿 A3.9a 的显式自同构、固定域和 Galois 定义，建立 fixing/fixed 反变连接、显式中间域载体、
真实 restriction 及恒等／复合／逆相容，再用 fixing 群阶—相对次数、同次数包含消去和有限集合
基数消去证明中间域与子群两个恢复方向。公开签名保持本库 `FieldEmbedding`、
`FieldAutomorphismOver`、`IntermediateFieldSet` 与 `SubgroupSet`。

Main 复验确认源码没有调用四个被禁用的最终对应接口；Mathlib 固定点、打包中间域、`AlgEquiv` 和
有限维工具只用于私有换基和基数后端。单文件与目标模块构建通过（8719 jobs），文档边界与实际
陈述一致。

后续权限：A3.9c 一般推论保持 `research_open`，待本批进入 Main 后提升为
`development_open`；具体二次扩张、有限域和低次多项式计算已转交 Examples E6.12，不再由抽象
代数负责人开发。
