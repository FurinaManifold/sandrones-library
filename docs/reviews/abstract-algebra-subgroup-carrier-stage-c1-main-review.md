# Main review：抽象代数子群载体 Stage C1

- branch: `codex/abstract-algebra-c1`
- reviewed_commit: `fec8561`
- integrated_commit: `61ec692`
- reviewer: `main`
- verdict: `accepted`
- reviewed_at: 2026-08-26

## 验收结论

C1 完成了 Galois fixing 子群的证明所有权倒置。`fixingAutomorphismSubgroup` 直接构造 Mathlib
`Subgroup`；子群对齐、subtype 等价、有限基数比较、有限性和严格恢复的私有核心全部以正式子群为
输入。正式基数与恢复 theorem 直接消费这些核心，旧 `Set + SubgroupSet` theorem 只在最外层通过
carrier 桥包装。

所有公开声明名、签名和 Entry 归属保持不变，四个旧集合接口继续作为 compatibility API；
`FieldGaloisConsequences` 与 `FieldGaloisConsequencesRestriction` 仍只消费正式恢复接口。没有修改
`Group.lean`，没有添加 deprecation、删除、改名或迁入 C2/C3 代码。

Main 在完整缓存主工作树上构建目标模块和两个真实下游，公开旧／新接口聚合 `#check` 全部通过；公理
仍只含 `propext`、`Classical.choice`、`Quot.sound`。C2 所需 compatibility 文档说明已随 C1 完成，
Main 决定不添加 deprecation；C3 默认不开放并继续保留薄 wrapper。
