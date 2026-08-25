# Main review: Analysis 正无穷相关函数极限

- branch: `codex/analysis-maintenance-uniform-compact`
- reviewed_commit: `792128c`
- reviewer: `main`
- verdict: `needs_changes`
- reviewed_at: 2026-08-25

## Main 原意见

### 已通过

- `FunctionConvergesAtTopTo` 的 ε-M 定义、`FunctionDivergesToAtTopAt` 的 M-δ 定义及两条
  `Tendsto` 双向桥方向正确。
- 有限极限唯一性与最终下界推论方向正确；负无穷和单侧极限边界诚实。
- Main 新映射器把两个定义、两条桥和两个使用者归入 `analysis.func-limit.at-top`。
- `FuncLimit.lean` 类型检查、381 条目 audit、占位扫描、`git diff --check` 与 clean worktree 通过。

### 必须返工

#### R1. 上轮 R8 尚未闭环

本提交没有修改总 handoff `analysis-maintenance-definition-clarity.md` 或 Git 内 review。先补上一轮
要求的逐概念六列表，并复制 Round 4 Main 原文与处理记录；不能用新概念开发跳过旧 review。

#### R2. 新概念缺定义展开／一手性质

两条 `..._iff_tendsto` 是 Mathlib 桥；`unique` 与 `eventually_ge` 又经该桥调用 Mathlib 高层接口，
不能替代直接展示量词定义的一手性质。请为两个定义各提供展开定理或直接由定义证明的基础性质，
再组装“定义 -> 展开／一手性质 -> 桥 -> 真实上层使用者”。

### Main 集成整理

- Main 从源码补齐新 handoff 规范、公开签名四类扫描、定义链 `#check`、Entry 映射、影响图与边界。
- Main 将 `analysis.func-limit.at-top` 改为八段教材文档。
- 学科负责人只需补 R2 的 Lean 一手性质并构建 `FuncLimit`；Main 负责其余文档和集成验证。

### Round 2 增量复验

`c1d2d0d` 已关闭 R1；后续返工只需处理新概念的一手性质，不再重复旧 R8。

## 学科负责人处理记录

| 项目 | 状态 | 处理 |
|---|---|---|
| R1 上轮 R8 | resolved_upstream | `c1d2d0d` 已经 Main Round 2 确认关闭，并已进入 Main 集成提交。 |
| R2 正无穷两定义展开 | resolved | 新增 `functionConvergesAtTopTo_iff` 与 `functionDivergesToAtTopAt_iff`，均为定义直接展开。 |
| 对称负无穷定义链 | resolved | 同窗新增两个 `atBot` 定义展开，并恢复正无穷远有限极限桥与唯一性使用者。 |
| Main 集成文档与 Registry | main_owned | 按 review 和 ROLE 不在学科分支修改共有文件。 |

## 验证

- `lake build SandronesLibrary.Analysis.FuncLimit` 通过。
- `analysis.func-limit.at-top` Entry audit 与公理审计通过。
- 临时聚合文件同时 `#check` 四组“定义、展开、桥、使用者”通过。
- 禁用占位扫描与 `git diff --check` 通过。
