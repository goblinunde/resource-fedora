# Yazi 配置文件 (含中文注释)

> 这是一套完整的、带中文注释的 Yazi 文件管理器配置,集成了插件系统以支持 Markdown、图片、PDF 等多种文件格式的预览功能。

## ✨ 特性

- 📝 **完整的中文注释** - 所有配置项都有详细的中文说明
- 🎨 **Tokyo Night 主题** - 美观的暗色主题配色
- ⌨️ **Vim 风格快捷键** - 符合 Vim 用户习惯的键位绑定
- 🔌 **增强预览功能** - 支持 20+ 种文件格式的高级预览
  - 📄 **PDF** - pdftoppm 图片预览
  - 📊 **数据文件** - CSV/TSV/Parquet (Rich/DuckDB)
  - 📓 **Jupyter Notebook** - nbpreview 渲染
  - 🎵 **音频/视频** - exiftool/mediainfo 元数据
  - 📝 **Markdown/JSON** - Rich-CLI 美化渲染
  - 🗄️ **SQLite** - 数据库结构预览
- 🛠️ **插件生态系统** - 预配置 7 个增强插件

## 📁 文件说明

| 文件 | 说明 | 对应官方文件 |
|------|------|--------------|
| [`yazi.toml`](yazi.toml) | 主配置文件(含中文注释) | yazi-default.toml |
| [`keymap.toml`](keymap.toml) | 键位绑定配置(含中文注释) | keymap-default.toml |
| [`theme.toml`](theme.toml) | Tokyo Night 主题配置 | theme-dark.toml |
| [`init.lua`](init.lua) | 插件初始化脚本 | - |
| [`YAZI_CONFIG_GUIDE.md`](YAZI_CONFIG_GUIDE.md) | 配置指南(中文) | - |
| `yazi-default.toml` | 官方默认配置(参考用) | - |
| `keymap-default.toml` | 官方默认键位(参考用) | - |
| `theme-dark.toml` | 官方暗色主题(参考用) | - |
| `theme-light.toml` | 官方亮色主题(参考用) | - |
| [`plugin.md`](plugin.md) | 官方插件文档 | - |

## 🚀 快速开始

### 1. 安装 Yazi

```bash
# Fedora
sudo dnf install yazi

# 或使用 Cargo 安装最新版
cargo install --locked yazi-fm yazi-cli
```

### 2. 安装配置文件

```bash
# 创建配置目录
mkdir -p ~/.config/yazi/plugins

# 复制配置文件到 Yazi 配置目录
cp yazi.toml ~/.config/yazi/
cp keymap.toml ~/.config/yazi/
cp theme.toml ~/.config/yazi/
cp init.lua ~/.config/yazi/
```

### 3. 安装插件

```bash
# 安装 piper.yazi (通用预览插件)
ya pkg add yazi-rs/plugins:piper

# 安装 mux.yazi (插件复用器)
ya pkg add peterfication/mux
```

### 4. 安装依赖工具

#### 系统工具 (Fedora)

```bash
# 基础预览工具
sudo dnf install \
    bat \              # 代码语法高亮
    glow \             # Markdown 渲染
    eza \              # 目录树显示
    hexyl              # 十六进制查看器

# 高级预览工具
sudo dnf install \
    poppler-utils \    # PDF 预览 (pdftoppm, pdftotext)
    perl-Image-ExifTool \  # 音频元数据 (exiftool)
    ffmpeg \           # 视频信息提取
    mediainfo \        # 媒体文件详细信息
    duckdb \           # 数据文件分析
    sqlite             # SQLite 数据库

# 可选: 搜索工具
sudo dnf install fd-find ripgrep fzf
```

#### Python 工具 (使用 uv)

```bash
# 安装 uv (如果还没有)
curl -LsSf https://astral.sh/uv/install.sh | sh

# 安装预览增强工具
uv tool install rich-cli    # 美化 Markdown/JSON/CSV
uv tool install nbpreview    # Jupyter Notebook 预览
```

> [!TIP]
> **或者使用自动安装脚本**: `bash install_yazi_config.sh` 会自动检查并提示安装缺失的依赖

### 5. 启动 Yazi

```bash
yazi
```

## 📖 配置说明

### 主要功能

#### 增强预览

配置中集成了以下预览增强功能:

**文本和数据**:

- **Markdown** - 使用 `rich-cli` (备选 `glow`) 美化渲染
- **JSON** - 使用 `rich-cli` 语法高亮和格式化
- **CSV/TSV** - 使用 `rich-cli` 表格显示或 `duckdb` 数据分析
- **Jupyter Notebook** - 使用 `nbpreview` 渲染 `.ipynb` 文件

**文档和数据库**:

- **PDF** - 使用 `pdftoppm` 转换首页为图片预览
- **SQLite** - 显示数据库结构 (`.schema`)
- **Parquet** - 使用 `duckdb` 查询和预览数据

**媒体文件**:

- **图片** - 内置图片预览器，支持多种格式
- **音频** - 使用 `exiftool` 显示元数据和封面
- **视频** - 使用 `mediainfo` / `ffmpeg` 显示详细媒体信息
- **字幕** - 预览字幕文件内容和元数据

**其他**:

- **目录树** - 使用 `eza` 显示目录结构
- **压缩包** - 显示压缩包内容列表
- **后备预览** - 使用 `hexyl` 十六进制查看不支持的文件

#### 快捷键

所有快捷键都采用 Vim 风格,并有详细的中文说明。常用快捷键:

| 功能 | 快捷键 |
|------|--------|
| 上/下移动 | `k` / `j` |
| 进入父/子目录 | `h` / `l` |
| 复制/剪切 | `y` / `x` |
| 粘贴 | `p` |
| 删除 | `d` (回收站) / `D` (永久删除) |
| 创建文件/目录 | `a` |
| 重命名 | `r` |
| 搜索文件名 | `s` |
| 搜索内容 | `S` |
| 显示帮助 | `~` 或 `F1` |

查看完整快捷键列表,请参阅 [YAZI_CONFIG_GUIDE.md](YAZI_CONFIG_GUIDE.md)

#### Tokyo Night 主题

配置采用 Tokyo Night 配色方案,提供美观的暗色主题。主要配色:

- 蓝色 `#7aa2f7` - 高亮、边框
- 绿色 `#9ece6a` - 成功、Shell
- 黄色 `#e0af68` - 警告、Python
- 红色 `#f7768e` - 错误、删除
- 紫色 `#bb9af7` - Markdown、图片

## 🔧 自定义配置

如果你想自定义配置,编辑以下文件:

- `~/.config/yazi/yazi.toml` - 修改文件管理器行为、预览设置等
- `~/.config/yazi/keymap.toml` - 自定义快捷键绑定
- `~/.config/yazi/theme.toml` - 调整主题配色和文件图标
- `~/.config/yazi/init.lua` - 添加自定义 Lua 函数和插件配置

详细的配置说明请参阅 [YAZI_CONFIG_GUIDE.md](YAZI_CONFIG_GUIDE.md)

## 🐛 故障排除

### 图片预览不显示

确保终端支持图片协议(Kitty, iTerm2, WezTerm)。对于不支持的终端,安装 `ueberzug`:

```bash
sudo dnf install ueberzug
```

### Markdown 预览显示纯文本

确保已安装 `glow` 并且在 `PATH` 中:

```bash
sudo dnf install glow
which glow
```

### PDF 预览不工作

确保已安装 `poppler-utils`:

```bash
sudo dnf install poppler-utils
```

### 文件图标不显示

确保终端字体支持 Nerd Font 图标,推荐使用 `0xProto Nerd Font Mono`:

```bash
sudo dnf install 'google-noto*' 'nerd-fonts*'
```

然后在终端设置中选择 Nerd Font 字体。

### 启用调试日志

```bash
YAZI_LOG=debug yazi
tail -f ~/.local/state/yazi/yazi.log
```

## 📚 参考资源

- [Yazi 官方文档](https://yazi-rs.github.io/)
- [Yazi GitHub 仓库](https://github.com/sxyazi/yazi)
- [Yazi 插件列表](https://yazi-rs.github.io/docs/plugins/overview)
- [配置详细指南](YAZI_CONFIG_GUIDE.md)

## ⚠️ 重要提示

> [!IMPORTANT]
> 如果你使用的是稳定版 Yazi(而非每日构建版),请确保从 [`shipped` 标签](https://github.com/sxyazi/yazi/tree/shipped) 检出官方配置文件,而不是最新的 `main` 分支。

这些配置文件在安装 Yazi 时已经包含在内了,你不需要手动下载或复制它们到配置目录。

但是,如果你想自定义某些配置:

- 创建 `~/.config/yazi/yazi.toml` 来覆盖 `yazi-default.toml` 中的设置
- 创建 `~/.config/yazi/keymap.toml` 来覆盖 `keymap-default.toml` 中的设置
- 创建 `~/.config/yazi/theme.toml` 来覆盖主题设置

## 📄 许可证

本配置文件基于官方默认配置修改,遵循 MIT 许可证。
