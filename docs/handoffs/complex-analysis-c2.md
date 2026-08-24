# 复分析 C2 学科 handoff

## 分支与范围

- 分支：`codex/complex-analysis`
- 批次：C2 复路径积分与 Cauchy 理论
- 新源码：`PathIntegral.lean`、`CauchyTheorem.lean`、`CauchyFormula.lean`、`Liouville.lean`
  （均位于 `SandronesLibrary/ComplexAnalysis/`）。
- 新文档：`docs/entries/complex-analysis/integral/` 两篇、`cauchy/` 四篇及 `liouville.md`。

## 完成条目

- `complex-analysis.integral.path`
- `complex-analysis.integral.reparametrization`
- `complex-analysis.cauchy.triangle-ball`（foundation；不完成一般 Goursat 条目）
- `complex-analysis.cauchy.path-independence-primitive`（foundation；不完成一般同伦条目）
- `complex-analysis.cauchy.formula`
- `complex-analysis.cauchy.derivatives`
- `complex-analysis.liouville`

## 公开定义与实现桥

- `scalarOneForm f z` 明确给出教材的一形式 `f(z) dz`；`pathIntegral` 与 `PathIntegrable` 使用
  Mathlib 通用 `Path`/`curveIntegral` 承载，而不是把专用 Cauchy 定理当作定义。
- 路径反向、拼接和线段公式使用本库 `pathIntegral` 公开陈述；当前换参数定理是参数区间的底层
  有向换元公式，未冒充尚未证明的一般 `Path.reparam` 等式。
- Cauchy 公式、导数公式、估计和 Liouville 的公开全纯前提均为 `HolomorphicOnTextbook`；
  `DifferentiableOn ℂ`、circle integral 和 Mathlib Liouville 只在证明桥中出现。

## 子 Agent 与负责人审核

- C2-I：路径积分、反向/拼接/线段及换元；负责人要求补齐所有 Entry 标记并把换参数声明降到
  实际已证的参数空间公式。
- C2-C：原函数端点公式、原函数条件下路径无关及其同伦推论、三角边界圆盘版。Main review
  进一步要求 foundation id 与 ROADMAP 完整课程 id 分离；已改为
  `cauchy.path-independence-primitive` 与 `cauchy.triangle-ball`。
- C2-F/L：闭圆盘条件下 Cauchy 公式、高阶导数公式、Cauchy 估计与 Liouville；负责人复核了
  开球、闭球、圆周和正半径条件。

## 验证

- 四个 C2 模块各自 targeted build 通过。
- 四模块联合构建通过（2750 jobs）。
- 临时聚合文件同时导入四模块并 `#check` 十个关键公开 API，通过。
- 正式源码无 `sorry`、`admit`、`sorryAx`、`native_decide`；`git diff --check` 通过。
- Main review 发现路径积分两篇缺 front matter，另三篇多出 `# 定义`。返工后七篇文档均有
  完整 front matter，且自动检查确认均且仅按顺序包含精确八段、各段非空；定义解释已语义合并，
  没有删除。
- 学科负责人未运行全库 `lake build`。

## Main 更新建议

- 顶层新增四个 C2 模块 import；Registry 新增上述七个 id，并重生成公理字段和文档索引。
- RADAR 登记 curve integral、interval FTC/change-of-variables、`isExactOn_ball`、circle integral、
  iterated derivative estimate 和 Liouville 后端。
- ROADMAP：C2 不应整体标 ✅。path/formula/derivatives/Liouville 可记完成；新增两个 foundation
  进度项 `triangle-ball` 与 `path-independence-primitive`。原有一般 `cauchy.triangle` 和
  `cauchy.homotopy` 必须继续保持未完成。C3 只能依赖已完成接口。

## Main review 处理状态

- R1 `resolved`：补全两篇 front matter；三篇九段文档改为精确八段；七篇自动核对通过。
- R2 `resolved`：条目降级为 `complex-analysis.cauchy.path-independence-primitive`，一般全纯同伦
  不变仍未完成。
- R3 `resolved`：条目降级为 `complex-analysis.cauchy.triangle-ball`，一般 Goursat 仍未完成。
- 修复提交为包含本记录和 review 处理表的当前提交（见分支 `git log`）。

## 稳定 API 与诚实边界

C3 可依赖路径积分反向/拼接/线段、原函数端点公式、圆盘三角边界为零、圆周 Cauchy 公式、
高阶公式/估计和 Liouville。尚未完成：一般 `Path.reparam` 定理、经典局部三角形 Goursat、
任意单连通开集上原函数存在及由此得到的一般同伦不变。Mathlib `HasPrimitives.lean` 目前也把
一般单连通推广列为 TODO，因此本批文档没有把圆盘结果包装成一般结论。
