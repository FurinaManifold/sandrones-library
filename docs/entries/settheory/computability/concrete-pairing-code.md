---
id: settheory.computability.concrete-pairing-code
kind: definition
state: verified
title: "可计算的自然数配对实例"
premises: ["settheory.computability.pairing-code"]
mathlib: ["Nat.pair", "Nat.unpair", "Nat.unpair_pair"]
provenance: {source_type: library_bridge, ref: "odifreddi-classical-recursion-1989"}
---

# 动机

上一条 `PairingCode` 只列出合格编码必须满足的字段，没有交出任何实例。若后续要真的把“程序代码
和普通输入”装进一个自然数，就需要一套能计算、能拆开并有恢复证明的具体方案。本条关闭的只是
这个配对编码门，不是通用模拟或对角编译门。

# 直觉

把自然数点阵中的每个格子 `(x,y)` 沿着逐渐扩大的方形边界编号，就能给每个有序对一个唯一自然
数。反向操作先用平方根定位代码落在哪一层方形边界，再算出横纵坐标。`Nat.pair` 和
`Nat.unpair` 实现的正是这种显式算术编号；先配对再拆对，会回到原来的两个数。

# 陈述（自然语言）

`natPairingCode` 是本库 `PairingCode` 的具体值：配对字段取 `Nat.pair`，左右投影取
`Nat.unpair` 的第一和第二分量。本库证明两个投影分别恢复输入，合起来恢复整个有序对，并由既有
抽象定理推出该配对函数对自然数有序对单射。

# 陈述（Lean 对照）

```lean
def natPairingCode : PairingCode where
  pair := Nat.pair
  left := fun code => code.unpair.1
  right := fun code => code.unpair.2
  left_pair := ...
  right_pair := ...
theorem natPairingCode_recover (x y : ℕ) :
  (natPairingCode.left (natPairingCode.pair x y),
    natPairingCode.right (natPairingCode.pair x y)) = (x, y)
theorem natPairingCode_injective :
  Function.Injective (fun p : ℕ × ℕ => natPairingCode.pair p.1 p.2)
```

# 思维脉络（thinking trace）

先审计 mathlib 源码：`Nat.pair` 是比较两个坐标后的分段乘加公式；`Nat.unpair` 用 `Nat.sqrt` 找到
方形层并用减法取坐标，二者都是可约简自然数程序。mathlib 已证明
`Nat.unpair_pair x y : Nat.unpair (Nat.pair x y) = (x,y)`。本库分别对该等式应用 `Prod.fst`
和 `Prod.snd`，得到 `PairingCode` 所需的两条恢复律，再复用本库抽象恢复与单射定理完成接口。

# 自然语言 ↔ Lean 映射

- “具体配对算法” ↔ `Nat.pair x y`。
- “具体拆对算法” ↔ `Nat.unpair code`。
- “左投影” ↔ `(Nat.unpair code).1`。
- “右投影” ↔ `(Nat.unpair code).2`。
- “先配再拆恢复” ↔ mathlib 后端定理 `Nat.unpair_pair`。
- “本库具体规格实例” ↔ `natPairingCode`。
- “编码无碰撞” ↔ `natPairingCode_injective`。

# 依赖（人话版）

公开目标依赖上一批本库 `PairingCode` 结构。具体算术和底层逆向证明复用 mathlib
`Mathlib.Data.Nat.Pairing`；它在这里是计算与证明后端，而不是本库概念定义的替代品。本库负责把
后端结果组装为先前冻结的教材接口，并公开恢复和单射性质。

# 应用与陷阱

后续可以直接用 `natPairingCode.pair code input` 把两个参数编码成一个自然数，并可靠恢复。但该
实例只是一种数据编码：它没有构造 `UniversalNatInterpreter`，没有提供机器语言 runner，也没有
实现 `DiagonalFlipClosure`。因此不能从本条无条件推出停机不可判定，更没有推出 Busy Beaver
不可计算。所谓“可计算”这里只指配对和投影是显式自然数函数，不等于已证明它们由本库
`NatProgram` 机器模型实现；若后续需要机器实现，还须单独编译并证明。
