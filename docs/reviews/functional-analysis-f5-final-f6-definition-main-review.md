# Functional Analysis F5 final / F6.1-F6.2 Main 验收

- 提交：`7bf8a72`、`8b770bc`、`32a8304`
- 结论：接受并集成
- Main 集成提交：`f97db25`、`fb9d7c2`、`4f7ee94`

## F5 最终备择

最终定理真实消费有限维核、有限维余核与 `index(I-K)=0`，再分别使用单射和满射下的指数公式完成
两个方向；没有导入 Mathlib 的最终 Fredholm alternative 来替代教材证明链。Main 将早期第一窗与
最终消费者拆为 `fredholm.alternative` / `fredholm.alternative-final` 两个 Entry，消除了注册依赖环；
这是 Main 的文档与注册维护，不构成学科返工。

## F6 定义层

F6.1 用 `NormedRing`、`NormedAlgebra ℂ`、`CompleteSpace`、`NormOneClass` 解释复幺 Banach 代数，
并解释 `Unitization` 和连续线性自映射代数；F6.2 直接解释 `spectrum`、`resolventSet`、`resolvent`
与 `spectralRadius`。两批均没有建立平行 carrier，且明确 `Ring.inverse` 在不可逆点作为总函数的约定。
这属于合规的 Mathlib 复用与教材解释，不是“概念挂靠后跳过定义”。

定向构建、540 条 Entry 审计与差异检查通过，公开接口未引入非标准公理。

## 后续权限

- F5.7 Fredholm 紧扰动／小扰动稳定性：`development_open`，允许拆成复合、紧扰动、小扰动三批；
- F6.3 复 Banach 代数谱非空、紧致与谱半径公式：`development_open`；
- F6.4 紧算子非零谱：`research_open`，F6.3 handoff 后自动开发；
- F6.5 紧自伴谱定理：`research_open`，可先调查 Mathlib carrier 与有限维逼近依赖。

定义层以后仍须写教材解释，但允许直接消费 Mathlib 的成熟谱论定理；只有“未解释概念语义与假设”
才是不合规，不要求重复证明 Mathlib 已完成的基础设施。
