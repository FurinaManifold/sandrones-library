# 抽象代数 A2 中国剩余定理交接

## 接收窗口

- 分支 `codex/abstract-algebra`；源码为 `SandronesLibrary/AbstractAlgebra/RingCRT.lean`。
- 开工基线为 Main `f8b1f3a`，通过 merge 同步并确认其为当前分支祖先。
- Entry 为 `abstract-algebra.ring.crt`，课程文档位于 `docs/entries/abstract-algebra/ring/crt.md`。
- 本批只包含 A2.8；局部化属于下一批 A2.9。

## 教材定义层六列表

| 概念 | 本库定义 | 展开／一手性质 | Mathlib 桥／后端 | 首个使用者 | Entry |
|---|---|---|---|---|---|
| 互素理想 | `ComaximalIdealSets` | `comaximalIdealSets_iff_exists_add_eq_one` | 无公开桥 | 二元满射 | `abstract-algebra.ring.crt` |
| 理想交 | `finiteIdealIntersection` | `finiteIdealIntersection_is_ideal` | 无 | 有限规范映射核 | 同上 |
| 两两互素族 | `PairwiseComaximalIdealSets` | 逐对调用二元互素定义 | `Ideal.IsCoprime` 仅证明体 | 有限满射 | 同上 |
| CRT 规范映射 | `chineseRemainderMap`、`finiteChineseRemainderMap` | 环同态与核判据 | 有限满射局部调用 `Ideal.exists_forall_sub_mem_ideal` | CRT 同构 | 同上 |
| CRT 同构 | `chineseRemainderIsomorphism`、`finiteChineseRemainderIsomorphism` | 代表元计算公式 | 无公开桥 | 本批终点 | 同上 |

## 公开签名审计

公开课程接口使用本库 `TwoSidedIdealSet`、`quotientRingSet`、`RingHomomorphism` 与
`RingIsomorphism`。Mathlib `Ideal` 只在有限满射证明体中临时构造；没有 `Module`、`Submodule`
或 Mathlib 商理想结构泄漏。有限性写成 `[Finite ι]`，判定相等性只由证明体中的 `classical` 提供。

## Main 集成清单

- 顶层 import：加入 `SandronesLibrary.AbstractAlgebra.RingCRT`。
- Registry：新增 `abstract-algebra.ring.crt`，premises 使用 ideal、quotient、iso-theorems。
- ROADMAP：勾选 A2.8；A2.9 局部化仍保持未完成。
- RADAR：登记 `Ideal.exists_forall_sub_mem_ideal` 为有限满射的局部证明后端。
- 重新生成 Entry 索引及公理字段，并由 Main 执行全库 audit/build。

## 诚实边界

本批证明二元及任意有限指标族的 CRT。没有声明无限族满射，也没有把互素理想的交等于积作为
本批主结论；分式域与一般乘法集局部化均不在本批范围。

## 学科负责人验证

- `/tmp/sandrones-library/AbstractAlgebraRingCRT.lean` 按框架法完成：二元与有限族上层接口均先
  组装，再逐项消除下层 `sorry`；最终临时文件编译无输出。
- `lake build SandronesLibrary.AbstractAlgebra.RingCRT`：8709 jobs 通过且无 warning。
- 临时聚合文件同时 `#check` 定义、核判据、二元/有限同构及代表元公式。
- `#print axioms` 两个主同构均只含 `propext`、`Classical.choice`、`Quot.sound`。
- 源码禁用项扫描无证明占位、待办标记或模论接口；文档中的这些词仅用于披露验收边界。
- `git diff --check` 通过；全库 build 留给 Main 集成阶段。
