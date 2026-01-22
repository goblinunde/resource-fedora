# Fish Shell 文件模板系统
# 作者: SMLYFM <yytcjx@gmail.com>
# 用途: 快速创建各种文件模板

# ============================================================================
# 模板创建函数
# ============================================================================

# 创建 Python 脚本模板
function template_python
    set -l filename $argv[1]
    
    if test -z "$filename"
        echo "Usage: template_python <filename.py>"
        return 1
    end
    
    # 确保文件扩展名
    if not string match -q "*.py" -- $filename
        set filename "$filename.py"
    end
    
    cat > $filename << 'EOF'
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Description: Module description here
Author: SMLYFM <yytcjx@gmail.com>
Created: DATE_PLACEHOLDER
"""

import sys
from pathlib import Path


def main():
    """Main function."""
    pass


if __name__ == "__main__":
    main()
EOF
    
    # 替换日期占位符
    sed -i "s/DATE_PLACEHOLDER/(date +%Y-%m-%d)/" $filename
    chmod +x $filename
    echo "✓ Created Python template: $filename"
end

# 创建 Rust 项目模板文件
function template_rust
    set -l filename $argv[1]
    
    if test -z "$filename"
        echo "Usage: template_rust <filename.rs>"
        return 1
    end
    
    if not string match -q "*.rs" -- $filename
        set filename "$filename.rs"
    end
    
    cat > $filename << 'EOF'
//! Module documentation here
//!
//! Author: SMLYFM <yytcjx@gmail.com>
//! Created: DATE_PLACEHOLDER

use std::error::Error;
use std::io;

/// Main function
fn main() -> Result<(), Box<dyn Error>> {
    println!("Hello from Rust!");
    
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_example() {
        assert_eq!(2 + 2, 4);
    }
}
EOF
    
    sed -i "s/DATE_PLACEHOLDER/(date +%Y-%m-%d)/" $filename
    echo "✓ Created Rust template: $filename"
end

# 创建 Shell 脚本模板
function template_shell
    set -l filename $argv[1]
    
    if test -z "$filename"
        echo "Usage: template_shell <filename.sh>"
        return 1
    end
    
    if not string match -q "*.sh" -- $filename
        set filename "$filename.sh"
    end
    
    cat > $filename << 'EOF'
#!/usr/bin/env bash
# ============================================================================
# Script: SCRIPT_NAME
# Description: Script description here
# Author: SMLYFM <yytcjx@gmail.com>
# Created: DATE_PLACEHOLDER
# ============================================================================

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Script configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

# ============================================================================
# Functions
# ============================================================================

log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

usage() {
    cat << USAGE
Usage: $SCRIPT_NAME [OPTIONS]

Description of script functionality.

OPTIONS:
    -h, --help      Show this help message
    -v, --verbose   Enable verbose output

EXAMPLES:
    $SCRIPT_NAME
    $SCRIPT_NAME --verbose

USAGE
}

main() {
    log_info "Starting $SCRIPT_NAME..."
    
    # Your code here
    
    log_info "Completed successfully!"
}

# ============================================================================
# Main execution
# ============================================================================

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -v|--verbose)
            set -x
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

main "$@"
EOF
    
    sed -i "s/SCRIPT_NAME/$filename/g" $filename
    sed -i "s/DATE_PLACEHOLDER/(date +%Y-%m-%d)/" $filename
    chmod +x $filename
    echo "✓ Created Shell script template: $filename"
end

# 创建 Makefile 模板
function template_makefile
    set -l filename "Makefile"
    
    if test -n "$argv[1]"
        set filename $argv[1]
    end
    
    cat > $filename << 'EOF'
.PHONY: help build test clean install

# ============================================================================
# Project Makefile
# Author: SMLYFM <yytcjx@gmail.com>
# Created: DATE_PLACEHOLDER
# ============================================================================

# Project variables
PROJECT_NAME := my-project
VERSION := 0.1.0

# Default target
help:  ## Show this help message
	@echo ""
	@echo "==========================================================================="
	@echo "                         $(PROJECT_NAME) - Makefile                        "
	@echo "==========================================================================="
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "Available targets:"
	@echo "---------------------------------------------------------------------------"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
	@echo "---------------------------------------------------------------------------"
	@echo ""

build:  ## Build the project
	@echo "Building $(PROJECT_NAME)..."
	# Add build commands here

test:  ## Run tests
	@echo "Running tests..."
	# Add test commands here

clean:  ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	# Add clean commands here

install:  ## Install the project
	@echo "Installing $(PROJECT_NAME)..."
	# Add install commands here

version:  ## Show version
	@echo "$(PROJECT_NAME) version $(VERSION)"
EOF
    
    sed -i "s/DATE_PLACEHOLDER/(date +%Y-%m-%d)/" $filename
    echo "✓ Created Makefile template: $filename"
end

# 创建 Markdown 文档模板
function template_markdown
    set -l filename $argv[1]
    
    if test -z "$filename"
        echo "Usage: template_markdown <filename.md>"
        return 1
    end
    
    if not string match -q "*.md" -- $filename
        set filename "$filename.md"
    end
    
    cat > $filename << 'EOF'
# Project Title

> Brief project description

**Author**: SMLYFM <yytcjx@gmail.com>  
**Created**: DATE_PLACEHOLDER

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

Project overview and purpose.

## ✨ Features

- Feature 1
- Feature 2
- Feature 3

## 📦 Installation

```bash
# Installation instructions
```

## 🚀 Usage

```bash
# Usage examples
```

## ⚙️ Configuration

Configuration details and options.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License.
EOF
    
    sed -i "s/DATE_PLACEHOLDER/(date +%Y-%m-%d)/" $filename
    echo "✓ Created Markdown template: $filename"
end

# 创建 LaTeX 文档模板
function template_latex
    set -l filename $argv[1]
    
    if test -z "$filename"
        echo "Usage: template_latex <filename.tex>"
        return 1
    end
    
    if not string match -q "*.tex" -- $filename
        set filename "$filename.tex"
    end
    
    cat > $filename << 'EOF'
\documentclass[12pt,a4paper]{article}

% ============================================================================
% LaTeX Document Template
% Author: SMLYFM <yytcjx@gmail.com>
% Created: DATE_PLACEHOLDER
% ============================================================================

% Packages
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[english]{babel}
\usepackage{amsmath,amssymb,amsthm}
\usepackage{graphicx}
\usepackage{hyperref}
\usepackage{geometry}
\geometry{margin=2.5cm}

% Title information
\title{Document Title}
\author{SMLYFM}
\date{\today}

\begin{document}

\maketitle

\begin{abstract}
Abstract content here.
\end{abstract}

\section{Introduction}

Introduction content.

\section{Main Content}

Main content here.

\section{Conclusion}

Conclusion.

\bibliographystyle{plain}
\bibliography{references}

\end{document}
EOF
    
    sed -i "s/DATE_PLACEHOLDER/(date +%Y-%m-%d)/" $filename
    echo "✓ Created LaTeX template: $filename"
end

# 创建 C/C++ 头文件模板
function template_cpp_header
    set -l filename $argv[1]
    
    if test -z "$filename"
        echo "Usage: template_cpp_header <filename.h>"
        return 1
    end
    
    if not string match -q -r ".*\\.(h|hpp)" -- $filename
        set filename "$filename.h"
    end
    
    # 生成头文件保护宏
    set -l guard (string upper (string replace -a '.' '_' (string replace -a '/' '_' $filename)))
    
    cat > $filename << EOF
/**
 * @file $filename
 * @brief Brief description
 * @author SMLYFM <yytcjx@gmail.com>
 * @date (date +%Y-%m-%d)
 */

#ifndef ${guard}_
#define ${guard}_

#ifdef __cplusplus
extern "C" {
#endif

// Your declarations here

#ifdef __cplusplus
}
#endif

#endif  // ${guard}_
EOF
    
    echo "✓ Created C/C++ header template: $filename"
end

# 创建 JSON 配置模板
function template_json
    set -l filename $argv[1]
    
    if test -z "$filename"
        echo "Usage: template_json <filename.json>"
        return 1
    end
    
    if not string match -q "*.json" -- $filename
        set filename "$filename.json"
    end
    
    cat > $filename << 'EOF'
{
  "name": "project-name",
  "version": "0.1.0", "description": "Project description",
  "author": "SMLYFM <yytcjx@gmail.com>",
  "created": "DATE_PLACEHOLDER",
  "config": {
    "option1": true,
    "option2": "value"
  }
}
EOF
    
    sed -i "s/DATE_PLACEHOLDER/(date +%Y-%m-%d)/" $filename
    echo "✓ Created JSON template: $filename"
end

# ============================================================================
# 通用模板创建函数
# ============================================================================

# 列出所有可用模板
function template_list
    echo "📝 Available Fish Shell Templates:"
    echo ""
    echo "  template_python <file.py>      - Python script template"
    echo "  template_rust <file.rs>        - Rust source file template"
    echo "  template_shell <file.sh>       - Bash shell script template"
    echo "  template_makefile [filename]   - Makefile template"
    echo "  template_markdown <file.md>    - Markdown document template"
    echo "  template_latex <file.tex>      - LaTeX document template"
    echo "  template_cpp_header <file.h>   - C/C++ header file template"
    echo "  template_json <file.json>      - JSON configuration template"
    echo ""
    echo "Usage: template_<type> <filename>"
end

# 别名: 使用 'tpl' 作为快捷方式
alias tpl='template_list'
