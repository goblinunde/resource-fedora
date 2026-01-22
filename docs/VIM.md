# 🎨 Vim 配置完整指南

详细说明 `.vimrc` 配置文件的所有功能、快捷键、插件和跨平台使用方法。

---

## 📋 目录

- [配置概览](#配置概览)
- [跨平台支持](#跨平台支持)
- [安装指南](#安装指南)
- [插件列表](#插件列表)
- [文件模板系统](#文件模板系统)
- [快捷键速查](#快捷键速查)
- [CoC.nvim 配置](#cocnvim-配置)
- [多系统配置流程](#多系统配置流程)
- [依赖工具](#依赖工具)
- [常见问题](#常见问题)

---

## 配置概览

**版本**: 4.0 (Cross-Platform)  
**配置大小**: ~16KB (455+ 行)  
**插件数量**: 15+  
**支持语言**: Python, Rust, C/C++, CMake, LaTeX, Bash, HTML, JSON, Markdown

### 核心特性

- ✅ **跨平台支持**: Windows, Linux (Fedora/Ubuntu/Arch), macOS
- ✅ **自动检测系统**: 根据 OS 自动配置路径和剪贴板
- ✅ **自动安装 vim-plug**: 首次运行自动安装插件管理器
- ✅ **LSP 支持**: 通过 CoC.nvim 提供类 VSCode 智能补全
- ✅ **文件模板系统**: 11 种语言/格式的自动模板
- ✅ **Gruvbox 主题**: 复古暖色调配色
- ✅ **Git 集成**: GitGutter + Fugitive
- ✅ **FZF 模糊搜索**: 极速文件搜索
- ✅ **NERDTree 文件树**: 可视化项目结构

---

## 跨平台支持

### 自动检测逻辑

配置会自动检测操作系统并设置相应的路径和选项：

```vim
\" [跨平台检测] 根据操作系统设置配置目录
if has('win32') || has('win64')
    let g:vim_home_path = '~/vimfiles'  \" Windows
    let g:os_type = 'windows'
elseif  has('unix')
    if system('uname -s') =~ 'Darwin'
        let g:vim_home_path = '~/.vim'  \" macOS
        let g:os_type = 'mac'
    else
        let g:vim_home_path = '~/.vim'  \" Linux
        let g:os_type = 'linux'
    endif
endif
```

### 系统特定配置

| 配置项 | Windows | Linux/macOS |
|--------|---------|-------------|
| 配置目录 | `~/vimfiles` | `~/.vim` |
| 插件目录 | `~/vimfiles/plugged` | `~/.vim/plugged` |
| 剪贴板 | `unnamed` (*) | `unnamedplus` (+) |
| 撤销文件 | `~/vimfiles/undodir` | `~/.vim/undodir` |

---

## 安装指南

### 前置要求

#### 必需工具

```bash
# Vim 8.0+ (推荐 8.2+)
vim --version

# curl (下载插件管理器)
curl --version

# Git (插件管理)
git --version
```

#### 可选工具 (增强功能)

| 工具 | 用途 | Fedora 安装 |
|------|------|-------------|
| `ripgrep` | FZF 搜索引擎 | `sudo dnf install -y ripgrep` |
| `fzf` | 模糊搜索 | `sudo dnf install -y fzf` |
| `ctags` | 代码大纲 | `sudo dnf install -y ctags` |
| `Node.js` | CoC.nvim LSP | `sudo dnf install -y nodejs` |
| `lazygit` | Git TUI (可选) | `sudo dnf copr enable atim/lazygit && sudo dnf install -y lazygit` |

### 安装步骤

#### 1. Linux/macOS 安装

```bash
# 1. 部署配置文件
bash setup.sh --editor vim

# 或手动复制
cp .vimrc ~/.vimrc

# 2. 打开 Vim (首次会自动安装 vim-plug)
vim

# 3. 安装所有插件
:PlugInstall

# 4. 等待安装完成后重启 Vim
:qa
vim
```

#### 2. Windows 安装

```powershell
# 1. 安装 Vim (推荐使用 Scoop 或直接下载)
scoop install vim
# 或下载: https://www.vim.org/download.php

# 2. 复制配置文件到用户目录
copy .vimrc %USERPROFILE%\_vimrc

# 3. 打开 Vim (会自动安装 vim-plug)
vim

# 4. 安装插件
:PlugInstall
```

#### 3. 安装 Nerd Font (可选但推荐)

图标显示需要 Nerd Font 字体：

```bash
# Fedora
sudo dnf install -y jetbrains-mono-fonts-all

# 或下载安装
# https://www.nerdfonts.com/font-downloads
# 推荐: JetBrains Mono Nerd Font, 0xProto Nerd Font
```

---

## 插件列表

### UI & 界面美化

| 插件 | 功能 | 命令 |
|------|------|------|
| [gruvbox](https://github.com/gruvbox-community/gruvbox) | 主题配色 | `:colorscheme gruvbox` |
| [vim-airline](https://github.com/vim-airline/vim-airline) | 底部状态栏 | 自动加载 |
| [vim-devicons](https://github.com/ryanoasis/vim-devicons) | 文件图标 | 需要 Nerd Font |
| [vim-startify](https://github.com/mhinz/vim-startify) | 启动界面 | 启动时自动 |
| [vim-gitgutter](https://github.com/airblade/vim-gitgutter) | Git 状态显示 | 自动加载 |
| [indentLine](https://github.com/Yggdroot/indentLine) | 缩进对齐线 | 自动加载 |
| [rainbow](https://github.com/luochen1990/rainbow) | 彩虹括号 | 自动加载 |

### 核心增强工具

| 插件 | 功能 | 快捷键 |
|------|------|--------|
| [NERDTree](https://github.com/preservim/nerdtree) | 文件资源管理器 | `<Leader> + n` |
| [fzf.vim](https://github.com/junegunn/fzf.vim) | 模糊搜索 | `Ctrl+P`, `<Leader>+s` |
| [NERDCommenter](https://github.com/preservim/nerdcommenter) | 快速注释 | `Ctrl+/` |
| [vim-surround](https://github.com/tpope/vim-surround) | 包裹符号处理 | `cs"'`, `ds"`, `ysiw"` |
| [tagbar](https://github.com/preservim/tagbar) | 代码大纲 | `<Leader> + t` |
| [vim-illuminate](https://github.com/RRethy/vim-illuminate) | 高亮当前单词 | 自动 |
| [auto-pairs](https://github.com/jiangmiao/auto-pairs) | 自动补全括号 | 自动 |

### LSP 与语言支持

| 插件 | 功能 | 语言 |
|------|------|------|
| [coc.nvim](https://github.com/neoclide/coc.nvim) | LSP 客户端 | 全部 |
| [vimtex](https://github.com/lervag/vimtex) | LaTeX 支持 | LaTeX |
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | Git 集成 | - |

### CoC Extensions (自动安装)

- `coc-json` - JSON 支持
- `coc-vimlsp` - VimScript LSP
- `coc-sh` - Bash 脚本支持
- `coc-snippets` - 代码片段
- `coc-pyright` - Python LSP
- `coc-rust-analyzer` - Rust LSP
- `coc-texlab` - LaTeX LSP
- `coc-clangd` - C/C++ LSP
- `coc-cmake` - CMake 支持

---

## 文件模板系统

### 支持的模板

| 文件类型 | 触发器 | 包含内容 |
|----------|--------|----------|
| Python | `*.py` | Shebang, UTF-8, Docstring, main() |
| Rust | `*.rs` | Doc comment, main() |
| C | `*.c`, `*.h` | Header comment, main() |
| C++ | `*.cpp`, `*.hpp` | Header comment, iostream, main() |
| CMake | `CMakeLists.txt` | Project setup, add_executable |
| LaTeX | `*.tex` | Document class, begin/end |
| Bash | `*.sh` | Shebang, strict mode, main() |
| Markdown | `*.md` | Title, Author, Sections |
| HTML | `*.html` | DOCTYPE, meta tags, body |
| JSON | `*.json` | Basic structure |
| Makefile | `Makefile` | Phony targets, build/clean |

### 模板变量

模板中的占位符会自动替换：

| 占位符 | 替换为 | 示例 |
|--------|--------|------|
| `__AUTHOR__` | `cjx` | (可修改 line 239) |
| `__EMAIL__` | `sudocjx@gmail.com` | (可修改 line 240) |
| `__DATE__` | 当前时间 | `2026-01-22 22:30:00` |
| `__CURSOR__` | 光标位置 | (自动定位) |

### 自定义模板

修改 `.vimrc` line 239-240 自定义作者信息：

```vim
exe 'silent! %s/__AUTHOR__/你的名字/ge'
exe 'silent! %s/__EMAIL__/your@email.com/ge'
```

添加新模板示例（Go 语言）：

```vim
\" --- Go 模板 ---
autocmd BufNewFile *.go let b:autocmd_template = [
            \\ '// @author: __AUTHOR__',
            \\ '// @created: __DATE__',
            \\ '',
            \\ 'package main',
            \\ '',
            \\ 'import \"fmt\"',
            \\ '',
            \\ 'func main() {',
            \\ '    fmt.Println(\"Hello, Go!\")',
            \\ '    __CURSOR__',
            \\ '}',
            \\ ]
autocmd BufNewFile *.go call <SID>InsertTemplate()
```

---

## 快捷键速查

> **Leader 键**: `<Space>` (空格)

### 基础操作

| 快捷键 | 功能 | 模式 |
|--------|------|------|
| `<Leader> + nh` | 取消搜索高亮 | Normal |
| `<Leader> + r` | 重新加载配置 | Normal |
| `:PlugInstall` | 安装插件 | Command |
| `:PlugUpdate` | 更新插件 | Command |
| `:PlugClean` | 清理插件 | Command |

### 窗口管理

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+h/j/k/l` | 切换到 左/下/上/右 窗口 |
| `:sp` | 水平分屏 |
| `:vsp` | 垂直分屏 |
| `Ctrl+w +/-` | 调整窗口高度 |
| `Ctrl+w </>`  | 调整窗口宽度 |

### 文件操作

| 快捷键 | 功能 | 插件 |
|--------|------|------|
| `<Leader> + n` | 开关文件树 | NERDTree |
| `Ctrl+P` | 搜索文件名 | FZF |
| `<Leader> + s` | 搜索文件内容 | FZF + Ripgrep |
| `<Leader> + t` | 开关代码大纲 | Tagbar |

### 编辑增强

| 快捷键 | 功能 | 插件 |
|--------|------|------|
| `Ctrl+/` | 注释/取消注释 | NERDCommenter |
| `cs"'` | 将 `"` 改为 `'` | vim-surround |
| `ds"` | 删除包裹的 `"` | vim-surround |
| `ysiw"` | 为当前单词添加 `"` | vim-surround |

### CoC.nvim (LSP)

| 快捷键 | 功能 |
|--------|------|
| `Tab` | 选择下一个补全项 |
| `Shift+Tab` | 选择上一个补全项 |
| `Enter` | 确认补全 |
| `gd` | 跳转到定义 |
| `gy` | 跳转到类型定义 |
| `gi` | 跳转到实现 |
| `gr` | 查看引用 |
| `K` | 显示文档悬浮窗 |
| `<Leader> + rn` | 重命名变量 |
| `<Leader> + f` | 格式化文件 |
| `<Leader> + a` | 快速修复 (Quick Fix) |

### Git 操作

| 快捷键 | 功能 | 插件 |
|--------|------|------|
| `:G` | 打开 Git 状态 | Fugitive |
| `:Gblame` | 查看 Git Blame | Fugitive |
| `:Gdiff` | 查看 Diff | Fugitive |

---

## CoC.nvim 配置

### LSP 服务器

CoC.nvim 会自动安装以下 LSP 服务器：

| 语言 | LSP Server | CoC 扩展 |
|------|------------|----------|
| Python | Pyright | `coc-pyright` |
| Rust | rust-analyzer | `coc-rust-analyzer` |
| C/C++ | clangd | `coc-clangd` |
| LaTeX | texlab | `coc-texlab` |
| CMake | cmake-language-server | `coc-cmake` |
| Bash | bash-language-server | `coc-sh` |
| JSON | vscode-json-languageserver | `coc-json` |
| Vim | vim-language-server | `coc-vimlsp` |

### CoC 命令

```vim
:CocInstall <extension>  \" 安装扩展
:CocList extensions      \" 查看已安装扩展
:CocUpdate               \" 更新所有扩展
:CocConfig               \" 编辑 CoC 配置
:CocCommand              \" 执行 CoC 命令
```

---

## 多系统配置流程

### Fedora 43

```bash
# 1. 安装依赖
sudo dnf install -y vim nodejs ripgrep fzf ctags jetbrains-mono-fonts-all

# 2. 部署配置
bash setup.sh --editor vim

# 3. 打开 Vim 并安装插件
vim
:PlugInstall

# 4. 等待 CoC.nvim 安装 LSP 服务器
# (首次打开 .py/.rs/.c 文件时自动安装)
```

### Ubuntu/Debian

```bash
# 1. 安装依赖
sudo apt-get update
sudo apt-get install -y vim nodejs npm ripgrep fzf exuberant-ctags

# 2. 安装 Nerd Font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.local/share/fonts/
fc-cache -fv

# 3. 部署配置
cp .vimrc ~/.vimrc

# 4. 打开 Vim
vim
:PlugInstall
```

### Arch Linux

```bash
# 1. 安装依赖
sudo pacman -S vim nodejs ripgrep fzf ctags ttf-jetbrains-mono-nerd

# 2. 部署配置
cp .vimrc ~/.vimrc

# 3. 打开 Vim
vim
:PlugInstall
```

### macOS

```bash
# 1. 安装 Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. 安装依赖
brew install vim node ripgrep fzf ctags
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font

# 3. 部署配置
cp .vimrc ~/.vimrc

# 4. 打开 Vim
vim
:PlugInstall
```

### Windows

```powershell
# 1. 安装 Scoop
irm get.scoop.sh | iex

# 2. 安装 Vim 和 依赖
scoop install vim nodejs ripgrep fzf universal-ctags

# 3. 安装 Nerd Font
scoop bucket add nerd-fonts
scoop install JetBrainsMono-NF

# 4. 部署配置
copy .vimrc %USERPROFILE%\_vimrc

# 5. 打开 Vim
vim
:PlugInstall
```

---

## 依赖工具

### 必需工具 (核心功能)

| 工具 | 版本要求 | 用途 |
|------|----------|------|
| Vim | ≥ 8.0 | 编辑器本体 |
| curl | 任意 | 下载 vim-plug |
| git | ≥ 2.0 | 插件管理 |
| Node.js | ≥ 14.0 | CoC.nvim LSP |

### 推荐工具 (增强功能)

| 工具 | 用途 | 功能 |
|------|------|------|
| ripgrep | 文件内容搜索 | FZF 搜索引擎 |
| fzf | 模糊搜索 | 文件/内容查找 |
| ctags | 代码索引 | Tagbar 大纲 |
| lazygit | Git TUI | Git 可视化操作 |

### 字体要求

**Nerd Font** (用于显示图标)：

- JetBrains Mono Nerd Font ✅ (推荐)
- 0xProto Nerd Font ✅
- FiraCode Nerd Font ✅
- Hack Nerd Font ✅

---

## 常见问题

### Q: 首次启动报错 "E492: Not an editor command: PlugInstall"？

**A**: vim-plug 尚未安装完成，重新打开 Vim：

```bash
rm -rf ~/.vim/autoload/plug.vim  # 删除不完整的文件
vim  # 重新打开，会自动下载
```

### Q: CoC.nvim 提示 "Node.js not found"？

**A**: 安装 Node.js：

```bash
# Fedora
sudo dnf install -y nodejs

# Ubuntu
sudo apt-get install -y nodejs npm

# macOS
brew install node
```

### Q: 图标显示为乱码？

**A**: 需要安装 Nerd Font 字体并在终端中设置。

**验证字体**:

```bash
echo -e "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"
# 应显示: ▶ ±  ➦ ✘ ⚡ ⚙
```

### Q: Ripgrep 搜索不工作？

**A**: 确保 ripgrep 已安装：

```bash
# 测试
rg --version

# Fedora 安装
sudo dnf install -y ripgrep
```

### Q: 如何更新所有插件？

**A**: 在 Vim 中执行：

```vim
:PlugUpdate
:CocUpdate
```

### Q: 如何删除不需要的插件？

**A**:

1. 在 `.vimrc` 中删除或注释插件行
2. 重启 Vim
3. 执行 `:PlugClean`

### Q: Windows 下剪贴板不工作？

**A**: 确保 Vim 编译时包含 clipboard 支持：

```powershell
vim --version | findstr clipboard
# 应显示 +clipboard
```

如果显示 `-clipboard`，需要安装完整版 Vim。

### Q: 如何禁用文件模板？

**A**: 注释掉 `.vimrc` 中的 `augroup MyFileTemplates` 部分 (line 250-447)。

### Q: 性能优化建议？

**A**:

1. 禁用不需要的插件（注释 `Plug` 行）
2. 减少 LSP 扩展数量
3. 关闭 GitGutter: `let g:gitgutter_enabled = 0`
4. 禁用彩虹括号: `let g:rainbow_active = 0`

---

## 参考资源

- [Vim 官方文档](https://www.vim.org/docs.php)
- [vim-plug GitHub](https://github.com/junegunn/vim-plug)
- [CoC.nvim Wiki](https://github.com/neoclide/coc.nvim/wiki)
- [Gruvbox 主题](https://github.com/gruvbox-community/gruvbox)
- [我的其他配置](../README.md)

---

**最后更新**: 2026-01-22  
**Vim 版本**: 8.0+  
**作者**: SMLYFM <yytcjx@gmail.com>
