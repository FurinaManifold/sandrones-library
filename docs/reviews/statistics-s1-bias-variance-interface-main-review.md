# Statistics S1 偏差—方差接口 Main 验收

- subject commit：`a8b3b4d`
- verdict：accepted
- next gate：`development_open`

审计正确沿用模型与随机化估计量的 Markov kernel carrier，在固定参数下以复合 kernel 的纤维作为
估计输出律，并显式要求 `MemLp id 2`；没有从概率性错误推出二阶矩。偏差保留为均值减目标，方差
复用 `Var`，平方损失通过 `ENNReal.ofReal` 接回既有 pointwise-risk 接口，未建立同义包装定义。

批准在 `Statistics/BiasVariance.lean` 开发一般概率测度的均方误差恒等式、平方损失联合可测性和
estimator 风险消费者。范围限于实值输出、实值目标和逐参数风险；相合性、MLE、Fisher 信息、
Cramér--Rao 与一般最优性继续冻结。
