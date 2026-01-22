#!/bin/zsh

# ==============================================================================
#
#   texcompile.sh - 专业级 LaTeX 交互式编译脚本 (旗舰版 v5.2)
#
#   更新日志 v5.2:
#   1. 修复: 配置文件生成向导中的换行符问题 (生成真正的换行而非 literal \n)。
#   2. 修复: 增强配置解析器，解决因换行符(CRLF)或文件尾缺失换行导致的读取失败问题。
#   3. 优化: 使用 Zsh 原生数组处理文件流，解析更稳健。
#
# ==============================================================================

# --- Color Definitions / 颜色定义 ---
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'
C_CYAN='\033[0;36m'
C_PURPLE='\033[0;35m'
C_BOLD='\033[1m'
C_RESET='\033[0m'

# --- Global Config Variables / 全局配置变量 ---
CONFIG_FILE=".latexcfg"

# 使用关联数组存储多目标配置
# 结构: CFG_TARGETS[index,KEY]
# 例如: CFG_TARGETS[1,FILE]="main.tex", CFG_TARGETS[1,ENGINE]="xelatex"
typeset -A CFG_TARGETS
CFG_TARGET_COUNT=0
HAS_CONFIG=false

# OS 相关变量
CURRENT_OS="unknown"
OPEN_CMD=""

# --- System Detection / 系统环境检测 ---

detect_os() {
    local kernel_name=$(uname -s)
    case "$kernel_name" in
        Darwin*)
            CURRENT_OS="macOS"
            OPEN_CMD="open"
            ;;
        Linux*)
            # 检测是否为 WSL (Windows Subsystem for Linux)
            if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
                CURRENT_OS="WSL"
                # WSL 下优先尝试 wslview (wslu)，否则使用 explorer.exe
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

# --- Helper Functions / 辅助功能函数 ---

# 编译后自动打开 PDF
open_pdf() {
    local pdf_file="$1"
    if [[ ! -f "$pdf_file" ]]; then
        return
    fi

    print -n "${C_BLUE}Open the generated PDF file (${C_BOLD}${CURRENT_OS}${C_RESET}${C_BLUE})? [y/n] ${C_RESET}"
    read -q REPLY
    echo
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        if [[ -n "$OPEN_CMD" ]]; then
            echo -e "${C_CYAN}==> Opening with: ${OPEN_CMD} ...${C_RESET}"
            $OPEN_CMD "$pdf_file" &> /dev/null
        else
            echo -e "${C_YELLOW}Warning: Could not detect a way to open PDF on ${CURRENT_OS}.${C_RESET}"
        fi
    fi
}

# 增强的清理函数
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
            target_files+=(*."${ext}"(N))
        done
    fi

    if (( ${#target_files[@]} == 0 )); then
        echo -e "${C_GREEN}==> No LaTeX auxiliary files found to clean.${C_RESET}"
        return 0
    fi

    echo -e "${C_YELLOW}==> The following ${C_BOLD}${#target_files[@]}${C_RESET}${C_YELLOW} files will be deleted:${C_RESET}"
    if (( ${#target_files[@]} > 10 )); then
        print -l "${target_files[@]:0:10}"
        echo "... and $((${#target_files[@]} - 10)) more."
    else
        print -l "${target_files[@]}"
    fi

    print -n "${C_RED}${C_BOLD}Are you sure? [y/n] ${C_RESET}"
    read -q REPLY
    echo
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        rm -f "${target_files[@]}"
        echo -e "\n${C_GREEN}==> Cleanup complete! Removed ${C_BOLD}${#target_files[@]}${C_RESET}${C_GREEN} files.${C_RESET}"
    else
        echo -e "\n${C_BLUE}==> Operation canceled.${C_RESET}"
    fi
}

# 编译失败时显示日志
show_log_error() {
    local log_file="$1"
    if [[ ! -f "$log_file" ]]; then return; fi
    
    print -n "${C_RED}View end of log file ${log_file} to locate errors? [y/n] ${C_RESET}"
    read -q REPLY
    echo
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        echo -e "${C_YELLOW}--- Last 25 lines of ${log_file} ---${C_RESET}"
        tail -n 25 "${log_file}"
        echo -e "${C_YELLOW}------------------------------------${C_RESET}"
    fi
}

# --- Parsing Config / 配置文件解析 ---

read_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        echo -e "${C_CYAN}Reading configuration from ${CONFIG_FILE}...${C_RESET}"
        
        # 重置配置
        CFG_TARGETS=()
        CFG_TARGET_COUNT=0
        local max_idx=0

        # V5.1 FIX: 使用 Zsh 原生数组读取，彻底解决换行符和 read 循环退出的问题
        # 1. cat 读取内容
        # 2. tr -d '\r' 删除 Windows 回车符
        # 3. "${(@f)...}" 按行分割到 lines 数组
        local file_content=$(cat "$CONFIG_FILE" | tr -d '\r')
        local -a lines=("${(@f)file_content}")

        for line in "${lines[@]}"; do
            # 忽略注释和空行 (更加健壮的正则)
            [[ "$line" =~ ^[[:space:]]*# ]] && continue
            [[ -z "${line//[[:space:]]/}" ]] && continue
            
            # 分割 key 和 value (使用参数扩展，不依赖 IFS)
            local key="${line%%=*}"
            local value="${line#*=}"
            
            # Trim spaces
            key="${key#"${key%%[![:space:]]*}"}"
            key="${key%"${key##*[![:space:]]}"}"
            value="${value#"${value%%[![:space:]]*}"}" 
            value="${value%"${value##*[![:space:]]}"}" 
            
            # Remove quotes
            value=${value#[\"\']}
            value=${value%[\"\']}

            # 解析逻辑
            if [[ "$key" == "MAIN_FILE" ]]; then
                # 兼容旧版配置
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
            # 新版批量解析: TARGET_n_KEY
            elif [[ "$key" =~ ^TARGET_([0-9]+)_(FILE|ENGINE|BIB_TOOL)$ ]]; then
                local idx=${match[1]}
                local field=${match[2]}
                CFG_TARGETS[$idx,$field]="$value"
                if (( idx > max_idx )); then max_idx=$idx; fi
            fi
        done

        CFG_TARGET_COUNT=$max_idx

        if (( CFG_TARGET_COUNT > 0 )); then
            HAS_CONFIG=true
            echo -e "  -> Detected ${C_BOLD}${CFG_TARGET_COUNT}${C_RESET} compilation targets."
        else
            echo -e "${C_RED}  -> Config file found but no valid targets detected. Check syntax.${C_RESET}"
            HAS_CONFIG=false
        fi
    else
        HAS_CONFIG=false
    fi
}

# --- Config Generator / 配置文件生成向导 ---

generate_config_template() {
    echo -e "\n${C_PURPLE}=== Generate Batch Project Configuration (.latexcfg) ===${C_RESET}"
    echo -e "${C_CYAN}This wizard creates a config file supporting multiple files with individual settings.${C_RESET}"

    local files=(*.tex(N))
    if (( ${#files[@]} == 0 )); then
        echo -e "${C_RED}No .tex files found! Cannot generate config.${C_RESET}"
        return
    fi

    local temp_config_content=""
    local idx=1
    
    while true; do
        echo -e "\n${C_BOLD}--- Configuring Target #${idx} ---${C_RESET}"
        
        # 1. Select File
        local selected_file=""
        echo -e "${C_BOLD}Select TeX file for Target #${idx}:${C_RESET}"
        select f in "${files[@]}"; do
            if [[ -n "$f" ]]; then selected_file="$f"; break; fi
        done

        # 2. Select Engine
        local selected_engine=""
        echo -e "${C_BOLD}Select engine for ${selected_file}:${C_RESET}"
        select e in "xelatex" "pdflatex" "lualatex"; do
            if [[ -n "$e" ]]; then selected_engine="$e"; break; fi
        done

        # 3. Select Bib Tool
        local selected_bib=""
        echo -e "${C_BOLD}Select bib tool for ${selected_file}:${C_RESET}"
        select b in "none" "biber" "bibtex"; do
            if [[ -n "$b" ]]; then selected_bib="$b"; break; fi
        done
        [[ "$selected_bib" == "none" ]] && selected_bib=""

        # Append to config buffer (V5.2 Fix: Use $'\n' for real newlines)
        temp_config_content+=$'\n'"TARGET_${idx}_FILE = \"${selected_file}\""
        temp_config_content+=$'\n'"TARGET_${idx}_ENGINE = \"${selected_engine}\""
        temp_config_content+=$'\n'"TARGET_${idx}_BIB_TOOL = \"${selected_bib}\""

        # 4. Continue?
        echo -e "\n${C_BLUE}Do you want to add another file? [y/n]${C_RESET}"
        read -q REPLY
        echo
        if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
            break
        fi
        ((idx++))
    done

    # Write File
    echo -e "\n${C_YELLOW}Writing to ${CONFIG_FILE}...${C_RESET}"
    
    cat > "$CONFIG_FILE" <<EOF
# LaTeX Project Configuration (Batch Mode)
# Generated by texcompile.sh

# This format is compatible with Bash, Zsh, and PowerShell (ConvertFrom-StringData).
# Format: TARGET_{index}_{KEY} = "VALUE"
${temp_config_content}
EOF

    echo -e "${C_GREEN}Configuration file created successfully!${C_RESET}"
    read_config # Reload config immediately
}

# --- Compilation Logic / 编译逻辑 ---

# 核心编译执行器 (Latexmk)
compile_latexmk() {
    local engine_flag="$1"
    local base_name="$2"
    local do_clean="$3" # "autoclean" or empty
    
    echo -e "\n${C_BLUE}===== Compiling ${C_BOLD}${base_name}.tex${C_RESET}${C_BLUE} with latexmk (${engine_flag}) =====${C_RESET}"
    local cmd=(latexmk "${engine_flag}" -synctex=1 -file-line-error -interaction=nonstopmode -halt-on-error)
    "${cmd[@]}" "${base_name}.tex"

    if [ $? -eq 0 ]; then
        echo -e "${C_GREEN}===== Successfully compiled: ${base_name}.pdf =====${C_RESET}"
        open_pdf "${base_name}.pdf"
        
        if [[ "$do_clean" == "autoclean" ]]; then
            latexmk -c "${base_name}.tex"
        else
             print -n "${C_BLUE}Run cleanup (latexmk -c)? [y/n] ${C_RESET}"
             read -q REPLY; echo
             [[ "$REPLY" =~ ^[Yy]$ ]] && latexmk -c "${base_name}.tex"
        fi
    else 
        echo -e "${C_RED}Error: latexmk compilation failed!${C_RESET}"
        show_log_error "${base_name}.log"
        return 1
    fi
}

# 辅助：根据配置执行单个任务
run_target_task() {
    local idx="$1"
    local filename="${CFG_TARGETS[$idx,FILE]}"
    local engine="${CFG_TARGETS[$idx,ENGINE]}"
    local bib="${CFG_TARGETS[$idx,BIB_TOOL]}" # 目前主要给 manual chain 用，latexmk 会自动探测

    if [[ -z "$filename" ]]; then
        echo -e "${C_RED}Error: Target #$idx is missing filename.${C_RESET}"
        return
    fi
    
    local base_name="${filename%.tex}"
    local flag="-${engine}" # xelatex -> -xelatex
    if [[ "$engine" == "pdflatex" ]]; then flag="-pdf"; fi
    
    # 目前默认使用 latexmk，若需支持配置中的 bib_tool 强制手动链，可在此扩展
    compile_latexmk "$flag" "$base_name"
}

# 批量执行所有配置
compile_all_targets() {
    echo -e "\n${C_PURPLE}=== Starting Batch Compilation (${CFG_TARGET_COUNT} targets) ===${C_RESET}"
    for ((i=1; i<=CFG_TARGET_COUNT; i++)); do
        echo -e "\n${C_CYAN}>>> Processing Target #$i${C_RESET}"
        run_target_task "$i"
    done
    echo -e "\n${C_GREEN}=== Batch Compilation Finished ===${C_RESET}"
}

# 使用配置编译 - 菜单
compile_with_config() {
    if (( CFG_TARGET_COUNT == 0 )); then
        echo -e "${C_RED}No targets defined in config.${C_RESET}"
        return
    fi

    # 如果只有一个目标，直接编译
    if (( CFG_TARGET_COUNT == 1 )); then
        run_target_task 1
        return
    fi

    # 如果有多个目标，显示选择菜单
    echo -e "\n${C_BOLD}Multi-target config detected. Choose action:${C_RESET}"
    
    # 构造菜单数组
    local target_menu=("!! Compile ALL Targets !!")
    for ((i=1; i<=CFG_TARGET_COUNT; i++)); do
        local fname="${CFG_TARGETS[$i,FILE]}"
        local eng="${CFG_TARGETS[$i,ENGINE]}"
        target_menu+=("Target #$i: $fname ($eng)")
    done
    target_menu+=("!! Go Back !!")

    select t_choice in "${target_menu[@]}"; do
        case "$t_choice" in
            "!! Go Back !!") return ;;
            "!! Compile ALL Targets !!") compile_all_targets; break ;;
            *)
                # 提取 Target 编号
                if [[ "$t_choice" =~ Target\ #([0-9]+) ]]; then
                    local t_idx=${match[1]}
                    run_target_task "$t_idx"
                    break
                else
                    echo -e "${C_RED}Invalid selection.${C_RESET}"
                fi
                ;;
        esac
    done
}

# 手动编译链 (Manual Chain - 备用方案)
compile_manual_chain() {
    local compiler="$1"
    local bib_tool="$2"
    local base_name="$3"
    
    echo -e "\n${C_PURPLE}===== Manual Chain: ${compiler} -> ${bib_tool} -> ${compiler} x2 =====${C_RESET}"
    
    echo -e "${C_YELLOW}[1/4] Running ${compiler} (Pass 1)...${C_RESET}"
    $compiler -interaction=nonstopmode -halt-on-error "${base_name}.tex" || { show_log_error "${base_name}.log"; return 1; }

    if [[ "$bib_tool" != "none" ]]; then
        echo -e "${C_YELLOW}[2/4] Running ${bib_tool}...${C_RESET}"
        if [[ "$bib_tool" == "biber" ]]; then
            biber "${base_name}"
        elif [[ "$bib_tool" == "bibtex" ]]; then
            bibtex "${base_name}"
        fi
        if [ $? -ne 0 ]; then echo -e "${C_RED}Warning: ${bib_tool} exited with errors.${C_RESET}"; fi
    else
        echo -e "${C_YELLOW}[2/4] Skipping bibliography step...${C_RESET}"
    fi

    echo -e "${C_YELLOW}[3/4] Running ${compiler} (Pass 2)...${C_RESET}"
    $compiler -interaction=nonstopmode -halt-on-error "${base_name}.tex" > /dev/null
    
    echo -e "${C_YELLOW}[4/4] Running ${compiler} (Pass 3)...${C_RESET}"
    $compiler -interaction=nonstopmode -halt-on-error "${base_name}.tex"
    
    if [ $? -eq 0 ]; then
        echo -e "${C_GREEN}===== Manual Compilation Success =====${C_RESET}"
        open_pdf "${base_name}.pdf"
    else
        echo -e "${C_RED}Error: Final compilation pass failed!${C_RESET}"
        show_log_error "${base_name}.log"
    fi
}

# 实时预览 (pvc)
compile_pvc() {
    local engine_flag="$1"
    local base_name="$2"
    echo -e "\n${C_BLUE}===== Starting live preview for ${C_BOLD}${base_name}.tex${C_RESET}${C_BLUE} =====${C_RESET}"
    echo -e "${C_YELLOW}Watching for file changes... Press Ctrl+C to stop.${C_RESET}"
    latexmk "${engine_flag}" -pvc -synctex=1 -interaction=nonstopmode -halt-on-error "${base_name}.tex"
}

# 交互式选择逻辑 (非 Config 模式)
interactive_compile_logic() {
    local files=(*.tex(N)) 
    if (( ${#files[@]} == 0 )); then echo -e "${C_RED}Error: No .tex files found.${C_RESET}"; return; fi
    
    local targets=()
    echo -e "${C_BOLD}Select a TeX file to compile:${C_RESET}"
    local menu_items=("${files[@]}" "!! Compile All !!" "!! Go Back !!")
    
    select file_choice in "${menu_items[@]}"; do
        case "$file_choice" in 
            "!! Go Back !!") return ;; 
            "!! Compile All !!") targets=("${files[@]}"); break ;; 
            *) if [[ -n "$file_choice" ]]; then targets=("$file_choice"); break; fi ;;
        esac
    done

    echo -e "\n${C_BOLD}Select Compilation Mode:${C_RESET}"
    local modes=(
        "Auto: Latexmk (XeLaTeX) [Recommended]"
        "Auto: Latexmk (PDFLaTeX)"
        "Auto: Latexmk (LuaLaTeX)"
        "Live: Preview Mode (XeLaTeX)"
        "Manual: XeLaTeX + Biber"
        "Manual: XeLaTeX + BibTeX"
        "Manual: PDFLaTeX + BibTeX"
        "!! Go Back !!"
    )

    select mode in "${modes[@]}"; do
        case "$mode" in
            "!! Go Back !!") return ;;
            "Auto: Latexmk (XeLaTeX) [Recommended]")
                for t in "${targets[@]}"; do compile_latexmk "-xelatex" "${t%.tex}"; done; break ;;
            "Auto: Latexmk (PDFLaTeX)")
                for t in "${targets[@]}"; do compile_latexmk "-pdf" "${t%.tex}"; done; break ;;
            "Auto: Latexmk (LuaLaTeX)")
                for t in "${targets[@]}"; do compile_latexmk "-lualatex" "${t%.tex}"; done; break ;;
            "Live: Preview Mode (XeLaTeX)")
                compile_pvc "-xelatex" "${targets[0]%.tex}"; break ;;
            "Manual: XeLaTeX + Biber")
                for t in "${targets[@]}"; do compile_manual_chain "xelatex" "biber" "${t%.tex}"; done; break ;;
            "Manual: XeLaTeX + BibTeX")
                for t in "${targets[@]}"; do compile_manual_chain "xelatex" "bibtex" "${t%.tex}"; done; break ;;
            "Manual: PDFLaTeX + BibTeX")
                for t in "${targets[@]}"; do compile_manual_chain "pdflatex" "bibtex" "${t%.tex}"; done; break ;;
            *) echo -e "${C_RED}Invalid selection.${C_RESET}" ;;
        esac
    done
}


# --- Script Entry Point ---

detect_os
if ! command -v latexmk &> /dev/null; then
    echo -e "${C_RED}CRITICAL ERROR: 'latexmk' command not found.${C_RESET}"
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
while true; do
    echo -e "\n${C_BLUE}--- LaTeX Compiler Tool v5.2 (${CURRENT_OS}) ---${C_RESET}"
    
    local menu_options=("Compile interactively" "Create/Update Config (.latexcfg)" "Clean auxiliary files" "Quit")
    if $HAS_CONFIG; then
        menu_options=("Compile with project config" "${menu_options[@]}")
    fi

    select main_choice in "${menu_options[@]}"; do
        case "$main_choice" in
            "Compile with project config") compile_with_config; break ;;
            "Compile interactively") interactive_compile_logic; break ;;
            "Create/Update Config (.latexcfg)") generate_config_template; break ;;
            "Clean auxiliary files") clstex; break ;;
            "Quit") echo -e "${C_GREEN}Bye!${C_RESET}"; exit 0 ;;
            *) echo -e "${C_RED}Invalid selection.${C_RESET}" ;;
        esac
    done
done
