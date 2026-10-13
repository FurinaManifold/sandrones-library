# Linear Algebra 登记完整性维护 RFC（Wave E1）

- 维护分支：`codex/linear-algebra-maintenance`
- worktree：`/home/pisquare/czt/sandrones-library-linear-algebra`
- 基线 Main：`52021fe`（ROADMAP 记 `c58dd2f`；本 worktree 起点为 `52021fe`）
- 角色：学科维护负责人（`docs/roles/SUBJECT-MAINTENANCE-ROLE.md`）
- 范围：ROADMAP Wave E §「E1 线性代数」四组缺陷，权限「维护 🚧」
- 本文档在修改任何源码之前完成，记录只读影响图与逐项裁决。

本轮**不处理**：Registry/RADAR/ROADMAP/`SandronesLibrary.lean` 等共有文件（仅写建议）；
`abstract-algebra.poly.irreducible` 跨文件 id（E3 窗口）；`real-analysis.riemann.cont-integrable`
（E3 窗口）；Analysis/Topology 的 10+2 个无标记模块（E2/E3 窗口）。

---

## 0. 只读影响图（现场重跑，脚本原文见 handoff §验证）

判据脚本：`/tmp/verify_registry_integrity.py`（本 RFC 作者现场重跑，未采信任何二手数字）。
现场结果（节选，全文见 handoff）：

- Registry 条目 575；Lean 标记 id 574。
- 双向差集 **[A] Registry 无标记**：`linear-algebra.vector-space.dimension`（本窗口）、
  `real-analysis.riemann.cont-integrable`（E3）；**[B] 标记无 Registry**：`analysis.derivative.definition`（E2）。
- 无标记 `.lean`（排除 `Examples/`）24 个：其中 LinearAlgebra 11 个（本窗口）、
  Analysis 10 个、`Basic.lean` / `Topology/MathlibBridge.lean`（基础设施）、`Topology/Closure.lean`。
- 跨文件 id：`linear-algebra.matrix.normal`（`NormalSpectral.lean:16` + `NormalMatrix.lean:16`）、
  `abstract-algebra.poly.irreducible`（E3）。
- orphan 文档 id 15 个：本窗口 4 个（其余属 E2/E3）。

### 0.1 直接引用者（库内 import 计数）

对 11 个无标记模块与 `NormalMatrix.lean` 做全库 import 扫描（`SandronesLibrary/**/*.lean`）：

| 模块 | 行数 | 库内导入者 | 导入者 |
|---|---:|---:|---|
| `Coordinates.lean` | 93 | 1 | `Diagonalization.lean` |
| `Diagonalization.lean` | 158 | 1 | `Jordan.lean` |
| `SubspaceSumQuotient.lean` | 152 | 1 | `Diagonalization.lean` |
| `Jordan.lean` | 612 | 1 | `JordanDecomposition.lean` |
| `JordanDecomposition.lean` | 468 | 1 | `JordanMatrix.lean` |
| `JordanMatrix.lean` | 93 | 1 | `JordanNormalForm.lean` |
| `JordanNormalForm.lean` | 156 | 1 | `JordanSimilarity.lean` |
| `JordanSimilarity.lean` | 130 | 2 | `MatrixSchur.lean`（**已登记模块**）、`JordanUniqueness.lean` |
| `JordanUniqueness.lean` | 566 | 0 | — |
| `MatrixElimination.lean` | 604 | 1 | `MatrixDecomposition.lean` |
| `MatrixDecomposition.lean` | 987 | 0 | — |
| `NormalMatrix.lean` | 89 | 1 | `NormalSpectral.lean`（持有 `linear-algebra.matrix.normal`） |

全部 12 个模块均被根 `SandronesLibrary.lean` 导入，参与全库构建。
**跨学科使用者计数：0**（在 `SandronesLibrary/` 非 `LinearAlgebra/` 目录中无任何 import）。
RADAR 中 `Module.finrank*` 的「谁在用」写作 `linear-algebra.vector-space.def/basis/dimension`
（`docs/MATHLIB-RADAR.md:1261`），`Matrix.IsHermitian.*` 的「谁在用」写作
`linear-algebra.matrix.normal` 的 Hermitian 酉对角化（`:2649`）。

### 0.2 隐式影响（typeclass / notation / simp / 实例搜索 / 前提边）

- 本窗口所有变更均**不新增、不删除、不改名任何公开声明**（幽灵 Entry 除外，见 §1），
  因此 typeclass 实例搜索、notation 展开、simp 属性集、导入闭包**不受影响**。
- 幽灵 Entry 补证新增两个 `lemma`，均为 `Prop`，不产生实例、不注册 simp 属性，
  不会被任何现有证明隐式使用。
- 前提边：`linear-algebra.maps.rank-nullity` 的 `premises` 含
  `linear-algebra.vector-space.dimension`，其 `dependedOnBy` 反向缓存也是该条。
  补证后该前提成立，无需改前提。新增的 `linear-algebra.matrix.hermitian`
  将成为 `linear-algebra.matrix.normal` 的真实前提（`NormalSpectral.lean` import `NormalMatrix.lean`）。
- 别名/间接暴露：`LinearMap.lean:96` 的 `rank_add_nullity` 直接 `unfold
  LinearAlgebra.VectorSpace.dim`，只用 `dim` 别名，不依赖幽灵条目的两条定理；
  补证不改变其签名或证明。

---

## 1. 幽灵 verified Entry：`linear-algebra.vector-space.dimension`

### 现状与准确定位

- Registry：`state: verified`，`lean_file: LinearAlgebra/VectorSpace.lean`，
  `premises: []`，`dependedOnBy: [linear-algebra.maps.rank-nullity]`，
  `mathlib: [Module.finrank_eq_rank, Module.finrank_zero_iff]`，
  `proof_sha: 56ab6cfe20365847`（**陈旧**：当前 `VectorSpace.lean` 的 SHA-16 为
  `cfcb0219e1ceffaf`，与其同文件另 4 条 Entry 一致，唯 `dimension` 不同）。
- 文档：`docs/entries/linear-algebra/vector-space/dimension.md`，与 Registry 同步。
- 源码：`VectorSpace.lean` 只有 4 个标记（`def`×2 于 `:70,:77`、`independent` 于 `:85`、
  `basis` 于 `:96`），**无 `dimension` 标记、无对应声明**。第 21 行文件头仍把
  `dimension` 列为「本文件当前条目」，即声明被移除后文件头与 Registry 均未同步。
- 全库 `finrank_eq_rank` 涉及本库的使用为零；`dim` 别名本身存在（`:52`
  `noncomputable abbrev dim := Module.finrank`），但条目声称的两条定理不存在。
- 后果：`check_axioms.py` 对该条 SKIP（「lean 文件未关联到带 **Entry** 标记的定理」）；
  `rank-nullity` 的 `premises` 悬空指向不存在的定理。

### 归类

条目声称内容属于**本库教材薄包装**：`dim` 是本库记号的 `Module.finrank` 别名，
两条定理是对 `Module.finrank_zero_iff`／`Module.finrank_eq_rank` 的教材层转写。

### 裁决：**补证（选项 i）**，定级 **M1**（新增定理、旧接口全保留）

不选撤登记，理由：`dim` 别名是 L1 课程公开接口，且 `rank-nullity` 在 Lean 中确实经
`LinearAlgebra.VectorSpace.dim` 记账；撤登记会留下一个真实使用中的 `dim` 概念没有 Entry，
并需改写 `rank-nullity.premises`。补证成本低且能恢复条目与源码一一对应。

**已现场验证可编译的真实证明**（`lake env lean`，见 handoff 验证）：

```lean
lemma dim_eq_zero_iff_subsingleton [Field 𝕜] [AddCommGroup V] [LinearSpace 𝕜 V]
    [IsFiniteDimensional 𝕜 V] : dim 𝕜 V = 0 ↔ Subsingleton V := by
  unfold dim IsFiniteDimensional at *
  exact Module.finrank_zero_iff

lemma dim_eq_rank [Field 𝕜] [AddCommGroup V] [LinearSpace 𝕜 V]
    [IsFiniteDimensional 𝕜 V] : (dim 𝕜 V : Cardinal) = Module.rank 𝕜 V := by
  unfold dim
  exact Module.finrank_eq_rank 𝕜 V
```

**诚实边界（必须在 Registry summary／文档写明并被 Main 采纳）**：v4.33 的
`Module.finrank_zero_iff` 需要 `[StrongRankCondition 𝕜] [Module.Finite 𝕜 V]`，
而 Mathlib 把无限维空间的 `finrank` 约定为 0。因此「`dim V=0 ⟺ Subsingleton V`」
**只在有限维成立**；条目原 summary 漏掉该限定。本轮在原 summary 的「有限维」措辞上
补齐零维部分，建议 Main 将 Registry summary 改为：
「有限维时 dim V=0 当且仅当 V 是平凡空间；dim 与秩（基数）一致」。
`mathlib` 列表不变（两条 Mathlib 名称均已核对存在）。

**`rank-nullity.premises` 处理**：补证后前提有效，**无需修改**
（若未来改为撤登记，则须改为 `linear-algebra.vector-space.basis` 或新增 `dim` 定义条目——
本轮不采用该分支）。

---

## 2. 跨文件 id：`linear-algebra.matrix.normal`

### 现状

- Registry：`lean_file: LinearAlgebra/NormalSpectral.lean`，
  summary「三类复矩阵、Hermitian-斜Hermitian分解及一般正规矩阵酉谱定理」，
  `premises: [linear-algebra.matrix.orthogonal-unitary, linear-algebra.spectral-quadratic]`。
- 标记同时出现在 `NormalMatrix.lean:16` 与 `NormalSpectral.lean:16`。
- 内容分布：
  - `NormalMatrix.lean`：`IsNormalMatrix`/`IsHermitianMatrix`/`IsSkewHermitianMatrix` 定义，
    `hermitian_is_normal`、`skewHermitian_is_normal`、`hermitianPart`/`skewHermitianPart`
    及其性质、`hermitian_unitary_diagonalization`（Hermitian 矩阵酉对角化）。
  - `NormalSpectral.lean`：`normal_unitary_diagonalization`（一般复正规矩阵酉谱定理）
    及其私有辅助证明；它 **import `NormalMatrix.lean`**，即语法上依赖前者的定义。
- 影响：`gen_entry_rankings.py` 的 Lean 使用扫描把两个文件的声明并到同一条目
  （ROADMAP D-4(f) 已记录该歧义使 `lean_usage_files` 由 0 变 1）；
  `check_axioms.py` 只读 `lean_file=NormalSpectral.lean`，正文却跨两文件，两种读法不一致。
- 直接引用者/跨学科使用者：`NormalSpectral.lean` 仅被根导入；无其他学科使用。

### 裁决：**拆开**，定级 **M3（新 Entry id）+ M0（原条目仅删冗余标记）**

- 原 id `linear-algebra.matrix.normal` **保留在 `NormalSpectral.lean`**，语义收窄为
  「一般复正规矩阵的酉谱定理」；`lean_file` 与 `proof_sha` 不变（Main 无需改这两字段）。
- 删除 `NormalMatrix.lean:16` 的旧标记，另立新 Entry id
  **`linear-algebra.matrix.hermitian`**，`lean_file: LinearAlgebra/NormalMatrix.lean`，
  承载三类矩阵定义、Hermitian/斜 Hermitian 分解与 Hermitian 酉对角化。
- 新条目文档：`docs/entries/linear-algebra/matrix/hermitian.md`（本轮新建）。
- 原条目文档 `docs/entries/linear-algebra/matrix/normal.md` 收窄 summary/正文，
  并在 `premises` 增加 `linear-algebra.matrix.hermitian`（真实 import 依赖）。
- `old_iff_new`：原条目没有改变任何 Lean 声明，只是把**本就不属于其 `lean_file`** 的
  标记归位，故新条目是「登记层新增」，不需要 `old_iff_new` 桥；语义不存在迁移。
- **M3 说明**：按 ROLE，另立 id 一律按 M3 处理。此 M3 是**登记 id 层的语义拆分**
  （一个被错误合并的概念拆成两个概念），不涉及任何现有 Lean 签名改动，因此不需要
  M2 三阶段双轨；回滚点即本 RFC 提交，回退单个 marker + doc 即可。

---

## 3. 11 个无标记模块：逐模块裁决

判定方法（禁用按文件名/行数猜）：对每个模块列出公开声明清单，与已登记条目
（`linear-algebra.decomposition.{svd,schur,qr,polar,cholesky,pseudoinverse}` 对应
`MatrixSVD/MatrixSchur/MatrixQR/MatrixPolar/MatrixCholesky/MatrixPseudoinverse`、
`linear-algebra.eigen.*` 对应 `Eigenvalue.lean`、`linear-algebra.vector-space.*`
对应 `Subspace.lean`/`VectorSpace.lean`）做**声明级对比**，并结合库内导入计数。

### 结论总表

| 模块 | 声明数 | 依赖现成 Entry？ | 已有 orphan 文档 | 裁决 | 定级 |
|---|---:|---|---|---|---|
| `Coordinates.lean` | 7 | 否（换基/坐标未被任何条目承载） | `coordinates.change-basis` | **登记** | M1 |
| `Diagonalization.lean` | 14 | 部分相邻（`eigen.similar-diagonal`）但声明无重叠 | `eigen.diagonalization` | **登记** | M1 |
| `SubspaceSumQuotient.lean` | 10 | 否（和/交/直和/商维数公式未登记） | `vector-space.sum-quotient` | **登记** | M1 |
| `Jordan.lean` | 36 | 否 | `eigen.jordan` | **登记** | M1 |
| `JordanDecomposition.lean` | 14 | 否 | 无 | **登记** | M1 |
| `JordanMatrix.lean` | 2 | 否 | 无 | **登记** | M1 |
| `JordanNormalForm.lean` | 4 | 否 | 无 | **登记** | M1 |
| `JordanSimilarity.lean` | 4 | 否；且被 `MatrixSchur.lean` 使用 | 无 | **登记** | M1 |
| `JordanUniqueness.lean` | 27 | 否 | 无 | **登记** | M1 |
| `MatrixElimination.lean` | 64 | 否（行化简/行阶梯未被承载） | 无 | **登记** | M1 |
| `MatrixDecomposition.lean` | 93 | 否（LU/LDU/PLU 未被 QR/SVD/Schur 承载） | 无 | **登记** | M1 |

**没有任何一个模块判为 superseded**，因此本轮**不提交任何退役申请**。证据摘要：

- `MatrixDecomposition.lean`（ROADMAP 提示「很可能已被取代」）：声明级对比显示其核心
  `LDUFactorization`/`LUFactorization`/`PLUFactorization`/`NoPivotCondition`/
  `NormalizedLUFactorization`/`existsPLU`/`lu_unique`/`ldu_unique` 等属于 **LU/LDU/PLU
  主元分解**，而 `linear-algebra.decomposition.schur`（`MatrixSchur.lean`）是**复 Schur
  三角化**、`MatrixQR`/`MatrixSVD`/`MatrixCholesky` 分别是 QR/SVD/Cholesky；
  注册条目集中在 `LDL_*`（Cholesky 前置），与 LU/LDU/PLU 是不同算法层。名称相似
  （`schurComplement` vs Schur 分解）不构成替代。库内导入者 0 与
  `MatrixCholesky`/`MatrixPseudoinverse` 同为 0，属「叶子模块」常态，不能据此判退役。
- `MatrixElimination.lean`：提供 `swapRows`/`addRowMultiple`/`scaleRow`、`IsRowEchelon`、
  `RowEquivalent` 与 `rank_eq_pivot_count`/`exists_rowEchelon`；已登记的
  `linear-algebra.maps.matrix-rank`/`row-rank`（`LinearMap.lean`）只给 `Matrix.rank`
  与列/转置秩，不含行阶梯化或行变换秩不变性。内容唯一。
- Jordan 链 6 文件：`exists_jordan_normal_basis`（代数闭域）、
  `matrix_is_similar_to_jordan`/`complex_matrix_is_similar_to_jordan`、
  `jordan_normal_basis_unique` 等构成完整的 Jordan 标准形存在与唯一性，无任何已登记条目覆盖；
  `JordanSimilarity.lean` 还被**已登记模块** `MatrixSchur.lean` 导入，不能退役。
- `Coordinates.lean`/`Diagonalization.lean`/`SubspaceSumQuotient.lean`：
  与 Eigenvalue/Subspace 声明清单无同名或同陈述重叠；三者的 orphan 文档已给出教材陈述。

### Jordan 链的文件级 Entry 拆分（一个 id 只对应一个 Lean 文件）

`eigen/jordan.md` 单文档覆盖 6 个文件，违反「一个 Entry id 只对应一个 Lean 文件」。
本轮按文件拆为 6 个 id（沿用既有 `linear-algebra.eigen.jordan` 给基础文件，其余另立）：

| Lean 文件 | Entry id |
|---|---|
| `Jordan.lean` | `linear-algebra.eigen.jordan`（沿用现有 orphan 文档） |
| `JordanDecomposition.lean` | `linear-algebra.eigen.jordan-decomposition` |
| `JordanMatrix.lean` | `linear-algebra.eigen.jordan-block` |
| `JordanNormalForm.lean` | `linear-algebra.eigen.jordan-normal-form` |
| `JordanSimilarity.lean` | `linear-algebra.eigen.jordan-similarity` |
| `JordanUniqueness.lean` | `linear-algebra.eigen.jordan-uniqueness` |

`eigen/jordan.md` 正文改写为只描述 `Jordan.lean` 的声明；其余 5 文件各建新文档。
原文档 `state: partial` 与「6 文件全链」不一致：现场 6 文件无 `sorry`/`admit`/`native_decide`，
完整存在性与唯一性定理均以真实证明给出，故新文档统一记 `state: verified`。
（若 Main 认为 Jordan 全链应作为单一 Entry，则需先做跨 6 文件的合并重构，属 M2，
不在本登记维护窗口内；本轮采用低风险的文件级拆分。）

---

## 4. 4 个 orphan 文档

| 文档 id | 判定 | 依据 |
|---|---|---|
| `linear-algebra.coordinates.change-basis` | **未登记但内容有效 → 建议补 Registry** | 唯一对应 `Coordinates.lean` 的 7 个声明；教材陈述完整 |
| `linear-algebra.eigen.diagonalization` | **未登记但内容有效 → 建议补 Registry** | 唯一对应 `Diagonalization.lean` 的 14 个声明；与 Eigenvalue 无重叠 |
| `linear-algebra.eigen.jordan` | **未登记但内容有效 → 建议补 Registry** | 对应 Jordan 链基础文件；正文收窄为 `Jordan.lean` |
| `linear-algebra.vector-space.sum-quotient` | **未登记但内容有效 → 建议补 Registry** | 唯一对应 `SubspaceSumQuotient.lean` 的 10 个声明 |

四者均**不删除**。共同缺陷：`provenance.ref` 写成中文自由文本
（如「本科线性代数：坐标变换…」），违反 AGENTS §6「只存 `reference.bib` 的 citation key」。
本轮统一改成本库已有合规键：核心概念用 `axler-linear-algebra-2015`，
矩阵分解/Jordan 用 `horn-johnson-matrix-analysis-2013`；旧 `variant`/`kind` 保持，
`state` 统一为 `verified`（与 Registry 现状一致）。章节定位移入正文。

---

## 5. M0–M3 汇总、迁移波次与回滚点

| 项 | 定级 | 迁移波次 | 回滚点 |
|---|---|---|---|
| 幽灵 Entry 补证 | M1 | 单阶段：加声明＋标记＋文档 | 删除两条 lemma 与标记，文档回退 |
| 跨文件 id 拆分（原条目删除冗余标记） | M0 | 单阶段（仅删 `NormalMatrix.lean` 标记） | 恢复该标记 |
| 新 id `linear-algebra.matrix.hermitian` | M3 | 单阶段：加标记＋新文档 | 删标记与新文档 |
| 11 模块补登记 | M1 | 单阶段：逐文件加标记；新文档 | 逐文件删标记/文档 |

**本窗口无 M2**：没有任何现有公开签名被改名、迁移或删除；不存在双轨兼容需求，
故不启动 M2 三阶段。所有变更均为**新增标记/新增文档/新增定理**或**删除冗余标记**。

**删除旧接口条件**：本窗口不删除任何旧接口，退役申请数量为零。

---

## 6. 本轮不处理

- 共有文件（`index/registry.json`、`SandronesLibrary.lean`、`docs/MATHLIB-RADAR.md`、
  `docs/ROADMAP-*.md`、`docs/entries/README.md`、`docs/entries/RANKINGS.md`、
  `index/rankings.json`、`reference.bib`、`README.md`、`AGENTS.md`、`scripts/**`）：
  只在 handoff 给建议。
- `abstract-algebra.poly.irreducible` 跨文件 id、`real-analysis.riemann.cont-integrable`、
  `analysis.derivative.definition`（E2/E3 窗口）。
- Analysis 10 个与 `Topology/Closure.lean` 无标记模块、15 个 orphan 文档中非线代的 11 个。
- 基础设施 `Basic.lean`、`Topology/MathlibBridge.lean` 的排除规则（E3 判定）。
- 全库 `lake build`、生成器、公理/audit 全量重跑（Main 职责）。
