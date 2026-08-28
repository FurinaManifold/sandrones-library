# Statistics S1 估计量定义 Main 验收

- subject commit：`8a793f9`
- verdict：accepted
- entry：`statistics.estimator.definition`

本批以 `Kernel` 与 `IsMarkovKernel` 承载随机化估计量，以 `Kernel.deterministic` 连接确定性可测
估计量，并复用 Mathlib 的平均风险、Bayes 风险与 Bayes 估计量接口。源码和条目均明确解释了这些
接口的教材含义，没有把普通 kernel 当作概率决策规则，也没有重复定义同义 carrier。

正式范围止于定义链、输出分布、风险展开和确定性桥；没有越级声称 Bayes 最优解存在，也没有提前
开发 MLE、Fisher 信息或 Cramér--Rao。Main 接受本批，并把偏差—方差接口调查开放为
`research_open`。
