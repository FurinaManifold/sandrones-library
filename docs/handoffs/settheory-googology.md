# ST3 Googology、递归与增长层级：集成交接清单

本文件供集成 Codex 使用。当前首批新增：

- `SandronesLibrary/SetTheory/Googology.lean`
- `docs/entries/settheory/googology/*.md`

## 顶层导入

```lean
import SandronesLibrary.SetTheory.Googology
```

## Registry

首批登记：

1. `settheory.googology.primitive-recursion`（`definition`）
2. `settheory.googology.hyperoperation`（`definition`）
3. `settheory.googology.ackermann`（`definition`）
4. `settheory.googology.knuth-arrow`（`definition`）
5. `settheory.googology.graham-number`（`definition`）
6. `settheory.googology.hereditary-base`（`definition`）
7. `settheory.googology.goodstein-step`（`definition`）

## 定义边界

`primitiveRecursion`、`hyperOperation` 与 `ackermann` 均为本库自行给出的可执行递归定义。
`Nat.hyperoperation`、`Nat.ack` 只作为 mathlib 对照 API，不得在集成时把公开定义改成薄包装。
`knuthArrow` 显式通过本库 `hyperOperation` 定义；`grahamNumber` 显式通过 64 个有限阶段定义。
遗传基语法把指数递归保留为同一表达式类型，Goodstein 单步只建立换底再减一；尚未登记完整
Goodstein 序列或终止性定理。

本批只建立递归与增长的起点，尚未宣称形式化 Ackermann 非原始递归、Goodstein 终止、PA
不可证性或 Busy Beaver 不可计算性。这些结论需要后续编码与支配定理。

## RADAR

- `Nat.rec`
- `Nat.hyperoperation`
- `Nat.ack`

## 合并后验收

```bash
python3 scripts/gen_entries_index.py
python3 scripts/check_axioms.py --all --fix
python3 scripts/audit.py
lake build
```
