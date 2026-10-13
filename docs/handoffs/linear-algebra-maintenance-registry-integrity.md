# Linear Algebra 登记完整性维护 Handoff（Wave E1）

- 学科：线性代数（已覆盖课程维持 ✅，本窗口维护状态 🚧）
- worktree：`/home/pisquare/czt/sandrones-library-linear-algebra`
- 分支：`codex/linear-algebra-maintenance`
- 基线 Main：`52021fe`（ROADMAP 记 `c58dd2f`，本 worktree 起点为 `52021fe`）
- 角色：学科维护负责人（`docs/roles/SUBJECT-MAINTENANCE-ROLE.md`）
- RFC：`docs/maintenance/linear-algebra-registry-integrity.md`
- 本文件对应 ROADMAP Wave E「E1 线性代数」四组缺陷的处置结果。

## 1. 提交清单与本提交回滚边界

| commit | 内容 | 回滚边界 |
|---|---|---|
| `5bbac58` | `docs(maintenance)`: E1 RFC（只读影响图与逐项裁决） | 只删该 RFC 文件，不影响源码 |
| `ea2641e` | `fix(linear-algebra)`: 幽灵 Entry 补证（VectorSpace.lean + dimension.md） | `git revert ea2641e` 即回到「无声明、有 Registry 记录」原状；`dim` 别名与全部既有签名不受影响 |
| `494e7f2` | `fix(linear-algebra)`: 拆开跨文件 id（NormalMatrix.lean + hermitian.md + normal.md） | `git revert 494e7f2` 恢复 `NormalMatrix.lean` 旧标记与旧 normal.md；无 Lean 声明变化 |
| `8f72938` | `chore(linear-algebra)`: 11 个无标记模块补登记（11 源码 + 11 文档） | `git revert 8f72938` 删除 11 个标记与 11 份文档；模块仍可编译（标记在注释内） |

每个 commit 只含一个语义单元，均不含 Main 共享文件。全部变更**没有删除、改名或改变任何
现有 Lean 声明的签名**；`git status --short` 在末次提交后为空。

## 2. 影响等级与阶段

| 项 | 定级 | 阶段 |
|---|---|---|
| 幽灵 Entry `linear-algebra.vector-space.dimension` 补证 | **M1** | 单阶段（新增两条定理 + 标记 + 文档） |
| 跨文件 id `linear-algebra.matrix.normal` 拆分 | **M0**（原条目仅删冗余标记）+ **M3**（新 id `linear-algebra.matrix.hermitian`） | 单阶段；无 M2 双轨 |
| 11 个无标记模块补登记 | **M1** | 单阶段（逐文件标记 + 文档） |

本窗口**无 M2**：没有公开签名迁移或删除，故不启动「新定义与桥 → 分层迁移 → 旧接口退役」三阶段。

## 3. 新旧公开 API 与桥方向

- **无任何 Lean 公开 API 被改名、迁移或删除**，因此没有 `old_iff_new` 桥需求。
- 幽灵 Entry 新增两条公开定理（新接口，无旧接口）：
  - `SandronesLibrary.LinearAlgebra.VectorSpace.dim_eq_zero_iff_subsingleton`：
    `[IsFiniteDimensional 𝕜 V] : dim 𝕜 V = 0 ↔ Subsingleton V`
  - `SandronesLibrary.LinearAlgebra.VectorSpace.dim_eq_rank`：
    `[IsFiniteDimensional 𝕜 V] : (dim 𝕜 V : Cardinal) = Module.rank 𝕜 V`
  - 诚实边界：两条都**必须**带有限维假设。v4.33 的 `Module.finrank_zero_iff` 需要
    `[StrongRankCondition] [Module.Finite]`，而 Mathlib 把无限维 `finrank` 约定为 0，
    故「零维 ⟺ 平凡」只在有限维成立。原条目 summary 漏写该限定。
- `linear-algebra.matrix.normal` 与 `linear-algebra.matrix.hermitian` 是**登记 id 层的拆分**
  （M3），不是 Lean 语义迁移：`normal_unitary_diagonalization` 仍只在 `NormalSpectral.lean`，
  三类矩阵定义与 Hermitian 酉对角化仍只在 `NormalMatrix.lean`，两文件本身一行未改签名。
- 11 个模块的声明在注册前后完全一致，只是补上 Entry 标记与文档。

## 4. 已迁移 / 未迁移下游

- **已迁移下游：无。** 本窗口不迁移任何下游，因为不改变现有声明签名。
- **未被本窗口处理（正确属其他窗口）的下游/债务**：
  - `abstract-algebra.poly.irreducible` 跨文件 id：E3 窗口。
  - `real-analysis.riemann.cont-integrable`（Registry 有、源码缺标记）：E3 窗口。
  - `analysis.derivative.definition`（标记有、Registry 无）：E2 窗口。
  - Analysis 10 个无标记模块、`Topology/Closure.lean`、11 个非线代 orphan 文档：E2/E3 窗口。
  - `Basic.lean` / `Topology/MathlibBridge.lean` 基础设施排除规则：E3 窗口判定。

## 5. 旧 API 剩余使用计数

- 删除的旧接口元素只有一处：`NormalMatrix.lean` 上重复的
  `linear-algebra.matrix.normal` 标记。
- 该旧标记在**全库源码中的剩余使用计数 = 0**（删除后 `grep` 该 id 在
  `SandronesLibrary/` 下零命中；`NormalSpectral.lean` 保留唯一标记）。
- 没有任何 Lean 声明被删除，故「旧声明使用计数」不适用（全部为 0 的移除量）。
- `linear-algebra.matrix.normal` 的 Registry `lean_file`、`proof_sha`、`axioms` **不需要改**：
  `NormalSpectral.lean` 未改动。

## 6. Main 需要更新的共有文件清单

> 维护人未改任何共有文件；以下为精确建议。

### 6.1 `index/registry.json`：新增 12 条记录

`dependedOnBy`、`axioms`、`proof_sha`、`added_by`、`added_at` 由生成器/审计生成，
不要手工填。建议字段如下（`state` 均为 `verified`，`kind` 均为 `theorem`）：

| id | lean_file | nl_file | premises | mathlib | provenance.ref |
|---|---|---|---|---|---|
| `linear-algebra.coordinates.change-basis` | `LinearAlgebra/Coordinates.lean` | `docs/entries/linear-algebra/coordinates/change-basis.md` | `[linear-algebra.vector-space.basis]` | `[Module.Basis.toMatrix_mulVec_repr, basis_toMatrix_mul_linearMap_toMatrix_mul_basis_toMatrix]` | `axler-linear-algebra-2015` |
| `linear-algebra.eigen.diagonalization` | `LinearAlgebra/Diagonalization.lean` | `docs/entries/linear-algebra/eigen/diagonalization.md` | `[linear-algebra.coordinates.change-basis, linear-algebra.eigen.charpoly]` | `[LinearMap.finrank_eigenspace_le, LinearMap.aeval_self_charpoly, LinearMap.minpoly_dvd_charpoly]` | `axler-linear-algebra-2015` |
| `linear-algebra.eigen.jordan` | `LinearAlgebra/Jordan.lean` | `docs/entries/linear-algebra/eigen/jordan.md` | `[linear-algebra.eigen.diagonalization]` | `[]` | `horn-johnson-matrix-analysis-2013` |
| `linear-algebra.eigen.jordan-decomposition` | `LinearAlgebra/JordanDecomposition.lean` | `docs/entries/linear-algebra/eigen/jordan-decomposition.md` | `[linear-algebra.eigen.jordan]` | `[]` | `horn-johnson-matrix-analysis-2013` |
| `linear-algebra.eigen.jordan-block` | `LinearAlgebra/JordanMatrix.lean` | `docs/entries/linear-algebra/eigen/jordan-block.md` | `[linear-algebra.eigen.jordan-decomposition]` | `[Matrix.blockDiagonal']` | `horn-johnson-matrix-analysis-2013` |
| `linear-algebra.eigen.jordan-normal-form` | `LinearAlgebra/JordanNormalForm.lean` | `docs/entries/linear-algebra/eigen/jordan-normal-form.md` | `[linear-algebra.eigen.jordan-block]` | `[Module.End.maxGenEigenspace, DirectSum.IsInternal.collectedBasis]` | `horn-johnson-matrix-analysis-2013` |
| `linear-algebra.eigen.jordan-similarity` | `LinearAlgebra/JordanSimilarity.lean` | `docs/entries/linear-algebra/eigen/jordan-similarity.md` | `[linear-algebra.eigen.jordan-normal-form]` | `[LinearMap.toMatrix'_toLin', Matrix.reindex]` | `horn-johnson-matrix-analysis-2013` |
| `linear-algebra.eigen.jordan-uniqueness` | `LinearAlgebra/JordanUniqueness.lean` | `docs/entries/linear-algebra/eigen/jordan-uniqueness.md` | `[linear-algebra.eigen.jordan-similarity]` | `[]` | `horn-johnson-matrix-analysis-2013` |
| `linear-algebra.vector-space.sum-quotient` | `LinearAlgebra/SubspaceSumQuotient.lean` | `docs/entries/linear-algebra/vector-space/sum-quotient.md` | `[linear-algebra.vector-space.subspace, linear-algebra.vector-space.dimension]` | `[Submodule.finrank_sup_add_finrank_inf_eq, Submodule.finrank_quotient_add_finrank]` | `axler-linear-algebra-2015` |
| `linear-algebra.matrix.hermitian` | `LinearAlgebra/NormalMatrix.lean` | `docs/entries/linear-algebra/matrix/hermitian.md` | `[linear-algebra.matrix.orthogonal-unitary]` | `[Matrix.IsHermitian.spectral_theorem, Matrix.IsHermitian.eigenvectorUnitary, Matrix.conjTranspose_add, Matrix.conjTranspose_sub]` | `horn-johnson-matrix-analysis-2013` |
| `linear-algebra.decomposition.lu` | `LinearAlgebra/MatrixDecomposition.lean` | `docs/entries/linear-algebra/decomposition/lu.md` | `[linear-algebra.elimination.row-reduction]` | `[Matrix.fromBlocks, Matrix.fromBlocks_eq_of_invertible₁₁, Matrix.IsLowerTriangular, Matrix.IsUpperTriangular, Matrix.det]` | `horn-johnson-matrix-analysis-2013` |
| `linear-algebra.elimination.row-reduction` | `LinearAlgebra/MatrixElimination.lean` | `docs/entries/linear-algebra/elimination/row-reduction.md` | `[]` | `[Matrix.swap, Matrix.transvection, Matrix.IsRowEchelon, Matrix.rank_mul_eq_right_of_det_ne_zero]` | `horn-johnson-matrix-analysis-2013` |

`variant`：`change-basis`/`diagonalization`/`sum-quotient` 用 `textbook`；Jordan 链与
`hermitian`/`lu`/`row-reduction` 用 `textbook`。`family` 取各 id 前缀
（`linear-algebra.coordinates`、`linear-algebra.eigen`、`linear-algebra.vector-space`、
`linear-algebra.matrix`、`linear-algebra.decomposition`、`linear-algebra.elimination`）。

**依赖顺序（新增集内部为 DAG，建议按此顺序登记）**：
`change-basis → diagonalization → jordan → jordan-decomposition → jordan-block →
jordan-normal-form → jordan-similarity → jordan-uniqueness`；
`row-reduction → lu`；`hermitian`；`sum-quotient`。

### 6.2 `index/registry.json`：修改 2 条现有记录

1. `linear-algebra.vector-space.dimension`：
   - 记录本来就存在；`lean_file` 不变（`LinearAlgebra/VectorSpace.lean`）。
   - 必须重跑 `python3 scripts/check_axioms.py --all --fix` 以刷新陈旧的 `proof_sha`
     （旧值 `56ab6cfe20365847` 与当前文件 SHA-16 `cfcb0219e1ceffaf` 不符）与 `axioms`。
     补证后该条不再被 `check_axioms.py` SKIP。
   - 建议把 `summary` 改为「有限维时 dim V=0 当且仅当 V 是平凡空间；dim 与秩（基数）一致」，
     与文档一致（原 summary 的零维部分漏写有限维限定）。
2. `linear-algebra.matrix.normal`：
   - `lean_file`、`proof_sha`、`axioms` **不变**（`NormalSpectral.lean` 未改动）。
   - 建议 `summary` 收窄为「一般复正规矩阵可被酉矩阵对角化」。
   - `premises` 增加 `linear-algebra.matrix.hermitian`（`NormalSpectral.lean` import
     `NormalMatrix.lean`，为真实前提）。`dependedOnBy` 由 `update_dependency_graph.py` 反推。

### 6.3 生成器与派生文件

集成后按 AGENTS §6 顺序重跑：`extract_registry_references.py` →
`update_dependency_graph.py` → `gen_entries_index.py` → `gen_entry_rankings.py` →
`check_axioms.py --all --fix` → `check_axioms.py --all` → `audit.py` → `git diff --check` → `lake build`。
重跑后 `linear-algebra.matrix.normal` 的 `lean_usage_files` 歧义（ROADMAP D-4(f) 记录）应消失，
因为重复标记已拆到独立 id。

### 6.4 `SandronesLibrary.lean`（根 import）

- **无需改动。** 11 个模块本来就已被根导入并参与全库构建；本轮没有退役任何模块，
  **没有退役申请**。
- 本窗口未提交任何「退役提交」。

### 6.5 `docs/MATHLIB-RADAR.md`

- `Module.finrank*` 的「谁在用」（`:1261`）应补上新的真实声明：
  `linear-algebra.vector-space.dimension`（`dim_eq_zero_iff_subsingleton`、`dim_eq_rank`）。
- `Matrix.IsHermitian.*` 的「谁在用」（`:2649`）现在同时对应
  `linear-algebra.matrix.hermitian`（Hermitian 酉对角化）与 `linear-algebra.matrix.normal`
  （一般正规酉谱定理）。
- 其余新条目（Jordan、Coordinates、Diagonalization、sum-quotient、LU、row-reduction）
  可在 RADAR 相应 Mathlib 接口段落补「谁在用」。RADAR 是 Main 共享文件，维护人未改。

### 6.6 ROADMAP

- 建议把 D-4 第 4 项 `(a)`（幽灵 Entry）与 `(e)` 中线代部分（`matrix.normal` 跨文件）
  标记为已由本窗口处置；D-4 第 4 项 `(d)` 中线代 11 模块部分标记为已补登记。
- `(b)/(c)/(e)-抽象代数/`E2/E3 部分仍未处置，不要一并勾销。

## 7. 验证结果

全部验证在本 worktree 现场执行；**未运行全库 `lake build`**（Main 职责）。

| 验收门 | 命令 | 结果 |
|---|---|---|
| 修改模块单独编译 + 学科依赖闭包 | `lake build SandronesLibrary.LinearAlgebra.{VectorSpace,NormalSpectral,JordanUniqueness,MatrixDecomposition,MatrixSchur}` | ✅ `Build completed successfully (8728 jobs)`，exit 0，仅重放既有 linter warnings |
| 聚合导入 + 关键 `#check` | `lake env lean /tmp/CheckAll.lean` | ✅ exit 0；18 个 `#check` 全部解析（含两条新定理、`existsPLU`、`complex_matrix_is_similar_to_jordan`、`jordan_normal_basis_unique`、`rank_eq_pivot_count` 等） |
| 幽灵补证独立试编 | `lake env lean /tmp/GhostTest.lean` | ✅ exit 0（两条定理在库记号下可证） |
| Lean Entry / 文档 id / 定义角色一致性 | 自写 Python（复用 `check_axioms.map_entry_to_decl`） | ✅ 13 个新标记 id 每个恰好 1 个 Lean 文件 + 1 份文档；映射到预期声明集合 |
| 禁用占位扫描 | `grep -rn "sorry\|admit\|sorryAx\|native_decide" SandronesLibrary/LinearAlgebra/` | ✅ 零命中（全库仅 FunctionalAnalysis 注释中 "admits" 的假阳性，非本窗口） |
| Mathlib 名称核实 | `grep` Mathlib 源码 | ✅ 文档 `mathlib` 列出的每个名字（含 `fromBlocks_eq_of_invertible₁₁`、`rank_mul_eq_right_of_det_ne_zero`、`Module.End.maxGenEigenspace` 等）均真实存在且在本库源码中被使用 |
| `git diff --check` | `git diff --check` | ✅ exit 0；新文档无行尾空白 |
| 工作树清洁 | `git status --short` | ✅ 空 |
| 磁盘 | `df -h /` | 构建前后均约 11G 可用（未低于 3G）；未跑 `lake update`/`cache get` |

## 8. 重跑的缺陷验证脚本输出原文

脚本：`/tmp/verify_registry_integrity.py`（现场用 Python 重算，未采信任何二手数字）。
判据：Registry id 集合 ↔ `SandronesLibrary/**/*.lean` 的 `> **Entry**: <id>` 标记双向差集；
每个 `.lean` 是否含标记（排除 `Examples/`）；同 id 跨文件；`docs/entries/**/*.md` 的 `id:` 是否在 Registry。

### 8.1 改动前（第一件事重跑，基线 `52021fe`）

```text
========================================================================
SCAN 1: Registry ids vs Lean Entry markers (bidirectional diff)
========================================================================
Registry entries:            575
Distinct marker ids:         574

[A] in Registry but NO Lean marker (2):
    linear-algebra.vector-space.dimension  (lean_file=LinearAlgebra/VectorSpace.lean, state=verified)
    real-analysis.riemann.cont-integrable  (lean_file=RealAnalysis/Riemann.lean, state=verified)

[B] Lean marker but NOT in Registry (1):
    analysis.derivative.definition  @ [('SandronesLibrary/Analysis/Derivative.lean', 32)]

========================================================================
SCAN 2: .lean files with NO Entry marker (excluding Examples/)
========================================================================
Total .lean (excl Examples): 352
Files with >=1 marker:       328
Files with NO marker (24):
    SandronesLibrary/Analysis/ChangeOfVariables.lean  (76 lines)
    SandronesLibrary/Analysis/Complex.lean  (72 lines)
    SandronesLibrary/Analysis/ConstantRank.lean  (572 lines)
    SandronesLibrary/Analysis/CoordinateIntegrals.lean  (509 lines)
    SandronesLibrary/Analysis/FundamentalTheoremAlgebra.lean  (44 lines)
    SandronesLibrary/Analysis/JordanRegion.lean  (61 lines)
    SandronesLibrary/Analysis/JordanRiemannBridge.lean  (100 lines)
    SandronesLibrary/Analysis/MultivariableIntegration.lean  (61 lines)
    SandronesLibrary/Analysis/NormalDomain.lean  (380 lines)
    SandronesLibrary/Analysis/NormedAlternating.lean  (52 lines)
    SandronesLibrary/Basic.lean  (26 lines)
    SandronesLibrary/LinearAlgebra/Coordinates.lean  (93 lines)
    SandronesLibrary/LinearAlgebra/Diagonalization.lean  (158 lines)
    SandronesLibrary/LinearAlgebra/Jordan.lean  (612 lines)
    SandronesLibrary/LinearAlgebra/JordanDecomposition.lean  (468 lines)
    SandronesLibrary/LinearAlgebra/JordanMatrix.lean  (93 lines)
    SandronesLibrary/LinearAlgebra/JordanNormalForm.lean  (156 lines)
    SandronesLibrary/LinearAlgebra/JordanSimilarity.lean  (130 lines)
    SandronesLibrary/LinearAlgebra/JordanUniqueness.lean  (566 lines)
    SandronesLibrary/LinearAlgebra/MatrixDecomposition.lean  (987 lines)
    SandronesLibrary/LinearAlgebra/MatrixElimination.lean  (604 lines)
    SandronesLibrary/LinearAlgebra/SubspaceSumQuotient.lean  (152 lines)
    SandronesLibrary/Topology/Closure.lean  (122 lines)
    SandronesLibrary/Topology/MathlibBridge.lean  (41 lines)

========================================================================
SCAN 3: Same id appearing in more than one file
========================================================================
  abstract-algebra.poly.irreducible:
      SandronesLibrary/AbstractAlgebra/Poly.lean:62
      SandronesLibrary/AbstractAlgebra/Poly.lean:69
      SandronesLibrary/AbstractAlgebra/Poly.lean:76
      SandronesLibrary/AbstractAlgebra/Poly.lean:83
      SandronesLibrary/AbstractAlgebra/Poly.lean:90
      SandronesLibrary/AbstractAlgebra/Poly.lean:97
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:21
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:32
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:41
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:48
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:55
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:65
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:73
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:80
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:90
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:98
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:105
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:114
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:125
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:134
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:142
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:155
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:195
  linear-algebra.matrix.normal:
      SandronesLibrary/LinearAlgebra/NormalSpectral.lean:16
      SandronesLibrary/LinearAlgebra/NormalMatrix.lean:16

========================================================================
SCAN 4: docs/entries/**/*.md  id: fields vs Registry
========================================================================
docs with id field: 590
orphan doc ids (NOT in Registry) (15):
    analysis.complex.definition  @ ['docs/entries/analysis/complex/definition.md']
    analysis.complex.fundamental-theorem-algebra  @ ['docs/entries/analysis/complex/fundamental-theorem-algebra.md']
    analysis.derivative.definition  @ ['docs/entries/analysis/derivative/definition.md']
    analysis.multivariable.change-variables  @ ['docs/entries/analysis/multivariable/change-of-variables.md']
    analysis.multivariable.constant-rank-theorem  @ ['docs/entries/analysis/multivariable/constant-rank-theorem.md']
    analysis.multivariable.coordinate-integrals  @ ['docs/entries/analysis/multivariable/coordinate-integrals.md']
    analysis.multivariable.jordan-region  @ ['docs/entries/analysis/multivariable/jordan-region.md']
    analysis.multivariable.jordan-riemann-bridge  @ ['docs/entries/analysis/multivariable/jordan-riemann-bridge.md']
    analysis.multivariable.rectangle-integral  @ ['docs/entries/analysis/multivariable/rectangle-integral.md']
    analysis.multivariable.x-normal-domain  @ ['docs/entries/analysis/multivariable/normal-domain.md']
    linear-algebra.coordinates.change-basis  @ ['docs/entries/linear-algebra/coordinates/change-basis.md']
    linear-algebra.eigen.diagonalization  @ ['docs/entries/linear-algebra/eigen/diagonalization.md']
    linear-algebra.eigen.jordan  @ ['docs/entries/linear-algebra/eigen/jordan.md']
    linear-algebra.vector-space.sum-quotient  @ ['docs/entries/linear-algebra/vector-space/sum-quotient.md']
    topology.space.closure  @ ['docs/entries/topology/space/closure.md']

Registry ids with NO doc id match (0):
```

### 8.2 改动后（末次提交工作树，供 Main 对账）

```text
========================================================================
SCAN 1: Registry ids vs Lean Entry markers (bidirectional diff)
========================================================================
Registry entries:            575
Distinct marker ids:         587

[A] in Registry but NO Lean marker (1):
    real-analysis.riemann.cont-integrable  (lean_file=RealAnalysis/Riemann.lean, state=verified)

[B] Lean marker but NOT in Registry (13):
    analysis.derivative.definition  @ [('SandronesLibrary/Analysis/Derivative.lean', 32)]
    linear-algebra.coordinates.change-basis  @ [('SandronesLibrary/LinearAlgebra/Coordinates.lean', 21)]
    linear-algebra.decomposition.lu  @ [('SandronesLibrary/LinearAlgebra/MatrixDecomposition.lean', 20)]
    linear-algebra.eigen.diagonalization  @ [('SandronesLibrary/LinearAlgebra/Diagonalization.lean', 18)]
    linear-algebra.eigen.jordan  @ [('SandronesLibrary/LinearAlgebra/Jordan.lean', 16)]
    linear-algebra.eigen.jordan-block  @ [('SandronesLibrary/LinearAlgebra/JordanMatrix.lean', 13)]
    linear-algebra.eigen.jordan-decomposition  @ [('SandronesLibrary/LinearAlgebra/JordanDecomposition.lean', 14)]
    linear-algebra.eigen.jordan-normal-form  @ [('SandronesLibrary/LinearAlgebra/JordanNormalForm.lean', 12)]
    linear-algebra.eigen.jordan-similarity  @ [('SandronesLibrary/LinearAlgebra/JordanSimilarity.lean', 12)]
    linear-algebra.eigen.jordan-uniqueness  @ [('SandronesLibrary/LinearAlgebra/JordanUniqueness.lean', 17)]
    linear-algebra.elimination.row-reduction  @ [('SandronesLibrary/LinearAlgebra/MatrixElimination.lean', 13)]
    linear-algebra.matrix.hermitian  @ [('SandronesLibrary/LinearAlgebra/NormalMatrix.lean', 16)]
    linear-algebra.vector-space.sum-quotient  @ [('SandronesLibrary/LinearAlgebra/SubspaceSumQuotient.lean', 20)]

========================================================================
SCAN 2: .lean files with NO Entry marker (excluding Examples/)
========================================================================
Total .lean (excl Examples): 352
Files with >=1 marker:       339
Files with NO marker (13):
    SandronesLibrary/Analysis/ChangeOfVariables.lean  (76 lines)
    SandronesLibrary/Analysis/Complex.lean  (72 lines)
    SandronesLibrary/Analysis/ConstantRank.lean  (572 lines)
    SandronesLibrary/Analysis/CoordinateIntegrals.lean  (509 lines)
    SandronesLibrary/Analysis/FundamentalTheoremAlgebra.lean  (44 lines)
    SandronesLibrary/Analysis/JordanRegion.lean  (61 lines)
    SandronesLibrary/Analysis/JordanRiemannBridge.lean  (100 lines)
    SandronesLibrary/Analysis/MultivariableIntegration.lean  (61 lines)
    SandronesLibrary/Analysis/NormalDomain.lean  (380 lines)
    SandronesLibrary/Analysis/NormedAlternating.lean  (52 lines)
    SandronesLibrary/Basic.lean  (26 lines)
    SandronesLibrary/Topology/Closure.lean  (122 lines)
    SandronesLibrary/Topology/MathlibBridge.lean  (41 lines)

========================================================================
SCAN 3: Same id appearing in more than one file
========================================================================
  abstract-algebra.poly.irreducible:
      SandronesLibrary/AbstractAlgebra/Poly.lean:62
      ... (E3 窗口，本窗口未处理)
      SandronesLibrary/AbstractAlgebra/PolynomialIrreducibility.lean:195

========================================================================
SCAN 4: docs/entries/**/*.md  id: fields vs Registry
========================================================================
docs with id field: 598
orphan doc ids (NOT in Registry) (23):
    ... 11 个 E2/E3 orphan ...
    linear-algebra.coordinates.change-basis  @ ['docs/entries/linear-algebra/coordinates/change-basis.md']
    linear-algebra.decomposition.lu  @ ['docs/entries/linear-algebra/decomposition/lu.md']
    linear-algebra.eigen.diagonalization  @ ['docs/entries/linear-algebra/eigen/diagonalization.md']
    linear-algebra.eigen.jordan  @ ['docs/entries/linear-algebra/eigen/jordan.md']
    linear-algebra.eigen.jordan-block  @ ['docs/entries/linear-algebra/eigen/jordan-block.md']
    linear-algebra.eigen.jordan-decomposition  @ ['docs/entries/linear-algebra/eigen/jordan-decomposition.md']
    linear-algebra.eigen.jordan-normal-form  @ ['docs/entries/linear-algebra/eigen/jordan-normal-form.md']
    linear-algebra.eigen.jordan-similarity  @ ['docs/entries/linear-algebra/eigen/jordan-similarity.md']
    linear-algebra.eigen.jordan-uniqueness  @ ['docs/entries/linear-algebra/eigen/jordan-uniqueness.md']
    linear-algebra.elimination.row-reduction  @ ['docs/entries/linear-algebra/elimination/row-reduction.md']
    linear-algebra.matrix.hermitian  @ ['docs/entries/linear-algebra/matrix/hermitian.md']
    linear-algebra.vector-space.sum-quotient  @ ['docs/entries/linear-algebra/vector-space/sum-quotient.md']

Registry ids with NO doc id match (0):
```

> 8.2 的 orphan 列表包含 12 个线代新 id，属预期：它们的 Registry 记录由 Main 在集成时补入；
> 补入后这些 orphan 会消失，而 `[A]` 中只剩 E3 的实分析条目、`[B]` 中只剩 E2 的
> `analysis.derivative.definition`。

## 9. 11 个模块逐模块判定与证据摘要

判定方法：声明清单 + 库内导入计数 + 与已登记条目的声明级对比（非文件名/行数）。

| 模块 | 行数 | 公开标记后映射声明数 | 库内导入者 | 判定 | 关键证据 |
|---|---:|---:|---:|---|---|
| `Coordinates.lean` | 93 | 7 | 1（`Diagonalization`） | 登记 | `coordinates`/`transitionMatrix`/`operatorMatrix` 换基链条，无已登记条目覆盖；orphan 文档已存在 |
| `Diagonalization.lean` | 158 | 14 | 1（`Jordan`） | 登记 | 特征基判据、几何/代数重数、Cayley–Hamilton、最小多项式；与 `Eigenvalue.lean`（`IsDiagonalizable`/`diagonalizable_diagonal` 等）无同名或同陈述重叠 |
| `SubspaceSumQuotient.lean` | 152 | 10 | 1（`Diagonalization`） | 登记 | 子空间和/交/直和/商维数公式；已登记 `vector-space.subspace` 只含 `IsSubspace`/`span`，不含维数公式 |
| `Jordan.lean` | 612 | 36 | 1（`JordanDecomposition`） | 登记 | 广义特征空间、Jordan 链/块、链独立与幂零前置；无条目覆盖 |
| `JordanDecomposition.lean` | 468 | 1 公开（其余 `private`） | 1（`JordanMatrix`） | 登记 | 公开结论 `nilpotent_exists_jordanBasisFamily`；不变子空间机制为 private 证明后端 |
| `JordanMatrix.lean` | 93 | 2 | 1（`JordanNormalForm`） | 登记 | `operatorMatrix_eq_blockDiagonal_jordan`、`nilpotent_operator_has_jordan_matrix` |
| `JordanNormalForm.lean` | 156 | 4 | 1（`JordanSimilarity`） | 登记 | `JordanFormData`/`jordanNormalMatrix`/`HasJordanNormalBasis`/`exists_jordan_normal_basis` |
| `JordanSimilarity.lean` | 130 | 3 | 2（`MatrixSchur` **已登记模块**、`JordanUniqueness`） | 登记 | `matrix_is_similar_to_jordan`、`complex_matrix_is_similar_to_jordan`；被 `MatrixSchur.lean` 使用，退役会破坏已登记条目 |
| `JordanUniqueness.lean` | 566 | 27 | 0 | 登记 | `jordan_normal_basis_unique` 等唯一性；0 导入者不等于 superseded（叶子模块常态） |
| `MatrixElimination.lean` | 604 | 63 | 1（`MatrixDecomposition`） | 登记 | 三类初等行变换、`RowEquivalent`、`exists_rowEchelon(_with_rank)`、`rank_eq_pivot_count`；已登记 `maps.matrix-rank`/`row-rank` 只给秩，不含行阶梯化 |
| `MatrixDecomposition.lean` | 987 | 93 | 0 | 登记 | LU/LDU/PLU/规范 LU 的存在与唯一、`NoPivotCondition`、顺序主子式判据、块分解；**ROADMAP 提示的「被 MatrixSVD/MatrixSchur 取代」经声明级对比不成立**：已登记分解条目是 QR/SVD/复 Schur/Cholesky/polar/pseudoinverse，没有 LU/LDU/PLU 主元分解；`schurComplement`（Schur 补）与 `linear-algebra.decomposition.schur`（复 Schur 三角化）是不同概念 |

**退役申请数量：0。** 无模块判定为 superseded，故根 `SandronesLibrary.lean` 的 import 无需改动。

## 10. 4 个 orphan 文档判定

| 文档 id | 判定 | 依据 |
|---|---|---|
| `linear-algebra.coordinates.change-basis` | 补 Registry | 唯一对应 `Coordinates.lean` 7 声明；`provenance.ref` 由中文自由文本改为 `axler-linear-algebra-2015`，`premises` 中不存在的 `linear-algebra.maps.basic` 改为 `linear-algebra.vector-space.basis` |
| `linear-algebra.eigen.diagonalization` | 补 Registry | 唯一对应 `Diagonalization.lean` 14 声明；ref 改为 `axler-linear-algebra-2015` |
| `linear-algebra.eigen.jordan` | 补 Registry | 对应 Jordan 链基础文件 `Jordan.lean`；正文已收窄为 Jordan.lean 的 36 声明；`state: partial/foundations` 改为 `verified/textbook`；ref 改为 `horn-johnson-matrix-analysis-2013` |
| `linear-algebra.vector-space.sum-quotient` | 补 Registry | 唯一对应 `SubspaceSumQuotient.lean` 10 声明；ref 改为 `axler-linear-algebra-2015` |

四者**均未删除**。原文档 `provenance.ref` 的中文自由文本违反 AGENTS §6，本轮统一替换为
`reference.bib` 中已定义的 key；章节定位移入正文。

## 11. 子 Agent 清单、所有权、提交与退回记录

| 子 Agent | 所有权（互不重叠） | 提交 | 结果 | 负责人核实/退回 |
|---|---|---|---|---|
| `565d312e-da6d-40ed-8da3-cf662761dc5e` | `docs/entries/linear-algebra/eigen/` 下 7 文件：`diagonalization.md`（编辑）、`jordan.md`（重写）、`jordan-decomposition.md`、`jordan-block.md`、`jordan-normal-form.md`、`jordan-similarity.md`、`jordan-uniqueness.md`（新建） | 由负责人并入 `8f72938` | 交付 7 文件 | 全部 7 份逐一阅读核实：front matter 合规、premises 为 Entry id、引用的 Mathlib 名在源码中确认。**退回记录：无返工**。子 Agent 主动纠正了我 prompt 中把 `JordanDecomposition.lean` 的 private 机制误称为 public 的说法，并按源码如实写成 private；该纠正正确，负责人采纳 |
| `9350a4fb-f31f-4e8a-bb4e-ac35bf6c0e41` | `docs/entries/linear-algebra/` 下 5 文件：`coordinates/change-basis.md`、`vector-space/sum-quotient.md`（编辑）；`matrix/hermitian.md`、`decomposition/lu.md`、`elimination/row-reduction.md`（新建） | 由负责人并入 `494e7f2`/`8f72938` | 交付 5 文件 | 全部逐一阅读核实。**退回记录：无返工**。其 `mathlib` 字段偏离我给的示例（发现 `Matrix.blockDiagonal'`/`Matrix.rank_eq_finrank_span_cols` 未在该源码使用），改用源码中真实使用的名字；负责人用 `grep` 复核，偏离正确，采纳 |

两个子 Agent 均声明**未运行任何 `git` 写命令、未运行 `lake`、未改任何 `.lean`、未越界写文件**；
负责人现场 `git status` 与文件审阅未发现越界。单写者资源（git index、`.lake/build`）只由负责人串行使用。

## 12. 诚实边界与未完成项

- **未运行全库 `lake build`**；只跑了线代依赖闭包（8728 jobs）。全库生成器、全量公理审计、
  `audit.py` 和全库 build 由 Main 执行。
- **Registry 未更新**：12 条新记录、`dimension` 的 `proof_sha`/`summary`、`matrix.normal` 的
  `summary`/`premises` 都在 §6，由 Main 更新。因此当前现场 `docs/entries` 的线代新 id 仍是
  orphan（预期），`check_axioms.py` 尚未对本窗口新条目做全量审计。
- **Jordan 链按文件拆为 6 个 Entry**是低风险路径；若 Main 认为 Jordan 全链应作为**单一**
  Entry，则需先做跨 6 文件的合并重构（属 M2，超出本登记维护窗口）。本窗口未做合并。
- **`linear-algebra.vector-space.dimension` 的语义收窄**：补证定理带有限维假设，比原
  Registry summary 的无限定措辞更强（更准确）。若 Main 认为这构成语义变化，应按 M3 重新
  评估，但本窗口判定为对原条目声称内容的**如实落地**（原条目 `mathlib` 字段本就引用了带
  `[Module.Finite]` 的 `Module.finrank_zero_iff`）。
- **未处置的 E2/E3 债务**：`abstract-algebra.poly.irreducible` 跨文件 id、
  `real-analysis.riemann.cont-integrable`、`analysis.derivative.definition`、Analysis 10 模块、
  `Topology/Closure.lean`、11 个非线代 orphan 文档——均不在本窗口文件所有权内。
- **未做**：`reference.bib`、RADAR、ROADMAP、根 import、派生索引的任何修改（Main 共享文件）。
- 磁盘全程约 11G 可用，未低于 3G 阈值；未跑 `lake update`/`lake exe cache get`，未删除
  worktree 外文件。

## 13. 建议的 Main verdict 依据

数学与定义层：幽灵 Entry 已补真实证明并通过线代闭包编译；跨文件 id 已按「一 id 一文件」拆分；
11 模块经声明级对比全部判定为内容唯一并补登记，无退役。剩余工作全部是 Main 共享文件
（Registry/生成器/RADAR/ROADMAP），因此建议 `accepted_main_docs`。
