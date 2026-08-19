# Sandrone's Library — 条目 Schema 规范

> 本文件定义"事实条目"的三种形态（叙述层 / 形式化层 / 元数据）的**精确字段**。
> 这是给 LLM 与人类共读的契约：任何条目都必须严格符合，否则审计不通过。

## 1. 元数据：`index/registry.json`

每条记录一个 JSON 对象：

```jsonc
{
  "id": "analysis.fixedpoint.banach.rudin",      // 全局唯一。多版本条目：<family>.<variant>
  "family": "analysis.fixedpoint.banach",        // 事实家族 id（共享同一数学结论的条目群）
  "variant": "rudin",                            // 本条目来源变体：rudin | zorich | 华东师大 |
                                                 //   chen-jixiu | mathlib-formal | generated | ...
  "kind": "theorem",                            // definition | lemma | proposition | theorem | example
  "state": "verified",                          // verified | pending | unresolved
  "title": "巴拿赫不动点定理",                    // 人类友好标题
  "summary": "完备度量空间上的压缩映射有唯一不动点",  // 一句话陈述
  "premises": [                                  // 依赖的库内条目（人话层）
    "analysis.metric.complete",
    "analysis.metric.contraction"
  ],
  "mathlib": [                                   // 用到的 mathlib 定理（机器层）
    "exists_fixedPoint_of_isContraction",
    "isFixedPt_iff"
  ],
  "axioms": [                                    // 非平凡公理依赖（#print axioms 的输出，如实登记）
    "propext", "Classical.choice", "Quot.sound"
  ],
  "provenance": {                                // 来源
    "source_type": "book",                       // book | paper | generated
    "ref": "Rudin, Principles of Mathematical Analysis, Thm 9.22"
  },
  "lean_file": "SandronesLibrary/Analysis/FixedPoint.lean",
  "nl_file": "docs/entries/analysis/fixedpoint/banach.md",
  "proof_sha": "6f9d2a3b7e1c...",                  // lean 文件指纹（sha1 前 16 位）；
                                                  // 供 check_axioms 增量验证跳过未变更文件
  "added_by": "ingestor-<会话标签>",
  "added_at": "2026-08-19T08:00:00Z",
  "dependedOnBy": []                             // 注册时自动回填（调用量指标）
}
```

约定：
- `premises` 只列库内条目 id；mathlib 的引用放 `mathlib` 字段，不混。
- `state` 只能取三值之一；`unresolved` 条目不得有 `lean_file`。
- `id` 一经注册不得更改；作废条目用 `state: unresolved` + 说明，而非删除。
- **多版本**：同一 family 可以有任意多个变体条目。
  - 无变体的条目：`variant` 取 `generated`（库内自创/无教材出处）。
  - `id` 规则：单版本条目 `analysis.fixedpoint.banach`；多版本条目 `analysis.fixedpoint.banach.rudin`。
  - `premises` 引用**具体条目 id**（含变体）；若只想指到"该结论"而不关心版本，
    可在 `premises` 里写 family id，由解析器自动选一个 `verified` 变体（优先被调用最多的）。
  - **调用量**：`dependedOnBy` 长度即引用计数，是"哪个版本更有价值"的客观度量，
    由 `scripts/audit.py`/注册脚本在每次纳入时自动回填，人工不得修改。
- **同一家族内的条目共享 family id 前缀**，`audit.py` 校验 family 一致性。

**公理透明（axioms）约定**：
- `axioms` 字段如实记录 `#print axioms <定理名>` 的输出（数组；空 = 构造性、无额外公理）。
- **这是"绝对严格"对教科书的杀手锏**：教科书的证明可能隐式使用选择公理而不自知；
  Lean 的 `#print axioms` 会如实揭露。`axioms` 含 `Classical.choice` 的条目，
  叙述层必须注明"教科书版本未提及 Choice，但形式化证明实际依赖"。
- `audit.py` 校验：verified 条目的 `axioms` 字段与 `#print axioms` 输出一致。

**验证效率（增量）约定**：
- `lake build` 本身是**增量编译**：只重建发生变化的模块（每个模块通常秒级），
  **不要**在验证前 `lake clean`。库再大，新增条目只触发其所在模块与上一层
  `SandronesLibrary.lean` 的重新编译。
- `check_axioms.py`（默认增量）：每条目以 `proof_sha`（lean 文件指纹）判断是否需要重验；
  文件未变则跳过 `#print axioms` 探测。改过 lean 后必须重验该文件里全部条目。
  `--full` 可强制全量。
- 完整流水线建议：`lake build`（增量）→ `python3 scripts/check_axioms.py --all --fix`
  → `python3 scripts/audit.py`。

## 2. 叙述层：`docs/entries/<family>/<entry>.md`

YAML front matter + 固定分节。front matter 与 registry.json 字段一一对应
（以 registry.json 为准，此处是展示层）：

```markdown
---
id: analysis.fixedpoint.banach
kind: theorem
state: verified
title: 巴拿赫不动点定理
premises: [analysis.metric.complete, analysis.metric.contraction]
mathlib: [exists_fixedPoint_of_isContraction]
provenance:
  source_type: book
  ref: "Rudin, Principles of Mathematical Analysis, Thm 9.22"
---

# 动机
人类为什么需要这个定理？从什么具体问题引入？

# 直觉
核心洞见，一句话或一小段。可给退化情形/反例。

# 陈述（自然语言）
数学上精确但不用 Lean 记号的陈述。

# 陈述（Lean 对照）
```lean
-- 与上一节逐项对应的 Lean 陈述，注明每个记号怎么读
theorem banach_fixed_point ...
```

# 思维脉络（thinking trace）
清洗过的链式推理：从前提如何走到结论，为何选此策略，
哪些路走不通及原因。用条目 id 或引用标注依赖的使用点。

# 自然语言 ↔ Lean 映射
| 人话 | Lean |
|---|---|
| 压缩映射 | `IsContraction f` |
| 迭代逼近 | `fun n ↦ f^[n] x` |

# 依赖（人话版）
逐条解释每个 premise 在讲什么、为何这里需要它。

# 应用与陷阱
这个定理有什么用；初学者/LLM 常错在哪。
```

## 3. 形式化层：`SandronesLibrary/<域>/<文件>.lean`

每个条目在 .lean 中对应一段，**块级 docstring 是强制头部**：

```lean
/-- 
> **Entry**: analysis.fixedpoint.banach
> **一句话**：完备度量空间上的压缩映射有唯一不动点。
> **直觉**：反复迭代压缩映射会把点"吸"到不动点。
> **依赖**：`analysis.metric.complete`、`analysis.metric.contraction`
> **mathlib**：`exists_fixedPoint_of_isContraction`
-/
theorem banach_fixed_point {α : Type*} [MetricSpace α] [CompleteSpace α]
    (f : α → α) (h : ∃ c, c < 1 ∧ ∀ x y, dist (f x) (f y) ≤ c * dist x y) :
    ∃! x : α, f x = x := by
  -- 思路：构造柯西列 (f^[n] x₀)，由完备性得极限 x；压缩性给出唯一性。
  ...
```

- 文件级 docstring（文件顶部）列出本文件所有 Entry id 与一句话陈述。
- 关键推理步骤必须有 `-- 思路：` 注释；机械步骤可用自动化策略。
- `sorry` 只允许出现在文件末尾 `#exit` 之后的临时区，且状态必须为 `pending`。

## 4. 一致性规则（audit.py 强制）

1. registry.json 与 entry.md 的 front matter：字段值完全一致（id/kind/state/premises/mathlib）。
2. entry.md 的「陈述（Lean 对照）」与 .lean 中的实际陈述必须同构（允许重命名与记法等价）。
3. .lean 中实际 `#check` 使用的库内依赖 ⊆ registry 的 `premises`。
4. `state: verified` ⇒ `lake build` 通过 且 .lean 无 `sorry`。
5. `state: pending` ⇒ 证明可含 `sorry`，但必须在 `#exit` 后集中登记。
6. `provenance.ref` 必须能定位到具体章节/编号（格式：`作者, 标题, 节/章`）。
