# Main review：T4-R3b shared foundation 与 A--E

- reviewed commits: `16c9041`、`8379713`、`43e06dc`、`40067cb`、`ae521d8`、`c38b7b7`、`435c24f`
- verdict: `accepted`
- reviewed at: 2026-08-26

## 验收结论

shared square-grid 抽取保持 13 项既有签名不变。A 只增加 dyadic 对齐证书；B 对任意 indexed 开覆盖
返回满足最低深度的逐格标签；D 的 raw grid 不泄漏复分析结构。C/E 留在 `ComplexAnalysis`
namespace，分别完成 dyadic 积分组装和逐格局部原函数的外边界抵消。primitive import 维护仅纠正
依赖方向，没有修改数学接口。

Main 构建 A--E 最终闭包通过，六个本路线新 Entry 的逐声明公理审计全部通过；未恢复全局
relative-C2 同伦方形签名，也未调用旧最终同伦不变性包装新证明链。

## 后续权限

R3b-F 已为 `integration_open`：直接组合 A+B+E 并使用局部全纯原函数覆盖，交付一般连续同伦下的
PiecewiseC1 道路积分不变性。AT2-C1/C2/C3 的既定并行权限保持不变。
