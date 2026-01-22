# 📝 LaTeX 编译脚本完整指南

> **脚本版本**: v5.2 (简洁版) + v6.0 (增强版)  
> **作者**: yyt  
> **仓库**: [goblinunde/latexcompile](https://github.com/goblinunde/latexcompile)  
> **更新日期**: 2026-01-22

本指南详细介绍两个专业级 LaTeX 编译脚本的功能、配置和使用方法。

---

## 📋 目录

- [脚本概览](#脚本概览)
- [功能对比](#功能对比)
- [安装与配置](#安装与配置)
- [详细功能说明](#详细功能说明)
- [配置文件详解](#配置文件详解)
- [使用示例](#使用示例)
- [常见问题](#常见问题)

---

## 脚本概览

### 🎯 latexcompile-simple.sh (简洁版 v5.2)

**定位**: 专注核心编译功能的轻量级脚本  
**行数**: 555 行  
**适用场景**: 日常 LaTeX 编译、批量项目处理

**核心功能**:

- ✅ Latexmk 自动化编译
- ✅ 多目标批量编译 (.latexcfg 配置)
- ✅ 跨平台支持 (macOS/Linux/WSL/Windows)
- ✅ 交互式菜单和命令行模式
- ✅ 智能清理功能

### 🚀 latexcompile-standalone.sh (增强版 v6.0)

**定位**: 功能完整的专业级编译工具  
**行数**: 2220 行  
**适用场景**: 大型工程项目、团队协作、高度定制需求

**核心功能**:

- ✅ **简洁版所有功能**
- ✅ 7 种主题配色方案  
- ✅ 编译历史记录 (最近 10 次)
- ✅ 快速重编译 (一键重复上次编译)
- ✅ 字数统计 (texcount 集成)
- ✅ 全局 + 项目双层配置系统
- ✅ 精美的 UI 界面 (进度条、表格、Logo)
- ✅ 实时预览模式 (latexmk -pvc)

---

## 功能对比

| 功能 | 简洁版 v5.2 | 增强版 v6.0 |
|------|-------------|-------------|
| Latexmk 编译 | ✅ | ✅ |
| 多目标批量编译 | ✅ | ✅ |
| 跨平台支持 | ✅ | ✅ |
| 配置文件 (.latexcfg) | ✅ | ✅ |
| 命令行模式 | ✅ | ✅ |
| 清理辅助文件 | ✅ | ✅ 增强 |
| 自动打开 PDF | ✅ | ✅ 可配置 |
| **主题系统** | ❌ | ✅ 7 种主题 |
| **编译历史** | ❌ | ✅ 持久化 |
| **快速重编 译** | ❌ | ✅ |
| **字数统计** | ❌ | ✅ texcount |
| **全局配置** | ❌ | ✅ ~/.latexrc |
| **项目配置优先级** | ❌ | ✅ 项目 > 全局 |
| **精美UI** | ❌ | ✅ ASCII 艺术 |
| **实时预览** | ❌ | ✅ -pvc 模式 |
| **进度条/动画** | ❌ | ✅ |

---

## 安装与配置

### 前置依赖

```bash
# 必需软件
sudo dnf install -y texlive-scheme-full latexmk

# 可选 (增强功能)
sudo dnf install -y texcount     # 字数统计 (增强版)
sudo dnf install -y biber bibtex # 参考文献管理
```

### 脚本安装

#### 方法 1: 克隆完整仓库 (推荐)

```bash
# 克隆完整的工具仓库
cd ~/Documents/Github
git clone https://github.com/goblinunde/latexcompile.git

# 或克隆 resource-fedora 主仓库
git clone https://github.com/goblinunde/resource-fedora.git
```

**脚本位置**:

```
resource-fedora/sh/latexcompile-simple.sh
resource-fedora/sh/latexcompile-standalone.sh
```

#### 方法 2: 单独下载脚本

```bash
# 下载简洁版
curl -O https://raw.githubusercontent.com/goblinunde/resource-fedora/main/sh/latexcompile-simple.sh
chmod +x latexcompile-simple.sh

# 下载增强版
curl -O https://raw.githubusercontent.com/goblinunde/resource-fedora/main/sh/latexcompile-standalone.sh
chmod +x latexcompile-standalone.sh
```

### 添加到 Shell 别名

**在 .bashrc 或 .zshrc 中添加**:

```bash
# 简洁版
alias texmkone='/path/to/latexcompile-simple.sh'

# 增强版
alias texmk='/path/to/latexcompile-standalone.sh'
```

**示例** (基于你的配置):

```bash
# .zshrc L244-246
alias texmkone='/home/yyt/APPS/sh/latexcompile-simple.sh'
alias texmk='/home/yyt/APPS/sh/latexcompile-standalone.sh'
```

**重载配置**:

```bash
source ~/.zshrc  # 或 source ~/.bashrc
```

---

## 详细功能说明

### 🎯 简洁版 (latexcompile-simple.sh) 功能

#### 1. 跨平台支持

**自动检测系统并配置 PDF 打开命令**:

| 系统 | 检测 | PDF 打开命令 |
|------|------|--------------|
| macOS | `Darwin` | `open` |
| Linux | `Linux` | `xdg-open` |
| WSL | `Microsoft|WSL` | `wslview` 或 `explorer.exe` |
| Git Bash | `MINGW|MSYS` | `start` |

**代码位置**: L40-71

#### 2. Latexmk 智能编译

**支持的引擎**:

- `xelatex` (推荐,支持中文)
- `pdflatex` (传统)
- `lualatex` (Lua 脚本)

**编译流程**:

```bash
latexmk -xelatex -synctex=1 -file-line-error -interaction=nonstopmode -halt-on-error main.tex
```

**参数说明**:

- `-synctex=1`: 生成 SyncTeX 文件 (支持 PDF-源码双向跳转)
- `-file-line-error`: 错误信息显示文件名和行号
- `-interaction=nonstopmode`: 遇到错误不中断,继续编译
- `-halt-on-error`: 遇到严重错误立即停止

**代码位置**: L307-332, `compile_latexmk()`

#### 3. 批量编译 (.latexcfg)

**配置格式**:

```ini
# 旧版本兼容格式 (单目标)
MAIN_FILE = "main.tex"
ENGINE = "xelatex"
BIB_TOOL = "biber"

# 新版本格式 (多目标)
TARGET_1_FILE = "report.tex"
TARGET_1_ENGINE = "xelatex"
TARGET_1_BIB_TOOL = "biber"

TARGET_2_FILE = "slides.tex"
TARGET_2_ENGINE = "pdflatex"
TARGET_2_BIB_TOOL = "none"
```

**自动生成向导**:

```bash
# 运行脚本选择: Create/Update Config (.latexcfg)
./latexcompile-simple.sh
```

**代码位置**: L235-302, `generate_config_template()`

#### 4. 智能清理

**清理的文件类型**:

```
.aux .log .out .toc .lof .lot .synctex.gz .fls .fdb_latexmk
.bbl .blg .bcf .bit .idx .ilg .ind .glo .gls .glg .run.xml
.dvi .ptc .nav .snm .vrb .thm .xdy
```

**用法**:

```bash
# 清理所有辅助文件
./latexcompile-simple.sh
# 选择: Clean auxiliary files

# 或直接调用函数 (需要在脚本中)
clstex                # 清理所有
clstex main           # 清理 main.tex 相关
clstex report slides  # 清理多个文件
```

**代码位置**: L96-141, `clstex()`

#### 5. 手动编译链 (备用)

**编译流程**:

```
1. xelatex main.tex   (第1遍)
2. biber main         (处理参考文献)
3. xelatex main.tex   (第2遍,整合引用)
4. xelatex main.tex   (第3遍,更新目录)
```

**适用场景**: Latexmk 失败时的降级方案

**代码位置**: L408-443, `compile_manual_chain()`

#### 6. 命令行模式

**语法**:

```bash
./latexcompile-simple.sh [file.tex] [-e engine]
```

**示例**:

```bash
# 使用默认引擎 (xelatex)
./latexcompile-simple.sh main.tex

# 指定引擎
./latexcompile-simple.sh report.tex -e pdflatex

# 自动清理
./latexcompile-simple.sh slides.tex -e lualatex
```

**代码位置**: L514-532

---

### 🚀 增强版 (latexcompile-standalone.sh) 独有功能

#### 1. 主题系统 (7 种配色)

**可用主题**:

1. **default** - 原始配色 (蓝绿橙)
2. **nord** - 北欧极光 (冷色调) ⭐ 默认
3. **dracula** - 吸血鬼紫粉
4. **sakura** - 樱花粉
5. **matrix** - 黑客帝国绿
6. **gruvbox** - 复古暖色
7. **monokai** - 经典深色

**主题预览**:

```bash
./latexcompile-standalone.sh
# 选择: Settings → Preview Themes
```

**切换主题**:

```bash
# 方法 1: 全局配置 ~/.latexrc
[Theme]
active_theme = dracula

# 方法 2: 项目配置 .latexcfg
[Theme]
active_theme = matrix
```

**效果**: 所有输出颜色自动调整

**代码位置**: L20-156

#### 2. 编译历史记录

**功能**:

- 自动记录最近 10 次编译 (可配置)
- 记录文件名、引擎、成功/失败状态、时间戳
- 持久化到 `~/.latex_history`

**查看历史**:

```bash
./latexcompile-standalone.sh
# 选择: View Compilation History
```

**输出示例**:

```
  1. [OK] main.tex (xelatex) - 2026-01-22T23:30:15+08:00
  2. [X]  report.tex (pdflatex) - 2026-01-22T22:15:03+08:00
  3. [OK] slides.tex (xelatex) - 2026-01-22T20:45:22+08:00
```

**代码位置**: L702-743

#### 3. 快速重编译

**功能**: 一键重复上次编译 (从历史记录读取)

**使用**:

```bash
./latexcompile-standalone.sh
# 选择: Quick Recompile (Last File)
```

**适用场景**: 修改后快速验证,无需重新选择文件和引擎

**代码位置**: L745-766

#### 4. 字数统计

**功能**: 使用 `texcount` 统计 LaTeX 文档字数

**安装 texcount**:

```bash
sudo dnf install -y texcount
```

**使用**:

```bash
./latexcompile-standalone.sh
# 选择: Word Count Report
```

**输出示例**:

```
Words in text: 5432
Words in headers: 234
Words in floats: 167
...
Total: 5833 words
```

**降级方案**: 如果未安装 texcount,自动使用 `detex + wc -w`

**代码位置**: L768-821

#### 5. 双层配置系统

**配置优先级**: **项目配置** > **全局配置** > **默认值**

##### 全局配置 (~/.latexrc)

```ini
[General]
default_engine = xelatex
auto_cleanup = false
editor = nvim
auto_open_pdf = true

[Theme]
active_theme = nord

[Features]
enable_history = true
max_history = 10

[PDF]
viewer =
```

##### 项目配置 (.latexcfg)

```ini
[General]
default_engine = pdflatex  # 覆盖全局默认
auto_cleanup = true         # 当前项目自动清理

[Theme]
active_theme = dracula      # 项目专用主题

[Targets]
TARGET_1_FILE = "main.tex"
TARGET_1_ENGINE = "xelatex"
TARGET_1_BIB_TOOL = "biber"
```

**效果**: 项目配置覆盖全局配置,实现项目级定制

**代码位置**: L380-609

#### 6. 精美 UI

**ASCII Logo**:

```
     ╔╦╗╔═╗═╗ ╦  ╔═╗┌─┐┌┬┐┌─┐┬┬  ┌─┐┬─┐
      ║ ║╣ ╔╩╦╝  ║  │ ││││├─┘││  ├┤ ├┬┘
      ╩ ╚═╝╩ ╚═  ╚═╝└─┘┴ ┴┴  ┴┴─┘└─┘┴└─

Professional LaTeX Compilation Tool v6.0
```

**进度条**:

```
[████████████████████████████████░░░░░░░░] 80% (4/5)
```

**表格输出**:

```
  File       : main.tex
  Engine     : xelatex
  Bib Tool   : biber
  Status     : SUCCESS
```

**代码位置**: L161-313

#### 7. 实时预览模式

**功能**: 监听文件变化,自动重新编译

**使用**:

```bash
./latexcompile-standalone.sh
# 选择: Compile interactively → Live: Preview Mode (XeLaTeX)
```

**命令**:

```bash
latexmk -xelatex -pvc -synctex=1 -interaction=nonstopmode -halt-on-error main.tex
```

**参数说明**:

- `-pvc`: Preview Continuously (实时预览)
- 文件保存后自动重新编译
- 按 Ctrl+C 停止

**适用场景**: 论文写作、实时调试排版

**代码位置**: L446-452

---

## 配置文件详解

### .latexcfg (项目配置)

**标准格式** (增强版 v6.0):

```ini
# ============================================================================
# LaTeX Project Configuration
# ============================================================================

# -----------------------------------------------------------------------------
# [General] 通用设置
# -----------------------------------------------------------------------------
[General]
default_engine = xelatex    # 默认编译引擎: xelatex | pdflatex | lualatex
auto_cleanup = true          # 编译后自动清理辅助文件
editor = nvim                # 文本编辑器
auto_open_pdf = true         # 成功后自动打开 PDF

# -----------------------------------------------------------------------------
# [Theme] 主题设置 (增强版独有)
# -----------------------------------------------------------------------------
[Theme]
active_theme = nord          # 主题: default | nord | dracula | sakura | matrix | gruvbox | monokai

# -----------------------------------------------------------------------------
# [Features] 功能设置 (增强版独有)
# -----------------------------------------------------------------------------
[Features]
enable_history = true        # 启用编译历史
max_history = 10             # 最大历史记录数

# -----------------------------------------------------------------------------
# [PDF] PDF 查看器设置
# -----------------------------------------------------------------------------
[PDF]
viewer =                     # 自定义 PDF 查看器 (留空使用系统默认)

# -----------------------------------------------------------------------------
# [Targets] 编译目标 (多文件项目)
# -----------------------------------------------------------------------------
[Targets]
# 目标 1: 主文档
TARGET_1_FILE = "main.tex"
TARGET_1_ENGINE = "xelatex"
TARGET_1_BIB_TOOL = "biber"

# 目标 2: 幻灯片
TARGET_2_FILE = "slides.tex"
TARGET_2_ENGINE = "pdflatex"
TARGET_2_BIB_TOOL = "none"

# 目标 3: 附录
TARGET_3_FILE = "appendix.tex"
TARGET_3_ENGINE = "xelatex"
TARGET_3_BIB_TOOL = "bibtex"
```

### ~/.latexrc (全局配置,增强版独有)

**自动生成**: 首次运行增强版时自动创建

**位置**: `~/.latexrc`

**作用**: 全局默认设置,所有项目共享 (除非项目配置覆盖)

---

## 使用示例

### 示例 1: 简单单文件编译

```bash
# 交互式模式
cd ~/Documents/my-paper
texmkone

# 选择:
# 1. Compile interactively
# 2. 选择 main.tex
# 3. 选择 Auto: Latexmk (XeLaTeX) [Recommended]
```

### 示例 2: 命令行快速编译

```bash
# 简洁版
texmkone main.tex -e xelatex

# 增强版
texmk main.tex -e pdflatex
```

### 示例 3: 多文件批量编译

**创建配置**:

```bash
cd ~/Documents/thesis
texmk

# 选择: Create/Update Config (.latexcfg)
# 按提示添加 3 个目标: main.tex, chapters.tex, references.tex
```

**批量编译**:

```bash
texmk

# 选择: Compile with project config
# 选择: !! Compile ALL Targets !!
```

### 示例 4: 使用特定主题 (增强版)

**项目配置** `.latexcfg`:

```ini
[General]
default_engine = xelatex

[Theme]
active_theme = matrix  # 使用 Matrix 主题 (全绿色)
```

```bash
texmk
# 所有输出使用绿色主题
```

### 示例 5: 实时预览写作

```bash
cd ~/Documents/paper
texmk

# 选择: Compile interactively
# 选择: main.tex
# 选择: Live: Preview Mode (XeLaTeX)

# 在另一个终端编辑文件
nvim main.tex

# 保存后自动重新编译并更新 PDF
```

### 示例 6: 快速重编译 (增强版)

```bash
# 第一次编译
cd ~/Documents/report
texmk
# 选择文件并编译...

# 修改后快速重编译 (使用上次配置)
texmk
# 选择: Quick Recompile (Last File)
```

### 示例 7: 字数统计 (增强版)

```bash
cd ~/Documents/thesis
texmk

# 选择: Word Count Report
# 选择: main.tex

# 输出详细字数统计
```

---

## 常见问题

### Q1: 如何选择使用哪个版本?

**简洁版** (latexcompile-simple.sh):

- ✅ 日常编译需求
- ✅ 脚本执行速度快
- ✅ 轻量级,易于理解

**增强版** (latexcompile-standalone.sh):

- ✅ 大型项目 (论文、书籍)
- ✅ 团队协作 (统一配置)
- ✅ 需要历史记录和快速重编译
- ✅ 喜欢精美 UI 和主题

### Q2: 如何启用参考文献?

**Biber (推荐)**:

```ini
# .latexcfg
TARGET_1_BIB_TOOL = "biber"
```

**BibTeX (传统)**:

```ini
TARGET_1_BIB_TOOL = "bibtex"
```

**无参考文献**:

```ini
TARGET_1_BIB_TOOL = "none"
```

### Q3: 编译失败如何调试?

1. **查看详细日志**:

   ```bash
   # 脚本会提示: View end of log file to locate errors?
   # 选择 y,查看最后 25 行日志
   ```

2. **手动查看完整日志**:

   ```bash
   less main.log
   # 搜索 "Error"
   ```

3. **使用手动编译链** (测试步骤):

   ```bash
   # 在交互模式选择: Manual: XeLaTeX + Biber
   # 可以看到每一步的输出
   ```

### Q4: 如何配置中文支持?

**推荐使用 XeLaTeX**:

```ini
[General]
default_engine = xelatex
```

**LaTeX 文档头部**:

```latex
\documentclass{article}
\usepackage{xeCJK}
\setCJKmainfont{Noto Serif CJK SC}  % 或其他中文字体
\begin{document}
你好,LaTeX!
\end{document}
```

### Q5: 如何自定义 PDF 查看器?

**全局配置** `~/.latexrc`:

```ini
[PDF]
viewer = evince  # 或 okular, zathura, etc.
```

**项目配置** `.latexcfg`:

```ini
[PDF]
viewer = firefox  # 使用 Firefox 打开 PDF
```

### Q6: 脚本报错 "latexmk command not found"

**安装 Latexmk**:

```bash
# Fedora
sudo dnf install -y latexmk

# Ubuntu
sudo apt install -y latexmk
```

### Q7: 如何禁用自动打开 PDF?

**全局禁用**:

```ini
# ~/.latexrc
[General]
auto_open_pdf = false
```

**项目禁用**:

```ini
# .latexcfg
[General]
auto_open_pdf = false
```

### Q8: 增强版主题不生效?

**检查配置**:

```bash
# 1. 检查全局配置
cat ~/.latexrc

# 2. 检查项目配置
cat .latexcfg

# 3. 手动预览主题
texmk
# 选择: Settings → Preview Themes
```

**项目配置会覆盖全局配置**,确保 `.latexcfg` 中 `[Theme]` 部分设置正确。

---

## 🔗 相关资源

### GitHub 仓库

- **主仓库**: [goblinunde/latexcompile](https://github.com/goblinunde/latexcompile)
  - 查看最新版本
  - 提交 Issue 和功能请求
  - 贡献代码

- **Fedora 配置仓库**: [goblinunde/resource-fedora](https://github.com/goblinunde/resource-fedora)
  - 包含这两个脚本 (`sh/` 目录)
  - 完整的 Fedora 开发环境配置

### 官方文档

- [Latexmk 官方文档](https://mg.readthedocs.io/latexmk.html)
- [TeX Live 文档](https://www.tug.org/texlive/)
- [TeXcount 字数统计](https://app.uio.no/ifi/texcount/)

### 相关教程

- [Fedora 开发环境配置](DEV_ENV_FEDORA.md)
- [Shell 配置文件指南](SHELL_CONFIG_GUIDE.md)
- [常用命令速查表](COMMON_COMMANDS.md)

---

## 🤝 贡献与反馈

**发现 Bug?** 请在 [GitHub Issues](https://github.com/goblinunde/latexcompile/issues) 提交

**功能建议?** 欢迎提交 Pull Request!

**文档改进?** 任何改进建议都欢迎!

---

## 📜 更新日志

### v6.0-standalone (2026-01-22)

- ✅ 添加 7 种主题配色
- ✅ 添加编译历史记录
- ✅ 添加快速重编译
- ✅ 添加字数统计
- ✅ 双层配置系统
- ✅ 精美 UI 界面

### v5.2-simple (2026-01-22)

- ✅ 修复配置文件生成向导换行问题
- ✅ 增强配置解析器,支持 CRLF
- ✅ 优化 Zsh 数组处理

---

**⭐ 如果这些脚本对你有帮助,请给仓库一个 Star!**

**仓库地址**: <https://github.com/goblinunde/latexcompile>
