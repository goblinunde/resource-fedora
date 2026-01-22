-- =========================================================
-- 语言配置中心 (Language Configuration Center)
-- =========================================================
-- 功能说明 (Description):
--   统一管理所有编程语言的启用/禁用状态
--   Centralized management for enabling/disabling programming languages
-- =========================================================

local M = {}

-- 💡 语言启用配置 (Language Enable Configuration)
-- 设置为 false 可以完全禁用某个语言的所有功能
-- Set to false to completely disable all features for a language
M.languages = {
  -- ========================================
  -- 💡 完善支持的语言 (Fully Supported Languages)
  -- 包含 LSP + 格式化 + 调试 + 完整工具链
  -- ========================================
  python = true, -- Python: basedpyright + ruff + debugpy
  rust = true, -- Rust: rust-analyzer + rustfmt + codelldb
  latex = true, -- LaTeX: texlab + latexmk
  markdown = true, -- Markdown: 渲染 + 预览 + TOC

  -- ========================================
  -- 💡 基础支持的语言 (Basic Supported Languages)  
  -- 包含 LSP + 基础功能
  -- ========================================
  c = true, -- C: quick-c + clangd
  cpp = true, -- C++: quick-c + clangd
  lua = true, -- Lua: lua-language-server

  -- ========================================
  -- 💡 可选支持的语言 (Optional Languages)
  -- 默认禁用，可按需启用
  -- ========================================
  
  -- 系统编程语言 (Systems Programming)
  go = false, -- Go: gopls + goimports + delve
  zig = false, -- Zig: zls + zig fmt
  
  -- JVM 和动态语言 (JVM & Dynamic Languages)
  java = false, -- Java: jdtls + google-java-format
  ruby = false, -- Ruby: solargraph + rubocop
  
  -- 科学计算 (Scientific Computing)
  julia = false, -- Julia: julia-lsp + JuliaFormatter
  
  -- Web 开发 (Web Development)
  typescript = false, -- TypeScript: tsserver + prettier
  javascript = false, -- JavaScript: tsserver + prettier
  
  -- Shell 脚本 (Shell Scripting)
  bash = false, -- Bash: bash-language-server + shfmt
  fish = false, -- Fish: fish-lsp
  zsh = false, -- Zsh: 使用 bash-language-server
  nushell = false, -- Nushell: nushell LSP
}

-- 💡 检查语言是否启用 (Check if language is enabled)
---@param lang string 语言名称
---@return boolean 是否启用
function M.is_enabled(lang)
  if M.languages[lang] == nil then
    -- 默认启用未配置的语言
    return true
  end
  return M.languages[lang] == true
end

-- 💡 启用语言 (Enable language)
---@param lang string 语言名称
function M.enable(lang)
  M.languages[lang] = true
  vim.notify("✅ 已启用 " .. lang .. " 支持", vim.log.levels.INFO)
end

-- 💡 禁用语言 (Disable language)
---@param lang string 语言名称
function M.disable(lang)
  M.languages[lang] = false
  vim.notify("❌ 已禁用 " .. lang .. " 支持", vim.log.levels.WARN)
end

-- 💡 切换语言状态 (Toggle language state)
---@param lang string 语言名称
function M.toggle(lang)
  if M.is_enabled(lang) then
    M.disable(lang)
  else
    M.enable(lang)
  end
end

-- 💡 获取已启用的语言列表 (Get list of enabled languages)
---@return table 已启用的语言列表
function M.get_enabled()
  local enabled = {}
  for lang, is_enabled in pairs(M.languages) do
    if is_enabled then
      table.insert(enabled, lang)
    end
  end
  table.sort(enabled)
  return enabled
end

-- 💡 显示语言状态 (Show language status)
function M.show_status()
  local enabled = M.get_enabled()
  local disabled = {}

  for lang, is_enabled in pairs(M.languages) do
    if not is_enabled then
      table.insert(disabled, lang)
    end
  end
  table.sort(disabled)

  print("📊 语言支持状态 (Language Support Status)")
  print("----------------------------------------")
  print("✅ 已启用 (" .. #enabled .. "):")
  print("  " .. table.concat(enabled, ", "))
  print("")
  print("❌ 已禁用 (" .. #disabled .. "):")
  if #disabled > 0 then
    print("  " .. table.concat(disabled, ", "))
  else
    print("  (无)")
  end
end

-- 💡 创建用户命令 (Create user commands)
vim.api.nvim_create_user_command("LangEnable", function(opts)
  M.enable(opts.args)
end, {
  nargs = 1,
  complete = function()
    local langs = {}
    for lang, _ in pairs(M.languages) do
      table.insert(langs, lang)
    end
    table.sort(langs)
    return langs
  end,
  desc = "启用指定语言支持",
})

vim.api.nvim_create_user_command("LangDisable", function(opts)
  M.disable(opts.args)
end, {
  nargs = 1,
  complete = function()
    local langs = {}
    for lang, _ in pairs(M.languages) do
      table.insert(langs, lang)
    end
    table.sort(langs)
    return langs
  end,
  desc = "禁用指定语言支持",
})

vim.api.nvim_create_user_command("LangToggle", function(opts)
  M.toggle(opts.args)
end, {
  nargs = 1,
  complete = function()
    local langs = {}
    for lang, _ in pairs(M.languages) do
      table.insert(langs, lang)
    end
    table.sort(langs)
    return langs
  end,
  desc = "切换指定语言支持",
})

vim.api.nvim_create_user_command("LangStatus", function()
  M.show_status()
end, {
  desc = "显示所有语言支持状态",
})

return M
