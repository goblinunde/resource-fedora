#!/usr/bin/env bash

################################################################################
# 🚀 Fedora 43 配置部署脚本
# 作者: SMLYFM <yytcjx@gmail.com>
# 用途: 自动化部署系统配置文件，支持全量配置和模块化配置
# 兼容: Fedora 43 Workstation Edition (GNOME 49 + Wayland)
################################################################################

set -euo pipefail  # 💡 严格模式: 遇错退出, 未定义变量报错, 管道错误传播

# ============================= 全局变量 =====================================

# 颜色定义 (ANSI Escape Codes)
readonly COLOR_RESET='\033[0m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_BOLD='\033[1m'

# 路径定义
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly HOME_DIR="${HOME}"
readonly CONFIG_DIR="${HOME}/.config"
readonly BACKUP_DIR="${HOME}/.config-backup-$(date +%Y%m%d-%H%M%S)"

# 配置文件映射关系 (源文件:目标文件)
declare -A CONFIG_FILES=(
    # Shell 配置
    [".bashrc"]="${HOME}/.bashrc"
    [".zshrc"]="${HOME}/.zshrc"
    ["fish"]="${CONFIG_DIR}/fish"
    ["nushell"]="${CONFIG_DIR}/nushell"
    
    # 编辑器配置
    [".vimrc"]="${HOME}/.vimrc"
    ["nvim"]="${CONFIG_DIR}/nvim"
    
    # 终端配置
    [".tmux.conf"]="${HOME}/.tmux.conf"
    
    # 开发工具配置
    [".gitconfig"]="${HOME}/.gitconfig"
    [".condarc"]="${HOME}/.condarc"
    
    # Starship 主题
    ["tokyo-night.toml"]="${CONFIG_DIR}/starship.toml"
)

# ============================= 工具函数 =====================================

# 打印信息
print_info() {
    echo -e "${COLOR_CYAN}ℹ ${COLOR_BOLD}$*${COLOR_RESET}"
}

# 打印成功
print_success() {
    echo -e "${COLOR_GREEN}✔ $*${COLOR_RESET}"
}

# 打印警告
print_warning() {
    echo -e "${COLOR_YELLOW}⚠ $*${COLOR_RESET}"
}

# 打印错误
print_error() {
    echo -e "${COLOR_RED}✘ $*${COLOR_RESET}" >&2
}

# 打印分隔线
print_separator() {
    echo -e "${COLOR_BLUE}$(printf '%.0s─' {1..80})${COLOR_RESET}"
}

# 打印标题
print_header() {
    echo
    print_separator
    echo -e "${COLOR_BOLD}${COLOR_CYAN}  $*${COLOR_RESET}"
    print_separator
    echo
}

# 检查文件是否存在
file_exists() {
    [[ -e "$1" ]]
}

# 创建目录
ensure_dir() {
    if [[ ! -d "$1" ]]; then
        mkdir -p "$1"
        print_success "创建目录: $1"
    fi
}

# 备份文件或目录
backup_file() {
    local target="$1"
    local backup_target="${BACKUP_DIR}/$(basename "$target")"
    
    if file_exists "$target"; then
        ensure_dir "$BACKUP_DIR"
        
        if [[ -d "$target" ]]; then
            cp -r "$target" "$backup_target"
            print_warning "备份目录: $target → $backup_target"
        else
            cp "$target" "$backup_target"
            print_warning "备份文件: $target → $backup_target"
        fi
    fi
}

# 部署单个配置文件
deploy_config() {
    local source="$1"
    local target="$2"
    local source_path="${SCRIPT_DIR}/${source}"
    
    # 检查源文件是否存在
    if ! file_exists "$source_path"; then
        print_error "源文件不存在: $source_path"
        return 1
    fi
    
    # 备份现有配置
    backup_file "$target"
    
    # 部署新配置
    if [[ -d "$source_path" ]]; then
        # 目录: 递归复制
        ensure_dir "$(dirname "$target")"
        cp -r "$source_path" "$target"
        print_success "部署目录: $source → $target"
    else
        # 文件: 直接复制
        ensure_dir "$(dirname "$target")"
        cp "$source_path" "$target"
        print_success "部署文件: $source → $target"
    fi
}

# ============================= 配置部署功能 =================================

# 部署 Bash 配置
deploy_bash() {
    print_header "📦 部署 Bash Shell 配置"
    print_info "用途: 默认系统 Shell，兼容性强"
    print_info "特性: 基础别名、路径配置、环境变量"
    echo
    
    deploy_config ".bashrc" "${CONFIG_FILES[".bashrc"]}"
    
    echo
    print_success "Bash 配置部署完成！"
    print_info "使用方法: 重新打开终端或执行 'source ~/.bashrc'"
}

# 部署 Zsh 配置
deploy_zsh() {
    print_header "📦 部署 Zsh Shell 配置"
    print_info "用途: 主力 Shell，高度定制化 (13KB+ 配置)"
    print_info "框架: Oh-My-Zsh + 主题插件"
    print_info "特性: 智能补全、语法高亮、自动建议"
    echo
    
    # 检查 Zsh 是否安装
    if ! command -v zsh &>/dev/null; then
        print_warning "Zsh 未安装，尝试自动安装..."
        sudo dnf install -y zsh || {
            print_error "Zsh 安装失败，请手动安装: sudo dnf install -y zsh"
            return 1
        }
    fi
    
    # 检查 Oh-My-Zsh 是否安装
    if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
        print_warning "⚠️  未检测到 Oh-My-Zsh 安装"
        print_info "Oh-My-Zsh 是 Zsh 的强大配置框架，建议安装"
        echo
        read -p "$(echo -e "${COLOR_YELLOW}是否现在安装 Oh-My-Zsh? [Y/n]: ${COLOR_RESET}")" -n 1 -r
        echo
        
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            print_info "正在安装 Oh-My-Zsh..."
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || {
                print_error "Oh-My-Zsh 安装失败"
                print_info "请手动安装: sh -c '\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)'"
            }
        else
            print_warning "跳过 Oh-My-Zsh 安装，配置文件可能无法正常工作"
        fi
    else
        print_success "已检测到 Oh-My-Zsh 安装"
    fi
    
    deploy_config ".zshrc" "${CONFIG_FILES[".zshrc"]}"
    
    echo
    print_success "Zsh 配置部署完成！"
    print_info "使用方法: 切换默认 Shell 'chsh -s $(which zsh)'"
    print_info "插件推荐: zsh-autosuggestions, zsh-syntax-highlighting"
}

# 部署 Fish 配置
deploy_fish() {
    print_header "📦 部署 Fish Shell 配置"
    print_info "用途: 现代化友好 Shell，开箱即用"
    print_info "特性: 自动补全、语法高亮、Web 配置界面"
    echo
    
    # 检查 Fish 是否安装
    if ! command -v fish &>/dev/null; then
        print_warning "Fish 未安装，尝试自动安装..."
        sudo dnf install -y fish || {
            print_error "Fish 安装失败，请手动安装: sudo dnf install -y fish"
            return 1
        }
    fi
    
    deploy_config "fish" "${CONFIG_FILES["fish"]}"
    
    echo
    print_success "Fish 配置部署完成！"
    print_info "使用方法: 切换默认 Shell 'chsh -s $(which fish)'"
    print_info "配置界面: 执行 'fish_config' 打开 Web 配置"
}

# 部署 Nushell 配置
deploy_nushell() {
    print_header "📦 部署 Nushell 配置"
    print_info "用途: 结构化数据处理 Shell，跨平台一致性"
    print_info "特性: 数据管道优先、内置表格处理、现代化语法"
    echo
    
    # 检查 Nushell 是否安装
    if ! command -v nu &>/dev/null; then
        print_warning "Nushell 未安装，尝试自动安装..."
        sudo dnf install -y nushell || {
            print_error "Nushell 安装失败，请手动安装: sudo dnf install -y nushell"
            return 1
        }
    fi
    
    deploy_config "nushell" "${CONFIG_FILES["nushell"]}"
    
    echo
    print_success "Nushell 配置部署完成！"
    print_info "使用方法: 执行 'nu' 进入 Nushell"
}

# 部署 Vim 配置
deploy_vim() {
    print_header "📦 部署 Vim 编辑器配置"
    print_info "用途: 轻量级编辑器，服务器环境首选 (15KB+ 配置)"
    print_info "特性: 插件管理、语法高亮、自定义快捷键"
    echo
    
    # 检查 Vim 是否安装
    if ! command -v vim &>/dev/null; then
        print_warning "Vim 未安装，尝试自动安装..."
        sudo dnf install -y vim || {
            print_error "Vim 安装失败，请手动安装: sudo dnf install -y vim"
            return 1
        }
    fi
    
    deploy_config ".vimrc" "${CONFIG_FILES[".vimrc"]}"
    
    echo
    print_success "Vim 配置部署完成！"
    print_info "使用方法: 打开 Vim 后执行 ':PlugInstall' 安装插件"
}

# 部署 Neovim 配置
deploy_nvim() {
    print_header "📦 部署 Neovim (LazyVim) 配置"
    print_info "用途: 现代化开发环境，LSP 支持"
    print_info "特性: LazyVim 框架、多主题、Python/Rust/LaTeX 支持"
    echo
    
    # 检查 Neovim 是否安装
    if ! command -v nvim &>/dev/null; then
        print_warning "Neovim 未安装，尝试自动安装..."
        sudo dnf install -y neovim || {
            print_error "Neovim 安装失败，请手动安装: sudo dnf install -y neovim"
            return 1
        }
    fi
    
    deploy_config "nvim" "${CONFIG_FILES["nvim"]}"
    
    echo
    print_success "Neovim 配置部署完成！"
    print_info "使用方法: 执行 'nvim' 启动，首次启动会自动安装插件"
    print_info "详细文档: 查看 nvim/README.md"
}

# 部署 Tmux 配置
deploy_tmux() {
    print_header "📦 部署 Tmux 终端复用器配置"
    print_info "用途: 终端会话管理，远程连接必备 (7.6KB 配置)"
    print_info "特性: TPM 插件管理、自定义状态栏、鼠标支持"
    echo
    
    # 检查 Tmux 是否安装
    if ! command -v tmux &>/dev/null; then
        print_warning "Tmux 未安装，尝试自动安装..."
        sudo dnf install -y tmux || {
            print_error "Tmux 安装失败，请手动安装: sudo dnf install -y tmux"
            return 1
        }
    fi
    
    deploy_config ".tmux.conf" "${CONFIG_FILES[".tmux.conf"]}"
    
    echo
    print_success "Tmux 配置部署完成！"
    print_info "使用方法: 执行 'tmux' 启动"
    print_info "安装插件: 在 Tmux 中按 'Prefix + I' (默认 Prefix 为 Ctrl+b)"
}

# 部署 Git 配置
deploy_git() {
    print_header "📦 部署 Git 配置"
    print_info "用途: 版本控制系统全局配置"
    print_info "特性: Git LFS、SOCKS5 代理、默认分支 main"
    echo
    
    print_warning "⚠️  检测到个人配置信息！"
    print_warning "├─ 用户名: SMLYFM"
    print_warning "├─ 邮箱: yytcjx@gmail.com"
    print_warning "└─ 代理: socks5://127.0.0.1:10808"
    echo
    
    read -p "$(echo -e "${COLOR_YELLOW}是否继续部署 Git 配置? [y/N]: ${COLOR_RESET}")" -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "已取消 Git 配置部署"
        print_info "建议: 手动编辑 .gitconfig 文件修改个人信息后部署"
        return 0
    fi
    
    deploy_config ".gitconfig" "${CONFIG_FILES[".gitconfig"]}"
    deploy_config ".condarc" "${CONFIG_FILES[".condarc"]}"
    
    echo
    print_success "Git 配置部署完成！"
    print_info "验证配置: git config --list"
    print_warning "提醒: 如需修改个人信息，请编辑 ~/.gitconfig"
}

# 部署 Starship 主题
deploy_starship() {
    print_header "📦 部署 Starship 主题 (Tokyo Night)"
    print_info "用途: 跨 Shell 提示符 (Bash/Fish/Nushell)"
    print_info "配色: Tokyo Night"
    print_info "注意: Zsh 使用 Oh-My-Zsh 框架，不需要 Starship"
    echo
    
    # 检查 Starship 是否安装
    if ! command -v starship &>/dev/null; then
        print_warning "Starship 未安装，尝试自动安装..."
        sudo dnf install -y starship || {
            print_error "Starship 安装失败，请手动安装:"
            print_error "方法 1 (DNF): sudo dnf install -y starship"
            print_error "方法 2 (官方脚本): curl -sS https://starship.rs/install.sh | sh"
            return 1
        }
    fi
    
    deploy_config "tokyo-night.toml" "${CONFIG_FILES["tokyo-night.toml"]}"
    
    echo
    print_success "Starship 主题部署完成！"
    print_info "适用 Shell: Bash, Fish, Nushell"
    print_info "配置位置: ~/.config/starship.toml"
    echo
    print_info "使用方法:"
    print_info "├─ Bash: 在 ~/.bashrc 末尾添加 'eval \"\$(starship init bash)\"'"
    print_info "├─ Fish: 在 ~/.config/fish/config.fish 添加 'starship init fish | source'"
    print_info "└─ Nushell: 在 config.nu 添加 Starship 初始化配置"
    echo
    print_warning "注意事项:"
    print_warning "1. 需要安装 Nerd Font 字体以正确显示图标"
    print_warning "   推荐字体: JetBrains Mono Nerd Font, 0xProto Nerd Font"
    print_warning "   安装命令: sudo dnf install -y jetbrains-mono-fonts-all"
    print_warning "2. Zsh 用户请使用 Oh-My-Zsh 框架，无需 Starship"
}

# 部署 Ruff 配置 (Python Linter/Formatter)
deploy_ruff() {
    print_header "📦 部署 Ruff Python 工具配置"
    print_info "用途: 快速 Python Linter 和 Formatter"
    print_info "配置: Ruff 全局配置文件"
    echo
    
    # 检查 Ruff 是否安装
    if ! command -v ruff &>/dev/null; then
        print_warning "⚠️  Ruff 未安装"
        print_info "Ruff 是现代化的 Python Linter/Formatter，速度极快"
        echo
        print_info "安装方法:"
        print_info "方法 1 (DNF):    sudo dnf install -y ruff"
        print_info "方法 2 (pipx):   pipx install ruff"
        print_info "方法 3 (pip):    pip install ruff"
        echo
        read -p "$(echo -e "${COLOR_YELLOW}是否通过 DNF 安装 Ruff? [y/N]: ${COLOR_RESET}")" -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo dnf install -y ruff || {
                print_error "Ruff 安装失败，请手动安装"
            }
        else
            print_warning "跳过 Ruff 安装"
        fi
    else
        print_success "已检测到 Ruff 安装: $(ruff --version)"
    fi
    
    # 检查并部署 ruff 配置
    if file_exists "${SCRIPT_DIR}/ruff"; then
        deploy_config "ruff" "${CONFIG_DIR}/ruff"
        print_success "Ruff 配置部署完成！"
    else
        print_info "未找到 Ruff 配置文件，跳过配置部署"
    fi
}

# 引导安装 Conda/Mamba
deploy_conda_tools() {
    print_header "📦 Conda/Mamba Python 包管理工具"
    print_info "用途: Python 环境和包管理"
    print_info "推荐: Mamba (Miniforge) - 比 Conda 更快"
    echo
    
    # 检查是否已安装
    local has_conda=false
    local has_mamba=false
    
    if command -v conda &>/dev/null; then
        has_conda=true
        print_success "已检测到 Conda: $(conda --version)"
    fi
    
    if command -v mamba &>/dev/null; then
        has_mamba=true
        print_success "已检测到 Mamba: $(mamba --version)"
    fi
    
    if [[ "$has_conda" == "true" ]] || [[ "$has_mamba" == "true" ]]; then
        echo
        # 部署 .condarc 配置
        if file_exists "${SCRIPT_DIR}/.condarc"; then
            deploy_config ".condarc" "${CONFIG_FILES[".condarc"]}"
            print_success "Conda 配置文件部署完成！"
        fi
        return 0
    fi
    
    # 未安装，提供安装引导
    print_warning "⚠️  未检测到 Conda/Mamba 安装"
    echo
    print_info "推荐安装选项:"
    echo
    print_info "${COLOR_BOLD}选项 1: Miniforge (Mamba)${COLOR_RESET} ${COLOR_GREEN}[推荐]${COLOR_RESET}"
    print_info "  - 速度快，社区驱动"
    print_info "  - 默认使用 conda-forge 源"
    print_info "  - 安装命令:"
    echo -e "    ${COLOR_CYAN}curl -L -O https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh${COLOR_RESET}"
    echo -e "    ${COLOR_CYAN}bash Miniforge3-Linux-x86_64.sh${COLOR_RESET}"
    echo
    print_info "${COLOR_BOLD}选项 2: Miniconda (官方精简版)${COLOR_RESET}"
    print_info "  - 官方维护，体积小"
    print_info "  - 安装命令:"
    echo -e "    ${COLOR_CYAN}curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh${COLOR_RESET}"
    echo -e "    ${COLOR_CYAN}bash Miniconda3-latest-Linux-x86_64.sh${COLOR_RESET}"
    echo
    print_info "安装后请重新运行此脚本部署 .condarc 配置文件"
}

# ============================= 主菜单功能 ===================================

# 显示帮助信息
show_help() {
    cat <<EOF
${COLOR_BOLD}${COLOR_CYAN}🚀 Fedora 43 配置部署脚本${COLOR_RESET}
${COLOR_BOLD}用法:${COLOR_RESET}
    bash setup.sh [选项]

${COLOR_BOLD}选项:${COLOR_RESET}
    ${COLOR_GREEN}--all${COLOR_RESET}                   一键部署所有配置 (推荐初次使用)
    
    ${COLOR_GREEN}--shell ${COLOR_YELLOW}<type>${COLOR_RESET}          部署指定 Shell 配置
                            类型: bash, zsh, fish, nushell
                            
    ${COLOR_GREEN}--editor ${COLOR_YELLOW}<type>${COLOR_RESET}         部署指定编辑器配置
                            类型: vim, nvim
                            
    ${COLOR_GREEN}--tmux${COLOR_RESET}                  部署 Tmux 配置
    ${COLOR_GREEN}--git${COLOR_RESET}                   部署 Git 配置 (需确认个人信息)
    ${COLOR_GREEN}--starship${COLOR_RESET}              部署 Starship 主题
    
    ${COLOR_GREEN}--interactive${COLOR_RESET}           交互式菜单 (逐项选择)
    ${COLOR_GREEN}--help, -h${COLOR_RESET}              显示此帮助信息

${COLOR_BOLD}使用示例:${COLOR_RESET}
    # 一键全量配置
    bash setup.sh --all
    
    # 仅配置 Zsh
    bash setup.sh --shell zsh
    
    # 配置 Neovim + Tmux
    bash setup.sh --editor nvim --tmux
    
    # 交互式选择
    bash setup.sh --interactive

${COLOR_BOLD}备份说明:${COLOR_RESET}
    所有现有配置会自动备份到: ~/.config-backup-<timestamp>/
    恢复方法: cp ~/.config-backup-*/file ~/

${COLOR_BOLD}更多信息:${COLOR_RESET}
    项目地址: https://github.com/goblinunde/resource-fedora
    作者: SMLYFM <yytcjx@gmail.com>
EOF
}

# 交互式菜单
interactive_mode() {
    print_header "🎯 交互式配置菜单"
    
    while true; do
        echo
        echo -e "${COLOR_BOLD}选择要部署的配置:${COLOR_RESET}"
        echo -e "  ${COLOR_GREEN}1)${COLOR_RESET} Bash Shell"
        echo -e "  ${COLOR_GREEN}2)${COLOR_RESET} Zsh Shell (Oh-My-Zsh)"
        echo -e "  ${COLOR_GREEN}3)${COLOR_RESET} Fish Shell"
        echo -e "  ${COLOR_GREEN}4)${COLOR_RESET} Nushell"
        echo -e "  ${COLOR_GREEN}5)${COLOR_RESET} Vim 编辑器"
        echo -e "  ${COLOR_GREEN}6)${COLOR_RESET} Neovim (LazyVim)"
        echo -e "  ${COLOR_GREEN}7)${COLOR_RESET} Tmux 终端复用器"
        echo -e "  ${COLOR_GREEN}8)${COLOR_RESET} Git 配置"
        echo -e "  ${COLOR_GREEN}9)${COLOR_RESET} Starship 主题 (Bash/Fish/Nushell)"
        echo -e "  ${COLOR_GREEN}r)${COLOR_RESET} Ruff (Python Linter)"
        echo -e "  ${COLOR_GREEN}c)${COLOR_RESET} Conda/Mamba 引导"
        echo -e "  ${COLOR_BLUE}a)${COLOR_RESET} 全部部署"
        echo -e "  ${COLOR_RED}q)${COLOR_RESET} 退出"
        echo
        
        read -p "$(echo -e "${COLOR_CYAN}请输入选项 [1-9/r/c/a/q]: ${COLOR_RESET}")" -n 1 -r choice
        echo
        
        case "$choice" in
            1) deploy_bash ;;
            2) deploy_zsh ;;
            3) deploy_fish ;;
            4) deploy_nushell ;;
            5) deploy_vim ;;
            6) deploy_nvim ;;
            7) deploy_tmux ;;
            8) deploy_git ;;
            9) deploy_starship ;;
            r|R) deploy_ruff ;;
            c|C) deploy_conda_tools ;;
            a|A) deploy_all; break ;;
            q|Q) print_info "退出脚本"; exit 0 ;;
            *) print_error "无效选项，请重新选择" ;;
        esac
        
        echo
        read -p "$(echo -e "${COLOR_CYAN}按 Enter 继续...${COLOR_RESET}")"
    done
}

# 部署所有配置
deploy_all() {
    print_header "🚀 一键部署所有配置"
    print_info "这将部署以下所有配置:"
    print_info "├─ Shell: Bash, Zsh (Oh-My-Zsh), Fish, Nushell"
    print_info "├─ 编辑器: Vim, Neovim (LazyVim)"
    print_info "├─ 终端: Tmux"
    print_info "├─ 开发工具: Git, Conda, Ruff"
    print_info "└─ 主题: Starship (Tokyo Night)"
    echo
    
    read -p "$(echo -e "${COLOR_YELLOW}确认部署? [y/N]: ${COLOR_RESET}")" -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "已取消部署"
        exit 0
    fi
    
    # 依次部署所有配置
    deploy_bash
    deploy_zsh
    deploy_fish
    deploy_nushell
    deploy_vim
    deploy_nvim
    deploy_tmux
    deploy_git
    deploy_starship
    deploy_ruff
    deploy_conda_tools
    
    # 显示总结
    print_header "✅ 所有配置部署完成"
    print_success "配置备份位置: $BACKUP_DIR"
    echo
    print_info "后续步骤:"
    print_info "1. 重新打开终端或执行 'source ~/.bashrc' (或对应 Shell 配置)"
    print_info "2. 对于 Vim: 打开后执行 ':PlugInstall' 安装插件"
    print_info "3. 对于 Neovim: 首次打开会自动安装插件"
    print_info "4. 对于 Tmux: 启动后按 'Prefix + I' 安装插件"
    print_info "5. 检查 Git 配置并根据需要修改个人信息"
    print_info "6. 如需要 Starship: 添加初始化命令到对应 Shell 配置"
    echo
    print_success "享受你的新配置！ 🎉"
}

# ============================= 主程序入口 ===================================

main() {
    # 显示欢迎信息
    clear
    echo -e "${COLOR_BOLD}${COLOR_CYAN}"
    cat <<'EOF'
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║     🚀 Fedora 43 配置部署脚本                                              ║
║     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━                                      ║
║                                                                           ║
║     一键部署 Shell、编辑器、终端和开发工具配置                              ║
║     支持 Bash, Zsh, Fish, Nushell, Vim, Neovim, Tmux, Git, Starship      ║
║                                                                           ║
║     作者: SMLYFM <yytcjx@gmail.com>                                       ║
║     仓库: https://github.com/goblinunde/resource-fedora                   ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${COLOR_RESET}"
    
    # 检查参数
    if [[ $# -eq 0 ]]; then
        show_help
        exit 0
    fi
    
    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --all)
                deploy_all
                exit 0
                ;;
            --shell)
                shift
                case "${1:-}" in
                    bash) deploy_bash ;;
                    zsh) deploy_zsh ;;
                    fish) deploy_fish ;;
                    nushell) deploy_nushell ;;
                    *)
                        print_error "无效的 Shell 类型: ${1:-未指定}"
                        print_info "支持的类型: bash, zsh, fish, nushell"
                        exit 1
                        ;;
                esac
                shift
                ;;
            --editor)
                shift
                case "${1:-}" in
                    vim) deploy_vim ;;
                    nvim) deploy_nvim ;;
                    *)
                        print_error "无效的编辑器类型: ${1:-未指定}"
                        print_info "支持的类型: vim, nvim"
                        exit 1
                        ;;
                esac
                shift
                ;;
            --tmux)
                deploy_tmux
                shift
                ;;
            --git)
                deploy_git
                shift
                ;;
            --starship)
                deploy_starship
                shift
                ;;
            --interactive)
                interactive_mode
                exit 0
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                print_error "未知选项: $1"
                echo
                show_help
                exit 1
                ;;
        esac
    done
    
    # 显示完成信息
    echo
    print_separator
    print_success "配置部署完成！备份位置: $BACKUP_DIR"
    print_separator
}

# 执行主程序
main "$@"
