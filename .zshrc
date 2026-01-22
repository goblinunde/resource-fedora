# ==============================================================================
#                                 1. 系统初始化与性能
# ==============================================================================
# 如果不是交互式 Shell，直接退出，避免干扰脚本运行
[ -z "$ZSH_VERSION" ] && return

# [ 性能优化 ] Powerlevel10k 即时提示 (必须位于文件最顶端)
# 作用：在完整 Shell 加载完成前，先显示一个简易提示符，消除等待感
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# [ 核心路径 ] Oh My Zsh 安装位置
export ZSH="$HOME/.oh-my-zsh"

# ==============================================================================
#                                 2. 主题与界面视觉
# ==============================================================================

# [ 主题 ] 使用 Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# [ 行为微调 ]
DISABLE_AUTO_TITLE="true"          # 禁止 Shell 自动修改终端窗口标题
COMPLETION_WAITING_DOTS="true"     # 命令补全慢时显示动态省略号 "..."
ZSH_AUTOSUGGEST_STRATEGY=(history completion) # 自动建议策略：优先查历史，其次查补全

# [ 颜色定制 ] 自动建议文字颜色 (244 为淡灰色)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"

# [ TTY 兼容性 ]
# 检测是否在纯物理终端 (tty) 下，如果是，强制使用 ASCII 字符，防止图标乱码
if [[ "$TERM" == "linux" ]]; then
    export P10K_MODE='ascii'
fi

# ==============================================================================
#                                 3. 插件加载
# ==============================================================================

# 插件列表 (保持精简以加快启动速度)
# git: Git 快捷命令
# sudo: 按两下 ESC 自动加 sudo
# zsh-autosuggestions: 灰色历史建议
# zsh-syntax-highlighting: 命令着色 (绿色对/红色错)
plugins=(
    git 
    sudo 
    zsh-autosuggestions 
    zsh-syntax-highlighting
)

# 加载 Oh My Zsh 核心
source $ZSH/oh-my-zsh.sh

# ==============================================================================
#                                 4. 补全系统增强
# ==============================================================================

# 让补全菜单支持方向键选择
zstyle ':completion:*' menu select
# 补全描述信息显示为绿色
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
# 补全列表复用 ls 的颜色设置
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# 智能大小写匹配 (输入小写可补全大写)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ==============================================================================
#                                 5. 开发环境配置
# ==============================================================================

# --- [ Rust / Cargo ] ---
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# --- [ Python: Pyenv ] ---
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init - zsh)"
    eval "$(pyenv virtualenv-init -)"
fi

# --- [ Python: Mamba / Micromamba ] ---
# 极速包管理器配置 (保持你原有的逻辑)
unalias mamba 2>/dev/null  # 防止 reload 时报错
export MAMBA_EXE='/home/yyt/.local/bin/micromamba'
export MAMBA_ROOT_PREFIX='/home/yyt/micromamba'
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    if [ -f "$MAMBA_EXE" ]; then
        alias micromamba="$MAMBA_EXE"  
    fi
fi
unset __mamba_setup
alias mamba="micromamba"

# --- [ Node.js: NVM ] ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# --- [ Node.js: PNPM ] ---
export PNPM_HOME="/home/yyt/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# --- [ Julia: Juliaup ] ---
# 将 Juliaup 初始化整合至此，保持文件整洁
if [[ -d "/home/yyt/.juliaup/bin" ]]; then
    path=('/home/yyt/.juliaup/bin' $path)
    export PATH
fi

# --- [ 其他工具链 ] ---
# Pixi, Direnv 及本地二进制路径
export PATH="$HOME/.local/bin:$HOME/.pixi/bin:$PATH"
eval "$(direnv hook zsh)"

# ==============================================================================
#                                 6. 实用工具函数
# ==============================================================================

# [ Python 诊断 ] 深度显示当前 Python 路径和版本
showpython() {
    local py_cmd="python"
    if ! command -v python &> /dev/null; then py_cmd="python3"; fi

    if ! command -v $py_cmd &> /dev/null; then
        echo -e "\033[1;31m✗ 当前 PATH 中未发现 Python\033[0m"
        return 1
    fi

    local py_path=$(which $py_cmd)
    echo -e "\033[1;34m[Python 环境诊断报告]\033[0m"
    echo -e "\033[1;32m├─ 逻辑路径:\033[0m  $py_path"
    echo -e "\033[1;32m├─ 物理二进制:\033[0m $(readlink -f $py_path)"
    echo -e "\033[1;32m├─ 版本信息:\033[0m     $($py_cmd --version 2>&1)"
    
    if [[ -n "$CONDA_PREFIX" ]]; then
        echo -e "\033[1;32m└─ Mamba 环境:\033[0m  \033[1;33m${CONDA_DEFAULT_ENV}\033[0m ($CONDA_PREFIX)"
    else
        echo -e "\033[1;32m└─ Mamba 环境:\033[0m   无"
    fi
}

# [ Python 激活 ] 自动寻找并激活 venv/.venv
activate_py() {
    local venv_dirs=(".venv" "venv" ".env" "env")
    for dir in $venv_dirs; do
        if [[ -d "$dir" && -f "$dir/bin/activate" ]]; then
            source "$dir/bin/activate"
            echo -e "\033[1;32m⚡ 虚拟环境已激活: \033[1;33m$dir\033[0m"
            return 0
        fi
    done
    echo -e "\033[1;31m✗ 当前目录下未发现虚拟环境文件夹。\033[0m"
    echo "提示: Mamba 环境请使用 'mamba activate <名称>'"
    return 1
}

# [ Python 退出 ] 智能退出 Conda 或 Venv
deactivate_py() {
    local env_found=false
    if [[ -n "$CONDA_PREFIX" ]]; then
        echo -e "\033[1;33m⠇ 正在退出 Mamba 环境: $CONDA_DEFAULT_ENV...\033[0m"
        micromamba deactivate
        env_found=true
    fi
    if (( $+functions[deactivate] )); then
        echo -e "\033[1;33m⠇ 正在关闭 venv/virtualenv...\033[0m"
        deactivate
        env_found=true
    fi
    if [[ "$env_found" == "true" ]]; then
        echo -e "\033[1;32m✔ 所有 Python 环境已清理完毕。\033[0m"
    else
        echo -e "\033[1;31m✗ 未检测到任何已激活的环境。\033[0m"
    fi
}

# [ 命令分析器 ] wch <命令>: 显示命令的类型、路径和物理位置
wch() {
    local target=$1
    [[ -z "$target" ]] && echo -e "\033[1;31m用法:\033[0m wch <命令名>" && return 1
    
    echo -e "\033[1;34m┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓\033[0m"
    echo -e "\033[1;34m┃ 深度分析对象:\033[0m $target"
    echo -e "\033[1;34m┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\033[0m"
    
    echo -e "\033[1;32m[类型与定义]\033[0m"
    whence -va "$target"

    local cmd_path=$(whence -p "$target")
    if [[ -n "$cmd_path" ]]; then
        echo -e "\n\033[1;32m[二进制文件详情]\033[0m"
        echo -n "路径: $cmd_path"
        [[ -L "$cmd_path" ]] && echo -e " \033[1;33m->\033[0m $(readlink -f $cmd_path)" || echo " (物理文件)"
        file -b "$cmd_path"
    fi
}

# [ Flatpak 查看器 ] flat-cat <关键词>: 查看安装的 Flatpak 应用
function flat-cat() {
    local DIR="/var/lib/flatpak/exports/share/applications"
    local DATA=$(awk -F= '
        /^Name=/{name=$2} 
        /^Categories=/{
            gsub(";", " ", $2); 
            printf "\033[1;36m%-25s\033[0m %s\n", name, $2
        }' $DIR/*.desktop 2>/dev/null | sort -k 2)
    
    if [ -z "$1" ]; then
        echo "$DATA" | less -R
    else
        echo "$DATA" | grep -i "$1"
    fi
}

# ==============================================================================
#                                 7. 服务管理与别名
# ==============================================================================

# --- [ 通用别名 ] ---
alias zconf="nvim ~/.zshrc"         # 编辑配置
alias cls="clear"                   # 清屏
alias sz='source ~/.zshrc'          # 重载配置
alias ls="ls --color=auto"
alias ll="ls -lh"
alias la="ls -lah"
alias find100='find . -type f -size +100M' # 查找大于100M的文件
alias apy="activate_py"             # Python 激活简写
alias dpy="deactivate_py"           # Python 退出简写
alias open='xdg-open'
# --- [ TTY & 桌面 ] ---
alias tty3='sudo chvt 3'            # 切到纯文本终端
alias ttyd='sudo chvt 2'            # 切回图形界面
alias rgdm='sudo systemctl restart gdm' # 重启 GNOME
alias glog='gnome-session-quit --logout --no-prompt' # 注销

# --- [ LaTeX 脚本 ] ---
alias texmkone='/home/yyt/APPS/sh/latexcompile-simple.sh'
alias texmk='/home/yyt/APPS/sh/latexcompile-standalone.sh'

# --- [ Memos 服务管理 (增强版) ] ---
# 清理可能冲突的旧别名 (防止报错)
unalias memos-start memos-stop memos-restart memos-status memos-log 2>/dev/null

memos-start() {
    echo -e "🚀 \033[1;33m正在启动 Memos 服务...\033[0m"
    sudo systemctl start memos
    if systemctl is-active --quiet memos; then
        echo -e "✅ \033[1;32mMemos 启动成功!\033[0m"
        echo -e "🔗 访问地址: \033[4;36mhttp://localhost:60001\033[0m"
    else
        echo -e "❌ \033[1;31mMemos 启动失败，请检查日志。\033[0m"
        sudo systemctl status memos --no-pager -n 5
    fi
}

memos-stop() {
    echo -e "🛑 \033[1;33m正在停止 Memos 服务...\033[0m"
    sudo systemctl stop memos
    if ! systemctl is-active --quiet memos; then
        echo -e "✅ \033[1;32mMemos 已安全停止。\033[0m"
    else
        echo -e "⚠️ \033[1;31m停止失败，服务仍在运行。\033[0m"
    fi
}

memos-restart() {
    echo -e "🔄 \033[1;33m正在重启 Memos...\033[0m"
    sudo systemctl restart memos
    if systemctl is-active --quiet memos; then
        echo -e "✅ \033[1;32mMemos 重启完毕!\033[0m"
        echo -e "🔗 访问地址: \033[4;36mhttp://localhost:60001\033[0m"
    else
        echo -e "❌ \033[1;31m重启失败。\033[0m"
    fi
}

memos-status() {
    echo -e "📊 \033[1;33m查看 Memos 状态...\033[0m"
    sudo systemctl status memos
}

memos-log() {
    echo -e "📜 \033[1;33m实时日志 (按 Ctrl+C 退出)...\033[0m"
    sudo journalctl -u memos -f -n 20
}

# --- [ Cockpit 服务管理 (增强版) ] ---

# 0. 清理旧别名，防止冲突
unalias cop-start cop-stop cop-status 2>/dev/null

# 1. 启动 Cockpit
cop-start() {
    echo -e "🚀 \033[1;33m正在激活 Cockpit Socket...\033[0m"
    # Cockpit 推荐只启动 socket，访问时会自动唤醒 service
    sudo systemctl start cockpit.socket
    
    # 检查 Socket 是否在监听
    if systemctl is-active --quiet cockpit.socket; then
        echo -e "✅ \033[1;32mCockpit 已就绪 (Socket 监听中)\033[0m"
        echo -e "🔗 管理面板: \033[4;36mhttps://localhost:9090\033[0m"
        echo -e "   \033[2;37m(提示: 首次访问可能会提示证书安全警告，请忽略并继续)\033[0m"
    else
        echo -e "❌ \033[1;31m启动失败，Socket 未响应。\033[0m"
        sudo systemctl status cockpit.socket --no-pager -n 5
    fi
}

# 2. 停止 Cockpit
cop-stop() {
    echo -e "🛑 \033[1;33m正在停止 Cockpit (Socket + Service)...\033[0m"
    # 必须同时停止 socket (监听口) 和 service (后台进程)，否则可能会自动重启或残留
    sudo systemctl stop cockpit.socket cockpit.service
    
    if ! systemctl is-active --quiet cockpit.socket; then
        echo -e "✅ \033[1;32mCockpit 已完全停止。\033[0m"
    else
        echo -e "⚠️ \033[1;31m停止失败，服务似乎仍在运行。\033[0m"
    fi
}

# 3. 查看详细状态
cop-status() {
    echo -e "📊 \033[1;33mCockpit 运行状态诊断...\033[0m"
    echo -e "\033[1;34m--- [Socket 监听状态] ---\033[0m"
    systemctl status cockpit.socket --no-pager
    
    echo -e "\n\033[1;34m--- [后台服务状态] ---\033[0m"
    # 只有当有人登录过，Service 才会是 active，否则可能是 inactive (dead)，这是正常的
    systemctl status cockpit.service --no-pager
}

# ==============================================================================
#                                 8. 配置收尾
# ==============================================================================

# [ 主题配置 ] 加载 P10k 自定义设置
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh