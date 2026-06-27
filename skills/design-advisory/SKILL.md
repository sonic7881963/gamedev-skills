---
name: design-advisory
description: Use automatically during game-design brainstorming and spec/design-doc writing — when a feature touches a design dimension (mechanics, economy, level, UX, narrative, art, audio, vision/pillars), route it to the matching design-department advisor (game-designer, economy-designer, ux-designer, etc.) for framed options before deciding. Companion overlay to superpowers brainstorming/writing-plans and the project's M/L spec flow. Design advice has no oracle — advisors give framed drafts, playtest is the judge. No manual trigger needed.
---

# 设计顾问介入（伴随式叠加）

> 配合你项目的设计介入门（若有）/ M-L 规格流程。本库 `agents/` 下有 9 个设计顾问 agent，
> 蒸馏自 `donchitos/claude-code-game-studios`（MIT，摘其设计域、解耦移植）；把它们装进你项目的
> `.claude/agents/` 即可点名派发。完整映射与用法见 `agents/README.md`。
> **伴随式叠加技能**：brainstorm / 写 spec / 写设计文档时自动套用，无需手动触发。它叠加在 superpowers
> `brainstorming` / `writing-plans` 与项目 M/L 流程之上——那些管"流程怎么走"，本技能管"何时把哪个设计
> 顾问拉进来、怎么用它的产出"。

## 何时触发（与不触发）

- **触发**：M/L 级 brainstorm 或 spec 阶段，议题命中任一**游戏设计维度**——核心循环/机制、数值/经济、
  关卡/遭遇/节奏、UX/HUD/可读性、叙事/世界观、美术方向、愿景与支柱自洽。
- **不触发**：S 级小改；纯工程特性（重构/架构/性能/bug，无设计判断）——那些走你的实现档代理
  （见 tiered-gamedev-workflow skill）。
- 拿不准算不算"设计维度"→ 当作算，宁可多问顾问一句。

## 维度 → 顾问（全 opus@high；详表见 `agents/README.md`）

| 议题 | 顾问 |
|---|---|
| 核心循环·机制·MDA·整体平衡 | game-designer |
| 具体公式·曲线·交互矩阵 | systems-designer |
| 货币·掉落·进度·奖励·通胀 | economy-designer |
| 战场/关卡布局·遭遇·节奏 | level-designer |
| HUD·交互·可读性·反馈·引导 | ux-designer |
| 剧情·世界观·角色·ludonarrative | narrative-director |
| 视觉风格·art bible·给美术提需求 | art-director |
| 声音美学·音乐·音效·自适应 | audio-director |
| 「这还是同一款游戏吗」·支柱自洽 | creative-director |

## 怎么用（orchestrator 驱动）

1. brainstorm/spec 中识别到设计维度 → 用 Task 派对应顾问，带上**具体问题 + 本作约束**（你游戏的具体
   约束：类型 / 范围 / 支柱——例如垂直切片 Demo 而非 AAA 开放世界，会显著改变顾问的取舍）。
2. 顾问返回 **2-4 个带 pros-cons 的框架化选项 + 一个推荐**（它已被钉死这么做）。
3. 把这些选项并入你给用户的**集中问**（AskUserQuestion）——由**用户拍板**，不替用户选。
4. 选定后再按 M/L 流程写进 spec / 设计文档（落你项目的设计文档目录，套 chinese-documentation）。

## ★ oracle 告诫（最重要）

设计建议**没有自动判据**——测试证不了"好不好玩 / 平不平衡 / 节奏对不对"。顾问产出是**框架 + 初稿**，
不是定论；**playtest 才是终审**。代码强、又极依赖证据的团队，最易接受"听着专业、实则平庸 / 不合本作"的
建议却判不出来 → 务必让顾问亮推理 + 引框架、永远给多选项、按本作裁剪，最后用 playtest 验。

## 子代理边界

单层轮辐：**顾问由 orchestrator 派发**，子代理不嵌套再派顾问。被派发的实现 / 审查子代理若产出涉及
设计判断，应停手把问题交回 orchestrator，由其决定是否咨询顾问。
