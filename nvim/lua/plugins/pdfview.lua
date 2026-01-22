-- =========================================================
-- PDFview 配置 (PDFview Configuration)
-- =========================================================
-- 功能说明 (Description):
--   在 Neovim 中查看和导航 PDF 文件
--   View and navigate PDF files within Neovim
-- 插件地址: https://github.com/basola21/PDFview.git
-- =========================================================

return {
  "basola21/PDFview",
  lazy = false, -- 💡 设置为 false 以确保插件在启动时加载
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    -- 💡 打开 PDF 文件选择器 (Open PDF file picker)
    {
      "<leader>po",
      function()
        require("pdfview").open()
      end,
      desc = "PDFview: Open PDF",
    },
    -- 💡 下一页 (Next page)
    {
      "<leader>pn",
      function()
        require("pdfview.renderer").next_page()
      end,
      desc = "PDFview: Next page",
    },
    -- 💡 上一页 (Previous page)
    {
      "<leader>pp",
      function()
        require("pdfview.renderer").previous_page()
      end,
      desc = "PDFview: Previous page",
    },
    -- 💡 使用 jj/kk 进行快速导航 (Fast navigation with jj/kk)
    {
      "<leader>jj",
      function()
        require("pdfview.renderer").next_page()
      end,
      desc = "PDFview: Next page (快速)",
    },
    {
      "<leader>kk",
      function()
        require("pdfview.renderer").previous_page()
      end,
      desc = "PDFview: Previous page (快速)",
    },
  },
  config = function()
    -- 💡 PDFview 配置 (PDFview configuration)
    -- 插件目前没有公开的 setup() 函数，使用默认配置
    -- The plugin doesn't have a public setup() function, using defaults

    -- 💡 创建自动命令：打开 PDF 文件时自动使用 PDFview
    -- Create autocmd to automatically open PDFs with PDFview
    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = "*.pdf",
      callback = function()
        local file_path = vim.api.nvim_buf_get_name(0)
        require("pdfview").open(file_path)
      end,
      desc = "Auto open PDF files with PDFview",
    })

    -- 💡 提示信息 (Notification)
    vim.notify("✅ PDFview 已加载 | PDF 查看功能已启用", vim.log.levels.INFO)
  end,
}
