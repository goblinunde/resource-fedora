-- ============================================
-- Yazi 插件系统初始化文件
-- 位置: ~/.config/yazi/init.lua
-- 文档: https://yazi-rs.github.io/docs/plugins/overview
-- ============================================

-- 💡 设置日志级别以便调试
-- 使用 YAZI_LOG=debug yazi 启动以查看日志
-- 日志位置: ~/.local/state/yazi/yazi.log

-- ===== 插件配置 =====

-- 💡 如果你安装了自定义插件,可以在这里初始化它们
-- 示例:
-- require("your-plugin"):setup({
--     option1 = "value1",
--     option2 = "value2",
-- })

-- ===== 实用函数 =====

-- 💡 快速跳转到常用目录的辅助函数
function cd_to_home()
    ya.manager_emit("cd", { "/home/yyt" })
end

function cd_to_downloads()
    ya.manager_emit("cd", { "/home/yyt/Downloads" })
end

function cd_to_documents()
    ya.manager_emit("cd", { "/home/yyt/Documents" })
end

function cd_to_projects()
    ya.manager_emit("cd", { "/home/yyt/Documents/Github" })
end

-- 💡 显示文件信息的辅助函数
function show_file_info()
    local h = cx.active.current.hovered
    if h then
        ya.dbg("File: " .. tostring(h.url))
        ya.dbg("Size: " .. h.length .. " bytes")
        ya.dbg("Modified: " .. os.date("%Y-%m-%d %H:%M:%S", h.modified))
    end
end

-- ===== 自定义快捷键提示 =====

-- 💡 你可以在 keymap.toml 中绑定这些函数
-- 示例:
-- [[manager.prepend_keymap]]
-- on = [ "g", "h" ]
-- run = 'plugin --sync init --args="cd_to_home"'
-- desc = "跳转到家目录"

-- ===== 启动消息 =====
ya.dbg("Yazi 插件系统已初始化 ✓")
ya.dbg("配置位置: ~/.config/yazi/")
ya.dbg("主题: Tokyo Night")
