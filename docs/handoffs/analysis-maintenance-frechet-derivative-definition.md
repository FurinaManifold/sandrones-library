# Analysis maintenance handoff：Fréchet 导数定义

## 交付定位

- 分支：`codex/analysis-maintenance-uniform-compact`
- 基线：`6d2f9c9`
- 成果提交：`69034eb`
- 维护说明：`docs/maintenance/analysis-frechet-derivative-definition.md`
- 影响等级：M1
- 范围：新增余项比值教材定义及 `HasFDerivAt` 桥，不改既有多元微分接口。

## 新增 API

```lean
HasFrechetDerivativeAtTextbook (f : E → F) (A : E →L[ℝ] F) (x : E) : Prop
hasFrechetDerivativeAtTextbook_iff_hasFDerivAt :
  HasFrechetDerivativeAtTextbook f A x ↔ HasFDerivAt f A x
```

`TotalDerivative := E →L[ℝ] F` 保持不变，因为连续线性映射是全微分的正确数据载体。

## 文件与共享状态建议

- 修改 `Analysis/MultivariableCalculus.lean`、`analysis.multivariable.frechet` 文档和定义审计。
- 新增维护说明及本 handoff。
- Main 保持 Registry id，更新为“本库余项比值定义 + Mathlib 桥”；ROADMAP 完成状态不变。
- RADAR 不建立 `HasFDerivAt` 替换任务；顶层 import 无变化。

## 边界

方向导数、梯度、Jacobian、Hessian、Taylor 和链式法则均保持原签名。本批不推广到一般标量域，
不处理高阶 Fréchet 导数，也不运行 Main 的全库 build。

## 验证

- 修改后的 `MultivariableCalculus.lean` 使用同一锁定依赖缓存类型检查通过。
- 临时聚合检查同时 `#check` 新定义、新桥和既有全微分唯一接口，通过。
- `#print axioms hasFrechetDerivativeAtTextbook_iff_hasFDerivAt`：
  `[propext, Classical.choice, Quot.sound]`。
- `python3 scripts/audit.py`：381 个条目通过。
- Fréchet 文档严格包含规定的八个一级标题，顺序正确。
- 修改源码未发现 `sorry`、`admit`、`sorryAx` 或 `native_decide`；`git diff --check` 通过。
