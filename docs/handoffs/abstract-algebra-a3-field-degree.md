# 抽象代数 A3.6 域扩张次数交接

## 接收窗口

- 分支：`codex/abstract-algebra`。
- 已同步 Main：`008b6a1`，同步合并提交 `2601ef4`。
- 新源码：`SandronesLibrary/AbstractAlgebra/FieldDegree.lean`。
- Entry：`abstract-algebra.field.degree`。

## 数学成果

- 显式定义有限线性组合、线性无关、张成、一般域基与 `Fin n` 域基。
- 定义有限次数关系、有限域扩张和代数扩张。
- 证明有限基坐标存在唯一、基长度相等、次数唯一与次数正性。
- 证明恒等扩张次数为一、有限扩张必代数。
- 构造塔乘积基、证明基的重编号，并得到塔式公式与有限性复合。

## 公开签名审计

- 课程主 API 继续显式接受 A3.5 的 `FieldEmbedding`。
- 公开声明不出现 `Algebra`、`Module`、`Submodule`、Mathlib `LinearIndependent`、
  `Module.Basis` 或 `Module.finrank`。
- 高级线性代数对象只存在于私有桥；局部 `Algebra` 的基域映射已证明等于显式嵌入。
- 塔式公式实际构造 `f(bᵢ)cⱼ` 乘积基并重编号，不是只有 `finrank` 包装。

## Main 集成事项

- 顶层 import 加入 `SandronesLibrary.AbstractAlgebra.FieldDegree`。
- Registry 将 `abstract-algebra.field.degree` 唯一映射到新源码和 Entry 文档。
- ROADMAP 标记 A3.6 完成；A3.7 是否解锁以 Main 新通知为准。
- RADAR 登记显式基、次数唯一、有限扩张代数性、`Basis.smulTower` 私有后端和塔式公式。
- 运行生成索引、公理修复、Entry audit、依赖闭包与 Main 全库 build。

## 当前冻结边界

Main `008b6a1` 同步通知明确写明分裂域及后续窗口仍冻结。`/tmp` 中 A3.7 草稿已经停止，不属于
本次提交，也不得由 Registry 或 ROADMAP 提前登记为完成。
