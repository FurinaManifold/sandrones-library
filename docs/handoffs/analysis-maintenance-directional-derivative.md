# Analysis maintenance handoff：方向导数定义

## 范围

- Entry：`analysis.multivariable.frechet`
- 模块：`SandronesLibrary.Analysis.MultivariableCalculus`
- 目标：补齐沿固定方向的一元去心差商定义；不替代 Mathlib 接口。

## 定义与桥

- `HasDirectionalDerivativeAtTextbook f d x v`：`t → 0` 且 `t ≠ 0` 时，
  `t⁻¹ • (f (x + t • v) - f x)` 趋于 `d`。
- `hasDirectionalDerivativeAtTextbook_iff_hasLineDerivAt`：与
  `HasLineDerivAt ℝ f d x v` 完全等价。
- `frechetDerivativeTextbook_hasDirectionalDerivativeAtTextbook`：Fréchet 可微单向推出
  固定方向可导，值为 `A v`。

## 教材使用者与边界

- `hasDirectionalDerivativeAtTextbook_unique` 给出固定方向导数唯一性。
- 不提供“各方向可导推出 Fréchet 可微”的反向命题；该命题一般不成立。
- 既有 `DirectionalDerivative := fderiv ...` 计算接口保留，未进行全面 API 替换。

## 验证

- `lake build SandronesLibrary.Analysis.MultivariableCalculus` 通过。
- `python3 scripts/audit.py analysis.multivariable.frechet` 通过。
- `python3 scripts/check_axioms.py analysis.multivariable.frechet` 通过，公理集合与 Registry 一致。
- 修改范围内禁用占位扫描和 `git diff --check` 通过。
