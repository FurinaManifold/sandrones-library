# 逆道路 foundation handoff

## 分支与范围

- 分支：`codex/topology-foundations`。
- `RealLine.lean` 的实反射、区间反射及连续性归属 `topology.foundation.real-line`，只是本条 premise。
- 本 Entry 的唯一 Lean 文件是 `Path.lean`，只负责 `Path.symm`、`symm_apply` 与双重反向定律。
- 新 Entry：`topology.homotopy.path-reversal-foundation`。
- 本 review 唯一接收顺序：`1bfe5fa`, `07c8057`, `a9aa0d7`, `f5e9a71`；基础结构批次已经 Main 验收。

## 公开接口与边界

- `continuous_realReflection` 从本库 ε-开集定义直接证明。
- `UnitInterval.reflect` 是本库单位区间自映射，连续性由子空间定义证明。
- `Path.symm` 只通过本库连续复合构造；`Path.symm_symm` 是严格相等。
- 道路拼接与完整 `topology.homotopy.path-loop` 仍未完成。
- `fb66c80` 是 review tip 之后的相对开集前置工作，不属于本次接收顺序或已审核范围。

## 负责人审核与验证

- 核心模块不导入 `MathlibBridge`，负向测试应保持 Mathlib 拓扑结构不可见。
- 检查反射连续性实际使用 `|1-y-(1-x)|=|y-x|`，没有调用外部连续函数库。
- 检查两个端点方向正确：逆道路源点为原终点，目标点为原源点。

## 教材概念清单

| 概念 | 本库教材定义 | 定义展开／一手性质 | Mathlib 桥 | 首个真实使用者 | 源码 Entry |
|---|---|---|---|---|---|
| 逆道路 | `Path.symm` | `symm_apply`、`symm_symm` | 无 | `symm_symm` | `topology.homotopy.path-reversal-foundation` |

## 公开签名扫描与定义链

- 公开签名只使用已验收的本库 `Path` 和 `UnitInterval.reflect`；没有 Mathlib 专用拓扑对象、桥侧
  对象、私有后端泄漏或第 4 类例外。
- 完整聚合链为 `UnitInterval.reflect` → `continuous_unitInterval_reflect` → `Path.symm` →
  `symm_apply/symm_symm`；Entry 映射必须只把最后三个声明归入 reversal id。

## Main 共有文件建议

- Registry 登记 foundation id，但 ROADMAP 的完整道路条目继续施工中。
- 顶层 import 可继续只列 `Path`，因为它传递导入 `RealLine`。

## 下一批

下一批建立本库闭集与分段连续粘合引理，定义道路拼接，并验证拼接端点、常值道路和反向操作的
基本关系。
