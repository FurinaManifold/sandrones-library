# Handoff: commutative-algebra-ca1b2（CA1 第二批：生成子模 / 商模 / 同构定理 / 直和）

- 学科：交换代数（commutative-algebra）
- 批次：CA1b2（ROADMAP §13.1 CA1 表第 2–5 行；窗口简令 `docs/dispatch/e1-ca-b2.md`）
- 分支：`codex/commutative-algebra-b2`
- worktree：`/home/pisquare/czt/sandrones-library-ca-b2`
- 基线：`bc8d4feb59f639aa440d7719466297d918e9dd28`（已同步 Main；`.lake/packages` 软链到主工作树）
- 角色：`subject-maintainer`（本批派 2 个子 Agent，负责人亲自做 quotient + isomorphism-theorems）
- 交付状态：源码、叙述层、pack、trace、handoff 均已提交；**未 push、未建 PR、未删 worktree**
- 未触碰 Main 共享文件（`git diff --name-only` 对只读清单为空；见 §2 实测命令）

## 1. 范围

交付 **4 条 Entry**（简令 §1 列 3 条；第 4 条 `isomorphism-theorems` 由简令 §9 手写残量
「出口条件」第 3、4 条点名，要求 quotient 验收通过后开工、pack 由负责人按 §10.3 生成）。

| Entry id | 内容 | Lean 文件 | 行数 | 声明数 | 叙述层 | 行数 |
|---|---|---|---|---|---|---|
| `commutative-algebra.module.generated` | 子集生成子模及最小性 | `SandronesLibrary/CommutativeAlgebra/Module/Generated.lean` | 228 | 15 | `docs/entries/commutative-algebra/module/generated.md` | 369 |
| `commutative-algebra.module.quotient` | 商模、自然投影与商映射泛性质 | `…/Module/Quotient.lean` | 216 | 18 | `…/module/quotient.md` | 338 |
| `commutative-algebra.module.direct-sum` | 内外直和及分解判据 | `…/Module/DirectSum.lean` | 387 | 22 | `…/module/direct-sum.md` | 513 |
| `commutative-algebra.module.isomorphism-theorems` | 模的三大同构定理 | `…/Module/IsomorphismTheorems.lean` | 292 | 22 | `…/module/isomorphism-theorems.md` | 391 |

未修改：`SandronesLibrary.lean`、`index/registry.json`、`index/rankings.json`、`reference.bib`、
`docs/entries/README.md`、`docs/entries/RANKINGS.md`、`docs/MATHLIB-RADAR.md`、
`docs/ROADMAP-*.md`、`docs/LEAN-PLAYBOOK.md`、`README.md`、`AGENTS.md`、`scripts/**`、
`docs/subject-packages/**`、`docs/releases/**`、`docs/world-formula/**`、`docs/dispatch/**`。
未实现 `scope.out_of_scope` 的任何条目（CA2 十条：finite-generation / free / exact-sequence /
projective / injective / flat 等一条未碰）。

## 2. 提交与清洁度

| commit | 内容 |
|---|---|
| `f6d1b3d` | CA1b2 派工上下文包 6 个（3 个负责人 pack + 3 个子 Agent pack）+ 负责人侦察 trace（6 条） |
| （见 §2.1 回填） | 4 个 Lean 源文件 + 4 篇叙述层 + 6 条 trace jsonl + 本 handoff |

工作区清洁度实测：

```
$ git status --short                     # 交付前为空（全部已提交）
$ git diff --check                       # 无输出
$ git diff --name-only HEAD -- SandronesLibrary.lean index/ reference.bib \
    docs/entries/README.md docs/entries/RANKINGS.md docs/MATHLIB-RADAR.md \
    docs/ROADMAP-LONGTERM.md docs/LEAN-PLAYBOOK.md README.md AGENTS.md scripts/ \
    docs/subject-packages/ docs/releases/ docs/world-formula/ docs/dispatch/
                                         # 无输出（未触碰任何只读路径）
```

## 3. 冻结的核心概念清单（AGENTS §4 六条）

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 角色 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|---|
| 子集生成的子模 `⟨S⟩` | 全体含 `S` 的子模之交，即含 `S` 的最小子模（A–M 第 2 章） | `Submodule.span R s` | 最小性四张脸：`mem_span_iff`（元素层）、`span_le_iff_subset`（序层）、`span_eq_iff_subset_and_le`（最小子模形式，**本库自证**）、`span_eq_sInf`（交形式，本版为定义展开 `rfl`）；归纳原理 `span_induction` | 语义一致的**正式公开承载**（`#print Submodule.span` 实测定义体就是 `sInf {p | s ⊆ ↑p}`） | `map_span`（`F(⟨s⟩) = ⟨F '' s⟩`） | `…module.generated` |
| 商模 `M/P` | 以陪集为元素、按代表元定义运算的模 | 商类型 `M ⧸ p` + `Submodule.Quotient.module` | `quotient_mk_eq_iff`（陪集判等）、`quotient_mk_eq_zero_iff`、`quotient_mk_add`/`_smul`（良定义） | 语义一致的**正式公开承载**。披露：`#check @Submodule.Quotient` 实测 `Unknown constant`——它是**命名空间**不是结构 | `first_iso`（第一同构定理的域） | `…module.quotient` |
| 自然投影 π | `x ↦ x + P` | 两个层次：`Submodule.Quotient.mk`（函数）/ `Submodule.mkQ`（线性映射） | `mkQ_apply_mk` 把两层接起来；`mkQ_ker`（`ker π = p`）、`mkQ_range`、`mkQ_surjective` | 语义一致的**正式公开承载**（两层都在公开签名里，这正是本条目的解释点） | `quotient_liftQ_comp_mkQ`、三条同构定理 | `…module.quotient` |
| 商映射的泛性质 | `f` 能下降 ⟺ `P ⊆ ker f`，且下降映射唯一 | `Submodule.liftQ` | **`quotient_liftQ_exists_unique`**：`(∃! g, g.comp p.mkQ = f) ↔ p ≤ ker f`（**本库自证**，Mathlib 只给存在性 + 交换性） | 语义一致的**正式公开承载**（`liftQ`）+ 本库补的**存在唯一打包** | `firstIsoHom`、`thirdIsoMap`、`first_iso` | `…module.quotient` |
| 内直和（两项） | `M = p ⊕ q`：`p + q = M` 且 `p ∩ q = 0` | `IsCompl p q`（**序论**谓词，非 `Submodule` 专用） | `isCompl_iff_disjoint_sup_eq_top`（展开）、**`isCompl_iff_existsUnique_decomposition`**（分解判据：`IsCompl p q ↔ ∀ x, ∃! yz : p × q, yz.1 + yz.2 = x`，**双向自证**） | 语义一致的**正式公开承载** | `prodEquivOfIsCompl_apply`（重组映射 `(y,z) ↦ y+z`） | `…module.direct-sum` |
| 外直和 `⨁ i, M i` | 有限支撑族 | `DirectSum ι M`（底层 `DFinsupp`） | `directSum_of_apply_same`/`_of_ne`（坐标）、`directSum_component_apply` | 语义一致的**正式公开承载** | `directSum_existsUnique_toModule`（泛性质存在唯一） | `…module.direct-sum` |
| 外直和的泛性质 | 给定 `φ i : M i →ₗ N`，存在唯一 `g` 使 `g ∘ ι i = φ i` | `DirectSum.toModule` + `DirectSum.lof` | `directSum_toModule_lof`（存在半）+ **`directSum_toModule_unique`**（唯一性半，**本库自证**：`DirectSum.toModule_unique` 实测不存在）+ `directSum_lof_ext_iff`、`directSum_existsUnique_toModule` | 语义一致的**正式公开承载** + 本库补的唯一性半 | 同上 | `…module.direct-sum` |
| 族版本内直和 | `M` 分解为各 `ℳ i` 的直和 | `DirectSum.Decomposition ℳ`（**带数据的类**，公开出现在签名里） | `internalDirectSum_decomposeLinearEquiv`（桥 `M ≃ₗ ⨁ i, ℳ i`）、`internalDirectSum_decompose_of_mem_same`/`_ne`（分量刻画） | 语义一致的**正式公开承载**（教材「分解」二字所指的正是这份数据；用 `Nonempty` 折回命题以免把「结构存在」当「性质成立」） | `isCompl_iff_nonempty_decomposition_fin_two`（两项情形双向等价） | `…module.direct-sum` |
| 第一同构定理 | `M / ker f ≅ im f` | `first_iso f : (M ⧸ ker f) ≃ₗ[R] LinearMap.range f` | 四步证明链：`firstIsoHom`（构造）→ `firstIsoHom_ker`（`ker = ⊥`）→ `firstIsoHom_injective`/`_surjective` → `LinearEquiv.ofBijective` 组装；`first_iso_mk` 取值引理 | 语义一致的**正式公开承载**（`liftQ`/`codRestrict`/`ofBijective`）。**不引用** Mathlib 的 `LinearMap.quotKerEquivRange` | `first_iso_of_surjective` | `…module.isomorphism-theorems` |
| 第二同构定理 | `(S+T)/T ≅ S/(S∩T)` | `second_iso S T : (↥S ⧸ comap S.subtype T) ≃ₗ[R] (↥(S ⊔ T)) ⧸ comap (S ⊔ T).subtype T` | 四步证明链：`secondIsoHom` → `secondIsoHom_ker` → `secondIsoMap`（`liftQ` 下降）→ `secondIsoMap_ker`（`ker_liftQ_eq_bot`）/`secondIsoMap_surjective`（`mem_sup` 拆解）→ 组装；`second_iso_mem_comap_iff` 是教材 `S ∩ T` 与 Lean `comap S.subtype T` 的翻译引理 | 语义一致的**正式公开承载**。**不引用** `LinearMap.quotientInfEquivSupQuotient` | `second_iso_mk` | `…module.isomorphism-theorems` |
| 第三同构定理 | `(M/S)/(T/S) ≅ M/T`（`S ≤ T`） | `third_iso h : ((M ⧸ S) ⧸ T.map S.mkQ) ≃ₗ[R] M ⧸ T` | 四步证明链：`factor_ker`（`ker (M/S → M/T) = T/S`，**自证**）→ `thirdIsoMap` → `thirdIsoMap_ker`/`_surjective` → 组装；`third_iso_mk_mk` 取值引理 | 语义一致的**正式公开承载**。**不引用** `Submodule.quotientQuotientEquivQuotient` / `…Aux` | `third_iso_mk_mk` | `…module.isomorphism-theorems` |

## 4. 公开签名四类归属（逐 Entry 摘要，详见各叙述层「Mathlib 角色分类」节）

1. **语义一致的正式公开承载**：
   `Submodule.span`、`Submodule.map`（generated）；`M ⧸ p`、`Submodule.Quotient.mk`、
   `Submodule.mkQ`、`Submodule.liftQ`、`Submodule.factor`、`Submodule.quotEquivOfEqBot`（quotient）；
   `IsCompl`/`Disjoint`/`Codisjoint`、`DirectSum`/`of`/`lof`/`toModule`/`component`、
   `DirectSum.Decomposition`、`DirectSum.IsInternal`、`Submodule.prodEquivOfIsCompl`（direct-sum）；
   `Submodule.inclusion`、`Submodule.comap`、`Submodule.map`、`LinearMap.codRestrict`、
   `LinearEquiv.ofBijective`（isomorphism-theorems）。
2. **本库特殊定义的桥**：**四条 Entry 全部为空**。四条都不定义新结构或新谓词：
   `⟨S⟩`/`M ⧸ p`/内直和/三条同构定理的教材语义与 Mathlib 承载逐条一致，没有「本库记号 ↔
   Mathlib 结构」意义上的桥。（`second_iso_mem_comap_iff` 是教材记号与 Mathlib 记号之间的
   翻译引理，两端都是 Mathlib 的 `Submodule`，不算第 2 类。）
3. **私有证明后端**：逐条列在各叙述层（合计约 90 个名字）。要点：
   `Submodule.mkQ_apply`、`Submodule.ker_mkQ`、`Submodule.range_mkQ`、`Submodule.liftQ_apply`、
   `Submodule.liftQ_mkQ`、`Submodule.linearMap_qext`、`Submodule.factor_mk`、
   `Submodule.Quotient.eq`/`induction_on`/`mk_eq_zero`、`Submodule.ker_liftQ_eq_bot`、
   `Submodule.mem_sup`、`Submodule.disjoint_def`、`DirectSum.toModule_lof`、
   `DirectSum.induction_on`、`DirectSum.isInternal_submodule_iff_isCompl`、
   `DirectSum.IsInternal.chooseDecomposition`、`Submodule.span_le`、`Submodule.span_induction`、
   `Submodule.map_le_iff_le_comap`、`Submodule.mem_map_of_mem`。
4. **超出课程层级的公开泄漏**：**无**。四条 Entry 专门复核的可疑点均已排除并写进叙述层：
   (i) `RingHomSurjective`——`Submodule.map_span` 的半线性形式带显式该假设，本批全部冻结在
   线性形式 `M →ₗ[R] N`，`RingHomSurjective (RingHom.id R)` 由类型类合成自动提供、不进公开签名；
   (ii) `Subsingleton`/`Nontrivial`（quotient 的极端情形）——教材「`M/M = 0`」的标准载体；
   (iii) `↥S`（子类型模结构，第二同构定理）——教材「把子模本身看成模」的正式承载；
   (iv) `[DecidableEq ι]`（direct-sum 外直和块）——技术性可判定性假设，非数学概念；
   (v) `Fin 2` 与 `![p, q]`——「两项」指标集的写法，未引入新概念；
   (vi) `sInf`/`⊔`/`⊓`（generated/direct-sum）——教材「交 / 和」的正式承载。

## 5. 定义链聚合 `#check` 与公理（真实输出）

聚合文件（`/tmp/ca_b2/aggregate_ca1b2.lean`，**不入库**）同时 import 本批 4 个模块，
按「正式承载 → 展开/刻画 → 必要的桥 → 上层使用者」逐概念 `#check`（共 84 条），
并对每条链补一个**实际使用**的 `noncomputable example`（不只是看类型）：

```
$ lake env lean /tmp/ca_b2/aggregate_ca1b2.lean
（无输出：0 error、0 warning）
```

**公理画像**（`#print axioms`，逐条实测，非推测）：

| Entry | 声明数 | 公理 |
|---|---|---|
| `…module.generated` | 15 | 14 条 `[propext, Quot.sound]`；`span_union` 为 `[propext, Classical.choice, Quot.sound]` |
| `…module.quotient` | 18 | 全部 `[propext, Classical.choice, Quot.sound]` |
| `…module.direct-sum` | 22 | 全部 `[propext, Classical.choice, Quot.sound]` |
| `…module.isomorphism-theorems` | 22 | 全部 `[propext, Classical.choice, Quot.sound]` |

与 CA1 定义层同口径（`registry.axioms = [Classical.choice, Quot.sound, propext]`）。
`Classical.choice` 的**归属逐条披露**，不掩盖也不假装零公理：

- **类型级噪声**（不可削减，与证明路径无关）：四条 Entry 各做了判决性实验——
  `span_union` 的 `⊔`（`theorem sup_refl : p ⊔ q = p ⊔ q := rfl` 同样带 choice）、
  quotient 的商类型（`theorem q_refl : p.mkQ = p.mkQ := rfl` 同样带）、
  direct-sum 的 `IsCompl`（`theorem compl_refl : IsCompl p q = IsCompl p q := rfl` 同样带）。
- **数学必需**（接受并披露）：`LinearEquiv.ofBijective`/`ofTop`（为双射选逆映射）、
  `DirectSum.IsInternal.chooseDecomposition`（从命题版内直和取出带数据的分解）。
- 子 Agent 的消 choice 工作经负责人独立复验：`generated` 的 `span_eq_sInf`、`span_empty`、
  `map_span` 原本带 choice，已用构造性证明消去（`rfl`、`le_antisymm` 两条夹出、两包含自足证明）。
- 顺带发现并留痕（已写入 generated 叙述层「应用与陷阱」）：点记号 `h.trans`（合成 `Set.Subset`）
  会经 `Trans` 实例把 `Classical.choice` 带进公理档案，显式 `Set.Subset.trans` 则干净。
  **负责人独立复现**了该对照实验（`mono_explicit` 干净 / `mono_dot` 带 choice）。

## 6. 验证命令与结果

| 验证 | 命令 | 真实结果 |
|---|---|---|
| 逐模块编译 | `lake build SandronesLibrary.CommutativeAlgebra.Module.Generated` | `Build completed successfully (8710 jobs).` |
| 逐模块编译 | `… .Module.Quotient` | `Build completed successfully (8710 jobs).` |
| 逐模块编译 | `… .Module.DirectSum` | `Build completed successfully (8710 jobs).` |
| 逐模块编译 | `… .Module.IsomorphismTheorems` | `Build completed successfully (8711 jobs).` |
| 本文件 linter | 删 olean 强制重编后 grep 本文件 | 4 个新文件**零** linter warning（输出里只剩 `LinearAlgebra/Subspace.lean`、`VectorSpace.lean` 的既有历史警告） |
| 依赖闭包 | 聚合文件同时 import 4 模块 + 84 条 `#check` + 定义链 example | 0 error / 0 warning |
| 禁用占位 | `grep -n "sorry\|admit\|sorryAx\|native_decide"` 4 个源文件 | 无匹配 |
| 冲突标记 | `grep -n "^<<<<<<<\|^=======\|^>>>>>>>"` | 无匹配 |
| Entry↔声明映射 | `check_axioms.map_entry_to_decl` 逐文件 | generated 15/15、quotient 18/18、direct-sum 22/22、iso 22/22；**无跨 Entry 归属** |
| 反「包装」核查 | `grep` iso 文件正文的 `quotKerEquivRange`/`quotientInfEquivSupQuotient`/`quotientQuotientEquivQuotient(Aux)` | 只出现在模块 docstring 的**声明性句子**里，正文零调用点 |
| 全局 instance / 公开泄漏 | 逐条读 77 条声明的类型 | 无新增全局 instance；`instance_reducible` 只用在非 instance 的 `decompositionOfIsCompl` 上（不污染搜索） |
| `git diff --check` | — | 无输出 |

**负责人独立复验的关键事实**（不采信子 Agent 自述，逐条重跑）：
`#print Submodule.span` 定义体确为 `sInf {p | s ⊆ ↑p}`（`span_eq_sInf` 用 `rfl` 合法）；
`#print axioms` 全部 77 条与子 Agent 报告一致；direct-sum 的「陷阱 1」`example`（`p ⊔ ⊤ = ⊤`
单独不够）在负责人环境重编译通过；generated 的三条消 choice 与 `.trans` 对照实验全部复现。

## 7. 本批 pack 与 trace（硬交付，Playbook §8/§9）

**pack 清单（6 个，`pack_id` 全部唯一，`context_pack.py check` 通过）**：

| pack 文件 | pack_id | 角色 / worker |
|---|---|---|
| `traces/packs/…-module.generated.json` | `commutative-algebra-CA1b2-commutative-algebra.module.generated` | subject-maintainer（负责人侦察） |
| `traces/packs/…-module.generated-gen.json` | `commutative-algebra-CA1b2-commutative-algebra.module.generated-gen` | sub-agent `gen` |
| `traces/packs/…-module.quotient.json` | `commutative-algebra-CA1b2-commutative-algebra.module.quotient` | subject-maintainer（负责人自做） |
| `traces/packs/…-module.direct-sum.json` | `commutative-algebra-CA1b2-commutative-algebra.module.direct-sum` | subject-maintainer（负责人侦察） |
| `traces/packs/…-module.direct-sum-ds.json` | `commutative-algebra-CA1b2-commutative-algebra.module.direct-sum-ds` | sub-agent `ds` |
| `traces/packs/…-module.isomorphism-theorems.json` | `commutative-algebra-CA1b2-commutative-algebra.module.isomorphism-theorems` | subject-maintainer（负责人自做；简令 §9 第 4 条要求负责人按 §10.3 自行生成） |

**同一 Entry 派多个 worker 全部加了 `--worker`**（`gen` / `ds`），`pack_id` 与 `trace.path`
都带后缀，`join key` 唯一（CA1 试点漏 14 条的故障未复现）。

**trace 清单（6 条路径，逐条有记录、逐条带本 pack 的 `pack_id`）**：

| trace 路径 | 记录数 | accepted / error |
|---|---|---|
| `traces/lean/commutative-algebra/commutative-algebra.module.generated.jsonl` | 1 | 0 / 1（负责人侦察） |
| `traces/lean/commutative-algebra/commutative-algebra.module.generated-gen.jsonl` | 15 | 10 / 5 |
| `traces/lean/commutative-algebra/commutative-algebra.module.quotient.jsonl` | 3 | 1 / 2 |
| `traces/lean/commutative-algebra/commutative-algebra.module.direct-sum.jsonl` | 2 | 0 / 2（负责人侦察） |
| `traces/lean/commutative-algebra/commutative-algebra.module.direct-sum-ds.jsonl` | 16 | 10 / 6 |
| `traces/lean/commutative-algebra/commutative-algebra.module.isomorphism-theorems.jsonl` | 5 | 2 / 3 |

```
$ python3 scripts/lean_trace.py check traces/lean/commutative-algebra/
检查 8 个文件、68 条记录：通过
```

（8 个文件含 CA1 批遗留的 2 个。本批新增 6 个文件、42 条记录；失败尝试 19 条，
按 Playbook §10.6「不许为报告好看而掩盖失败」全部保留。）

## 8. subject_package 自检

（本节由回填提交补入，原文见下。）

## 9. 子 Agent 所有权与负责人复核

| worker | 拥有文件 | 交付 | 负责人独立复核发现 |
|---|---|---|---|
| `gen` | `Generated.lean` + `generated.md` + `generated-gen.jsonl` | 15 声明 / 369 行文档 / 15 条 trace | **通过**。复核了三条关键事实并全部复现（见 §6 末段）。发现 1 处可改进并**未退回**：其叙述层把「任意同构 `p × q ≃ₗ M` ⟹ 互补」写成「没有形式化」——该命题其实是**假**的，负责人直接改写为「刻意不做 + 反例」（见 §10 第 3 项） |
| `ds` | `DirectSum.lean` + `direct-sum.md` + `direct-sum-ds.jsonl` | 22 声明 / 511 行文档 / 16 条 trace | **通过**。复核 `#print axioms` 22/22、`rfl` 对照实验、陷阱 1 的 `example` 重编译、Mathlib 角色四类归属。**退回 0 次**；子 Agent 自查时已自行改掉初稿里一处「反推为真」的错误陈述，负责人把该处从「未形式化」进一步改成「命题为假 + 反例」 |

负责人**亲自做**的两条（`quotient`、`isomorphism-theorems`）也按同一标准留痕：
`quotient` 3 条 trace（含 1 轮 4 错修复）、`isomorphism-theorems` 5 条 trace
（含 2 轮构造返工 + 2 轮 `rw`/`change` 返工）。

**子 Agent 的「完成」不是验收**：所有编译、公理、映射检查、聚合 `#check` 均由负责人在
交付前重新跑过一遍（§6），未采信任何未经复跑的自述数字。

## 10. Main 需更新的共享文件（建议清单，本分支未修改）

1. **`index/registry.json`：新增 4 条 Entry**（`axioms`/`proof_sha`/`dependedOnBy` 由
   `check_axioms.py` 与 `update_dependency_graph.py` 生成，不要手填）：

```json
[
  {"id": "commutative-algebra.module.generated", "kind": "theorem",
   "title": "子集生成的子模与最小性",
   "summary": "交换环上由子集生成的子模（Submodule.span）的最小性四张脸、归纳原理与 span 基本演算，以及模同态下像的生成刻画",
   "family": "commutative-algebra.module", "variant": "textbook",
   "premises": ["commutative-algebra.module.definition"],
   "mathlib": ["Submodule.span","Submodule.map","LinearMap","Submodule.mem_span","Submodule.span_le","Submodule.subset_span","Submodule.span_mono","Submodule.span_eq","Submodule.span_span","Submodule.span_empty","Submodule.span_univ","Submodule.span_union","Submodule.span_eq_bot","Submodule.mem_span_singleton","Submodule.span_induction","Submodule.map_span"],
   "lean_file": "CommutativeAlgebra/Module/Generated.lean",
   "nl_file": "docs/entries/commutative-algebra/module/generated.md",
   "provenance": {"source_type": "book", "ref": "atiyah-macdonald-commutative-algebra-1969"},
   "state": "verified"},

  {"id": "commutative-algebra.module.quotient", "kind": "definition",
   "title": "商模、自然投影与商映射的泛性质",
   "summary": "交换环上商模 M/p 的正式承载（商类型 M ⧸ p）、自然投影的两个层次、陪集判等、商映射的泛性质（存在唯一性）与函子性，以及商模的极端情形",
   "family": "commutative-algebra.module", "variant": "textbook",
   "premises": ["commutative-algebra.module.definition"],
   "mathlib": ["Submodule.Quotient.mk","Submodule.mkQ","Submodule.liftQ","Submodule.ker_mkQ","Submodule.range_mkQ","Submodule.factor","Submodule.quotEquivOfEqBot","LinearMap.ker","LinearMap.range"],
   "lean_file": "CommutativeAlgebra/Module/Quotient.lean",
   "nl_file": "docs/entries/commutative-algebra/module/quotient.md",
   "provenance": {"source_type": "book", "ref": "atiyah-macdonald-commutative-algebra-1969"},
   "state": "verified"},

  {"id": "commutative-algebra.module.direct-sum", "kind": "theorem",
   "title": "内外直和与分解判据",
   "summary": "内直和（两项 IsCompl）与分解判据 ∀ x, ∃! yz : p × q, yz.1 + yz.2 = x 的双向证明、外直和 ⨁ i, M i 的坐标刻画与泛性质（唯一性半本库自证）、以及族版本内直和 DirectSum.Decomposition 的桥与两项情形下两种拼写的双向等价",
   "family": "commutative-algebra.module", "variant": "textbook",
   "premises": ["commutative-algebra.module.definition"],
   "mathlib": ["IsCompl","Disjoint","Submodule.prodEquivOfIsCompl","DirectSum","DirectSum.of","DirectSum.lof","DirectSum.toModule","DirectSum.component","DirectSum.Decomposition","DirectSum.IsInternal","DirectSum.decomposeLinearEquiv","DirectSum.isInternal_submodule_iff_isCompl","DirectSum.Decomposition.isInternal"],
   "lean_file": "CommutativeAlgebra/Module/DirectSum.lean",
   "nl_file": "docs/entries/commutative-algebra/module/direct-sum.md",
   "provenance": {"source_type": "book", "ref": "atiyah-macdonald-commutative-algebra-1969"},
   "state": "verified"},

  {"id": "commutative-algebra.module.isomorphism-theorems", "kind": "theorem",
   "title": "模的三大同构定理",
   "summary": "交换环上模的第一、第二、第三同构定理，每条按「构造诱导映射 → 证核/单射 → 证满射 → 组装线性等价」四步自建完整证明链（不引用 Mathlib 的三条现成等价）",
   "family": "commutative-algebra.module", "variant": "textbook",
   "premises": ["commutative-algebra.module.definition", "commutative-algebra.module.quotient"],
   "mathlib": ["Submodule.Quotient.mk","Submodule.mkQ","Submodule.liftQ","Submodule.factor","Submodule.inclusion","Submodule.comap","Submodule.map","Submodule.prod","LinearMap.codRestrict","LinearMap.ker","LinearMap.range","LinearEquiv.ofBijective"],
   "lean_file": "CommutativeAlgebra/Module/IsomorphismTheorems.lean",
   "nl_file": "docs/entries/commutative-algebra/module/isomorphism-theorems.md",
   "provenance": {"source_type": "book", "ref": "atiyah-macdonald-commutative-algebra-1969"},
   "state": "verified"}
]
```

   **注意**：`commutative-algebra.module.isomorphism-theorems` 的 `premises` 必须**含**
   `commutative-algebra.module.quotient`（它 `import` 了 `Quotient.lean` 并使用其接口）。
   本批 pack 生成时 quotient 尚未入 Registry，所以 pack 的 `prerequisites` 只列了 definition；
   这是已知的推导缺口，不是本文件的实际依赖。

2. **`docs/ROADMAP-LONGTERM.md` §13.1**：CA1 表第 2、3、4、5 行状态从空白改为
   `✅ verified（2026-10-14 集成，15/18/22/22 声明）`（日期以 Main 实际集成为准）。

3. **`docs/MATHLIB-RADAR.md`**（建议，非必须）：本批实测出的一批「按记忆会写错」的名字，
   可作为 RADAR 的负向条目：
   - 不存在：`Submodule.Quotient`（是命名空间）、`Submodule.Quotient.mk'`、
     `Submodule.Quotient.inductionOn`/`liftOn`、`Submodule.Quotient.liftQ_unique`、
     `Submodule.Quotient.ker_liftQ`/`range_liftQ`、`Submodule.quotientEquivOfEq`、
     `Submodule.isCompl_iff`、`Submodule.span_eq_iff`/`span_le_span_iff`/`span_eq_top_iff`/
     `span_eq_iSup_of_singleton`/`span_attach`/`span_induction'`/`span_eq_sInf`（后两者是
     Mathlib 无、本库自建）、`Submodule.mem_span_iff_exists_finset`、`DirectSum.lift`、
     `DirectSum.isInternal`、`DirectSum.toModule_unique`（整体形式）、`DirectSum.isInternal_iff_iSupIndep`；
   - 真名与记忆不符：`LinearMap.quotKerEquivRange`（不是 `quotientKerEquivRange`）、
     `Submodule.Quotient.induction_on`（不是 `inductionOn`）、`Submodule.quotEquivOfEq`
     （在 `Submodule` 下不在 `Submodule.Quotient` 下）、`DirectSum.toModule`（不是 `DirectSum.lift`）、
     `DirectSum.isInternal_submodule_iff_isCompl`、`DirectSum.isInternal_submodule_iff_iSupIndep_and_iSup_eq_top`。

4. **`reference.bib`**：**无需新增**。四条 Entry 的 `provenance.ref` 全部复用已有的
   `atiyah-macdonald-commutative-algebra-1969`（章节定位写在叙述层正文）。

5. **口径统一建议（跨条目，Main 裁决）**：CA1 定义层叙述层末尾记了一条待裁决项——
   L1 `VectorSpace.lean` 头部自述「mathlib 的 `Module`/`Submodule` 只出现在 `:= by` 之后」，
   但同一文件的 `IsBasis` 公开定义体已含 `Submodule.span`。本批四条 Entry 公开使用
   `Submodule`/`Submodule.span`/`M ⧸ p`，与 L1 的**实际**做法一致、与 L1 的**自述**不一致。
   本批不擅改 L1 文档，维持原建议：由 Main 统一口径（或修 L1 自述，或明确「公开承载可用
   Mathlib 结构」的边界）。

## 11. 未完成边界（诚实边界）

**本批明确没做**（`scope.out_of_scope`，一条未碰）：CA2 的 finite-generation、free、
exact-sequence、projective、injective、flat；CA3 的 tensor-product、localization。

**四条 Entry 各自的诚实边界**（详见各叙述层的「应用与陷阱 / 未完成边界」）：

- `generated`：**「`⟨S⟩` = 有限线性组合之集」这一等价刻画没有形式化**——本条目给的是归纳原理
  （`P` 在 `S` 上成立 + 对 `0`/`+`/`•` 封闭 ⟹ 在 `⟨S⟩` 上处处成立），这是**结构性**刻画，
  **不是**有限和的等价陈述，两者不等价，不要把前者读成后者。`span_eq_sInf` 在本版是
  **定义展开**（`rfl`），不是新数学。子模格完整 API（`span_iUnion`、`span_insert` 等）未纳入。
- `quotient`：不含三大同构定理本身；不含 `Submodule.mapQ`、`Submodule.comapMkQRelIso`
  （子模对应定理）的完整演算；`quotient_liftQ_exists_unique` 是本条目**唯一**需要自证的定理
  （其余 16 条是把 Mathlib 下层接口按教材口径重述）。商模的 `Classical.choice` 是**结构底线**
  （一条 `rfl` 也带），不可削减。
- `direct-sum`：**只做两项内直和 + 一般族分解**，没有 n 元内直和判据（`iSupIndep` 的教材化
  展开未做）；**重组同构只做了一个方向，且反向命题是假的**（反例 `M = R²`、`p = q = R × 0`：
  `p × q ≅ M` 但 `p ⊓ q = p ≠ ⊥`）——这是刻意不做，不是待补；外直和泛性质只做「从 `⨁` 出发」
  方向，未做「映入 `⨁` 的映射由分量决定」（需 `lof` 的线性无关性），未做有限指标下 `⨁` 与 `∏`
  的比较；`decompositionOfIsCompl` 是**非计算**的（走 `chooseDecomposition`，带 choice）。
- `isomorphism-theorems`：第二同构定理只做 `comap` 形式（未移植 Mathlib 的 `simp` 引理族）；
  第三同构定理只做 `S ≤ T` 版本（未做 `⊔` 重述版与指标公式 `[M:T][S:T]=[M:S]`）；
  未做环/代数/群版本；未做加性群版本 `QuotientAddGroup.quotientKerEquivRange` 的比较。
  三条定理的「≅」在 Lean 里是 `≃ₗ`（**数据**）而非 `↔`（命题），因此都是 `noncomputable def`。

**一句话**：本批交付的是 CA1 定义层之上的四条**教材层**条目，全部声明在教材设定
`[CommRing R] [AddCommGroup M] [Module R M]` 上；**没有**任何「foundation/bridge 被说成
教材定理」的情况（四条 Entry 的第 2 类桥全部为空，这一点在 §4 已明示）。`Classical.choice`
逐条披露归属，未用投影改写伪装零公理。

## 12. 下一批可稳定依赖 / 不可依赖的 API

**可稳定依赖**（本批已交付、已编译、已留痕、签名冻结）：

- 生成：`Submodule.span` 上的 `subset_span`、`mem_span_iff`、`span_le_iff_subset`、
  `span_eq_iff_subset_and_le`、`span_induction`、`span_mono`、`span_union`、`span_eq_bot_iff`、
  `map_span`。
- 商：`M ⧸ p`、`Submodule.Quotient.mk`/`mkQ`、`quotient_mk_eq_iff`、`quotient_liftQ_exists_unique`、
  `quotient_liftQ_unique`、`quotient_hom_ext`、`mkQ_ker`、`quotient_factor_mkQ`。
- 直和：`isCompl_iff_disjoint_sup_eq_top`、`isCompl_iff_existsUnique_decomposition`、
  `prodEquivOfIsCompl_apply`、`directSum_existsUnique_toModule`、`directSum_lof_ext_iff`、
  `internalDirectSum_decomposeLinearEquiv`、`isCompl_iff_nonempty_decomposition_fin_two`。
- 同构：`first_iso`、`first_iso_of_surjective`、`first_iso_mk`、`second_iso`、`second_iso_mk`、
  `third_iso`、`third_iso_mk_mk`、`factor_ker`。
- CA2 的 finite-generation / free / exact-sequence 可直接在这套接口上开工。

**不可依赖 / 需注意**：

- `commutative-algebra.module.isomorphism-theorems` 的 `premises` 尚未含
  `commutative-algebra.module.quotient`（本批同时新登记，pack 推导缺口），Main 集成时必须补。
- 本批四条 Entry **尚未登记 Registry**（Registry 是 Main 共享文件），
  在 Main 合并前不要作为 `premises` 引用。
- `generated` 的 `span_eq_sInf` 是 `rfl`（定义展开）——依赖它等于依赖 Mathlib `Submodule.span`
  的定义体，Mathlib 改定义会破。其余条目无此风险。
- `direct-sum` 的 `decompositionOfIsCompl` 非计算，不要在需要可计算分解的场景依赖它。
- 商模一切陈述都带 `Classical.choice`（类型级），下游条目会继承，这不是本批的缺陷。

## 13. 协议反馈（如实记录，含子 Agent 反馈的负责人复核）

**pack 与派工协议**：

1. **pack 的 `prerequisites.mathlib` 只给名字、不给 binder**，是本批最大的信息缺口。
   `gen` worker 明确报告「派工消息里我手写的『已测量 Mathlib 事实』清单比 pack 有用得多」。
   建议 `context_pack.py build` 把候选名的 `#check` 签名（binder 顺序、隐式/显式）一并冻结进
   `prerequisites.mathlib`，或至少加一个 `mathlib_signatures` 块。本批 13/42 候选名不存在
   （Main 已实测并更正），正说明「名字」这一层信息不够。
2. **pack 的 `budget: 每目标最多 5 次编译尝试` 与 Playbook §0.4 的「同一证明 5 次」语义不同**。
   `gen` 15 条声明共 15 轮编译，按 pack 字面会误判超预算。建议改成
   「同一证明目标 5 次编译失败」。
3. **pack 未含「Entry 的 `kind` 约定」与「叙述层必需节清单」**（这两项只出现在负责人的派工
   消息里）。若子 Agent 只读 pack 会缺信息。建议 pack 增加 `target.nl_sections` 与 `target.kind`。
4. **pack 的 `ownership.writable` 是目录级（`SandronesLibrary/CommutativeAlgebra/**`），
   派工消息是文件级**。两者口径不一致（本批无实际冲突）。建议 pack 支持
   `--owned-files` 把子 Agent 的具体文件写进 `ownership.writable`。
5. **同一 Entry 多 worker 时 `trace_id` 撞车**：`ds` 与负责人的侦察记录都用
   `trace_id = commutative-algebra.module.direct-sum`，`lean_trace.py summary` 按 trace_id
   合并成 17 次。`pack_id` 能区分，但按 trace_id 切语料会混。建议 `--worker` 同时给
   `trace_id` 加后缀（或把 trace_id 定义成 `pack_id` 的函数）。
6. **`--worker` 机制本身工作正常**：本批 6 条 trace 路径、6 个 pack_id 一一对应，
   `context_pack.py check` 与 `subject_package.py` 的 `packs` 块均无
   `duplicate_pack_ids` / `trace_path_mismatch`。CA1 的漏记录故障未复现。

**trace 协议**：

7. **负向探针（`#check` 不存在的名字）按 §8.4 记 `outcome=error` 是预期结论，不是失败**。
   `gen` worker 建议在 §8.4 补一句，避免下游把这类记录当返工信号。本批 42 条记录里有相当一部分
   是这类（负责人侦察 6 条全部是），如果按 outcome 统计「失败率」会把侦察轮算成失败。
8. **`trace_id` 与 `pack_id` 的关系在 §8.4 与 §9.4 之间没有显式对齐**：§8.4 说 trace_id 是
   「同一证明任务的稳定标识（一个任务一个文件）」，§9.4 说同一 Entry 多 worker 时 trace.path
   带 worker 后缀——两句话合起来意味着「一个 Entry 可以有多个文件但 trace_id 相同」，
   这正是第 5 条的歧义来源。

**数学 / Mathlib 侦察**：

9. **`Submodule.Quotient` 是命名空间不是常量**，`#check` 报 `Unknown constant` 是**正确行为**
   而非「Mathlib 缺商模」。这类「命名空间 vs 常量」的混淆值得进 Playbook §5 教训日志
   （本批负责人侦察第一轮就撞上，见 `…module.quotient.jsonl` attempt 1 的 `next_step`）。
10. **`rw` 的关键字匹配不认 defeq**（`p.mkQ x` vs `Quotient.mk x`）在本批复现两次
    （iso 的 `factor_ker`、负责人 Quotient.lean 的 `h0` 改写），Playbook §5.2 已有条目，
    建议补一条「遇到 `Did not find an occurrence of the pattern` 且两端明显 defeq 时，
    先用 `change` 对齐再 `rw`」的具体手法。
11. **`Subtype` 层的等式是形式化噪声**：`LinearMap.ker (f.codRestrict p _) = LinearMap.ker f`
    这类等式两轮都证不干净（`simp` 报 unused、`Subtype.coe_injective` 报元变量），
    换构造（把 `codRestrict` 提到最外层 + 陪集归纳）一次通过。建议进 Playbook §5 或 §2。
12. **点记号 `.trans` 会带进 `Classical.choice`**（`gen` worker 发现，负责人独立复现）：
    合成 `Set.Subset` 时 `h.trans k` 经 `Trans` 实例引入 choice，`Set.Subset.trans h k` 干净。
    这是 Playbook §3.1「`rw [mathlib 定理]` 可能悄悄引入 choice」的一个新实例，
    建议进 §3.1 或 §5。
13. **`open scoped DirectSum` 是硬要求**：不加 scope 时 `⨁` 落到范畴论双积记号，
    报错伪装成「类型不匹配 + 意外逗号」，`ds` worker 白烧一轮。建议 pack 在 Mathlib 候选旁
    注明所需 scope。
14. **`Submodule.span` 的定义体就是教材的交定义**（`sInf {p | s ⊆ ↑p}`），
    这类「教材定义与 Mathlib 定义体逐字一致」的发现值得进 RADAR 的正向条目：
    它让「桥」变成不必要，是本库 AGENTS §4「优先复用」的最佳案例。

**简令与协议自身**：

15. **简令 §7 只渲染了 1/6 条 trace 路径**（Main 已确认是 `dispatch_brief.py` 的渲染缺陷并
    已修，提交 `24f9e30`）。本批负责人按 pack 的 `trace.path` 逐条核对，6 条全部有记录，
    未因该缺陷漏写。**建议**：`subject_package.py` 的 `packs` 块已有 `trace_path_mismatch`
    硬检查，可考虑再加一条「pack 文件存在但对应 trace 文件不存在」的显式告警。
16. **简令 §1 列 3 条 Entry，§9 手写残量又要求第 4 条 `isomorphism-theorems`**。这两处
    在简令内部不一致（§1 是 pack 推导，§9 是手写残量）。本批按 §9 执行（4 条），
    但建议渲染器在 §1 表下加一行显式说明「另有 §9 追加的 Entry」，避免负责人漏做或误判越界。
