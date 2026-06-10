# 工具链更新同步清单

本包依赖的上游在持续演进，**任一更新后过一遍对应清单**，再更新 README 版本表。

## godot-mcp-enhanced 更新时（`npx -y` 冷启动自动拉新）

1. `npm view godot-mcp-enhanced version` 记录新版本号。
2. 冒烟（在任一 Godot 项目里）：
   - `screenshot capture` 截一个带 HUD 的场景 → 出图；
   - `game` 的 game_bridge_install + game_query(get_tree) → 正常返回；
   - `audio_play` 指定一个 wav → 不报错。
3. 行为变化/新能力 → 更新 `skills/gamedev-toolchain/SKILL.md` 的能力表与"核对于 vX.Y.Z"。
4. 破坏性变化 → 在 README 版本表标注最后兼容版本，必要时改用
   `npx -y godot-mcp-enhanced@<固定版本>` 钉版本。

## superpowers 插件更新时

1. 留意 skill 改名/拆分（本包多处 `superpowers:xxx` 交叉引用）。
2. 失效引用 → 更新 tiered-gamedev-workflow 与 gamedev-toolchain 的引用名。

## 本地工作流迭代时（复盘回路产生修订）

1. 项目 CLAUDE.md 修订记录新增条目后，把规则变化同步进对应 SKILL.md：
   - 流程/判级/复盘 → tiered-gamedev-workflow
   - 测试坑/模式 → godot-headless-testing
   - 提交/协作 → solo-repo-discipline
   - 工具用法 → gamedev-toolchain
2. 同一事故在 SKILL.md 红线表/坑表里补一行（带"现实"反驳）。
3. **发布前脱敏**：本库公开——去除本机路径、用户名、私有项目专属细节，
   只保留可泛化的规则与事故模式（事故示例匿名化到"用户/某项目"级）。
4. commit + push 本仓库——**项目约定与本库不允许漂移**。

## Claude Code harness / 终端环境更新时

1. 实测 shell 基线：`$PSVersionTable.PSVersion` + `[Console]::OutputEncoding`——
   版本或编码变了，**所有以旧 shell 为前提的规则全部重新实测**（不靠猜）。
2. 冒烟三件：①含 `"引号"`/`(括号)`/中文 的 here-string 提交进临时仓库，
   `git log --format=%B` 验完整；②无 BOM UTF-8 中文 .ps1 执行；③MCP 工具调用
   方式（是否延迟加载、是否需先 ToolSearch）。
3. 盘点新 harness 能力（后台任务/子代理/定时任务/worktree 等）→ 评估写进
   gamedev-toolchain 的阶段映射表。
4. 规则前提失效 → 改写对应 SKILL.md；**破坏性变更**（如基线升级）在 README
   版本表标注最后兼容 tag，并打主版本号 tag。
   （实例：2026-06-10 工具从 PS5.1/GBK 换 pwsh 7.6.2/UTF-8，BOM 与 -F 规则
   实测失效，v2.0.0 切 pwsh 7+ 基线。）

## Godot 引擎升级时

1. 重跑模板 runner 的全量测试确认 SceneTree 脚本模式仍然成立。
2. GUI 子系统/headless 行为若变（如官方加了 console wrapper），更新
   godot-headless-testing 坑表第一行。
