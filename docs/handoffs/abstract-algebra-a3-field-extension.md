# 抽象代数 A3.5 域扩张交接

## 接收窗口

- 分支：`codex/abstract-algebra`。
- 基线：已同步 Main `224663d`，合并提交 `69a87c9`。
- 新源码：`SandronesLibrary/AbstractAlgebra/FieldExtension.lean`。
- Entry：`abstract-algebra.field.extension`。

## 定义层与成果

- 自建显式 `FieldEmbedding`，携带本库 `RingHomomorphism` 和单射性。
- 自建 `SubfieldSet`、`IntermediateFieldSet` 及交集式 `generatedIntermediateFieldSet`。
- 自建 `AlgebraicElement`、`TranscendentalElement`、`MinimalPolynomialOf` 和
  `SimpleExtension` 教材谓词。
- 证明生成中间域的封闭、包含、最小性和单调性，以及异系数求值四个基础公式。
- 证明基域像代数、超越元量词刻画、最小多项式存在唯一、非零和不可约。

## 接口审计

- 公开主声明显式量化 `FieldEmbedding`；不量化 Mathlib `Algebra`、`IntermediateField` 或
  `Module`。
- `RingHom` 仅是由本库环同态谓词得到的具名承载桥。
- `Algebra`、`algebraMap`、`IsIntegral` 与 `minpoly` 只出现在私有桥和证明体；私有桥先证明
  局部 `algebraMap` 等于显式嵌入，避免改变教材语义。
- 所有湮灭多项式与最小多项式统一使用正式 `Polynomial K`；无 `PolynomialSequence` 新依赖。

## Main 集成事项

- 顶层 import 加入 `SandronesLibrary.AbstractAlgebra.FieldExtension`。
- Registry 将 `abstract-algebra.field.extension` 唯一映射到新源码与 Entry 文档。
- ROADMAP 标记 A3.5 完成，并解锁 A3.6 扩张次数。
- RADAR 登记显式嵌入、生成中间域、代数／超越元和最小多项式接口及私有 Mathlib 后端。
- 运行 register、`check_axioms --all --fix`、audit、Entry 唯一映射检查与全库 build。

## 后续边界

A3.6 应继续显式接受 `FieldEmbedding`，不得以 `[Algebra K L]` 或 `Module` 作为课程主签名；扩张
次数所需的线性组合、线性无关、张成和基应按最新 ROADMAP/Playbook 的阶段边界单独设计。
