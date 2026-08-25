---
id: settheory.googology.conway-recursion
kind: definition
state: verified
title: "一般有限 Conway 链的递归求值"
premises: ["settheory.googology.conway-chain"]
mathlib: ["Prod.Lex"]
provenance: {source_type: book, ref: "conway-guy-book-of-numbers-1996"}
---

# 动机

只说一项链等于该数、两项链等于幂，还不能解释 `a → b → c` 或更长链究竟表示什么。一般 Conway 链的递推又会把一次较小链的求值结果塞回原链，表面上甚至可能产生更大的参数；如果不同时给出严格的终止度量，“按公式递归”便还不是一个合法的总函数。本条补齐任意有限正整数链的求值及其终止性证明。

# 直觉

从链的最右端观察。末项是 `1` 时，把末项删掉；倒数第二项是 `1` 时，从这个 `1` 起把右侧尾部全部删掉。若末两项 `a,b` 都大于一，就先在保持 `b` 不变的情况下把 `a` 减一并求出内层值，再把该值放回倒数第二个位置，同时把 `b` 减一。内层调用降低倒数第二项，外层调用降低末项，因此虽然中间数值可能暴涨，递归控制参数仍严格下降。

# 陈述（自然语言）

非空有限链从右端递归构造。单项链 `a` 的值为 `a`，两项链 `a → b` 的值为 `a^b`。对更长链，`X → a → 1 = X → a`，`X → 1 → Y = X`；当 `a,b>1` 时，

`X → a → b = X → (X → (a-1) → b) → (b-1)`。

这些规则对所有有限正整数链给出唯一的自然数值。实现使用“链长、末项、倒数第二项”的字典序作为终止度量。

# 陈述（Lean 对照）

```lean
inductive ConwayArrowTerm where
  | singleton (a : ℕ)
  | snoc (init : ConwayArrowTerm) (last : ℕ)

def ConwayArrowTerm.Positive : ConwayArrowTerm → Prop
def ConwayArrowTerm.eval : ConwayArrowTerm → ℕ

theorem conwayEval_penultimate_one (c) (b) :
  (ConwayArrowTerm.snoc (ConwayArrowTerm.snoc c 1) b).eval = c.eval

theorem conwayEval_recursive (c) (a b) :
  (c.snoc (a + 2)).snoc (b + 2) |>.eval =
    (c.snoc (((c.snoc (a + 1)).snoc (b + 2)).eval)).snoc (b + 1) |>.eval

theorem conwayEval_two_two_two :
  ((ConwayArrowTerm.singleton 2).snoc 2).snoc 2 |>.eval = 4
```

# 思维脉络（thinking trace）

先选择 `singleton/snoc` 语法，使“末项”和“删去右端”直接对应构造子，而不必反复拆列表。随后把数学定义域单独写成 `Positive`，求值则为满足 Lean 的总函数要求，对含零输入增加不参与正整数理论的技术分支。终止证明分三类：删去 `1` 会缩短链长；一般递推的内层调用保持链长和末项但降低倒数第二项；外层调用保持链长却降低末项。最后用 `2 → 2 → 2 = 4` 做语义回归，防止把 `X → 1 → Y` 误写成 `X → Y`。

# 自然语言 ↔ Lean 映射

“在链右边追加 `b`”对应 `ConwayArrowTerm.snoc c b`；“链中所有项为正”对应 `c.Positive`；“通常从左到右书写的项列表”对应 `c.entries`。“先算内层再塞回去”对应 `eval` 一般分支中的局部量 `inner`；“三层字典序下降”对应私有度量 `recursionMeasure c = (c.length, c.last, c.penultimate)` 以及两个嵌套的 `Prod.Lex`。原有列表式语法则通过 `toChain` 接收新语法中的正链。

# 依赖（人话版）

数学上只依赖自然数幂和上一条已经固定的 Conway 正整数链约定。形式化没有调用现成的 Conway 求值器；Mathlib 的 `Prod.Lex` 只帮助表达字典序良基关系，实际递推规则、语法、正性条件和终止下降均由本库给出。`toChain` 连接 `settheory.googology.conway-chain` 的列表入口，但旧入口的一、二项受限求值不是本定义的实现替身。

# 应用与陷阱

该求值器可作为一般 Conway 长链、Knuth 上箭头低阶对应和后续大数记号的公共基础。最常见的错误是把 `X → 1 → Y` 化成 `X → Y`；标准规则应得到 `X`，错误规则会把 `2 → 2 → 2` 算成 `16` 而不是 `4`。另一个边界是代码为含零链提供了总化分支，但标准 Conway 记号只使用 `Positive` 链，不能把技术分支解释为新的数学约定。定义可执行也不意味着现实机器能展开大链的数值。
