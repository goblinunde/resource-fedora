# ============================================================================
# Fish Shell 配置文件 - Fedora 43 优化版
# 作者: SMLYFM <yytcjx@gmail.com>
# 用途: Fish shell 交互式配置
# 主题: Starship Tokyo Night
# ============================================================================

if status is-interactive
    # ========================================================================
    # Starship 提示符初始化 (Tokyo Night 主题)
    # ========================================================================
    if type -q starship
        # 使用本地 tokyo-night.toml 配置
        set -gx STARSHIP_CONFIG ~/.config/fish/tokyo-night.toml
        starship init fish | source
    end

    # ========================================================================
    # 环境变量配置
    # ========================================================================
    
    # 编辑器设置
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    
    # PATH 扩展
    # 💡 添加常用工具路径
    fish_add_path ~/.local/bin
    fish_add_path ~/.cargo/bin
    
    # Conda/Mamba 环境 (如果已安装)
    if test -d ~/miniforge3
        eval ~/miniforge3/bin/conda "shell.fish" "hook" $argv | source
    else if test -d ~/miniconda3
        eval ~/miniconda3/bin/conda "shell.fish" "hook" $argv | source
    end

    # ========================================================================
    # 现代化 CLI 工具别名
    # ========================================================================
    
    # ls 相关 (使用 lsd 或 exa 替代)
    if type -q lsd
        alias ls='lsd'
        alias ll='lsd -lh'
        alias la='lsd -lAh'
        alias lt='lsd --tree'
    else if type -q exa
        alias ls='exa'
        alias ll='exa -lh'
        alias la='exa -lah'
        alias lt='exa --tree'
    else
        alias ll='ls -lh'
        alias la='ls -lAh'
    end
    
    # cat 替代 (使用 bat)
    if type -q bat
        alias cat='bat --paging=never'
        alias ccat='bat --paging=always'  # 分页版本
    end
    
    # find 替代 (使用 fd)
    if type -q fd
        alias find='fd'
    end
    
    # grep 替代 (使用 ripgrep)
    if type -q rg
        alias grep='rg'
    end

    # ========================================================================
    # 系统别名
    # ========================================================================
    
    # DNF 包管理器
    alias dnfi='sudo dnf install'
    alias dnfu='sudo dnf update'
    alias dnfr='sudo dnf remove'
    alias dnfs='dnf search'
    alias dnfinfo='dnf info'
    
    # 系统管理
    alias sysup='sudo dnf update -y && sudo dnf autoremove -y'
    alias sysinfo='fastfetch'  # 或 neofetch
    
    # 快速导航
    alias ..='cd ..'
    alias ...='cd ../..'
    alias ....='cd ../../..'
    
    # Git 快捷命令
    alias g='git'
    alias gs='git status'
    alias ga='git add'
    alias gc='git commit'
    alias gp='git push'
    alias gl='git log --oneline --graph --decorate'
    alias gd='git diff'
    
    # Python 开发
    alias py='python3'
    alias pip='python3 -m pip'
    alias venv='python3 -m venv'
    
    # Tmux
    alias t='tmux'
    alias ta='tmux attach'
    alias tl='tmux list-sessions'

    # ========================================================================
    # 实用函数
    # ========================================================================
    
    # mkcd - 创建目录并进入
    function mkcd
        mkdir -p $argv; and cd $argv
    end
    
    # extract - 通用解压函数
    function extract
        if test (count $argv) -eq 0
            echo "Usage: extract <file>"
            return 1
        end
        
        switch $argv[1]
            case '*.tar.bz2'
                tar xjf $argv[1]
            case '*.tar.gz'
                tar xzf $argv[1]
            case '*.bz2'
                bunzip2 $argv[1]
            case '*.rar'
                unrar x $argv[1]
            case '*.gz'
                gunzip $argv[1]
            case '*.tar'
                tar xf $argv[1]
            case '*.tbz2'
                tar xjf $argv[1]
            case '*.tgz'
                tar xzf $argv[1]
            case '*.zip'
                unzip $argv[1]
            case '*.Z'
                uncompress $argv[1]
            case '*.7z'
                7z x $argv[1]
            case '*'
                echo "'$argv[1]' cannot be extracted"
                return 1
        end
    end
    
    # backup - 快速备份文件
    function backup
        if test (count $argv) -eq 0
            echo "Usage: backup <file>"
            return 1
        end
        cp -r $argv[1] $argv[1].backup.(date +%Y%m%d-%H%M%S)
    end
    
    # fcd - 使用 fd 查找目录并进入 (需要 fzf)
    function fcd
        set -l dir (fd --type d | fzf)
        if test -n "$dir"
            cd $dir
        end
    end
    
    # fopen - 使用 fd 查找文件并用 nvim 打开 (需要 fzf)
    function fopen
        set -l file (fd --type f | fzf)
        if test -n "$file"
            $EDITOR $file
        end
    end
    
    # ports - 显示占用端口的进程
    function ports
        if type -q lsof
            sudo lsof -i -P -n | grep LISTEN
        else if type -q netstat
            sudo netstat -tulpn | grep LISTEN
        else
            echo "需要 lsof 或 netstat 命令"
        end
    end

    # ========================================================================
    # Fish 特性配置
    # ========================================================================
    
    # 启用 Vi 模式 (可选，默认使用 Emacs 模式)
    # fish_vi_key_bindings
    
    # 禁用欢迎信息
    set fish_greeting
    
    # 彩色 man 页面
    set -gx LESS_TERMCAP_mb (printf '\e[1;31m')     # begin bold
    set -gx LESS_TERMCAP_md (printf '\e[1;36m')     # begin blink
    set -gx LESS_TERMCAP_me (printf '\e[0m')        # reset bold/blink
    set -gx LESS_TERMCAP_so (printf '\e[01;44;33m') # begin reverse video
    set -gx LESS_TERMCAP_se (printf '\e[0m')        # reset reverse video
    set -gx LESS_TERMCAP_us (printf '\e[1;32m')     # begin underline
    set -gx LESS_TERMCAP_ue (printf '\e[0m')        # reset underline

    # ========================================================================
    # 自动建议和语法高亮 (Fish 内置)
    # ========================================================================
    # Fish 默认启用自动建议和语法高亮
    # 自定义颜色可在 ~/.config/fish/conf.d/ 中配置
    
    # ========================================================================
    # 完成后 Hook (可选)
    # ========================================================================
    # 在这里添加自定义的初始化命令
    
    # 显示系统信息 (可选)
    # type -q fastfetch && fastfetch
end

# ============================================================================
# 非交互式会话配置
# ============================================================================
# 在这里添加非交互式会话需要的配置
