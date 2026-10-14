---
id: examples.settheory.ordinal-arithmetic
kind: example
state: verified
title: 有限序数与 ω 的加乘幂、Cantor 正规形小例
summary: 有限序数加乘幂的真计算、ω 的加乘幂恒等式、加法与乘法不交换的反例、序数加法左消去成立而右消去失败的实测，以及 ω+1 的 Cantor 正规形计算与显式求值
premises: [settheory.ordinal.addition, settheory.ordinal.multiplication, settheory.ordinal.exponentiation, settheory.ordinal.cantor-normal-form, settheory.ordinal.power-bridge]
mathlib: [Ordinal.mul_two, Ordinal.opow_succ, Ordinal.opow_one, Ordinal.add_omega0, Ordinal.natCast_lt_omega0, Ordinal.one_lt_omega0, add_left_cancel, mul_left_cancel₀, one_mul, Ordinal.CNF.opow_mul_add, Ordinal.CNF.of_lt, Order.lt_succ, Order.succ_eq_add_one]
provenance:
  source_type: book
  ref: "jech-set-theory-2003"
---

# 动机

`settheory.ordinal.addition`、`settheory.ordinal.multiplication`、`settheory.ordinal.exponentiation`
分别用「良序拼接」「字典序积」「超限递归」定义了序数加、乘、幂，`settheory.ordinal.power-bridge`
把本库幂接到 mathlib 序数幂，`settheory.ordinal.cantor-normal-form` 则断言「正规形求值还原原序数」。
这些定义与定理必须在小序数上可核对：有限序数的加乘幂能不能真算、`ω` 的代数法则长什么样、
哪些自然数法则在序数上失效、Cantor 正规形到底怎么读。本 Entry 给出这组小例与两条消去律的实测。

# 直觉

- 有限序数就是自然数，加乘幂与自然数一致：`3 + 4 = 7`、`2 * 3 = 6`、`2 ^ 3 = 8`。
- `ω + ω` 是两个 `ω` 首尾相接，正是 `ω * 2`；而 `2 * ω` 是「两份副本」被 `ω` 吞掉，仍是 `ω`。
- 幂是乘法的迭代：`ω ^ 0 = 1`、`ω ^ 1 = ω`、`ω ^ 2 = ω * ω`。
- 加法**左消去**成立：公共左加数可以直接删掉。但公共**右加数**不能删：`1 + ω = 2 + ω = ω`，
  可 `1 ≠ 2`——因为接在 `ω` 前面的有限部分被无限尾巴吸收了。
- Cantor 正规形把序数写成 `ω^{e₁}·c₁ + ω^{e₂}·c₂ + …`（指数递减、系数为正有限数）；
  `ω + 1` 的展开是 `ω^1 * 1 + ω^0 * 1`，对应列表 `[(1,1), (0,1)]`。

# 陈述（自然语言）

1. 有限序数真计算：`3 + 4 = 7`、`2 * 3 = 6`、`2 ^ 3 = 8`。
2. `ω` 的代数法则：`ω + ω = ω * 2`、`2 * ω = ω`、`ω * 2 ≠ ω`、`ω ^ 0 = 1`、`ω ^ 1 = ω`、`ω ^ 2 = ω * ω`。
3. **反例（乘法不交换）**：`2 * ω = ω`，而 `ω * 2 ≠ ω`，所以 `ω * 2 ≠ 2 * ω`。
4. **反例（加法不交换）**：`1 + ω = ω`，而 `ω + 1` 是 `ω` 的后继、不等于 `ω`。
5. **正例（加法左消去成立）**：`c + a = c + b → a = b`。
6. **反例（加法右消去失败）**：前件 `1 + ω = 2 + ω` 成立（两边都等于 `ω`），
   后件 `1 = 2` 为假。所以公共右加数不能消去。
7. **正例（乘法左消去成立，左因子非零）**：`c ≠ 0` 时 `c * a = c * b → a = b`。
8. **反例（乘法右消去失败）**：前件 `2 * ω = 1 * ω` 成立（两边都等于 `ω`），后件 `2 = 1` 为假。
9. Cantor 正规形小例：底取 `ω` 时，`ω` 的正规形是 `[(1,1)]`，`ω + 1` 的正规形是 `[(1,1),(0,1)]`；
   把后者代入 foldr 用本库加乘幂逐项求值，结果精确还原 `ω + 1`。

# 陈述（Lean 对照）

```lean
-- 有限序数真计算
theorem finite_add : ordinalAdd (3 : Ordinal) 4 = 7
theorem finite_mul : ordinalMul (2 : Ordinal) 3 = 6
theorem finite_pow : ordinalPow (2 : Ordinal) 3 = 8

-- ω 的加乘幂
theorem omega_add_omega_eq_omega_mul_two : ordinalAdd ω ω = ordinalMul ω 2
theorem two_mul_omega_eq_omega : ordinalMul 2 ω = ω
theorem omega_mul_two_ne_omega : ordinalMul ω 2 ≠ ω
theorem omega_pow_zero : ordinalPow ω 0 = 1
theorem omega_pow_one : ordinalPow ω 1 = ω
theorem omega_pow_two_eq_omega_mul_omega : ordinalPow ω 2 = ordinalMul ω ω

-- 反例：不交换
theorem omega_mul_two_ne_two_mul_omega : ordinalMul ω 2 ≠ ordinalMul 2 ω
theorem one_add_omega_ne_omega_add_one : ordinalAdd 1 ω ≠ ordinalAdd ω 1

-- 消去律实测
theorem addition_left_cancellation (h : ordinalAdd c a = ordinalAdd c b) : a = b
theorem addition_right_cancellation_fails :
    ordinalAdd 1 ω = ordinalAdd 2 ω ∧ (1 : Ordinal) ≠ 2
theorem multiplication_left_cancellation (hc : c ≠ 0)
    (h : ordinalMul c a = ordinalMul c b) : a = b
theorem multiplication_right_cancellation_fails :
    ordinalMul 2 ω = ordinalMul 1 ω ∧ (2 : Ordinal) ≠ 1

-- Cantor 正规形
def omegaPlusOneOrd : Ordinal := ordinalAdd Ordinal.omega0 1
theorem omegaPlusOneOrd_eq : omegaPlusOneOrd = Ordinal.omega0 + 1
theorem cnf_omega : Ordinal.CNF ω ω = [(1, 1)]
theorem cnf_omegaPlusOne : Ordinal.CNF ω omegaPlusOneOrd = [(1, 1), (0, 1)]
theorem cnf_foldr_eval :
    ([(1, 1), (0, 1)]).foldr (fun p r => ordinalAdd (ordinalMul (ordinalPow ω p.1) p.2) r) 0
      = ordinalAdd ω 1
theorem cantorNormalForm_reconstructs_omegaPlusOne :
    (Ordinal.CNF ω (ω + 1)).foldr (fun p r => ordinalAdd (ordinalMul (ordinalPow ω p.1) p.2) r) 0
      = ω + 1
```

# 思维脉络

本库的 `ordinalAdd`／`ordinalMul` 是 `def`，公开接口只有递推式；要把它们交给 mathlib 的
序数算术验证，需要一条桥。理论模块内部的 `ordinalAdd_eq_mathlib` 是私有的，所以本 Entry
在文件内**私有**地重证两条一行桥（`simp [ordinalAdd]`、`simp [ordinalMul]`），
公开签名仍然只出现本库运算——原生 `+`／`*` 不作为本 Entry 的公开接口。

有限序数部分用 `norm_num` 在序数上真算：先经私有桥把 `ordinalAdd`／`ordinalMul` 换成原生运算，
再由 `norm_num` 把 `3 + 4` 算成 `7`。`ω` 的幂用库内 `ordinalPow_zero`、桥 `ordinalPow_eq_opow`
与 `Ordinal.opow_succ`／`Ordinal.opow_one` 逐步展开，`ω ^ 2 = ω * ω` 走
`ω ^ 2 = ω ^ (succ 1) = ω ^ 1 * ω = ω * ω`。

消去律部分是本 Entry 的实测重点。序数加法**左消去成立**：把桥展开后直接用 mathlib 的
`add_left_cancel`。**右消去失败**：`1 + ω` 与 `2 + ω` 都用 `Ordinal.add_omega0` 归约到 `ω`，
而 `1 ≠ 2` 由 `norm_num` 给出。乘法同理：`mul_left_cancel₀`（左因子非零）给左消去，
右消去则由 `2 * ω = 1 * ω = ω` 与 `2 ≠ 1` 反驳。
**这与 ROADMAP 原文「左消去失败」相反**：实测结论是左消去成立、右消去失败，
本 Entry 按实测陈述（见「应用与陷阱」）。

Cantor 正规形部分先命名 `omegaPlusOneOrd = ω + 1`，用 mathlib 的
`Ordinal.CNF.opow_mul_add`（把 `b^e * x + y` 的正规形拆成 `(e,x)` 与 `y` 的正规形）
真算出 `CNF ω (ω+1) = [(1,1),(0,1)]`；再把该列表代入 foldr，用本库加乘幂显式求值得到 `ω + 1`；
最后调用库内 `cantorNormalForm_reconstructs` 在同一对象上复述一般定理。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 序数加法 | `ordinalAdd a b`（本库定义） |
| 序数乘法 | `ordinalMul a b`（本库定义） |
| 序数幂 | `ordinalPow a b`（本库定义；桥 `ordinalPow_eq_opow`） |
| `ω` | `Ordinal.omega0` |
| `ω + 1` | `omegaPlusOneOrd = ordinalAdd Ordinal.omega0 1` |
| 公共左加数可消去 | `ordinalAdd c a = ordinalAdd c b → a = b` |
| 公共右加数不可消去 | `ordinalAdd 1 ω = ordinalAdd 2 ω ∧ 1 ≠ 2` |
| 左因子非零时乘法左消去 | `c ≠ 0 → ordinalMul c a = ordinalMul c b → a = b` |
| Cantor 正规形（底 `ω`） | `Ordinal.CNF Ordinal.omega0 o : List (Ordinal × Ordinal)` |
| 正规形求值 | `List.foldr (fun p r => ordinalAdd (ordinalMul (ordinalPow b p.1) p.2) r) 0` |

# 依赖（人话版）

- `settheory.ordinal.addition`：`ordinalAdd` 及其递推式；库内 `addition_not_commutative` 是
  「加法不交换」的一般结论。
- `settheory.ordinal.multiplication`：`ordinalMul` 及其递推式；库内
  `multiplication_not_commutative` 直接给出 `2 * ω = ω` 与 `ω * 2 ≠ ω`。
- `settheory.ordinal.exponentiation`：`ordinalPow` 的零／后继／极限三分支定义。
- `settheory.ordinal.power-bridge`：公开桥 `ordinalPow_eq_opow`，本 Entry 的幂计算都经过它。
- `settheory.ordinal.cantor-normal-form`：`cantorNormalForm_reconstructs`，正规形小例的一般形式。
- mathlib 侧只用到序数算术的标准接口：`Ordinal.mul_two`、`Ordinal.opow_succ`、`Ordinal.opow_one`、
  `Ordinal.add_omega0`、`add_left_cancel`、`mul_left_cancel₀`、`Ordinal.CNF.opow_mul_add` 等。

# 应用与陷阱

- **应用**：消去律方向是序数算术最容易被想当然的地方；本 Entry 把「左成立、右失败」钉成
  两条 Lean 定理，后续任何要用消去律的推理都应先查方向。Cantor 正规形小例则是
  `ε₀`、Goodstein 与序数记号系统的入口。
- **陷阱一（与 ROADMAP 原文的出入）**：ROADMAP E1.7 原文写「左消去失败」，实测相反——
  **左消去成立**（`addition_left_cancellation`），**右消去失败**（`addition_right_cancellation_fails`）。
  本 Entry 按实测陈述，并把这个出入登记在交付报告中；不制造伪反例。
- **陷阱二**：右消去失败只发生在无限序数上。有限序数上 `a + n = b + n ↔ a = b` 是成立的
  （mathlib 的 `Ordinal.add_right_cancel` 正是这个有限版本），所以不能把本 Entry 的反例
  误读成「序数加法右消去处处失败」。
- **陷阱三**：`2 * ω = ω` 与 `ω * 2 ≠ ω` 说明乘法两侧的单调性不同；`ω ^ 2 = ω * ω` 是
  「自乘」而不是「两份副本相加」，别把 `ω ^ 2` 与 `ω * 2` 混同（后者等于 `ω + ω`）。
- **陷阱四**：本库的 `ordinalAdd`／`ordinalMul` 是 `def`，`rw` 不会自动展开成 mathlib 原生
  `+`／`*`；本 Entry 用文件内私有桥显式完成这一步，公开接口不暴露原生运算。
