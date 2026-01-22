# 🌍 环境变量配置指南

> **适用系统**: Fedora / Ubuntu / 其他 Linux 发行版  
> **适用 Shell**: Bash, Zsh, Fish, Nushell  
> **更新日期**: 2026-01-22

本指南详细说明开发环境中常用的环境变量配置方法,涵盖系统级变量、编程语言特定变量和包管理器配置。

---

## 📋 目录

- [Shell 配置文件说明](#shell-配置文件说明)
- [通用系统变量](#通用系统变量)
- [编程语言变量](#编程语言变量)
- [包管理器配置](#包管理器配置)
- [完整配置示例](#完整配置示例)

---

## Shell 配置文件说明

### Bash

```bash
# 系统级配置 (影响所有用户)
/etc/profile              # 登录 shell 加载
/etc/bash.bashrc          # 交互式 shell 加载

# 用户级配置 (影响当前用户)
~/.bash_profile           # 登录 shell 加载 (优先)
~/.profile                # 登录 shell 加载 (备选)
~/.bashrc                 # 交互式 shell 加载 (推荐配置位置)
~/.bash_logout            # 登出时加载
```

> [!NOTE]
> **Bash 配置加载顺序**
>
> - **登录 shell**: `~/.bash_profile` → `~/.profile` → `~/.bashrc`
> - **交互式 shell**: 直接加载 `~/.bashrc`
> - **推荐做法**: 所有配置写在 `~/.bashrc`,在 `~/.bash_profile` 中 source `~/.bashrc`

### Zsh

```bash
# 系统级配置
/etc/zsh/zshenv           # 所有 shell 加载
/etc/zsh/zprofile         # 登录 shell 加载
/etc/zsh/zshrc            # 交互式 shell 加载

# 用户级配置
~/.zshenv                 # 所有 shell 加载 (环境变量)
~/.zprofile               # 登录 shell 加载
~/.zshrc                  # 交互式 shell 加载 (推荐配置位置)
~/.zlogin                 # 登录 shell 加载 (zshrc 之后)
~/.zlogout                # 登出时加载
```

> [!NOTE]
> **Zsh 配置加载顺序**
>
> - `~/.zshenv` → `~/.zprofile` → `~/.zshrc` → `~/.zlogin`
> - **推荐做法**: 环境变量写在 `~/.zshrc` (使用 Oh-My-Zsh 时)

### Fish

```bash
# 系统级配置
/etc/fish/config.fish

# 用户级配置
~/.config/fish/config.fish           # 主配置文件 (推荐)
~/.config/fish/fish_variables        # 通用变量 (自动生成)
~/.config/fish/conf.d/*.fish         # 配置片段目录
~/.config/fish/functions/*.fish      # 自定义函数
```

**Fish 环境变量语法**:

```fish
# 设置环境变量 (使用 set -x)
set -x EDITOR vim
set -x PATH /usr/local/bin $PATH

# 持久化保存 (使用 set -Ux,保存到 fish_variables)
set -Ux JAVA_HOME /usr/lib/jvm/java-21-openjdk
```

### Nushell

```bash
# 用户级配置
~/.config/nushell/env.nu      # 环境变量配置 (推荐)
~/.config/nushell/config.nu   # 主配置文件
```

**Nushell 环境变量语法**:

```nushell
# env.nu 文件中设置
$env.EDITOR = "vim"
$env.JAVA_HOME = "/usr/lib/jvm/java-21-openjdk"

# 修改 PATH
$env.PATH = ($env.PATH | split row (char esep) | prepend "/usr/local/bin")
```

---

## 通用系统变量

### PATH - 可执行文件搜索路径

**Bash/Zsh**:

```bash
# 添加单个路径 (前置)
export PATH="/usr/local/bin:$PATH"

# 添加多个路径
export PATH="/usr/local/bin:/opt/bin:$HOME/.local/bin:$PATH"

# 检查 PATH
echo $PATH | tr ':' '\n'  # 每行显示一个路径
```

**Fish**:

```fish
# 添加路径
set -x PATH /usr/local/bin $PATH
set -x PATH $HOME/.local/bin $PATH

# 持久化
set -Ux fish_user_paths /usr/local/bin $fish_user_paths
```

**Nushell**:

```nushell
# env.nu
$env.PATH = ($env.PATH | split row (char esep) | prepend "/usr/local/bin")
```

### EDITOR/VISUAL - 默认编辑器

```bash
# Bash/Zsh
export EDITOR=vim
export VISUAL=vim    # 或 neovim

# Fish
set -Ux EDITOR vim
set -Ux VISUAL nvim

# Nushell
$env.EDITOR = "vim"
$env.VISUAL = "nvim"
```

### LANG/LC_ALL - 语言环境

```bash
# Bash/Zsh - 设置为中文 UTF-8
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# 或设置为英文
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Fish
set -Ux LANG en_US.UTF-8
set -Ux LC_ALL en_US.UTF-8
```

### PAGER - 分页器

```bash
# Bash/Zsh
export PAGER=less
export LESS='-R -F -X'  # 保留颜色、自动退出、不清屏

# Fish
set -Ux PAGER less
set -Ux LESS '-R -F -X'
```

---

## 编程语言变量

### Rust 环境变量

```bash
# Bash/Zsh
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"
export PATH="$CARGO_HOME/bin:$PATH"

# 启用详细错误回溯
export RUST_BACKTRACE=1         # 简单回溯
export RUST_BACKTRACE=full      # 完整回溯

# Cargo 镜像 (由 ~/.cargo/config.toml 管理,无需环境变量)
```

**Fish**:

```fish
set -Ux CARGO_HOME "$HOME/.cargo"
set -Ux RUSTUP_HOME "$HOME/.rustup"
set -Ux PATH "$CARGO_HOME/bin" $PATH
set -Ux RUST_BACKTRACE 1
```

**Nushell**:

```nushell
$env.CARGO_HOME = ($env.HOME | path join ".cargo")
$env.RUSTUP_HOME = ($env.HOME | path join ".rustup")
$env.PATH = ($env.PATH | prepend ($env.CARGO_HOME | path join "bin"))
$env.RUST_BACKTRACE = "1"
```

### Go 环境变量

```bash
# Bash/Zsh
export GOROOT=/usr/local/go              # Go 安装路径
export GOPATH=$HOME/go                   # Go 工作目录
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# Go Modules 配置
export GO111MODULE=on                    # 启用 Go Modules (默认)
export GOPROXY=https://goproxy.cn,direct # 国内镜像加速
export GOSUMDB=sum.golang.google.cn      # 校验数据库镜像

# 私有仓库配置
export GOPRIVATE=github.com/mycompany/*  # 跳过代理
```

**Fish**:

```fish
set -Ux GOROOT /usr/local/go
set -Ux GOPATH $HOME/go
set -Ux PATH $GOROOT/bin $GOPATH/bin $PATH
set -Ux GO111MODULE on
set -Ux GOPROXY https://goproxy.cn,direct
```

### Java 环境变量

```bash
# Bash/Zsh
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk  # 根据实际路径调整
export PATH="$JAVA_HOME/bin:$PATH"

# Maven 配置
export MAVEN_HOME=/opt/maven
export PATH="$MAVEN_HOME/bin:$PATH"
export MAVEN_OPTS="-Xmx2048m -XX:MaxPermSize=512m"

# Gradle 配置
export GRADLE_HOME=/opt/gradle
export PATH="$GRADLE_HOME/bin:$PATH"
export GRADLE_USER_HOME=$HOME/.gradle
```

**Fish**:

```fish
set -Ux JAVA_HOME /usr/lib/jvm/java-21-openjdk
set -Ux PATH $JAVA_HOME/bin $PATH
set -Ux MAVEN_HOME /opt/maven
set -Ux PATH $MAVEN_HOME/bin $PATH
```

### Python 环境变量

```bash
# Bash/Zsh
# pyenv 配置
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# poetry 配置
export POETRY_HOME="$HOME/.local/share/pypoetry"
export PATH="$POETRY_HOME/bin:$PATH"

# 虚拟环境配置
export VIRTUAL_ENV_DISABLE_PROMPT=1      # 禁用默认提示符修改
export PYTHONPATH="$HOME/myproject/src"  # 添加模块搜索路径

# uv 配置 (一般无需环境变量,使用默认路径即可)
```

**Fish**:

```fish
# pyenv
set -Ux PYENV_ROOT "$HOME/.pyenv"
set -Ux PATH "$PYENV_ROOT/bin" $PATH
pyenv init - | source

# poetry
set -Ux POETRY_HOME "$HOME/.local/share/pypoetry"
set -Ux PATH "$POETRY_HOME/bin" $PATH
```

### Julia 环境变量

```bash
# Bash/Zsh
export JULIA_DEPOT_PATH="$HOME/.julia"   # Julia 包和环境路径
export JULIA_NUM_THREADS=8               # 多线程数 (根据 CPU 核心数调整)
export JULIA_EDITOR=nvim                 # Julia REPL 编辑器

# Fish
set -Ux JULIA_DEPOT_PATH "$HOME/.julia"
set -Ux JULIA_NUM_THREADS 8
set -Ux JULIA_EDITOR nvim
```

### Ruby 环境变量

```bash
# Bash/Zsh
# rbenv 配置
export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init - bash)"

# Gem 配置
export GEM_HOME="$HOME/.gem"
export PATH="$GEM_HOME/bin:$PATH"

# Fish
set -Ux RBENV_ROOT "$HOME/.rbenv"
set -Ux PATH "$RBENV_ROOT/bin" $PATH
rbenv init - | source
```

### Node.js 环境变量

```bash
# Bash/Zsh
# NVM 配置
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # 加载 nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Node 路径 (由 NVM 自动管理)
export NODE_PATH="$NVM_DIR/versions/node/v20.0.0/lib/node_modules"

# npm 配置
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"

# Fish
set -Ux NVM_DIR "$HOME/.nvm"
# 使用 fish-nvm 插件或 bass 加载 nvm
```

---

## 包管理器配置

### Conda/Mamba 环境变量

```bash
# Bash/Zsh
# Miniforge 安装后自动添加
# >>> conda initialize >>>
__conda_setup="$($HOME/miniforge3/bin/conda 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "$HOME/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "$HOME/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

# 手动配置
export CONDA_PREFIX="$HOME/miniforge3"
export MAMBA_ROOT_PREFIX="$HOME/miniforge3"
```

**Fish**:

```fish
# Conda 自动初始化
# >>> conda initialize >>>
eval $HOME/miniforge3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<
```

### Micromamba 环境变量

```bash
# Bash/Zsh
export MAMBA_ROOT_PREFIX="$HOME/micromamba"
eval "$(micromamba shell hook -s bash)"

# Fish
set -Ux MAMBA_ROOT_PREFIX "$HOME/micromamba"
eval (micromamba shell hook -s fish)
```

### 代理配置

```bash
# Bash/Zsh - HTTP/HTTPS 代理
export HTTP_PROXY="http://127.0.0.1:7890"
export HTTPS_PROXY="http://127.0.0.1:7890"

# SOCKS5 代理
export ALL_PROXY="socks5://127.0.0.1:7891"

# Git 代理 (覆盖 ~/.gitconfig)
export GIT_PROXY_COMMAND="nc -X 5 -x 127.0.0.1:7891 %h %p"

# 不走代理的域名
export NO_PROXY="localhost,127.0.0.1,::1,.local,.cn"

# Fish
set -Ux HTTP_PROXY "http://127.0.0.1:7890"
set -Ux HTTPS_PROXY "http://127.0.0.1:7890"
set -Ux NO_PROXY "localhost,127.0.0.1,.local"
```

---

## 完整配置示例

### Bash 完整配置 (`~/.bashrc`)

```bash
# ~/.bashrc - Bash 配置示例

# ============ 系统基础配置 ============
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS='-R -F -X'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ============ PATH 配置 ============
export PATH="$HOME/.local/bin:$PATH"

# ============ Rust 配置 ============
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"
export PATH="$CARGO_HOME/bin:$PATH"
export RUST_BACKTRACE=1

# ============ Go 配置 ============
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct

# ============ Java 配置 ============
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
export PATH="$JAVA_HOME/bin:$PATH"

# ============ Python 配置 ============
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

# poetry
export POETRY_HOME="$HOME/.local/share/pypoetry"
export PATH="$POETRY_HOME/bin:$PATH"

# ============ Ruby 配置 ============
export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$PATH"
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init - bash)"
fi

# ============ Node.js 配置 ============
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ============ Julia 配置 ============
export JULIA_NUM_THREADS=12

# ============ Conda 配置 ============
# >>> conda initialize >>>
__conda_setup="$($HOME/miniforge3/bin/conda 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "$HOME/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "$HOME/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

# ============ 代理配置 (按需启用) ============
# export HTTP_PROXY="http://127.0.0.1:7890"
# export HTTPS_PROXY="http://127.0.0.1:7890"
# export NO_PROXY="localhost,127.0.0.1,.local"

# ============ Starship 提示符 ============
if command -v starship 1>/dev/null 2>&1; then
  eval "$(starship init bash)"
fi
```

### Zsh 完整配置 (`~/.zshrc`)

```bash
# ~/.zshrc - Zsh 配置示例

# ============ 系统基础配置 ============
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS='-R -F -X'
export LANG=en_US.UTF-8

# ============ PATH 配置 ============
export PATH="$HOME/.local/bin:$PATH"

# ============ Rust 配置 ============
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"
export PATH="$CARGO_HOME/bin:$PATH"
export RUST_BACKTRACE=1

# ============ Go 配置 ============
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct

# ============ Java 配置 ============
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
export PATH="$JAVA_HOME/bin:$PATH"

# ============ Python 配置 ============
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

export POETRY_HOME="$HOME/.local/share/pypoetry"
export PATH="$POETRY_HOME/bin:$PATH"

# ============ Ruby 配置 ============
export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$PATH"
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init - zsh)"
fi

# ============ Node.js 配置 ============
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ============ Julia 配置 ============
export JULIA_NUM_THREADS=12

# ============ Conda 配置 ============
# >>> conda initialize >>>
__conda_setup="$($HOME/miniforge3/bin/conda 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "$HOME/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "$HOME/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

# ============ Oh-My-Zsh (如果使用) ============
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git rust golang python docker kubectl)
source $ZSH/oh-my-zsh.sh

# ============ Starship 提示符 ============
if command -v starship 1>/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
```

### Fish 完整配置 (`~/.config/fish/config.fish`)

```fish
# ~/.config/fish/config.fish - Fish 配置示例

# ============ 系统基础配置 ============
set -Ux EDITOR nvim
set -Ux VISUAL nvim
set -Ux PAGER less
set -Ux LESS '-R -F -X'
set -Ux LANG en_US.UTF-8

# ============ PATH 配置 ============
set -Ux fish_user_paths $HOME/.local/bin $fish_user_paths

# ============ Rust 配置 ============
set -Ux CARGO_HOME "$HOME/.cargo"
set -Ux RUSTUP_HOME "$HOME/.rustup"
set -Ux PATH "$CARGO_HOME/bin" $PATH
set -Ux RUST_BACKTRACE 1

# ============ Go 配置 ============
set -Ux GOROOT /usr/local/go
set -Ux GOPATH $HOME/go
set -Ux PATH $GOROOT/bin $GOPATH/bin $PATH
set -Ux GO111MODULE on
set -Ux GOPROXY https://goproxy.cn,direct

# ============ Java 配置 ============
set -Ux JAVA_HOME /usr/lib/jvm/java-21-openjdk
set -Ux PATH $JAVA_HOME/bin $PATH

# ============ Python 配置 ============
set -Ux PYENV_ROOT "$HOME/.pyenv"
set -Ux PATH "$PYENV_ROOT/bin" $PATH
if command -v pyenv 1>/dev/null 2>&1
    pyenv init - | source
end

set -Ux POETRY_HOME "$HOME/.local/share/pypoetry"
set -Ux PATH "$POETRY_HOME/bin" $PATH

# ============ Ruby 配置 ============
set -Ux RBENV_ROOT "$HOME/.rbenv"
set -Ux PATH "$RBENV_ROOT/bin" $PATH
if command -v rbenv 1>/dev/null 2>&1
    rbenv init - | source
end

# ============ Julia 配置 ============
set -Ux JULIA_NUM_THREADS 12

# ============ Conda 配置 ============
# >>> conda initialize >>>
eval $HOME/miniforge3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

# ============ Starship 提示符 ============
if command -v starship 1>/dev/null 2>&1
    starship init fish | source
end
```

---

## 💡 最佳实践

> [!TIP]
> **环境变量配置建议**
>
> 1. **按功能分组**: 将相关变量归类到一起 (如 Rust 配置、Go 配置)
> 2. **添加注释**: 使用注释说明每个变量的用途
> 3. **条件检查**: 使用 `command -v` 检查工具是否存在再初始化
> 4. **避免重复**: 不要在多个配置文件中重复设置相同变量
> 5. **定期清理**: 删除不再使用的工具的环境变量配置

> [!WARNING]
> **常见陷阱**
>
> - **PATH 顺序**: 路径放在 `$PATH` 前面会优先搜索,可能覆盖系统命令
> - **Shell 重载**: 修改配置后需 `source ~/.bashrc` 或重启终端
> - **Fish 变量**: Fish 使用 `set -Ux` 持久化的变量存储在 `fish_variables`,不在 `config.fish` 中

---

## 📚 相关文档

- [Fedora 开发环境配置](DEV_ENV_FEDORA.md)
- [Ubuntu 开发环境配置](DEV_ENV_UBUNTU.md)
- [常用命令速查表](COMMON_COMMANDS.md)
- [主配置说明](../README.md)

---

**⭐ 如果本指南对你有帮助,请给仓库一个 Star!**
