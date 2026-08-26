# F4.8 Krein--Milman 接口调查

- 分支：`codex/functional-analysis`
- Main 基线：`d2dc95f`
- 权限：`research_open`
- 状态：仅接口调查；不是 verified Entry，不请求集成最终课程条目

## 教材范围

以 Bühler--Salamon, *Functional Analysis*, PDF 第 155--158 页（印刷页 140--143）的页面图像为准。
第 155 页包含 Definition 3.5.1 与 Theorem 3.5.2：

- `F ⊂ K` 是 face，当且仅当 `F` 非空且凸，并且 `K` 中一条开线段只要有内点落在 `F`，
  两端点就都落在 `F`；
- `x ∈ K` 是 extremal point，当且仅当把 `x` 写成 `K` 中两点的严格凸组合只能是平凡表示；
- 实、局部凸、Hausdorff 拓扑向量空间中的非空紧凸集，等于其全部极点的闭凸包；特别地极点
  集非空。

教材随后五步证明使用极小非空紧凸 face、连续线性泛函的极大值 face、Zorn 引理和分离定理。
本调查不把这些证明步骤误登记成库中缺失的最终定理，因为 Mathlib 已经实现了相同证明链。

## 概念与正式承载候选

| 教材概念 | Mathlib 承载 | 展开／桥 | 判断 |
|---|---|---|---|
| face / extreme subset | `IsExtreme ℝ K F` | `isExtreme_iff` | 语义一致；Mathlib 的结构只存一个端点，另一个由 `IsExtreme.right_mem_of_mem_openSegment` 推出 |
| extremal point | `K.extremePoints ℝ` | `mem_extremePoints` | 与教材严格凸组合刻画等价；直接复用 |
| singleton 是 face | `IsExtreme ℝ K {x}` | `isExtreme_singleton` | 给出 face 与 extremal point 的教材桥 |
| convex hull | `convexHull ℝ S` | `convexHull_min` 等既有接口 | 直接复用 |
| closed convex hull | `closedConvexHull ℝ S` 或 `closure (convexHull ℝ S)` | `closedConvexHull_eq_closure_convexHull` | 教材定理的现有结论采用后者；课程文档可同时解释二者 |
| Krein--Milman 极点存在 | `IsCompact.extremePoints_nonempty` | 非空紧集推出极点非空 | Mathlib 已有最终定理 |
| Krein--Milman 闭凸包等式 | `closure_convexHull_extremePoints` | 紧致与凸性推出等式 | Mathlib 已有最终定理；声明在顶层，不是 `IsCompact` 点式接口 |

## 类型类与教材假设对照

Mathlib 最终定理要求：

- `[AddCommGroup E] [Module ℝ E]`：实向量空间；
- `[TopologicalSpace E] [T2Space E]`：Hausdorff；
- `[IsTopologicalAddGroup E] [ContinuousSMul ℝ E]`：拓扑向量空间运算；
- `[LocallyConvexSpace ℝ E]`：局部凸。

这与 Theorem 3.5.2 的环境一致。`IsCompact.extremePoints_nonempty` 本身不要求原集合凸，强于
教材最后一句所需的推论；课程条目应仍按教材的“非空紧凸集”叙述，Lean 对照可以披露 Mathlib
极点存在引理的更强范围。

## 原型验证

研究原型位于 `/tmp/sandrones-library/f4-krein-milman-interface.lean`，同时检查：

1. `IsExtreme` 与 `isExtreme_iff`；
2. `Set.extremePoints` 与 `mem_extremePoints`；
3. `isExtreme_singleton`；
4. `closure_convexHull_extremePoints`；
5. `IsCompact.extremePoints_nonempty`；
6. `closedConvexHull_eq_closure_convexHull`。

`lake env lean /tmp/sandrones-library/f4-krein-milman-interface.lean` 已通过，无 `sorry`。原型确认最终
定理必须以顶层名称调用，而非写作 `hKcpt.closure_convexHull_extremePoints`。

## 建议冻结的正式窗口

F4.8 若提升为 `development_open`，建议只交付一个教材解释 Entry 和最薄的定义链组装模块：

- 不新建 `FaceTextbook`、`ExtremePointTextbook` 或平行闭凸包定义；
- 用公开 `example`/定理展示 `isExtreme_iff`、`mem_extremePoints`、`isExtreme_singleton` 与最终定理
  的组装，若上层没有稳定使用者，则不要为了制造本库声明而包装同型最终定理；
- Entry 明确解释 Mathlib `IsExtreme` 的单端点字段为什么仍与教材双端点定义等价；
- 不把 Minkowski--Carathéodory、Choquet 理论或具体紧凸集极点计算并入本窗口。

在 Main 冻结公开签名前，本调查不修改 `SandronesLibrary.lean`、Registry、ROADMAP 或正式源码。
