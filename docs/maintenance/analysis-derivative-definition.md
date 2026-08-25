# 分析维护说明：一元导数教材定义

## 现状与补充

`Analysis/Derivative.lean` 此前用注释把 `HasDerivAt` 称为导数定义，却没有在源码中展示教材的去心
差商极限。本轮新增：

```lean
def HasDerivativeAtTextbook (f : ℝ → ℝ) (f' x : ℝ) : Prop :=
  Tendsto (fun y => (f y - f x) / (y - x)) (𝓝[≠] x) (𝓝 f')
```

并证明 `hasDerivativeAtTextbook_iff_hasDerivAt`。桥使用 `hasDerivAt_iff_tendsto_slope` 和
`slope_def_field`，两个方向无额外前提。

## 接口边界

本项为 M1 定义补充。`HasDerivAt`、`DifferentiableAt` 和 `deriv` 继续用于导数唯一、四则运算、
链式法则及反函数求导；不要求替换，不设退役计划。教材谓词负责说明具体导数值，
`DifferentiableAt` 负责表达导数存在，`deriv` 是 Mathlib 选出的导数值。

本轮只处理实函数在一点的双侧有限导数，不处理单侧导数、高阶导数、向量值导数或 Fréchet 导数。
新定义不增加 notation、instance 或 simp 属性。共享状态和顶层 import 仍由 Main 处理。

回滚点为 `9bda755`，回滚不影响任何既有 API。
