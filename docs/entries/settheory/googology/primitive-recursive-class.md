---
id: settheory.googology.primitive-recursive-class
kind: definition
state: verified
title: "原始递归函数类：冻结、教科书承载与派生闭包"
premises: ["settheory.googology.primitive-recursion"]
mathlib: ["Nat.Primrec'", "Nat.Primrec'.prim_iff", "Nat.Primrec'.prec'", "Nat.Primrec'.comp'", "Finset.range"]
provenance:
  source_type: textbook
  ref: "odifreddi-classical-recursion-1989"
---

# 动机

上一条只把一元递推模板 `primitiveRecursion` 写成一个具体构造，还没有回答“哪些函数算原始递归”。
经典递归论用**最小函数类**回答这个问题：从零函数、后继与投影出发，对复合和原始递归封闭。
本条把这个类冻结下来，并补上 ST3 增长路线要用的派生闭包，避免每个具体函数各自重证一遍。

# 直觉

原始递归函数类不是一张函数清单，而是一台“造函数机器”能产出的全部函数：初始零件是零、后继和
投影，装配规则只有复合与原始递归。凡是能用这两条规则从初始零件搭出来的都在类里；凡是需要
“搜索直到找到”才能定义的则可能不在。把类本身冻结后，证明新函数属于类就只需指出装配过程。

# 陈述（自然语言）

原始递归函数类是满足以下条件的最小类：

1. 含零函数、后继函数与所有坐标投影；
2. 若 `f` 与各分量函数在类中，则复合 `v ↦ f (g v)` 在类中；
3. 若基函数 `f` 与递归步 `g` 在类中，则按 `Nat.rec` 定义的原始递归函数在类中。

在此之上，本条证明三条派生闭包：**有界求和** `v ↦ Σ_{i < b v} f (i, v)`、**有界求积**
`v ↦ Π_{i < b v} f (i, v)`，以及**有限迭代** `v ↦ Nat.rec (base v) (step ·) (count v)`：只要
`b`、`f`、`base`、`step`、`count` 在类中，结果仍在类中。另有接入定理：本库 `primitiveRecursion`
的一元模板在其更新规则属于类时，所得函数也在类中。

# 陈述（Lean 对照）

教材类直接由 mathlib 的教科书版多元类 `Nat.Primrec'`（函数 `List.Vector ℕ n → ℕ`）承载；初始
函数、复合与原始递归分别对应构造子 `zero`、`succ`、`get`、`comp`、`prec`。到一元配对形式
`Nat.Primrec` 的等价由 `Nat.Primrec'.prim_iff` 给出：

```lean
theorem primrec_boundedSum {n} {b : List.Vector ℕ n → ℕ} {f : List.Vector ℕ (n + 1) → ℕ}
    (hb : @Nat.Primrec' n b) (hf : @Nat.Primrec' (n + 1) f) :
    @Nat.Primrec' n (fun v => Finset.sum (Finset.range (b v)) (fun i => f (i ::ᵥ v)))
theorem primrec_boundedProd {n} {b} {f} (hb) (hf) :
    @Nat.Primrec' n (fun v => Finset.prod (Finset.range (b v)) (fun i => f (i ::ᵥ v)))
theorem primrec_iterated {n} {base} {step} {count} (hbase) (hstep) (hcount) :
    @Nat.Primrec' n (fun v => Nat.rec (base v) (fun _ IH => step (IH ::ᵥ v)) (count v))
theorem primrec_primitiveRecursion {z} {step : ℕ → ℕ → ℕ}
    (hstep : @Nat.Primrec' 2 (fun v => step v.head v.tail.head)) :
    @Nat.Primrec' 1 (fun v : List.Vector ℕ 1 => primitiveRecursion z step v.head)
```

有界求和与有界求积的证明都把 `Finset.sum`／`prod` 化归成一次 `Nat.rec`：递归步分别是
`IH + f y` 与 `IH * f y`，再用 `Finset.sum_range_succ`／`prod_range_succ` 把递归值与有限和／积
对齐。有限迭代则直接调用 `Nat.Primrec'.prec'`，把单步函数作用在「新累加器 + 尾参数」向量上。

# 思维脉络（thinking trace）

原计划先用“教科书类”与“一元类”两套定义互证，但这正是 `Mathlib` 已经完成的 `prim_iff`；重造同构
谓词只会增加维护面。于是把类承载固定为 `Nat.Primrec'`，本条只做 mathlib 尚未提供的三件事：
有界求和、有界求积和有限迭代的闭包，以及把本库 `primitiveRecursion` 接入该类。有界求和先写成
`Nat.rec 0 (fun y IH => IH + f y)` 再逐点证其等于 `Finset.range` 上的和；关键是把累加放在
`IH` 之后，使递归顺序与 `sum_range_succ` 一致。有限迭代的组装要点是 `prec'` 的递归步接收
`y ::ᵥ IH ::ᵥ v`，因此单步函数要读 `IH`（`w.tail.head`）而不是 `y`，并把 `y` 显式忽略。

# 自然语言 ↔ Lean 映射

- “类” ↔ `Nat.Primrec'`；`n` 元函数 ↔ `List.Vector ℕ n → ℕ`。
- “初始函数” ↔ 构造子 `zero`、`succ`、`get`。
- “对复合封闭” ↔ 构造子 `comp`／派生 `comp'`；本条的有界闭包都通过它把分量接起来。
- “对原始递归封闭” ↔ 构造子 `prec`／派生的 `prec'`。
- “有界求和／求积的界” ↔ 第一参数 `b : List.Vector ℕ n → ℕ`；被求和项 `f` 多收一个下标参数。
- “有限迭代次数” ↔ `count`；初值 ↔ `base`；单步 ↔ `step`。
- “本库一元递归模板” ↔ `primitiveRecursion z step`，其更新规则以二元函数进入类。

# 依赖（人话版）

依赖本库 `settheory.googology.primitive-recursion` 提供的 `primitiveRecursion` 与自然数结构递归，
以及 mathlib 的教科书版函数类 `Nat.Primrec'`。`Finset.sum`／`prod` 与 `Nat.rec` 只承担“有限和／积
就是递归”的证明后端，不替代类本身；`Nat.Primrec'.prim_iff` 是类与一元配对形式之间语义一致的
公开桥，不是本库自建定义。Ackermann 函数、无界搜索与一般递归不在本条范围。

# 应用与陷阱

下游增长层级可以把“带燃料迭代”直接登记为类内函数，再讨论其支配关系；接入定理让
`Googology.primitiveRecursion` 生成的函数不再孤立于函数类之外。陷阱有二：其一，`Nat.Primrec'`
允许投影与配对编码，属于类的函数**不**意味着在通常字面意义上“只用一个递归变量”，比较支配时
必须先回到类内见证；其二，有界求和／求积的界也可以本身是类内函数，定理并未要求它是常数。本条
不证明 Ackermann 非原始递归，也不含无界 `μ`-算子闭包，故不能据此宣称“所有递归函数都原始递归”。
