# Handoff: commutative-algebra-ca1（CA1 定义层：模、子模与模同态）

- 学科：交换代数（commutative-algebra）
- 批次：CA1（ROADMAP §13.1 CA1 表第 1 行；§D4 行，Wave R1 试点窗口）
- 分支：`codex/commutative-algebra`
- worktree：`/home/pisquare/czt/sandrones-library-commutative-algebra`
- 基线：`4bfa280`（main，已含 Main 的目录裁决提交）
- 交付状态：源码、叙述层、pack、trace、handoff 均已提交；**未 push、未建 PR**
- 目录裁决执行：新建 `SandronesLibrary/CommutativeAlgebra/`，家族前缀 `commutative-algebra.*`，
  叙述层 `docs/entries/commutative-algebra/`；未复用 `AbstractAlgebra/`，未触碰 Main 共享文件。

## 1. 范围

只交付 **1 条 Entry**（CA1 定义层），本批冻结范围（子集生成子模、商模、同构定理、直和、
张量积、局部化）一律未碰。

| Entry id | Lean 文件 | 叙述层 |
|---|---|---|
| `commutative-algebra.module.definition` | `SandronesLibrary/CommutativeAlgebra/Module/Definition.lean`（185 行） | `docs/entries/commutative-algebra/module/definition.md`（277 行） |

未修改：`SandronesLibrary.lean`、`index/registry.json`、`index/rankings.json`、`reference.bib`、
`docs/entries/README.md`、`docs/entries/RANKINGS.md`、`docs/MATHLIB-RADAR.md`、
`docs/ROADMAP-*.md`、`docs/LEAN-PLAYBOOK.md`、`README.md`、`AGENTS.md`、`scripts/**`。

## 2. 提交

| commit | 内容 |
|---|---|
| `398bd99` | CA1 派工上下文包（2 个 pack）+ 负责人接口侦察 trace（5 条） |
| `fe4eb10` | CA1 定义层 Lean 源码（11 条公开声明） |
| `1956a2e` | 叙述层 `docs/entries/commutative-algebra/module/definition.md` |
| `8878212` | 叙述层补充：L1 词汇口径边界 + 冻结在 `M →ₗ[R] N` 的说明 |
| `3c9d096` | 两个 trace jsonl（27 条记录）+ 本 handoff 初稿 |
| `36fd2fd` | 本 handoff 回填 subject_package 输出（只改 handoff 文本） |

源码 blob：`Definition.lean` = `13222ba08c15779bbe9036bbf8cb972406655ccd`；
叙述层 = `5b94d1f95679c7d09b878493552fcbce3a5b4a06`。行数：源码 185、叙述层 277、本文件 320。

## 3. 冻结的核心概念清单（AGENTS §4 六条）

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 角色 | 首个真实使用者 | Entry |
|---|---|---|---|---|---|---|
| 模 | 交换环 `A` 通过作用 `A × M → M` 作用在阿贝尔群 `M` 上，满足两条分配律、结合律、单位律与两条零律（A–M 第 2 章） | `Module R M` | `module_axioms`：六条公理逐条展开成合取式 | 语义一致的**正式公开承载**（`#print Module`：父类 `DistribMulAction` 含 `smul_add`/`smul_zero`/`mul_smul`/`one_smul`，自有字段只有 `add_smul`/`zero_smul`） | 本文件全部定理的 `[Module R M]`；`submodule_of_closure` 的构造 | `commutative-algebra.module.definition` |
| 子模 | 含 `0`、对加法封闭、对数乘封闭的子集 | `Submodule R M` | `submodule_closure`（必要性）+ `submodule_of_closure`（充分性），两条合起来就是教材「子集是子模 ⟺ 三条封闭」；`submodule_eq_iff` 是外延性 | 语义一致的**正式公开承载**；构造子 `Submodule.mk` 只出现在证明体（私有后端） | `LinearMap.ker F : Submodule R M`、`LinearMap.range F : Submodule R N` | 同上 |
| 模同态 | 保持加法与数乘的映射；域上就是线性映射 | `LinearMap R M N`（记号 `M →ₗ[R] N`） | `linearMap_iff`：`(∃ F, ⇑F = f) ↔ 加法保持 ∧ 数乘保持`；`linearMap_ext_iff`；`linearMap_map_zero` | 语义一致的**正式公开承载**（父结构是 `AddHom`，不是 `AddMonoidHom`） | `linearMap_mem_ker_iff`/`linearMap_mem_range_iff`；后续商模与同构定理（本批冻结） | 同上 |
| 核与像 | `ker f = {x : f x = 0}`、`im f = {f x}` | `LinearMap.ker` / `LinearMap.range` | `linearMap_mem_ker_iff`（`x ∈ ker F ↔ F x = 0`）、`linearMap_mem_range_iff`（`y ∈ range F ↔ ∃ x, F x = y`） | 语义一致的**正式公开承载**（Mathlib 已把二者定义为 `Submodule`） | 子模承载的公开使用者；商模 `M/ker f` 与同构定理的入口（冻结，未做） | 同上 |
| 子空间（L1 记号） | 非空、加法封闭、数乘封闭的子集 | `IsSubspace K W`（本库 L1 谓词）+ `LinearSpace K V` | `isSubspace_iff_exists_submodule`：`IsSubspace K W ↔ ∃ S : Submodule K V, ↑S = W` | **本库桥**（L1 教材谓词 ↔ Mathlib `Submodule`），双向 | 桥本身；L1 `Subspace.lean` 的 `IsSubspace` 使用者 | 同上 |
| 双边理想（A2 记号） | 左理想 ∧ 右理想（0、加法、负元、单侧吸收逐条写出） | `AbstractAlgebra.Ring.TwoSidedIdealSet I`（本库 A2 谓词） | `twoSidedIdealSet_iff_exists_submodule_self`：`TwoSidedIdealSet I ↔ ∃ S : Submodule R R, ↑S = I` | **本库桥**（A2 教材谓词 ↔ Mathlib `Submodule R R`），双向 | A2 已有的 `twoSidedIdealSet_iff_exists_ideal`（同一命题的 `Ideal` 版，见 §11 诚实边界） | 同上 |

## 4. 公开签名四类归属

1. **语义一致的正式公开承载**：`Module`、`Submodule`、`LinearMap`（`M →ₗ[R] N`）、
   `LinearMap.ker`、`LinearMap.range`。均直接出现在公开陈述里，逐条有教材解释。
   独立复核的实测签名：`Module` 父类仅 `toDistribMulAction`，自有字段恰 `add_smul`/`zero_smul`；
   `Submodule.mk` 吃 `(toAddSubmonoid : AddSubmonoid M)` + `smul_mem'`（`carrier`/`zero_mem'`/
   `add_mem'` 是从 `AddSubmonoid` 继承的字段名）；`LinearMap` 父结构是 `AddHom`（`M →ₙ+ M₂`）
   加 `MulActionHom`，`LinearMap.mk` 吃 `AddHom` + `map_smul'`，**没有** `map_zero'` 字段。
2. **本库特殊定义的桥**：`isSubspace_iff_exists_submodule`（L1 `IsSubspace`/`LinearSpace` ↔
   Mathlib `Submodule`）、`twoSidedIdealSet_iff_exists_submodule_self`（A2 `TwoSidedIdealSet` ↔
   Mathlib `Submodule R R`）。两条都是 `↔`，无缺失反向。
3. **私有证明后端**（只出现在 `:= by` 之后，不进公开签名）：`Submodule.mk`（`carrier`/
   `zero_mem'`/`add_mem'`/`smul_mem'` 字段）、`LinearMap.mk`/`AddHom.mk`、`smul_add`、
   `add_smul`、`mul_smul`、`one_smul`、`zero_smul`、`smul_zero`、`Submodule.add_mem`、
   `Submodule.smul_mem`、`Submodule.zero_mem`、`SetLike.ext_iff`、`map_zero`、
   `LinearMap.mem_ker`、`LinearMap.mem_range`、`smul_eq_mul`、`neg_one_smul`、`mul_comm`。
4. **超出课程层级的公开泄漏**：无。独立复核（`ca1-verify`）额外确认两点：
   (i) `LinearMap.range` 内部需要的 `RingHomSurjective (RingHom.id R)` 由类型类合成自动提供
   （`#synth` 得 `RingHomSurjective.ids`；`M →ₗ[R] N` 就是 `M →ₛₗ[RingHom.id R] N`，`rfl` 可判），
   不会作为额外 typeclass 出现在使用处公开签名——实测 `#print` 一个形如 `∃ S, S = f.range`
   的定理，binder 列表无 `RingHomSurjective`。**风险边界**：若把结论推广到一般
   `M →ₛₗ[σ] N` 而不假设实例，它就会真成为公开假设；本条目冻结在 `M →ₗ[R] N`。
   (ii) `IsSubspace`/`TwoSidedIdealSet`/`LinearSpace` 都是本库谓词与类，不是 Mathlib 高阶接口。

### 4.1 上层使用者的 Mathlib 级证据（AGENTS §4 第 5 条）

`ca1-verify` 在本地 Mathlib 里为 `Submodule`（作为 `ker`/`range` 的载体）与 `LinearMap` 各找出
真实消费它们的公开声明共 19 条（16 条在冻结范围外），并抽验 6 条 `文件:行`：

- `LinearAlgebra/FiniteDimensional/Lemmas.lean:173`（秩-零化度 `finrank_range_add_finrank_ker`）、
  `FiniteDimensional/Basic.lean:302/:307`、`Matrix/Rank.lean:499`、`Dual/Lemmas.lean:740`、
  `TensorProduct/Finiteness.lean:131`、`Dual/Basis.lean:105`、`Dual/Defs.lean:482`（以上冻结范围外）；
- `TensorProduct/Map.lean:56`、`TensorProduct/Tower.lean:183`、`Dual/Defs.lean:80/:117/:325`、
  `Basis/Defs.lean:513`、`Algebra/Module/LinearMap/Defs.lean:486`、`ModuleCat/Basic.lean:119`
  （以上冻结范围外）；
- 冻结范围内的三条（本批不碰，仅作边界证据）：`Dual/Lemmas.lean:747`（直和/`IsCompl`）、
  `LinearAlgebra/Isomorphisms.lean:39`（商模 + 第一同构）、`LinearAlgebra/Quotient/Basic.lean:174`。

条目自身的公开使用者是 `linearMap_mem_ker_iff`/`linearMap_mem_range_iff`（`ker`/`range` 返回
`Submodule`）与两条桥；下一批（生成子模、商模）将直接以 `submodule_of_closure` 为构造入口。

## 5. 定义链聚合 `#check` 与公理（真实输出摘要）

聚合文件（临时，worktree 外）：同时 `import SandronesLibrary.CommutativeAlgebra.Module.Definition`，
`#check` 正式承载 → 刻画 → 桥 → 上层使用者，并 `#print axioms`。

11 条公开声明全部按预期签名通过（`module_axioms` 的合取式、`submodule_of_closure` 的
`0 ∈ s → (∀ x ∈ s, ∀ y ∈ s, x + y ∈ s) → (∀ (a : R), ∀ x ∈ s, a • x ∈ s) → ∃ S, ↑S = s`、
`linearMap_iff` 的 `(∃ F, ⇑F = f) ↔ …`、两条桥的 `↔ ∃ S, ↑S = …` 等）。

```
'SandronesLibrary.CommutativeAlgebra.Module.module_axioms' depends on axioms: [propext]
'SandronesLibrary.CommutativeAlgebra.Module.submodule_of_closure' depends on axioms: [propext]
'SandronesLibrary.CommutativeAlgebra.Module.linearMap_iff' does not depend on any axioms
'SandronesLibrary.CommutativeAlgebra.Module.isSubspace_iff_exists_submodule' depends on axioms: [propext, Quot.sound]
'SandronesLibrary.CommutativeAlgebra.Module.twoSidedIdealSet_iff_exists_submodule_self' depends on axioms: [propext]
```

无 `sorryAx`、无 `Classical.choice`（`Quot.sound` 来自 L1 `LinearSpace` 路径上的商结构，
`propext` 为 Lean 内建）。叙述层因此无需写 Choice 说明。

## 6. 验证命令与结果

| 命令 | 结果 |
|---|---|
| `lake env lean SandronesLibrary/CommutativeAlgebra/Module/Definition.lean` | rc 0，文件级零警告 |
| `lake build SandronesLibrary.CommutativeAlgebra.Module.Definition` | rc 0，`Build completed successfully (8709 jobs)`；仅 replay L1 `Subspace.lean` 既有 header/whitespace 警告 |
| 聚合 `#check` + `#print axioms` | rc 0（见 §5） |
| 禁用占位扫描（`SandronesLibrary/CommutativeAlgebra/**` + 叙述层） | 零命中 |
| 全局 instance 扫描（`instance`/`attribute [instance]`） | 零命中（未新增任何全局 instance） |
| Entry 声明映射（`check_axioms.map_entry_to_decl`） | 11 条声明 / 11 个 Entry 标记，单文件单 id |
| `git diff --check`（含 `HEAD`） | 干净 |
| `python3 scripts/lean_trace.py check traces/lean/commutative-algebra/` | 2 个文件、27 条记录，通过 |
| `df -h /` | 开工 11G avail → 收工 11G avail，全程未低于 5G 硬门 |

磁盘纪律：只做目标模块的定向构建；未跑 `lake update`、`lake exe cache get`、裸 `lake build`；
`.lake/packages` 仍符号链接到主工作树。

## 7. 本批 pack 与 trace（硬交付，Playbook §8/§9 首跑）

**pack 清单**

| pack 文件 | pack_id | 角色 | 用途 |
|---|---|---|---|
| `traces/packs/commutative-algebra-CA1-commutative-algebra.module.definition.json` | `commutative-algebra-CA1-commutative-algebra.module.definition` | `subject-maintainer` | Main 生成的条目派工包；本批同时作为 `ca1-lean-core` 的开工输入（内容与需求一致：同一 Entry、同一前提闭包、同一 trace 路径） |
| `traces/packs/commutative-algebra-CA1-commutative-algebra.module.definition.verify.json` | `commutative-algebra-CA1-commutative-algebra.module.definition` | `sub-agent` | 负责人按 §9.4 为 `ca1-verify` 生成 |

`python3 scripts/context_pack.py check traces/packs/*.json` → 检查 2 个 pack：通过。
两个 pack 的 `pack_id` **相同**：本版工具 `pack_id = f"{subject}-{batch}-{entry}"`
（`scripts/context_pack.py:299`），本批只有一个 Entry，无 `--pack-id`/`--worker` 开关可用。
该摩擦点已写进 §13 协议反馈。

**trace 清单（按 outcome 分类）**

| trace 文件 | trace_id | 记录数 | accepted | error | sorry_left | 写入者 |
|---|---|---|---|---|---|---|
| `traces/lean/commutative-algebra/commutative-algebra.module.definition.jsonl` | `commutative-algebra.module.definition` | 13 | 9 | 3 | 1 | `ca1-lead`（7：3 accepted / 3 error / 1 sorry_left）+ `ca1-lean-core`（6 accepted） |
| `traces/lean/commutative-algebra/ca1-mathlib-role-probe.jsonl` | `ca1-mathlib-role-probe` | 14 | 5 | 9 | 0 | `ca1-verify` |
| 合计 | — | **27** | 14 | 12 | 1 | 3 个 Agent |

全部 27 条记录都带 `pack_id = commutative-algebra-CA1-commutative-algebra.module.definition`，
`outcome` 与编译器真实结论一致；失败尝试占 13/27（含接口误判、隐式 binder 陷阱、
`map_zero'` 字段不存在、`RingHomSurjective` 参数误用等），未事后美化。
`ca1-verify` 的 14 条写在独立 jsonl（而非 pack 里 `trace.path` 指定的文件）：本批两个子 Agent
并发 append 同一文件会让 `attempt` 序号竞争，属已知偏离，见 §13。

## 8. subject_package 自检

命令：

```bash
python3 scripts/subject_package.py --worktree /home/pisquare/czt/sandrones-library-commutative-algebra \
    --base 4bfa280 --subject commutative-algebra
```

输出（原文抄录，源码/文档/轨迹/handoff 初稿提交 `3c9d096`；本回填提交只改 handoff 文本）：

```
学科验收包 commutative-algebra  (codex/commutative-algebra @ 3c9d09635)
  基线 4bfa280｜提交 5｜改动文件 7
  ✅ cleanliness
  ✅ ownership
  ✅ semantics
  ✅ proof
  ✅ coverage
  ✅ traces（软门）：本批含 27 条验证尝试记录
  ✅ packs（软门）：pack 与 trace 的 pack_id 已配对

  verdict: pass
```

`--json` 细节：`exceptions: []`；逐 Entry 声明数 `commutative-algebra.module.definition` = 11，
`in_registry: false`（待 Main 登记），`lean_files` 只有一个文件；
`traces: {"status": "present", "records": 27, "invalid": []}`；
`packs: {"pack_ids": ["commutative-algebra-CA1-commutative-algebra.module.definition",
"commutative-algebra-CA1-commutative-algebra.module.definition"],
"referenced_by_traces": ["commutative-algebra-CA1-commutative-algebra.module.definition"],
"missing_for_referenced": [], "invalid": []}`——注意 `pack_ids` 里同一个 id 出现两次，
即 §13 第 1/2 条的 pack_id 粒度问题在验收包里可见（机械门不报错，但 join key 不再唯一）。

回填后在最终 HEAD 重跑（`0436946b7`，提交 7，改动文件 7）：五组门全 pass、两条软门同文案，
`verdict: pass` 不变，`git status --short` 为空。

## 9. 子 Agent 所有权与退回

| 子 Agent | 所有权（本批实际写入） | pack | 结果 | 负责人退回／修复 |
|---|---|---|---|---|
| `ca1-lean-core` | `SandronesLibrary/CommutativeAlgebra/Module/Definition.lean` + 条目 trace 文件 | pack #1 | 11 条公开声明，6 条 trace 全 `accepted`，定向 build 通过 | 负责人发现 1 处 docstring 事实错误并修复（见下） |
| `ca1-verify` | 仅 `traces/lean/commutative-algebra/ca1-mathlib-role-probe.jsonl` + worktree 外 scratch | pack #2 | 独立复现两条桥（无 sorry）、接口存在性表、上层使用者清单、泄漏判定 | 无退回；其结论被采纳（`Ideal` 是 reducible 的 `Submodule R R`、`RingHomSurjective` 不泄漏、`Submodule.neg_mem` 更地道） |

**负责人审核中发现并修复的问题（1 项）**：`ca1-lean-core` 给 `linearMap_map_zero` 写的 docstring
称「`F 0 = 0` 由父结构 `AddHom` 自动提供」。负责人去 Mathlib 源码核对
（`.lake/packages/mathlib/Mathlib/Algebra/Module/LinearMap/Defs.lean:139-145`）：`map_zero` 实际来自
`SemilinearMapClass → AddMonoidHomClass` 实例，证明走 `F 0 = F (0 • 0) = 0 • F 0 = 0`
（`zero_smul` + `map_smul`），与 `AddHom` 父结构无关。已改写该 docstring 并整文件复验
（trace `attempt 12`）。数学陈述、签名、证明体均未改动。

**语料真实性说明**：`ca1-lean-core` 的 6 条尝试全部一次通过（负责人已把实测过的接口写法写进派工规格），
所以该 Agent 没有 `error` 记录；本批 12 条 `error` 来自负责人的接口侦察与 `ca1-verify` 的独立复现，
未为了凑失败而故意写错。

## 10. Main 需更新的共享文件（建议清单，本分支未修改）

1. **`SandronesLibrary.lean`**：新增一行（位置由 Main 决定，建议与 LinearAlgebra 块相邻）
   ```lean
   import SandronesLibrary.CommutativeAlgebra.Module.Definition
   ```
2. **`index/registry.json`**：登记 1 条（`axioms`/`proof_sha`/`dependedOnBy` 由生成器写，勿手工填）：
   ```json
   {
     "id": "commutative-algebra.module.definition",
     "kind": "definition",
     "state": "verified",
     "title": "模、子模与模同态",
     "summary": "交换环上模、子模与模同态的教材定义与量词展开；子模的加法/数乘封闭刻画、模同态与线性映射的关系，以及它们在 Mathlib 中的角色分类",
     "premises": ["abstract-algebra.ring.def", "abstract-algebra.ring.ideal",
                  "linear-algebra.vector-space.def", "linear-algebra.vector-space.subspace"],
     "mathlib": ["Module", "Submodule", "LinearMap", "LinearMap.ker", "LinearMap.range"],
     "provenance": {"source_type": "book", "ref": "atiyah-macdonald-commutative-algebra-1969"},
     "lean_file": "CommutativeAlgebra/Module/Definition.lean",
     "nl_file": "docs/entries/commutative-algebra/module/definition.md",
     "family": "commutative-algebra.module",
     "variant": "textbook"
   }
   ```
   说明：`premises` 与 Lean 文件的实际 import 一致（文件 import 了
   `SandronesLibrary.LinearAlgebra.Subspace`（含 `VectorSpace`）与 `SandronesLibrary.AbstractAlgebra.Ring`
   （含 `ring.def` 与 `ring.ideal`））；未列 `abstract-algebra.ring.quotient`（本条目不使用）。
3. **`docs/ROADMAP-LONGTERM.md`**：§13.1 CA1 表第 1 行 `commutative-algebra.module.definition`
   由 🚧/`research_open` 转 ✅/`verified`；§D4 行同步（首条已成品，CA1 其余条目
   `generated`/`quotient`/`isomorphism-theorems`/`direct-sum` 仍冻结）；§1 阶段表相应单元格同步。
4. **`docs/MATHLIB-RADAR.md`**：建议登记本批用到的 Mathlib 名，角色为「语义一致的正式公开承载」：
   `Module`、`Submodule`、`LinearMap`（`M →ₗ[R] N`）、`LinearMap.ker`、`LinearMap.range`；
   另建议登记两条接口事实（角色为「私有证明后端 / 接口注意」）：`Submodule.mk`
   （字段 `carrier`/`zero_mem'`/`add_mem'`/`smul_mem'`，隐式 binder 需显式写出）、
   `LinearMap.mk`（吃 `AddHom`，不接受 `map_zero'`）、`Submodule.neg_mem`。
5. **`reference.bib`**：无需新增 key，沿用已存在的 `atiyah-macdonald-commutative-algebra-1969`。
6. **派生文件**：按 AGENTS §6 顺序重建（`extract_registry_references` → `update_dependency_graph`
   → `gen_entries_index` → `gen_entry_rankings` → `check_axioms --all --fix` → `check_axioms --all`
   → `audit.py` → `git diff --check` → 全库 `lake build`）。

## 11. 未完成边界（诚实边界）

- 只覆盖 CA1 **定义层**。子集生成子模、商模与自然投影、同构定理、直和、自由模与秩、张量积、
  局部化、子模格运算（和/交/任意交）**均未做**，仍属冻结或后续批次。
- 两条桥是「`↔ ∃ S, ↑S = …`」强度，**未**证明载体唯一性等更强结论（教材层不需要）。
- A2 桥与 A2 已有 `twoSidedIdealSet_iff_exists_ideal` 在数学内容上**是同一命题**：本版 Mathlib
  里 `Ideal R` 是 `@[reducible] def Ideal R [Semiring R] := Submodule R R`（负责人实测
  `#print Ideal`，且 `(I : Set R) = (I : Submodule R R)` 可用 `rfl` 判定），所以「理想 ↔ 子模」
  不需要转换引理。本条目给出的是 CA1 词汇（`Submodule R R`）下的版本，价值在词汇与依赖归属，
  不是新数学；叙述层已明确披露这一点。
- Mathlib 角色分类中「正式承载／桥／私有后端」是按公开签名与证明体人工分类；机器只验证了类型。
  本批 `frozen.declarations` 为空（无 sorry 原型），所以 pack 里没有机器可读的冻结签名。
- **跨条目口径问题（Main-side 决策）**：L1 的 `VectorSpace.lean` 头部自述「mathlib 的
  `Module`/`Submodule` 等只出现在 `:= by` 之后，绝不出现在定理描述里」，但同一文件的 `IsBasis`
  公开定义体已经含 `Submodule.span`。本条目公开使用 `Submodule`/`LinearMap` 与 L1 的**实际**
  做法一致、与 L1 的**自述**纪律不一致。本批不擅改 L1 文档，建议 Main 统一两门口径
  （要么修订 L1 头部说明，要么把 L1 的 `IsBasis` 改成教材记号）。
- 上层使用者的 Mathlib 级证据是 `ca1-verify` 的 grep + 抽验（19 条中抽验 6 条 `文件:行`），
  不是逐条编译验证；`Submodule.comap`/`Submodule.map` 只核对了签名，未做使用级验证。
- `mathlib` 字段按「出现在公开签名里的 Mathlib 名」填写；`RingHomSurjective` 只在
  `LinearMap.range` 的定义处作为实例需求出现、不进本条目公开签名，故未列入。
  （`scripts/audit.py` 不检查 `mathlib` 字段，无机械约束。）
- 未跑 `check_axioms.py --all`、`audit.py`、`subject_package` 之外的 Main-side 流水线；
  `axioms`/`proof_sha` 未生成（条目尚未登记 Registry，脚本会写派生文件）。
- 未运行全库 `lake build`（学科负责人不做）；本批结论只到「目标模块 + 依赖闭包 + 聚合 `#check`」。
- 未 push、未建 PR、未删 worktree。

## 12. 下一批可稳定依赖 / 不可依赖的 API

- **可稳定依赖**：`Module`/`Submodule`/`LinearMap` 承载本身；`module_axioms`、
  `submodule_closure`、`submodule_of_closure`（CA1 生成子模条目可直接复用它的构造方向）、
  `submodule_eq_iff`、`linearMap_iff`、`linearMap_ext_iff`、`linearMap_map_zero`、
  `linearMap_mem_ker_iff`、`linearMap_mem_range_iff`、`isSubspace_iff_exists_submodule`、
  `twoSidedIdealSet_iff_exists_submodule_self`。
- **不可依赖**：生成子模、商模、同构定理、直和（本批不存在）；`Submodule.mk` 的字段顺序、
  `LinearMap` 父结构是 `AddHom` 这类实现细节（Mathlib 升级可能变），只应在证明体内使用。
- 本批公开签名一旦 Main 集成即冻结为 definition 层；后续批次若需弱化/替换应走
  `SUBJECT-MAINTENANCE-ROLE.md` 的 M1/M2 流程。

## 13. 协议反馈（试点首跑，如实记录）

1. **`pack_id` 粒度与本批形状不匹配（主要摩擦点）**。`pack_id = f"{subject}-{batch}-{entry}"`
   （`scripts/context_pack.py:299`），`trace.path` 也由 entry 唯一决定（同文件 `:349`）。本批只有
   一个 Entry 却要派 2 个所有权不重叠的子 Agent，于是：第二个 pack 只能写到另一个文件名、但
   `pack_id` 与第一个完全相同；`ca1-verify` 的 trace 也只能改写到自己的 jsonl，否则与
   `ca1-lean-core` 并发 append 同一文件会让 `attempt` 序号竞争（脚本用
   `last_attempt(trace_id)+1` 计算，无锁）。**具体后果**：按 `pack.trace.path` 去收轨迹，
   会漏掉 `ca1-verify` 的全部 14 条记录——只有 `pack_id` 字段本身是可靠的 join key。
   建议：`build` 增加 `--worker`/`--pack-id`/`--task-id` 开关，或把 `pack_id`（join key）与
   `trace.path`（任务文件）分开推导。
2. **`check` 不检测 `pack_id` 重复**：两个 pack 文件同 `pack_id` 时
   `context_pack.py check` 仍报「通过」，`subject_package.py` 也用 set 去重，于是
   `pack_id → pack 文件` 不再唯一，训练样本配对会歧义。
3. **`--lean-file` 的语义与包内字段不一致**：CLI 帮助写 `CommutativeAlgebra/Module/Definition.lean`
   （相对 `SandronesLibrary/`），而 pack 里 `target.lean_file` 存的是
   `SandronesLibrary/CommutativeAlgebra/Module/Definition.lean`（相对仓库根）。子 Agent 直接读包
   才不会找错路径；建议统一并在帮助里写明。
4. **`goal` 字段对接口侦察类尝试没有约定**：`#check`/`#print` 侦察没有「待证命题」，
   Playbook §8.4 要求 `goal` 是 Lean pretty-print 的类型/目标。本次按「查询表达式 + 期望签名」
   写；建议 §8.4 补一句 `#check` 类尝试的 `goal` 写法，否则不同 Agent 会写出不可比的东西。
5. **pack 无法表达「本批冻结范围」**：本批 `frozen.declarations` 为空（无 sorry 原型），
   而「生成子模/商模/同构定理/直和不许碰」这条边界只能靠负责人手写进派工提示词。建议 pack 支持
   从 ROADMAP 行或 `--frozen-entries` 推导「本批不碰的条目 id」，让边界也进 join key。
6. **`playbook.sections` 关键词路由对「定义层 + 桥」任务覆盖有限**：本批命中的 6 节里没有
   §2「意图↔tactic 映射」的具体条目（目标是写定义与短证明，不是硬分析目标）。不是 bug，
   但说明路由规则需要一条「定义层/接口核对」分支。
7. **`#print axioms` 是失败编译的 `sorryAx` 探针（子 Agent 发现，值得进 Playbook）**：
   编译失败后残留 `?_` 洞会被当成 `sorryAx`，`#print axioms` 会如实报出来。`ca1-verify` 用它
   自查证明干净度。建议在 Playbook §3 公理纪律里补这一条：**任何"部分通过"的编译都要用
   `#print axioms` 复核是否混入 `sorryAx`**。
8. **隐式 binder 陷阱值得进 Playbook §2**：`LeftIdealSet`/`IsSubspace` 的分量用 `∀ ⦃x⦄, …`
   隐式绑定，把裸 lambda 塞进嵌套 `And` 的匿名构造子时，Lean 会把第一个显式参数当成隐式 binder
   的类型（`hx : R` 而不是 `x ∈ S`）。`ca1-verify` 三次复现、`ca1-lean-core` 也踩过一次；
   修法是先 `refine ⟨_, ?_, …⟩` 再 `intro`。本批已有 trace 记录（`ca1-mathlib-role-probe`
   attempt 5/7/10），但 Playbook 未登记该模式。
