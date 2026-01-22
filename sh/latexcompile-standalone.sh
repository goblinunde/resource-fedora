#!/bin/zsh

# ==============================================================================
#
#   latexcompile-standalone.sh - LaTeX 交互式编译脚本 (单文件版 v6.0)
#
#   特性：
#   - 7种主题配色方案
#   - 编译历史记录
#   - 快速重编译
#   - 字数统计
#   - 配置管理
#   - 纯ASCII图标，无Emoji依赖
#
# ==============================================================================

readonly SCRIPT_VERSION="6.0-standalone"

# ============================================================================== 
# SECTION 1: 主题系统
# ==============================================================================

# 主题定义
typeset -A THEME_DEFAULT=(
    [PRIMARY]="0,122,204"
    [SUCCESS]="0,150,0"
    [WARNING]="255,193,7"
    [ERROR]="220,53,69"
    [ACCENT]="156,39,176"
    [CYAN]="23,162,184"
)

typeset -A THEME_NORD=(
    [PRIMARY]="136,192,208"
    [SUCCESS]="163,190,140"
    [WARNING]="235,203,139"
    [ERROR]="191,97,106"
    [ACCENT]="180,142,173"
    [CYAN]="129,161,193"
)

typeset -A THEME_DRACULA=(
    [PRIMARY]="189,147,249"
    [SUCCESS]="80,250,123"
    [WARNING]="241,250,140"
    [ERROR]="255,85,85"
    [ACCENT]="255,121,198"
    [CYAN]="139,233,253"
)

typeset -A THEME_SAKURA=(
    [PRIMARY]="255,182,193"
    [SUCCESS]="152,251,152"
    [WARNING]="255,218,185"
    [ERROR]="255,105,180"
    [ACCENT]="221,160,221"
    [CYAN]="175,238,238"
)

typeset -A THEME_MATRIX=(
    [PRIMARY]="0,255,0"
    [SUCCESS]="50,205,50"
    [WARNING]="173,255,47"
    [ERROR]="0,255,127"
    [ACCENT]="124,252,0"
    [CYAN]="127,255,212"
)

typeset -A THEME_GRUVBOX=(
    [PRIMARY]="251,184,108"
    [SUCCESS]="184,187,38"
    [WARNING]="250,189,47"
    [ERROR]="251,73,52"
    [ACCENT]="211,134,155"
    [CYAN]="142,192,124"
)

typeset -A THEME_MONOKAI=(
    [PRIMARY]="102,217,239"
    [SUCCESS]="166,226,46"
    [WARNING]="253,151,31"
    [ERROR]="249,38,114"
    [ACCENT]="174,129,255"
    [CYAN]="102,217,239"
)

rgb_to_ansi() {
    local rgb="$1"
    local r g b
    IFS=',' read -r r g b <<< "$rgb"
    echo "\033[38;2;${r};${g};${b}m"
}

load_theme() {
    local theme_name="${1:u}"
    local theme_array_name="THEME_${theme_name}"
    
    if ! typeset -p "$theme_array_name" &>/dev/null; then
        theme_array_name="THEME_DEFAULT"
    fi
    
    local -A theme_data
    eval "theme_data=(\${(kv)${theme_array_name}})"
    
    C_PRIMARY=$(rgb_to_ansi "${theme_data[PRIMARY]}")
    C_SUCCESS=$(rgb_to_ansi "${theme_data[SUCCESS]}")
    C_WARNING=$(rgb_to_ansi "${theme_data[WARNING]}")
    C_ERROR=$(rgb_to_ansi "${theme_data[ERROR]}")
    C_ACCENT=$(rgb_to_ansi "${theme_data[ACCENT]}")
    C_CYAN=$(rgb_to_ansi "${theme_data[CYAN]}")
    
    C_RED="$C_ERROR"
    C_GREEN="$C_SUCCESS"
    C_YELLOW="$C_WARNING"
    C_BLUE="$C_PRIMARY"
    C_PURPLE="$C_ACCENT"
    
    C_BOLD='\033[1m'
    C_DIM='\033[2m'
    C_RESET='\033[0m'
    
    export C_PRIMARY C_SUCCESS C_WARNING C_ERROR C_ACCENT C_CYAN
    export C_RED C_GREEN C_YELLOW C_BLUE C_PURPLE
    export C_BOLD C_DIM C_RESET
}

list_themes() {
    echo ""
    echo -e "${C_BOLD}Available Themes:${C_RESET}"
    echo ""
    echo "  1. default   - Original color scheme"
    echo "  2. nord      - Nordic aurora (cool tones)"
    echo "  3. dracula   - Dracula vampire (purple/pink)"
    echo "  4. sakura    - Cherry blossom (warm pink)"
    echo "  5. matrix    - Matrix hacker (green)"
    echo "  6. gruvbox   - Retro warm colors"
    echo "  7. monokai   - Classic dark theme"
    echo ""
}

preview_theme() {
    local theme_name="$1"
    load_theme "$theme_name"
    
    echo ""
    echo -e "${C_BOLD}=== Theme Preview: ${theme_name} ===${C_RESET}"
    echo ""
    echo -e "  ${C_PRIMARY}[*]${C_RESET} PRIMARY   - Main UI elements"
    echo -e "  ${C_SUCCESS}[*]${C_RESET} SUCCESS   - Compilation success"
    echo -e "  ${C_WARNING}[*]${C_RESET} WARNING   - Warnings and prompts"
    echo -e "  ${C_ERROR}[*]${C_RESET} ERROR     - Error messages"
    echo -e "  ${C_ACCENT}[*]${C_RESET} ACCENT    - Decorative highlights"
    echo -e "  ${C_CYAN}[*]${C_RESET} CYAN      - Information text"
    echo ""
}

# ==============================================================================
# SECTION 2: UI组件
# ==============================================================================

get_term_width() {
    tput cols 2>/dev/null || echo 80
}

repeat_char() {
    local char="$1"
    local count="$2"
    printf "%${count}s" | tr ' ' "$char"
}

draw_separator() {
    local char="${1:-=}"
    local color="${2:-$C_PRIMARY}"
    local term_width=$(get_term_width)
    echo -e "${color}$(repeat_char "$char" $term_width)${C_RESET}"
}

draw_header() {
    local title="$1"
    local subtitle="$2"
    local term_width=$(get_term_width)
    
    echo ""
    draw_separator "=" "$C_PRIMARY"
    
    # 计算标题居中
    local title_text="* ${title} *"
    local padding=$(( (term_width - ${#title_text}) / 2 ))
    printf "%${padding}s" ""
    echo -e "${C_BOLD}${C_ACCENT}*${C_RESET} ${C_BOLD}${title}${C_RESET} ${C_ACCENT}*${C_RESET}"
    
    if [[ -n "$subtitle" ]]; then
        local sub_padding=$(( (term_width - ${#subtitle}) / 2 ))
        printf "%${sub_padding}s" ""
        echo -e "${C_DIM}${subtitle}${C_RESET}"
    fi
    draw_separator "=" "$C_PRIMARY"
    echo ""
}

print_success() {
    echo -e "${C_SUCCESS}[OK]${C_RESET} ${C_BOLD}$@${C_RESET}"
}

print_error() {
    echo -e "${C_ERROR}[X]${C_RESET} ${C_BOLD}$@${C_RESET}"
}

print_warning() {
    echo -e "${C_WARNING}[!]${C_RESET} ${C_BOLD}$@${C_RESET}"
}

print_info() {
    echo -e "${C_CYAN}[i]${C_RESET} $@"
}

prompt_confirm() {
    local message="$1"
    local default="${2:-n}"
    
    local prompt="${C_WARNING}>${C_RESET} ${message} "
    if [[ "$default" == "y" ]]; then
        prompt+="${C_DIM}[Y/n]${C_RESET} "
    else
        prompt+="${C_DIM}[y/N]${C_RESET} "
    fi
    
    echo -en "$prompt"
    read -q REPLY
    echo
    
    if [[ -z "$REPLY" ]]; then
        [[ "$default" == "y" ]] && return 0 || return 1
    fi
    
    [[ "$REPLY" =~ ^[Yy]$ ]] && return 0 || return 1
}

draw_table_2col() {
    local -a rows=("$@")
    local max_key_len=0
    
    for row in "${rows[@]}"; do
        local key="${row%%:*}"
        [[ ${#key} -gt $max_key_len ]] && max_key_len=${#key}
    done
    
    for row in "${rows[@]}"; do
        local key="${row%%:*}"
        local value="${row#*:}"
        local padding=$((max_key_len - ${#key} + 2))
        echo -e "  ${C_ACCENT}${key}${C_RESET}$(repeat_char ' ' $padding): ${C_BOLD}${value}${C_RESET}"
    done
}

show_compile_status() {
    local file="$1"
    local engine="$2"
    echo ""
    draw_separator "=" "$C_CYAN"
    echo -e "${C_BOLD}Compiling:${C_RESET} ${C_ACCENT}${file}${C_RESET} ${C_DIM}with${C_RESET} ${C_PRIMARY}${engine}${C_RESET}"
    draw_separator "=" "$C_CYAN"
}

show_logo() {
    local version="${1:-v6.0}"
    echo ""
    echo -e "${C_ACCENT}"
    cat << 'EOF'
    ╔╦╗╔═╗═╗ ╦  ╔═╗┌─┐┌┬┐┌─┐┬┬  ┌─┐┬─┐
     ║ ║╣ ╔╩╦╝  ║  │ ││││├─┘││  ├┤ ├┬┘
     ╩ ╚═╝╩ ╚═  ╚═╝└─┘┴ ┴┴  ┴┴─┘└─┘┴└─
EOF
    echo -e "${C_RESET}"
    local term_width=$(get_term_width)
    local text="Professional LaTeX Compilation Tool ${version}"
    local padding=$(( (term_width - ${#text}) / 2 ))
    printf "%${padding}s${C_DIM}%s${C_RESET}\n\n" "" "$text"
}

# 编译进度动画
show_compile_progress() {
    local message="$1"
    local pid="$2"
    
    local spinners=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local i=0
    
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r${C_CYAN}${spinners[$i]}${C_RESET} ${message}..."
        i=$(( (i + 1) % ${#spinners[@]} ))
        sleep 0.1
    done
    
    printf "\r%*s\r" 60 ""  # 清除行
}

# 编译进度条
show_compile_bar() {
    local current="$1"
    local total="$2"
    local width=40
    
    local percentage=$(( current * 100 / total ))
    local filled=$(( width * current / total ))
    local empty=$(( width - filled ))
    
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done
    
    printf "\r${C_ACCENT}[${bar}]${C_RESET} ${C_BOLD}${percentage}%%${C_RESET} (${current}/${total})"
}

# ==============================================================================
# SECTION 3: 配置管理
# ==============================================================================

CONFIG_FILE=".latexcfg"
USER_CONFIG="$HOME/.latexrc"
HISTORY_FILE="$HOME/.latex_history"

CFG_DEFAULT_ENGINE="xelatex"
CFG_AUTO_CLEANUP=false
CFG_EDITOR="nvim"
CFG_AUTO_OPEN_PDF=true
CFG_ACTIVE_THEME="nord"
CFG_ENABLE_HISTORY=true
CFG_MAX_HISTORY=10
CFG_PDF_VIEWER=""

# 💡 项目级配置变量 - 用于覆盖全局配置
PRJ_DEFAULT_ENGINE=""
PRJ_AUTO_CLEANUP=""
PRJ_EDITOR=""
PRJ_AUTO_OPEN_PDF=""
PRJ_ACTIVE_THEME=""
PRJ_ENABLE_HISTORY=""
PRJ_MAX_HISTORY=""
PRJ_PDF_VIEWER=""

typeset -A CFG_TARGETS
CFG_TARGET_COUNT=0
HAS_CONFIG=false

CURRENT_OS="unknown"
OPEN_CMD=""

detect_os() {
    local kernel_name=$(uname -s)
    case "$kernel_name" in
        Darwin*)
            CURRENT_OS="macOS"
            OPEN_CMD="open"
            ;;
        Linux*)
            if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
                CURRENT_OS="WSL"
                if command -v wslview &> /dev/null; then
                    OPEN_CMD="wslview"
                else
                    OPEN_CMD="explorer.exe"
                fi
            else
                CURRENT_OS="Linux"
                OPEN_CMD="xdg-open"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*)
            CURRENT_OS="Windows (Git Bash)"
            OPEN_CMD="start"
            ;;
        *)
            CURRENT_OS="Unknown"
            OPEN_CMD=""
            ;;
    esac
}

init_user_config() {
    if [[ ! -f "$USER_CONFIG" ]]; then
        print_info "Creating default user config at ${USER_CONFIG}..."
        cat > "$USER_CONFIG" << 'EOF'
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
EOF
    fi
}

load_user_config() {
    [[ ! -f "$USER_CONFIG" ]] && return
    
    local current_section=""
    while IFS='=' read -r key value; do
        key="${key## }"
        key="${key%% }"
        value="${value## }"
        value="${value%% }"
        
        [[ "$key" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$key" ]] && continue
        
        if [[ "$key" =~ ^\[(.*)\]$ ]]; then
            current_section="${match[1]}"
            continue
        fi
        
        case "$current_section" in
            General)
                case "$key" in
                    default_engine) CFG_DEFAULT_ENGINE="$value" ;;
                    auto_cleanup) [[ "$value" == "true" ]] && CFG_AUTO_CLEANUP=true || CFG_AUTO_CLEANUP=false ;;
                    editor) CFG_EDITOR="$value" ;;
                    auto_open_pdf) [[ "$value" == "true" ]] && CFG_AUTO_OPEN_PDF=true || CFG_AUTO_OPEN_PDF=false ;;
                esac
                ;;
            Theme)
                [[ "$key" == "active_theme" ]] && CFG_ACTIVE_THEME="$value"
                ;;
            Features)
                case "$key" in
                    enable_history) [[ "$value" == "true" ]] && CFG_ENABLE_HISTORY=true || CFG_ENABLE_HISTORY=false ;;
                    max_history) CFG_MAX_HISTORY="$value" ;;
                esac
                ;;
            PDF)
                [[ "$key" == "viewer" ]] && CFG_PDF_VIEWER="$value"
                ;;
        esac
    done < "$USER_CONFIG"
    
    load_theme "$CFG_ACTIVE_THEME"
}

read_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        echo -e "${C_CYAN}Reading configuration from ${CONFIG_FILE}...${C_RESET}"
        
        # 💡 重置配置变量
        CFG_TARGETS=()
        CFG_TARGET_COUNT=0
        local max_idx=0
        
        # 💡 重置项目级配置
        PRJ_DEFAULT_ENGINE=""
        PRJ_AUTO_CLEANUP=""
        PRJ_EDITOR=""
        PRJ_AUTO_OPEN_PDF=""
        PRJ_ACTIVE_THEME=""
        PRJ_ENABLE_HISTORY=""
        PRJ_MAX_HISTORY=""
        PRJ_PDF_VIEWER=""

        local file_content=$(cat "$CONFIG_FILE" | tr -d '\r')
        local -a lines=("${(@f)file_content}")
        local current_section=""

        for line in "${lines[@]}"; do
            # 💡 跳过注释和空行
            [[ "$line" =~ ^[[:space:]]*# ]] && continue
            [[ -z "${line//[[:space:]]/}" ]] && continue
            
            local key="${line%%=*}"
            local value="${line#*=}"
            
            # 💡 清理前后空格
            key="${key#"${key%%[![:space:]]*}"}"
            key="${key%"${key##*[![:space:]]}"}"
            value="${value#"${value%%[![:space:]]*}"}" 
            value="${value%"${value##*[![:space:]]}"}" 
            
            # 💡 移除引号
            value=${value#[\"\']}
            value=${value%[\"\']}
            
            # 💡 检测 section 标记 [SectionName]
            if [[ "$key" =~ ^\[(.+)\]$ ]]; then
                current_section="${match[1]}"
                continue
            fi

            # 💡 根据当前 section 解析配置
            case "$current_section" in
                General)
                    case "$key" in
                        default_engine) PRJ_DEFAULT_ENGINE="$value" ;;
                        auto_cleanup) PRJ_AUTO_CLEANUP="$value" ;;
                        editor) PRJ_EDITOR="$value" ;;
                        auto_open_pdf) PRJ_AUTO_OPEN_PDF="$value" ;;
                    esac
                    ;;
                Theme)
                    [[ "$key" == "active_theme" ]] && PRJ_ACTIVE_THEME="$value"
                    ;;
                Features)
                    case "$key" in
                        enable_history) PRJ_ENABLE_HISTORY="$value" ;;
                        max_history) PRJ_MAX_HISTORY="$value" ;;
                    esac
                    ;;
                PDF)
                    [[ "$key" == "viewer" ]] && PRJ_PDF_VIEWER="$value"
                    ;;
                Targets|"")
                    # 💡 处理编译目标配置 (旧格式兼容)
                    if [[ "$key" == "MAIN_FILE" ]]; then
                        if [[ -z "${CFG_TARGETS[1,FILE]}" ]]; then
                            CFG_TARGETS[1,FILE]="$value"
                            [[ $max_idx -lt 1 ]] && max_idx=1
                        fi
                    elif [[ "$key" == "ENGINE" ]]; then
                         if [[ -z "${CFG_TARGETS[1,ENGINE]}" ]]; then
                            CFG_TARGETS[1,ENGINE]="$value"
                        fi
                    elif [[ "$key" == "BIB_TOOL" ]]; then
                         if [[ -z "${CFG_TARGETS[1,BIB_TOOL]}" ]]; then
                            CFG_TARGETS[1,BIB_TOOL]="$value"
                        fi
                    elif [[ "$key" =~ ^TARGET_([0-9]+)_(FILE|ENGINE|BIB_TOOL)$ ]]; then
                        local idx=${match[1]}
                        local field=${match[2]}
                        CFG_TARGETS[$idx,$field]="$value"
                        if (( idx > max_idx )); then max_idx=$idx; fi
                    fi
                    ;;
            esac
        done

        CFG_TARGET_COUNT=$max_idx

        if (( CFG_TARGET_COUNT > 0 )); then
            HAS_CONFIG=true
            echo -e "  -> Detected ${C_BOLD}${CFG_TARGET_COUNT}${C_RESET} compilation targets."
        else
            echo -e "${C_RED}  -> Config file found but no valid targets detected.${C_RESET}"
            HAS_CONFIG=false
        fi
    else
        HAS_CONFIG=false
    fi
}

# 💡 应用配置优先级: 项目配置 > 全局配置 > 默认值
apply_config_priority() {
    local has_project_override=false
    
    # General 部分
    if [[ -n "$PRJ_DEFAULT_ENGINE" ]]; then
        CFG_DEFAULT_ENGINE="$PRJ_DEFAULT_ENGINE"
        has_project_override=true
    fi
    
    if [[ -n "$PRJ_AUTO_CLEANUP" ]]; then
        [[ "$PRJ_AUTO_CLEANUP" == "true" ]] && CFG_AUTO_CLEANUP=true || CFG_AUTO_CLEANUP=false
        has_project_override=true
    fi
    
    if [[ -n "$PRJ_EDITOR" ]]; then
        CFG_EDITOR="$PRJ_EDITOR"
        has_project_override=true
    fi
    
    if [[ -n "$PRJ_AUTO_OPEN_PDF" ]]; then
        [[ "$PRJ_AUTO_OPEN_PDF" == "true" ]] && CFG_AUTO_OPEN_PDF=true || CFG_AUTO_OPEN_PDF=false
        has_project_override=true
    fi
    
    # Theme 部分
    if [[ -n "$PRJ_ACTIVE_THEME" ]]; then
        CFG_ACTIVE_THEME="$PRJ_ACTIVE_THEME"
        load_theme "$CFG_ACTIVE_THEME"  # 💡 立即应用项目主题
        has_project_override=true
    fi
    
    # Features 部分
    if [[ -n "$PRJ_ENABLE_HISTORY" ]]; then
        [[ "$PRJ_ENABLE_HISTORY" == "true" ]] && CFG_ENABLE_HISTORY=true || CFG_ENABLE_HISTORY=false
        has_project_override=true
    fi
    
    if [[ -n "$PRJ_MAX_HISTORY" ]]; then
        CFG_MAX_HISTORY="$PRJ_MAX_HISTORY"
        has_project_override=true
    fi
    
    # PDF 部分
    if [[ -n "$PRJ_PDF_VIEWER" ]]; then
        CFG_PDF_VIEWER="$PRJ_PDF_VIEWER"
        has_project_override=true
    fi
    
    # 💡 显示配置来源信息
    if $has_project_override; then
        echo -e "  ${C_ACCENT}->${C_RESET} Applied project-level configuration overrides."
    fi
}



# ==============================================================================
# SECTION 4: 辅助功能
# ==============================================================================

open_pdf() {
    local pdf_file="$1"
    if [[ ! -f "$pdf_file" ]]; then
        return
    fi

    if [[ "$CFG_AUTO_OPEN_PDF" == "false" ]]; then
        return
    fi

    if ! prompt_confirm "Open generated PDF (${CURRENT_OS})?" "y"; then
        return
    fi

    local viewer_cmd="${CFG_PDF_VIEWER:-$OPEN_CMD}"
    
    if [[ -n "$viewer_cmd" ]]; then
        print_info "Opening with: ${viewer_cmd}"
        $viewer_cmd "$pdf_file" &>/dev/null &
    else
        print_warning "Could not detect PDF viewer on ${CURRENT_OS}"
    fi
}

clstex() {
    local target_files=()
    local extensions=(
        aux log out toc lof lot synctex.gz fls fdb_latexmk
        bbl blg bcf bit idx ilg ind glo gls glg run.xml dvi ptc
        nav snm vrb thm xdy
    )
    
    if (( $# > 0 )); then
        for base_name in "$@"; do
            base_name="${base_name%.tex}"
            for ext in "${extensions[@]}"; do
                if [[ -f "${base_name}.${ext}" ]]; then
                    target_files+=("${base_name}.${ext}")
                fi
            done
        done
    else
        for ext in "${extensions[@]}"; do
            target_files+=(*.${ext}(N))
        done
    fi

    if (( ${#target_files[@]} == 0 )); then
        print_success "No LaTeX auxiliary files found to clean."
        return 0
    fi

    echo -e "${C_YELLOW}[!] The following ${C_BOLD}${#target_files[@]}${C_RESET}${C_YELLOW} files will be deleted:${C_RESET}"
    if (( ${#target_files[@]} > 10 )); then
        print -l "${target_files[@]:0:10}"
        echo "... and $((${#target_files[@]} - 10)) more."
    else
        print -l "${target_files[@]}"
    fi

    if prompt_confirm "Are you sure?" "n"; then
        rm -f "${target_files[@]}"
        echo ""
        print_success "Cleanup complete! Removed ${C_BOLD}${#target_files[@]}${C_RESET} files."
    else
        echo ""
        print_info "Operation canceled."
    fi
}

show_log_error() {
    local log_file="$1"
    if [[ ! -f "$log_file" ]]; then return; fi
    
    if prompt_confirm "View end of log file to locate errors?" "y"; then
        echo -e "${C_YELLOW}--- Last 25 lines of ${log_file} ---${C_RESET}"
        tail -n 25 "${log_file}"
        echo -e "${C_YELLOW}------------------------------------${C_RESET}"
    fi
}

# ==============================================================================
# SECTION 5: 历史记录
# ==============================================================================

save_to_history() {
    [[ "$CFG_ENABLE_HISTORY" == "false" ]] && return
    
    local file="$1"
    local engine="$2"
    local success="$3"
    local timestamp=$(date -Iseconds)
    
    local entry="${timestamp}|${file}|${engine}|${success}"
    
    local -a history_lines=()
    [[ -f "$HISTORY_FILE" ]] && history_lines=("${(@f)$(cat "$HISTORY_FILE")}")
    
    history_lines=("$entry" "${history_lines[@]}")
    history_lines=("${history_lines[@]:0:$CFG_MAX_HISTORY}")
    
    printf '%s\n' "${history_lines[@]}" > "$HISTORY_FILE"
}

show_history() {
    if [[ ! -f "$HISTORY_FILE" ]] || [[ ! -s "$HISTORY_FILE" ]]; then
        print_warning "No compilation history found."
        return
    fi
    
    draw_header "Compilation History" "Last ${CFG_MAX_HISTORY} compilations"
    
    local -a history_lines=("${(@f)$(cat "$HISTORY_FILE")}")
    local i=1
    
    for line in "${history_lines[@]}"; do
        IFS='|' read -r timestamp file engine success <<< "$line"
        local status_icon="[OK]"
        local status_color="$C_SUCCESS"
        [[ "$success" == "false" ]] && status_icon="[X]" && status_color="$C_ERROR"
        
        echo -e "  ${C_DIM}${i}.${C_RESET} ${status_color}${status_icon}${C_RESET} ${C_ACCENT}${file}${C_RESET} ${C_DIM}(${engine})${C_RESET} - ${C_DIM}${timestamp}${C_RESET}"
        ((i++))
    done
    
    echo ""
}

quick_recompile() {
    if [[ ! -f "$HISTORY_FILE" ]] || [[ ! -s "$HISTORY_FILE" ]]; then
        print_error "No compilation history available."
        return
    fi
    
    local last_entry=$(head -n 1 "$HISTORY_FILE")
    IFS='|' read -r timestamp file engine success <<< "$last_entry"
    
    if [[ ! -f "$file" ]]; then
        print_error "File ${file} no longer exists."
        return
    fi
    
    print_info "Recompiling: ${C_ACCENT}${file}${C_RESET} with ${C_PRIMARY}${engine}${C_RESET}"
    
    local base_name="${file%.tex}"
    local flag="-${engine}"
    [[ "$engine" == "pdflatex" ]] && flag="-pdf"
    
    compile_latexmk "$flag" "$base_name"
}

word_count_report() {
    local files=(*.tex(N))
    if (( ${#files[@]} == 0 )); then
        print_error "No .tex files found."
        return
    fi
    
    echo ""
    print_info "Select a file for word count:"
    select file in "${files[@]}" "[Cancel]"; do
        [[ "$file" == "[Cancel]" ]] && return
        if [[ -n "$file" ]]; then
            draw_header "Word Count Report" "$file"
            
            # 尝试使用texcount
            if command -v texcount &>/dev/null; then
                echo -e "${C_CYAN}[i] Using texcount (LaTeX-aware)${C_RESET}\n"
                
                # 添加-inc参数包含子文件，-v0抑制警告
                if texcount -brief -q -inc "$file" 2>/dev/null; then
                    echo ""
                else
                    print_warning "texcount failed, using fallback method..."
                    echo ""
                    
                    # 备选方案：简单字数统计
                    local words=$(detex "$file" 2>/dev/null | wc -w)
                    if [[ -z "$words" ]]; then
                        words=$(grep -v '^%' "$file" | wc -w)
                    fi
                    
                    echo -e "${C_ACCENT}Approximate word count:${C_RESET} ${C_BOLD}${words}${C_RESET} words"
                    echo -e "${C_DIM}(Basic count, excludes LaTeX commands)${C_RESET}"
                    echo ""
                fi
            else
                # 如果没有texcount，使用基础统计
                print_warning "texcount not installed, using basic count..."
                echo ""
                
                local total_lines=$(wc -l < "$file")
                local code_lines=$(grep -v '^[[:space:]]*%' "$file" | grep -v '^[[:space:]]*$' | wc -l)
                local comment_lines=$(grep '^[[:space:]]*%' "$file" | wc -l)
                local words=$(grep -v '^%' "$file" | wc -w)
                
                echo -e "${C_ACCENT}Basic Statistics:${C_RESET}"
                echo -e "  Total lines:   ${C_BOLD}${total_lines}${C_RESET}"
                echo -e "  Code lines:    ${C_BOLD}${code_lines}${C_RESET}"
                echo -e "  Comments:      ${C_BOLD}${comment_lines}${C_RESET}"
                echo -e "  Approx words:  ${C_BOLD}${words}${C_RESET}"
                echo ""
                echo -e "${C_DIM}Tip: Install texcount for accurate LaTeX word counting:${C_RESET}"
                echo -e "${C_DIM}    sudo dnf install texcount${C_RESET}"
                echo ""
            fi
            
            break
        fi
    done
}

# 依赖包检测
check_missing_packages() {
    local files=(*.tex(N))
    if (( ${#files[@]} == 0 )); then
        print_error "No .tex files found."
        return
    fi
    
    echo ""
    print_info "Select a file to check dependencies:"
    select file in "${files[@]}" "[Cancel]"; do
        [[ "$file" == "[Cancel]" ]] && return
        if [[ -n "$file" ]]; then
            draw_header "Package Dependency Check" "$file"
            
            # 提取所有\usepackage命令
            local -a packages=($(grep -oP '\\usepackage(\[.*?\])?\{\K[^}]+' "$file" 2>/dev/null | tr ',' '\n' | sort -u))
            
            if (( ${#packages[@]} == 0 )); then
                print_info "No packages found in $file"
                echo ""
                return
            fi
            
            echo -e "${C_ACCENT}Found ${#packages[@]} packages:${C_RESET}\n"
            
            local missing=0
            for pkg in "${packages[@]}"; do
                # 检查包是否存在(简单方法：查找.sty文件)
                if kpsewhich "${pkg}.sty" &>/dev/null; then
                    echo -e "  ${C_SUCCESS}[OK]${C_RESET} ${pkg}"
                else
                    echo -e "  ${C_ERROR}[X]${C_RESET}  ${pkg} ${C_DIM}(not found)${C_RESET}"
                    ((missing++))
                fi
            done
            
            echo ""
            if (( missing > 0 )); then
                print_warning "Found $missing missing package(s)"
                echo -e "${C_DIM}Install with: sudo dnf install 'tex(packagename.sty)'${C_RESET}"
            else
                print_success "All packages are installed!"
            fi
            echo ""
            
            break
        fi
    done
}

# LaTeX错误诊断
diagnose_errors() {
    local log_files=(*.log(N))
    if (( ${#log_files[@]} == 0 )); then
        print_error "No .log files found. Compile first."
        return
    fi
    
    echo ""
    print_info "Select a log file to diagnose:"
    select log in "${log_files[@]}" "[Cancel]"; do
        [[ "$log" == "[Cancel]" ]] && return
        if [[ -n "$log" ]]; then
            draw_header "Error Diagnosis" "$log"
            
            # 常见错误模式匹配
            local has_errors=false
            
            # 1. 缺失文件
            if grep -q "File.*not found" "$log"; then
                echo -e "${C_ERROR}[!] Missing Files:${C_RESET}"
                grep "File.*not found" "$log" | sed 's/^/  /' | head -5
                echo ""
                has_errors=true
            fi
            
            # 2. 未定义的控制序列
            if grep -q "Undefined control sequence" "$log"; then
                echo -e "${C_ERROR}[!] Undefined Commands:${C_RESET}"
                grep -A1 "Undefined control sequence" "$log" | grep "l\." | sed 's/^/  /' | head -5
                echo -e "  ${C_DIM}→ 可能是拼写错误或缺少宏包${C_RESET}"
                echo ""
                has_errors=true
            fi
            
            # 3. 缺失包
            if grep -q "\.sty.*not found" "$log"; then
                echo -e "${C_ERROR}[!] Missing Packages:${C_RESET}"
                grep "\.sty.*not found" "$log" | sed 's/^/  /' | head -5
                echo -e "  ${C_DIM}→ 使用 Package Check 功能检测缺失的包${C_RESET}"
                echo ""
                has_errors=true
            fi
            
            # 4. 数学模式错误
            if grep -q "Missing .*\\$" "$log"; then
                echo -e "${C_ERROR}[!] Math Mode Errors:${C_RESET}"
                echo -e "  ${C_DIM}→ 检查数学公式是否正确闭合 \$ ... \$${C_RESET}"
                echo ""
                has_errors=true
            fi
            
            # 5. 引用错误
            if grep -q "Reference.*undefined" "$log"; then
                echo -e "${C_WARNING}[!] Undefined References:${C_RESET}"
                grep "Reference.*undefined" "$log" | sed 's/LaTeX Warning: /  /' | head -5
                echo -e "  ${C_DIM}→ 可能需要再编译一次或检查\\label${C_RESET}"
                echo ""
                has_errors=true
            fi
            
            if [[ "$has_errors" == "false" ]]; then
                print_success "No common errors found in log file!"
                echo -e "${C_DIM}Use 'View log file' option for detailed analysis.${C_RESET}"
            fi
            
            echo ""
            break
        fi
    done
}

# 项目信息摘要
show_project_summary() {
    echo ""
    draw_header "Project Summary" "Current directory: ${PWD##*/}"
    
    local tex_files=(*.tex(N))
    local pdf_files=(*.pdf(N))
    local bib_files=(*.bib(N))
    local fig_files=(*.{png,jpg,pdf,eps}(N))
    
    echo -e "${C_ACCENT}File Statistics:${C_RESET}"
    echo -e "  TeX files:    ${C_BOLD}${#tex_files[@]}${C_RESET}"
    echo -e "  PDF files:    ${C_BOLD}${#pdf_files[@]}${C_RESET}"
    echo -e "  Bib files:    ${C_BOLD}${#bib_files[@]}${C_RESET}"
    echo -e "  Figures:      ${C_BOLD}${#fig_files[@]}${C_RESET}"
    echo ""
    
    # 💡 显示配置状态和来源
    echo -e "${C_ACCENT}Configuration Status:${C_RESET}"
    if [[ -f ".latexcfg" ]]; then
        echo -e "  Project config:  ${C_SUCCESS}[OK]${C_RESET} .latexcfg found"
        
        # 💡 显示项目级覆盖的配置项
        local has_overrides=false
        local override_list=""
        
        [[ -n "$PRJ_DEFAULT_ENGINE" ]] && has_overrides=true && override_list+="engine, "
        [[ -n "$PRJ_AUTO_CLEANUP" ]] && has_overrides=true && override_list+="cleanup, "
        [[ -n "$PRJ_EDITOR" ]] && has_overrides=true && override_list+="editor, "
        [[ -n "$PRJ_AUTO_OPEN_PDF" ]] && has_overrides=true && override_list+="pdf-open, "
        [[ -n "$PRJ_ACTIVE_THEME" ]] && has_overrides=true && override_list+="theme, "
        [[ -n "$PRJ_ENABLE_HISTORY" ]] && has_overrides=true && override_list+="history, "
        [[ -n "$PRJ_PDF_VIEWER" ]] && has_overrides=true && override_list+="viewer, "
        
        override_list="${override_list%, }"  # 移除尾部逗号
        
        if $has_overrides; then
            echo -e "  ${C_CYAN}└─>${C_RESET} Overrides: ${C_BOLD}${override_list}${C_RESET}"
        fi
    else
        echo -e "  Project config:  ${C_DIM}None (using global)${C_RESET}"
    fi
    
    if [[ -f "$USER_CONFIG" ]]; then
        echo -e "  User config:     ${C_SUCCESS}[OK]${C_RESET} ~/.latexrc"
    fi
    echo ""
    
    # 💡 显示当前活动配置值
    echo -e "${C_ACCENT}Active Settings:${C_RESET}"
    
    local engine_source="global"
    [[ -n "$PRJ_DEFAULT_ENGINE" ]] && engine_source="project"
    echo -e "  Engine:       ${C_BOLD}${CFG_DEFAULT_ENGINE}${C_RESET} ${C_DIM}(${engine_source})${C_RESET}"
    
    local theme_source="global"
    [[ -n "$PRJ_ACTIVE_THEME" ]] && theme_source="project"
    echo -e "  Theme:        ${C_BOLD}${CFG_ACTIVE_THEME}${C_RESET} ${C_DIM}(${theme_source})${C_RESET}"
    
    local cleanup_status="disabled"
    [[ "$CFG_AUTO_CLEANUP" == "true" ]] && cleanup_status="enabled"
    local cleanup_source="global"
    [[ -n "$PRJ_AUTO_CLEANUP" ]] && cleanup_source="project"
    echo -e "  Auto-cleanup: ${C_BOLD}${cleanup_status}${C_RESET} ${C_DIM}(${cleanup_source})${C_RESET}"
    
    local editor_source="global"
    [[ -n "$PRJ_EDITOR" ]] && editor_source="project"
    echo -e "  Editor:       ${C_BOLD}${CFG_EDITOR}${C_RESET} ${C_DIM}(${editor_source})${C_RESET}"
    echo ""
    
    # 显示最近编译
    if [[ -f "$HISTORY_FILE" ]] && [[ -s "$HISTORY_FILE" ]]; then
        echo -e "${C_ACCENT}Recent Compilation:${C_RESET}"
        local last_entry=$(head -n 1 "$HISTORY_FILE")
        IFS='|' read -r timestamp file engine success <<< "$last_entry"
        local status_icon="[OK]"
        local status_color="$C_SUCCESS"
        [[ "$success" == "false" ]] && status_icon="[X]" && status_color="$C_ERROR"
        
        echo -e "  ${status_color}${status_icon}${C_RESET} ${file} (${engine})"
        echo -e "  ${C_DIM}${timestamp}${C_RESET}"
        echo ""
    fi
}

# LaTeX模板生成器
generate_template() {
    echo ""
    draw_header "LaTeX Template Generator" "Quick start with common templates"
    
    echo -e "${C_ACCENT}Available Templates:${C_RESET}\n"
    echo "  1) Article (学术论文)"
    echo "  2) Beamer (演示幻灯片)"
    echo "  3) Book (书籍/论文)"
    echo "  4) Homework (作业模板)"
    echo "  5) Letter (信件)"
    echo "  6) CV/Resume (简历)"
    echo ""
    
    echo -en "${C_WARNING}?#${C_RESET} Select template [1-6]: "
    read -r choice
    
    echo -en "${C_WARNING}?#${C_RESET} Output filename (without .tex): "
    read -r filename
    
    if [[ -z "$filename" ]]; then
        print_error "Filename cannot be empty"
        return
    fi
    
    local output_file="${filename}.tex"
    
    if [[ -f "$output_file" ]]; then
        if ! prompt_confirm "File exists. Overwrite?" "n"; then
            return
        fi
    fi
    
    case "$choice" in
        1) # Article模板 - 英文版
            cat > "$output_file" << 'EOF'
\documentclass[12pt,a4paper]{article}
\usepackage{amsmath,amssymb}
\usepackage{graphicx}
\usepackage{hyperref}

\title{Article Title}
\author{Author Name}
\date{\today}

\begin{document}

\maketitle

\begin{abstract}
This is the abstract of the article.
\end{abstract}

\section{Introduction}

The main content starts here...

\section{Methods}

\section{Results}

\section{Conclusion}

\bibliographystyle{plain}
\bibliography{references}

\end{document}
EOF
            print_success "Created English Article template: $output_file"
            ;;
            
        2) # Beamer模板 - 英文版
            cat > "$output_file" << 'EOF'
\documentclass{beamer}
\usetheme{Madrid}

\title{Presentation Title}
\author{Author Name}
\institute{Institution}
\date{\today}

\begin{document}

\frame{\titlepage}

\begin{frame}
\frametitle{Table of Contents}
\tableofcontents
\end{frame}

\section{Section One}
\begin{frame}{First Slide}
\begin{itemize}
    \item Point one
    \item Point two
    \item Point three
\end{itemize}
\end{frame}

\section{Section Two}
\begin{frame}{Second Slide}
Content goes here...
\end{frame}

\end{document}
EOF
            print_success "Created English Beamer template: $output_file"
            ;;
            
        3) # Book模板 - 英文版
            cat > "$output_file" << 'EOF'
\documentclass[12pt,a4paper]{book}
\usepackage{amsmath,graphicx}
\usepackage{hyperref}

\title{Book Title}
\author{Author Name}
\date{\today}

\begin{document}

\maketitle
\tableofcontents

\chapter{First Chapter}
\section{First Section}

Chapter content goes here...

\chapter{Second Chapter}

More content...

\end{document}
EOF
            print_success "Created English Book template: $output_file"
            ;;
            
        4) # Homework模板 - 英文版
            cat > "$output_file" << 'EOF'
\documentclass[12pt]{article}
\usepackage{amsmath,amssymb}
\usepackage{enumerate}

\title{Homework Assignment}
\author{Student Name \\ Student ID: XXXXXXXX}
\date{Due Date: \today}

\begin{document}
\maketitle

\section*{Problem 1}

\textbf{Question:}

\textbf{Solution:}

\section*{Problem 2}

\textbf{Question:}

\textbf{Solution:}

\end{document}
EOF
            print_success "Created English Homework template: $output_file"
            ;;
            
        5) # Letter模板 - 英文版
            cat > "$output_file" << 'EOF'
\documentclass{letter}

\signature{Your Name}
\address{Your Address \\ City, State ZIP}

\begin{document}

\begin{letter}{Recipient Name \\ Recipient Address \\ City, State ZIP}

\opening{Dear Sir/Madam:}

Letter content goes here...

\closing{Sincerely,}

\end{letter}
\end{document}
EOF
            print_success "Created English Letter template: $output_file"
            ;;
            
        6) # CV模板 - 英文版
            cat > "$output_file" << 'EOF'
\documentclass[11pt,a4paper]{article}
\usepackage[margin=2cm]{geometry}
\usepackage{enumitem}

\pagestyle{empty}

\begin{document}

\begin{center}
{\LARGE \textbf{Your Name}}\\[5pt]
Phone: (123) 456-7890 | Email: your.email@example.com | Address
\end{center}

\section*{Education}
\begin{itemize}[leftmargin=*]
\item \textbf{University Name} \hfill 2020 -- 2024
  \\ Major | Degree (e.g., B.S. in Computer Science)
\end{itemize}

\section*{Work Experience}
\begin{itemize}[leftmargin=*]
\item \textbf{Company Name} \hfill 2023 -- Present
  \\ Position Title
  \begin{itemize}
  \item Job responsibility description
  \item Achievement or project
  \end{itemize}
\end{itemize}

\section*{Skills}
\begin{itemize}[leftmargin=*]
\item Programming Languages: Python, C++, Java
\item Tools \& Technologies: Git, Docker, Linux
\end{itemize}

\section*{Projects}
\begin{itemize}[leftmargin=*]
\item \textbf{Project Name} -- Brief description
\end{itemize}

\end{document}
EOF
            print_success "Created English CV template: $output_file"
            ;;
            
        *)
            print_error "Invalid template choice"
            return
            ;;
    esac
    
    echo ""
    if prompt_confirm "Compile the template now?" "y"; then
        compile_latexmk "-xelatex" "${filename}"
    fi
}

# BibTeX文献管理
manage_bibliography() {
    echo ""
    draw_header "BibTeX Management" "Manage your references"
    
    local bib_files=(*.bib(N))
    
    if (( ${#bib_files[@]} == 0 )); then
        print_warning "No .bib files found"
        echo ""
        if prompt_confirm "Create a new .bib file?" "y"; then
            echo -en "${C_WARNING}?#${C_RESET} Filename (without .bib): "
            read -r bibname
            
            if [[ -n "$bibname" ]]; then
                cat > "${bibname}.bib" << 'EOF'
% BibTeX数据库文件
% 示例条目

@article{example2023,
    author = {Zhang, San and Li, Si},
    title = {示例文章标题},
    journal = {示例期刊},
    year = {2023},
    volume = {1},
    pages = {1--10}
}

@book{example_book,
    author = {Wang, Wu},
    title = {示例书籍},
    publisher = {出版社},
    year = {2023}
}
EOF
                print_success "Created ${bibname}.bib"
            fi
        fi
        return
    fi
    
    echo -e "${C_ACCENT}Found ${#bib_files[@]} bibliography file(s):${C_RESET}\n"
    
    local i=1
    for bib in "${bib_files[@]}"; do
        local entries=$(grep -c '^@' "$bib" 2>/dev/null || echo "0")
        echo -e "  ${i}) ${C_BOLD}${bib}${C_RESET} (${entries} entries)"
        ((i++))
    done
    
    echo ""
    echo "Actions:"
    echo "  1) View entries"
    echo "  2) Validate BibTeX"
    echo "  3) Add new entry"
    echo "  4) Back"
    echo ""
    
    echo -en "${C_WARNING}?#${C_RESET} Select action [1-4]: "
    read -r action
    
    case "$action" in
        1) # View entries
            if (( ${#bib_files[@]} == 1 )); then
                local selected_bib="${bib_files[1]}"
            else
                echo -en "${C_WARNING}?#${C_RESET} Select file [1-${#bib_files[@]}]: "
                read -r file_idx
                local selected_bib="${bib_files[$file_idx]}"
            fi
            
            if [[ -n "$selected_bib" ]] && [[ -f "$selected_bib" ]]; then
                echo ""
                echo -e "${C_ACCENT}Entries in ${selected_bib}:${C_RESET}\n"
                grep '^@' "$selected_bib" | sed 's/^/  /'
                echo ""
            fi
            ;;
            
        2) # Validate
            if command -v bibtex &>/dev/null; then
                print_info "BibTeX validation feature coming soon..."
            else
                print_error "bibtex command not found"
            fi
            ;;
            
        3) # Add entry  
            print_info "Manual entry addition - edit .bib file directly"
            echo -e "${C_DIM}Tip: Use ${CFG_EDITOR} ${bib_files[1]}${C_RESET}"
            ;;
            
        4) # Back
            return
            ;;
    esac
}

# ==============================================================================
# SECTION 6: 编译逻辑
# ==============================================================================

compile_latexmk() {
    local engine_flag="$1"
    local base_name="$2"
    local do_clean="$3"
    local tex_file="${base_name}.tex"
    
    local engine_name="xelatex"
    case "$engine_flag" in
        -pdf) engine_name="pdflatex" ;;
        -lualatex) engine_name="lualatex" ;;
    esac
    
    show_compile_status "$tex_file" "$engine_name"
    
    local cmd=(latexmk "$engine_flag" -synctex=1 -file-line-error -interaction=nonstopmode -halt-on-error)
    "${cmd[@]}" "$tex_file"

    if [ $? -eq 0 ]; then
        print_success "Successfully compiled: ${base_name}.pdf"
        save_to_history "$tex_file" "$engine_name" "true"
        open_pdf "${base_name}.pdf"
        
        if [[ "$do_clean" == "autoclean" ]] || [[ "$CFG_AUTO_CLEANUP" == "true" ]]; then
            latexmk -c "$tex_file"
        else
             if prompt_confirm "Run cleanup (latexmk -c)?" "n"; then
                 latexmk -c "$tex_file"
             fi
        fi
    else 
        print_error "Latexmk compilation failed!"
        save_to_history "$tex_file" "$engine_name" "false"
        show_log_error "${base_name}.log"
        return 1
    fi
}

run_target_task() {
    local idx="$1"
    local filename="${CFG_TARGETS[$idx,FILE]}"
    local engine="${CFG_TARGETS[$idx,ENGINE]}"
    local bib="${CFG_TARGETS[$idx,BIB_TOOL]}"

    if [[ -z "$filename" ]]; then
        print_error "Target #$idx is missing filename."
        return
    fi
    
    local base_name="${filename%.tex}"
    local flag="-${engine}"
    if [[ "$engine" == "pdflatex" ]]; then flag="-pdf"; fi
    
    compile_latexmk "$flag" "$base_name"
}

compile_all_targets() {
    echo ""
    echo -e "${C_PURPLE}=== Starting Batch Compilation (${CFG_TARGET_COUNT} targets) ===${C_RESET}"
    for ((i=1; i<=CFG_TARGET_COUNT; i++)); do
        echo ""
        echo -e "${C_CYAN}>>> Processing Target #$i${C_RESET}"
        run_target_task "$i"
    done
    echo ""
    print_success "Batch Compilation Finished"
}

compile_with_config() {
    if (( CFG_TARGET_COUNT == 0 )); then
        print_error "No targets defined in config."
        return
    fi

    if (( CFG_TARGET_COUNT == 1 )); then
        run_target_task 1
        return
    fi

    echo ""
    echo -e "${C_BOLD}Multi-target config detected. Choose action:${C_RESET}"
    
    local target_menu=("[ALL] Compile ALL Targets")
    for ((i=1; i<=CFG_TARGET_COUNT; i++)); do
        local fname="${CFG_TARGETS[$i,FILE]}"
        local eng="${CFG_TARGETS[$i,ENGINE]}"
        target_menu+=("Target #$i: $fname ($eng)")
    done
    target_menu+=("[Back]")

    select t_choice in "${target_menu[@]}"; do
        case "$t_choice" in
            "[Back]") return ;;
            "[ALL]"*) compile_all_targets; break ;;
            *)
                if [[ "$t_choice" =~ Target\ #([0-9]+) ]]; then
                    local t_idx=${match[1]}
                    run_target_task "$t_idx"
                    break
                else
                    print_error "Invalid selection."
                fi
                ;;
        esac
    done
}

compile_manual_chain() {
    local compiler="$1"
    local bib_tool="$2"
    local base_name="$3"
    
    echo ""
    echo -e "${C_PURPLE}===== Manual Chain: ${compiler} -> ${bib_tool} -> ${compiler} x2 =====${C_RESET}"
    
    echo -e "${C_YELLOW}[1/4] Running ${compiler} (Pass 1)...${C_RESET}"
    $compiler -interaction=nonstopmode -halt-on-error "${base_name}.tex" || { show_log_error "${base_name}.log"; return 1; }

    if [[ "$bib_tool" != "none" ]]; then
        echo -e "${C_YELLOW}[2/4] Running ${bib_tool}...${C_RESET}"
        if [[ "$bib_tool" == "biber" ]]; then
            biber "${base_name}"
        elif [[ "$bib_tool" == "bibtex" ]]; then
            bibtex "${base_name}"
        fi
        if [ $? -ne 0 ]; then print_warning "${bib_tool} exited with errors."; fi
    else
        echo -e "${C_YELLOW}[2/4] Skipping bibliography step...${C_RESET}"
    fi

    echo -e "${C_YELLOW}[3/4] Running ${compiler} (Pass 2)...${C_RESET}"
    $compiler -interaction=nonstopmode -halt-on-error "${base_name}.tex" > /dev/null
    
    echo -e "${C_YELLOW}[4/4] Running ${compiler} (Pass 3)...${C_RESET}"
    $compiler -interaction=nonstopmode -halt-on-error "${base_name}.tex"
    
    if [ $? -eq 0 ]; then
        print_success "Manual Compilation Success"
        open_pdf "${base_name}.pdf"
    else
        print_error "Final compilation pass failed!"
        show_log_error "${base_name}.log"
    fi
}

compile_pvc() {
    local engine_flag="$1"
    local base_name="$2"
    echo ""
    echo -e "${C_BLUE}===== Starting live preview for ${C_BOLD}${base_name}.tex${C_RESET}${C_BLUE} =====${C_RESET}"
    echo -e "${C_YELLOW}Watching for file changes... Press Ctrl+C to stop.${C_RESET}"
    latexmk "${engine_flag}" -pvc -synctex=1 -interaction=nonstopmode -halt-on-error "${base_name}.tex"
}

interactive_compile_logic() {
    local files=(*.tex(N)) 
    if (( ${#files[@]} == 0 )); then print_error "No .tex files found."; return; fi
    
    local targets=()
    echo ""
    echo -e "${C_BOLD}Select a TeX file to compile:${C_RESET}"
    local menu_items=("${files[@]}" "[ALL] Compile All" "[Back]")
    
    select file_choice in "${menu_items[@]}"; do
        case "$file_choice" in 
            "[Back]") return ;; 
            "[ALL]"*) targets=("${files[@]}"); break ;; 
            *) if [[ -n "$file_choice" ]]; then targets=("$file_choice"); break; fi ;;
        esac
    done

    echo ""
    echo -e "${C_BOLD}Select Compilation Mode:${C_RESET}"
    local modes=(
        "[Auto] Latexmk (XeLaTeX) [Recommended]"
        "[Auto] Latexmk (PDFLaTeX)"
        "[Auto] Latexmk (LuaLaTeX)"
        "[Live] Preview Mode (XeLaTeX)"
        "[Manual] XeLaTeX + Biber"
        "[Manual] XeLaTeX + BibTeX"
        "[Manual] PDFLaTeX + BibTeX"
        "[Back]"
    )

    select mode in "${modes[@]}"; do
        case "$mode" in
            "[Back]") return ;;
            *"Auto"*"XeLaTeX"*)
                for t in "${targets[@]}"; do compile_latexmk "-xelatex" "${t%.tex}"; done; break ;;
            *"Auto"*"PDFLaTeX"*)
                for t in "${targets[@]}"; do compile_latexmk "-pdf" "${t%.tex}"; done; break ;;
            *"Auto"*"LuaLaTeX"*)
                for t in "${targets[@]}"; do compile_latexmk "-lualatex" "${t%.tex}"; done; break ;;
            *"Live"*)
                compile_pvc "-xelatex" "${targets[0]%.tex}"; break ;;
            *"Manual"*"XeLaTeX + Biber"*)
                for t in "${targets[@]}"; do compile_manual_chain "xelatex" "biber" "${t%.tex}"; done; break ;;
            *"Manual"*"XeLaTeX + BibTeX"*)
                for t in "${targets[@]}"; do compile_manual_chain "xelatex" "bibtex" "${t%.tex}"; done; break ;;
            *"Manual"*"PDFLaTeX"*)
                for t in "${targets[@]}"; do compile_manual_chain "pdflatex" "bibtex" "${t%.tex}"; done; break ;;
            *) print_error "Invalid selection." ;;
        esac
    done
}

generate_config_template() {
    echo ""
    echo -e "${C_PURPLE}=== Generate Batch Project Configuration (.latexcfg) ===${C_RESET}"
    echo -e "${C_CYAN}This wizard creates a config file supporting multiple files.${C_RESET}"

    local files=(*.tex(N))
    if (( ${#files[@]} == 0 )); then
        print_error "No .tex files found!"
        return
    fi

    local temp_config_content=""
    local idx=1
    
    while true; do
        echo ""
        echo -e "${C_BOLD}--- Configuring Target #${idx} ---${C_RESET}"
        
        local selected_file=""
        echo -e "${C_BOLD}Select TeX file for Target #${idx}:${C_RESET}"
        select f in "${files[@]}"; do
            if [[ -n "$f" ]]; then selected_file="$f"; break; fi
        done

        local selected_engine=""
        echo -e "${C_BOLD}Select engine for ${selected_file}:${C_RESET}"
        select e in "xelatex" "pdflatex" "lualatex"; do
            if [[ -n "$e" ]]; then selected_engine="$e"; break; fi
        done

        local selected_bib=""
        echo -e "${C_BOLD}Select bib tool for ${selected_file}:${C_RESET}"
        select b in "none" "biber" "bibtex"; do
            if [[ -n "$b" ]]; then selected_bib="$b"; break; fi
        done
        [[ "$selected_bib" == "none" ]] && selected_bib=""

        temp_config_content+=$'\n'"TARGET_${idx}_FILE = \"${selected_file}\""
        temp_config_content+=$'\n'"TARGET_${idx}_ENGINE = \"${selected_engine}\""
        temp_config_content+=$'\n'"TARGET_${idx}_BIB_TOOL = \"${selected_bib}\""

        echo ""
        if ! prompt_confirm "Add another file?" "n"; then
            break
        fi
        ((idx++))
    done

    echo ""
    echo -e "${C_YELLOW}Writing to ${CONFIG_FILE}...${C_RESET}"
    
    cat > "$CONFIG_FILE" <<EOF
# LaTeX Project Configuration (Batch Mode)
# Generated by latexcompile.sh
${temp_config_content}
EOF

    print_success "Configuration file created!"
    read_config
    apply_config_priority  # 💡 应用项目级配置覆盖
}

# 增强的模板管理系统
TEMPLATE_DIR="$HOME/.latex_templates"

manage_templates() {
    echo ""
    draw_header "Template Management" "Manage your LaTeX templates"
    
    # 确保模板目录存在
    mkdir -p "$TEMPLATE_DIR"
    
    echo -e "${C_ACCENT}Template Actions:${C_RESET}\n"
    echo "  1) Generate from built-in template"
    echo "  2) Save current file as template"
    echo "  3) List custom templates"
    echo "  4) Use custom template"
    echo "  5) Delete custom template"
    echo "  6) Back"
    echo ""
    
    echo -en "${C_WARNING}?#${C_RESET} Select action [1-6]: "
    read -r action
    
    case "$action" in
        1) # 生成内置模板
            generate_template
            ;;
            
        2) # 保存为模板
            local files=(*.tex(N))
            if (( ${#files[@]} == 0 )); then
                print_error "No .tex files found"
                return
            fi
            
            echo ""
            print_info "Select file to save as template:"
            select file in "${files[@]}" "[Cancel]"; do
                [[ "$file" == "[Cancel]" ]] && return
                if [[ -n "$file" ]]; then
                    echo -en "${C_WARNING}?#${C_RESET} Template name: "
                    read -r tpl_name
                    
                    if [[ -n "$tpl_name" ]]; then
                        cp "$file" "$TEMPLATE_DIR/${tpl_name}.tex"
                        print_success "Saved template: ${tpl_name}"
                    fi
                    break
                fi
            done
            ;;
            
        3) # 列出自定义模板
            local custom_tpls=("$TEMPLATE_DIR"/*.tex(N))
            
            if (( ${#custom_tpls[@]} == 0 )); then
                print_warning "No custom templates found"
            else
                echo ""
                echo -e "${C_ACCENT}Custom Templates:${C_RESET}\n"
                for tpl in "${custom_tpls[@]}"; do
                    local tpl_name="${tpl##*/}"
                    echo -e "  ${C_SUCCESS}[+]${C_RESET} ${tpl_name%.tex}"
                done
                echo ""
            fi
            ;;
            
        4) # 使用自定义模板
            local custom_tpls=("$TEMPLATE_DIR"/*.tex(N))
            
            if (( ${#custom_tpls[@]} == 0 )); then
                print_error "No custom templates found"
                return
            fi
            
            echo ""
            print_info "Select template:"
            local tpl_names=()
            for tpl in "${custom_tpls[@]}"; do
                tpl_names+=("${tpl##*/}")
            done
            
            select tpl_file in "${tpl_names[@]}" "[Cancel]"; do
                [[ "$tpl_file" == "[Cancel]" ]] && return
                if [[ -n "$tpl_file" ]]; then
                    echo -en "${C_WARNING}?#${C_RESET} Output filename (without .tex): "
                    read -r filename
                    
                    if [[ -n "$filename" ]]; then
                        cp "$TEMPLATE_DIR/$tpl_file" "${filename}.tex"
                        print_success "Created ${filename}.tex from template"
                        
                        if prompt_confirm "Compile now?" "y"; then
                            compile_latexmk "-xelatex" "$filename"
                        fi
                    fi
                    break
                fi
            done
            ;;
            
        5) # 删除模板
            local custom_tpls=("$TEMPLATE_DIR"/*.tex(N))
            
            if (( ${#custom_tpls[@]} == 0 )); then
                print_error "No custom templates found"
                return
            fi
            
            echo ""
            print_info "Select template to delete:"
            local tpl_names=()
            for tpl in "${custom_tpls[@]}"; do
                tpl_names+=("${tpl##*/}")
            done
            
            select tpl_file in "${tpl_names[@]}" "[Cancel]"; do
                [[ "$tpl_file" == "[Cancel]" ]] && return
                if [[ -n "$tpl_file" ]]; then
                    if prompt_confirm "Delete template ${tpl_file}?" "n"; then
                        rm "$TEMPLATE_DIR/$tpl_file"
                        print_success "Deleted template: ${tpl_file}"
                    fi
                    break
                fi
            done
            ;;
            
        6) # 返回
            return
            ;;
    esac
}

# 项目工作区管理
WORKSPACE_FILE="$HOME/.latex_workspaces"

manage_workspaces() {
    echo ""
    draw_header "Project Workspace Manager" "Switch between LaTeX projects"
    
    echo -e "${C_ACCENT}Workspace Actions:${C_RESET}\n"
    echo "  1) List workspaces"
    echo "  2) Add current directory"
    echo "  3) Switch to workspace"
    echo "  4) Remove workspace"
    echo "  5) Back"
    echo ""
    
    echo -en "${C_WARNING}?#${C_RESET} Select action [1-5]: "
    read -r action
    
    case "$action" in
        1) # 列出工作区
            if [[ ! -f "$WORKSPACE_FILE" ]] || [[ ! -s "$WORKSPACE_FILE" ]]; then
                print_warning "No workspaces saved"
            else
                echo ""
                echo -e "${C_ACCENT}Saved Workspaces:${C_RESET}\n"
                local i=1
                while IFS='|' read -r name path; do
                    echo -e "  ${i}) ${C_BOLD}${name}${C_RESET}"
                    echo -e "     ${C_DIM}${path}${C_RESET}"
                    ((i++))
                done < "$WORKSPACE_FILE"
                echo ""
            fi
            ;;
            
        2) # 添加当前目录
            echo -en "${C_WARNING}?#${C_RESET} Workspace name: "
            read -r ws_name
            
            if [[ -n "$ws_name" ]]; then
                echo "${ws_name}|${PWD}" >> "$WORKSPACE_FILE"
                print_success "Added workspace: ${ws_name}"
            fi
            ;;
            
        3) # 切换工作区
            if [[ ! -f "$WORKSPACE_FILE" ]] || [[ ! -s "$WORKSPACE_FILE" ]]; then
                print_error "No workspaces saved"
                return
            fi
            
            echo ""
            print_info "Select workspace:"
            
            local -a ws_names=()
            local -a ws_paths=()
            while IFS='|' read -r name path; do
                ws_names+=("$name")
                ws_paths+=("$path")
            done < "$WORKSPACE_FILE"
            
            select ws_name in "${ws_names[@]}" "[Cancel]"; do
                [[ "$ws_name" == "[Cancel]" ]] && return
                if [[ -n "$ws_name" ]]; then
                    local idx=$((REPLY - 1))
                    local target_path="${ws_paths[$idx]}"
                    
                    if [[ -d "$target_path" ]]; then
                        cd "$target_path" || return
                        print_success "Switched to: ${ws_name}"
                        print_info "Location: ${target_path}"
                        
                        # 重新读取项目配置
                        read_config
                        apply_config_priority  # 💡 应用项目级配置覆盖
                    else
                        print_error "Directory not found: ${target_path}"
                    fi
                    break
                fi
            done
            ;;
            
        4) # 删除工作区
            if [[ ! -f "$WORKSPACE_FILE" ]] || [[ ! -s "$WORKSPACE_FILE" ]]; then
                print_error "No workspaces saved"
                return
            fi
            
            echo ""
            print_info "Select workspace to remove:"
            
            local -a ws_names=()
            while IFS='|' read -r name path; do
                ws_names+=("$name")
            done < "$WORKSPACE_FILE"
            
            select ws_name in "${ws_names[@]}" "[Cancel]"; do
                [[ "$ws_name" == "[Cancel]" ]] && return
                if [[ -n "$ws_name" ]]; then
                    if prompt_confirm "Remove workspace ${ws_name}?" "n"; then
                        # 删除对应行
                        sed -i "/^${ws_name}|/d" "$WORKSPACE_FILE"
                        print_success "Removed workspace: ${ws_name}"
                    fi
                    break
                fi
            done
            ;;
            
        5) # 返回
            return
            ;;
    esac
}

# 工具集菜单
tools_menu() {
    while true; do
        draw_header "Tools & Utilities" "LaTeX productivity tools"
        
        echo -e "${C_ACCENT}Available Tools:${C_RESET}\n"
        echo "  1) [M] Manage Templates - 管理自定义模板库"
        echo "  2) [W] Workspace Manager - 项目工作区切换"
        echo "  3) [B] Manage Bibliography - 管理BibTeX文献"
        echo "  4) [Q] Back to Main Menu"
        echo ""
        
        echo -en "${C_WARNING}?#${C_RESET} Select tool [1-4]: "
        read -r choice
        
        case "$choice" in
            1) manage_templates ;;
            2) manage_workspaces ;;
            3) manage_bibliography ;;
            4) return ;;
            *) print_error "Invalid selection" ;;
        esac
    done
}

# 诊断工具菜单
diagnostics_menu() {
    while true; do
        draw_header "Diagnostics & Analysis" "Troubleshooting tools"
        
        echo -e "${C_ACCENT}Diagnostic Tools:${C_RESET}\n"
        echo "  1) [=] Word Count & Statistics - 字数统计"
        echo "  2) [?] Check Package Dependencies - 检测缺失宏包"
        echo "  3) [!] Diagnose Errors - 智能错误分析"
        echo "  4) [Q] Back to Main Menu"
        echo ""
        
        echo -en "${C_WARNING}?#${C_RESET} Select tool [1-4]: "
        read -r choice
        
        case "$choice" in
            1) word_count_report ;;
            2) check_missing_packages ;;
            3) diagnose_errors ;;
            4) return ;;
            *) print_error "Invalid selection" ;;
        esac
    done
}

# 项目信息菜单
project_info_menu() {
    while true; do
        draw_header "Project Information" "View project details"
        
        echo -e "${C_ACCENT}Information Views:${C_RESET}\n"
        echo "  1) [i] Project Summary - 项目文件统计"
        echo "  2) [@] Compilation History - 编译历史记录"
        echo "  3) [Q] Back to Main Menu"
        echo ""
        
        echo -en "${C_WARNING}?#${C_RESET} Select view [1-3]: "
        read -r choice
        
        case "$choice" in
            1) show_project_summary ;;
            2) show_history ;;
            3) return ;;
            *) print_error "Invalid selection" ;;
        esac
    done
}

# ==============================================================================
# SECTION 7: 设置菜单
# ==============================================================================

theme_selector() {
    while true; do
        draw_header "Theme Selector" "Choose your color scheme"
        list_themes
        
        local themes=(default nord dracula sakura matrix gruvbox monokai "[Preview Current]" "[Back]")
        select theme in "${themes[@]}"; do
            case "$theme" in
                "[Back]") return ;;
                "[Preview Current]")
                    preview_theme "$CFG_ACTIVE_THEME"
                    break
                    ;;
                "")
                    print_error "Invalid selection"
                    break
                    ;;
                *)
                    CFG_ACTIVE_THEME="$theme"
                    load_theme "$theme"
                    preview_theme "$theme"
                    
                    if [[ -f "$USER_CONFIG" ]]; then
                        sed -i "s/^active_theme = .*/active_theme = ${theme}/" "$USER_CONFIG"
                        print_success "Theme saved to config"
                    fi
                    break
                    ;;
            esac
        done
    done
}

settings_menu() {
    while true; do
        draw_header "Settings & Configuration" "Customize your experience"
        
        echo -e "${C_ACCENT}[*] Current Settings:${C_RESET}\n"
        draw_table_2col \
            "Theme:${CFG_ACTIVE_THEME}" \
            "Default Engine:${CFG_DEFAULT_ENGINE}" \
            "Auto Cleanup:${CFG_AUTO_CLEANUP}" \
            "Auto Open PDF:${CFG_AUTO_OPEN_PDF}" \
            "History Enabled:${CFG_ENABLE_HISTORY}"
        
        echo ""
        local menu_items=(
            "[#] Change Theme"
            "[*] Edit Config File"
            "[!] Reset to Defaults"
            "[Q] Back to Main Menu"
        )
        
        select choice in "${menu_items[@]}"; do
            case "$choice" in
                *"Change Theme") theme_selector; break ;;
                *"Edit Config File")
                    if [[ -f "$USER_CONFIG" ]]; then
                        ${CFG_EDITOR:-nvim} "$USER_CONFIG"
                        load_user_config
                        print_success "Config reloaded!"
                    fi
                    break
                    ;;
                *"Reset to Defaults")
                    if prompt_confirm "Reset all settings to defaults?" "n"; then
                        rm -f "$USER_CONFIG"
                        init_user_config
                        load_user_config
                        print_success "Settings reset to defaults"
                    fi
                    break
                    ;;
                *"Back to Main Menu") return ;;
                *) print_error "Invalid selection"; break ;;
            esac
        done
    done
}

# ==============================================================================
# MAIN ENTRY POINT
# ==============================================================================

detect_os
init_user_config
load_user_config

if ! command -v latexmk &> /dev/null; then
    print_error "CRITICAL ERROR: 'latexmk' command not found."
    echo "Install it with: sudo dnf install latexmk"
    exit 1
fi

# CLI Mode
if [[ $# -gt 0 ]]; then
    main_file_arg=""
    engine_arg="xelatex" 
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -e|--engine) engine_arg="$2"; shift ;;
            -h|--help) echo "Usage: $0 [file.tex] [-e xelatex]"; exit 0 ;;
            *) main_file_arg="$1" ;;
        esac
        shift
    done
    [[ -z "$main_file_arg" ]] && { echo "Error: No file."; exit 1; }
    case "$engine_arg" in
        pdflatex) flag="-pdf" ;; lualatex) flag="-lualatex" ;; *) flag="-xelatex" ;;
    esac
    compile_latexmk "$flag" "${main_file_arg%.tex}" "autoclean"
    exit 0
fi

# Interactive Mode
read_config
apply_config_priority  # 💡 应用项目级配置覆盖
show_logo "v${SCRIPT_VERSION}"

while true; do
    draw_header "LaTeX Compiler Pro" "v${SCRIPT_VERSION} • ${CURRENT_OS} • Theme: ${CFG_ACTIVE_THEME}"
    
    local menu_items=()
    
    # 检查历史记录中的有效文件
    if [[ -f "$HISTORY_FILE" ]] && [[ -s "$HISTORY_FILE" ]]; then
        local -a history_lines=("${(@f)$(cat "$HISTORY_FILE")}")
        local found=false
        local last_file
        
        for line in "${history_lines[@]}"; do
            IFS='|' read -r timestamp file engine success <<< "$line"
            if [[ -f "$file" ]]; then
                last_file="$file"
                found=true
                break
            fi
        done
        
        if [[ "$found" == "true" ]]; then
            menu_items+=("[>>>] Quick Recompile (${last_file})")
        fi
    fi
    
    if $HAS_CONFIG; then
        menu_items+=("[F] Compile with project config")
    fi
    
    menu_items+=(
        "[+] Compile interactively"
        "[T] Generate Template"
        "[*] Create/Update Config"
        "[~] Clean auxiliary files"
        "[U] Tools & Utilities"
        "[D] Diagnostics"
        "[I] Project Info"
        "[#] Settings & Themes"
        "[Q] Quit"
    )

    # 显示菜单项和中文说明
    echo -e "${C_DIM}选择操作（输入数字）：${C_RESET}\n"
    
    local i=1
    for item in "${menu_items[@]}"; do
        echo -e "${C_ACCENT}${i})${C_RESET} ${item}"
        
        # 根据菜单项显示中文说明
        case "$item" in
            *"Quick Recompile"*)
                echo -e "   ${C_DIM}→ 快速重编译上次文件，无需重新选择${C_RESET}"
                ;;
            *"Compile with project config"*)
                echo -e "   ${C_DIM}→ 使用 .latexcfg 批量编译多个文件${C_RESET}"
                ;;
            *"Compile interactively"*)
                echo -e "   ${C_DIM}→ 交互式选择文件和编译引擎${C_RESET}"
                ;;
            *"Generate Template"*)
                echo -e "   ${C_DIM}→ 快速生成LaTeX模板（论文/幻灯片/简历等）${C_RESET}"
                ;;
            *"Create/Update Config"*)
                echo -e "   ${C_DIM}→ 创建项目配置文件，支持批量编译${C_RESET}"
                ;;
            *"Clean auxiliary files"*)
                echo -e "   ${C_DIM}→ 清理 .aux .log 等辅助文件${C_RESET}"
                ;;
            *"Tools & Utilities"*)
                echo -e "   ${C_DIM}→ 模板管理、工作区、文献等工具（3项）${C_RESET}"
                ;;
            *"Diagnostics"*)
                echo -e "   ${C_DIM}→ 字数统计、依赖检测、错误诊断（3项）${C_RESET}"
                ;;
            *"Project Info"*)
                echo -e "   ${C_DIM}→ 项目摘要、编译历史等信息（2项）${C_RESET}"
                ;;
            *"Settings & Themes"*)
                echo -e "   ${C_DIM}→ 修改主题、引擎等全局配置${C_RESET}"
                ;;
            *"Quit"*)
                echo -e "   ${C_DIM}→ 退出程序${C_RESET}"
                ;;
        esac
        ((i++))
    done
    
    echo ""
    echo -en "${C_WARNING}?#${C_RESET} "
    read -r choice
    
    # 验证输入
    if [[ ! "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#menu_items[@]} )); then
        print_error "无效的选择（请输入 1-${#menu_items[@]}）"
        continue
    fi
    
    local main_choice="${menu_items[$choice]}"
    
    case "$main_choice" in
        *"Quick Recompile"*) quick_recompile ;;
        *"Compile with project config") compile_with_config ;;
        *"Compile interactively") interactive_compile_logic ;;
        *"Generate Template"*) generate_template ;;
        *"Create/Update Config"*) generate_config_template ;;
        *"Clean auxiliary files") clstex ;;
        *"Tools & Utilities"*) tools_menu ;;
        *"Diagnostics"*) diagnostics_menu ;;
        *"Project Info"*) project_info_menu ;;
        *"Settings & Themes") settings_menu ;;
        *"Quit")
            echo ""
            print_success "Goodbye!"
            exit 0
            ;;
        *) print_error "Invalid selection" ;;
    esac
done
