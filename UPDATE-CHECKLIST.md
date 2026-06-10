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
3. commit + push 本仓库——**项目约定与本库不允许漂移**。

## Godot 引擎升级时

1. 重跑模板 runner 的全量测试确认 SceneTree 脚本模式仍然成立。
2. GUI 子系统/headless 行为若变（如官方加了 console wrapper），更新
   godot-headless-testing 坑表第一行。
