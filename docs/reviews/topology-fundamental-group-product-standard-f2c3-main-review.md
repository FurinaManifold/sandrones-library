# Main review：T4-F2c3 积空间基本群

- branch: `codex/topology-foundations`
- reviewed_commit: `125ac90`
- integrated_commit: `9e36ba9`
- reviewer: `main`
- verdict: `accepted`
- reviewed_at: 2026-08-25

## 验收结论

本批不是给 Mathlib 最终结论换名。`fundamentalGroupProdMulEquiv` 在定义体中真实调用
`FundamentalGroupoidFunctor.prodIso` 在指定对象上的态射映射，随后用公开 apply 定理把它展开为
积道路类；逆向投影同态也有元素级公式。正反两个复合恒等式证明这两张映射确实互逆，乘法保持证明
显式处理了基本群乘法与道路拼接的反序。

结论只覆盖固定基点的二元积，没有声称无限积、一般极限、换基点自然性或 van Kampen 已完成。
学科负责人报告的模块闭包构建、六条声明映射和公理结果与 Main 复验一致；源码无占位。

## 后续权限

- T4-F2c3 已接收，不再保留集成门。
- AT1-VK1 开覆盖道路细分：`development_open`，正式实现必须复用 Mathlib `Path.subpath`，不得迁入
  RFC 中已经废弃的自建仿射子段。
- AT1-VK2 规范同态与满射、AT1-VK3 网格零同伦与单射：`research_open`。
- T4-R3 一般连续／分段 `C¹` 边界正则化：维持 `research_open`。
