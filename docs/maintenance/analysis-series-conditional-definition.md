# 分析维护说明：条件收敛定义

本批定义 `SeriesConditionallyConvergent f := SeriesConvergent f ∧
¬ SeriesAbsolutelyConvergent f`。这里的收敛固定自然顺序，不能用 Mathlib 的无条件
`Summable` 代替。

影响等级为 M1。两个真实使用者分别投影出自然顺序收敛和非绝对收敛。既有交错级数与 Riemann
重排定理接口保持不变；本轮不声称已经构造具体条件收敛例子。
