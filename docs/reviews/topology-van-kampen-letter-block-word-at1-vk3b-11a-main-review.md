# Main review：AT1-VK3b-11a 字母 block 细边词恢复

- reviewed commit: `7523406`
- integrated commit: `071446e`
- verdict: `accepted`
- reviewed at: 2026-08-26

## 验收结论

本批在每个输入字母指定的覆盖成员中构造 aligned block 顶点、内部 connectors 和细 subpaths，以
`Path.correctedLoopWord` 组成有限基本群词，并证明它严格恢复原输入字母。首末 connector 规范为常值
道路，反序来自既有 `Path.concat`／群乘法约定；结论没有扩张到 dual-label 比较、kernel 或最终
van Kampen 同构。

正式公开面为 11 public / 4 private，与名称级冻结清单和 12--14 真实消费者一致。Main 在当前
`f14d3ad` 上构建 11a（1763 jobs）通过，并直接编译未修改的 11b 候选通过。11a 接收，11b 转为
`development_open`；11c 及以后继续冻结。
