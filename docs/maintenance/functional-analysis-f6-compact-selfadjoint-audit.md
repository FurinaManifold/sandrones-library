# F6.5 紧自伴谱定理接口调查

- 调查基线：Main `0aaf58f`
- 权限：`research_open`
- 目标 Entry：`functional-analysis.hilbert.compact-selfadjoint-spectral`
- 教材：Bühler–Salamon, *Functional Analysis*, Theorem 5.3.15(v)

## 教材页面核对

本调查直接查看 `textbook/Salamon, Functional analysis.pdf` 的渲染页面，没有使用文本抽取：

- PDF 242／印刷 227：Definition 5.3.10 以 `A* = A` 定义 self-adjoint，并说明自伴蕴含正规；
- PDF 244／印刷 229：Theorem 5.3.15(v) 对紧正规算子陈述存在由特征向量组成的正交归一基，
  非零特征值形成有限列或趋零序列，并给出对每个向量的对角展开公式；
- PDF 245／印刷 230：证明分三步完成：互异特征空间正交；广义特征向量退化为普通特征向量；
  所有非零特征空间直和的正交补恰为核。最后在各特征空间选择正交归一基。

ROADMAP 的 F6.5 是上述紧正规结论的紧自伴特例。自伴性保证特征值为实数，因此正式条目不应把
一般正规算子的全部理论或后续连续函数演算一并纳入。

## Mathlib 的准确承载

相关后端位于 `Mathlib.Analysis.InnerProductSpace.Spectrum`。

- 空间：`[RCLike 𝕜] [NormedAddCommGroup E] [InnerProductSpace 𝕜 E] [CompleteSpace E]`；
- 算子：`T : E →L[𝕜] E`；
- 紧性：全局谓词 `IsCompactOperator T`，不是
  `ContinuousLinearMap.IsCompactOperator`；
- 自伴性：连续线性映射强制转换到线性映射后的
  `(T : E →ₗ[𝕜] E).IsSymmetric`。这里不应另建同义 `SelfAdjointOperator` 结构，也不应把
  C*-代数元素谓词 `IsSelfAdjoint` 混作本条承载。

已有公共接口精确覆盖：

1. `LinearMap.IsSymmetric.conj_eigenvalue_eq_self`：自伴算子的特征值为实；
2. `LinearMap.IsSymmetric.orthogonalFamily_eigenspaces`：互异特征空间组成正交族；
3. `ContinuousLinearMap.orthogonalComplement_iSup_eigenspaces_eq_bot`：紧自伴算子的全部特征空间
   上确界具有平凡正交补；
4. `ContinuousLinearMap.finite_dimensional_eigenspace`：每个非零特征空间有限维；
5. F6.4 已冻结的一般紧算子接口给出非零谱点是特征值、远离零的谱点有限以及互异谱点序列趋零。

其中第 3 项就是 Mathlib 文件明确标注的 compact self-adjoint spectral theorem。它表达的是特征空间
张成的稠密性，而不是一个已经选择好的无限维 `HilbertBasis`。

## 已有结果与教材陈述的边界

Mathlib 已经有 F6.5 的核心，不需要在本库重证“正交补为零”。但它没有把教材 Theorem 5.3.15(v)
封装成一个同时返回以下数据的公共对象：

- 一个由各特征空间基拼接而成的无限维 `HilbertBasis`；
- 每个基向量对应的实特征值；
- `T x` 的按基坐标对角展开公式。

`LinearMap.IsSymmetric.eigenvectorBasis`、`diagonalization` 与 `eigenvalues` 只处于文件的
`FiniteDimensional` 部分，不能直接用于无限维紧算子。无限维正确的基承载是 `HilbertBasis`，不是
只适用于有限指标的 `OrthonormalBasis`。构造显式 `HilbertBasis` 还需为每个特征空间选择基并拼接；
这会显著扩大接口面，而且不是讲清定义所必需。

教材证明的第二步——对自伴算子，有限阶广义特征空间退化为普通特征空间——在该文件中没有现成
的无限维公共定理。这可以作为窄幅新增引理，但不应与 F6.4 留出的“一般紧算子幂核最终稳定／
Fitting 分解／谱投影”混为一谈：自伴情形的退化直接来自内积恒等式，不需要一般 Fitting 理论。

## 建议的正式开发边界

建议 Main 将第一开发批冻结为“定义解释加最小组装”，不复制 Mathlib 最终谱定理：

1. 在 Entry 中解释 `IsCompactOperator T` 与 `(T : E →ₗ[𝕜] E).IsSymmetric` 分别承载紧性和自伴性；
2. 以一个教材化组装定理同时给出特征值为实、互异特征空间正交、全部特征空间正交补为零，以及
   非零特征空间有限维；证明直接消费上述 Mathlib 接口与 F6.4；
3. 可选地新增 `genEigenspace = eigenspace` 的自伴引理，对应教材 Step 2；
4. 暂不构造新的 `HilbertBasis` 包装，不登记连续函数演算、谱测度、一般正规算子或谱投影。

若后续消费者确实需要逐坐标展开，再单独开“特征 Hilbert 基”窗口，而不是让 F6.5 第一批为一个
尚无消费者的选择性数据结构承担大规模 API。
