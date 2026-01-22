# .bashrc - Fixed for Bash compatibility on Fedora 43
# User: yyt | Path: /home/yyt

# --- 1. 系统级配置加载 ---
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# --- 2. 环境变量与路径优化 ---
# 💡 Bash 路径去重函数
path_append() {
    if [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}
path_append "$HOME/.local/bin"
path_append "$HOME/bin"

export BAT_THEME="base16"
export SYSTEMD_PAGER=cat 

# --- 3. 现代化工具别名 ---
if command -v lsd >/dev/null 2>&1; then
    alias ls='lsd'
    alias l='lsd -l'
    alias la='lsd -a'
    alias lla='lsd -la'
    alias lt='lsd --tree'
fi

alias cat='bat --paging=never'
alias grep='rg'
alias find='fd'
alias cls='clear'
alias open='xdg-open'
alias sb='source ~/.bashrc'

# --- 4. 语言环境与开发工具 ---

# 🦀 Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# 🐍 Python (Pyenv)
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d $PYENV_ROOT/bin ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - bash)"
    eval "$(pyenv virtualenv-init - bash)"
fi

# 🟢 Node.js (NVM)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- 5. 提示符与个性化 ---
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# --- 6. 模块化加载 ---
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        [ -f "$rc" ] && . "$rc"
    done
fi
unset rcexport PATH="$HOME/.local/bin:$PATH"

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE='/home/yyt/.local/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/yyt/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
alias mamba="micromamba"

# 切换 TTY 的别名
alias tty3='sudo chvt 3'
alias ttyd='sudo chvt 2'  # ttyd 表示 tty-desktop

# 重启 GNOME 桌面 (会关闭所有程序)
alias rgdm='sudo systemctl restart gdm'

# 安全注销
alias glog='gnome-session-quit --logout --no-prompt'


# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/home/yyt/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/yyt/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<
