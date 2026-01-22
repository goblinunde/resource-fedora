# 🚀 Fedora 43 Configuration Repository

> 基于 **Fedora 43 Workstation Edition (GNOME 49 + Wayland)** 的个人系统配置文件集合  
> 包含 Shell 配置、编辑器配置、开发工具配置和快速部署脚本

![Fedora](https://img.shields.io/badge/Fedora-43-blue?logo=fedora)
![Shell](https://img.shields.io/badge/Shell-Bash%20%7C%20Zsh%20%7C%20Fish%20%7C%20Nushell-green)
![Editor](https://img.shields.io/badge/Editor-Neovim%20%7C%20Vim-brightgreen?logo=neovim)
![License](https://img.shields.io/badge/License-MIT-orange)

---

## ✨ 特性

- 🎨 **统一美化主题** - 采用 Tokyo Night 配色方案，跨 Shell 和编辑器统一视觉体验
  - **Bash/Fish/Nushell**: 使用 [Starship](https://starship.rs/) 跨 Shell 提示符
  - **Zsh**: 使用 [Oh-My-Zsh](https://ohmyz.sh/) 框架 + 主题插件
- 🐚 **多 Shell 支持** - 提供 Bash、Zsh、Fish 和 Nushell 的完整配置
- ⚡ **现代化工具链** - 集成 Starship、bat、lsd、fd、rg 等现代 CLI 工具
- 📝 **强大编辑器配置** - LazyVim 定制化 Neovim 配置，支持 Python、Rust、LaTeX 开发
- 🔧 **一键部署脚本** - 支持全量配置和模块化分别配置，自动引导安装缺失工具
- 💾 **自动备份** - 配置部署前自动备份现有配置文件

---

## 🛠️ 开发环境配置指南

本仓库提供完整的多语言开发环境配置教程,支持快速搭建编译工具链:

- **📘 [Fedora 开发环境配置](docs/DEV_ENV_FEDORA.md)** - Fedora 43 系统完整工具链安装
- **📗 [Ubuntu 开发环境配置](docs/DEV_ENV_UBUNTU.md)** - Ubuntu 22.04/24.04 系统工具链安装
- **📙 [环境变量配置指南](docs/ENV_VARS.md)** - 跨系统环境变量配置参考
- **📕 [常用命令速查表](docs/COMMON_COMMANDS.md)** - 开发工具常用命令快速查询

**支持的语言与工具**:

- **系统编译**: C/C++ (GCC, Clang), Fortran
- **现代语言**: Rust, Go, Java, Ruby
- **Python 生态**: uv (推荐), poetry, pyenv, pixi
- **科学计算**: Julia, Conda (Mamba, Micromamba)
- **前端开发**: Node.js (NVM 管理)

---

## 📁 目录结构

```text
resource-fedora/
├── 📄 Shell 配置文件
│   ├── .bashrc              # Bash shell 配置
│   ├── .zshrc               # Zsh shell 配置 (主力)
│   ├── fish/                # Fish shell 配置目录
│   │   ├── config.fish      # Fish 主配置文件
│   │   ├── fish_variables   # Fish 环境变量
│   │   ├── completions/     # 自定义补全脚本
│   │   ├── conf.d/          # 配置片段目录
│   │   └── functions/       # 自定义函数目录
│   └── nushell/             # Nushell 配置目录
│       ├── config.nu        # Nushell 主配置文件
│       ├── env.nu           # Nushell 环境配置
│       └── history.txt      # 命令历史
│
├── 🎨 主题与终端
│   ├── tokyo-night.toml     # Starship Tokyo Night 主题配置
│   └── .tmux.conf           # Tmux 终端复用器配置 (详见 [Tmux 配置指南](docs/TMUX.md))
│
├── ✏️ 编辑器配置
│   ├── .vimrc               # Vim 编辑器配置
│   └── nvim/                # Neovim (LazyVim) 配置目录
│       ├── init.lua         # Neovim 入口配置
│       ├── lua/             # Lua 配置模块
│       ├── docs/            # 文档目录
│       └── README.md        # LazyVim 配置说明
│
├── 🔧 开发工具配置
│   ├── .gitconfig           # Git 全局配置 (含 LFS、代理)
│   ├── .condarc             # Conda 包管理器配置
│   ├── ruff/                # Ruff Python linter 配置
│   │   └── ruff-receipt.json
│   └── yazi/                # Yazi 文件管理器配置
│       ├── yazi.toml        # Yazi 主配置文件
│       ├── keymap.toml      # 键位绑定配置
│       ├── theme.toml       # Tokyo Night 主题
│       ├── init.lua         # 插件初始化
│       ├── plugins/         # 插件目录
│       ├── themes/          # 多主题配置
│       ├── README.md        # Yazi 配置说明
│       ├── YAZI_CONFIG_GUIDE.md  # 详细配置指南
│       └── install_yazi_config.sh # 自动安装脚本

├── 📜 脚本与文档
│   ├── setup.sh             # 系统配置部署脚本 (一键/分别配置)
│   ├── Makefile             # Make 任务管理 (推荐使用)
│   ├── GEMINI.md            # AI 助手行为准则配置
│   ├── README.md            # 本文档
│   └── docs/                # 详细文档目录
│       ├── DEV_ENV_FEDORA.md   # Fedora 开发环境配置指南
│       ├── DEV_ENV_UBUNTU.md   # Ubuntu 开发环境配置指南
│       ├── ENV_VARS.md         # 环境变量配置指南
│       ├── COMMON_COMMANDS.md  # 常用命令速查表
│       ├── SHELL_CONFIG_GUIDE.md  # Shell 配置文件完整解析
│       ├── TMUX.md          # Tmux 配置完整指南
│       └── VIM.md           # Vim 配置完整指南
│
└── .gitignore               # Git 忽略规则
```

---

## 🚀 快速开始

### 前置要求

**系统要求**: Fedora 43 Workstation Edition (推荐) 或其他基于 Fedora 43 的系统

#### 必需工具

```bash
# 检查系统版本
cat /etc/fedora-release  # 应显示 Fedora Linux 43

# 安装 Git (必需)
sudo dnf install -y git
```

#### 推荐工具 (setup.sh 会自动检测并引导安装)

**Shell 环境**:

```bash
# Starship - 跨 Shell 提示符 (Bash/Fish/Nushell)
sudo dnf install -y starship

# Oh-My-Zsh - Zsh 框架 (脚本会自动引导安装)
# 无需手动安装，运行 setup.sh --shell zsh 时会提示

# 可选 Shell
sudo dnf install -y zsh fish nushell
```

**编辑器**:

```bash
# Vim
sudo dnf install -y vim

# Neovim (推荐 ≥ 0.9.0)
sudo dnf install -y neovim
```

**终端工具**:

```bash
# Tmux - 终端复用器
sudo dnf install -y tmux

# 现代化 CLI 工具
sudo dnf install -y bat lsd fd-find ripgrep
```

**开发工具**:

```bash
# Ruff - Python Linter/Formatter
sudo dnf install -y ruff  # 或使用 pipx install ruff

# Conda/Mamba - Python 包管理
# Mamba (推荐，比 Conda 更快)
curl -L -O https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash Miniforge3-Linux-x86_64.sh

# 或使用传统 Miniconda
# curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# bash Miniconda3-latest-Linux-x86_64.sh
```

> **💡 提示**: `setup.sh` 脚本会自动检测这些工具是否已安装，如未安装会提供安装引导。

### 克隆仓库

```bash
cd ~/Documents/Github
git clone https://github.com/goblinunde/resource-fedora.git
cd resource-fedora
```

### 使用配置脚本

#### 🎯 使用 Makefile (推荐)

本仓库提供了 **Makefile** 来简化配置管理，使用更加方便：

```bash
# 查看所有可用命令
make help

# 一键部署所有配置
make install

# 部署特定模块
make deploy-zsh
make deploy-nvim

# 检查配置完整性
make check

# 查看项目信息
make info
```

**Makefile 提供的功能**：

- 📦 **部署命令** - 一键或模块化部署配置
- 📚 **文档查看** - 快速查看 README 和文档列表
- 🔧 **维护工具** - 检查、清理、备份、更新
- 🧪 **测试验证** - Shell 语法测试、Shellcheck 检查
- ℹ️  **系统信息** - 项目统计、版本信息

#### 📦 直接使用 setup.sh (传统方式)

```bash
bash setup.sh --all
```

此命令将自动部署：

- Shell 配置 (Bash/Zsh/Fish/Nushell)
- Tmux 配置
- Vim/Neovim 配置
- Git 配置
- Starship 主题

#### 🔧 分别配置 (模块化选择)

```bash
# 仅配置 Shell
bash setup.sh --shell bash   # 或 zsh/fish/nushell

# 仅配置编辑器
bash setup.sh --editor vim   # 或 nvim

# 仅配置 Tmux
bash setup.sh --tmux

# 仅配置 Git
bash setup.sh --git

# 仅配置 Starship
bash setup.sh --starship
```

#### 📋 查看帮助

```bash
bash setup.sh --help
```

---

## 📝 配置文件详解

### Shell 配置

#### Bash (`.bashrc`)

- **用途**: 默认系统 Shell 配置
- **特性**: 基础别名、路径配置
- **适用场景**: 系统脚本、兼容性需求

#### Zsh (`.zshrc`)

- **用途**: 主力 Shell 配置 (13KB+ 高度定制)
- **特性**:
  - Oh-My-Zsh 框架集成
  - Starship 提示符
  - 丰富的插件和主题
  - 智能补全和历史记录
- **适用场景**: 日常开发、交互式使用

#### Fish (`fish/config.fish`)

- **用途**: 现代化友好 Shell
- **特性**:
  - 开箱即用的自动补全
  - 语法高亮
  - Web 配置界面 (`fish_config`)
- **适用场景**: 新手友好、快速配置

#### Nushell (`nushell/config.nu`)

- **用途**: 结构化数据处理 Shell
- **特性**:
  - 数据管道优先设计
  - 内置表格处理
  - 跨平台一致性
- **适用场景**: 数据处理、系统管理

### 编辑器配置

#### Vim (`.vimrc`)

- **大小**: 15KB+
- **特性**:

#### Vim 配置 (`.vimrc`)

- **版本**: 4.0 (Cross-Platform)
- **大小**: 16KB (480 行)
- **主题**: Gruvbox 复古暖色调
- **跨平台**: ✅ Windows, Linux, macOS
- **特性**:
  - **自动系统检测**: 根据 OS 配置路径和剪贴板
  - **自动安装 vim-plug**: 首次运行自动安装
  - **15+ 插件**:
    - CoC.nvim (LSP 智能补全)
    - NERDTree (文件树)
    - FZF (模糊搜索)
    - GitGutter (Git 状态)
    - Airline (状态栏)
  - **11 种文件模板**: Python, Rust, C/C++, CMake, LaTeX, Bash, Markdown, HTML, JSON, Makefile
  - **LSP 支持**: Python (Pyright), Rust (rust-analyzer), C/C++ (clangd), LaTeX (texlab)
  - **Git 集成**: Fugitive + GitGutter
- **适用场景**: 多语言开发、跨平台使用
- **📖 详细文档**: [Vim 配置完整指南](docs/VIM.md) (安装指南、快捷键、多系统流程、FAQ)

#### Neovim (`nvim/`)

- **框架**: LazyVim
- **特性**:
  - LSP 语言服务器支持 (Python/Rust/LaTeX)
  - 多主题自动切换 (12+ 主题)
  - 文件预览功能
  - Git 集成
  - 详细文档 (见 `nvim/README.md`)
- **适用场景**: 现代化开发环境

### Tmux 配置 (`.tmux.conf`)

- **大小**: 8KB+ (增强版)
- **前缀键**: `Ctrl+a` (替代默认 `Ctrl+b`)
- **主题**: Dracula 配色
- **特性**:
  - TPM 插件管理器
  - True Color (24位真彩色) 支持
  - 自定义状态栏 (CPU/内存/时间)
  - 快捷键优化 (Vi 风格)
  - 鼠标支持
  - **10+ 插件集成**:
    - vim-tmux-navigator (Vim/Tmux 无缝导航)
    - tmux-resurrect (会话保存)
    - tmux-continuum (自动恢复)
    - tmux-fzf (模糊搜索)
    - extrakto (文本提取)
    - tmux-yank (剪贴板)
  - **浮动窗口 (Popup)**:
    - Lazygit/Gitui (Git TUI)
    - Htop (系统监控)
    - Ranger (文件管理器)
  - **Shell 快捷创建**: Bash, Zsh, Fish, Nushell
  - **Python 开发**: Python, IPython, Jupyter Lab
  - **会话持久化**: 自动保存/恢复 (每10分钟)
- **适用场景**: 终端复用、远程会话管理、开发环境
- **📖 详细文档**: [Tmux 配置完整指南](docs/TMUX.md) (快捷键速查、插件说明、FAQ)

### Yazi 配置 (`yazi/`)

- **版本**: 26.1.4+
- **主题**: Tokyo Night
- **特性**:
  - **20+ 种文件格式预览**:
    - **文档**: PDF (pdftoppm 图片预览)
    - **数据**: CSV/TSV/Parquet (Rich-CLI/DuckDB 数据分析)
    - **科学计算**: Jupyter Notebook (.ipynb 渲染)
    - **媒体**: 音频元数据、视频信息、字幕预览
    - **文本**: 美化 Markdown/JSON 显示
  - **增强插件系统**:
    - piper.yazi (管道预览)
    - rich-preview.yazi (Rich CLI 美化)
    - nbpreview.yazi (Jupyter 预览)
    - duckdb.yazi (数据分析)
    - exifaudio.yazi / mediainfo.yazi (媒体元数据)
  - **Vim 风格键位** - 完全兼容 Vim 操作习惯
  - **多主题切换** - Tokyo Night, Catppuccin, Gruvbox, Nord
  - **智能依赖检查** - 自动检测并提示安装缺失工具
- **配置文件**:
  - `yazi.toml` - 主配置 (10K+, 含中文注释)
  - `keymap.toml` - 键位绑定
  - `theme.toml` - 主题配置
  - `init.lua` - 插件初始化
- **快速部署**:

  ```bash
  # 使用 Makefile
  make deploy-yazi
  
  # 或直接运行安装脚本
  bash yazi/install_yazi_config.sh
  ```

- **依赖工具**:
  - **基础**: bat, glow, eza, hexyl
  - **高级预览**: poppler-utils, exiftool, ffmpeg, mediainfo, duckdb
  - **Python 工具**: rich-cli, nbpreview (通过 uv 安装)
- **适用场景**: 终端文件管理、快速预览、开发辅助
- **📖 详细文档**:
  - [Yazi 配置说明](yazi/README.md)
  - [配置完整指南](yazi/YAZI_CONFIG_GUIDE.md)
  - [主题切换指南](yazi/THEMES.md)

### Git 配置 (`.gitconfig`)

- **用户**: `SMLYFM <yytcjx@gmail.com>`
- **特性**:
  - Git LFS 支持
  - 代理配置 (SOCKS5)
  - 默认分支: `main`
- **注意**: 部署前需根据个人信息修改

### Starship 主题 (`tokyo-night.toml`)

- **配色**: Tokyo Night
- **适用 Shell**: **Bash, Fish, Nushell**（Zsh 使用 Oh-My-Zsh 框架）
- **显示模块**: 目录、Git、语言版本、时间
- **支持语言**: Node.js、Rust、Go、PHP
- **Nerd Font 要求**: 需要安装 Nerd Font 字体支持图标

  ```bash
  # 推荐字体: JetBrains Mono Nerd Font 或 0xProto Nerd Font
  sudo dnf install -y jetbrains-mono-fonts-all
  # 或从 https://www.nerdfonts.com/ 下载安装
  ```

- **配置位置**: 部署后位于 `~/.config/starship.toml`

### Oh-My-Zsh 配置 (Zsh 专用)

- **框架**: Oh-My-Zsh
- **主题**: 内置于 `.zshrc` 配置
- **插件**: Git、语法高亮、自动建议等
- **安装**: `setup.sh --shell zsh` 会自动检测并引导安装
- **配置文件**: `~/.zshrc`

---

## 🔄 配置备份

脚本会自动备份现有配置到 `~/.config-backup-<timestamp>/`：

```bash
ls ~/.config-backup-*
# 示例: ~/.config-backup-20260122-213000/
```

恢复备份：

```bash
# 恢复单个文件
cp ~/.config-backup-<timestamp>/.zshrc ~/.zshrc

# 恢复所有配置
cp -r ~/.config-backup-<timestamp>/.* ~/
```

---

## 🛠️ 高级定制

### 修改 Starship 主题

```bash
# 编辑主题配置
vim ~/Documents/Github/resource-fedora/tokyo-night.toml

# 重新应用
bash setup.sh --starship
```

### 添加自定义 Fish 函数

```bash
# 在 fish/functions/ 目录创建函数文件
echo "function myfunction
    echo 'Hello, Fish!'
end" > fish/functions/myfunction.fish

# 重新部署
bash setup.sh --shell fish
```

### 扩展 LazyVim 插件

```bash
cd nvim/lua/plugins
# 添加新插件配置 (参考 nvim/README.md)
```

---

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

---

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

---

## 📮 联系方式

**作者**: SMLYFM  
**邮箱**: <yytcjx@gmail.com>  
**GitHub**: [@goblinunde](https://github.com/goblinunde)

---

## 🙏 致谢

- [Starship](https://starship.rs/) - 跨 Shell 提示符
- [LazyVim](https://www.lazyvim.org/) - Neovim 配置框架
- [Tokyo Night](https://github.com/tokyo-night/tokyo-night-vscode-theme) - 配色方案
- [Oh-My-Zsh](https://ohmyz.sh/) - Zsh 配置框架
- Fedora 开源社区

---

**⭐ 如果这个项目对你有帮助，请给个 Star！**
