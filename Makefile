.PHONY: help install clean test docs deploy-bash deploy-zsh deploy-all update

# ============================================================================
# 🚀 Fedora 43 配置管理 Makefile
# 用途: 统一管理配置部署、文档生成、测试和维护
# 作者: SMLYFM <yytcjx@gmail.com>
# ============================================================================

# 项目变量
PROJECT_NAME := Fedora 43 配置仓库
REPO_URL     := https://github.com/goblinunde/resource-fedora
SETUP_SCRIPT := ./setup.sh
SHELL_DIR    := $(HOME)

# ============================================================================
# 默认目标: 显示帮助
# ============================================================================

help:  ## 显示此帮助信息
	@echo ""
	@echo "==========================================================================="
	@echo "                  Fedora 43 配置仓库 - Makefile 帮助                       "
	@echo "==========================================================================="
	@echo ""
	@echo "使用方式: make <target>"
	@echo ""
	@echo "可用命令"
	@echo "---------------------------------------------------------------------------"
	@printf "  %-20s %s\n" "install" "一键部署所有配置 [推荐]"
	@printf "  %-20s %s\n" "interactive" "交互式菜单部署"
	@printf "  %-20s %s\n" "deploy-bash" "部署 Bash 配置"
	@printf "  %-20s %s\n" "deploy-zsh" "部署 Zsh 配置"
	@printf "  %-20s %s\n" "deploy-fish" "部署 Fish 配置"
	@printf "  %-20s %s\n" "deploy-nushell" "部署 Nushell 配置"
	@printf "  %-20s %s\n" "deploy-vim" "部署 Vim 配置"
	@printf "  %-20s %s\n" "deploy-nvim" "部署 Neovim 配置"
	@printf "  %-20s %s\n" "deploy-tmux" "部署 Tmux 配置"
	@printf "  %-20s %s\n" "deploy-yazi" "部署 Yazi 文件管理器"
	@printf "  %-20s %s\n" "deploy-git" "部署 Git 配置"
	@printf "  %-20s %s\n" "deploy-starship" "部署 Starship 主题"
	@echo "---------------------------------------------------------------------------"
	@printf "  %-20s %s\n" "docs" "在浏览器中查看文档"
	@printf "  %-20s %s\n" "readme" "查看 README.md"
	@printf "  %-20s %s\n" "list-docs" "列出所有可用文档"
	@echo "---------------------------------------------------------------------------"
	@printf "  %-20s %s\n" "check" "检查配置文件完整性"
	@printf "  %-20s %s\n" "clean" "清理临时文件"
	@printf "  %-20s %s\n" "update" "更新仓库 (git pull)"
	@printf "  %-20s %s\n" "backup" "手动备份当前配置"
	@printf "  %-20s %s\n" "restore" "恢复最近的备份"
	@echo "---------------------------------------------------------------------------"
	@printf "  %-20s %s\n" "test" "运行所有测试"
	@printf "  %-20s %s\n" "test-shell" "测试 Shell 配置语法"
	@printf "  %-20s %s\n" "lint" "检查脚本语法 (shellcheck)"
	@echo "---------------------------------------------------------------------------"
	@printf "  %-20s %s\n" "info" "显示项目信息和统计"
	@printf "  %-20s %s\n" "version" "显示版本信息"
	@printf "  %-20s %s\n" "help" "显示此帮助信息"
	@echo "---------------------------------------------------------------------------"
	@echo ""
	@echo "使用示例"
	@echo "  make install                        # 一键部署所有配置"
	@echo "  make deploy-zsh deploy-nvim         # 部署多个模块"
	@echo "  make update && make install         # 更新并重新部署"
	@echo ""
	@echo "==========================================================================="
	@echo "  更多信息: $(REPO_URL)"
	@echo ""

# ============================================================================
# 部署命令
# ============================================================================

install: ## 一键部署所有配置
	@echo "$(COLOR_GREEN)🚀 开始部署所有配置...$(COLOR_RESET)"
	@bash $(SETUP_SCRIPT) --all

interactive: ## 交互式菜单部署
	@bash $(SETUP_SCRIPT) --interactive

deploy-bash: ## 部署 Bash 配置
	@echo "$(COLOR_CYAN)📦 部署 Bash 配置...$(COLOR_RESET)"
	@bash $(SETUP_SCRIPT) --shell bash

deploy-zsh: ## 部署 Zsh 配置
	@echo "$(COLOR_CYAN)📦 部署 Zsh 配置...$(COLOR_RESET)"
	@bash $(SETUP_SCRIPT) --shell zsh

deploy-fish: ## 部署 Fish 配置
	@echo "$(COLOR_CYAN)📦 部署 Fish 配置...$(COLOR_RESET)"
	@bash $(SETUP_SCRIPT) --shell fish

deploy-nushell: ## 部署 Nushell 配置
	@echo "$(COLOR_CYAN)📦 部署 Nushell 配置...$(COLOR_RESET)"
	@bash $(SETUP_SCRIPT) --shell nushell

deploy-vim: ## 部署 Vim 配置
	@echo "$(COLOR_CYAN)📦 部署 Vim 配置...$(COLOR_RESET)"
	@bash $(SETUP_SCRIPT) --editor vim

deploy-nvim: ## 部署 Neovim 配置
	@echo "$(COLOR_CYAN)📦 部署 Neovim 配置...$(COLOR_RESET)"
	@bash $(SETUP_SCRIPT) --editor nvim

deploy-tmux: ## 部署 Tmux 配置
	@echo "$(COLOR_CYAN)📦 部署 Tmux 配置...$(COLOR_RESET)"
	@bash $(SETUP_SCRIPT) --tmux

deploy-git: ## 部署 Git 配置
	@echo "$(COLOR_CYAN)📦 部署 Git 配置...$(COLOR_RESET)"
	@bash $(SETUP_SCRIPT) --git

deploy-yazi: ## 部署 Yazi 文件管理器
	@echo "$(COLOR_CYAN)📦 部署 Yazi 文件管理器...$(COLOR_RESET)"
	@if [ -d "yazi" ]; then \
		bash yazi/install_yazi_config.sh; \
	else \
		echo "$(COLOR_RED)错误: yazi 配置目录不存在$(COLOR_RESET)"; \
	fi

deploy-starship: ## 部署 Starship 主题
	@echo "$(COLOR_CYAN)📦 部署 Starship 主题...$(COLOR_RESET)"
	@bash $(SETUP_SCRIPT) --starship

# ============================================================================
# 文档命令
# ============================================================================

docs: ## 在浏览器中查看所有文档
	@echo "$(COLOR_CYAN)📚 打开文档...$(COLOR_RESET)"
	@if [ -f "README.md" ]; then \
		xdg-open "README.md" 2>/dev/null || open "README.md" 2>/dev/null || echo "请手动打开 README.md"; \
	fi

readme: ## 查看 README
	@if command -v bat > /dev/null 2>&1; then \
		bat README.md; \
	else \
		less README.md; \
	fi

list-docs: ## 列出所有可用文档
	@echo "$(COLOR_BOLD)$(COLOR_CYAN)📚 可用文档列表:$(COLOR_RESET)"
	@echo ""
	@echo "$(COLOR_BOLD)核心文档:$(COLOR_RESET)"
	@[ -f "README.md" ] && echo "  ✓ README.md - 项目总览" || echo "  ✗ README.md"
	@echo ""
	@echo "$(COLOR_BOLD)配置教程 (docs/):$(COLOR_RESET)"
	@[ -f "docs/DEV_ENV_FEDORA.md" ] && echo "  ✓ DEV_ENV_FEDORA.md - Fedora 开发环境配置" || true
	@[ -f "docs/DEV_ENV_UBUNTU.md" ] && echo "  ✓ DEV_ENV_UBUNTU.md - Ubuntu 开发环境配置" || true
	@[ -f "docs/ENV_VARS.md" ] && echo "  ✓ ENV_VARS.md - 环境变量配置指南" || true
	@[ -f "docs/COMMON_COMMANDS.md" ] && echo "  ✓ COMMON_COMMANDS.md - 常用命令速查表" || true
	@[ -f "docs/SHELL_CONFIG_GUIDE.md" ] && echo "  ✓ SHELL_CONFIG_GUIDE.md - Shell 配置文件完整解析" || true
	@[ -f "docs/LATEX_COMPILE_GUIDE.md" ] && echo "  ✓ LATEX_COMPILE_GUIDE.md - LaTeX 编译脚本指南" || true
	@echo ""
	@echo "$(COLOR_BOLD)其他文档:$(COLOR_RESET)"
	@[ -f "docs/VIM.md" ] && echo "  ✓ VIM.md - Vim 配置说明" || true
	@[ -f "nvim/README.md" ] && echo "  ✓ nvim/README.md - Neovim 配置说明" || true
	@[ -f "ruff/README.md" ] && echo "  ✓ ruff/README.md - Ruff 配置说明" || true
	@echo ""

# ============================================================================
# 维护命令
# ============================================================================

check: ## 检查配置文件完整性
	@echo "$(COLOR_CYAN)🔍 检查配置文件...$(COLOR_RESET)"
	@echo ""
	@echo "$(COLOR_BOLD)Shell 配置:$(COLOR_RESET)"
	@[ -f ".bashrc" ] && echo "  ✓ .bashrc" || echo "  ✗ .bashrc $(COLOR_RED)(缺失)$(COLOR_RESET)"
	@[ -f ".zshrc" ] && echo "  ✓ .zshrc" || echo "  ✗ .zshrc $(COLOR_RED)(缺失)$(COLOR_RESET)"
	@[ -d "fish" ] && echo "  ✓ fish/" || echo "  ✗ fish/ $(COLOR_RED)(缺失)$(COLOR_RESET)"
	@[ -d "nushell" ] && echo "  ✓ nushell/" || echo "  ✗ nushell/ $(COLOR_RED)(缺失)$(COLOR_RESET)"
	@echo ""
	@echo "$(COLOR_BOLD)编辑器配置:$(COLOR_RESET)"
	@[ -f ".vimrc" ] && echo "  ✓ .vimrc" || echo "  ✗ .vimrc $(COLOR_RED)(缺失)$(COLOR_RESET)"
	@[ -d "nvim" ] && echo "  ✓ nvim/" || echo "  ✗ nvim/ $(COLOR_RED)(缺失)$(COLOR_RESET)"
	@echo ""
	@echo "$(COLOR_BOLD)其他配置:$(COLOR_RESET)"
	@[ -f ".tmux.conf" ] && echo "  ✓ .tmux.conf" || echo "  ✗ .tmux.conf $(COLOR_RED)(缺失)$(COLOR_RESET)"
	@[ -d "yazi" ] && echo "  ✓ yazi/" || echo "  ✗ yazi/ $(COLOR_RED)(缺失)$(COLOR_RESET)"
	@[ -f ".gitconfig" ] && echo "  ✓ .gitconfig" || echo "  ✗ .gitconfig $(COLOR_RED)(缺失)$(COLOR_RESET)"
	@[ -f "tokyo-night.toml" ] && echo "  ✓ tokyo-night.toml" || echo "  ✗ tokyo-night.toml $(COLOR_RED)(缺失)$(COLOR_RESET)"
	@echo ""
	@echo "$(COLOR_BOLD)脚本:$(COLOR_RESET)"
	@[ -f "setup.sh" ] && echo "  ✓ setup.sh" || echo "  ✗ setup.sh $(COLOR_RED)(缺失)$(COLOR_RESET)"
	@[ -d "sh" ] && echo "  ✓ sh/" || echo "  ✗ sh/ $(COLOR_RED)(缺失)$(COLOR_RESET)"
	@echo ""
	@echo "$(COLOR_GREEN)✔ 检查完成$(COLOR_RESET)"

clean: ## 清理临时文件
	@echo "$(COLOR_CYAN)🧹 清理临时文件...$(COLOR_RESET)"
	@find . -type f -name "*.swp" -delete 2>/dev/null || true
	@find . -type f -name "*.swo" -delete 2>/dev/null || true
	@find . -type f -name "*~" -delete 2>/dev/null || true
	@find . -type f -name ".DS_Store" -delete 2>/dev/null || true
	@echo "$(COLOR_GREEN)✔ 清理完成$(COLOR_RESET)"

update: ## 更新仓库到最新版本
	@echo "$(COLOR_CYAN)🔄 更新仓库...$(COLOR_RESET)"
	@git pull origin main
	@echo "$(COLOR_GREEN)✔ 更新完成$(COLOR_RESET)"

backup: ## 手动备份当前配置
	@echo "$(COLOR_CYAN)💾 备份当前配置...$(COLOR_RESET)"
	@BACKUP_DIR="$(HOME)/.config-backup-manual-$$(date +%Y%m%d-%H%M%S)"; \
	mkdir -p "$$BACKUP_DIR"; \
	[ -f "$(HOME)/.bashrc" ] && cp "$(HOME)/.bashrc" "$$BACKUP_DIR/" || true; \
	[ -f "$(HOME)/.zshrc" ] && cp "$(HOME)/.zshrc" "$$BACKUP_DIR/" || true; \
	[ -f "$(HOME)/.vimrc" ] && cp "$(HOME)/.vimrc" "$$BACKUP_DIR/" || true; \
	[ -f "$(HOME)/.tmux.conf" ] && cp "$(HOME)/.tmux.conf" "$$BACKUP_DIR/" || true; \
	echo "$(COLOR_GREEN)✔ 备份完成: $$BACKUP_DIR$(COLOR_RESET)"

restore: ## 恢复最近的备份
	@echo "$(COLOR_YELLOW)⚠️  恢复功能需要手动选择备份目录$(COLOR_RESET)"
	@echo "备份目录通常位于: $(HOME)/.config-backup-*"
	@ls -td $(HOME)/.config-backup-* 2>/dev/null | head -5 || echo "未找到备份"

# ============================================================================
# 测试命令
# ============================================================================

test: test-shell lint ## 运行所有测试

test-shell: ## 测试 Shell 配置语法
	@echo "$(COLOR_CYAN)🧪 测试 Shell 配置语法...$(COLOR_RESET)"
	@bash -n .bashrc && echo "  ✓ .bashrc 语法正确" || echo "  ✗ .bashrc 语法错误"
	@zsh -n .zshrc 2>/dev/null && echo "  ✓ .zshrc 语法正确" || echo "  ✗ .zshrc 语法错误 (如未安装 zsh 可忽略)"
	@echo "$(COLOR_GREEN)✔ 测试完成$(COLOR_RESET)"

lint: ## 检查脚本语法 (需要 shellcheck)
	@echo "$(COLOR_CYAN)🔎 运行 shellcheck...$(COLOR_RESET)"
	@if command -v shellcheck > /dev/null 2>&1; then \
		shellcheck setup.sh sh/*.sh 2>/dev/null || echo "$(COLOR_YELLOW)发现一些警告 (可忽略)$(COLOR_RESET)"; \
	else \
		echo "$(COLOR_YELLOW)⚠️  shellcheck 未安装,跳过检查$(COLOR_RESET)"; \
		echo "安装命令: sudo dnf install -y shellcheck"; \
	fi

# ============================================================================
# 信息命令
# ============================================================================

info: ## 显示项目信息和统计
	@echo ""
	@echo "$(COLOR_BOLD)$(COLOR_CYAN)📊 项目信息$(COLOR_RESET)"
	@echo "$(COLOR_BOLD)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(COLOR_RESET)"
	@echo "  项目名称: $(PROJECT_NAME)"
	@echo "  仓库地址: $(REPO_URL)"
	@echo "  作者: SMLYFM <yytcjx@gmail.com>"
	@echo ""
	@echo "$(COLOR_BOLD)$(COLOR_CYAN)统计信息:$(COLOR_RESET)"
	@echo "  配置文件数: $$(find . -maxdepth 1 -type f \( -name ".*rc" -o -name ".*.conf" -o -name "*.toml" \) | wc -l)"
	@echo "  文档数量: $$(find docs -name "*.md" 2>/dev/null | wc -l)"
	@echo "  脚本数量: $$(find sh -name "*.sh" 2>/dev/null | wc -l)"
	@echo ""
	@echo "$(COLOR_BOLD)$(COLOR_CYAN)Git 信息:$(COLOR_RESET)"
	@git log -1 --pretty=format:"  最后提交: %h - %s (%cr)%n  作者: %an%n" 2>/dev/null || echo "  无 Git 信息"
	@echo ""

version: ## 显示版本信息
	@echo "$(COLOR_BOLD)Fedora 配置仓库 v1.0.0$(COLOR_RESET)"
	@echo "Setup 脚本: $$(bash setup.sh --help 2>&1 | head -n 1 || echo 'v1.0.0')"

# ============================================================================
# 完整性检查
# ============================================================================

.PHONY: check-setup
check-setup:
	@if [ ! -x "$(SETUP_SCRIPT)" ]; then \
		echo "$(COLOR_RED)错误: setup.sh 不存在或不可执行$(COLOR_RESET)"; \
		exit 1; \
	fi
