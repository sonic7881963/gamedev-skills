# 设计部门（设计顾问）

## 这是什么

这是从 [claude-code-game-studios](https://github.com/donchitos/claude-code-game-studios)（MIT）解耦移植的 9 个设计域顾问 agent。一个典型缺口是 agent roster「全是代码执行代理、零设计顾问」——这 9 个顾问补上它。

把 `agents/*.md`（除本 README 外的 9 个）拷进你项目的 `.claude/agents/`，即可在对话里点名找它们。它们的定位是**随叫随到的领域专家**——像请了员工一样，需要哪个方向的设计判断，就点名找对应的顾问。尤其适合代码 / 架构强、游戏设计经验薄的团队。

---

## 9 个顾问一览

| 顾问 | 职责 | 何时找它 |
|------|------|---------|
| **game-designer** | 核心循环、系统设计、平衡、MDA 框架 | 要设计一个新机制、需要平衡数值框架、想用 MDA 分析玩法体验 |
| **systems-designer** | 子系统架构、公式设计、平衡框架、数值推导 | 要写具体系统的伤害公式 / 经济模型 / 进度曲线 |
| **economy-designer** | Sink-faucet 设计、进度曲线、掉落表、奖励心理学 | 要设计货币 / 掉落 / 奖励 / 付费点，或担心通胀与资源枯竭 |
| **level-designer** | 空间布局、遭遇设计、节奏把控 | 要设计一个战场 / 关卡 / 遭遇区域的结构和敌人摆放 |
| **ux-designer** | 玩家可读性、HUD 设计、反馈系统 | UI / HUD 让人困惑、指引不清楚、想做可读性审查 |
| **narrative-director** | 剧情结构、ludonarrative 一致性、世界观设定 | 要写角色 / 世界观 / 剧情节奏，或担心故事和玩法脱节 |
| **art-director** | 美术方向定义、art bible、向美术提需求的语言 | 要确定视觉风格、写 art bible、或不知道怎么和美术沟通 |
| **audio-director** | 音频方向、音乐与音效设计原则 | 要制定声音美学、写 sound bible、设计自适应音乐系统 |
| **creative-director** | 愿景与支柱评议、压力测试「这是否还是同一款游戏」 | 有重大设计分叉、想验证新方向是否背离核心支柱、或需要从整体视角仲裁 |

---

## ★ 最重要的告诫：设计建议没有 oracle

**与代码不同，设计建议没有自动判据。**

测试能证明代码正确，但测试证不了「好不好玩 / 平不平衡 / 节奏对不对」。顾问只提供框架与初稿，**playtest 才是终审**。

最大风险：接受了「听起来很专业、其实平庸或不合本作」的建议，而无力判断优劣。

**对策：**

1. **要求顾问亮推理 + 引框架**——「按 MDA 框架，这个机制服务的是 Challenge 还是 Fantasy？」优于「感觉这个好」。
2. **永远让顾问给 2–4 个选项**，而不是一个答案；你根据本作具体约束来选。
3. **按本作上下文过滤**——把你游戏的具体约束（类型 / 范围 / 支柱）讲清楚，例如垂直切片 Demo 不是 AAA 开放世界；顾问给的通用框架要往这个方向裁剪。
4. **用 playtest 验**——任何设计建议，在没有真实玩家反馈之前都只是假设。

---

## 怎么用

直接在对话里点名，例如：

- 「找 **game-designer** 帮我把核心战斗循环理一遍」
- 「找 **systems-designer** 设计一套伤害公式，要求区分近 / 中 / 远距」
- 「找 **creative-director** 压力测试：加入这个新单位会不会破坏某条核心支柱」

也可以由主控 agent 派发（见伴随式 skill `design-advisory`）。

**产出的设计文档落你项目的设计文档目录**（如 `docs/design/`）；文档模板见本库 `templates/design/`。

---

## 不是什么

**不是 BMAD 流程。**

本部门没有安装 epics / stories / TR-registry / ADR / story-done 那套 BMAD 管理体系。这里只要顾问，不要流程——完整的 BMAD 流程会与 superpowers 派发体系以及你已有的工作流冲突。

模板里保留了「Related ADRs」字段作为可选占位，但本部门不预设 ADR 流程；填与不填均可。

---

## 出处与许可

Adapted from [https://github.com/donchitos/claude-code-game-studios](https://github.com/donchitos/claude-code-game-studios)（MIT License）。
本移植：仅移植设计域 9 个顾问，解耦了原模板中的流程绑定，改为中文说明，并加入了「设计建议没有 oracle」告诫。

---

*安装：把本目录下 9 个顾问 `.md` 拷进你项目的 `.claude/agents/`（cwd 本地配置）；模板见本库 `templates/design/`。*
