-- =========================================================
-- Lazy.nvim 配置 (Lazy.nvim Bootstrap Configuration)
-- =========================================================
-- 功能说明 (Description):
--   Lazy.nvim 插件管理器引导配置
--   Lazy.nvim plugin manager bootstrap configuration
-- =========================================================

-- 💡 自动安装 lazy.nvim (Auto-install lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- =========================================================
-- Lazy.nvim 主配置 (Main Configuration)
-- =========================================================
require("lazy").setup({
  -- ---------------------------------------------------------
  -- 插件规格 (Plugin Specifications)
  -- ---------------------------------------------------------
  spec = {
    -- 💡 导入 LazyVim 核心插件 (Import LazyVim core plugins)
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    
    -- 💡 导入自定义插件配置 (Import custom plugin configurations)
    { import = "plugins" },
  },
  
  -- ---------------------------------------------------------
  -- 默认设置 (Default Settings)
  -- ---------------------------------------------------------
  defaults = {
    -- 💡 懒加载策略 (Lazy-loading strategy)
    -- LazyVim 核心插件会自动懒加载，自定义插件默认不懒加载
    -- LazyVim core plugins auto lazy-load, custom plugins don't by default
    lazy = false,
    
    -- 💡 版本管理 (Version management)
    -- 使用最新 git commit，避免过时的版本
    -- Use latest git commit to avoid outdated releases
    version = false,
    -- version = "*", -- 如需稳定版本，取消注释 (Uncomment for stable versions)
  },
  
  -- ---------------------------------------------------------
  -- 安装配置 (Installation Configuration)
  -- ---------------------------------------------------------
  install = {
    -- 💡 默认主题配置 (Default colorscheme)
    -- 首次安装时使用的备用主题，我们的主题是 catppuccin
    -- Fallback colorscheme during first install, our theme is catppuccin
    colorscheme = { "catppuccin", "tokyonight", "habamax" },
    
    -- 💡 缺失插件时不自动安装 (Don't auto-install missing plugins on startup)
    missing = true,
  },
  
  -- ---------------------------------------------------------
  -- UI 配置 (UI Configuration)
  -- ---------------------------------------------------------
  ui = {
    -- 💡 窗口大小 (Window size)
    size = { width = 0.8, height = 0.8 },
    
    -- 💡 边框样式 (Border style)
    border = "rounded", -- 圆角边框，符合 resource.css 设计 (Rounded borders per resource.css)
    
    -- 💡 自定义图标 (Custom icons)
    icons = {
      cmd = " ",
      config = "",
      event = "",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = "",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
  
  -- ---------------------------------------------------------
  -- 更新检查 (Update Checker)
  -- ---------------------------------------------------------
  checker = {
    enabled = true,  -- 💡 启用自动检查更新 (Enable auto-check for updates)
    notify = false,  -- 💡 不弹出通知，避免干扰 (Don't notify to avoid distraction)
    frequency = 3600, -- 💡 每小时检查一次 (Check every hour)
  },
  
  -- ---------------------------------------------------------
  -- 变更检测 (Change Detection)
  -- ---------------------------------------------------------
  change_detection = {
    enabled = true,   -- 💡 启用配置文件变更自动重载 (Enable auto-reload on config changes)
    notify = false,   -- 💡 不弹出通知 (Don't notify)
  },
  
  -- ---------------------------------------------------------
  -- 性能优化 (Performance Optimization)
  -- ---------------------------------------------------------
  performance = {
    cache = {
      enabled = true, -- 💡 启用缓存加速启动 (Enable cache for faster startup)
    },
    
    rtp = {
      -- 💡 禁用不需要的 Neovim 内置插件 (Disable unnecessary builtin plugins)
      disabled_plugins = {
        "gzip",         -- gzip 压缩文件支持 (gzip file support)
        "tarPlugin",    -- tar 归档文件支持 (tar archive support)
        "tohtml",       -- 转换为 HTML (convert to HTML)
        "tutor",        -- Neovim 教程 (Neovim tutor)
        "zipPlugin",    -- zip 压缩文件支持 (zip file support)
        -- "matchit",   -- 💡 如需高级 % 匹配，保持启用 (Keep for advanced % matching)
        -- "matchparen",-- 💡 如需括号高亮，保持启用 (Keep for bracket highlighting)
        -- "netrwPlugin",-- 💡 如需文件浏览器，保持启用 (Keep for file browser)
      },
    },
    
    -- 💡 重置包路径优化 (Reset packpath for optimization)
    reset_packpath = true,
  },
  
  -- ---------------------------------------------------------
  -- 开发者选项 (Developer Options)
  -- ---------------------------------------------------------
  dev = {
    -- 💡 本地插件开发路径 (Local plugin development path)
    path = "~/projects",
    
    -- 💡 本地插件模式匹配 (Patterns for local plugins)
    patterns = {}, -- 如: { "goblinunde" } 会从本地加载匹配的插件
    
    -- 💡 回退到 git (Fallback to git when local not found)
    fallback = true,
  },
  
  -- ---------------------------------------------------------
  -- Git 配置 (Git Configuration)
  -- ---------------------------------------------------------
  git = {
    -- 💡 Git 超时时间 (Git timeout)
    timeout = 120, -- 120 秒，适合网络较慢的环境 (120s for slow networks)
    
    -- 💡 Git URL 格式 (Git URL format)
    url_format = "https://github.com/%s.git",
  },
})
