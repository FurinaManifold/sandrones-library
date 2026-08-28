# F6.5 紧自伴谱定理签名 Main 验收

- subject commit：`d3e8b08`
- verdict：accepted
- next gate：`development_open`

正式 carrier 冻结为 `T : E →L[𝕜] E`、`IsCompactOperator T` 和
`(T : E →ₗ[𝕜] E).IsSymmetric`，其中 `𝕜` 为 `RCLike`，`E` 为完备内积空间。不新增同义
self-adjoint 或 compact wrapper。

第一批公开组装必须同时解释并给出：特征值满足 `star μ = μ`、特征空间组成正交族、全部特征空间
上确界的正交补为底、非零特征空间有限维。可以加入自伴情形 `genEigenspace = eigenspace` 的窄幅
真实证明，以呈现教材 Step 2；不得借此展开一般 Fitting 分解。

Mathlib 已有的正交补结论可以直接复用，但 Entry 必须解释它为何等价于特征空间张成稠密，不能只列
接口名。无限维特征向量 `HilbertBasis`、一般紧正规算子、连续函数演算、谱投影和谱测度保持冻结，
待真实消费者另开窗口。
