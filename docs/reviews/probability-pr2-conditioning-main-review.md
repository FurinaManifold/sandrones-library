# Main review：Pr2 条件化定义链

- reviewed commits: `ab1d81c`、`8d3de8a`、`7fed21f`、`397ff81`
- verdict: `accepted`
- reviewed at: 2026-08-26

## 验收结论

条件期望直接复用 `condExp`，正常教材分支显式保留子 σ-代数、trim σ-有限与可积条件；tower 保持
a.e. 等式。独立性批同时给出 σ-代数版本和真实消费 Pr1 `IndepFun` 的随机变量版本。过滤层采用
Mathlib 4.33 的 `Filtration` 与普通可测语义 `Adapted`，没有重造 carrier 或无理由收紧时间序。

Main 构建全部新模块通过，并逐 Entry 复验公开声明公理边界。统计 S1 审计正确区分逐参数 RN 导数与
联合可测 `Kernel.rnDeriv`，只作为后续签名依据，没有冒充已完成统计定理。

## 后续权限

Martingale 定义转 `development_open`；有界停时可选停止转 `research_open` 并在 martingale handoff 后
自动解锁。Statistics model definition 转 `development_open`，density 为自动解锁的
`research_open`；Pr3 convergence modes 可并行接口调查。
