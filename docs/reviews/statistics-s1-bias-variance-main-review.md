# Statistics S1 偏差—方差 Main 验收

- subject commit：`0a0af86`
- verdict：accepted
- entry：`statistics.estimator.bias-variance`

提交完成平方损失联合可测性、一般概率测度的均方误差恒等式，以及 Markov estimator 输出律的
ENNReal 逐参数风险消费者。二阶矩条件逐参数显式保留，实积分到 `lintegral` 的桥完整验证了可积性
和非负性；没有建立 bias、loss 或 risk 的同义包装。

Main 接受本批，并将相合性开放为 `research_open`。下一阶段只冻结估计量序列／样本量 carrier、
逐参数与一致相合的量词及概率收敛接口；MLE、Fisher 信息与 Cramér--Rao 继续冻结。
