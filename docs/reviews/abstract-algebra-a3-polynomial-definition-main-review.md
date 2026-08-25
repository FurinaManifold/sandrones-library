# Main review: Abstract algebra A3.1 polynomial definition

- reviewed commit: `ad87445`
- reviewed against main: `fe232a4`
- verdict: `needs_changes`
- reviewed_at: 2026-08-25

## 已通过范围

Main 认可 `PolynomialSequence` 的有限支撑系数序列载体、系数外延性、双向 Mathlib 转换、环运算
的系数公式、常数与不定元系数、因式定理以及整环性。新旧模块联合定向构建通过（8709 jobs），
提交无证明占位且 `git diff --check` 通过。

## 必须返工的数学定义链

### R1 — `degree` 尚未成为教材定义

公开 `degree` 只展开到私有 `transportedDegree`，后者直接读取
`(toMathlibPolynomial p).degree`。除 `degree_zero` 外，没有用本库 `coefficient` 和有限支撑说明
“最高非零项”的公开性质，也没有具名 Mathlib 桥。因此当前源码不足以支持文档中“次数是最高
非零项指标”的陈述。

请二选一完成真实定义层：

1. 直接由有限支撑集合的最大指标定义教材次数；或
2. 若保留后端承载，至少提供只用 `coefficient` 陈述、足以唯一刻画次数的展开性质，并把
   Mathlib 等式隔离为具名桥。

最低应覆盖零多项式边界、次数以上系数为零，以及非零有限次数处系数非零／最高性。

### R2 — `evaluate` 尚未公开有限和语义

公开 `evaluate` 同样只展开到 Mathlib `Polynomial.eval`。现有 `evaluate_zero/add/mul` 是运算律，
不能代替教材定义“有限支撑系数乘幂之和”，也没有 `evaluate_eq_...sum` 或具名 Mathlib 桥。

请用本库系数和有限支撑给出求值定义，或给出公开的有限和展开定理并建立方向清楚的具名后端桥。
随后让 `IsRoot`、求值同态和因式定理真实经过该定义链，不能仅靠定义归约静默回到 Mathlib。

## 复验清单

- `degree`：本库定义／展开、一手最高项性质、具名桥、真实下游。
- `evaluate`：有限和展开、具名桥、`IsRoot` 与因式定理下游。
- Entry 映射继续覆盖上述定义、展开、桥和使用者。
- 重跑 `PolynomialDefinition`、`Poly` 联合构建、占位扫描和 `git diff --check`。

其余文档格式、Registry、顶层 import 与 ROADMAP 更新均由 Main 接收后处理，不是返工项。

## 学科负责人处理记录

- R1 — resolved：新增 `degree_eq_mathlib_degree`，并以本库 `coefficient` 给出
  `degree_eq_bot_iff_coefficients_zero`、`coefficient_eq_zero_of_degree_lt`、
  `coefficient_ne_zero_of_degree_eq`、`degree_eq_nat_iff` 和 `degree_index_unique`。
- R2 — resolved：新增 `coefficientSupport`、支撑成员判据、`evaluate_eq_coefficientSupport_sum`、
  `evaluate_eq_mathlib_eval`、根的有限和判据和具名根桥；因式定理显式经过
  `isRoot_iff_mathlib_isRoot`。
- 验证：临时两个下层框架均无输出编译通过；正式模块与旧兼容模块联合构建、聚合 `#check`、
  公理检查、占位扫描和 `git diff --check` 在返工提交前重跑。
