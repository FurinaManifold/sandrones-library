# ST1 序数理论：集成交接清单

本文件供集成 Codex 使用。学科分支 `codex/settheory-ordinal` 只维护：

- `SandronesLibrary/SetTheory/Ordinal.lean`
- `docs/entries/settheory/ordinal/*.md`

## 顶层导入

在 `SandronesLibrary.lean` 的 SetTheory 区加入：

```lean
import SandronesLibrary.SetTheory.Ordinal
```

## Registry

为以下 13 个条目登记 `SetTheory/Ordinal.lean` 与对应叙述文件：

1. `settheory.ordinal.order-type`
2. `settheory.ordinal.transfinite-induction`
3. `settheory.ordinal.transfinite-recursion`
4. `settheory.ordinal.addition`
5. `settheory.ordinal.multiplication`
6. `settheory.ordinal.exponentiation`
7. `settheory.ordinal.successor-limit`
8. `settheory.ordinal.supremum`
9. `settheory.ordinal.cofinality`
10. `settheory.ordinal.normal-function`
11. `settheory.ordinal.cantor-normal-form`
12. `settheory.ordinal.epsilon-zero`
13. `settheory.ordinal.no-infinite-descent`

标题、premises、mathlib 与 provenance 以各 `.md` 的 front matter 为准。合并源码后运行：

其中 `settheory.ordinal.addition`、`settheory.ordinal.multiplication`、
`settheory.ordinal.exponentiation`、`settheory.ordinal.cofinality` 的 `kind` 均为
`definition`；公开对象分别是 `ordinalAdd`、`ordinalMul`、`ordinalPow`、
`ordinalCofinality`。不要恢复成直接包装 mathlib `+`、`*`、`^`、`.cof` 的 theorem 条目。

```bash
python3 scripts/check_axioms.py --all --fix
```

由脚本重算 `axioms` 与 `proof_sha`，不要从其他分支手工复制派生字段。

## ROADMAP

将 ST1 前缀统一为 `settheory.ordinal.*`，登记上述 13 个核心入口，并将 P11/ST1 标记为完成。
同时保留边界说明：ST1 只建立 `ε₀` 和序数良基下降接口；Goodstein 状态编码、遗传基表示
和单步下降桥仍属于 ST3。

## RADAR

登记以下实际使用的 mathlib API：

- `Ordinal.type_eq`
- `Ordinal.type_nat_lt`
- `Ordinal.type`
- `Ordinal.type_sum_lex`
- `Ordinal.type_prod_lex`
- `WellFoundedLT.induction`
- `Ordinal.limitRecOn`
- `Ordinal.add_omega0`
- `Order.lt_succ`
- `Ordinal.natCast_mul_omega0`
- `Ordinal.mul_two`
- `Ordinal.mul_succ`
- `Ordinal.opow_succ`
- `Ordinal.opow_limit`
- `Order.lt_succ_iff`
- `Ordinal.isSuccLimit_omega0`
- `Ordinal.lt_iSup_iff`
- `Order.cof`
- `Ordinal.cof_toType`
- `Ordinal.cof_zero`
- `Ordinal.cof_add_one`
- `Ordinal.cof_omega0`
- `Ordinal.isNormal_opow`
- `Ordinal.CNF.foldr`
- `Ordinal.omega0_opow_epsilon`
- `Ordinal.epsilon_zero_le_of_omega0_opow_le`
- `Ordinal.lt_wf`

## Playbook 教训候选

序数 API 的短名受 namespace、`open` 与 import 闭包影响。稳定写法应优先使用
`Ordinal.type (α := ℕ) (· < ·)`、`Order.lt_succ`、`WellFoundedLT.induction`，并为
`Ordinal.natCast_mul_omega0` 显式导入 `Mathlib.SetTheory.Ordinal.Principal`。

本轮新增的转正规则：教材核心运算不能直接把 mathlib typeclass 运算当公开定义。
`ordinalAdd` 必须由 `Sum.Lex` 良序的序型定义，`ordinalMul` 必须由 `Prod.Lex` 良序的序型
定义，`ordinalPow` 必须由 `Ordinal.limitRecOn` 定义；原生 `+`、`*`、`^` 仅留在私有
等价桥中。乘法的后继递推必须调用本库 `ordinalAdd`，幂的后继递推必须调用本库
`ordinalMul`，以显式保留定义依赖链。

## 合并后统一验收

```bash
python3 scripts/gen_entries_index.py
python3 scripts/check_axioms.py --all --fix
python3 scripts/audit.py
lake build
```

另需人工检查重复 id、丢失 import、ROADMAP 状态回退与 RADAR 条目覆盖。
