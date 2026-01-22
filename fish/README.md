# Fish Shell 配置说明

完整的 Fish Shell 配置，包含现代化工具集成、实用函数和文件模板系统。

## ✨ 特性

### 🎨 主题美化

- **Starship 提示符** - 使用 Tokyo Night 主题
- **彩色 man 页面** - 增强的手册页显示
- **现代化工具集成** - lsd, bat, fd, rg 等

### 📝 文件模板系统

提供 **8 种文件模板**，快速创建各类项目文件：

| 命令 | 描述 | 示例 |
|------|------|------|
| `template_python <file.py>` | Python 脚本模板 | `template_python app.py` |
| `template_rust <file.rs>` | Rust 源文件模板 | `template_rust main.rs` |
| `template_shell <file.sh>` | Bash 脚本模板 | `template_shell deploy.sh` |
| `template_makefile [file]` | Makefile 模板 | `template_makefile` |
| `template_markdown <file.md>` | Markdown 文档模板 | `template_markdown README.md` |
| `template_latex <file.tex>` | LaTeX 文档模板 | `template_latex paper.tex` |
| `template_cpp_header <file.h>` | C/C++ 头文件模板 | `template_cpp_header utils.h` |
| `template_json <file.json>` | JSON 配置模板 | `template_json config.json` |

**快捷命令**: `tpl` - 显示所有可用模板

### 🛠️ 实用函数

- `mkcd <dir>` - 创建目录并进入
- `extract <file>` - 智能解压（自动识别格式）
- `backup <file>` - 备份文件（带时间戳）
- `fcd` - 使用 fzf 查找并进入目录
- `fopen` - 使用 fzf 查找并打开文件
- `ports` - 显示占用端口的进程

### 📦 包管理器别名

```fish
dnfi      # sudo dnf install
dnfu      # sudo dnf update
dnfr      # sudo dnf remove
dnfs      # dnf search
sysup     # 系统完整更新
```

### 🔧 开发工具别名

**Git 工作流**:

```fish
g         # git
gs        # git status
ga        # git add
gc        # git commit
gp        # git push
gl        # git log --oneline --graph
```

**Python 开发**:

```fish
py        # python3
pip       # python3 -m pip
venv      # python3 -m venv
```

**Tmux**:

```fish
t         # tmux
ta        # tmux attach
tl        # tmux list-sessions
```

## 📁 目录结构

```
fish/
├── config.fish                # 主配置文件
├── functions/
│   └── templates.fish         # 文件模板系统
└── tokyo-night.toml           # Starship Tokyo Night 主题
```

## 🚀 安装

### 方法 1: 使用 setup.sh（推荐）

```bash
cd ~/Documents/Github/resource-fedora
bash setup.sh --shell fish
```

### 方法 2: 手动部署

```bash
# 复制配置文件
cp -r fish/* ~/.config/fish/

# 复制 Starship 主题
cp tokyo-night.toml ~/.config/fish/
```

## 📖 使用示例

### 文件模板创建

```fish
# 创建 Python 脚本
template_python my_script.py

# 创建 Rust 项目文件
template_rust main.rs

# 创建 Shell 脚本（自动添加 shebang 和颜色函数）
template_shell deploy.sh

# 创建 Makefile
template_makefile

# 创建 Markdown 文档（自动生成目录结构）
template_markdown PROJECT.md

# 查看所有可用模板
tpl  # 或 template_list
```

### 实用函数

```fish
# 创建并进入目录
mkcd ~/projects/new-app

# 备份文件
backup important.conf
# 生成: important.conf.backup.20260123-002000

# 解压文件（自动识别格式）
extract archive.tar.gz
extract package.zip

# 使用 fzf 快速导航
fcd          # 查找并进入目录
fopen        # 查找并打开文件

# 查看端口占用
ports
```

### 包管理

```fish
# 安装软件包
dnfi package-name

# 更新系统
sysup

# 搜索软件包
dnfs keyword
```

## 🎨 模板特性

每个模板都包含：

- ✅ **作者信息** - 自动填充 SMLYFM <yytcjx@gmail.com>
- ✅ **创建日期** - 自动填充当前日期
- ✅ **标准化结构** - 遵循最佳实践
- ✅ **注释说明** - 详细的代码注释

### Python 模板特性

- Shebang 和编码声明
- 模块文档字符串
- main 函数结构
- if **name** == "**main**" 惯用语法

### Rust 模板特性

- 模块文档注释
- 标准错误处理
- 单元测试模块

### Shell 模板特性

- Bash 严格模式 (set -euo pipefail)
- 彩色日志函数
- 参数解析
- 使用说明函数
- 自动添加执行权限

### Makefile 模板特性

- 帮助目标自动生成
- PHONY 目标声明
- 标准化目标命名

## ⚙️ 配置详解

### Tokyo Night 主题

在 `config.fish` 中配置：

```fish
if type -q starship
    set -gx STARSHIP_CONFIG ~/.config/fish/tokyo-night.toml
    starship init fish | source
end
```

### 现代化工具集成

Fish 会自动检测并使用以下工具替代传统命令：

| 传统命令 | 现代替代 | 优势 |
|----------|----------|------|
| `ls` | `lsd` / `exa` | 彩色输出、图标显示 |
| `cat` | `bat` | 语法高亮、行号 |
| `find` | `fd` | 更快、更简单 |
| `grep` | `rg` | 极快的搜索速度 |

## 🔧 自定义

### 添加自定义函数

在 `~/.config/fish/functions/` 目录下创建 `.fish` 文件：

```fish
# ~/.config/fish/functions/my_function.fish
function my_function
    echo "Hello from custom function!"
end
```

### 添加自定义模板

编辑 `functions/templates.fish`，添加新的模板函数：

```fish
function template_mytype
    # 模板实现
end
```

## 📝 依赖项

**必需**:

- Fish Shell (≥ 3.0)

**推荐**:

- [Starship](https://starship.rs/) - 提示符主题
- [lsd](https://github.com/lsd-rs/lsd) - 现代 ls
- [bat](https://github.com/sharkdp/bat) - 语法高亮 cat
- [fd](https://github.com/sharkdp/fd) - 现代 find
- [rg](https://github.com/BurntSushi/ripgrep) - 快速搜索
- [fzf](https://github.com/junegunn/fzf) - 模糊查找工具

**安装推荐工具**:

```bash
# Fedora
sudo dnf install -y starship lsd bat fd-find ripgrep fzf
```

## 🐛 故障排除

### 模板命令不可用

确保 `templates.fish` 已正确加载：

```fish
# 检查函数是否存在
type template_python

# 手动加载
source ~/.config/fish/functions/templates.fish
```

### Starship 未显示

确保已安装并在 PATH 中：

```bash
# 检查 Starship
starship --version

# 如未安装
sudo dnf install -y starship
```

## 📚 更多资源

- [Fish Shell 官方文档](https://fishshell.com/)
- [Tokyo Night 主题](https://github.com/tokyo-night/tokyo-night-vscode-theme)
- [Starship 文档](https://starship.rs/)

---

**作者**: SMLYFM <yytcjx@gmail.com>  
**仓库**: [goblinunde/resource-fedora](https://github.com/goblinunde/resource-fedora)
