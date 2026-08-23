---
id: linear-algebra.eigen.jordan
family: linear-algebra.eigen
variant: foundations
kind: theorem
state: partial
title: 广义特征空间与 Jordan 链
summary: Jordan 标准形所需的广义特征空间、Jordan 链基和单块矩阵表示
premises: [linear-algebra.eigen.diagonalization]
mathlib: []
provenance:
  source_type: textbook
  ref: "本科线性代数：广义特征向量、Jordan 链与 Jordan 块"
---

# linear-algebra.eigen.jordan

## 已完成

- `k` 阶广义特征子空间的教材定义、子空间性和阶数单调性；
- 一级广义特征子空间等于普通特征子空间；
- Jordan 链基与 Jordan 块矩阵的定义；
- 多条 Jordan 链共同构成全空间基的 `IsJordanBasisFamily` 教材接口；
- 独立于“基”条件的 Jordan 链定义，以及“链基 = 基 + Jordan 链”的接口；
- Jordan 链基下的算子矩阵等于对应 Jordan 块；
- Jordan 块是上三角矩阵，且其特征多项式为 `(X-μ)^(m+1)`；
- 若全空间由单条 Jordan 链构成，则算子的特征多项式同样为 `(X-μ)^(m+1)`；
- 链中第 `j` 个向量被 `(T-μI)^(j+1)` 湮灭。
- 上述幂湮灭结论已推广到不预设张成性的任意 Jordan 链。
- 任意非零 Jordan 链线性无关（对链长归纳，施加 `T-μI` 消去链首）。
- 长度 `m+1` 的链满足 `(T-μI)^m b_m=b_0≠0`；若它是全空间基，则下一次幂为零。
- 链顶满足逐级下降公式 `(T-μI)^i b_m=b_{m-i}`，故前 `m+1` 个平移算子幂线性无关。
- 单条 Jordan 链张成全空间时，平移算子 `T-μI` 的最小多项式恰为 `X^(m+1)`。
- 已补上线性算子环适用的最小多项式标量平移公式；因此单块算子本身的最小多项式
  与特征多项式相同，均为 `(X-μ)^(m+1)`。
- 完整链分解的幂零前置：幂零算子的 `dim V` 次幂必为零；非平凡空间中其核含有
  非零向量，可作为 Jordan 链首。
- 幂零算子存在精确的首次归零次数，并能由达到该指数的向量反向迭代，构造一条长度
  恰等于幂零指数的最长 Jordan 链。
- 精确幂零指数不超过空间维数；证明归结为最长 Jordan 链的线性无关性。
- 任意有限维幂零算子都存在完整 Jordan 链基。证明固定环境空间，对不变子空间维数
  归纳：先分解像空间，逐链提升一个向量，再用核基补齐链首与长度为一的新链。
- 任意 Jordan 链族基下，算子矩阵等于各链对应 Jordan 块组成的块对角矩阵。
- 在代数闭域上，把有限个非零最大广义特征空间作内部直和，并分别调用幂零分解，
  得到任意有限维算子的完整 Jordan 标准基。
- 任意 `n × n` 方阵都与重编号后的 Jordan 块对角矩阵相似；正式结论
  `matrix_is_similar_to_jordan` 同时给出互逆换基矩阵 `P,Q` 及等式 `J = P A Q`。
- 代数学基本定理给出 `ℂ` 的代数闭性，因此 `complex_matrix_is_similar_to_jordan`
  将抽象的代数闭域结论实例化为“每个复方阵都有 Jordan 相似标准型”。
- 有限维时广义特征子空间在 `dim V` 阶稳定。
- 代数闭域上，所有 `dim V` 阶广义特征子空间共同张成全空间。

## 尚未完成

Jordan 标准形的存在性和矩阵相似形式已经完成。尚需证明 Jordan 块大小及排列外的
唯一性；这将通过各特征值对应的核维数序列恢复块大小。
