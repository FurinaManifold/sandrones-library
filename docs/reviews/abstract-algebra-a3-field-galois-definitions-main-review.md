# Main review：A3.9a Galois 定义层

- branch: `codex/abstract-algebra`
- reviewed_commit: `7fd03d8`
- integrated_commit: `0490f17`
- reviewer: `main`
- verdict: `accepted`
- reviewed_at: 2026-08-25

## 验收结论

提交把基域自同构定义为既有 `FieldIsomorphismOver e e` 的缩写，避免重复结构；恒等、复合、逆、
逐点公式和五条群律形成完整的教材使用链。`FixedFieldSet` 对任意自同构族定义，并证明空族、全体
自同构、子域封闭、包含基域像和反变性。Galois 扩张精确定义为可分且正规，并使用 A3.8 已集成
刻画展开不可约多项式条件。公开签名没有泄露隐式 `Algebra`、打包 `IntermediateField` 或
Mathlib Galois 类型类，也没有提前发布固定域—子群对应。

目标模块构建通过；一个 Entry 精确映射 28 个公开声明，公理审计不超过 `propext`、
`Classical.choice`、`Quot.sound`。共享定义审计表由 Main 合并，没有要求负责人返工。

## 后续权限

- A3.9b 基本定理：`development_open`；
- A3.9c 典型有限扩张计算：`research_open`。

A3.9b 必须复用本批冻结定义，并拆出限制映射、固定域／自同构族的双向操作和对应定理的可验收
证明链；不得只包装 Mathlib 最终 Galois 对应。
