# 抽象代数 A3.1 多项式定义层交接

## 接收窗口

- 分支 `codex/abstract-algebra`；开工基线包含 Main `b5ceedc`。
- 新源码 `SandronesLibrary/AbstractAlgebra/PolynomialDefinition.lean`。
- 旧 `Poly.lean` 只做 Entry 标记迁移：历史包装转入 `abstract-algebra.poly.mathlib-compat`。

## 教材定义层六列表

| 概念 | 本库定义 | 展开／一手性质 | Mathlib 桥／后端 | 首个使用者 | Entry |
|---|---|---|---|---|---|
| 多项式 | `PolynomialSequence` | `coefficient`、`ext`、有限支撑字段 | 双向具名桥 | 环运算 | `abstract-algebra.poly.def` |
| 环运算 | 本库实例 | `coefficient_zero/add/neg/mul` | 私有 `transported...` | 求值、整除 | 同上 |
| 常数与不定元 | `constant`、`X` | 对应系数公式 | 具名桥内部 | 因式定理 | 同上 |
| 次数、求值、根 | `degree`、`evaluate`、`IsRoot` | 零次数、求值同态律 | 具名桥内部 | 因式定理 | 同上 |
| 整除与整环性 | A2 `DividesElement` | 因式定理、`polynomial_integralDomainAxioms` | 私有证明后端 | A3.2 | 同上 |

## Main 集成清单

- 顶层 import：加入 `SandronesLibrary.AbstractAlgebra.PolynomialDefinition`。
- Registry：`poly.def` 改映射新文件；新增 `poly.mathlib-compat` 映射旧 `Poly.lean`。
- ROADMAP：A3.1 可勾选；A3.2 仍需把首一除法、gcd 与 Bézout 迁到本库类型。
- RADAR：记录 `Polynomial`/`Finsupp` 为具名桥和私有传输后端，而非教材定义。
- 重生成索引、公理字段并执行 audit/full build。

## 验证与边界

- `/tmp` 框架先组装因式定理与整环性，最终无 `sorry` 且单文件编译无输出。
- `lake build SandronesLibrary.AbstractAlgebra.PolynomialDefinition`：8708 jobs，无 warning。
- Main R1 已补 `degree_eq_bot_iff_coefficients_zero`、次数以上系数为零、最高项非零及
  `degree_eq_nat_iff` 唯一刻画，并用 `degree_eq_mathlib_degree` 隔离后端。
- Main R2 已补 `coefficientSupport`、`evaluate_eq_coefficientSupport_sum`、根的有限和判据和
  `evaluate_eq_mathlib_eval`；因式定理已显式调用 `isRoot_iff_mathlib_isRoot`。
- 公开主结论不含 `Module`、`Submodule` 或 `Algebra`。
- A3.2–A3.4 的除法、不可约、唯一分解和重数仍未迁移；旧接口仅兼容，不算这些项目完成。
