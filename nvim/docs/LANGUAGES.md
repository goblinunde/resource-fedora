# 语言支持文档 (Language Support Documentation)

本文档详细说明 LazyVim 配置支持的编程语言及其功能。

---

## 📊 语言支持概览 (Language Support Overview)

### 🟢 完善支持 (Fully Supported)

包含 LSP + 格式化 + 调试 + 完整工具链

| 语言 | LSP | 格式化 | 调试 | 特色功能 |
|------|-----|--------|------|----------|
| **Python** | basedpyright + ruff | ruff | debugpy | Type hints, 虚拟环境, PyTorch 支持 |
| **Rust** | rust-analyzer | rustfmt | codelldb | Clippy, Crates管理, 内存安全检查 |
| **LaTeX** | texlab | latexmk | - | PDF预览, 自动编译, 学术模板 |
| **Markdown** | - | prettier | - | 实时渲染, TOC, 预览 |

### 🟡 基础支持 (Basic Supported)

包含 LSP + 基础功能

| 语言 | LSP | 格式化 | 调试 | 特色功能 |
|------|-----|--------|------|----------|
| **C/C++** | clangd (via quick-c) | clang-format | codelldb | Make/CMake, 一键构建运行 |
| **Lua** | lua-language-server | stylua | - | Neovim 配置支持 |

### 🔵 可选支持 (Optional - 默认禁用)

需要手动启用，完整 LSP + 格式化 + 调试

| 语言 | LSP | 格式化 | 调试 | 启用方法 |
|------|-----|--------|------|----------|
| **Go** | gopls | goimports + gofumpt | delve | `:LangEnable go` |
| **Java** | jdtls | google-java-format | java-debug-adapter | `:LangEnable java` |
| **TypeScript** | tsserver | prettier + eslint | vscode-js-debug | `:LangEnable typescript` |
| **JavaScript** | tsserver | prettier + eslint | vscode-js-debug | `:LangEnable javascript` |
| **Bash** | bash-language-server | shfmt + shellcheck | - | `:LangEnable bash` |

---

## 🎮 语言配置管理 (Language Configuration Management)

### 配置文件位置

- **配置中心**: `lua/config/languages.lua`
- **语言插件**: `lua/plugins/languages.lua`

### 用户命令 (User Commands)

#### 查看语言状态

```vim
:LangStatus
```

显示所有语言的启用/禁用状态。

#### 启用语言

```vim
:LangEnable python    " 启用 Python
:LangEnable go        " 启用 Go
```

#### 禁用语言

```vim
:LangDisable rust     " 禁用 Rust
:LangDisable java     " 禁用 Java
```

#### 切换语言状态

```vim
:LangToggle python    " 切换 Python（禁用↔启用）
```

### 配置文件编辑

编辑 `lua/config/languages.lua`:

```lua
M.languages = {
  -- 完善支持的语言
  python = true,
  rust = true,
  latex = true,
  markdown = true,
  
  -- 基础支持的语言
  c = true,
  cpp = true,
  lua = true,
  
  -- 可选语言（按需启用）
  go = false,          -- 改为 true 启用
  java = false,
  typescript = false,
  javascript = false,
  bash = false,
}
```

**重要**: 修改配置后需要重启 Neovim！

---

## 🔧 语言详细配置 (Detailed Configuration)

### Python 开发

**LSP 服务器**: `basedpyright` (类型检查) + `ruff` (linter/formatter)

**功能**:

- ✅ 类型检查和类型提示
- ✅ 虚拟环境支持 (`<leader>cv`)
- ✅ 调试支持 (debugpy)
- ✅ AMD ROCm 支持 (深度学习)
- ✅ uv 包管理器兼容

**系统依赖**:

```bash
# 安装 Python 和 uv
sudo dnf install python3 python3-pip
pip install uv
```

**常用快捷键**:

- `<leader>cv` - 选择虚拟环境
- `<leader>dPt` - 调试测试方法
- `<leader>dPc` - 调试测试类

---

### Rust 开发

**LSP 服务器**: `rust-analyzer`

**功能**:

- ✅ 完整的类型推断和检查
- ✅ Clippy lint 检查
- ✅ Cargo.toml 智能补全
- ✅ 调试支持 (codelldb)
- ✅ 内联类型提示和生命周期提示

**系统依赖**:

```bash
# 安装 Rust 工具链
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rust-analyzer clippy rustfmt
```

**常用快捷键**:

- `<leader>cR` - Rust 代码操作
- `<leader>rr` - Rust 可运行项
- `<leader>rd` - Rust 可调试项

---

### C/C++ 开发

**构建工具**: `quick-c`

**功能**:

- ✅ 一键编译、运行、调试
- ✅ Make 和 CMake 集成
- ✅ Telescope 目标选择器
- ✅ 异步构建不阻塞

**系统依赖**:

```bash
# Fedora 43
sudo dnf install gcc g++ clang make cmake gdb lldb
```

**常用快捷键**:

- `<leader>cqb` - 构建当前文件
- `<leader>cqr` - 运行最近构建
- `<leader>cqR` - 构建并运行
- `<leader>cqD` - 调试程序
- `<leader>cqM` - Make 目标选择
- `<leader>cqC` - CMake 目标选择

---

### Go 语言 (可选)

**LSP 服务器**: `gopls`

**功能**:

- ✅ 完整的 gopls LSP 支持
- ✅ goimports + gofumpt 格式化
- ✅ delve 调试器集成
- ✅ 静态分析 (staticcheck)

**启用方法**:

1. 编辑 `lua/config/languages.lua` 设置 `go = true`
2. 重启 Neovim
3. Mason 会自动安装 `gopls`, `goimports`, `delve`

**系统依赖**:

```bash
# 安装 Go
sudo dnf install golang
```

---

### TypeScript/JavaScript (可选)

**LSP 服务器**: `typescript-language-server`

**功能**:

- ✅ TypeScript 类型检查
- ✅ JavaScript 智能补全
- ✅ Prettier + ESLint 格式化
- ✅ 调试支持 (vscode-js-debug)
- ✅ React/JSX/TSX 支持

**启用方法**:

1. 编辑 `lua/config/languages.lua`
2. 设置 `typescript = true` 和/或 `javascript = true`
3. 重启 Neovim

**系统依赖**:

```bash
# 安装 Node.js
sudo dnf install nodejs npm
```

---

### Java (可选)

**LSP 服务器**: `jdtls` (Eclipse JDT Language Server)

**功能**:

- ✅ 完整的 Java LSP 支持
- ✅ Maven/Gradle 项目支持
- ✅ 调试和测试集成
- ✅ google-java-format 格式化

**启用方法**:

1. 编辑 `lua/config/languages.lua` 设置 `java = true`
2. 重启 Neovim
3. 确保系统已安装 JDK

**系统依赖**:

```bash
# 安装 JDK
sudo dnf install java-17-openjdk java-17-openjdk-devel
```

---

### Bash/Shell (可选)

**LSP 服务器**: `bash-language-server`

**功能**:

- ✅ Bash 脚本 LSP 支持
- ✅ shfmt 格式化
- ✅ shellcheck linting
- ✅ 支持 sh/bash/zsh

**启用方法**:

1. 编辑 `lua/config/languages.lua` 设置 `bash = true`
2. 重启 Neovim

---

## 🚀 进阶使用 (Advanced Usage)

### 批量启用语言

编辑 `lua/config/languages.lua`:

```lua
-- 启用所有可选语言
M.languages = {
  python = true,
  rust = true,
  latex = true,
  markdown = true,
  c = true,
  cpp = true,
  lua = true,
  
  -- 全部启用
  go = true,
  java = true,
  typescript = true,
  javascript = true,
  bash = true,
}
```

### 性能优化

如果你不使用某个语言，建议禁用以减少插件加载：

```lua
M.languages = {
  python = true,
  -- 其他语言设为 false
  rust = false,
  go = false,
  java = false,
}
```

### 添加新语言

1. 编辑 `lua/config/languages.lua` 添加新语言条目
2. 编辑 `lua/plugins/languages.lua` 添加对应插件配置
3. 确保包含 LSP + 格式化 + Tree-sitter

---

## 📚 参考资源 (References)

- [Mason Plugin Registry](https://github.com/mason-org/mason-registry)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [conform.nvim](https://github.com/stevearc/conform.nvim)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

---

**最后更新**: 2026-01-20
