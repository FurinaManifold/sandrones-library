# Analysis maintenance handoff：函数有限点极限定义

## 交付定位

- 分支：`codex/analysis-maintenance-uniform-compact`
- 基线：`9e630ea`
- 成果提交：`5c98905`
- 维护说明：`docs/maintenance/analysis-function-limit-definition.md`
- 影响等级：M1
- 范围：新增教材 ε-δ 定义与 `Tendsto` 等价桥；不改既有定理接口。

## 新增 API

```lean
FunctionConvergesToAt (f : ℝ → ℝ) (a L : ℝ) : Prop
functionConvergesToAt_iff_epsilon_delta
functionConvergesToAt_iff_tendsto :
  FunctionConvergesToAt f a L ↔ Tendsto f (𝓝[≠] a) (𝓝 L)
```

当前全库 Lean 中匹配去心邻域 `Tendsto ... 𝓝[≠]` 的使用共 32 处，全部位于 Analysis；课程文档
中共 12 处。这些是保留的正式接口使用，不是待清零债务。

## 文件与共享状态建议

- 修改 `SandronesLibrary/Analysis/FuncLimit.lean`、定义条目和 Analysis 定义审计。
- 新增维护说明与本 handoff。
- Main 可保持 Registry id `analysis.func-limit.definition`，把角色更新为本库 ε-δ 定义及 Mathlib 桥。
- ROADMAP 完成状态不变；RADAR 不应建立替换 `Tendsto` 的任务；顶层 import 不变。

## 边界

原极限唯一、四则运算、Heine 原理、无穷远极限和复合极限均未改签名。无穷远、单侧及无穷值
极限的教材定义仍待分别补齐。Main 的全库 build 不在本维护分支执行。

## 验证

- 修改后的 `FuncLimit.lean` 使用同一锁定依赖缓存类型检查通过；仅出现文件中既有 tactic 建议警告。
- 临时聚合检查同时 `#check` 新定义、两个新桥和既有极限唯一接口，通过。
- `#print axioms functionConvergesToAt_iff_tendsto`：
  `[propext, Classical.choice, Quot.sound]`。
- `python3 scripts/audit.py`：381 个条目通过。
- 定义文档严格包含规定的八个一级标题，顺序正确。
- 修改源码未发现 `sorry`、`admit`、`sorryAx` 或 `native_decide`；`git diff --check` 通过。
