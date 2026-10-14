# Examples handoff — E0 存量转正 + E1（集合、映射、基数与序数）

- **学科**：Examples（跨学科计算例巡视，`docs/roles/EXAMPLES-MAINTAINER-ROLE.md`）
- **分支**：`codex/examples-e1`
- **worktree**：`/home/pisquare/czt/sandrones-library-examples-e1`（`.lake/packages` 符号链接到主 worktree；无 `.lake/build` 复制）
- **基线**：`bc8d4feb59f639aa440d7719466297d918e9dd28`（Main `feat(dispatch): 派工文档改为脚本渲染（Playbook §10）+ 十个窗口定义`）
- **角色权限**：`development_open`（Wave D D9 窗口；简令 `docs/dispatch/e9-examples-e1.md`）
- **提交**：见 §9（handoff 与交付同批提交；未 push）
- **同步 Main**：本窗基线即 `bc8d4fe`，开工时 `git status` 除 4 个未跟踪 pack 外干净；未做 rebase（基线未前进）。

## 1. 范围与权威范围表

**权威范围表是 `docs/ROADMAP-examples.md` 的 E0 与 E1 两节**，不是简令 §1 的表。简令 §1 的 4 行
只是 Main 建了 pack 的那 4 条（E1.1–E1.4）；本窗按 ROADMAP 执行了：

| 批次 | 内容 | 本窗结果 |
|---|---|---|
| E0.2 | 坐标积分与球体矩 | 4 个既有 Examples 模块中的 2 个转正（`examples.analysis.coordinate-integrals`、`examples.analysis.spherical-moments`） |
| E0.3 | Green/Gauss/Stokes 具体区域 | 另 2 个转正（`examples.analysis.green-regions`、`examples.analysis.gauss-stokes`），并按出口要求补**定向反例** |
| E0.4 | 既有 `analysis.integral.examples`、Taylor examples 归档 | 影响审计完成，结论**保留不迁移**（见 §4 与 `docs/maintenance/examples-e0-impact-audit.md`） |
| E1.1–E1.4 | 集合运算／映射性质／等价关系与商／可数性 | 4 个新 Entry（有 Main 生成的 pack） |
| E1.5–E1.7 | 基数算术／序数基础／序数算术 | 3 个新 Entry（开工门 ST2／ST1／序数运算主线均已满足；负责人按 Playbook §10.3 自建 `--role sub-agent --worker` pack 后派工） |
| E1.8 | 递归与增长 | **本窗不做**（简令 §9：等 ST3 纵深窗口成果落地后再排） |
| E2–E12 | — | 不做 |

## 2. 交付清单（11 条 Entry）

| Entry id | Lean 文件 | 行 | 公开声明 | 叙述层 | 课程文档行 |
|---|---|---|---|---|---|
| `examples.settheory.set-operations` | `Examples/SetTheory/SetOperations.lean` | 242 | 43 | `docs/entries/examples/settheory/set-operations.md` | 136 |
| `examples.settheory.functions` | `Examples/SetTheory/Functions.lean` | 396 | 53 | `.../functions.md` | 170 |
| `examples.settheory.quotients` | `Examples/SetTheory/Quotients.lean` | 104 | 17 | `.../quotients.md` | 140 |
| `examples.settheory.countability` | `Examples/SetTheory/Countability.lean` | 266 | 39 | `.../countability.md` | 188 |
| `examples.settheory.cardinal-arithmetic` | `Examples/SetTheory/CardinalArithmetic.lean` | 220 | 33 | `.../cardinal-arithmetic.md` | 174 |
| `examples.settheory.ordinals` | `Examples/SetTheory/Ordinals.lean` | 102 | 13 | `.../ordinals.md` | 125 |
| `examples.settheory.ordinal-arithmetic` | `Examples/SetTheory/OrdinalArithmetic.lean` | 191 | 21 | `.../ordinal-arithmetic.md` | 153 |
| `examples.analysis.coordinate-integrals` | `Examples/CoordinateIntegrals.lean` | 86 | 4 | `docs/entries/examples/analysis/coordinate-integrals.md` | 103 |
| `examples.analysis.spherical-moments` | `Examples/SphericalMoments.lean` | 186 | 11 | `.../spherical-moments.md` | 109 |
| `examples.analysis.green-regions` | `Examples/GreenRegions.lean` | 297 | 17 | `.../green-regions.md` | 125 |
| `examples.analysis.gauss-stokes` | `Examples/GaussStokes.lean` | 166 | 11 | `.../gauss-stokes.md` | 125 |

合计：Lean 2256 行、**262 条公开声明**（每条都有 docstring）、课程文档 11 篇、影响审计 1 篇
（`docs/maintenance/examples-e0-impact-audit.md`）。另有 `SandronesLibrary/Examples/README.md`
更新（E0 转正状态 + 7 个新模块）。

**公理画像**：262 条声明的聚合 `#check` 与 16 条关键声明（各 Entry 的反例 + 主计算）的
`#print axioms` 显示，全部公理集 ⊆ `{propext, Classical.choice, Quot.sound}`，**无 `sorryAx`**；
其中 `sq_image_inter_ne`、`doubleAddOne_injective_not_surjective`、`infinite_addition_cancellation_fails`
为 `[propext, Quot.sound]`（不带 choice）。`Classical.choice` 的来源是 ℝ 的序结构／Lebesgue 积分
基础设施与 mathlib 实例路径（Playbook §3.3），未用投影改写伪装零公理（§3.5）。

## 3. E0.2 / E0.3：存量转正明细

四个模块**签名一字未改**（M0 级：只加模块 docstring、Entry 标记与新的反例定理）：

- `examples.analysis.coordinate-integrals`：Entry 标记 + 课程文档；覆盖 `∫₀^π sin φ dφ = 2`、
  `∫₀^R ρ² dρ = R³/3`、球坐标 Jacobian 三重积分 `4πR³/3`、常密度质量 `4πδR³/3`。
- `examples.analysis.spherical-moments`：Entry 标记 + 课程文档；覆盖三个一阶矩为零（重心在球心）、
  `I_z = 8πδR⁵/15`、以及 `I = (2/5)MR²` 的 `ring` 改写。
- `examples.analysis.green-regions`：Entry 标记 + 课程文档 + **定向反例**：
  `standardRightTriangleBoundaryIntegralRev`／`unitDiskBoundaryIntegralRev` 与
  `..._eq_neg`（反向遍历恰好变号）、`standardRightTriangle_rev_ne_ccw`（真计算 `-1/2 ≠ 1/2`）、
  `unitDisk_rev_ne_ccw_of_ne_zero`（非零即不同）。
- `examples.analysis.gauss-stokes`：Entry 标记 + 课程文档 + **定向反例**：
  `boxBoundaryFlux3Inward`／`boxBoundaryFlux3Inward_eq_neg`／`gauss_inward_ne_outward`
  （外向 `3` vs 内向 `-3`）、`horizontalUnitSquareRev`／`stokes_horizontalUnitSquareRev_xDy`
  （交换切向量次序后环流 `-1`）。

**「是否需要定向反例」的判定**：需要。两族公式的左端都是有向量，而右端与定向无关；
本窗把「反向遍历 = 取负」证成定理，并各给一个真数值反例，精确反驳「边界积分／通量与定向无关」。

## 4. E0.4：影响审计（单独成节，结论：保留不迁移）

对象：`analysis.integral.examples`（`RealAnalysis/RiemannIntegralBridge.lean`，5 条声明）与
`analysis.mvt.taylor-examples`（`Analysis/MVT.lean`，1 条声明）。完整审计见
`docs/maintenance/examples-e0-impact-audit.md`，要点：

1. **下游影响 = 0**，三重独立核对：registry `premises` 反向重算为 `[]`（与 `dependedOnBy` 缓存一致）、
   6 条声明在 `SandronesLibrary/**` 内除定义文件外零引用、Examples 侧无 import。
2. **判定保留**，三条理由：① 理论模块不得依赖 Examples，迁移会让未来理论层复用
   `riemannIntegral_pow`／`cos_taylor_second_order` 时被迫反向依赖，是硬伤；② 迁移要改
   RealAnalysis／Analysis 学科文件，属 M2 跨学科操作，不在本窗 `ownership.writable` 内；
   ③ ROADMAP E0.4 的出口是「保留**或**迁移」的二选一审计，本窗给出「保留」支的完整论证。
3. **后续动作**：E2.6／E2.9／E3.3 应把这两条登记为 `premises`，不重算同一批公式。
4. **顺带发现（Main 侧规范化项）**：`analysis.mvt.taylor-examples` 的 front matter 用
   `source_type: textbook`，而 `docs/SCHEMA.md` 只列 `book | paper | generated`；全库有约 55 处
   `textbook` 及 `derived`/`migration`/`library` 等值。`subject_package.py` 不校验该字段，
   本窗新增 11 条 Entry 全部使用 `book`。

## 5. 覆盖合同逐项对照（ROADMAP「必做正例／计算」与「必做反例」）

| ROADMAP 行 | 必做正例／计算 | 必做反例 | 落地 |
|---|---|---|---|
| E1.1 | 两个有限集合逐元素算并、交、差、补；验证 De Morgan | `A∪B=A∪C` 推不出 `B=C` | `A={1,2,3}`、`B={3,4}`、`C={2,4}` 于 `Fin 5`；并／交／差／补各逐元素算成显式集合，De Morgan 两侧各自算成 `{0}`／`{0,1,2,4}` 后相接；`union_eq_but_ne`（∃ 见证）+ `union_right_cancel_not_valid`（全称否定）+ `B_ne_C`、`diff_not_comm` |
| E1.2 | 线性／平方函数的像与原像、单射／满射／双射 | 单射不必满射、满射不必单射；像不保持交 | `doubleAddOne(2n+1)`、`half(n/2)`、`sq(n²)`、`shift(n+1)`；像与原像各逐元素算成显式集合；`doubleAddOne_injective_not_surjective`、`half_surjective_not_injective`、`sq_image_inter_ne`（`∅ ≠ {1}`）+ `exists_image_inter_ne` |
| E1.3 | 模 `n` 同余类与商映射；显式判定两代表元同类 | 不同代表元可给同一商元素 | `modFive : Setoid ℤ`（`a % 5 = b % 5`，含 `↔ 5 ∣ b-a` 刻画）；`7 ≈ 2`、`-3 ≈ 2`、`7 ≉ 1`；`quotient_mk_surjective`；`quotient_mk_eq_not_imp_eq`（`⟦7⟧=⟦2⟧ ∧ 7≠2`）、`quotient_mk_not_injective` |
| E1.4 | `ℕ×ℕ` 配对、整数枚举、两个可数集之并 | 无限集不必不可数；幂集严格更大的有限原型 | `Nat.pair 2 3 = 11`／`unpair 11 = (2,3)`（`decide`）、`intToNat`（`0↦0,3↦6,-1↦1,-4↦7`）与单射、`evens ∪ odds = univ` 及 `ℤ = ⋃ n, {-n,n}`；`infinite_not_imp_uncountable`、`Fintype.card (Fin 3 → Bool) = 8 > 3` 且无满射／无单射 |
| E1.5 | 有限基数加乘幂；可数集与有限集运算 | 基数相等不等于集合相等；无限基数算术不能照搬自然数消去律 | `Fin 2 ⊕ Fin 3 ≃ Fin 5`、`Fin 2 × Fin 3 ≃ Fin 6`、`(Fin 2 → Fin 3) ≃ Fin 9`（`decide` 真算 5／6／9）；`evenNats ∪ {1}` 可数并展开出单射；`cardinal_equinumerous_not_set_eq`、`infinite_addition_cancellation_fails`（`ℕ⊕ℕ ≃ ℕ` 而 `ℕ ≄ Fin 0`）+ 有限对照 |
| E1.6 | `0,1,2,ω,ω+1` 序关系、后继／极限辨析 | `1+ω=ω` 但 `ω+1≠ω`，展示加法不交换 | `zero_lt_one_lt_two_lt_omega_lt_omegaPlusOne`（前两项 `norm_num` 真算）；`omega_is_limit`／`succ_not_limit`／`succ_is_immediate`／`omega_limit_but_omegaPlusOne_not`；`one_add_omega_eq_omega`、`omega_add_one_ne_omega`、`one_add_omega_ne_omega_add_one` |
| E1.7 | 有限序数与 `ω` 的加乘幂、Cantor 正规形小例 | 加法与乘法不交换、消去律失败的具体反例 | `ordinalAdd 3 4 = 7`、`ordinalMul 2 3 = 6`、`ordinalPow 2 3 = 8`（`norm_num`）；`ω+ω = ω*2`、`2*ω = ω`、`ω*2 ≠ ω`、`ω^0=1`、`ω^1=ω`、`ω^2=ω*ω`；`CNF ω ω = [(1,1)]`、`CNF ω (ω+1) = [(1,1),(0,1)]` + foldr 显式求值 + `cantorNormalForm_reconstructs` 实例；`omega_mul_two_ne_two_mul_omega`、`addition_right_cancellation_fails`、`multiplication_right_cancellation_fails` |
| E0.2 | 球体体积、质量、重心、转动惯量 | —（无点名反例） | 见 §3 |
| E0.3 | 三角形、圆盘、立方体、正方形 | 「检查是否需要定向反例」 | 见 §3：需要，且已给 4 条 |

**真计算纪律**：所有数值／低维结果都走 `norm_num`／`decide`／显式求值或逐元素枚举
（`ext x` + `fin_cases`），不是把公式抄一遍；具体清单见各子 Agent 报告与 trace。

## 6. 公开签名四类扫描

- **语义一致的正式承载（直接复用，不另造包装）**：`Set.ext`／`Set` 运算、`Function.Injective`／
  `Surjective`／`Bijective`、`Quotient`／`Quotient.eq`／`Setoid`、`Countable`／`Set.Countable`／
  `Nat.pair`／`Nat.pairEquiv`、`Int.ModEq`／`ZMod`、`Equinumerous`／`FiniteByEnumeration`（本库
  `CardinalTheory`）、`Ordinal`／`Ordinal.CNF`、本库 `ordinalAdd`／`ordinalMul`／`ordinalPow`、
  `xNormalDomain`／`yNormalDomain`／`boxBoundaryFlux3`／`rectangleBoundaryIntegral`。
- **本库定义的桥一侧**：`omegaPlusOne`（= `ordinalAdd ω 1`）、`omegaPlusOneOrd`（同）、
  `modFive`（`Setoid ℤ`）、`intToNat`、`evens`／`odds`／`intHalves`、`twoElemSet`／`twoElemSetShifted`、
  `evenNats`／`oneSet`、`TwoSumThree`／`TwoProdThree`／`ThreePowTwo`（本库 `CardinalSum` 等的
  具体承载）、`U`／`A`／`B`／`C`、`doubleAddOne`／`half`／`sq`／`shift`、`standardRightTriangleRev`
  系列与 `boxBoundaryFlux3Inward`／`horizontalUnitSquareRev`。均为**例子对象命名**，不是新概念定义。
- **私有证明后端**：`E1.7` 文件内两条 `private` 桥（`ordinalAdd_eq_add`／`ordinalMul_eq_mul`）、
  各文件里 mathlib 的积分／序数自动化引理；未作为公开前提或结论。
- **越级泄漏**：未发现。新增公开签名的类型只出现上述正式承载与具体对象；原生 `+`／`*` 未在
  E1.7 的公开签名中泄漏（桥是 private）。**反向依赖扫描**：`SandronesLibrary/{Analysis,RealAnalysis,
  SetTheory,...}` 无任何 `import SandronesLibrary.Examples`。

## 7. 验证证据（现场命令与真实结果）

```bash
# 0) 依赖预热（Mathlib olean 经 .lake/packages 符号链接复用）
lake build SandronesLibrary.SetTheory.{Set,Function,Relations,Cardinal,Ordinal,CardinalTheory,OrdinalPowerBridge}
# → Build completed successfully (8711 jobs)

# 1) 删 olean 强制重编 11 个交付模块（一次跑完）
rm -f .lake/build/lib/lean/SandronesLibrary/Examples/{,SetTheory/}*.olean ...
lake build SandronesLibrary.Examples.SetTheory.SetOperations ... SandronesLibrary.Examples.GaussStokes
✔ [8744/8754] Built SandronesLibrary.Examples.SetTheory.Ordinals (1.4s)
✔ [8745/8754] Built SandronesLibrary.Examples.SetTheory.OrdinalArithmetic (1.5s)
✔ [8746/8754] Built SandronesLibrary.Examples.SetTheory.Quotients (3.1s)
✔ [8747/8754] Built SandronesLibrary.Examples.SetTheory.SetOperations (3.5s)
✔ [8748/8754] Built SandronesLibrary.Examples.SetTheory.Functions (3.5s)
✔ [8749/8754] Built SandronesLibrary.Examples.SetTheory.Countability (3.6s)
✔ [8750/8754] Built SandronesLibrary.Examples.SetTheory.CardinalArithmetic (3.6s)
✔ [8751/8754] Built SandronesLibrary.Examples.GaussStokes (3.6s)
✔ [8752/8754] Built SandronesLibrary.Examples.CoordinateIntegrals (3.8s)
✔ [8753/8754] Built SandronesLibrary.Examples.GreenRegions (4.1s)
✔ [8754/8754] Built SandronesLibrary.Examples.SphericalMoments (2.7s)
Build completed successfully (8754 jobs).        # 零 error、零 warning

# 2) 聚合 #check（262 条公开声明，11 个模块联合导入）
lake env lean /tmp/sandrones-library/e1_aggregate.lean
# → exit 0；0 error；284 行 `#check` 输出（含 @ 展开的签名）

# 3) 禁用占位扫描（11 个交付文件）
grep -rnE '\b(sorry|admit|sorryAx|native_decide)\b' <11 files>   # → 无匹配

# 4) 公理画像（16 条关键声明，含每个 Entry 的反例）
lake env lean /tmp/sandrones-library/e1_aggregate.lean | grep -A3 "depends on axioms"
# → 全部 ⊆ {propext, Classical.choice, Quot.sound}；无 sorryAx；3 条不含 choice

# 5) Entry ↔ 声明映射（scripts/check_axioms.py 的 map_entry_to_decl）
# → 11 个文件各恰 1 个 Entry 标记；归属声明数 43/53/17/39/33/13/21/4/11/17/11（合计 262）

# 6) git diff --check → clean
# 7) 未运行 lake update / lake exe cache get / 裸 lake build（全库构建是 Main 职责）
```

**负责人独立复核抓到并修掉的三件事**（子 Agent 的「完成」不是验收）：

1. **假依赖边**：`SetOperations.lean` 原样只 `import` 理论模块而**没有任何声明级引用**；
   `Functions.lean` 的 `set.ext`／`preimage-union`／`preimage-inter` 三条 premises 也是
   「文档上对应、代码里没调用」。负责人补了 9 条 `*_via_theory`／`*_instance` 实例定理
   （`Set.ext`、`subset_iff_forall_mem`、`inter_distrib_left`、`complement_union`、
   `complement_inter`、`diff_inter_complement`、`preimage_union`、`preimage_inter` 直接作用在
   具体对象上），使 6+6 条 premises 成为真实的声明级依赖，同时让这批零下游的理论条目
   第一次有公开上层使用者（AGENTS §4 第 5 条）。
2. **公理探针会解析失败的声明名**：`Ordinals.lean` 3 条与 `OrdinalArithmetic.lean` 6 条写成
   `theorem foo.{u}`。`check_axioms.py` 的 `DECL_RE` 允许名字里带 `.`，会把源码名捕成 `foo.`，
   而 `#print axioms foo.` 报 `unexpected token '.'` → 公理字段会变成 `<解析失败>`（现场实测）。
   改为文件级 `universe u` + 声明名不带后缀，9 条重跑公理探针全部正常，签名仍宇宙多态。
3. **文档声明映射缺口**：`cardinal-arithmetic.md` 有 9 条声明（命名对象、显式双射、等势见证）
   未出现在 Lean 对照块，`ordinal-arithmetic.md` 缺 `omegaPlusOneOrd_eq`；已补齐。

## 8. pack 与 trace（Playbook §8／§9）

**pack 清单（15 个，全部 `context_pack.py check` 通过；另有基线自带的 2 个 CA1 pack）**：

| 用途 | pack_id |
|---|---|
| 窗口（Main 生成，role `subject-maintainer`） | `examples-E1-examples.settheory.{set-operations,functions,quotients,countability}` |
| worker-a（`--role sub-agent --worker worker-a`） | `examples-E1-examples.settheory.{set-operations,functions}-worker-a` |
| worker-b | `examples-E1-examples.settheory.{quotients,countability}-worker-b` |
| worker-c | `examples-E1-examples.settheory.{cardinal-arithmetic,ordinals,ordinal-arithmetic}-worker-c` |
| E0（负责人自建，batch `E0`） | `examples-E0-examples.analysis.{coordinate-integrals,spherical-moments,green-regions,gauss-stokes}` |

**trace 清单（15 个 jsonl、65 条记录；accepted 38 / error 27；`lean_trace.py check` 通过）**：

| trace 路径 | 条数 |
|---|---|
| `traces/lean/examples/examples.settheory.set-operations.jsonl`（窗口 pack，负责人复验） | 2 |
| `traces/lean/examples/examples.settheory.set-operations-worker-a.jsonl` | 7 |
| `traces/lean/examples/examples.settheory.functions.jsonl`（窗口 pack，负责人复验） | 1 |
| `traces/lean/examples/examples.settheory.functions-worker-a.jsonl` | 8 |
| `traces/lean/examples/examples.settheory.quotients.jsonl`（窗口 pack，负责人复验） | 1 |
| `traces/lean/examples/examples.settheory.quotients-worker-b.jsonl` | 8 |
| `traces/lean/examples/examples.settheory.countability.jsonl`（窗口 pack，负责人复验） | 1 |
| `traces/lean/examples/examples.settheory.countability-worker-b.jsonl` | 12 |
| `traces/lean/examples/examples.settheory.cardinal-arithmetic-worker-c.jsonl` | 5 |
| `traces/lean/examples/examples.settheory.ordinals-worker-c.jsonl`（含负责人修复轮） | 5 |
| `traces/lean/examples/examples.settheory.ordinal-arithmetic-worker-c.jsonl`（含负责人修复轮） | 7 |
| `traces/lean/examples/examples.analysis.coordinate-integrals.jsonl` | 1 |
| `traces/lean/examples/examples.analysis.spherical-moments.jsonl` | 1 |
| `traces/lean/examples/examples.analysis.green-regions.jsonl` | 4 |
| `traces/lean/examples/examples.analysis.gauss-stokes.jsonl` | 2 |

失败留痕都是真实编译器结论（`ring` 无法跨积分原子、`rw` 自抵消、`decide` 卡
`Set.decidableEq` 的 `Classical.choice`、`surj_comp` 名字不存在、`Ordinal.natCast_add`／
`Ordinal.zero_le`／`Ordinal.opow_two` 不存在、`foo.{u}` 探针语法错等）。

## 9. 学科包自检

见 §13（在提交后运行，原文抄录）。五组门与 `traces`／`packs` 两行以现场输出为准。

## 10. 未完成边界（诚实披露）

1. **E1.8 未做**（简令 §9 明确本窗不做，等 ST3 纵深成果落地）。
2. **`E1.4` 的整数枚举只证了单射**（`intToNat_injective`），这正是前提 `countable-def`
   「可嵌入 ℕ」所需；未构造显式双射 `ℤ ≃ ℕ`，也未证满射。文档已写明。
3. **`E1.5` 的配对与等势见证直接复用 mathlib**（`Nat.pairEquiv`、`finSumFinEquiv`、
   `finProdFinEquiv`、`NatSumNatEquivNat`），未另造本库包装（ROLE「不另造包装」）。
4. **`E1.7` 的 Cantor 正规形是降级点**：只做 `CNF ω ω` 与 `CNF ω (ω+1)` 的真算列表 +
   foldr 显式求值 + 库内 `cantorNormalForm_reconstructs` 实例，**未**证一般 `ω²+ω+1` 的展开。
5. **`E1.7` 与 ROADMAP 原文的出入**：ROADMAP 写「左消去失败」，实测**相反**——序数加法
   **左消去成立**（`addition_left_cancellation`）、**右消去失败**（`1+ω = 2+ω = ω` 而 `1≠2`）。
   按 ROLE「不制造伪反例」把成立方向证成定理、失败方向做成反例，并在课程文档「应用与陷阱」
   显式登记；**建议 Main 修订 ROADMAP E1.7 的「必做反例」文字**（ROADMAP 是 Main 共享文件）。
6. **理论接口请求**：`SetTheory/Ordinal.lean` 的 `ordinalAdd_eq_mathlib`／`ordinalMul_eq_mathlib`
   是 `private`，Examples 无法调用，E1.7 只能在文件内 private 重证两条一行桥。建议理论侧
   公开这两条桥或补 `ordinalAdd` 的左零／消去律接口（属集合论学科，本窗不改理论模块）。
7. **`E1.6`／`E1.7` 的 premises 按「直接使用」给**（2 条／5 条），不是 pack 的前提闭包
   （5 条／9 条）：`no-infinite-descent`、`transfinite-induction`、`supremum`、`order-type`
   在该 Entry 里没有声明级引用。
8. **`E0.4` 的两条理论 Entry 未迁移**（判定为保留），跨学科迁移路径写在审计文档 §4。
9. **未登记 Registry、未改 `SandronesLibrary.lean`、未改 ROADMAP／RADAR／reference.bib**：
   均为 Main 共享文件，更新建议见 §12。
10. **未跑全库 `lake build`**：本窗只做定向构建（Main 职责）。

## 11. 子 Agent 与负责人审核发现

- 三个子 Agent（worker-a：E1.1+E1.2；worker-b：E1.3+E1.4；worker-c：E1.5+E1.6+E1.7），
  文件所有权不重叠，各自 2／2／3 个 Lean 文件与对应叙述层。
- **我亲自验的**：11 个模块的强制重编、262 条聚合 `#check`、占位扫描、16 条公理探针、
  Entry↔声明映射、`git diff --check`、每条 premises 的**声明级使用面 grep**、
  文档 front matter 的 id↔路径↔ref↔premises 机械校验、以及 §7 的三处修复。
- **采信子 Agent 的**：各自文件内部的逐条数学细节（已抽查反例陈述与真计算写法）、
  以及他们报告的 `#print axioms` 明细（我用聚合探针独立复算过关键 16 条）。
- **退回／修复**：无退回；§7 的三处由负责人直接修复（均记入 trace）。
- **子 Agent 的「完成」不是验收**：本窗的验收是 §7 与 §9 的现场结果。

## 12. 给 Main 的共享文件更新建议

### 12.1 `index/registry.json` 新增 11 条（`axioms`／`proof_sha`／`dependedOnBy`／`added_*` 由生成器产出）

```json
[
 {"id":"examples.settheory.set-operations","kind":"example","state":"verified",
  "title":"有限集上的并、交、差、补与 De Morgan 逐元素计算例",
  "summary":"在有限全集 Fin 5 上取 A={1,2,3}、B={3,4}、C={2,4}，逐元素算出并、交、差、补、交对并分配律与德摩根律两侧，并给出 A∪B=A∪C 推不出 B=C 的精确反例与差集不可交换的辨析",
  "premises":["settheory.set.ext","settheory.set.subset.definition","settheory.set.operations.inter-distrib","settheory.set.operations.complement-union","settheory.set.operations.complement-inter","settheory.set.operations.diff-inter-complement"],
  "mathlib":["Set.ext","Set.mem_insert_iff","Set.mem_singleton_iff","Set.mem_inter_iff","Set.mem_sdiff","Set.mem_compl_iff","Set.union_insert","Set.union_singleton","Set.insert_eq_of_mem","Fin.reduceEq"],
  "provenance":{"source_type":"book","ref":"jech-set-theory-2003"},
  "lean_file":"Examples/SetTheory/SetOperations.lean","nl_file":"docs/entries/examples/settheory/set-operations.md"},
 {"id":"examples.settheory.functions","kind":"example","state":"verified",
  "title":"像、原像与单射／满射／双射的具体计算与反例",
  "summary":"命名线性函数 2n+1、折半函数 n/2、平方函数 n² 与平移函数 n+1，逐元素算出它们的像与原像，并给出单射不必满射、满射不必单射、像不保持交三组精确反例与双射、复合的正例",
  "premises":["settheory.function.inj-comp","settheory.function.surj-comp","settheory.function.image-preimage.preimage-union","settheory.function.image-preimage.preimage-inter","settheory.function.inject-surject.bijective-iff-inverse","settheory.set.ext"],
  "mathlib":["Function.Injective","Function.Surjective","Function.Bijective","Function.LeftInverse","Function.RightInverse","Set.ext","Set.mem_image","Set.mem_preimage","Set.mem_insert_iff","Set.mem_singleton_iff","Set.mem_inter_iff","Set.mem_empty_iff_false","Set.image_empty","Set.image_inter_subset","Nat.mul_div_right","mul_eq_zero"],
  "provenance":{"source_type":"book","ref":"jech-set-theory-2003"},
  "lean_file":"Examples/SetTheory/Functions.lean","nl_file":"docs/entries/examples/settheory/functions.md"},
 {"id":"examples.settheory.quotients","kind":"example","state":"verified",
  "title":"等价关系与商：模 5 同余类、商映射满射与「不同代表元同一商元素」的辨析",
  "summary":"模 5 同余是 ℤ 上的 Setoid，7 与 2 显式判定同类、商映射满射；反例给出 ⟦7⟧ = ⟦2⟧ 而 7 ≠ 2，精确否定「商元素唯一决定代表元」",
  "premises":["settheory.set.relations.equivalence-class-eq","settheory.set.relations.quotient-surj"],
  "mathlib":["Int.ModEq","Int.modEq_iff_dvd","Quotient.eq","Quotient.sound","Quotient.exact","Quotient.mk_surjective","Setoid.ker","ZMod"],
  "provenance":{"source_type":"book","ref":"jech-set-theory-2003"},
  "lean_file":"Examples/SetTheory/Quotients.lean","nl_file":"docs/entries/examples/settheory/quotients.md"},
 {"id":"examples.settheory.countability","kind":"example","state":"verified",
  "title":"可数性：ℕ×ℕ 配对、整数枚举与「无限不必不可数」的辨析",
  "summary":"Nat.pair 的显式配对与真值、ℤ 的显式枚举及其单射、偶数∪奇数与 ℤ = ⋃{-n,n} 两个可数并实例，以及「ℕ 无限却可数」「Fin 3 幂集 2³ = 8 > 3」两条反例",
  "premises":["settheory.cardinal.countable-def","settheory.cardinal.countable-union","settheory.cardinal.uncountable-real"],
  "mathlib":["Nat.pair","Nat.unpair","Nat.pair_unpair","Nat.unpair_pair","Nat.pair_eq_pair","Nat.pairEquiv","Equiv.countable_iff","Set.countable_range","Set.Countable.union","Set.countable_univ","Set.countable_univ_iff","Set.countable_iUnion","Set.infinite_univ","Fintype.card_fun","Fintype.card_le_of_surjective","Fintype.card_le_of_injective","Finset.card_powerset","Int.toNat_of_nonneg"],
  "provenance":{"source_type":"book","ref":"jech-set-theory-2003"},
  "lean_file":"Examples/SetTheory/Countability.lean","nl_file":"docs/entries/examples/settheory/countability.md"},
 {"id":"examples.settheory.cardinal-arithmetic","kind":"example","state":"verified",
  "title":"有限基数加乘幂的计算与基数算术的两个反例",
  "summary":"有限基数加、乘、幂的显式等势见证与真计算，可数集与有限集之并仍可数，以及「基数相等不等于集合相等」「无限基数加法没有自然数那样的消去律」两个精确反例",
  "premises":["settheory.cardinal.addition","settheory.cardinal.multiplication","settheory.cardinal.exponentiation","settheory.cardinal.finite-set","settheory.cardinal.equinumerous","settheory.cardinal.countable-def"],
  "mathlib":["finSumFinEquiv","finProdFinEquiv","finTwoArrowEquiv","Equiv.natSumNatEquivNat","Fintype.card_congr","Fintype.card_fin","Set.range","Set.countable_range","Set.finite_singleton","Set.Countable.union","Fin.elim0"],
  "provenance":{"source_type":"book","ref":"jech-set-theory-2003"},
  "lean_file":"Examples/SetTheory/CardinalArithmetic.lean","nl_file":"docs/entries/examples/settheory/cardinal-arithmetic.md"},
 {"id":"examples.settheory.ordinals","kind":"example","state":"verified",
  "title":"序数 0,1,2,ω,ω+1 的序关系与后继／极限辨析",
  "summary":"把 ω+1 命名并证明它是 ω 的后继，给出 0<1<2<ω<ω+1 的序关系链、极限序数与后继序数的区分，以及 1+ω=ω 但 ω+1≠ω 的加法不交换反例",
  "premises":["settheory.ordinal.addition","settheory.ordinal.successor-limit"],
  "mathlib":["Ordinal.natCast_lt_omega0","Order.not_isSuccLimit_succ","Order.lt_succ","Order.succ_eq_add_one"],
  "provenance":{"source_type":"book","ref":"jech-set-theory-2003"},
  "lean_file":"Examples/SetTheory/Ordinals.lean","nl_file":"docs/entries/examples/settheory/ordinals.md"},
 {"id":"examples.settheory.ordinal-arithmetic","kind":"example","state":"verified",
  "title":"有限序数与 ω 的加乘幂、Cantor 正规形小例",
  "summary":"有限序数加乘幂的真计算、ω 的加乘幂恒等式、加法与乘法不交换的反例、序数加法左消去成立而右消去失败的实测，以及 ω+1 的 Cantor 正规形计算与显式求值",
  "premises":["settheory.ordinal.addition","settheory.ordinal.multiplication","settheory.ordinal.exponentiation","settheory.ordinal.cantor-normal-form","settheory.ordinal.power-bridge"],
  "mathlib":["Ordinal.mul_two","Ordinal.opow_succ","Ordinal.opow_one","Ordinal.add_omega0","Ordinal.natCast_lt_omega0","Ordinal.one_lt_omega0","add_left_cancel","mul_left_cancel₀","one_mul","Ordinal.CNF.opow_mul_add","Ordinal.CNF.of_lt","Order.lt_succ","Order.succ_eq_add_one"],
  "provenance":{"source_type":"book","ref":"jech-set-theory-2003"},
  "lean_file":"Examples/SetTheory/OrdinalArithmetic.lean","nl_file":"docs/entries/examples/settheory/ordinal-arithmetic.md"},
 {"id":"examples.analysis.coordinate-integrals","kind":"example","state":"verified",
  "title":"球体体积与质量的球坐标计算例",
  "summary":"极角积分 ∫₀^π sin φ dφ = 2、径向积分 ∫₀^R ρ² dρ = R³/3，合成半径 R 球体的体积 4πR³/3 与常密度 δ 下的质量 4πδR³/3",
  "premises":["analysis.multivariable.coordinate-integrals"],
  "mathlib":["integral_Ioc_eq_integral_Ioo","intervalIntegral.integral_of_le","integral_sin","integral_pow","integral_const_mul","setIntegral_const"],
  "provenance":{"source_type":"book","ref":"ecnu-mathematical-analysis-5"},
  "lean_file":"Examples/CoordinateIntegrals.lean","nl_file":"docs/entries/examples/analysis/coordinate-integrals.md"},
 {"id":"examples.analysis.spherical-moments","kind":"example","state":"verified",
  "title":"均匀球体的重心与转动惯量计算例",
  "summary":"三个一阶矩（重心坐标）全为零，绕 z 轴的转动惯量为 8πδR⁵/15，并改写为教材形式 I = (2/5)MR²",
  "premises":["analysis.multivariable.coordinate-integrals","analysis.coordinate-integrals.mass-center"],
  "mathlib":["integral_Ioc_eq_integral_Ioo","intervalIntegral.integral_of_le","integral_cos","integral_sin","integral_sin_sq","integral_sin_mul_cos₁","integral_sin_pow_three","integral_pow","integral_const_mul","setIntegral_const","setIntegral_congr_fun","measurableSet_Ioo"],
  "provenance":{"source_type":"book","ref":"ecnu-mathematical-analysis-5"},
  "lean_file":"Examples/SphericalMoments.lean","nl_file":"docs/entries/examples/analysis/spherical-moments.md"},
 {"id":"examples.analysis.green-regions","kind":"example","state":"verified",
  "title":"直角三角形与单位圆盘上的 Green 公式计算例",
  "summary":"两个标准平面区域上的 Green 公式实例、三角形面积型边界积分 1/2，以及边界定向反转使积分变号的精确反例",
  "premises":["analysis.multivariable.green-gauss-stokes","analysis.multivariable.jordan-region"],
  "mathlib":["Real.abs_le_sqrt","Real.sq_sqrt","sq_le_sq₀","sq_abs","abs_le","intervalIntegral.integral_sub","intervalIntegral.integral_of_le","integral_Icc_eq_integral_Ioc","integral_id","integral_neg","setIntegral_congr_fun","measurableSet_Icc","Continuous.intervalIntegrable"],
  "provenance":{"source_type":"book","ref":"spivak-calculus-manifolds-1965"},
  "lean_file":"Examples/GreenRegions.lean","nl_file":"docs/entries/examples/analysis/green-regions.md"},
 {"id":"examples.analysis.gauss-stokes","kind":"example","state":"verified",
  "title":"单位立方体的 Gauss 与水平单位正方形的 Stokes 计算例",
  "summary":"位置向量场在单位立方体上的外向通量为 3、1-形式 x dy 在水平单位正方形上的边界环流为 1，以及法向定向与切向量次序反转改变符号的精确反例",
  "premises":["analysis.multivariable.green-gauss-stokes"],
  "mathlib":["setIntegral_const","integrableOn_const","measure_Icc_lt_top","Real.volume_Icc_pi_toReal","isCompact_Icc","ContinuousLinearMap.fst","Finset.sum_neg_distrib"],
  "provenance":{"source_type":"book","ref":"spivak-calculus-manifolds-1965"},
  "lean_file":"Examples/GaussStokes.lean","nl_file":"docs/entries/examples/analysis/gauss-stokes.md"}
]
```

### 12.2 `SandronesLibrary.lean` 增加 7 条 import

`SandronesLibrary.Examples.SetTheory.{SetOperations,Functions,Quotients,Countability,CardinalArithmetic,Ordinals,OrdinalArithmetic}`
（4 个 E0 分析模块已在 `SandronesLibrary.lean:368-371` 的 import 列表内，无需新增）。

### 12.3 `docs/ROADMAP-examples.md` 覆盖台账建议（Main 共享，本窗未改）

- **E0.2／E0.3 由 `partial` → `covered`**：四个分析模块已补齐 Entry、课程文档与定向反例。
- **E0.4 由 `partial` → `covered`**：影响审计完成，结论保留不迁移
  （`docs/maintenance/examples-e0-impact-audit.md`）。
- **E1.1–E1.7 由 `missing`/计划态 → `covered`**（正例、真计算与点名反例均已 Lean 化）；
  E1.8 保持未做。
- **E1.7 的「必做反例」文字建议修订**：原文「左消去失败」与实测相反，实测为
  **左消去成立、右消去失败**（反例 `1+ω = 2+ω = ω` 而 `1≠2`）。建议改为「右消去失败」，
  并在备注里保留「左消去成立」这一正面结论。
- **E3.3 计划 id `examples.analysis.coordinate-integrals` 已被 E0.2 消耗**；
  **E3.6 计划 id `examples.analysis.integral-theorems` 因「一 Entry 一文件」约束需拆为
  `examples.analysis.green-regions`（三角形／圆盘）与 `examples.analysis.gauss-stokes`
  （立方体／正方形）**，建议 Main 在 E3 排期时改写这两行。

### 12.4 注册后按 AGENTS §6 重建

`extract_registry_references` → `update_dependency_graph` → `gen_entries_index` →
`gen_entry_rankings` → `check_axioms.py --all --fix` → `check_axioms.py --all` → `audit.py` →
`git diff --check` → 全库 `lake build`。

### 12.5 共享工具建议（`scripts/**` 属 Main）

- **`check_axioms.py` 的 `DECL_RE` 口径**：它允许声明名里带 `.`，于是源码 `theorem foo.{u}`
  被捕成 `foo.`，`#print axioms foo.` 报语法错 → 该 Entry 的公理字段会变成 `<解析失败>`。
  本窗已在 9 条声明上绕开（改用文件级 `universe u`），但**建议脚本在 `map_entry_to_decl`
  里剥掉名字尾部的 `.`**，否则任何窗口只要写 `foo.{u}` 就会静默产出坏公理字段。
- **`context_pack.py`**：`prerequisites.entries` 是**闭包**，而 Registry 的 `premises` 要**直接前提**；
  建议拆一个 `prerequisites.direct`。`prerequisites.mathlib` 的 hint 实测有不存在名
  （`Set.image_inter` 实为 `Set.image_inter_subset`；`Ordinal.natCast_add`／`Ordinal.zero_le`／
  `Ordinal.opow_two` 不存在）——建议在 pack 里显式写「提示名需自证」。
- **`pack.target.lean_file`** 用全路径 `SandronesLibrary/Examples/...`，而 `registry.lean_file`
  惯例相对 `SandronesLibrary/`；建议 pack 增 `registry_lean_file` 或注明换算。

## 13. 学科包原文（提交后运行）

见下方「§13 附录」——若本 handoff 中该节为空，则以 Main 复跑为准；本窗在提交后运行
`python3 scripts/subject_package.py --worktree /home/pisquare/czt/sandrones-library-examples-e1 --base bc8d4feb59f639aa440d7719466297d918e9dd28 --subject examples`
并把 `traces`／`packs` 两行与异常清单原文抄进该附录（记录该次运行对应的 head）。
