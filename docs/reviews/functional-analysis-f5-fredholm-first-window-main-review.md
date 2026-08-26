# Main review：F5.6 Fredholm 备择第一开发窗

- reviewed commits: `08613b6`、`d5fc0bb`
- verdict: `accepted`
- reviewed at: 2026-08-26

## 验收结论

本批直接复用 Mathlib `IsCompactOperator`、弱星闭单位球与本库 `dualOperator`，没有建立平行的
紧算子或对偶算子 carrier。Schauder 对偶紧性通过弱星紧球、原算子单位球像有限网和一致范数控制
完整组装，没有调用 Mathlib 最终 Fredholm alternative。

`I-K` 部分先在核上把 `K` 识别为紧恒等算子，得到有限维核；再在有限维核的闭补空间上用紧性反证
建立反 Lipschitz 下界，从而得到闭值域。公开接口只交付对偶紧性、`I-K` 的有限维核和闭值域，没有
冒进到余核、指数零或单射／满射备择。

Main 重建两个目标模块，8726 jobs 通过；新增源码无 `sorry`、`admit`、`sorryAx`、`native_decide`
或新增 `axiom`。五个公开声明的公理边界保持为 `propext`、`Classical.choice`、`Quot.sound`。

## 后续权限

第一窗接口通过。F5.6 第二窗开放余核有限维与 `index (I-K)=0`，要求沿 Schauder 对偶紧性和现有
闭值域链推进。最终单射／满射等价仍冻结，不得直接包装 Mathlib 最终 package。
