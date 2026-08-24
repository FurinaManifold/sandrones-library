# 抽象代数 A2 理想与商环：集成交接清单

本批完成教材定义层中的双边理想到商环的完整构造链。抽象代数分支负责源码、教材条目和
定义审计；Main 只需在接收后更新共有索引与规划文件。

## 源码与条目

本批源码文件：

- `SandronesLibrary/AbstractAlgebra/Ring.lean`：理想集合、生成理想、和与积及 Mathlib 桥；
- `SandronesLibrary/AbstractAlgebra/RingQuotient.lean`：模理想同余、商集运算、环公理、
  自然投影、核与泛性质。

本批文档文件：

- `docs/entries/abstract-algebra/ring/ideal.md`；
- `docs/entries/abstract-algebra/ring/quotient.md`；
- `docs/entries/abstract-algebra/DEFINITION-AUDIT.md`。

## 顶层 import

Main 接收后应在 `SandronesLibrary.lean` 的抽象代数部分加入：

```lean
import SandronesLibrary.AbstractAlgebra.RingQuotient
```

`RingQuotient.lean` 自身导入 `SandronesLibrary.AbstractAlgebra.Ring`，无需重复调整依赖方向。

## Main 后续共有文件更新事项

- Registry：保留 `abstract-algebra.ring.ideal` 对 `Ring.lean` 的现有归属，只新增
  `abstract-algebra.ring.quotient` 并指向 `RingQuotient.lean`；两个 id 分别由脚本重算
  axioms 与 proof hash，不允许一条记录跨两个 Lean 文件。
- ROADMAP：将 A2.2 理想与商环定义层标记完成；下一项仍是零因子、整环与域的自建谓词。
- RADAR：登记通用 `Quotient` 的 `lift`/`map`/归纳接口，以及兼容层使用的 `Ideal` API。
- 不要把后续素理想、极大理想、环同构定理误计入本批。

## 验证命令

```bash
lake env lean SandronesLibrary/AbstractAlgebra/RingQuotient.lean
lake build SandronesLibrary.AbstractAlgebra.Ring SandronesLibrary.AbstractAlgebra.RingQuotient
python3 scripts/check_axioms.py --all
python3 scripts/audit.py
git diff --check
```

若 Registry 尚未由 Main 接入新模块，`check_axioms.py --all` 不会覆盖新文件；此时应另用临时
聚合文件对新模块的公开定理执行 `#print axioms`，并在 Main 更新 Registry 后重跑全量检查。

## 完成边界

- 本批已经完整证明商环运算良定义、环公理、自然投影的同态性与核，以及映射下降的存在唯一性。
- Mathlib `Ideal` 与 `Ideal.Quotient` 仍作为兼容层保留，不是本库教材定义。
- 零因子、整环、域、素理想、极大理想、商整环/商域判据和环同构定理仍属后续批次。
