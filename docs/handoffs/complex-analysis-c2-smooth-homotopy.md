# 复分析 C2 光滑同伦不变 foundation handoff

## 分支、范围与门状态

- 分支：`codex/complex-analysis`，前置提交 `86c389e` 已完成一般局部三角形 Goursat。
- 新源码：`SandronesLibrary/ComplexAnalysis/HomotopyInvariance.lean`。
- 新文档：`docs/entries/complex-analysis/cauchy/smooth-homotopy-foundation.md`。
- 完成 id：`complex-analysis.cauchy.smooth-homotopy-foundation`。
- 本批推进 Main 的第二优先级，但不把一般连续同伦或单连通域原函数记为完成，因此完整 C2 门
  尚未打开。

## 本库定义与后端边界

- 本库公开定义 `C2HomotopicWithin U gamma delta`：存在固定端点的道路同伦，像位于 `U`，且
  标准实正方形延拓为 `ContDiffOn ℝ 2`。这不是 `IsSimplyConnected` 的别名。
- 公开定理 `pathIntegral_eq_of_C2HomotopicWithin` 只使用本库 `HolomorphicOnTextbook`、
  `pathIntegral` 与上述定义；没有假设或调用原函数。
- 私有实现显式计算 `f(z)dz` 的实 Fréchet 导数，并由复乘法交换律证明对称性；Mathlib 的
  `curveIntegral_add_curveIntegral_eq_of_hasFDerivWithinAt` 只承担正方形边界积分公式。

## 负责人开发与审核

- `/tmp/sandrones-complex-homotopy.lean` 先建立一形式导数、对称性、同伦像闭包、四边公式和侧边
  消去的完整框架；逐项消除后无 `sorry` 编译通过，才迁入正式模块。
- 负责人拒绝把 `Path.Homotopic` 直接写进结论：该谓词只给连续同伦，而使用的积分公式要求
  `C²` 延拓。独立 foundation id 保留这一差异。
- 只读核对 Mathlib 官方 PR `leanprover-community/mathlib4#33505`：截至 2026-08-25 仍为 open，
  974 additions、3 changed files；本批不复制该未合入 Riemann 映射证明。

## 验证

- `lake build SandronesLibrary.ComplexAnalysis.HomotopyInvariance`：通过（2749 jobs）。
- 正式模块单文件编译通过。
- 临时聚合文件同时导入 `Goursat`、`CauchyTheorem`、`HomotopyInvariance`，并 `#check`
  `C2HomotopicWithin`、同伦不变主定理和零同伦推论：通过。
- 新文档 front matter、精确八段顺序、段落非空通过自动核对；源码/文档唯一 Entry id 一致。
- 正式源码无 `sorry`、`admit`、`sorryAx`、`native_decide`；`git diff --check` 通过。
- 学科负责人未运行全库 `lake build`。

## Main 共有文件更新建议

- 顶层新增 `import SandronesLibrary.ComplexAnalysis.HomotopyInvariance`。
- Registry 新增 foundation id，并由 Main 重算公理与 proof hash。
- RADAR 登记 `Path.Homotopy`、
  `ContinuousMap.Homotopy.curveIntegral_add_curveIntegral_eq_of_hasFDerivWithinAt`、
  `ContinuousLinearMap.smulRightL` 和 `ContDiffOn`。
- ROADMAP 只登记 C² 同伦 foundation；一般 `complex-analysis.cauchy.homotopy` 与单连通域原函数
  保持未完成。

## 后续稳定 API 与诚实边界

可以稳定依赖：任意开全纯域内给定 `C²` 固定端点同伦时路径积分相等，给定 `C²` 零同伦时闭路
积分为零。仍缺：把普通连续道路同伦在开集内相对端点平滑化，或以多边形逼近独立证明一般同伦；
只有补齐该桥后，才能从标准 `IsSimplyConnected U` 推出全体适当路径的积分无关并构造一般原函数。
Laurent 主线仍不得启动为完整课程条目。
