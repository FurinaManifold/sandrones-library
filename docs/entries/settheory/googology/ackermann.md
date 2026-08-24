---
id: settheory.googology.ackermann
kind: definition
state: verified
title: "Ackermann 函数：定义与计算方程"
premises: ["settheory.googology.primitive-recursion"]
mathlib: ["Nat.ack"]
provenance: {source_type: book, ref: "Herbert Enderton, A Mathematical Introduction to Logic, Section 3.4"}
---

# 动机

单层递推只把上一项交给固定更新规则。Ackermann–Péter 函数展示更深的嵌套：同一等级先完成一次递归，其结果再成为较低等级的新输入。本条只建立可执行定义及其计算方程。

# 直觉

把第一个参数看成运算等级，第二个参数看成该等级的进度。最深分支先把进度从 `n+1` 降到 `n`，算出一个新输入；随后等级从 `m+1` 降到 `m`，因此嵌套虽猛烈却仍有下降方向。

# 陈述（自然语言）

定义 `A(0,n)=n+1`，`A(m+1,0)=A(m,1)`，以及 `A(m+1,n+1)=A(m,A(m+1,n))`。本条证明这三条就是所定义函数的计算方程；没有在当前批次证明它不属于原始递归函数类。

# 陈述（Lean 对照）

`ackermann` 是本库按三种参数形状定义的公开函数。`ackermann_equations` 用一个三重合取逐字给出三条方程，证明 `simp [ackermann]` 只展开递归定义。`Nat.ack` 作为 Mathlib 中相关实现登记，不是公开定理的证明捷径。

# 思维脉络（thinking trace）

先选定 Ackermann–Péter 的版本，避免不同教材初值偏移；再把边界情形与双重后继情形分开；最后让 Lean 的终止检查验证嵌套调用沿参数结构下降。证明计算式时无需增长理论，因为它们就是定义的展开规则。

# 自然语言 ↔ Lean 映射

`A(m,n)` 对应 `ackermann m n`；“零等级”对应模式 `| 0, n`；“正等级的零输入”对应 `| m + 1, 0`；嵌套方程对应第三个模式。`simp` 是定义化简工具，不代表已证明渐近支配或非原始递归性。

# 依赖（人话版）

只需要自然数结构递归和嵌套递归的良构性。理解上承接原始递归条目，以便比较调用形状；但当前 Lean 文件尚未定义完整的原始递归函数类，也没有复杂度层级或支配定理。

# 应用与陷阱

三条方程可用于计算小参数和研究增长层级。后续目标才是编码原始递归函数、证明统一支配界，再推出 Ackermann 非原始递归。现在不能把这一经典数学事实登记为已形式化结论。非原始递归也不等于不可计算；每个具体输入仍得到有限自然数。
