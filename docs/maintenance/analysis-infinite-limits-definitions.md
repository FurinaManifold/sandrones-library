# 分析维护说明：正负无穷相关函数极限

本批区分两个教材概念：`FunctionConvergesAtTopTo f L` 用 ε-M 量词表示 `x→+∞` 时趋于有限值；
`FunctionDivergesToAtTopAt f a` 用 M-δ 量词表示 `x→a` 时函数值趋于 `+∞`。二者分别双向桥接
`Tendsto f atTop (𝓝 L)` 与 `Tendsto f (𝓝[≠] a) atTop`。
两者各有一个 `..._iff` 展开定理，直接展示原始 ε-M 或 M-δ 量词，不经 Mathlib 高层接口。

随后对称补充 `FunctionConvergesAtBotTo f L` 和 `FunctionDivergesToAtBotAt f a`，分别表达
`x→-∞` 时趋于有限值及 `x→a` 时函数值趋于 `-∞`，并桥接对应的 `atBot` 接口。
负无穷的两个对称谓词也各有直接量词展开定理。

影响等级为 M1。既有 Mathlib 接口和定理签名保持不变。四个定义都有真实教材使用者：正负无穷远
有限极限唯一，以及正负无穷发散分别推出每个下界／上界最终成立。本轮不处理单侧极限。
