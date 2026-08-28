# F6.6 全纯函数演算概念冻结 Main 验收

- subject commit：`82dab42`
- verdict：accepted with narrow development window

调查正确区分了一般复 Banach 代数的谱邻域全纯演算与 C*-代数连续函数演算；`cfc` 不能作为本条
后端。当前 Mathlib 没有同时承载有限 cycle、避谱、绕数和选择无关性的成熟 Dunford package，因而
不得直接把完整 F6.6 标为开发开放。

Main 将首个子窗拆为独立 Entry
`functional-analysis.functional-calculus.holomorphic-neighborhood`，只定义谱邻域全纯谓词并证明
见证缩小／交集、常数、恒等、多项式和基本代数闭性。不得定义 `f(a)` 或建立 germ quotient。

有限 cycle、winding 条件与 Banach 值路径积分的通用 carrier 归复分析基础设施所有；泛函分析作为
下游消费者，不得重复定义。完整 Dunford 定义、乘法、谱映射、复合和谱投影继续各自受门控。
