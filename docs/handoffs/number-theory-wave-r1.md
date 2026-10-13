# Handoff: number-theory-wave-r1（N2.1–N2.3 数域 / 代数整数 / 整数环）

- 学科：数论（number-theory）
- 批次：N2.1–N2.3（ROADMAP §11 N2 表第 1–3 行；开发权限 `development_open`）
- 分支：`codex/number-theory-wave-r1`
- worktree：`/home/pisquare/czt/sandrones-library-number-r1`
- 基线：`ed6459a`（main，与主工作树一致）
- 交付状态：数学与源码已提交，待 Main 集成共有文件；**未 push**

## 1. 范围

只新建数论所有权目录下的三个 definition-layer 模块及其教材条目：

| Entry id | Lean 文件 | 教材文档 |
|---|---|---|
| `number-theory.algebraic.number-field` | `SandronesLibrary/NumberTheory/Algebraic/NumberField.lean` | `docs/entries/number-theory/algebraic/number-field.md` |
| `number-theory.algebraic.algebraic-integer` | `SandronesLibrary/NumberTheory/Algebraic/AlgebraicInteger.lean` | `docs/entries/number-theory/algebraic/algebraic-integer.md` |
| `number-theory.algebraic.ring-of-integers` | `SandronesLibrary/NumberTheory/Algebraic/RingOfIntegers.lean` | `docs/entries/number-theory/algebraic/ring-of-integers.md` |

未触碰任何 Main 共享文件（无 `SandronesLibrary.lean`、registry、ROADMAP、RADAR、bib、生成文件、`scripts/**`）。

## 2. 提交

| commit | 内容 |
|---|---|
| `a4ec77178d18afc49df217dc2d943bd294d59f66` | N2.1 number field textbook layer |
| `b33d0197d616dcef3d6b3d902c945b105580ced7` | N2.2 algebraic integers textbook layer |
| `25b796d1e70cd3bc457a2bcd0fef3e2ed6c10f6e` | N2.3 ring of integers textbook layer |

源码 blob：
- `NumberField.lean` = `05efbcc21491a550b5f35cb8a340b6e3f7d50243`
- `AlgebraicInteger.lean` = `15398dd194f2dcf7d98272dc198b4ca3edcb6ff5`
- `RingOfIntegers.lean` = `d74196bf042e033d77da7dd3532dd4e0bb7c2c84`

handoff 提交：本文件所在提交（也见 `git log`）。

## 3. 冻结的核心概念清单

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 数域 | 特征零且为 `ℚ` 的有限维扩张 | Mathlib `NumberField K`（class） | `numberField_iff : NumberField K ↔ FiniteDimensional ℚ K`（`[CharZero K]`） | 语义一致的正式公开承载，直接复用，无桥 | `numberField_of_module_finite`、`numberField_exists_primitive_element` | `number-theory.algebraic.number-field` |
| 有限扩张封闭 | 数域的有限扩张仍是数域 | Mathlib `NumberField.of_module_finite` | 定理 `numberField_of_module_finite` | 语义一致，正式承载 | `numberField_of_module_finite` | 同上 |
| 子域封闭 | 数域的子域仍是数域 | Mathlib `NumberField.of_subfield` | 定理 `numberField_of_subfield` | 语义一致，正式承载 | `numberField_of_subfield` | 同上 |
| 单生成元 | 存在 `α` 使 `ℚ(α)=K` | Mathlib `Field.exists_primitive_element` | `∃ α, IntermediateField.adjoin ℚ {α} = ⊤` | 语义一致；可分离性由特征零自动 | `numberField_exists_primitive_element` | 同上 |
| 代数整数（整元素） | 首一多项式零点 | Mathlib `IsIntegral R x` | `isIntegral_iff_monic`（`Iff.rfl`） | 语义一致的正式公开承载 | `isIntegral_add`、`isIntegral_rat_iff`、N2.3 全篇 | `number-theory.algebraic.algebraic-integer` |
| 整闭包 | 全体整元素构成的子环 | Mathlib `integralClosure R A`（`Subalgebra`） | `isIntegral_iff_mem_integralClosure` | 谓词 ↔ 子代数成员的桥，方向：成员 ⇒ `IsIntegral`；成员由 `IsIntegral` 直接得到（`Iff.rfl`） | `isIntegral_add` 等 | 同上 |
| `ℤ` 整闭 | `ℤ` 含其分式域中整元素 | Mathlib `IsIntegrallyClosed ℤ` | `int_isIntegrallyClosed` | 语义一致；实例来自 `GCDMonoid.toIsIntegrallyClosed` | `isIntegral_rat_iff` | 同上 |
| 有理代数整数定理 | `ℚ` 中代数整数必为整数 | `isIntegral_rat_iff` | `IsIntegral ℤ q ↔ ∃ n : ℤ, (n:ℚ)=q` | 本库组合结论，非新定义 | 教材结论 | 同上 |
| 整数环 `𝓞_K` | `K` 中在 `ℤ` 上整的元素全体 | Mathlib `NumberField.RingOfIntegers K`（`= integralClosure ℤ K`） | `ringOfIntegers_mem_iff : IsIntegral ℤ x ↔ ∃ y, algebraMap y = x` | 语义一致的正式公开承载；成员桥 `IsIntegralClosure.isIntegral_iff` | `ringOfIntegersMk`、`ringOfIntegers_rank` | `number-theory.algebraic.ring-of-integers` |
| 整数环结构 | 分式域 `K`、整闭、秩 `[K:ℚ]` | `IsIntegralClosure` / `IsFractionRing` / `IsIntegrallyClosed` / `NumberField.RingOfIntegers.rank` | `ringOfIntegers_isFractionRing` / `_isIntegrallyClosed` / `_rank` | 语义一致，正式承载 | 本文件定理 | 同上 |

## 4. 公开签名四类归属

1. **语义一致的正式公开承载**（推荐复用）：`NumberField`、`NumberField.of_module_finite`、
   `NumberField.of_subfield`、`NumberField.isAlgebraic`、`IsIntegral`、`integralClosure`、
   `IsIntegralClosure`、`IsIntegrallyClosed`、`NumberField.RingOfIntegers`、
   `IsFractionRing`、`Module.finrank`、`Field.exists_primitive_element`。
   公开签名中出现的所有 Mathlib 专用对象都属此类，均有教材解释。
2. **本库特殊定义的桥侧接口**：`ringOfIntegers_mem_iff`（整数环子类型 ↔ `IsIntegral`）、
   `isIntegral_iff_mem_integralClosure`（整闭包子代数 ↔ `IsIntegral`）、
   `ringOfIntegersMk`（由整元素构造整数环元素）。方向均已写清，无缺失反向。
3. **私有证明后端**：无（所有辅助都直接调用 Mathlib 公开接口）。
4. **超出课程层级的公开泄漏**：无。

命名纪律记录：初稿曾把 `isIntegral_algebraMap`、`isIntegral_intCast` 公开命名，与 Mathlib 根命名
冲突（`open` 命名空间后产生 ambiguous term）。已改名为 `algebraMap_isIntegral`、`intCast_isIntegral`
并重新编译通过。这是负责人自检发现并修复的唯一问题。

## 5. 定义链聚合 `#check` 与公理（真实输出）

命令（worktree 内）：

```bash
lake build SandronesLibrary.NumberTheory.Algebraic.NumberField \
  SandronesLibrary.NumberTheory.Algebraic.AlgebraicInteger \
  SandronesLibrary.NumberTheory.Algebraic.RingOfIntegers
lake env lean /tmp/sandrones-library/aggregate.lean
```

`lake build`：`Build completed successfully (2058 jobs)`。

聚合文件同时导入三个模块并 `#check` 正式承载、刻画、桥与上层使用者，全部通过（0 error）。
`#print axioms` 关键声明：

```
numberField_exists_primitive_element depends on axioms: [propext, Classical.choice, Quot.sound]
isIntegral_rat_iff                depends on axioms: [propext, Classical.choice, Quot.sound]
ringOfIntegers_rank               depends on axioms: [propext, Classical.choice, Quot.sound]
```

`Classical.choice` 来自 `ℚ`/域的代数与序结构及 Mathlib 既有证明路径，属结构必需，非形式化噪声；
`Quot.sound`、`propext` 为 Lean 内建。

## 6. 验证命令与结果

| 命令 | 结果 |
|---|---|
| `lake env lean SandronesLibrary/NumberTheory/Algebraic/NumberField.lean` | rc 0，无 warning |
| `lake env lean .../AlgebraicInteger.lean` | rc 0，无 warning |
| `lake env lean .../RingOfIntegers.lean` | rc 0，无 warning |
| `lake build <三个模块>` | rc 0，2058 jobs |
| 聚合 `#check` + `#print axioms` | rc 0 |
| 禁用占位扫描 `grep -rnE "\b(sorry\|admit\|sorryAx\|native_decide)\b"` | 无命中 |
| `git diff --check` | 干净 |
| `python3 scripts/subject_package.py --worktree <wt> --base ed6459a --subject number-theory` | 见 §7 |

磁盘纪律：构建前后 `df -h /` 可用 15G；未触发 3G 停止线。只做三个目标模块的定向构建，
未运行 `lake update` / `lake exe cache get`，未运行全库 `lake build`。`.lake/packages` 已符号链接到主工作树。

## 7. subject_package 自检

命令：

```bash
python3 scripts/subject_package.py \
    --worktree /home/pisquare/czt/sandrones-library-number-r1 \
    --base ed6459a --subject number-theory
```

结果：`verdict: pass`（五组门 cleanliness / ownership / semantics / proof / coverage 全 pass，
异常清单为空）。完整输出见交付报告。

## 8. Main 需更新的共享文件（建议清单，本分支未修改）

1. **`SandronesLibrary.lean`**：在现有 `NumberTheory.Elementary.*` import 之后新增三行：
   ```lean
   import SandronesLibrary.NumberTheory.Algebraic.NumberField
   import SandronesLibrary.NumberTheory.Algebraic.AlgebraicInteger
   import SandronesLibrary.NumberTheory.Algebraic.RingOfIntegers
   ```
2. **`index/registry.json`**：登记三个条目，建议字段如下（`axioms`/`proof_sha`/`dependedOnBy`
   由生成器写，勿手工填）：
   - `number-theory.algebraic.number-field`
     - kind `definition`，state `verified`
     - title「数域与有限扩张」；summary 见 Entry 文档 front matter
     - `premises: []`
     - `mathlib: [NumberField, NumberField.of_module_finite, NumberField.of_subfield, NumberField.isAlgebraic, Field.exists_primitive_element]`
     - `provenance: {source_type: book, ref: "ireland-rosen-number-theory-1990"}`
     - `lean_file: "NumberTheory/Algebraic/NumberField.lean"`
     - `nl_file: "docs/entries/number-theory/algebraic/number-field.md"`
   - `number-theory.algebraic.algebraic-integer`
     - kind `definition`，state `verified`
     - `premises: []`
     - `mathlib: [IsIntegral, integralClosure, IsIntegralClosure, IsIntegrallyClosed, GCDMonoid.toIsIntegrallyClosed, Polynomial.eval₂]`
     - provenance 同上；`lean_file: "NumberTheory/Algebraic/AlgebraicInteger.lean"`；
       `nl_file: "docs/entries/number-theory/algebraic/algebraic-integer.md"`
   - `number-theory.algebraic.ring-of-integers`
     - kind `definition`，state `verified`
     - `premises: ["number-theory.algebraic.number-field", "number-theory.algebraic.algebraic-integer"]`
     - `mathlib: [NumberField.RingOfIntegers, IsIntegralClosure, IsFractionRing, IsIntegrallyClosed, NumberField.RingOfIntegers.rank, Module.finrank]`
     - provenance 同上；`lean_file: "NumberTheory/Algebraic/RingOfIntegers.lean"`；
       `nl_file: "docs/entries/number-theory/algebraic/ring-of-integers.md"`
   - 注意 `premises` 目前是**语义前提**（文件未直接 import 另两个模块）；如 Main 的审计器要求
     premises 必须对应真实 import，请降级为 `premises: []` 并在正文保留依赖叙述。
3. **`docs/ROADMAP-LONGTERM.md`**：§11 N2 表第 1–3 行由 🚧 转 ✅；§1 阶段表 Phase 10 状态
   由「N1✅ N2.1–N2.3🚧/其余🔒」改为「N1✅ N2.1–N2.3✅ N2.4–N2.15🔒」；§Wave R R-number 行同步。
   下一批 N2.4（范数/迹）仍 `research_open`，依赖本批已集成的公开载体重开。
4. **`docs/MATHLIB-RADAR.md`**：建议登记本批正式承载 `NumberField`、`IsIntegral`、
   `integralClosure`、`IsIntegralClosure`、`IsIntegrallyClosed`、`NumberField.RingOfIntegers`，
   角色为「语义一致的正式公开承载」。
5. **`reference.bib`**：无需新增 key；沿用已存在的 `ireland-rosen-number-theory-1990`。
6. **派生文件**：按 AGENTS §6 顺序重生成（`extract_registry_references` → `update_dependency_graph`
   → `gen_entries_index` → `gen_entry_rankings` → `check_axioms --all --fix` → `audit` → `git diff --check`
   → 全库 `lake build`）。

## 9. 子 Agent 所有权与退回

本批未派子 Agent（负责人单写者完成）。原因：三个条目是同一定义层的紧耦合链
（`NumberField → IsIntegral → RingOfIntegers`），且核心工作是与 Mathlib 接口逐条核对签名，
并行收益低于合并/冲突成本；hard rule 4 允许 2–3 个而非要求。无子 Agent 分支、无退回记录。
相关纪律已在本文件 §4 记录负责人自检发现并修复的命名冲突。

## 10. 未完成边界（诚实边界）

- 只覆盖 N2.1–N2.3。N2.4 起（范数与迹、判别式与整基、Dedekind 性、分式理想、理想唯一分解、
  类群、分歧、Minkowski、单位定理、赋值、p-进、局部域）**未开始**，其中 N2.4–N2.15 仍 `research_open`。
- 整数环只给秩等式 `finrank ℤ 𝓞_K = finrank ℚ K`；**未建立整基的存在性与构造**，也未给具体数域计算。
- 未涉及 Dedekind 性、分式理想与类群；未引入范数/迹（N2.4）。
- 无 `sorry`/`admit`/`sorryAx`/`native_decide`。
- 未运行全库 `lake build`；本批结论只到「三个模块 + 依赖闭包 + 聚合 `#check`」层级，
  全库通过结论只能由 Main 集成工作树给出。
- 未 push；worktree 与分支保留。

## 11. 下一批可依赖 / 不可依赖的 API

- **可稳定依赖**：`NumberField`（正式承载）、`numberField_iff`、`numberField_of_module_finite`、
  `IsIntegral`（正式承载）、`integralClosure`、`isIntegral_iff_mem_integralClosure`、
  `NumberField.RingOfIntegers`、`ringOfIntegers_mem_iff`、`ringOfIntegersMk`。
- **不可依赖**：`ringOfIntegers_rank` 之外的整基/判别式结论（不存在）；任何 N2.4+ 名称。
- 本批公开签名一旦 Main 集成即冻结为 definition 层；后续批次若需弱化/替换应走
  `SUBJECT-MAINTENANCE-ROLE.md` 的 M1/M2 流程。

## 12. 复现证据附录

### 12.1 subject_package 真实输出（源码/条目/初版 handoff 提交 `c0b88c8`；本附录提交只改 handoff 文本，verdict 不变）

```
学科验收包 number-theory  (codex/number-theory-wave-r1 @ c0b88c8e1)
  基线 ed6459a｜提交 4｜改动文件 7
  ✅ cleanliness
  ✅ ownership
  ✅ semantics
  ✅ proof
  ✅ coverage

  verdict: pass
```

逐 Entry 声明数：`number-theory.algebraic.number-field` 6，`algebraic-integer` 10，
`ring-of-integers` 9；三者 `in_registry: false`（由 Main 登记），`lean_files` 各只有一个文件。

### 12.2 聚合 `#check` 文件（临时，位于 `/tmp/sandrones-library/aggregate.lean`）

```lean
import SandronesLibrary.NumberTheory.Algebraic.NumberField
import SandronesLibrary.NumberTheory.Algebraic.AlgebraicInteger
import SandronesLibrary.NumberTheory.Algebraic.RingOfIntegers

open SandronesLibrary.NumberTheory.Algebraic

#check @numberField_iff
#check @numberField_finiteDimensional
#check @numberField_isAlgebraic
#check @numberField_of_module_finite
#check @numberField_of_subfield
#check @numberField_exists_primitive_element
#check @isIntegral_iff_monic
#check @isIntegral_iff_mem_integralClosure
#check @algebraMap_isIntegral
#check @intCast_isIntegral
#check @isIntegral_add
#check @isIntegral_mul
#check @isIntegral_neg
#check @isIntegral_sub
#check @int_isIntegrallyClosed
#check @isIntegral_rat_iff
#check @ringOfIntegers_mem_iff
#check @ringOfIntegersMk
#check @ringOfIntegersMk_coe
#check @ringOfIntegers_isIntegral
#check @ringOfIntegers_coe_injective
#check @ringOfIntegers_isIntegralClosure
#check @ringOfIntegers_isFractionRing
#check @ringOfIntegers_isIntegrallyClosed
#check @ringOfIntegers_rank
#print axioms numberField_exists_primitive_element
#print axioms isIntegral_rat_iff
#print axioms ringOfIntegers_rank
```

重建后运行 `lake env lean /tmp/sandrones-library/aggregate.lean`，rc 0。
