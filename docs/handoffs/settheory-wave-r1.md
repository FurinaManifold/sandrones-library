# 集合论 Wave R1（ST3 纵深两项）集成交接清单

- 分支：`codex/settheory-wave-r1`
- worktree：`/home/pisquare/czt/sandrones-library-settheory-r1`
- 基线：`7dffe37`（Main 当前尖端，worktree 直接从该提交建立，未另行 rebase）
- 提交：`1a2b104`（原始递归函数类）、`5564ea3`（通用 runner 实例）
- 范围：ST3 纵深两条 🚧 课程门
  - `settheory.googology.primitive-recursive-class`
  - `settheory.computability.universal-machine-instance`

本轮未派独立子 Agent：两个文件所有权独立但总量只有两条 Entry，为保持同一 worktree
`git index` 与 `.lake/build` 单写者纪律，由负责人（唯一验收人）独立完成并逐项审核。

## 源码与叙述层文件

新增（均为本学科所有权目录，未触碰任何 Main 共享文件）：

- `SandronesLibrary/SetTheory/PrimitiveRecursiveClass.lean`
- `docs/entries/settheory/googology/primitive-recursive-class.md`
- `SandronesLibrary/SetTheory/UniversalMachineInstance.lean`
- `docs/entries/settheory/computability/universal-machine-instance.md`

## 顶层导入建议（Main 执行）

```lean
import SandronesLibrary.SetTheory.PrimitiveRecursiveClass
import SandronesLibrary.SetTheory.UniversalMachineInstance
```

`UniversalMachineInstance` 已显式导入 `PartialComputability` 与 `BinaryMachineCoding`；
`PrimitiveRecursiveClass` 导入 `SandronesLibrary.SetTheory.Googology` 与 mathlib 的
`Mathlib.Computability.Primrec.List`。

## Registry 建议

| id | kind | lean_file | premises | mathlib | provenance.ref |
|---|---|---|---|---|---|
| `settheory.googology.primitive-recursive-class` | `definition` | `SandronesLibrary/SetTheory/PrimitiveRecursiveClass.lean` | `settheory.googology.primitive-recursion` | `Nat.Primrec'`, `Nat.Primrec'.prim_iff`, `Nat.Primrec'.prec'`, `Nat.Primrec'.comp'`, `Finset.range` | `odifreddi-classical-recursion-1989` |
| `settheory.computability.universal-machine-instance` | `definition` | `SandronesLibrary/SetTheory/UniversalMachineInstance.lean` | `settheory.computability.universal-interpreter-spec`, `settheory.computability.binary-machine-coding` | `Nat.pair`, `Nat.unpair`, `Function.Injective` | `odifreddi-classical-recursion-1989` |

两个 ref 键均已在 `reference.bib` 定义（`odifreddi-classical-recursion-1989`，行 159）；
建议 Main 集成时按现有 Odifreddi 条目登记，不新增 BibTeX。`axioms`／`proof_sha` 由
`check_axioms.py` 生成，本 handoff 不写派生字段。

## ROADMAP 建议

- §12 ST3 待开发表第 1 行 `settheory.googology.primitive-recursive-class`：数学已交付，建议在
  Main 集成后由 🚧 转 verified，并注明「教科书类承载为 `Nat.Primrec'`，已补有界求和／求积与
  有限迭代闭包；Ackermann 非原始递归仍属第 2 行」。
- §12 ST3 待开发表第 9 行 `settheory.computability.universal-machine-instance`：建议由 🚧 转
  verified，并把旧边界「没有构造其实例」更新为「已构造 `noncomputable` 元层实例；它不是
  `NatProgram` 自身，不含自解释器」。
- §1 阶段表 ST3 纵深：在 Main 完成集成前**不得**由 🚧 改 ✅。剩余 🚧 为
  `hereditary-encoding-order`、`hydra-general-descent`。

## RADAR 建议（新增的实际使用 Mathlib API）

- `Nat.Primrec'`、`Nat.Primrec'.prim_iff`、`Nat.Primrec'.comp'`、`Nat.Primrec'.prec'`
- `Nat.Primrec'.const`、`Nat.Primrec'.head`、`Nat.Primrec'.tail`、`Nat.Primrec'.get`、
  `Nat.Primrec'.Vec`、`Nat.Primrec'.cons`
- `Finset.sum_range_succ`、`Finset.prod_range_succ`
- `Nat.pair`、`Nat.unpair`、`Nat.unpair_pair`

## Playbook 教训候选

1. `Finset.range` 上的有界递归要与 `Finset.sum_range_succ` 对齐时，把累加写成
   `Nat.rec 0 (fun y IH => IH + f y)`（累加在 `IH` 之后），否则递归顺序与“在末尾追加一项”相反，
   需要额外的交换律才能拼回。
2. 对 `n` 元函数类 `Nat.Primrec'`，`prec'` 的递归步接收 `y ::ᵥ IH ::ᵥ v`；想实现“有限迭代”
   必须读 `IH`（`w.tail.head`）并显式忽略 `y`，否则会把“步数”误当“累加器”。
3. 解码函数中不要在 `match decodeMachineNat …` 内部直接 `rw [Nat.unpair_pair]`：该改写位于
   依赖匹配的 motive 内，会报 “motive is not type correct”。把“按偏移解码”抽成独立的
   `decodeProgramPair offset index`，先在**函数引数位置**重写配对，再化简匹配。

## 核心概念清单（教材解释层）

| 概念 | 教材定义／语义 | Lean 正式承载 | 展开／刻画 | Mathlib 复用说明或桥 | 首个使用者 | Entry |
|---|---|---|---|---|---|---|
| 原始递归函数类 | 含零函数、后继、投影，并对复合与原始递归封闭的最小类（Odifreddi） | mathlib `Nat.Primrec'`（`List.Vector ℕ n → ℕ`） | 构造子 `zero`/`succ`/`get`/`comp`/`prec`；到一元配对形式的一手刻画 `Nat.Primrec'.prim_iff` | 语义一致，**直接复用**，不重造同构谓词 | `primrec_boundedSum` 等闭包定理；`primrec_primitiveRecursion` | `settheory.googology.primitive-recursive-class` |
| 有界求和／求积 | `Σ/Π_{i<b v} f(i,v)` 仍为原始递归 | 定理结论中的 `Fun + Finset.sum/prod` | 定理本身即刻画（递归式 `IH ± f y` + `sum/prod_range_succ`） | `Finset.sum_range_succ` 等仅作验证后端 | 下游增长／支配路线 | 同上 |
| 有限迭代 | 对初值施加 `count v` 次单步 | 定理 `primrec_iterated`（`Nat.rec` 形式） | 结论即 `Nat.rec (base v) (step ·) (count v)` | `Nat.Primrec'.prec'` 组装，非新结构 | 带燃料增长层级 | 同上 |
| 程序自然数编码 | 状态偏移与固定状态数机器代码的可分离编号 | 本库 `encodeNatProgram`／`decodeNatProgram` | 左逆 `decodeNatProgram_encodeNatProgram`、单射 `encodeNatProgram_injective` | `Nat.pair`/`Nat.unpair`；`Fintype.equivFin`（`noncomputable` 后端） | `universalNatInterpreter` | `settheory.computability.universal-machine-instance` |
| 通用 runner | 满足 `UniversalNatInterpreter` 字段的通用模拟器 | 本库 `universalNatInterpreter : UniversalNatInterpreter` | `simulate` 字段：逐燃料忠实模拟 | 复用 `PartialComputability` 正式规格；输出等价复用 `universal_outputs_encode_iff` | `universalNatInterpreter_outputs_encode_iff` | 同上 |

## 公开签名四类扫描

- **语义一致的正式公开承载（第 1 类）**：`Nat.Primrec'` 及其构造子／`prim_iff`；
  `Function.Injective`；`Nat.pair`／`Nat.unpair`／`Nat.unpair_pair`；`Finset.sum`／`prod`／`range`；
  本库既有的 `UniversalNatInterpreter`、`ProgramOutput`、`interpretWithin`、`NatProgram`。
- **本库特殊定义的桥侧接口（第 2 类）**：无新增桥；`encodeNatProgram`／`decodeNatProgram` 是
  规格到实例的实现，两侧语义一致。
- **未泄漏的私有证明后端（第 3 类）**：`fallbackNatProgram`、`decodeProgramPair`（均 `private`）；
  `Finset.sum_range_succ`／`prod_range_succ` 只进入证明体。
- **越级公开泄漏（第 4 类）**：无。未出现高阶结构、全局实例选择或未披露 typeclass。

## 定义链聚合验证（全部实测）

```bash
lake env lean /tmp/sandrones-library/aggregate.lean
```

同时导入两个新模块并 `#check` 11 个关键公开 API（两个 Entry 的正式承载、展开／刻画、桥与上层
使用者），以及 `#print axioms`：

- `primrec_boundedSum`：`[propext, Classical.choice, Quot.sound]`
- `primrec_boundedProd`：`[propext, Classical.choice, Quot.sound]`
- `primrec_iterated`：`[propext, Quot.sound]`
- `primrec_primitiveRecursion`：`[propext, Quot.sound]`
- `encodeNatProgram_injective`：`[propext, Classical.choice, Quot.sound]`
- `universalNatInterpreter`：`[propext, Classical.choice, Quot.sound]`
- `universalNatInterpreter_outputs_encode_iff`：`[propext, Classical.choice, Quot.sound]`

`primrec_boundedSum/Prod` 的 `Classical.choice` 来自 `Finset.sum_range_succ`／`prod_range_succ`
的证明路径（Playbook §3.1 的“借道经典引理”型噪声）；`UniversalMachineInstance` 的
`Classical.choice` 来自 `Fintype.equivFin` 有限枚举后端。两者均非新增数学公理，已按实披露。

声明映射（`scripts.check_axioms.map_entry_to_decl`）：

- `settheory.googology.primitive-recursive-class` → 4 个公开声明，均在
  `SandronesLibrary/SetTheory/PrimitiveRecursiveClass.lean`；
- `settheory.computability.universal-machine-instance` → 7 个公开声明，覆盖
  `encodeNatProgram`、`decodeNatProgram`、`decodeNatProgram_pair`、
  `decodeNatProgram_encodeNatProgram`、`encodeNatProgram_injective`、`universalNatInterpreter`、
  `universalNatInterpreter_outputs_encode_iff`，均在
  `SandronesLibrary/SetTheory/UniversalMachineInstance.lean`。

## 已运行的验证

- `df -h /`：开工前可用 16G；闭包构建后可用 13G（>3G，未触发停机）。`.lake/packages` 为指向主
  worktree 的符号链接；未运行 `lake update`／`lake exe cache get`。
- 模块编译：`lake build SandronesLibrary.SetTheory.PrimitiveRecursiveClass
  SandronesLibrary.SetTheory.UniversalMachineInstance` → 921 jobs 通过，零新增 warning。
- 学科依赖闭包：对 `SandronesLibrary/SetTheory/**.lean`（49 个模块）执行定向
  `lake build <全部 SetTheory 模块>` → 8754 jobs 通过。唯一 warning 是**既有**文件
  `SandronesLibrary/SetTheory/Zorn.lean:61:20` 的格式提示，与本批无关。
- 聚合 `#check`／公理探测：见上节。
- 禁用占位扫描：两文件零命中 `sorry`／`admit`／`sorryAx`／`native_decide`／`TODO`／`FIXME`。
- 叙述层：两篇文档均恰含 8 个一级标题、front matter id 与
  `docs/entries/{id/点转斜杠}.md` 路径一致。
- `git diff --check`：两提交均干净。
- 学科验收包：`python3 scripts/subject_package.py --worktree
  /home/pisquare/czt/sandrones-library-settheory-r1 --base 7dffe37 --subject settheory`
  → `verdict: pass`（五组门全部 pass，无异常）。

## 诚实边界

- `primitive-recursive-class`：只冻结函数类并证明三条派生闭包。**不含** Ackermann 非原始递归性
  （ROADMAP 第 2 行，仍 🔒）、无界 `μ`-算子闭包、一般递归函数等价或支配定理。`Nat.Primrec'`
  允许投影与配对编码，不能据此把“属于类”读成字面上只有一个递归变量。
- `universal-machine-instance`：`encodeNatProgram`／`decodeNatProgram` 与实例均为 `noncomputable`
  （依赖 `Fintype.equivFin` 有限枚举与 `Classical.choice`）；该 runner 是**元层自然数函数**，
  不是本库 `NatProgram` 自身，因此不构成自解释器；`eval` 固定燃料返回 `none` 只是尚未停机，
  不产生停机判定算法，也不推出停机不可判定或 Busy Beaver 不可计算。
- 本批**没有**修改 `hereditary-encoding-order`、`hydra-general-descent` 相关文件；两条仍为 🚧。
- 未运行全库 `lake build`；学科闭包构建不能报告为全库通过。

## 可稳定依赖的 API（下一批）

`primrec_boundedSum`、`primrec_boundedProd`、`primrec_iterated`、`primrec_primitiveRecursion`、
`encodeNatProgram`、`decodeNatProgram`、`decodeNatProgram_pair`、
`decodeNatProgram_encodeNatProgram`、`encodeNatProgram_injective`、`universalNatInterpreter`、
`universalNatInterpreter_outputs_encode_iff`。

## 下一批建议

1. `settheory.googology.hereditary-encoding-order`：继续证明一般换底重编码保持 `omegaValue`
   （即未证明前提 `CanonicalBaseChangeOmegaCompatible` 的正向桥）。
2. `settheory.googology.hydra-general-descent`：取消最右脊柱证书限制。
3. `settheory.googology.ackermann-domination` 仍为 🔒：本批函数类与有界闭包是必要前置，但支配
   定理与“非原始递归”仍需独立证明，不得由本批暗示已完成。

`hereditary-encoding-order` 与 `hydra-general-descent` 两条线可并行，因为文件所有权不重叠；
若同 worktree 并行，建议由负责人串行安排 Lean 构建（`.lake/build` 单写者）。
