---
name: chinese-code-review
description: Use automatically whenever giving or relaying code-review feedback in Chinese — pairs with superpowers requesting-code-review and receiving-code-review. Provides Chinese review communication: severity tags [必须修复/建议修改/仅供参考/问题], suggestion-over-command phrasing, and common anti-patterns. Companion overlay; no manual trigger needed.
---

# 中文代码审查沟通（蒸馏版）

> 蒸馏自 superpowers-zh（MIT, jnMetaCode）的 `chinese-code-review`，按 solo + 七代理审查流精简。
> **伴随式叠加技能**：用中文给出或转述审查反馈时自动套用，无需手动触发。叠加在 superpowers 的
> `requesting-code-review` / `receiving-code-review` 之上——那些管"审什么、走什么流程"，本技能管
> "中文怎么说得既不放过 bug 又让人愿意接受"。
> ⚠️ **子代理盲区**：t-review / t-review-deep 是被派发的子代理、跳过 using-superpowers，其审查输出措辞
> 不会自动套用本技能；要统一风格须写进派发 prompt 或 DISPATCH-BRIEF「审查代理专则」。

**核心：** 用"建议"代替"命令"、用"提问"代替"否定"，但绝不因面子放过 bug。

## 分级标注（每条评论必带）

- **[必须修复]** —— 安全漏洞、数据丢失、逻辑错误（不修不能合）
- **[建议修改]** —— 性能、可维护性、缺校验（本次或下个迭代）
- **[仅供参考]** —— 命名、风格、替代方案（不改也行）
- **[问题]** —— 不确定处，需作者解释意图

## 表达方式

| 命令式（避免） | 建议式（推荐） |
|---|---|
| 你必须改成 X | 建议用 X，因为 Y |
| 这里写错了 | 这里是否考虑过 Z 的情况？ |
| 不要用这个方法 | 这方法在 A 场景可能有性能问题，可看看 B 方案 |

不确定对方意图时先问再评：`这里用 sync 读文件是出于什么考虑？并发上来可能阻塞事件循环。`

## 评论模板

```
[必须修复] SQL 注入风险
第 42 行：用户输入直接拼进 SQL 语句。
原因：可被注入 '; DROP TABLE users; --
建议：参数化查询 —— db.query('... WHERE name = $1', [name])
```

## 四个反模式

1. **过度客气** —— 关键 bug 藏在委婉语里 → 用分级标注，[必须修复] 语气可温和但级别必须准确
2. **不敢给资深提意见** —— 对事不对人，用提问式/学习式：`想请教这里用递归而非迭代的考虑？担心深层栈溢出`
3. **审查变风格之争** —— 缩进/空格交给 lint 工具，审查聚焦逻辑 / 安全 / 性能
4. **只写 LGTM** —— 即使通过也写清审了哪些面（并发 / 错误处理 / 向下兼容）

## 审查顺序

架构 → 正确性（边界条件）→ 安全（注入/越权/泄露）→ 性能（N+1/内存泄漏）→ 可维护性 → 风格（仅工具管不了的）

## 收尾总结

一句整体评价 + 值得学的点（先扬）+ 按优先级排列的问题列表 + 建议的修改方向。

## 检查清单

- [ ] 每条评论标了优先级
- [ ] [必须修复] 都给了具体修复建议
- [ ] 没因面子跳过关键问题
- [ ] 没纠结工具能自动处理的风格
- [ ] 对好的代码给了肯定
- [ ] 给了整体总结
