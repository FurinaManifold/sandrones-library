# ST2 基数理论（基础与算术批次）：集成交接清单

本文件供集成 Codex 使用。学科分支 `codex/settheory-ordinal` 在本批次新增：

- `SandronesLibrary/SetTheory/CardinalTheory.lean`
- `docs/entries/settheory/cardinal/equinumerous.md`
- `docs/entries/settheory/cardinal/comparison.md`
- `docs/entries/settheory/cardinal/cantor-bernstein.md`
- `docs/entries/settheory/cardinal/cantor-theorem.md`
- `docs/entries/settheory/cardinal/addition.md`
- `docs/entries/settheory/cardinal/multiplication.md`
- `docs/entries/settheory/cardinal/exponentiation.md`
- `docs/entries/settheory/cardinal/finite-set.md`
- `docs/entries/settheory/cardinal/aleph-hierarchy.md`
- `docs/entries/settheory/cardinal/beth-hierarchy.md`
- `docs/entries/settheory/cardinal/cardinal-cofinality.md`
- `docs/entries/settheory/cardinal/regular-singular.md`
- `docs/entries/settheory/cardinal/konig-theorem.md`
- `docs/entries/settheory/cardinal/classical-choice-wellordering.md`
- `docs/entries/settheory/cardinal/continuum-hypothesis.md`

## 顶层导入

在 `SandronesLibrary.lean` 的 SetTheory 区加入：

```lean
import SandronesLibrary.SetTheory.CardinalTheory
```

## Registry

登记以下十五项：

1. `settheory.cardinal.equinumerous`（`definition`）
2. `settheory.cardinal.comparison`（`definition`）
3. `settheory.cardinal.cantor-bernstein`（`theorem`）
4. `settheory.cardinal.cantor-theorem`（`theorem`）
5. `settheory.cardinal.addition`（`definition`）
6. `settheory.cardinal.multiplication`（`definition`）
7. `settheory.cardinal.exponentiation`（`definition`）
8. `settheory.cardinal.finite-set`（`definition`）
9. `settheory.cardinal.aleph-hierarchy`（`definition`）
10. `settheory.cardinal.beth-hierarchy`（`definition`）
11. `settheory.cardinal.cardinal-cofinality`（`definition`）
12. `settheory.cardinal.regular-singular`（`definition`）
13. `settheory.cardinal.konig-theorem`（`theorem`）
14. `settheory.cardinal.classical-choice-wellordering`（`theorem`）
15. `settheory.cardinal.continuum-hypothesis`（`definition`）

ROADMAP 中“有限／可数／不可数集”的其余部分已有
`SetTheory/Cardinal.lean` 中的 `countable-def`、`countable-rat`、`uncountable-real` 与
`countable-union` 承担。本分支新增 `finite-set` 补齐有限集接口，不重复复制既有四条。完成合并后，
本批已完成等势、比较关系闭环、Cantor 严格比较、三种算术、有限集入口、aleph、beth、共尾性、
无限基数的正则／奇异分类、König 定理，以及 CH 的准确陈述。既有 `Cardinal.lean` 承担可数性
四条。当前 `classical-choice-wellordering` 只证明 Lean 经典基础中选择函数与良序化可用；尚未在
无选择公理的共同弱基础上形式化它们与 Zorn 引理的双向等价。因此本批不得建议 main 将 ROADMAP
中的该等价关系标为完成，P11/ST2 仍保留这一明确边界。

## 下游依赖门

可以稳定依赖：`Equinumerous`、`CardinalLE`、`CardinalLT` 及比较关系闭环；Cantor 幂集严格
比较；三种教材定义的基数运算；aleph、beth、共尾性、无限基数分类；König 定理与 CH 命题接口。

尚不可依赖：选择公理、良序定理与 Zorn 引理在无选择共同基础中的双向等价；CH/`¬CH` 的证明
或 Gödel/Cohen 独立性的模型论形式化；更细的选择公理弱形式分类。

标题、premises、mathlib 与 provenance 以对应叙述文件的 front matter 为准。合并后运行
`python3 scripts/check_axioms.py --all --fix` 重算派生字段。

## RADAR

登记本批次实际使用的 mathlib API：

- `Equiv`
- `Function.Injective`
- `Embedding.schroeder_bernstein`
- `Equiv.ofBijective`
- `Equiv.sumCongr`
- `Equiv.prodCongr`
- `Equiv.arrowCongr`
- `Fin`
- `Cardinal.aleph`
- `Cardinal.aleph_zero`
- `Cardinal.succ_aleph`
- `Cardinal.beth`
- `Cardinal.beth_zero`
- `Cardinal.beth_succ`
- `Cardinal.ord`
- `Ordinal.cof_ord_le`
- `Cardinal.isRegular_aleph0`
- `Cardinal.sum_lt_prod`
- `Cardinal.lt_power_cof_ord`
- `Classical.choice`
- `WellOrderingRel`
- `Cardinal.beth_one`
- `Cardinal.two_power_aleph0`

Cantor 定理采用本库中展开的对角线论证，没有把 mathlib 的同名定理当作证明主体。

## 定义边界

`Equinumerous α β` 的公开定义是存在等价 `α ≃ β`；`CardinalLE α β` 的公开定义是存在
单射 `α → β`。这两个入口保留教材中的“配对”和“嵌入”含义，不应在集成时改写成对
`Cardinal.mk` 的现成等式或序关系的薄包装。

三种算术的公开对象分别是 `CardinalSum α β := Sum α β`、
`CardinalProduct α β := α × β` 与 `CardinalPower α β := β → α`。集成时不要把它们改成
现成的 `Cardinal` 加、乘、幂运算；本批次的目的正是从不交并、笛卡尔积、函数空间解释这些
运算在数什么。

## 合并后统一验收

```bash
python3 scripts/gen_entries_index.py
python3 scripts/check_axioms.py --all --fix
python3 scripts/audit.py
lake build
```
