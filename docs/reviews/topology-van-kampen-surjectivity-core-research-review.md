# Main review：VK2 满射核心研究更新

- reviewed_commit: `c4ed557`
- verdict: `research_update_needs_correction`
- reviewed_at: 2026-08-25

有限 corrected-loop word 原型可独立编译，`correctedLoopWord_eq_concat` 已消除任意有限分段的迭代
抵消缺口。新的 surjectivity-core 原型也已建立推送、规范映射、基点连接道路、分段环路，以及从
道路连通性构造连接道路的主体接口，研究方向正确。

但 `c4ed557` 中“新原型已无占位编译”的事实声明不成立。Main 现场运行
`lake env lean /tmp/sandrones-library/VanKampenSurjectivityCorePrototype.lean`，在
`BinaryOpenCoverSubdivision.canonicalMap_of_segmentPieceLoop` 的
`rw [binaryVanKampenCanonicalMap, Monoid.PushoutI.lift_of]` 处失败：目标仍依赖
`D.label i`，改写尝试把它泛化为任意 `Bool` 后类型不再成立。应先固定或分情况处理标签，再计算
对应 `PushoutI.of` 分支。

本提交只有研究文档且包含错误验证声明，因此暂不集成。VK2 权限不回退，继续保持
`development_open`；负责人可直接修复原型并迁入正式模块，完成有限词、规范映射像和满射定理后
再提交。无需等待新的 Main 解冻通知。

## `80f0bdf` 复验补充

后续文档提交 `80f0bdf` 新增 `exists_basedConnectors` 的构造说明，但没有修正上述整文件编译失败，
也没有提交正式 Lean 模块。该连接器定理主体已经写出，按首末点、相邻标签相同和标签切换三类
顶点选路的数学方案合理；然而当前同一临时文件仍在后续
`canonicalMap_of_segmentPieceLoop` 失败，所以不能把它描述成整个原型“无占位编译通过”。

`80f0bdf` 同样不集成。VK2 继续 `development_open`，负责人应直接修复标签依赖的改写并迁入正式
模块，而不是继续追加只记录临时原型进展的 maintenance 提交。
