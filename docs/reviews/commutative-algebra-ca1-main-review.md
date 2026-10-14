# Main review: commutative-algebra CA1 module definition layer

- branch: `codex/commutative-algebra`（Wave R1 试点窗口；工作树已回收，分支保留 @ `e55e78b`）
- reviewed_commit: `cc5061f`（交付尖端）与 `e55e78b`（join key 迁移）；基线 `4bfa280`
- reviewer: main
- verdict: `accepted`
- reviewed_at: 2026-10-13
- 集成提交: `d3b492f`（共享状态）、`48e87b0`（回执与快照）
- 发布回执: `docs/releases/release-receipt-2026-10-13T112349Z.json`（十步全绿，零异常）

## 已通过

**范围与权限。** 交付为 1 条 Entry（`commutative-algebra.module.definition`）、7 个改动文件，
全部落在学科所有权内；Main 共享文件只留下建议清单，由 Main 自己更新。分支基线 `4bfa280` 与
派工坐标一致，工作树交付时 `git status --short` 为空。

**数学与定义链。** 11 条公开声明逐条读过：`module_axioms`（教材六条公理的合取展开）、
`submodule_closure`/`submodule_of_closure`/`submodule_eq_iff`（子模的必要条件、充分条件、外延性）、
`linearMap_iff`/`linearMap_ext_iff`/`linearMap_map_zero`/`linearMap_mem_ker_iff`/
`linearMap_mem_range_iff`、以及两条桥 `isSubspace_iff_exists_submodule`（L1）与
`twoSidedIdealSet_iff_exists_submodule_self`（A2）。正式承载是 Mathlib 的 `Module`/`Submodule`/
`LinearMap`（+`ker`/`range`），符合 AGENTS §4「语义一致就直接复用、不重造结构」。
`linearMap_iff` 的两条保持性 ↔ 存在模同态，方向与量词都对；两条桥都双向且方向写清。

**四类角色分类。** 叙述层按 AGENTS §4 逐项给出：正式承载（`Module`/`Submodule`/`LinearMap`/
`ker`/`range`）、本库桥（两条）、私有证明后端（`Submodule.mk`/`LinearMap.mk`/`AddHom.mk` 等，
均不进公开签名）、公开泄漏（无）。Main 独立复核了"无泄漏"的判定：`LinearMap.mem_range` 需要
`RingHomSurjective (RingHom.id R)`，该实例由类型类合成提供，不出现在使用处 binder 列表里——
探针 `traces/lean/commutative-algebra/ca1-mathlib-role-probe.jsonl` 第 8 次尝试有 `#print` 实证。

**验证真实性。** Main 独立复跑（不采信报告）：定向 `lake build` rc 0；全库 `lake build`
**9083 jobs 通过**（仅重放既有 linter warnings）；`audit.py` 622 条 OK；`check_axioms.py --all`
无 `sorryAx`；`git diff --check` 干净；占位扫描（`sorry`/`admit`/`sorryAx`/`native_decide`）零命中。
公理画像 `[Classical.choice, Quot.sound, propext]`，与全库主导画像一致（575/622）。

**试点协议（本批的第二个交付物）。** 27 条 trace（14 accepted／12 error／1 sorry_left）与 2 个 pack，
`lean_trace.py check` 与 `context_pack.py check` 均通过；验收包五门 + 两条软门全 pass。
失败尝试占 47%，且失败可归因到**接口事实**（候选名不存在、`RingHomSurjective` 的参数形状、
隐式 binder 推断）而非"没读懂上下文"——这是该协议第一次拿到真实数据。

## Main 侧修复与规范化

1. **L1 头部自述失准（跨条目口径，试点上报）。** `SandronesLibrary/LinearAlgebra/VectorSpace.lean`
   原文声称 Mathlib 名"只出现在 `:= by` 之后的证明内部，绝不出现在定理描述里"，但同文件
   `IsBasis`（`:67`）的定义体含 `Submodule.span`，另有 `dim`/`IsFiniteDimensional`/
   `IsLinearIndependent` 三处同类情况。**定理陈述确实守住了纪律**，失准的是把定义体漏掉了。
   按事实改写为"陈述只用教材记号；Mathlib 名可作为教材记号的实现"，未改数学。
2. **CA1 两个 pack 的 join key 重复**（试点协议反馈 #1/#2）。迁移为
   `…definition` / `…definition-verify`，同步 verify pack 那 14 条 trace 的 `pack_id`；
   迁移事实写在 pack 的 `join_key_migration` 字段，`goal_nl`／所有权／前提闭包／预算与
   全部 trace 内容零改动。提交 `e55e78b`，cherry-pick 回 main 后逐字节哈希核对一致。
3. **handoff 一处措辞偏宽（记录，不退回）。** handoff 称"无 `Classical.choice`"，那是对所选
   5 条聚合 `#print axioms` 而言；全量逐声明扫描显示 `linearMap_mem_range_iff` 用了它。
   数学无碍、与全库一致，故不作为缺陷退回，仅在此记录以免后人误读。

## 由本批暴露并修掉的协议缺陷

试点最有价值的产出是它把工具的缺陷打了出来。四项已修（提交随本次集成）：

- **`--worker`（join key 消歧 + 指针一致）。** 原来 `pack_id` 与 `trace.path` 都由 Entry 唯一决定，
  一个 Entry 派两个子 Agent 时 join key 不唯一——按 `pack.trace.path` 收轨迹会**静默漏掉**
  `ca1-verify` 全部 14 条。现在 `--worker` 给两者加同一后缀。**历史 pack 的指针也修了**：
  verify pack 的 `trace.path` 原本指向 lead 的 jsonl（其中 0 条属于它），已改为
  `ca1-mathlib-role-probe.jsonl`，迁移记录写在 `join_key_migration.trace_path`。
- **重复 `pack_id` 与错误 `trace.path` 的检测。** `context_pack.py check` 直接报错重复的
  `pack_id`；验收包新增 `duplicate_pack_ids` 与 `trace_path_mismatch`，两者都参与 packs 软门
  的标记判定（反向用例已验证能报错）。
- **`--lean-file` 口径归一。** CLI 相对 `SandronesLibrary/`、包内 `target.lean_file` 相对仓库根，
  两套口径会让子 Agent 路径翻倍；现在两种写法都接受并归一。
- **pack 表达不了批次冻结范围（反馈 #5，本批最后修掉的一条）。** 原来 `frozen` 只覆盖
  "目标文件里哪些声明冻结"，"本批只做哪一条、同族哪些不做"只能靠负责人手写进派工提示词，
  换个负责人就会漂。新增 `scope` 块，`out_of_scope` 由 ROADMAP 批次表按 family 前缀确定性推导
  （CA1 本批推出 10 条同族条目，正是当时手写的那批）。两个历史 pack 已按同一函数回填，
  并在块内标注 `backfilled_at`/`backfill_reason`。

另有两项由 Main 自己发现并修掉：

- **`pack_sha256` 口径未文档化、且 `check` 不校验值。** 真实口径是"除 `generated_at` 外、
  **并自排除 `pack_sha256` 本身**"；Playbook 原文只说"除 `generated_at` 外"，且 `check` 只查字段
  是否存在。Main 在 join key 迁移时按错误口径重算，把 verify pack 的哈希**算错了而无人发现**。
  现在计算入口收敛为唯一的 `pack_sha()`，`check` 真校验，Playbook 写明自排除。
- **`attempt` 序号竞争未被检测。** 两个 worker 并发 append 同一 jsonl 会各自从 1 编号，
  使轨迹先后关系失真（`ca1-verify` 当时只能另写文件规避）。`lean_trace.py check` 现在报
  同文件内重复的 `attempt`。

## 诚实边界（沿用学科自述，Main 已核对）

- 只做**定义层**；子集生成的子模、商模与自然投影、同构定理、直和、自由模与秩、张量积、
  局部化、子模格运算均未做，仍在 ROADMAP 冻结。
- 两条桥的强度是 `↔ ∃ S, ↑S = …`，**未证唯一性**。
- A2 桥与 A2 已有的 `twoSidedIdealSet_iff_exists_ideal`（`AbstractAlgebra/Ring.lean:390`）
  是**同一命题**的两种词汇写法（本版 Mathlib `Ideal R` 是 `@[reducible] def Ideal R := Submodule R R`）；
  价值在 CA1 词汇与依赖归属，不是新数学。叙述层已自行披露，Main 确认披露属实。
- `LinearMap.range` 的 `RingHomSurjective` 在 `M →ₗ[R] N` 上自动合成；本条目冻结在该记法，
  不推广到 `M →ₛₗ[σ] N`，以免把超课程 typeclass 带进公开签名。

## 结论

数学、定义链、公开接口、Mathlib 角色与诚实边界均达标；共享状态已由 Main 补齐并通过
AGENTS §6 全流水线与发布门。`verdict: accepted`。分支 `codex/commutative-algebra` 保留 @ `e55e78b`，
工作树已回收。
