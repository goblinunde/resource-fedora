#!/usr/bin/env bash
# ============================================
# Yazi 配置安装脚本
# ============================================

set -e  # 遇到错误立即退出

# 💡 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 💡 配置目录
YAZI_CONFIG_DIR="$HOME/.config/yazi"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 💡 打印函数
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[成功]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[警告]${NC} $1"
}

print_error() {
    echo -e "${RED}[错误]${NC} $1"
}

# 💡 检查命令是否存在
command_exists() {
    command -v "$1" &> /dev/null
}

# 💡 安装 Yazi
install_yazi() {
    if ! command_exists yazi; then
        print_warning "Yazi 未安装"
        read -p "是否安装 Yazi? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if command_exists dnf; then
                print_info "使用 dnf 安装 Yazi..."
                sudo dnf install -y yazi
            elif command_exists cargo; then
                print_info "使用 Cargo 安装 Yazi..."
                cargo install --locked yazi-fm yazi-cli
            else
                print_error "无法找到包管理器。请手动安装 Yazi。"
                exit 1
            fi
            print_success "Yazi 安装完成"
        else
            print_error "Yazi 未安装,退出。"
            exit 1
        fi
    else
        print_success "Yazi 已安装: $(yazi --version)"
    fi
}

# 💡 创建配置目录
create_config_dir() {
    if [ ! -d "$YAZI_CONFIG_DIR" ]; then
        print_info "创建配置目录: $YAZI_CONFIG_DIR"
        mkdir -p "$YAZI_CONFIG_DIR/plugins"
        print_success "配置目录创建完成"
    else
        print_info "配置目录已存在: $YAZI_CONFIG_DIR"
    fi
}

# 💡 备份现有配置
backup_existing_config() {
    local backup_dir="$YAZI_CONFIG_DIR.backup.$(date +%Y%m%d_%H%M%S)"
    
    if [ -f "$YAZI_CONFIG_DIR/yazi.toml" ] || \
       [ -f "$YAZI_CONFIG_DIR/keymap.toml" ] || \
       [ -f "$YAZI_CONFIG_DIR/theme.toml" ] || \
       [ -f "$YAZI_CONFIG_DIR/init.lua" ]; then
        print_warning "检测到现有配置文件"
        read -p "是否备份现有配置? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "备份配置到: $backup_dir"
            cp -r "$YAZI_CONFIG_DIR" "$backup_dir"
            print_success "备份完成"
        fi
    fi
}

# 💡 复制配置文件
copy_config_files() {
    print_info "复制配置文件..."
    
    cp "$SCRIPT_DIR/yazi.toml" "$YAZI_CONFIG_DIR/" && \
        print_success "已复制: yazi.toml"
    
    cp "$SCRIPT_DIR/keymap.toml" "$YAZI_CONFIG_DIR/" && \
        print_success "已复制: keymap.toml"
    
    cp "$SCRIPT_DIR/theme.toml" "$YAZI_CONFIG_DIR/" && \
        print_success "已复制: theme.toml"
    
    cp "$SCRIPT_DIR/init.lua" "$YAZI_CONFIG_DIR/" && \
        print_success "已复制: init.lua"
}

# 💡 安装插件
install_plugins() {
    if ! command_exists ya; then
        print_warning "ya (Yazi 包管理器) 未找到,跳过插件安装"
        return
    fi
    
    print_info "安装插件..."
    
    # 安装 piper.yazi
    if ya pkg list | grep -q "piper.yazi"; then
        print_info "piper.yazi 已安装"
    else
        print_info "安装 piper.yazi..."
        ya pkg add yazi-rs/plugins:piper && \
            print_success "已安装: piper.yazi"
    fi
    
    # 安装 mux.yazi
    if ya pkg list | grep -q "mux.yazi"; then
        print_info "mux.yazi 已安装"
    else
        print_info "安装 mux.yazi..."
        ya pkg add peterfication/mux && \
            print_success "已安装: mux.yazi"
    fi
}

# 💡 检查依赖
check_dependencies() {
    print_info "检查依赖工具..."
    
    local missing_tools=()
    
    # 必需工具
    local required_tools=("bat" "glow" "eza" "hexyl")
    for tool in "${required_tools[@]}"; do
        if ! command_exists "$tool"; then
            missing_tools+=("$tool")
        fi
    done
    
    # 可选工具
    local optional_tools=("mediainfo" "exiftool" "fd" "rg" "fzf" "zoxide" "sqlite3")
    local missing_optional=()
    for tool in "${optional_tools[@]}"; do
        if ! command_exists "$tool"; then
            missing_optional+=("$tool")
        fi
    done
    
    # PDF 预览工具
    if ! command_exists pdftoppm; then
        missing_tools+=("poppler-utils")
    fi
    
    # 报告缺失工具
    if [ ${#missing_tools[@]} -gt 0 ]; then
        print_warning "缺少以下必需工具: ${missing_tools[*]}"
        read -p "是否安装这些工具? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if command_exists dnf; then
                # 构建安装命令
                local install_cmd="sudo dnf install -y"
                for tool in "${missing_tools[@]}"; do
                    case $tool in
                        "bat") install_cmd="$install_cmd bat" ;;
                        "glow") install_cmd="$install_cmd glow" ;;
                        "eza") 
                            print_info "eza 需要通过 Cargo 安装"
                            if command_exists cargo; then
                                cargo install eza
                            fi
                            ;;
                        "hexyl") install_cmd="$install_cmd hexyl" ;;
                        "poppler-utils") install_cmd="$install_cmd poppler-utils" ;;
                    esac
                done
                eval "$install_cmd"
                print_success "必需工具安装完成"
            fi
        fi
    else
        print_success "所有必需工具已安装"
    fi
    
    if [ ${#missing_optional[@]} -gt 0 ]; then
        print_info "缺少以下可选工具: ${missing_optional[*]}"
        print_info "这些工具可通过以下命令安装:"
        echo "  sudo dnf install ${missing_optional[*]}"
    fi
}

# 💡 主函数
main() {
    echo "========================================"
    echo "    Yazi 配置安装脚本"
    echo "========================================"
    echo
    
    # 1. 安装 Yazi
    install_yazi
    
    # 2. 创建配置目录
    create_config_dir
    
    # 3. 备份现有配置
    backup_existing_config
    
    # 4. 复制配置文件
    copy_config_files
    
    # 5. 安装插件
    install_plugins
    
    # 6. 检查依赖
    check_dependencies
    
    echo
    echo "========================================"
    print_success "Yazi 配置安装完成!"
    echo "========================================"
    echo
    print_info "配置文件位置: $YAZI_CONFIG_DIR"
    print_info "启动 Yazi: yazi"
    print_info "查看帮助: yazi 后按 ~ 或 F1"
    print_info "详细文档: $SCRIPT_DIR/YAZI_CONFIG_GUIDE.md"
    echo
}

# 运行主函数
main
