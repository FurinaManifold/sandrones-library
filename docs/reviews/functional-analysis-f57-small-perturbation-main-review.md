# F5.7 Fredholm 小扰动 Main 验收

- subject commit：`def5c8a`
- verdict：accepted
- entry：`functional-analysis.fredholm.stability-small`

证明选取 `ε=(‖S‖+1)⁻¹`，由算子范数次乘性得到 `‖KS‖<1`，再用 Neumann 判据使
`I+KS` 可逆。有限秩误差经紧扰动稳定性处理，拟逆消去给出 `T+K` Fredholm，两次复合指数公式则
给出指数局部常值。该证明真实消费了 F5.7 前两个窗口，没有调用不存在的最终开性定理冒充教材链。

原提交把第三个正式文件重新挂到组合 Entry；Main 按共享登记职责将其拆为独立
`functional-analysis.fredholm.stability-small`，不要求学科负责人重做数学内容。F5.7 至此完成；
F6.5 紧自伴谱定理仍按既有权限保持 `research_open`。
