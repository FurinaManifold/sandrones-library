# 分析维护说明：函数有限点极限定义

## 现状与补充

`analysis.func-limit.definition` 已有 `tendsto_nhds_iff_eps_delta`，但其左侧直接以 `Tendsto` 表示
函数极限，ε-δ 公式只作为定理右侧出现。本轮给去心邻域函数极限的教材量词命名为：

```lean
def FunctionConvergesToAt (f : ℝ → ℝ) (a L : ℝ) : Prop :=
  ∀ ε > 0, ∃ δ > 0, ∀ x, |x - a| < δ → x ≠ a → |f x - L| < ε
```

新增定义展开 `functionConvergesToAt_iff_epsilon_delta`，并由既有 ε-δ 定理证明：

```lean
functionConvergesToAt_iff_tendsto :
  FunctionConvergesToAt f a L ↔ Tendsto f (𝓝[≠] a) (𝓝 L)
```

## 接口与边界

本项是 M1 定义补充。`func_lim_unique`、四则运算、Heine 原理与复合极限继续使用 `Tendsto`；
这是正式接口复用，不是后续必须替换的债务。新定义不增加 notation、instance 或 simp 属性。

## 只读影响证据

- 直接源码使用者：`Analysis/FuncLimit.lean`、`ClassicalLimits.lean`、`Derivative.lean`、`MVT.lean`。
- 全库 Lean 中匹配去心邻域 `Tendsto ... 𝓝[≠]` 的使用共 32 处，全部位于 Analysis；课程文档中
  共 12 处。它们是有效 Mathlib 接口使用，不是待清零债务。
- Entry premises：`analysis.func-limit.comp`、`analysis.func-limit.heine`、
  `analysis.continuity.definition`、`analysis.derivative.definition` 和 `analysis.limits.classical`
  直接依赖 `analysis.func-limit.definition`。
- 间接上层包括连续性、导数、中值定理和经典极限计算。
- 导入闭包：新定义位于原 `FuncLimit.lean`，没有新增 import；普通 `Prop` 不影响 instance、notation
  或 simp 搜索。

本轮只处理有限点、有限值、双侧去心极限；无穷远极限、单侧极限和无穷极限各自有不同量词，
不得用本定义冒充。共享 Registry、RADAR、ROADMAP 和顶层 import 不在维护分支修改。

回滚点为 `9e630ea`；回滚不会影响任何既有 API。
