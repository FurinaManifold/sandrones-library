# F1 泛函分析基础 handoff

- 分支：`codex/functional-analysis`
- Main 基线：`8d5d823`
- 设计 RFC：`docs/maintenance/functional-analysis-f1-design.md`
- 当前阶段：按最新 Playbook 完成重复定义收缩；算子解释层已重新验证

## 路线结论

- 赋范／Banach 空间复用已验收 Topology 条目。
- `ContinuousLinearMap` 是“线性且连续”的语义一致正式承载。
- 算子范数直接采用该承载上的 Mathlib 范数，以基本估计和最小界性质完成教材解释。
- 绝对可和直接写 `Summable (fun n ↦ ‖f n‖)`；闭子空间直接采用 `Submodule` 加 `IsClosed`。

## 重复造轮子修正

- 已删除 `IsBoundedLinearOperator` 及人工打包桥。
- 已撤回未提交的 `operatorBounds`、`operatorNorm := sInf ...`。
- `Operator.lean` 改为正式承载、全局界刻画与有界／连续等价；不创建平行接口。

## Main-side 建议

- ROADMAP F1 第 1 项标记为复用 `topology.normed-space.def`，不要创建重复 Entry。
- 后续集成新增 `SandronesLibrary.FunctionalAnalysis.*` imports、实际新 Entry 的 Registry 和 RADAR；
  共有文件不由本分支修改。

## 尚未完成

- 算子空间、Banach 级数和商空间尚未按新复用规则实现。
- F2/F3/F4 保持锁定。

## 修正版验证

- `lake build SandronesLibrary.FunctionalAnalysis.Operator`：8708 jobs 通过；只重放既有 Topology
  格式警告。
- 聚合 `#check` 覆盖正式承载、算子范数基本估计、三条展开性质和有界／连续等价；公理检查通过。
- Entry 映射：continuous-linear-map 3 个声明，bounded-iff 1 个声明；无自建核心 `def`。
- 禁用占位扫描和 `git diff --check` 通过。
