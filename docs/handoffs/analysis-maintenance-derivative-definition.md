# Analysis maintenance handoff：一元导数定义

## 交付定位

- 分支：`codex/analysis-maintenance-uniform-compact`
- 基线：`9bda755`
- 成果提交：`89d78ce`
- 维护说明：`docs/maintenance/analysis-derivative-definition.md`
- 影响等级：M1
- 范围：新增教材差商极限定义和 `HasDerivAt` 桥，不改既有求导接口。

## 新增 API

```lean
HasDerivativeAtTextbook (f : ℝ → ℝ) (f' x : ℝ) : Prop
hasDerivativeAtTextbook_iff_hasDerivAt :
  HasDerivativeAtTextbook f f' x ↔ HasDerivAt f f' x
```

## 文件与共享状态建议

- 修改 `SandronesLibrary/Analysis/Derivative.lean` 和 Analysis 定义审计。
- 新增缺失的 `docs/entries/analysis/derivative/definition.md`、维护说明和本 handoff。
- Main 可登记既有 ROADMAP id `analysis.derivative.definition`，以本库差商定义为概念主位、
  `HasDerivAt` 为正式桥。
- ROADMAP 状态可从只有源码注释的旧状态更新为定义文档与桥均已验证；RADAR 不建立接口替换任务。
- 顶层 import 无变化。

## 边界

既有导数唯一、常数、四则运算、链式法则和反函数求导均保持原签名。本批不处理单侧、高阶、
向量值或 Fréchet 导数，也不运行 Main 的全库 build。

## 验证

- 修改后的 `Derivative.lean` 使用同一锁定依赖缓存类型检查通过。
- 临时聚合检查同时 `#check` 新定义、新桥与既有导数唯一接口，通过。
- `#print axioms hasDerivativeAtTextbook_iff_hasDerivAt`：
  `[propext, Classical.choice, Quot.sound]`。
- `python3 scripts/audit.py`：381 个条目通过。
- 新定义文档严格包含规定的八个一级标题，顺序正确。
- 修改源码未发现 `sorry`、`admit`、`sorryAx` 或 `native_decide`；`git diff --check` 通过。
