# 分析维护说明：收敛列存在性定义

`SequenceConvergesTo u l` 指定极限值，但教材还频繁使用“不指定极限，只说数列收敛”。本批定义
`SequenceConvergent u := ∃ l, SequenceConvergesTo u l`，并以
`sequenceConvergent_iff_exists_tendsto` 桥接存在 Mathlib 滤子极限。

影响等级为 M1。真实使用者 `sequenceConvergent_bounded` 证明收敛列值域有上下界。既有
`Tendsto` 定理保持不变；新定义是普通 `Prop`，不增加实例、notation 或 simp 属性。
