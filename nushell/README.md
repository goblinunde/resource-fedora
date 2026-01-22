# Nushell 配置说明

完整的 Nushell 配置，集成 Tokyo Night 主题和实用函数库。

## 📁 目录结构

```
nushell/
├── config.nu           # 主配置文件
├── env.nu             # 环境变量和提示符配置
├── tokyo-night.toml   # Starship Tokyo Night 主题
├── themes/
│   └── tokyo-night.nu # Nushell Tokyo Night 主题
└── scripts/
    └── utils.nu       # 实用函数库
```

## ✨ 特性

### 🎨 Tokyo Night 主题

- **配色方案**: 采用官方 Tokyo Night 配色
- **语法高亮**: 完整的 Nushell 语法高亮配置
- **Starship 集成**: 使用 Tokyo Night 提示符主题

### 🛠️ 实用函数库

提供 30+ 个常用函数，涵盖以下功能分类：

#### 系统管理

- `sysinfo` - 显示系统信息（CPU、内存、磁盘）
- `ports` - 列出所有监听端口
- `proc <name>` - 按名称查找进程
- `sys-update` - 更新 Fedora 系统包
- `sys-clean` - 清理包缓存

#### 文件操作

- `mkcd <dir>` - 创建目录并进入
- `backup <file>` - 备份文件（添加时间戳）
- `sizeof <dir>` - 计算目录大小
- `extract <file>` - 智能解压（自动识别格式）
- `large-files [size]` - 查找大文件（默认 >100M）
- `disk-usage` - 显示当前目录磁盘使用情况

#### Git 函数

- `gst` - git status 简化输出
- `glog [n]` - 美化的 git log（默认显示 10 条）
- `gacp <message>` - git add + commit + push 一键操作
- `gc <message>` - 快速提交（add all + commit）
- `gbr` - 显示分支及最后提交信息

#### 网络工具

- `myip` - 显示本机 IP（内网和外网）
- `speedtest` - 测试下载速度

#### 开发工具

- `venv-activate` - 激活 Python 虚拟环境（支持 uv/poetry/venv）
- `serve [port]` - 启动 HTTP 服务器（默认 8000）
- `ports-kill <port>` - 根据端口号杀死进程

#### 快捷命令

- `ll` - 使用 lsd 的增强 ls
- `bat-cat <file>` - 使用 bat 的语法高亮 cat

## 🚀 安装

### 方法 1: 使用 setup.sh（推荐）

```bash
cd ~/Documents/Github/resource-fedora
bash setup.sh --shell nushell
```

### 方法 2: 手动部署

```bash
# 复制配置文件到 Nushell 配置目录
cp -r nushell/* ~/.config/nushell/

# 复制 Starship 主题
cp tokyo-night.toml ~/.config/
```

## 📖 使用示例

### 系统信息查看

```nushell
# 显示完整系统信息
sysinfo

# 查看监听端口
ports

# 查找 Firefox 进程
proc firefox
```

### 文件操作

```nushell
# 创建并进入目录
mkcd ~/Documents/test

# 备份文件
backup ~/.bashrc

# 解压文件（自动识别格式）
extract archive.tar.gz

# 查看目录大小
sizeof ~/Downloads
```

### Git 工作流

```nushell
# 查看状态
gst

# 查看最近 5 条提交
glog 5

# 快速提交并推送
gacp "feat: 添加新功能"

# 仅提交不推送
gc "fix: 修复bug"
```

### 网络工具

```nushell
# 查看 IP 地址
myip

# 测试网速
speedtest
```

### 开发环境

```nushell
# 激活 Python 虚拟环境
venv-activate

# 启动 HTTP 服务器（默认 8000 端口）
serve

# 在 3000 端口启动
serve 3000

# 杀死 8000 端口的进程
ports-kill 8000
```

## 🎨 主题配色

Tokyo Night 主题使用以下配色方案：

| 颜色         | 十六进制  | 用途           |
|--------------|-----------|----------------|
| 背景         | #1a1b26   | 默认背景       |
| 前景         | #c0caf5   | 默认文本       |
| 蓝色         | #7aa2f7   | 关键字、目录   |
| 绿色         | #9ece6a   | 字符串、成功   |
| 黄色         | #e0af68   | 警告、操作符   |
| 紫色         | #bb9af7   | 变量、参数     |
| 橙色         | #ff9e64   | 数字           |
| 青色         | #7dcfff   | 类型、文件     |
| 红色         | #f7768e   | 错误、删除     |

## ⚙️ 配置详解

### 环境变量（env.nu）

```nushell
$env.EDITOR = "nvim"           # 默认编辑器
$env.VISUAL = "nvim"           # 可视化编辑器
$env.PAGER = "less"            # 分页器
$env.STARSHIP_CONFIG = "..."  # Starship 配置路径
```

### 主题配置（config.nu）

```nushell
color_config: (tokyo_night_theme)  # 使用 Tokyo Night 主题
```

## 🔧 自定义

### 添加自定义函数

在 `scripts/utils.nu` 文件末尾添加：

```nushell
export def my-function [] {
    # 你的代码
}
```

### 修改主题颜色

编辑 `themes/tokyo-night.nu` 文件中的颜色定义。

## 📝 依赖项

**必需**:

- Nushell (≥ 0.99.0)

**推荐**:

- [Starship](https://starship.rs/) - 跨 Shell 提示符（Tokyo Night 主题）
- [lsd](https://github.com/lsd-rs/lsd) - 现代化 ls 命令
- [bat](https://github.com/sharkdp/bat) - 语法高亮 cat

**可选**:

- [fd](https://github.com/sharkdp/fd) - 现代化 find 命令
- [rg](https://github.com/BurntSushi/ripgrep) - 快速文本搜索

## 🐛 故障排除

### Starship 未加载

确保已安装 Starship 并在 PATH 中：

```bash
# 安装 Starship (Fedora)
sudo dnf install -y starship

# 验证安装
starship --version
```

### 函数无法使用

确保 `scripts/utils.nu` 已正确加载：

```nushell
# 在 Nushell 中检查
which sysinfo
```

### 主题颜色不正确

确保使用的终端支持 True Color（24位）：

```bash
# 测试终端颜色支持
echo $COLORTERM
```

## 📚 更多资源

- [Nushell 官方文档](https://www.nushell.sh/)
- [Tokyo Night 主题](https://github.com/tokyo-night/tokyo-night-vscode-theme)
- [Starship 文档](https://starship.rs/)

---

**作者**: SMLYFM <yytcjx@gmail.com>  
**仓库**: [goblinunde/resource-fedora](https://github.com/goblinunde/resource-fedora)
