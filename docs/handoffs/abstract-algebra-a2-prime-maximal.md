# 抽象代数 A2 素理想与极大理想：集成交接清单

本批独立完成素理想、极大理想及商整环/商域判据的教材定义层，不修改此前两个已划定的 A2
接收窗口。

## 源码与条目

- `SandronesLibrary/AbstractAlgebra/RingPrimeIdeal.lean`；
- `docs/entries/abstract-algebra/ring/prime-ideal.md`；
- `docs/entries/abstract-algebra/DEFINITION-AUDIT.md`。

新 Entry 为 `abstract-algebra.ring.prime-ideal`，只对应 `RingPrimeIdeal.lean`。Main 接收时应
新增该 Registry 记录和顶层 import，不得把声明并回 `ring.domain` 或 `ring.quotient`。

## 前置窗口

本批必须在 A2 商环窗口 `2b60814`、`7aeab93` 和 domain/field 窗口 `c09ff37` 之后接收。
它不依赖 A1 group/action/automorphism/permutation/product 的高扇出迁移。

## 验证命令

```bash
lake env lean SandronesLibrary/AbstractAlgebra/RingPrimeIdeal.lean
lake build SandronesLibrary.AbstractAlgebra.RingPrimeIdeal
python3 scripts/check_axioms.py --all
git diff --check
```

Main 新增 Registry 后还需确认该 Entry 的所有标记只位于 `RingPrimeIdeal.lean`，并重跑完整
`lake build`、audit 与 Registry 派生字段生成。

## 兼容层与后续边界

- 两个 `exists Ideal` 定理是 Mathlib 承载桥，不是教材定义。
- `Ring.lean` 中旧 `is_prime_iff`、`is_maximal_implies_is_prime`、Mathlib 商整环/商域及零理想
  极大判据仍保留为兼容接口，后续调用应迁移到本批主定理。
- 环同构定理的定义层迁移属于下一批；整除、Euclidean 环、PID 与 UFD 尚未开始。
