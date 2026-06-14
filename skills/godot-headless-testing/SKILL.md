---
name: godot-headless-testing
description: Use when writing or debugging automated tests for Godot 4 projects — headless tests hang or time out with no output, animation/physics timing asserts fail intermittently, new class_name types are "not found", a freed object crashes a typed parameter, or the test suite has grown slow
---

# Godot 4 无头测试模式（SceneTree 脚本 + 并行运行）

## 核心原则

测试 = `extends SceneTree` 的无头脚本，自带看门狗、事件驱动断言、确定性环境剥离；
套件并行跑（互不依赖），总时长 = 最慢单测。

## 测试骨架

```gdscript
extends SceneTree
## 一句话说明断言对象。

var _frames := 0
var _fail := 0

func _check(cond: bool, msg: String) -> void:
	if not cond:
		print("FAIL: ", msg)
		_fail += 1

func _initialize() -> void:
	seed(20260610)  # 必须播种:偶发要可复现——可复现的 bug 值十分钟,不可复现的值两小时
	# 搭场景/单位...
	physics_frame.connect(_on_phys)

func _on_phys() -> void:
	_frames += 1
	if _frames > 600:  # 看门狗:脚本错误会中断断言流程,没有它进程挂死主循环
		print("FAILED: watchdog timeout")
		quit(1)
		return
	# 状态机式分阶段断言...
	# 终态: print("PASS: ..."); quit(0) 或 print("FAILED: ", _fail); quit(1)
```

## 坑表（每条都来自真实事故）

| 症状 | 根因 | 解法 |
|---|---|---|
| 测试"跑完"但无输出、拿不到退出码 | Windows 版 Godot 是 GUI 子系统应用 | `Start-Process -PassThru -NoNewWindow -RedirectStandardOutput/-RedirectStandardError` + `WaitForExit(超时)` 强杀；勿直接调用 |
| 进程永不退出 | SceneTree 脚本内的 SCRIPT ERROR 中断当帧断言、quit 永远不执行 | 测试必带帧数看门狗；runner 必带超时强杀 |
| 按帧号等动画/事件的断言偶发失败 | 动画与战斗逻辑走 `_process`（墙钟），物理帧固定步长，启动头几帧引擎卡顿、两钟漂移 1-2 帧 | **事件驱动**：轮询等可观察状态（信号计数/monitoring 翻转）再断言；必须比帧数时给 ≥5 帧裕度 |
| 想冻结某单位但它还是动了一拍 | `queue_free()` 帧末才生效，AI 在当帧已执行 | **入树前**剥离：`unit.remove_child(ai); ai.free()` 再 `add_child(unit)` |
| 测试按名字引用新类型报 "Could not find type" | `--script` 模式不刷新全局类缓存 | 新增 `class_name` 后先跑一次 `--headless --import` |
| freed 对象传入函数直接报错（尤其某类型**首次**变得可被 `queue_free` 时） | typed 参数在调用边界拒收已释放实例，函数内 `is_instance_valid` 守卫来不及跑；旧代码假设"该类型永不释放"故只 `!= null`/`is_dead` 检查，新 free 路径让这些缓存引用悄悄变 freed | 可能收到已释放对象的参数用无类型 `Variant`，先 `is_instance_valid`；**引入新 `queue_free` 路径时主动审一遍所有存量引用持有方（缓存的 current_target/目标等）与它们穿越的 typed-param 边界**——陷阱已知 ≠ 已应用 |
| 战局测试随平衡调参反复翻红 | 断言了"谁赢"——胜负随数值漂移 | **只断言行为**（推进发生/命令生效/位移量）；胜负观察放非门禁脚本 |
| 测试偶发"前置失败/触发不了"（百分之十几概率） | **setup 的触发条件赌了战局结果**（如"某队必须先死光才触发被测行为"——另一队可能直接获胜）：平衡敏感漏洞藏在前置而非断言 | 平衡敏感纪律覆盖**断言与前置**：触发条件一律确定化（关键单位 1 HP 必死 / 9999 HP 必活） |
| 死亡单位偶发不倒地：空挥无伤害、永远站立 | 状态机特性只测了受击×相位、漏死亡×相位（伤害层守卫造成"死亡已处理"错觉）：死在 WINDUP/READY 死后照常释放，strike 动画顶掉死亡姿势 | 状态机特性的测试清单必须含**中断矩阵**：每个相位 × {受击, 死亡}；死亡须停机所有自驱状态机（halt 且不发 cancel——cancel 会把动画器拍回 locomotion） |
| 套件越来越慢 | 串行起进程，每个 2-4s 启动 + 战局秒级模拟 | 并行 runner：同批起进程逐个收割（见 templates/run_tests.ps1，串行分钟级 → 一两分钟） |
| 并行全量偶发翻红、单测稳定通过 | **满核并行 CPU 饥饿**：重负载测试（长战局模拟）被拖到看门狗超时/时序漂移 | runner 留 2 核（核数−2）+ 重负载测试隔离末批只彼此并行；调试此类偶发**先单测循环定性，禁止反复跑全量钓鱼**（一次教训：82 分钟） |
| 战局测试慢得离谱（帧数÷60≈墙钟秒数） | **headless 默认仍按 60fps 实时步进**——引擎在真实时间里空等模拟打完 | runner 加 `--fixed-fps 60`：delta 固定且主循环全速空转（实测 3-3.6×）；固定 delta 顺带根除"动画墙钟 vs 物理固定步"漂移类偶发 |
| 同一偶发每次跑都不一样、无法定位 | 测试未播种，引擎 RNG 每次新宇宙 | 骨架 `_initialize()` 首行 `seed(固定值)`——偶发变必现/必不现；纯逻辑断言另入**单元合订本**（一进程多断言，免每测启动税） |
| 测试全绿，游戏里却脚本加载失败/黑屏 | **class_name 是全局类型图**：任一脚本的类型冲突（如大迁移期 Vector2/Vector3）级联毒化引用它的脚本——A 引用 B 类型、B 解析失败 → A 编译失败；测试只编译自己的依赖链，拦不住 | 交付验收含**一次真实启动 + stderr 捕获为空**；大迁移期未迁脚本一律打 parse 保活 shim（签名桥/边界转换），语义由归属切片重写 |
| 单位在游戏里沉穿地板/穿墙，移动测试却全绿 | 测试载具用裸物理体（默认碰撞掩码）而非游戏单位基类——**掩码 × 静态世界层的交互不在覆盖里**（实例：单位掩码沿用 2D 时代不含地面层，重力一开边走边沉） | 移动/物理类测试载具用**真实单位基类**；水平位移断言配**垂直稳定性断言**（`absf(y) < 容差`） |

## 确定性环境清单

- 敌我单位入树前剥 AI（手动驱动，时序可控）
- 陪练单位血量拉满（`hp.current_hp = 9999`）防被试招打死
- 信号计数用 lambda 收集（`signal.connect(func(): _count += 1)`），同帧同步断言
- `physics_frame` 信号先于节点物理回调——同帧内的注入+断言不受 AI 干扰

## 测试基建迭代触发器（助手主动提案，用户免记忆）

测试基建会随项目长大而过时——迭代不能依赖用户"想起来"。任一触发即在当前任务
收尾时**主动**提出迭代提案（一轮确认后实施）：

1. 全量并行 >3 分钟，或单测 >30s；
2. 任何偶发/flaky 出现（连带复现纪律）；
3. 逃逸/验收期 bug 暴露测试缺口——修复必须连**测试模式**一起修（载具类型、
   断言维度），不是只补一个测试；
4. 同一样板模式在 ≥3 个测试里重复（抽进基建/合订本）;
5. 每子项目/里程碑交付自带一次测试台账核对（缺口/冗余/时长）。

## 纪律

红（单测）→ 绿（单测）→ 并行全量 ×1 → 提交（**REQUIRED**：superpowers:test-driven-development）。
提交前的全量并行用**后台任务**跑（Claude Code run_in_background）——期间准备 diff
自查与 commit message，完成自动通知，不要轮询。
**分级验证**：纯注释/文档改动跑受影响单测做解析检查即可提交，免全量；
代码改动全量 ×1 不动摇。
3× 稳定性复跑只在改动时序敏感测试本身时做。意外翻红走 superpowers:systematic-debugging
——写一次性探针打印逐帧状态，定位后删探针，禁止猜改。
