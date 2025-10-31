# 一夜终极狼人发牌器（One Night Ultimate Werewolf Dealer）

一个用 Python + Tkinter 编写的“一夜终极狼人”发牌与夜晚引导工具。支持图形化选角、按序查看、引导式夜晚流程、基础结算，并可选播放夜晚提示音与 BGM。

## 功能特点

- 图形化角色选择：支持点击卡片选择角色，狼人可设置数量；守夜人自动以两张计入。
- 按序查看：玩家逐个点击查看自己的身份，避免互相泄露。
- 引导式夜晚：按角色顺序显示操作说明与可交互区域（如强盗交换、捣蛋鬼点两人、酒鬼与中央交换等）。
- 可选音频：若 `sounds/` 下存在对应 MP3，将在夜晚阶段播放唤醒/闭眼提示音与背景音乐（可通过“设置”调整音量与开关）。
- 背景图与牌面图片：自动适配窗口大小，支持高 DPI 显示。

## 目录结构

```
OPI_one_night_werewolf/
├─ images/
│  ├─ background.jpg                 # 窗口背景（可选）
│  └─ roles/                         # 牌面图片（建议保留）
│     ├─ werewolf.png
│     ├─ seer.png
│     ├─ robber.png
│     ├─ troublemaker.png
│     ├─ drunk.png
│     ├─ insomniac.png
│     ├─ mason.png
│     ├─ minion.png
│     ├─ tanner.png
│     └─ villager.png
├─ sounds/                           # 可选音频（若不存在也能运行）
│  ├─ night_start.MP3
│  ├─ night_over.MP3
│  ├─ seer_wake.MP3 / seer_close.MP3
│  ├─ robber_wake.MP3 / robber_close.MP3
│  ├─ troublemaker_wake.MP3 / troublemaker_close.MP3
│  ├─ drunk_wake.MP3 / drunk_close.MP3
│  ├─ insomniac_wake.MP3 / insomniac_close.MP3
│  ├─ mason_wake.MP3 / mason_close.MP3
│  ├─ minion_wake.MP3 / minion_close.MP3
│  ├─ werewolf_wake.MP3 / werewolf_close.MP3
│  └─ Mysterious Light.mp3           # 夜晚 BGM（文件名需匹配）
└─ wolf/
	 ├─ main.py                        # 程序入口（Tk 版本）
	 ├─ core/
	 │  └─ werewolf_dealer.py         # 发牌与夜晚流程核心逻辑
	 └─ gui/
			├─ __init__.py
			└─ main_window.py              # Tk 界面与交互
```

说明：代码会优先尝试在 `wolf/resources/roles` 寻找图片资源，若不存在会自动回退到仓库根目录的 `images/roles`。因此建议保留 `images/roles` 目录。

## 环境要求

- Python 3.9+（3.8 也大概率可用）
- 依赖：
  - 必需：`Pillow`（用于图片显示）
  - 可选：`pygame` 或 `playsound`（用于音频播放，存在其一即可，优先使用 pygame）

## 安装依赖（Windows）

```cmd
cd /d d:\aclasses\嵌入式系统\实验\嵌入式系统\OPI_one_night_werewolf
pip install pillow
REM 可选安装音频后端（二选一或都装）
pip install pygame
pip install playsound==1.2.2
```

提示：若只想使用静音版本，`pygame/playsound` 可不安装。

## 运行

```cmd
cd /d d:\aclasses\嵌入式系统\实验\嵌入式系统\OPI_one_night_werewolf
python wolf\main.py
```

首次运行后即可看到 GUI：

- 选择玩家人数（4–12）。
- 在“选择角色”区域点击卡片选择（狼人用计数，守夜人自动两张）。
- 点击“开始局”后，按提示依次查看与进行夜晚操作。

## 使用说明（要点）

- 选角：
  - 狼人通过计数框设置数量。
  - 守夜人（mason）每次选择计为两张。
  - “随机发牌”会基于可选池随机补足玩家数+3 的牌。
- 夜晚阶段：
  - “开始夜晚”进入引导式流程，会按角色顺序给出操作说明。
  - 强盗需先选择一名玩家交换；捣蛋鬼需选择两名玩家交换；酒鬼需选择一张中央牌交换。
  - 夜晚结束后，点击一名玩家翻牌并给出简要胜负判定。
- 设置：
  - 可开关 BGM，调节 BGM 与提示音音量（提示音音量对 pygame 有效）。

## 资源命名约定与放置

- 牌面图片：放在 `images/roles/` 下，文件名需与角色 key 一致（大小写不敏感），例如：
  - `werewolf.png`, `seer.png`, `robber.png`, `troublemaker.png`, `drunk.png`, `insomniac.png`, `mason.png`, `minion.png`, `tanner.png`, `villager.png`
- 背景图：`images/background.jpg`（或 `background.png`）。
- 夜晚 BGM：建议文件名为 `Mysterious Light.mp3`（或 `mysterious light.mp3`），以便被自动识别。
- 角色提示音：命名形如 `seer_wake.MP3` / `seer_close.MP3`（下划线前为角色 key，后缀为 wake/close），放入 `sounds/`。

注意：若资源缺失，程序会尽量回退（例如用占位图、不播放音频），但体验会受影响。

## 常见问题（FAQ）

1) 启动后没有音效/音乐？

- 请安装 `pygame` 或 `playsound`（优先使用 pygame）。
- 确认 `sounds/` 目录存在，且文件名与 README 中的命名约定一致。
- BGM 文件名需匹配“`Mysterious Light.mp3`”前缀（不带 s）。若你的文件名是 “Mysterious Lights.mp3”，请重命名去掉最后的 s。

2) 图片不显示或报 PIL 错误？

- 确认已安装 `Pillow`：`pip install pillow`。
- 确认 `images/roles/` 目录存在，且包含对应角色的 PNG/JPG 文件。

3) 高 DPI 下显示模糊？

- 程序在 Windows 下会尝试设置 DPI 感知；若仍感觉模糊，可尝试在系统显示设置中调整缩放比例。

4) 规则配置在哪里？

- 目前 GUI 主要基于“玩家自选角色”开始一局，不强依赖外部规则文件。
- 引擎类 `WerewolfDealer` 支持 `roles_config.json` 的扩展（默认空字典），后续可按需要增加。

## 开发者提示

- 入口文件：`wolf/main.py`（使用 Tk 界面）。
- 核心逻辑：`wolf/core/werewolf_dealer.py`。
- 界面与交互：`wolf/gui/main_window.py`。
