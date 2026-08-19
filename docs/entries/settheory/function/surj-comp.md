---
id: settheory.function.surj-comp
family: settheory.function
variant: ecnu
kind: theorem
state: verified
title: 满射的复合仍为满射
summary: 若 f 与 g 均满射，则 g∘f 满射
premises: []
mathlib: [Function.Surjective.comp]
provenance:
  source_type: book
  ref: "华东师大《数学分析》第五版 第一卷 第一章（预备知识）"
---

# 动机

单射管"输入不塌缩"，满射管"输出全覆盖"。复合函数的第二个性质问题是：
**两个满射合起来还满射吗？**

答案同样是"会"。但注意：满射的证明方式和单射**完全对称但方向相反**——
单射是"从外往里剥"（已知外层输出相等，往内推输入），
满射是"从里往外搭"（已知目标在终点，往源头找起点）。
这两条定理放一起，就完整刻画了"复合保持结构"的两个半场。

# 直觉

满射的意思是"每个目标值都有人打中"：`g` 打到 C 的每个点，`f` 打到 B 的每个点。

复合 `g∘f` 要打到 C 的任意一个点 c：
- 因为 g 满射，存在 b 使 g(b) = c（"中间人"）；
- 因为 f 满射，存在 a 使 f(a) = b（"源头"）。

于是 a 一路被 f 送到 b，再被 g 送到 c——**复合打中了 c**。
c 是任取的，所以复合满射。

形象一点：满射是"单向能到达任何地方"。第一段能到达 B 的任何地方，
第二段能从 B 的任何地方到达 C 的任何地方，合起来当然能从 A 到达 C 的任何地方。

# 陈述（自然语言）

若 f : A → B 与 g : B → C 都是满射，则复合映射 g∘f : A → C 也是满射。
（即：对每个 c ∈ C，存在 a ∈ A 使 g(f(a)) = c。）

# 陈述（Lean 对照）

```lean
theorem surjective_comp {α β γ : Type*} {f : α → β} {g : β → γ}
    (hf : Function.Surjective f) (hg : Function.Surjective g) :
    Function.Surjective (g ∘ f)
```

| 人话 | Lean |
|---|---|
| f 是满射 | `hf : Function.Surjective f` |
| g 是满射 | `hg : Function.Surjective g` |
| 每个目标都有来源 | `Function.Surjective`（即 `∀ c, ∃ a, f a = c`） |

# 思维脉络（thinking trace）

1. **展开目标**：`Function.Surjective (g∘f)` = `∀ c, ∃ a, (g∘f) a = c`。
   先 `intro c`——固定一个任意的终点 c。
2. **从终点找中间人**：因为 g 满射，`∃ b, g b = c`。把这个 b 记为 `⟨b, hb⟩`
   （hb : `g b = c`）。
3. **从中间人找源头**：因为 f 满射，对上面那个 b，`∃ a, f a = b`。
   记为 `⟨a, ha⟩`（ha : `f a = b`）。
4. **组合**：`(g∘f) a = g (f a) = g b = c`。返回 `⟨a, 这个等式⟩`。
   完成——c 是任意的，所以对所有 c 都成立。
5. **为什么顺序是从终点往回走**：满射给的是"存在性"，你不知道 b、a 是谁，
   只能从已知的目标 c 反推。这种"从目标反向构造"的思维在分析中无处不在
  （ε-δ 证明里"先给 ε 再找 δ"、求不动点时的构造）。

# 自然语言 ↔ Lean 映射

| 人话 | Lean |
|---|---|
| 满射 | `Function.Surjective f` |
| 取一个来源 | `rcases hf b with ⟨a, ha⟩` |
| 中间人 | `⟨b, hb⟩`（hc : g b = c） |
| 组合等式 | `rw [ha, hb]` |

# 依赖（人话版）

无库内依赖（本证明只展开满射与复合的定义）。
注意它与 `settheory.function.inj-comp` 是**并列**关系而非互相依赖：
单射性走"从外往里剥"，满射性走"从里往外搭"，是两个独立的半边。
把它们放同一个 family（`settheory.function`），供"双射的复合仍双射"调用。

# 应用与陷阱

**应用**：
- 双射的复合仍双射：`Function.Bijective.comp`（即本条 + inj-comp 的打包）。
- 满射保证"到达"：在商集、像空间、映射的可逆性讨论中，满射 = 值域全覆盖。
- 后续：连续满射把紧集映到紧集（拓扑学），积分算子的满射性（泛函分析）。

**陷阱**：
- **方向陷阱**：满射的"存在性"由目标反向找源头。有人顺着 f→g 的方向找，
  会卡住——因为你不知道从 A 出发该选哪个 a 才能命中 c，只能从 c 倒推。
- **顺序陷阱**：剥洋葱时先 `hg` 后 `hf`（先找中间人再找源头），
  与单射情形对称但内容相反。
- **反过来不成立**：`g∘f` 满射推不出 f 满射（只有 g 一定满射）。
  初学者常把单射/满射的"复合保持"方向记混。
