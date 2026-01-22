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

# 💡 安装单个插件的辅助函数
install_plugin_if_missing() {
    local plugin_name="$1"
    local plugin_path="$2"
    
    if ya pkg list 2>/dev/null | grep -q "$plugin_name"; then
        print_info "$plugin_name 已安装"
    else
        print_info "安装 $plugin_name..."
        if ya pkg add "$plugin_path" 2>/dev/null; then
            print_success "已安装: $plugin_name"
        else
            print_warning "安装失败: $plugin_name"
        fi
    fi
}

# 💡 安装插件
install_plugins() {
    if ! command_exists ya; then
        print_warning "ya (Yazi 包管理器) 未找到,跳过插件安装"
        print_info "安装 ya: cargo install yazi-cli"
        return
    fi
    
    print_info "安装 Yazi 插件..."
    
    # 基础插件
    install_plugin_if_missing "piper.yazi" "yazi-rs/plugins:piper"
    install_plugin_if_missing "mux.yazi" "yazi-rs/plugins:mux"
    
    # 高级预览插件
    # 注意: 这些插件可能需要额外的依赖工具
    print_info "安装高级预览插件..."
    
    # Rich 预览 (需要 rich-cli)
    install_plugin_if_missing "rich-preview.yazi" "Reledia/rich-preview.yazi"
    
    # Jupyter Notebook 预览 (需要 nbpreview)
    # ⚠️ 临时禁用: nbpreview 在 Python 3.14 下编译失败
    # install_plugin_if_missing "nbpreview.yazi" "AnirudhG07/nbpreview.yazi"
    
    # DuckDB 数据预览 (需要 duckdb)
    install_plugin_if_missing "duckdb.yazi" "hankertrix/duckdb.yazi"
    
    # 音频元数据预览 (需要 exiftool)
    install_plugin_if_missing "exifaudio.yazi" "Sonico98/exifaudio.yazi"
    
    # 媒体信息预览 (需要 mediainfo)
    install_plugin_if_missing "mediainfo.yazi" "Ape/mediainfo.yazi"
    
    print_success "插件安装完成"
}

# 💡 检查依赖
check_dependencies() {
    print_info "检查依赖工具..."
    
    local missing_tools=()
    local missing_optional=()
    local missing_python=()
    
    # 💡 基础必需工具 (Yazi 核心功能)
    local required_tools=("bat" "glow" "eza" "hexyl")
    for tool in "${required_tools[@]}"; do
        if ! command_exists "$tool"; then
            missing_tools+=("$tool")
        fi
    done
    
    # 💡 预览增强工具 (强烈推荐)
    local preview_tools=("pdftoppm" "pdftotext" "exiftool" "ffmpeg" "mediainfo" "duckdb" "sqlite3")
    local missing_preview=()
    for tool in "${preview_tools[@]}"; do
        if ! command_exists "$tool"; then
            missing_preview+=("$tool")
        fi
    done
    
    # 💡 Python 工具 (通过 uv 安装)
    local python_tools=("rich")  # nbpreview 暂时禁用 (Python 3.14 编译问题)
    for tool in "${python_tools[@]}"; do
        if ! command_exists "$tool"; then
            missing_python+=("$tool")
        fi
    done
    
    # 💡 可选增强工具
    local optional_tools=("fd" "rg" "fzf" "zoxide" "jq")
    for tool in "${optional_tools[@]}"; do
        if ! command_exists "$tool"; then
            missing_optional+=("$tool")
        fi
    done
    
    # 💡 报告缺失的基础工具
    if [ ${#missing_tools[@]} -gt 0 ]; then
        print_warning "缺少以下基础工具: ${missing_tools[*]}"
        read -p "是否安装这些工具? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if command_exists dnf; then
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
                    esac
                done
                eval "$install_cmd"
                print_success "基础工具安装完成"
            fi
        fi
    else
        print_success "所有基础工具已安装"
    fi
    
    # 💡 报告缺失的预览工具
    if [ ${#missing_preview[@]} -gt 0 ]; then
        print_warning "缺少以下预览增强工具: ${missing_preview[*]}"
        print_info "这些工具将增强 PDF、音频、视频等文件的预览体验"
        read -p "是否安装这些工具? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if command_exists dnf; then
                # 构建 Fedora 安装命令
                local preview_install_cmd="sudo dnf install -y"
                for tool in "${missing_preview[@]}"; do
                    case $tool in
                        "pdftoppm"|"pdftotext") preview_install_cmd="$preview_install_cmd poppler-utils" ;;
                        "exiftool") preview_install_cmd="$preview_install_cmd perl-Image-ExifTool" ;;
                        "ffmpeg") preview_install_cmd="$preview_install_cmd ffmpeg" ;;
                        "mediainfo") preview_install_cmd="$preview_install_cmd mediainfo" ;;
                        "duckdb") preview_install_cmd="$preview_install_cmd duckdb" ;;
                        "sqlite3") preview_install_cmd="$preview_install_cmd sqlite" ;;
                    esac
                done
                eval "$preview_install_cmd"
                print_success "预览工具安装完成"
            fi
        fi
    else
        print_success "所有预览增强工具已安装"
    fi
    
    # 💡 报告缺失的 Python 工具
    if [ ${#missing_python[@]} -gt 0 ]; then
        print_warning "缺少以下 Python 工具: ${missing_python[*]}"
        echo
        print_info "这些工具用于高级预览功能:"
        echo "  - rich: 美化 Markdown/JSON/CSV 预览"
        echo "  - nbpreview: Jupyter Notebook 预览"
        echo
        if command_exists uv; then
            read -p "是否使用 uv 安装这些工具? (y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                for tool in "${missing_python[@]}"; do
                    print_info "安装 $tool..."
                    case $tool in
                        "rich") uv tool install rich-cli ;;
                        # "nbpreview") uv tool install nbpreview ;;  # 暂时禁用
                    esac
                done
                print_success "Python 工具安装完成"
            fi
        else
            print_info "建议安装 uv 包管理器: curl -LsSf https://astral.sh/uv/install.sh | sh"
            echo
            print_info "或使用以下命令手动安装:"
            for tool in "${missing_python[@]}"; do
                case $tool in
                    "rich") echo "  uv tool install rich-cli" ;;
                    # "nbpreview") echo "  uv tool install nbpreview" ;;  # 暂时禁用
                esac
            done
        fi
    else
        print_success "所有 Python 工具已安装"
    fi
    
    # 💡 报告可选工具
    if [ ${#missing_optional[@]} -gt 0 ]; then
        print_info "缺少以下可选工具: ${missing_optional[*]}"
        print_info "这些工具可通过以下命令安装:"
        echo "  sudo dnf install ${missing_optional[*]}"
    fi
    
    echo
    print_success "依赖检查完成"
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
