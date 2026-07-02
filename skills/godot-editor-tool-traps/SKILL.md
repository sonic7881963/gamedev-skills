---
name: godot-editor-tool-traps
description: Use when writing Godot 4 @tool editor scripts (calibration or authoring workbenches that live-preview and bake values into .tres), or when the editor silently crashes on save/bake, a .tres value "won't save", non-uniform scale is needed, or a tool scene's markers/params reset to old values on reopen.
---

# Godot 4 @tool 编辑器脚本 & .tres 资源 authoring 坑

写编辑器内 authoring/标定工作台（@tool 脚本实时预览 + bake 参数写回 .tres）时的深坑。
每条都来自真实事故；这些**发生在编辑器时**，SceneTree 无头测试套件抓不到（见「验证」）。

## 坑表

| 症状 | 根因 | 解法 |
|---|---|---|
| @tool 场景里勾一个开关 / 改一个属性触发存盘后，**编辑器静默闪退**（窗口直接消失，日志无 backtrace） | 在 `@export` 属性的 `set(v):` 回调里**同步**调 `ResourceSaver.save`（或任何触碰编辑器 EditorFileSystem 重导入的操作）→ 在 Inspector 属性设值回调栈内重入编辑器状态，native 崩溃 | setter 里用 `_do_it.call_deferred()` 把存盘/重操作**延出属性回调**、放到空闲帧执行；绝不在 setter 内同步 `ResourceSaver.save` |
| 存盘后 .tres 里某属性"没保存"（文件里根本没有那一行） | Godot 文本资源 saver **只序列化与脚本 @export 默认值不同的属性**；值恰好 == 默认（如 `@export var scale: float = 1.0` 存 1.0）会被**省略** | 认清这是正常行为（读回时取默认=正确值）。**但若该默认值又兼作判据**（如"未标定"探测 `if x == 1.0: auto_fit()`），合法的默认值会被误判重置 → 改用独立布尔标记（`calibrated: bool`）或换个哨兵默认值，别让默认值兼两职 |
| @tool `_process` 每帧重建预览（spawn 节点 / 移动 marker）时，存盘崩溃或预览垃圾节点被写进 .tscn 累积 | 每帧重建与编辑器存盘序列化/重导入撞车；`owner = edited_scene_root` 的自建预览节点会被存进场景文件 | `_saving` 门：`_notification(NOTIFICATION_EDITOR_PRE_SAVE)` 置 `_saving=true` 暂停 `_process` 重建 + 剥离所有自建可视节点；`NOTIFICATION_EDITOR_POST_SAVE` 复位。→ 场景文件永不含预览、开场干净 |
| 模型/装备只能整体等比缩放，想 x≠y≠z（非等比）却存不下 | scale 字段是单个 `float`，bake 只取一个分量、丢其余 | 把字段从 `float` 升 `Vector3`：改类型 + **所有消费方 coercion**（`inst.scale = sc if sc is Vector3 else Vector3.ONE * float(sc)`，兼容仍传 float 的旧路径）+ 迁移既有 .tres 标量→等值 `Vector3(x,x,x)`（否则标量喂 Vector3 属性 → 读成默认 ONE、模型崩） |
| 标定/authoring 工具**重开场景后 marker/参数回到旧种子值**、上次 bake 丢了 | bake 只写回 .tres，但开场不从 .tres 反向载入节点位置/参数（.tscn 里存的是旧种子） | `_ready()` 内（`if Engine.is_editor_hint()`）从 .tres 反向载入节点 transform/参数，实现 round-trip；另给一个手动"重载"开关（@export bool setter）随时重拉 |

## 验证（编辑器脚本的解析错测试套件抓不到）

`extends SceneTree` 无头测试套件通常只扫 `res://scripts`（或类似），**不扫 `scenes/`、`addons/` 下的
@tool/authoring 脚本** → 这些脚本的解析错（改了个签名、少个参数）不会翻红，静默漏到编辑器里才爆。

改动 @tool / authoring 场景脚本后，跑一次 headless parse-check：

```
godot --headless --path <绝对项目路径> --check-only --script res://path/to/tool.gd
```

判 `EXIT` 码 + stderr（空=通过）。★`--path` 用**绝对路径**——相对 `.` 会漂到 shell 的当前目录导致
"File not found"。真正的可视/交互验收（gizmo 拖动、bake、round-trip）仍须人在编辑器手验。

## 相关

- 无头测试骨架 / 测试期坑：`godot-headless-testing`
- 工具链（MCP/搜索）：`gamedev-toolchain`
