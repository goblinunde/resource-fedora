# 💤 LazyVim Configuration | 山水·数理 🌊

> 基于 LazyVim 的 Neovim 配置，支持 Python、Rust、LaTeX 开发，采用深青色学术风格主题  
> LazyVim-based Neovim configuration for Python, Rust, and LaTeX development with deep teal academic theme

![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)
![Neovim](https://img.shields.io/badge/Neovim-0.9+-green.svg)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)

---

## ✨ 特性 (Features)

### 🎨 UI 美化 (UI Enhancement)

- **深青色主题**: 基于 `resource.css` 的山水·数理配色方案 (Deep teal academic color scheme)
- **0xProto 字体**: 极客代码字体，支持连字 (Geek code font with ligatures)
- **现代化 UI**: Lualine、Bufferline、Noice 等插件美化 (Modern UI with Lualine, Bufferline, Noice)
- **优雅通知**: nvim-notify 美化通知系统 (Elegant notification system)

### 🐍 Python 开发 (Python Development)

- **LSP**: basedpyright (高性能类型检查) | basedpyright (high-performance type checker)
- **Linter/Formatter**: ruff (超快的 Python 工具) | ruff (ultra-fast Python tools)
- **调试器**: debugpy (完整调试支持) | debugpy (full debugging support)
- **虚拟环境**: 自动检测 venv/.venv | Auto-detect virtual environments
- **遵循规则**: AMD ROCm 环境，uv 包管理器 | Follows AMD ROCm, uv package manager rules

### 🦀 Rust 开发 (Rust Development)

- **LSP**: rust-analyzer (官方 Rust 语言服务器) | rust-analyzer (official Rust language server)
- **工具链**: clippy, rustfmt 集成 | clippy, rustfmt integration
- **依赖管理**: crates.nvim (Cargo.toml 智能补全) | crates.nvim (Cargo.toml smart completion)
- **调试器**: codelldb (LLDB 调试器) | codelldb (LLDB debugger)
- **强调**: 内存安全和 Result<T,E> 错误处理 | Emphasizes memory safety and Result<T,E> error handling

### 🔨 C/C++ 开发 (C/C++ Development)

- **构建工具**: Quick-c (一键编译、运行、调试) | Quick-c (one-click build, run, debug)
- **Make 集成**: 自动发现 Makefile、目标选择器 | Auto-detect Makefile, target selector
- **CMake 集成**: cmake 配置与构建、目标列表 | cmake configure/build, target list
- **调试器**: nvim-dap + codelldb (LLDB 调试器) | nvim-dap + codelldb (LLDB debugger)
- **多文件支持**: Telescope 多选源文件、异步构建 | Telescope multi-select sources, async build
- **跨平台**: 自动检测编译器 (gcc/clang/cl) | Auto-detect compilers (gcc/clang/cl)

### 🌿 Git 工作流 (Git Workflow)

- **LazyGit**: 现代化 TUI Git 客户端 | Modern TUI Git client
- **Gitsigns**: Git 变更标记、暂存、预览 | Git change markers, staging, preview
- **Fugitive**: 经典 Git 命令集成 | Classic Git command integration
- **Diffview**: 强大的 diff 和历史可视化 | Powerful diff and history visualization
- **快捷操作**: 一键暂存、blame、导航变更 | Quick staging, blame, navigate changes

### 📝 LaTeX 学术写作 (LaTeX Academic Writing)

- **LSP**: texlab (强大的 LaTeX 语言服务器) | texlab (powerful LaTeX language server)
- **编译**: latexmk 自动编译 | latexmk auto-compilation
- **预览**: Zathura PDF 实时预览 | Zathura PDF live preview
- **片段**: Physics、PDE 数学公式片段 | Physics, PDE mathematical formula snippets
- **包支持**: physics, siunitx, cleveref | Package support for physics, siunitx, cleveref

### 📄 Markdown 编辑与预览 (Markdown Editing & Preview)

- **内置渲染**: render-markdown.nvim (Neovim 内即时渲染) | render-markdown.nvim (instant rendering in Neovim)
- **浏览器预览**: markdown-preview.nvim (实时预览) | markdown-preview.nvim (live preview)
- **终端预览**: Glow (轻量级预览) | Glow (lightweight preview)
- **表格编辑**: vim-table-mode (自动格式化) | vim-table-mode (auto-formatting)
- **目录生成**: vim-markdown-toc (自动 TOC) | vim-markdown-toc (auto TOC)
- **智能列表**: bullets.vim (复选框管理) | bullets.vim (checkbox management)
- **智能软换行**: 自动在单词边界换行，保持缩进 | Smart soft wrap at word boundaries with indent preservation

### 📄 PDF 查看 (PDF Viewing)

- **Neovim 内查看**: PDFview.nvim (在 Neovim 内查看 PDF 文本) | PDFview.nvim (view PDF text in Neovim)
- **键盘导航**: 快捷键翻页 | Keyboard navigation for pages
- **自动打开**: 自动识别 PDF 文件 | Auto-open PDF files
- **文本提取**: pdftotext 提取 PDF 内容 | Extract PDF content with pdftotext

### 📁 文件管理 (File Management)

- **现代文件管理器**: Yazi.nvim (在 Neovim 内使用 Yazi 终端文件管理器) | Yazi.nvim (use Yazi terminal file manager in Neovim)
- **浮动窗口**: 美观的浮动窗口界面 | Beautiful floating window interface
- **快捷操作**: 分割、标签、quickfix 等快捷操作 | Quick operations like splits, tabs, quickfix
- **集成搜索**: 集成 Telescope 和 grug-far | Integrated with Telescope and grug-far

### 🛠️ 其他功能 (Other Features)

- **文件预览**: PDF、图片、视频等格式一键预览 | File preview for PDF, images, videos
- **Tree-sitter**: 增强语法高亮和代码理解 | Enhanced syntax highlighting
- **自动格式化**: 保存时自动格式化代码 | Format on save
- **DAP调试器**: 统一的调试界面 | Unified debugging interface
- **双语注释**: 所有配置文件中英文双语注释 | Bilingual comments in all config files

---

## 📋 系统依赖 (System Requirements)

### 必需 (Required)

- **Neovim**: >= 0.9.0
- **Git**: >= 2.19.0
- **字体**: [0xProto Nerd Font Mono](https://github.com/ryanoasis/nerd-fonts)

### Python 开发 (Python Development)

```bash
# Fedora 43
sudo dnf install python3 python3-pip
pip install uv
uv tool install ruff
uv tool install basedpyright
```

### Rust 开发 (Rust Development)

```bash
# 安装 Rust 工具链 (Install Rust toolchain)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rust-analyzer clippy rustfmt
```

### C/C++ 开发 (C/C++ Development)

```bash
# Fedora 43
sudo dnf install gcc g++ clang make cmake gdb

# 可选：安装 LLDB 调试器 (Optional: LLDB debugger)
sudo dnf install lldb
```

### Git 工具 (Git Tools)

```bash
# Fedora 43
sudo dnf install git lazygit

# 验证安装 (Verify installation)
lazygit --version
```

### LaTeX 写作 (LaTeX Writing)

```bash
# Fedora 43
sudo dnf install texlive-scheme-full latexmk zathura zathura-pdf-mupdf
```

### 通用工具 (General Tools)

```bash
# Fedora 43
sudo dnf install ripgrep fd-find poppler-utils yazi  # yazi 是现代终端文件管理器
```

---

## 🚀 安装 (Installation)

### 1. 备份现有配置 (Backup existing config)

```bash
mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)
mv ~/.local/share/nvim ~/.local/share/nvim.backup.$(date +%Y%m%d_%H%M%S)
```

### 2. 克隆配置 (Clone configuration)

```bash
git clone https://github.com/goblinunde/lazyvim-linux.git ~/.config/nvim
cd ~/.config/nvim
```

### 3. 启动 Neovim (Start Neovim)

```bash
nvim
```

首次启动时，LazyVim 会自动安装所有插件和 LSP servers。请耐心等待。  
On first launch, LazyVim will automatically install all plugins and LSP servers. Please wait.

---

## ⚙️ 配置结构 (Configuration Structure)

```
~/.config/nvim/
├── init.lua                    # 入口文件 (Entry point)
├── lua/
│   ├── config/                 # 核心配置 (Core configuration)
│   │   ├── lazy.lua            # Lazy.nvim 配置
│   │   ├── options.lua         # Neovim 选项
│   │   ├── keymaps.lua         # 快捷键映射
│   │   └── autocmds.lua        # 自动命令
│   ├── plugins/                # 插件配置 (Plugin configurations)
│   │   ├── colorscheme.lua     # 主题配置
│   │   ├── ui.lua              # UI 增强
│   │   ├── python.lua          # Python 开发
│   │   ├── rust.lua            # Rust 开发
│   │   ├── quickc.lua          # C/C++ 开发
│   │   ├── latex.lua           # LaTeX 写作
│   │   ├── markdown.lua        # Markdown 编辑
│   │   ├── pdfview.lua         # PDF 查看
│   │   ├── yazi.lua            # Yazi 文件管理
│   │   ├── git.lua             # Git 工作流
│   │   ├── treesitter.lua      # Tree-sitter
│   │   ├── formatting.lua      # 格式化
│   │   └── dap.lua             # 调试器
│   └── utils/                  # 工具模块 (Utility modules)
│       └── colors.lua          # 颜色工具
├── resource.css                # UI 设计参考
└── stylua.toml                 # Lua 格式化配置
```

---

## ⌨️ 常用快捷键 (Common Keybindings)

### 通用 (General)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<Space>` | Leader 键 | Leader key |
| `<C-s>` | 保存文件 | Save file |
| `<leader>qq` | 退出所有 | Quit all |
| `<leader>cf` | 格式化代码 | Format code |

### Python

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>pv` | 选择虚拟环境 | Select VirtualEnv |
| `<leader>pt` | 调试测试方法 | Debug test method |
| `<leader>pc` | 调试测试类 | Debug test class |

### Rust

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>rr` | Rust 可运行项 | Rust runnables |
| `<leader>rd` | Rust 可调试项 | Rust debuggables |
| `<leader>cR` | Rust 代码操作 | Rust code action |

### 🔨 C/C++ 开发 (C/C++ Development)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>cqb` | 构建当前文件 | Build current file |
| `<leader>cqr` | 运行最近构建 | Run last build |
| `<leader>cqR` | 构建并运行 | Build & Run |
| `<leader>cqD` | 调试程序 | Debug with DAP |
| `<leader>cqM` | Make 目标选择 | Make targets (Telescope) |
| `<leader>cqC` | CMake 目标选择 | CMake targets (Telescope) |
| `<leader>cqc` | CMake 配置 | CMake configure |
| `<leader>cqB` | CMake 构建 | CMake build |

### 🌿 Git 工作流 (Git Workflow)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>gg` | LazyGit | Open LazyGit |
| `<leader>gs` | Git Status | Git Status (Fugitive) |
| `<leader>gd` | Git Diff | Git Diff |
| `<leader>gb` | Git Blame | Git Blame |
| `<leader>gl` | Git Log | Git Log |
| `<leader>hs` | 暂存 Hunk | Stage Hunk |
| `<leader>hr` | 重置 Hunk | Reset Hunk |
| `]h` | 下一个变更 | Next Hunk |
| `[h` | 上一个变更 | Prev Hunk |

### LaTeX

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>ll` | 编译 LaTeX | Compile LaTeX |
| `<leader>lv` | 查看 PDF | View PDF |
| `<leader>lc` | 清理辅助文件 | Clean auxiliary files |
| `<leader>lt` | 打开目录 | Open TOC |

### 📄 Markdown

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>mr` | Neovim 内渲染 | Render in Neovim |
| `<leader>mp` | 浏览器预览 | Browser preview |
| `<leader>mg` | 终端预览 (Glow) | Terminal preview (Glow) |
| `<leader>mt` | 表格模式 | Table mode |
| `<leader>mT` | 生成目录 | Generate TOC |

### 📖 PDF 查看 (PDF Viewing)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>po` | 打开 PDF | Open PDF with Telescope |
| `<leader>pn` | 下一页 | Next page |
| `<leader>pp` | 上一页 | Previous page |
| `<leader>jj` | 下一页 (快速) | Next page (fast) |
| `<leader>kk` | 上一页 (快速) | Previous page (fast) |

### 🎨 主题切换 (Theme Switching)

**命令模式切换** (Command mode):

```vim
:colorscheme catppuccin     # Catppuccin 主题
:colorscheme tokyonight     # Tokyonight 主题
:Catppuccin mocha           # 深夜风格
:Catppuccin frappe          # 柔和深色
:Catppuccin macchiato       # 中深色
:Catppuccin latte           # 浅色风格
:set background=dark        # 深色模式
:set background=light       # 浅色模式
```

**永久修改**: 编辑 `lua/plugins/colorscheme.lua` 文件

### 🔍 查找与导航 (Search & Navigation)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>ff` | 查找文件 | Find files |
| `<leader>fg` | 全局搜索 | Global search (grep) |
| `<leader>fb` | 查找缓冲区 | Find buffers |
| `<leader>fr` | 最近文件 | Recent files |
| `<leader>ss` | 符号搜索 | Symbol search |
| `<leader>/` | 当前缓冲区搜索 | Search in buffer |
| `gd` | 转到定义 | Go to definition |
| `gr` | 查找引用 | Find references |
| `<C-o>` | 跳转历史向后 | Jump backward |
| `<C-i>` | 跳转历史向前 | Jump forward |

### 📂 文件操作 (File Operations)  

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>e` | 文件树 | File explorer |
| `<leader>fe` | 浮动文件树 | Float file explorer |
| `<C-s>` | 保存文件 | Save file |
| `<leader>fs` | 另存为 | Save as |
| `<leader>fn` | 新文件 | New file |
| `<leader>bd` | 删除缓冲区 | Delete buffer |
| `<leader>bD` | 强制删除缓冲区 | Force delete buffer |
| `<S-h>` | 上一个缓冲区 | Previous buffer |
| `<S-l>` | 下一个缓冲区 | Next buffer |

### 📁 Yazi 文件管理器 (Yazi File Manager)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>fy` | 打开 Yazi | Open Yazi at current file |
| `<leader>fY` | 在工作目录打开 | Open Yazi in working directory |
| `<leader>yr` | 恢复会话 | Resume last Yazi session |

**Yazi 内部快捷键** (Inside Yazi):

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<F1>` | 显示帮助 | Show help |
| `<C-v>` | 垂直分割打开 | Open in vertical split |
| `<C-x>` | 水平分割打开 | Open in horizontal split |
| `<C-t>` | 新标签打开 | Open in new tab |
| `<C-s>` | Telescope 搜索 | Grep in directory |
| `<C-q>` | 发送到 quickfix | Send to quickfix list |

### 👁️ 文件预览 (File Preview)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>fp` | 预览文件 | Preview file |
| `<leader>fo` | 打开文件夹 | Open in file manager |
| `<leader>fx` | 系统默认打开 | Open with system default |
| `<leader>fpe` | Evince 打开 | Open with Evince |
| `<leader>fpv` | MPV 打开 | Open with MPV |
| `<leader>uw` | 切换软换行 | Toggle soft wrap |

### 💻 代码编辑 (Code Editing)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>ca` | 代码操作 | Code action |
| `<leader>cr` | 重命名 | Rename symbol |
| `<leader>cf` | 格式化 | Format code |
| `K` | 悬浮文档 | Hover documentation |
| `gD` | 转到声明 | Go to declaration |
| `gi` | 转到实现 | Go to implementation |
| `<C-k>` | 签名帮助 | Signature help |
| `]d` | 下一个诊断 | Next diagnostic |
| `[d` | 上一个诊断 | Previous diagnostic |
| `<leader>cd` | 行诊断 | Line diagnostics |
| `gcc` | 注释/取消注释 | Toggle comment |
| `gc` | 注释（Visual 模式） | Comment (Visual) |

### 🪟 窗口管理 (Window Management)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<C-h>` | 移到左窗口 | Go to left window |
| `<C-j>` | 移到下窗口 | Go to lower window |
| `<C-k>` | 移到上窗口 | Go to upper window |
| `<C-l>` | 移到右窗口 | Go to right window |
| `<leader>ww` | 切换窗口 | Switch window |
| `<leader>wd` | 删除窗口 | Delete window |
| `<leader>w-` | 水平分割 | Horizontal split |
| `<leader>w|` | 垂直分割 | Vertical split |
| `<C-Up>` | 增加高度 | Increase height |
| `<C-Down>` | 减少高度 | Decrease height |
| `<C-Left>` | 减少宽度 | Decrease width |
| `<C-Right>` | 增加宽度 | Increase width |

### 🐛 调试 (Debugging)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<leader>db` | 切换断点 | Toggle breakpoint |
| `<leader>dc` | 继续执行 | Continue |
| `<leader>di` | 步入 | Step into |
| `<leader>do` | 步过 | Step over |
| `<leader>du` | 切换 DAP UI | Toggle DAP UI |

---

## 🎨 主题配色 (Color Scheme)

本配置采用深青色学术风格，源自 `resource.css` 的山水·数理设计：  
This configuration uses a deep teal academic color scheme from resource.css design:

- **Primary**: `#2F545D` (深青色 | Deep Teal)
- **Dark Background**: `#1A3038` (深青黑 | Deep Teal-Black)  
- **Light Background**: `#E6EDEF` (月白青 | Moon-White Teal)
- **Foreground**: `#E6EDEF` / `#2F545D` (根据主题 | Theme-dependent)

---

## 🔧 常用命令 (Common Commands)

### 插件管理 (Plugin Management)

| 命令 | 功能 | Description |
|------|------|-------------|
| `:Lazy` | 打开插件管理器 | Open plugin manager |
| `:Lazy sync` | 同步所有插件 | Sync all plugins |
| `:Lazy update` | 更新插件 | Update plugins |
| `:Lazy clean` | 清理未使用的插件 | Clean unused plugins |
| `:Lazy restore` | 恢复插件快照 | Restore plugin snapshot |
| `:Lazy profile` | 查看插件加载性能 | View plugin loading performance |

### LSP 命令 (LSP Commands)

| 命令 | 功能 | Description |
|------|------|-------------|
| `:LspInfo` | 查看 LSP 信息 | View LSP information |
| `:LspRestart` | 重启 LSP 服务器 | Restart LSP server |
| `:Mason` | 打开 Mason 管理器 | Open Mason manager |
| `:MasonUpdate` | 更新 Mason 工具 | Update Mason tools |
| `:MasonInstall <tool>` | 安装工具 | Install tool |
| `:MasonUninstall <tool>` | 卸载工具 | Uninstall tool |

### 格式化与诊断 (Formatting & Diagnostics)

| 命令 | 功能 | Description |
|------|------|-------------|
| `:Format` | 格式化代码 | Format code |
| `:FormatToggle` | 切换自动格式化 | Toggle auto-format |
| `:Trouble` | 打开问题列表 | Open trouble list (if installed) |
| `:checkhealth` | 检查健康状态 | Check health status |

### Git 命令 (Git Commands - 需要 lazygit)

| 命令 | 功能 | Description |
|------|------|-------------|
| `<leader>gg` | 打开 LazyGit | Open LazyGit |
| `<leader>gb` | Git blame | Git blame |
| `<leader>gf` | Git 浮动终端 | Git float terminal |

### 终端 (Terminal)

| 快捷键 | 功能 | Description |
|--------|------|-------------|
| `<C-/>` | 切换浮动终端 | Toggle float terminal |
| `<leader>ft` | 浮动终端 | Float terminal |
| `<leader>fT` | 全屏终端 | Fullscreen terminal |

---

## ⚙️ 自定义配置 (Custom Configuration)

### 修改主题风格

编辑 `lua/plugins/colorscheme.lua`:

```lua
-- 修改 Catppuccin 风格
{
  "catppuccin/nvim",
  opts = {
    flavour = "mocha",  -- 可选: mocha, frappe, macchiato, latte
    transparent_background = false,  -- true 启用透明背景
    -- 自定义颜色
    custom_highlights = function(colors)
      -- 在这里添加自定义高亮
    end,
  },
}
```

### 修改 LSP 配置

编辑对应语言的插件文件（`lua/plugins/python.lua`、`lua/plugins/rust.lua` 等）：

```lua
-- 修改 Python LSP 设置
{
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      basedpyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "standard",  -- off, basic, standard, strict
              autoSearchPaths = true,
            },
          },
        },
      },
    },
  },
}
```

### 添加自定义快捷键

编辑 `lua/config/keymaps.lua`:

```lua
local map = vim.keymap.set

-- 示例：添加快速保存并退出
map("n", "<leader>wq", ":wq<cr>", { desc = "Save and quit" })

-- 示例：快速切换行号显示
map("n", "<leader>un", ":set number!<cr>", { desc = "Toggle line numbers" })
```

### 修改 Neovim 选项

编辑 `lua/config/options.lua`:

```lua
local opt = vim.opt

-- 示例：修改缩进设置
opt.tabstop = 4          -- Tab 宽度
opt.shiftwidth = 4       -- 缩进宽度
opt.expandtab = true     -- 使用空格代替 Tab

-- 示例：显示设置
opt.number = true        -- 显示行号
opt.relativenumber = true -- 显示相对行号
opt.wrap = false         -- 禁用自动换行
opt.colorcolumn = "80"   -- 显示列标尺
```

---

## 📊 故障排查 (Troubleshooting)

### Markdown Preview 无法工作

```bash
# 进入 Neovim 配置目录
cd ~/.local/share/nvim/lazy/markdown-preview.nvim
# 手动安装依赖
cd app && npx --yes yarn install
```

或在 Neovim 中：

```vim
:Lazy build markdown-preview.nvim
```

### LSP 无法启动

1. 检查 LSP 状态：`:LspInfo`
2. 检查 Mason 工具：是否已安装：`:Mason`
3. 重启 LSP：`:LspRestart`
4. 检查健康状态：`:checkhealth lspconfig`

### 插件加载慢

```vim
:Lazy profile  # 查看插件加载时间
```

优化建议：

- 使用 `lazy = true` 延迟加载不常用插件
- 使用 `event`, `cmd`, `ft` 等条件加载
- 减少 `ensure_installed` 中的语言解析器

### Python 虚拟环境未检测

```bash
# 在项目根目录创建虚拟环境
uv venv
source .venv/bin/activate

# 或使用 conda
conda create -n myenv python=3.11
conda activate myenv
```

然后在 Neovim 中：`<leader>pv` 选择虚拟环境

---

## 🧪 测试 (Testing)

### 验证 LSP 工作状态 (Verify LSP status)

```vim
:LspInfo
```

### 检查健康状态 (Check health)

```vim
:checkhealth
```

### 查看插件状态 (View plugin status)

```vim
:Lazy
```

---

## 📚 参考资源 (References)

- [LazyVim 官方文档](https://lazyvim.github.io/)
- [Neovim 官方文档](https://neovim.io/doc/)
- [0xProto Font](https://github.com/0xType/0xProto)
- [Resource.css 设计理念](./resource.css)

---

## 📝 开发记录 (Development Log)

所有修改都通过 Git 进行版本管理，遵循 Conventional Commits 规范：  
All changes are version-controlled via Git following Conventional Commits:

```bash
git log --oneline
```

---

## 📄 许可证 (License)

Apache License 2.0 - 详见 [LICENSE](LICENSE) 文件  
Apache License 2.0 - See [LICENSE](LICENSE) file for details

---

## 🤝 贡献 (Contributing)

欢迎提交 Issues 和 Pull Requests！  
Issues and Pull Requests are welcome!

---

**Made with ❤️ for AMD Fedora 43 | 为专业开发者打造**
