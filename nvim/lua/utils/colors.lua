-- =========================================================
-- 山水·数理配色模块 (Shan-shui Color Palette Module)
-- =========================================================
-- 功能说明 (Description):
--   基于 resource.css 的深青色学术风格色板
--   Provides color utilities based on resource.css deep teal academic theme
-- =========================================================

local M = {}

-- ---------------------------------------------------------
-- 核心色板定义 (Core Color Palette)
-- ---------------------------------------------------------
-- 深青色系 (Deep Teal Series) - 主题色
M.colors = {
  -- Primary colors: 深青色主题
  primary = "#2F545D",           -- Deep teal primary color
  primary_soft = "#4A6A73",      -- Soft variant for borders
  primary_mute = "#3D5C66",      -- Muted variant for backgrounds
  
  -- Accent color: 强调色 (用于链接和重要元素)
  accent = "#1976D2",            -- Accent blue for links and highlights

  
  -- Dark mode palette: 深色模式配色
  dark = {
    bg = "#1A3038",              -- 深青黑背景 (Deep teal-black background)
    bg_mute = "#223940",         -- 次要背景 (Secondary background)
    bg_soft = "#2A454D",         -- 柔和背景 (Soft background)
    fg = "#E6EDEF",              -- 月白色前景 (Moon-white foreground)
    fg_dim = "#9FB3B8",          -- 灰青色次要文本 (Dim teal-gray text)
    border = "#3D555E",          -- 边框色 (Border color)
    code_bg = "#0D1F26",         -- 代码块背景 (Code block background)
    chat_user = "#243942",       -- 用户气泡背景 (User bubble background)
    chat_ai = "#2C4A52",         -- AI气泡背景 (AI bubble background)
  },
  
  -- Light mode palette: 浅色模式配色
  light = {
    bg = "#E6EDEF",              -- 月白青背景 (Moon-white teal background)
    bg_mute = "#D5E0E3",         -- 次要背景 (Secondary background)
    bg_soft = "#DCE6E9",         -- 柔和背景 (Soft background)
    fg = "#2F545D",              -- 深墨色文本 (Deep ink text)
    fg_dim = "#5A7A84",          -- 次要文本 (Secondary text)
    border = "#B8C8CD",          -- 边框色 (Border color)
    code_bg = "#F0F5F7",         -- 代码块背景 (Code block background)
    chat_user = "#FFFFFF",       -- 用户气泡背景 (User bubble background)
    chat_ai = "#E3EBED",         -- AI气泡背景 (AI bubble background)
  },
  
  -- Semantic colors: 语义化颜色
  semantic = {
    error = "#D32F2F",           -- 错误红 (Error red)
    warning = "#F57C00",         -- 警告橙 (Warning orange)
    info = "#1976D2",            -- 信息蓝 (Info blue)
    success = "#388E3C",         -- 成功绿 (Success green)
    hint = "#7C4DFF",            -- 提示紫 (Hint purple)
  },
}

-- ---------------------------------------------------------
-- 工具函数 (Utility Functions)
-- ---------------------------------------------------------

--- 将十六进制颜色转换为 RGB 值
--- Convert hex color to RGB values
--- @param hex string: 十六进制颜色值 (如 "#2F545D")
--- @return table: {r, g, b} RGB values (0-255)
function M.hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return {
    r = tonumber(hex:sub(1, 2), 16),
    g = tonumber(hex:sub(3, 4), 16),
    b = tonumber(hex:sub(5, 6), 16),
  }
end

--- 生成带透明度的颜色
--- Generate color with alpha transparency
--- @param hex string: 十六进制颜色值
--- @param alpha number: 透明度 (0.0-1.0)
--- @return string: RGBA 格式颜色
function M.with_alpha(hex, alpha)
  local rgb = M.hex_to_rgb(hex)
  return string.format("rgba(%d, %d, %d, %.2f)", rgb.r, rgb.g, rgb.b, alpha)
end

--- 获取当前主题的配色方案
--- Get color scheme for current theme
--- @param is_dark boolean: 是否为深色模式
--- @return table: 当前主题的配色表
function M.get_theme_colors(is_dark)
  if is_dark == nil then
    is_dark = vim.o.background == "dark"
  end
  return is_dark and M.colors.dark or M.colors.light
end

--- 应用颜色到 highlight group
--- Apply colors to highlight group
--- @param group string: Highlight group 名称
--- @param opts table: 颜色选项 {fg, bg, bold, italic, etc}
function M.set_hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

return M
