# Main review：F4.5 Banach–Dieudonné 弱星闭性判据

- branch: `codex/functional-analysis`
- reviewed_commit: `846febe`
- integrated_commit: `6f85798`
- reviewer: `main`
- verdict: `accepted_main_docs`
- reviewed_at: 2026-08-25

## 验收结论

本批没有调用一个现成 Banach–Dieudonné 终结论后重新命名。证明先从对偶子空间单位球截面的弱星
闭性导出范数闭性和外点正间隙，再用 Banach–Alaoglu 紧性递归取得有限检测块；检测点缩放枚举成
趋零序列后，求值进入 `C₀(ℕ,ℝ)`，在像的商空间上应用 Hahn–Banach，并利用原 Banach 空间的
完备性求和，最终构造消去整个子空间而分离指定外点的原空间向量。弱星闭性及其充要形式由该分离
结果推出，证明链与公开结论强度一致。

正式承载复用 `StrongDual`、`WeakDual`、`Submodule`、`ZeroAtInfty` 和商空间，没有制造平行的
对偶或弱星拓扑。结论只针对实 Banach 空间连续对偶的线性子空间，没有扩大为任意凸集或非线性
集合；`CompleteSpace X` 明确保留。学科负责人提供的单模块与依赖闭包构建、16 条声明映射及公理
报告通过 Main 复验。

初始 Entry 缺少 family、variant、summary，ROADMAP/RADAR/Registry/Examples 也尚未更新；这些
均属 Main 共享文档职责，故数学成果接收后由 Main 补齐，不构成学科返工。

## 后续权限

- F4.5 已接收。
- F4.7 Eberlein–Šmulian：维持 `development_open`。
- F4.8 Krein–Milman：维持 `research_open`。
- F5.2 闭值域：维持 `development_open`；F5.5 Fredholm 定义层维持 `research_open`。
