---
id: settheory.googology.hereditary-base
kind: definition
state: verified
title: "遗传基表示：连指数也用同一底数展开"
premises: ["settheory.googology.primitive-recursion"]
mathlib: []
provenance: {source_type: book, ref: "Laurence Kirby and Jeff Paris, Accessible Independence Results for Peano Arithmetic, 1982"}
---

# 动机

普通写法 `4=2²` 把指数 `2` 当成不可分析的数。Goodstein 换底要求指数内部乃至更深层的底数也一起改变，因此必须保存表达式结构，而不只保存最终数值。

# 直觉

遗传表示是一棵语法树。节点记载零、数字、加法、乘法和“当前底数的某表达式次幂”；指数仍是同类树，所以底数能在任意深度出现。同一棵树换一个解释底数便得到新值。

# 陈述（自然语言）

定义遗传表达式及其在底数 `b` 下的求值，并规定每个数字叶必须小于 `b`。`4` 的遗传二进制树是 `B^(B^1)`：在 `B=2` 时为 4，在 `B=3` 时为 27，而且它在底数 2 下合法。

# 陈述（Lean 对照）

归纳类型 `HereditaryBaseExpr` 给出五种语法节点；`HereditaryBaseExpr.eval` 递归求值，`Valid` 递归检查数字范围。`hereditary_four_example` 用 `norm_num` 展开两一定义并完成有限算术验证。全部是本库公开结构，没有 Mathlib 现成遗传表示作后端。

# 思维脉络（thinking trace）

先区分语法和语义，避免换底前丢失幂结构；再让 `basePow` 的指数递归使用同一语法，以实现“遗传”；随后补充最低限度的合法性谓词；最后用 4 的例子验证深层换底确实把 9 提升为 27。

# 自然语言 ↔ Lean 映射

“语法树”对应 `HereditaryBaseExpr`；常数位对应 `.digit n`；当前底数幂对应 `.basePow exponent`；“在底数 b 下解释”对应 `expr.eval b`；“数字小于底数”对应 `expr.Valid b`；`norm_num` 是具体算术证明工具，不是一般正规形算法。

# 依赖（人话版）

只需要有限归纳语法、自然数加乘幂和递归求值。前置原始递归条目提供构造背景。当前 `Valid` 仅检查数字范围，不证明表示唯一，也未给出把任意自然数自动编码成遗传正规形的算法。

# 应用与陷阱

该语法是 Goodstein 单步的输入。换底改变所有 `basePow` 的统一解释参数，而不是把数字叶机械加一。普通换底 `2²→3²=9` 会漏掉指数中的底数；遗传换底得到 27。合法表达式仍可能非正规或不唯一，这一缺口不能在后续序列定义中忽略。
