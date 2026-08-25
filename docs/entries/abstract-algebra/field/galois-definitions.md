---
id: abstract-algebra.field.galois-definitions
family: abstract-algebra.field
variant: textbook
kind: definition
state: verified
title: Galois 扩张、显式自同构群与固定域
summary: 基域自同构的教材群结构、固定域集合以及可分且正规的 Galois 扩张定义
premises: [abstract-algebra.field.separable-normal-characterizations,
  abstract-algebra.group.def, abstract-algebra.field.splitting]
mathlib: []
provenance:
  source_type: book
  ref: dummit-foote-abstract-algebra-2004
---

# 动机

Galois 理论同时研究扩张的多项式性质与保持基域不动的对称性。本条目只建立
A3.9a 定义层：显式基域自同构、这些自同构的群公理、任意自同构族的固定域，
以及“可分且正规”的 Galois 扩张。中间域与子群的基本对应属于 A3.9b。

# 自同构承载

`FieldAutomorphismOver e` 是 `FieldIsomorphismOver e e` 的缩写，不是新结构。
后者已经显式保存正向和逆向 `FieldEmbedding`、左右互逆证明及固定基域条件；
重新复制会制造两套相同概念。缩写使已有 A3.7 同构成为正式教材承载。

恒等、复合与逆分别复用 `FieldIsomorphismOver.refl`、`trans` 和 `symm`。
复合约定为 `(σ * τ)(x)=σ(τ(x))`。模块公开逐点计算公式、结合律、左右
单位律和左右逆律，最后汇总为本库 `GroupAxioms`。这里有意不给公开 API
加入 Mathlib `Group` 或 `AlgEquiv`。

# 固定域

对 `H : Set (FieldAutomorphismOver e)`，`FixedFieldSet e H` 是被 `H` 中每个
自同构固定的目标域元素集合。即使 `H` 尚未配备子群条件，共同固定点仍对
零、一、加、乘、负和非零逆封闭。每个基域自同构还固定 `e` 的像，因此
该集合满足 `IntermediateFieldSet e`。

空自同构族的固定域是全集；全体自同构的固定域按定义是被每个自同构固定的
元素。若 `H ⊆ J`，则 `FixedFieldSet e J ⊆ FixedFieldSet e H`，体现固定域
关于自同构族的反变性。

# Galois 扩张

`GaloisExtension e` 定义为：

```text
SeparableExtension e ∧ NormalExtension e.
```

模块给出可分、正规和代数性投影。利用 A3.8 第二批正规扩张判据，还得到：
Galois 等价于扩张可分且代数，并且每个在目标域中获得一个根的基域不可约
多项式都在目标域中完全分裂。

# Mathlib 的角色

Mathlib 以 `L ≃ₐ[K] L` 承载 Galois 群，以 `IntermediateField.fixedField`
承载打包固定域，并以 `IsGalois K L` 表示可分且正规。本条目没有公开这些
对象：显式嵌入和集合谓词已经足以完成 A3.9a，而且没有需要 `AlgEquiv` 桥的
真实公开使用者。Mathlib 结构可在 A3.9b 的私有证明后端按需桥接。

# 教材来源

本条目复用 Dummit and Foote, *Abstract Algebra*, Third Edition 的来源键，
对应 Chapter 13 中 Galois 扩张、自同构群与固定域的定义性内容。

# 审计与边界

- `FieldAutomorphismOver` 是 `abbrev`；声明映射工具已实际识别该缩写，人工核对也确认其
  展开、运算、群公理和固定域使用链完整。
- 不证明全自同构固定域等于基域，不证明自同构群阶等于扩张次数。
- 不定义固定中间域的自同构子群，也不建立中间域与子群的反序对应。
- A3.9b 仍为 `research_open`，不能由本条目的 verified 状态推断为已完成。
