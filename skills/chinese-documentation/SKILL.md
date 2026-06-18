---
name: chinese-documentation
description: Use automatically whenever writing or editing Chinese technical prose — specs, plans, READMEs, design docs, commit bodies, code comments, memory/notes — including the output of superpowers brainstorming, writing-plans, and writing-skills. Applies Chinese typography (CN/EN spacing, full/half-width punctuation, term retention) and anti-machine-translation rules. Companion overlay to the superpowers writing skills; no manual trigger needed.
---

# 中文技术写作规范（蒸馏版）

> 蒸馏自 superpowers-zh（MIT, jnMetaCode）的 `chinese-documentation`，按 solo + GitHub + Godot 场景精简。
> **伴随式叠加技能**：凡是你（或你派发的子代理）在产出中文文档/规格/计划/README/注释/记忆时自动套用，
> 无需手动触发。它叠加在 superpowers 的 `brainstorming` / `writing-plans` / `writing-skills` 等写作技能之上——
> 那些技能管"写什么、怎么组织"，本技能管"中文怎么排得专业、不出机翻味"。

**核心：** 排版服务于阅读，规范服务于一致。参考 [中文文案排版指北](https://github.com/sparanoid/chinese-copywriting-guidelines)。

## 空格

- 中英文之间加空格：`使用 Git 管理版本` ✓ ／ `使用Git管理版本` ✗
- 中文与数字之间加空格：`3 个新功能`、`12 个 Bug`
- 数字与单位之间加空格：`5 MB`、`200 ms`
- 例外（紧贴不加）：度数、百分比 → `32°C`、`95%`
- 链接前后加空格：`参考 [文档](url) 获取更多信息`

## 标点

- 中文语境用全角：`注意：该接口需鉴权。`（不是 `注意:...`）
- 全角标点与相邻中文之间不加空格：`MIT 协议，详见 LICENSE`（不是 `… 协议 ，…`）
- 括号：中文内容用全角「（）」；括号内是英文/数字用半角 `Spring Boot (v3.2.0)`
- 引号：推荐直角引号「」『』；或团队统一用弯引号 `""`
- 英文/代码片段内部一律半角标点：`Run npm install, then npm test.`

## 数字

技术参数统一用半角阿拉伯数字：`100 个并发`、`端口 8080`、`状态码 200`。不要写「一百个并发」。

## 术语（中英混排）

- **保留英文**：专有名词（React / Redis / MySQL）、通用缩写（API / SDK / CI/CD）、命令与代码、无公认译名的词（debounce / middleware）
- **翻译为中文**：有公认译法的概念（数据库 / 负载均衡 / 版本控制）
- **首次出现标中英对照**：`消息队列（Message Queue）`，后文直接用中文
- **别过度翻译**：`在 Controller 层校验` ✓ ／ `在控制器层校验` ✗；`Redis 缓存` ✓ ／ `"远程字典服务"缓存` ✗

## 五个中文病（写完逐条自检）

1. **机翻味** —— 被动语态、冗余代词、直译句式。`这个函数被用来计算折扣` → `用于计算折扣`
2. **欧化长句** —— 长定语 + 多重从句。拆成短句，一句只说一件事
3. **过度翻译** —— `打开"终端模拟器"运行"节点包管理器"` → `打开终端运行 npm install`
4. **中英标点混用** —— 中文句用了 `,` `.`；英文句用了 `，` `。`
5. **缺结构** —— 大段流水账 → 用列表 / 表格 / 小标题切分

## 一个高频 bug-class 提醒

金额、数量等带单位的字段，注释必须写清单位：`total_amount: 9900  // 单位：分（即 99.00 元）`。用浮点存金额会有精度问题。

## 发布前检查清单

- [ ] 中英文之间、中文与数字之间有空格
- [ ] 中文用全角标点 / 英文与代码用半角标点，无混用
- [ ] 专有名词保留英文、首次出现标对照、术语前后一致
- [ ] 句子简短、无欧化长句、无多余被动语态
- [ ] 结构化信息用了列表 / 表格
- [ ] 代码块标了语言类型、链接可访问
