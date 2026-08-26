# Main review：F4.9 均值遍历消费者

- reviewed commits: `ca8ddf7`、`2cd73fd`
- verdict: `accepted`
- reviewed at: 2026-08-26

## 验收结论

自反消费者用 Eberlein--Šmulian 为有界 Cesàro 轨道抽取弱收敛子列，再调用已冻结的 decomposition
判据得到处处范数收敛，没有重证分解。投影消费者从逐点极限组装连续线性算子，证明固定点性质、
交换性、幂等性和 `ST=TS=S²=S`；陈述始终是逐点范数收敛，没有冒进到算子范数收敛。

Main 目标构建与逐声明公理审计通过。F4.9 因此完成。负责人当前已提交但尚无 Entry/handoff 的
Fredholm 余核文件，以及未跟踪的指数草稿，均不属于本次验收；待第二窗形成完整独立 handoff 后审核。

## 后续权限

F5.6 第二窗权限保持：余核有限维和指数零须作为完整可复验批次交付；最终备择仍按既定自动门推进。
F6.1/F6.2 与 F5.7 的并行权限保持不变。
