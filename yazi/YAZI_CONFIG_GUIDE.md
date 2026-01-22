# Yazi 配置指南

> **Yazi** 是一个快速、现代化的终端文件管理器,基于 Rust 编写,支持丰富的预览功能和插件系统。

## 📋 目录

- [配置文件结构](#配置文件结构)
- [快速开始](#快速开始)
- [配置详解](#配置详解)
- [插件系统](#插件系统)
- [依赖项](#依赖项)
- [快捷键速查](#快捷键速查)
- [常见问题](#常见问题)

---

## 配置文件结构

Yazi 的配置文件位于 `~/.config/yazi/`,结构如下:

```
~/.config/yazi/
├── yazi.toml       # 主配置文件
├── keymap.toml     # 键位绑定配置
├── theme.toml      # 主题配置
├── init.lua        # 插件初始化脚本
└── plugins/        # 插件目录
    ├── piper.yazi/ # 管道预览插件
    └── mux.yazi/   # 插件复用器
```

---

## 快速开始

### 1. 安装 Yazi

```bash
# Fedora
sudo dnf install yazi

# 或使用 Cargo 安装最新版
cargo install --locked yazi-fm yazi-cli
```

### 2. 复制配置文件

```bash
# 创建配置目录
mkdir -p ~/.config/yazi/plugins

# 复制配置文件
cp /home/yyt/Documents/Github/resource-fedora/yazi/yazi.toml ~/.config/yazi/
cp /home/yyt/Documents/Github/resource-fedora/yazi/keymap.toml ~/.config/yazi/
cp /home/yyt/Documents/Github/resource-fedora/yazi/theme.toml ~/.config/yazi/
cp /home/yyt/Documents/Github/resource-fedora/yazi/init.lua ~/.config/yazi/
```

### 3. 安装插件

```bash
# 安装 piper.yazi (通用预览插件)
ya pkg add yazi-rs/plugins:piper

# 安装 mux.yazi (插件复用器)
ya pkg add peterfication/mux
```

### 4. 安装依赖工具

```bash
# 安装预览工具
sudo dnf install \
    bat \              # 代码语法高亮
    glow \             # Markdown 渲染
    poppler-utils \    # PDF 预览
    eza \              # 目录树显示
    hexyl \            # 十六进制查看器
    mediainfo \        # 媒体信息查看
    exiftool           # EXIF 信息查看
```

### 5. 启动 Yazi

```bash
yazi
```

---

## 配置详解

### 主配置文件 (`yazi.toml`)

#### 文件管理器设置

```toml
[mgr]
# 窗口布局比例 [父目录:当前目录:预览窗口]
ratio = [1, 4, 3]

# 文件排序方式
sort_by = "alphabetical"  # alphabetical | created | modified | natural | size | extension

# 是否优先显示目录
sort_dir_first = true

# 是否显示隐藏文件
show_hidden = false
```

#### 预览设置

```toml
[preview]
# 预览窗口最大尺寸
max_width = 600
max_height = 900

# 图片预览质量 (1-100)
image_quality = 75

# 图片缩放滤镜
image_filter = "triangle"  # nearest | triangle | catmull-rom | gaussian | lanczos3
```

#### 插件系统配置

配置文件中已集成以下增强预览功能:

- **Markdown 预览**: 使用 `glow` 渲染
- **CSV 预览**: 使用 `bat` 语法高亮
- **目录树预览**: 使用 `eza` 显示
- **PDF 预览**: 内置 PDF 预览器
- **图片预览**: 内置图片预览器
- **后备预览器**: 使用 `hexyl` 十六进制查看

---

### 键位绑定 (`keymap.toml`)

#### Vim 风格导航

| 按键 | 功能 |
|------|------|
| `j/k` | 下/上移动 |
| `h/l` | 进入父目录/子目录 |
| `gg` | 跳转到顶部 |
| `G` | 跳转到底部 |
| `Ctrl-u/d` | 上/下翻半页 |
| `Ctrl-b/f` | 上/下翻整页 |

#### 文件操作

| 按键 | 功能 |
|------|------|
| `y` | 复制文件 (yank) |
| `x` | 剪切文件 (cut) |
| `p` | 粘贴文件 |
| `d` | 移至回收站 |
| `D` | 永久删除 |
| `a` | 创建文件/目录 |
| `r` | 重命名 |

#### 预览控制

| 按键 | 功能 |
|------|------|
| `J/K` | 预览窗口向下/上滚动 |
| `Tab` | 聚焦到当前文件 |

#### 快速跳转

| 按键 | 功能 |
|------|------|
| `gh` | 跳转到家目录 `~` |
| `gd` | 跳转到下载目录 `~/Downloads` |
| `gD` | 跳转到文档目录 `~/Documents` |
| `gp` | 跳转到项目目录 `~/Documents/Github` |
| `gc` | 跳转到配置目录 `~/.config` |

#### 搜索和过滤

| 按键 | 功能 |
|------|------|
| `s` | 通过 `fd` 按文件名搜索 |
| `S` | 通过 `rg` 按内容搜索 |
| `f` | 过滤文件 |
| `/` | 查找文件 |
| `n/N` | 下/上一个查找结果 |

---

### 主题配置 (`theme.toml`)

#### Tokyo Night 调色板

本配置采用 **Tokyo Night** 配色方案:

| 颜色 | 十六进制 | 用途 |
|------|----------|------|
| 蓝色 | `#7aa2f7` | 高亮、边框、链接 |
| 青色 | `#7dcfff` | 可执行文件、音频 |
| 绿色 | `#9ece6a` | 成功、LaTeX、Shell |
| 黄色 | `#e0af68` | 警告、Python、视频 |
| 橙色 | `#ff9e64` | Rust、Git |
| 红色 | `#f7768e` | 错误、删除、压缩包 |
| 紫色 | `#bb9af7` | Markdown、图片 |

#### 自定义文件图标

配置中已为常见文件类型设置了 Nerd Font 图标,确保你的终端字体支持图标显示(推荐使用 `0xProto Nerd Font Mono`)。

---

## 插件系统

### 已配置插件

#### 1. **piper.yazi** - 管道预览插件

允许使用任意 Shell 命令作为预览器。

**使用示例**:

```toml
[[plugin.prepend_previewers]]
url = "*.md"
run = 'piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark "$1"'
```

**可用变量**:

- `$w` - 预览区域宽度
- `$h` - 预览区域高度
- `$1` - 文件路径

#### 2. **mux.yazi** - 插件复用器

允许为同一文件类型定义多个预览器并循环切换。

### 安装新插件

```bash
# 使用 ya pkg 安装插件
ya pkg add <author>/<plugin-name>

# 示例: 安装 git.yazi 插件
ya pkg add yazi-rs/plugins:git
```

### 自定义插件

在 `~/.config/yazi/plugins/` 创建自己的插件:

```
~/.config/yazi/plugins/my-plugin.yazi/
├── main.lua    # 插件入口
├── README.md   # 文档
└── LICENSE     # 许可证
```

---

## 依赖项

### 必需依赖

| 工具 | 用途 | 安装命令 |
|------|------|----------|
| `yazi` | Yazi 主程序 | `sudo dnf install yazi` |

### 预览增强依赖

| 工具 | 用途 | 安装命令 |
|------|------|----------|
| `bat` | 代码语法高亮 | `sudo dnf install bat` |
| `glow` | Markdown 渲染 | `sudo dnf install glow` |
| `poppler-utils` | PDF 预览 | `sudo dnf install poppler-utils` |
| `eza` | 目录树显示 | `cargo install eza` |
| `hexyl` | 十六进制查看 | `sudo dnf install hexyl` |
| `mediainfo` | 媒体信息 | `sudo dnf install mediainfo` |
| `exiftool` | EXIF 信息 | `sudo dnf install perl-Image-ExifTool` |
| `fd` | 文件搜索 | `sudo dnf install fd-find` |
| `rg` (ripgrep) | 内容搜索 | `sudo dnf install ripgrep` |
| `sqlite3` | SQLite 数据库预览 | `sudo dnf install sqlite` |

### 可选依赖

| 工具 | 用途 | 安装命令 |
|------|------|----------|
| `fzf` | 模糊查找 | `sudo dnf install fzf` |
| `zoxide` | 智能目录跳转 | `sudo dnf install zoxide` |
| `mpv` | 媒体播放 | `sudo dnf install mpv` |

---

## 快捷键速查

### 常用操作

```
移动: j/k/h/l       搜索: s/S         操作: y/x/p
选择: Space         过滤: f           删除: d/D
标签: t/1-9         帮助: ~/<F1>      退出: q
```

### 完整快捷键列表

启动 Yazi 后按 `~` 或 `F1` 查看完整的交互式帮助。

---

## 常见问题

### Q: 图片预览不显示?

**A**: 确保终端支持图片协议(Kitty, iTerm2, WezTerm)或安装 `ueberzug`:

```bash
sudo dnf install ueberzug
```

### Q: Markdown 预览显示纯文本?

**A**: 确保已安装 `glow`:

```bash
sudo dnf install glow
```

如果仍有问题,检查 `glow` 是否在 `PATH` 中:

```bash
which glow
```

### Q: PDF 预览不工作?

**A**: 确保已安装 `poppler-utils`:

```bash
sudo dnf install poppler-utils
which pdftoppm  # 应该能找到路径
```

### Q: 文件图标不显示?

**A**: 确保终端字体支持 Nerd Font 图标。推荐安装:

```bash
# 安装 Nerd Font
sudo dnf install nerd-fonts
```

然后在终端设置中选择 `0xProto Nerd Font Mono` 或其他 Nerd Font。

### Q: 如何调试插件问题?

**A**: 启用调试日志:

```bash
# 启动 Yazi 时设置日志级别
YAZI_LOG=debug yazi

# 查看日志
tail -f ~/.local/state/yazi/yazi.log
```

### Q: 如何自定义快捷键?

**A**: 编辑 `~/.config/yazi/keymap.toml`,添加或修改键位绑定:

```toml
[[manager.prepend_keymap]]
on = ["g", "p"]
run = "cd ~/Documents/Github"
desc = "跳转到项目目录"
```

### Q: 如何更改主题颜色?

**A**: 编辑 `~/.config/yazi/theme.toml`,修改对应的颜色值。可参考 [官方主题文档](https://yazi-rs.github.io/docs/configuration/theme)。

---

## 参考资源

- [Yazi 官方文档](https://yazi-rs.github.io/)
- [Yazi GitHub 仓库](https://github.com/sxyazi/yazi)
- [Yazi 插件列表](https://yazi-rs.github.io/docs/plugins/overview)
- [Tokyo Night 主题](https://github.com/tokyo-night/tokyo-night-vscode-theme)

---

## 许可证

本配置文件基于官方默认配置修改,遵循 MIT 许可证。
