# Main review：F4.9 均值遍历分解

- reviewed commit: `50a375f`
- verdict: `accepted`
- reviewed at: 2026-08-26

## 验收结论

本批从幂一致有界、Cesaro 平均和收敛域开始，完整证明收敛域等于固定点空间与
`closure(range(T-1))` 的内部直和，并给出“存在弱收敛子列当且仅当平均范数收敛”的判据。
定义层复用 Mathlib `birkhoffAverage`、`LinearMap.eqLocus`、`Submodule.topologicalClosure` 和
`StrongDual`；Entry 对这些挂靠接口均有教材语义解释，没有重复造弱拓扑或平均算子理论。

Main 直接重建源码通过，新增文件无 `sorry`、`admit`、`native_decide` 或新增 `axiom`，且差分闭包、
望远镜恒等式、对偶分离点与闭直和证明链均在正式消费者中使用。

## 后续权限

F4.9 现开放两个可并行批次：

1. `mean-ergodic.reflexive`：由自反性和弱紧致工具证明整个空间上的平均收敛；
2. `mean-ergodic.projection`：构造平均极限投影，并证明其值域、核以及 `ST = TS = S² = S`。

两批必须消费本批公开接口，不应复制直和分解证明。更后的遍历测度与点态遍历定理仍不在本轮权限内。
