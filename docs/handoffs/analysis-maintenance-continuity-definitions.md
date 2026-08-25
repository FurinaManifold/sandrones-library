# Analysis maintenance handoff：连续性定义

## 交付定位

- 分支：`codex/analysis-maintenance-uniform-compact`
- 基线：`5c98905`
- 成果提交：`9bda755`
- 维护说明：`docs/maintenance/analysis-continuity-definitions.md`
- 影响等级：M1
- 范围：补充三种教材 ε-δ 定义及 Mathlib 桥，不改既有定理接口。

## 新增 API

```lean
ContinuousAtTextbook (f : ℝ → ℝ) (a : ℝ) : Prop
ContinuousOnTextbook (f : ℝ → ℝ) (s : Set ℝ) : Prop
UniformContinuousOnTextbook (f : ℝ → ℝ) (s : Set ℝ) : Prop

continuousAtTextbook_iff_continuousAt
continuousOnTextbook_iff_continuousOn
uniformContinuousOnTextbook_iff_uniformContinuousOn
```

三个桥均为无附加前提的双向等价。原常函数、四则运算、介值、最值、反函数连续、一致连续推出连续
以及 Heine–Cantor 定理全部保持原签名。

## 文件与共享状态建议

- 修改 `SandronesLibrary/Analysis/Continuity.lean`、连续性定义文档和 Analysis 定义审计。
- 新增维护说明与本 handoff。
- Main 保持 Registry id `analysis.continuity.definition`，将 kind/说明更新为本库三层教材定义及桥。
- ROADMAP 完成状态不变；RADAR 不建立 Mathlib 接口替换任务；顶层 import 无变化。

## 边界

本批没有把三种定义推广到一般度量空间，没有改变任何现有定理的 `Continuous*` 前提，也没有运行
Main 的全库 build。

## 验证

- 修改后的 `Continuity.lean` 使用同一锁定依赖缓存类型检查通过。
- 临时聚合检查同时 `#check` 三个新定义和三条桥，通过。
- 三条桥的 `#print axioms` 均为 `[propext, Classical.choice, Quot.sound]`。
- `python3 scripts/audit.py`：381 个条目通过。
- 连续性定义文档严格包含规定的八个一级标题，顺序正确。
- 修改源码未发现 `sorry`、`admit`、`sorryAx` 或 `native_decide`；`git diff --check` 通过。
