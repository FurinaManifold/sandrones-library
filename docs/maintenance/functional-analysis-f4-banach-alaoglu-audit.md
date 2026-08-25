# F4.3 Banach–Alaoglu 与弱紧致性 API 审计

- 审计基线：Mathlib 当前 checkout（Main `837e93f`）
- 权限：F4.3 `research_open`
- 结论：Banach–Alaoglu 后端完整；自反性与弱紧闭单位球的双向刻画仍需单独设计

## 可直接复用

- `WeakDual 𝕜 E` 是 `StrongDual 𝕜 E` 的弱星拓扑类型同义词；二者通过
  `StrongDual.toWeakDual`／`WeakDual.toStrongDual` 在线性层互换。
- `WeakDual.isCompact_of_bounded_of_closed`：弱星有界闭集紧致。
- `WeakDual.isCompact_polar`：零邻域的极集紧致，即 Mathlib 的 Banach–Alaoglu 主接口。
- `WeakDual.metrizable_of_isCompact`：底空间可分时，弱星紧子集可度量化。
- `WeakDual.isSeqCompact_of_isBounded_of_isClosed`、`WeakDual.isSeqCompact_polar` 与
  `WeakDual.isSeqCompact_closedBall`：可分情形的序列版本。

## 尚需设计的桥

- 教材条目应以弱星闭单位球紧致为主陈述，并明确球集在 `WeakDual` 中写成
  `WeakDual.toStrongDual ⁻¹' Metric.closedBall 0 1`；不应另建弱星拓扑。
- “自反则闭单位球弱紧”需要把典范双对偶满射与 `WeakSpace`／`WeakDual` 的拓扑传输接起来。
- 逆向刻画需要从弱紧致性恢复典范嵌入的满射，不能仅靠 Banach–Alaoglu 一步得到。

## 解锁建议

先开放一个仅含 Banach–Alaoglu 本体和可分序列推论的开发窗；把“自反 iff 闭单位球弱紧”作为
后续独立窗口。两者都必须复用 `WeakDual`、`WeakSpace`，不得创建本地 weak/weak-star 拓扑。
