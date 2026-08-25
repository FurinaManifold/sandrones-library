# Main review: Functional analysis F4.3 Banach–Alaoglu

- reviewed_commit: `0357822`
- accepted_as: `7c00de3`
- verdict: `accepted`
- reviewed_at: 2026-08-25

正式集合位于 `WeakDual ℝ E`，范数只经 `WeakDual.toStrongDual` 读取；源码和文档均准确区分弱星
紧致与范数紧致，也没有越级声称原空间闭单位球弱紧。三个公开声明分别给出闭性、任意闭球紧致和
单位球特例，数学强度与 Mathlib 后端一致。Main 独立编译通过（8723 jobs），无占位，提交 diff
检查通过。书目字段由 Main 规范化为 citation key。

后续权限：F4.4 为 `integration_open`；F4.5 与 F4.7 可在不重叠文件中并行 `development_open`；
F4.8 维持 `research_open`，F5 闭值域开放接口调查但暂不正式集成。
