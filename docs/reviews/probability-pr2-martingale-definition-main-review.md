# Pr2 鞅定义层 Main 验收

结论：通过，学科提交 `9cbd7af` 已由 Main 集成。

本批直接复用 Mathlib 的鞅、上鞅与下鞅 carrier，准确区分 `StronglyAdapted`、几乎处处条件期望
等式和逐时刻可积性。条件期望过程给出了真实消费者，没有创建平行过程结构，也没有越界声称可选
停止或收敛定理。

后续权限：有界停时可选停止转为 `development_open`；应先冻结停时、停止过程和有界性量词，再证明
定理。Pr3 收敛模式仍只保持 `research_open`。
