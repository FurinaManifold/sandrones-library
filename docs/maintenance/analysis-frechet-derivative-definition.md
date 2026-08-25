# 分析维护说明：Fréchet 导数教材定义

## 现状与补充

`Analysis/MultivariableCalculus.lean` 已说明 `f(x+h)=f(x)+A(h)+o(‖h‖)`，但源码只把
`TotalDerivative` 别名到连续线性映射，并用 `HasFDerivAt` 表达导数存在。本轮把“小于一阶余项”
写成明确的本库谓词：

```lean
def HasFrechetDerivativeAtTextbook (f : E → F) (A : E →L[ℝ] F) (x : E) : Prop :=
  Tendsto (fun y => ‖y - x‖⁻¹ * ‖f y - f x - A (y - x)‖) (𝓝 x) (𝓝 0)
```

它表达余项范数除以增量范数趋于零。Lean 中 `0⁻¹=0`，所以中心点处表达式取零；这不影响邻域极限。
`hasFrechetDerivativeAtTextbook_iff_hasFDerivAt` 由 Mathlib 的 `hasFDerivAt_iff_tendsto` 直接给出，
无附加前提。

## 接口边界

本项为 M1 定义补充。`E →L[ℝ] F` 仍是全微分正确的数据载体；`HasFDerivAt`、`DifferentiableAt`、
`fderiv`、方向导数、梯度、Jacobian 和链式法则继续使用 Mathlib 正式接口，不要求替换。

本轮不定义一般标量域版本，不修改 `DirectionalDerivative` 在不可微点取零的既有约定，不处理高阶
Fréchet 导数。新定义不增加 notation、instance 或 simp 属性。共享状态由 Main 更新。

回滚点为 `6d2f9c9`，回滚不影响任何既有 API。
