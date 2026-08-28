# S1 统计模型定义层 Main 验收

结论：通过，学科提交 `f7a5d51` 已由 Main 集成。

本批以 `Kernel Θ 𝓧` 和 `[IsMarkovKernel P]` 同时承载参数可测性与逐纤维概率性，没有另造
`StatisticalModel`。事件概率、常模型与确定性模型均真实使用该 carrier，文档也明确说明任意测度族
不能无条件升级为 kernel。

后续权限：支配模型／density 转为 `development_open`，必须使用 `Kernel.rnDeriv` 保留联合可测性；
一般估计定理继续冻结。
