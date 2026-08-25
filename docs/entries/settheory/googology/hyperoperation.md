---
id: settheory.googology.hyperoperation
kind: definition
state: verified
title: "超运算：把重复运算本身逐级迭代"
premises: ["settheory.googology.primitive-recursion"]
mathlib: ["Nat.hyperoperation"]
provenance: {source_type: book, ref: "pohlers-proof-theory-1989"}
---

# 动机

加法是重复后继，乘法是重复加法，幂是重复乘法。与其逐个发明新符号，不如把“重复前一级运算”本身做成统一的自然数等级，这就是超运算。

# 直觉

等级像一架梯子：`H₀` 做后继，`H₁` 做加法，`H₂` 做乘法，`H₃` 做幂。计算 `H_(r+1)(a,b+1)` 时，先算同等级的前一步，再把结果交给低一级 `H_r`。

# 陈述（自然语言）

本库规定 `H₀(a,b)=b+1`，并用 `H_(r+1)(a,b+1)=H_r(a,H_(r+1)(a,b))` 递推。零输入按等级取不同初值：加法层为 `a`，乘法层为 `0`，幂及更高层为 `1`。由此可证明前四级恰为后继、加法、乘法、幂。

# 陈述（Lean 对照）

公开定义是 `hyperOperation`，并非 `Nat.hyperoperation` 的别名。私有引理 `hyperOperation_one/two/three` 分别通过对 `b` 归纳建立三层桥；公开定理 `hyperOperation_first_levels` 汇总四个等式。证明中 `simp` 展开定义，`rw` 使用归纳假设以及 `Nat.mul_succ`、`pow_succ` 等算术规则。

# 思维脉络（thinking trace）

先固定统一的后继递推，再反推每层在零处必须取什么值，才能恢复熟悉运算。之后逐层证明：加法桥先成立，乘法桥依赖加法桥，幂桥再依赖乘法桥。这种分层验证也暴露了不同教材编号偏移的来源。

# 自然语言 ↔ Lean 映射

“等级”对应 `rank : ℕ`；底数与迭代参数对应 `a b`；“重复前一级”对应最后一个模式分支里的嵌套 `hyperOperation`；“前四级”对应定理四个合取分量。`Nat.hyperoperation` 是可比对的 Mathlib API，而本条公开结构由本库递归式决定。

# 依赖（人话版）

概念上依赖前条的有限逐步递归和自然数加乘幂。Lean 证明后端使用自然数归纳、结合律、交换律和后继公式；没有使用无限序数，也没有假设某个巨大值能够被实际十进制展开。

# 应用与陷阱

它为 Knuth 箭头提供统一后端。`H₄(2,4)=65536` 已远超普通的同规模指数，但仍是有限自然数。零值约定和等级编号在文献间会偏移，比较公式必须先核对定义；幂塔按右结合，不能误作 `(a^a)^a`。
