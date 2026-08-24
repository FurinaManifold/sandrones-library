---
id: settheory.computability.pairing-code
kind: definition
state: verified
title: "自然数有序对编码"
premises: ["settheory.computability.universal-interpreter-spec"]
mathlib: ["Function.Injective"]
provenance: {source_type: textbook, ref: "Gödel coding of finite tuples"}
---

# 动机

通用程序通常需要同时接收“被模拟程序的代码”和“普通输入”，但本库程序接口只接收一个自然数。
要把两个参数送进同一输入，必须先固定配对编码，并证明编码后能够无歧义地恢复左右分量，不能仅在
文字里说“把它们打包起来”。

# 直觉

配对编码像给每个自然数有序对分配一个储物柜编号。左投影和右投影是两把读取钥匙：拿到由
`pair x y` 产生的编号，必须分别取回原来的 `x` 与 `y`。如果两对数拿到同一编号，投影会证明
它们左右分量都相等，所以两对本来就是同一对。

# 陈述（自然语言）

`PairingCode` 包含配对函数和左右投影，并要求两条投影还原定律。由这些定律，本库证明配对函数在
自然数有序对上单射，也证明把配对代码同时送入两个投影，结果恰是原有序对。本条只冻结规格，
没有选择某个具体 Cantor 配对公式。

# 陈述（Lean 对照）

```lean
structure PairingCode where
  pair : ℕ → ℕ → ℕ
  left : ℕ → ℕ
  right : ℕ → ℕ
  left_pair : ∀ x y, left (pair x y) = x
  right_pair : ∀ x y, right (pair x y) = y
theorem PairingCode.pair_injective (coding : PairingCode) :
  Function.Injective (fun p : ℕ × ℕ => coding.pair p.1 p.2)
theorem PairingCode.recover (coding : PairingCode) (x y : ℕ) :
  (coding.left (coding.pair x y), coding.right (coding.pair x y)) = (x, y)
```

# 思维脉络（thinking trace）

结构把未来实现必须提供的计算函数与正确性定律放在一起。证明单射时，假设两个配对代码相等，
分别在等式两边应用 `left` 和 `right`，再用还原定律得到左右分量相等，最后用有序对外延性组装。
恢复定理则直接同时重写两条还原定律。

# 自然语言 ↔ Lean 映射

- “把两个数编成一个数” ↔ `coding.pair x y`。
- “取回程序代码” ↔ `coding.left code`。
- “取回普通输入” ↔ `coding.right code`。
- “左分量恢复” ↔ `left_pair`。
- “右分量恢复” ↔ `right_pair`。
- “编码没有碰撞” ↔ `PairingCode.pair_injective`。
- “同时恢复原有序对” ↔ `PairingCode.recover`。

# 依赖（人话版）

概念上依赖上一批通用解释器需要自然数程序代码这一背景，形式证明只使用函数、自然数和有序对。
`Function.Injective` 是单射的标准谓词；配对和投影本身是本库要求实现者提供的字段。

# 应用与陷阱

配对接口让一元输入程序可以接收代码与数据，也可继续嵌套编码更多参数。当前结构只要求对配对产生
的代码正确恢复，没有要求每个自然数都是某个有序对代码；本批对角证明不需要满射性。不要在尚未
构造具体 `PairingCode` 实例时声称已经得到可执行编号器。
