# Main review: complex-analysis-c2

- branch: `codex/complex-analysis`
- reviewed_commit: `cce0c385b31651eb4f6994496c3526228bfcb0cd`
- reviewer: main
- verdict: `needs_changes`
- reviewed_at: 2026-08-24

## 已通过

- `PathIntegral`、`CauchyTheorem`、`CauchyFormula`、`Liouville` 四模块联合构建通过。
- 正式复分析源码未发现 `sorry`、`admit`、`sorryAx` 或 `native_decide`。
- `pathIntegral` 通过一形式曲线积分明确实现教材记号；Cauchy 公式、导数公式、估计和 Liouville 的公开全纯前提均调用本库 `HolomorphicOnTextbook`。
- handoff 已诚实说明一般换参数、一般 Goursat 三角形定理和一般单连通域同伦不变尚未完成。

## 必须返工

### R1. handoff 的文档验收记录与文件不一致

- `docs/entries/complex-analysis/integral/path.md` 与 `reparametrization.md` 没有 YAML front matter，因此不存在可供 Registry/audit 对照的 Entry 元数据。
- `docs/entries/complex-analysis/cauchy/formula.md`、`derivatives.md` 与 `liouville.md` 在规定八段之外另有一级标题 `# 定义`，实际为九段。
- `docs/handoffs/complex-analysis-c2.md` 第 44–45 行却声明七篇文档均有 front matter 且精确八段。

要求：为路径积分两篇补齐与源码一致的 front matter；把三篇额外“定义”内容语义合并进规定八段，不能删除实质解释；自动检查七篇文档的 front matter、八段顺序和段落非空，并同步改正 handoff 的验证记录。

### R2. `complex-analysis.cauchy.homotopy` 的条目名强于已证结论

- `pathIntegral_homotopyInvariant_of_primitive` 的实质前提是存在原函数 `g`；参数 `_homotopy` 没有参与证明。它证明的是恰当一形式的路径无关性，不是 ROADMAP 所列的“一般同伦不变与单连通域版本”。
- `docs/entries/complex-analysis/cauchy/homotopy.md` 与 Entry id 仍把该结果登记为 Cauchy 同伦条目，容易让 Registry 把尚未完成的 C2 课程入口标成 verified。

要求二选一：

1. 证明与条目名匹配的一般全纯同伦不变版本；或
2. 将当前结果降级为明确的“原函数条件下路径无关”，同步修改 Entry id、源码 docstring、文档 front matter/标题/summary、handoff 和 main 更新建议，并保留 ROADMAP 的一般同伦条目未完成。

### R3. `complex-analysis.cauchy.triangle` 同样必须保持 ball/primitive 边界

当前 Lean 只证明原函数条件和球内全纯情形，而 ROADMAP 的课程项是一般三角形 Cauchy 定理。handoff 已承认这一点，但仍复用了完整课程 Entry id。

要求：若不补一般 Goursat 版本，则把当前 Entry 降级为球内/原函数版的独立 foundation id；不得建议 main 把 ROADMAP 的一般 `cauchy.triangle` 标为完成。文档标题、summary 与源码 docstring 必须保持同强度。

## 可选择降级的接口

- 可以保留并接收路径积分、反向、拼接、参数空间换元、圆周 Cauchy 公式、高阶导数公式、Cauchy 估计与 Liouville。
- 原函数路径无关和球内三角边界积分为零可以用新的 foundation Entry id 接收；一般同伦不变与 Goursat 条目继续留在 ROADMAP。

## 不得越过的边界

- 不修改 main 共有文件；所需 imports、Registry、RADAR、ROADMAP 变更只写入 handoff。
- 不把局部构建称为全库通过，不把 Mathlib 原函数 API 包装成一般单连通域定理。

## 要求重跑的验证

```bash
lake build SandronesLibrary.ComplexAnalysis.PathIntegral \
  SandronesLibrary.ComplexAnalysis.CauchyTheorem \
  SandronesLibrary.ComplexAnalysis.CauchyFormula \
  SandronesLibrary.ComplexAnalysis.Liouville
git diff --check
git status --short
```

另需聚合导入四模块并 `#check` 关键公开 API；扫描禁用占位证明；自动核对七篇文档的 front matter、精确八段及 Entry id 与源码一一对应。

## 学科负责人处理记录

| 项目 | 状态 | 修复提交／说明 |
|---|---|---|
| R1 文档元数据与模板 | resolved | 为 path/reparametrization 补全 front matter；formula/derivatives/liouville 的定义解释完整并入规定八段；七篇 front matter、标题顺序及非空性自动核对通过。 |
| R2 同伦条目强度 | resolved | 采用允许的降级方案：源码 Entry、文档 id/title/summary 和 handoff 改为 `complex-analysis.cauchy.path-independence-primitive`；一般 `cauchy.homotopy` 保持未完成。 |
| R3 三角形条目强度 | resolved | 采用允许的降级方案：源码 Entry、文档 id/title 和 handoff 改为 `complex-analysis.cauchy.triangle-ball`；一般 `cauchy.triangle` 保持未完成。 |

修复提交为包含本处理记录的当前提交（见 `codex/complex-analysis` 分支 `git log`）。C1 复验接受
记录原样保留，未修改 C1 数学或 C2 以外源码。
