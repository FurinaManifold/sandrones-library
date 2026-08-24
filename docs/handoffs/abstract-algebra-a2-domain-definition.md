# 抽象代数 A2 零因子、整环与域定义层：集成交接清单

本批只完成零因子、整环与域的底层教材公理及实现桥，不包含素理想、极大理想或商环判据
的迁移。

## 源码与文档

- 源码：`SandronesLibrary/AbstractAlgebra/Ring.lean`。
- 条目：`docs/entries/abstract-algebra/ring/domain.md`。
- 审计：`docs/entries/abstract-algebra/DEFINITION-AUDIT.md`。

新增公开对象为 `ZeroDivisorElement`、`NoZeroDivisorsAxiom`、`IntegralDomainAxioms` 与
`FieldAxioms`。教材主定理使用这些本库对象；Mathlib `NoZeroDivisors`、`IsDomain`、
`IsField` 只在三个具名桥中出现。

## Main 共有文件事项

- 本批不新增 Lean 文件和 Entry id，Registry 仍将 `abstract-algebra.ring.domain` 指向
  `Ring.lean`，只需重算该条目的声明集合、axioms 与 proof hash。
- ROADMAP 可把 A2.4 的零因子、整环、域定义层标记完成，但素/极大理想和商环判据仍须保留
  迁移边界。
- RADAR 应把 `NoZeroDivisors`、`IsDomain`、`IsField` 标记为兼容桥，而非教材定义。

## 验证命令

```bash
lake env lean SandronesLibrary/AbstractAlgebra/Ring.lean
lake build SandronesLibrary.AbstractAlgebra.Ring
python3 scripts/check_axioms.py --all
git diff --check
```

还应扫描 `abstract-algebra.ring.domain` 新主定理的签名，确认 `IsDomain`、`IsField` 仅出现于
具名桥和旧兼容接口，且没有 `Module` 或 `Submodule`。

## 未完成边界

- `is_prime_iff`、`is_maximal_implies_is_prime`、商整环、商域和零理想极大判据仍直接使用
  Mathlib `Ideal` 属性，等待下一批自建素理想与极大理想谓词。
- 第一、第二、第三环同构定理与对应定理属于 A2.3，不在本批范围。
