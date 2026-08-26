# Main review：AT1-VK3b-15a--15c kernel 消去与二元 van Kampen 定理

- reviewed commits: `33b02bb`、`f72e7f4`、`af9f24f`
- verdict: `accepted`
- reviewed at: 2026-08-26

## 验收结论

15a 沿同伦方形边界传播 potential-normalized frame；15b 用首末 frame 相等消去整体 rebase；15c 再把
任意 kernel 元素表示成字母词，证明规范同态单射，并与既有满射组装 `MulEquiv`。证明方向没有把最终
同构或单射性回填为 residual-gauge 前提，三批保持真实线性消费者链。

Main 重建最终模块及全部依赖通过。公开接口复用 Mathlib `Path`、`FundamentalGroup`、
`Monoid.PushoutI` 与 `MulEquiv.ofBijective`，未建立平行 carrier。新增源码无 `sorry`、`admit`、
`native_decide` 或新增 `axiom`。Main 补齐许可证、中文模块说明和公开声明的中文教材注释；纯英文
内部实现注释列入 Main 后续文档维护，不构成学科返工理由。

## 后续权限

AT1-VK3b 已完成。T4-R3b-square 的局部原函数／dyadic grid 路线通过研究门，转为分批开发权限：

1. 先迁移通用 square-grid foundation，不改现有声明名；
2. 随后 A/B/D 可并行，C 可在最小 primitive import 维护后并行；
3. E 等待 C+D，F 等待 A+B+E；
4. 当前拓扑负责人获准在明确的 `ComplexAnalysis` namespace 内迁移 C/E/F，但每批必须独立提交。

不得恢复已被数学障碍否决的全局 relative-`C²` 同伦方形签名。
