# PDF 查看功能配置文档 (PDF Viewing Configuration)

## 📦 插件信息 (Plugin Information)

- **插件名称**: PDFview.nvim
- **作者**: basola21
- **仓库地址**: <https://github.com/basola21/PDFview.git>
- **依赖**: telescope.nvim

## ✨ 功能特性 (Features)

- ✅ 在 Neovim 内部查看 PDF 文件
- ✅ 使用 `pdftotext` 提取文本内容
- ✅ 支持键盘导航翻页
- ✅ 自动打开 PDF 文件
- ✅ 集成 Telescope 文件选择器

## 🔧 安装要求 (Requirements)

### 系统依赖

```bash
# Fedora 43 安装 pdftotext
sudo dnf install poppler-utils

# 验证安装
pdftotext -v
```

### Neovim 插件

PDFview 已经配置在 [`lua/plugins/pdfview.lua`](file:///home/yyt/Downloads/lazyvim-linux/lua/plugins/pdfview.lua) 中,LazyVim 会自动加载。

## ⌨️ 快捷键映射 (Keybindings)

| 快捷键 | 模式 | 功能 | 说明 |
|--------|------|------|------|
| `<leader>po` | Normal | 打开 PDF | 使用 Telescope 选择 PDF 文件 |
| `<leader>pn` | Normal | 下一页 | 翻到下一页 |
| `<leader>pp` | Normal | 上一页 | 翻到上一页 |
| `<leader>jj` | Normal | 下一页(快速) | 快速导航下一页 |
| `<leader>kk` | Normal | 上一页(快速) | 快速导航上一页 |

> 💡 **提示**: `<leader>` 在 LazyVim 中默认为空格键 `Space`

## 🚀 使用方法 (Usage)

### 方法 1: 使用 Telescope 打开 PDF

```vim
" 按下 Space + p + o
<leader>po
```

这会打开 Telescope 文件选择器,你可以搜索并选择要查看的 PDF 文件。

### 方法 2: 直接打开 PDF 文件

```bash
# 在终端中使用 Neovim 打开 PDF
nvim document.pdf
```

由于配置了自动命令,Neovim 会自动使用 PDFview 打开 PDF 文件。

### 方法 3: 在 Neovim 中打开 PDF

```vim
" 在 Neovim 命令行中
:e /path/to/document.pdf
```

## 📄 自动命令 (Autocmds)

PDFview 配置了自动命令,当打开 `.pdf` 文件时自动触发:

```lua
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.pdf",
  callback = function()
    local file_path = vim.api.nvim_buf_get_name(0)
    require("pdfview").open(file_path)
  end,
})
```

## ⚙️ 配置自定义 (Customization)

### 修改每页行数

PDFview 默认每页显示 50 行文本。如果需要修改,需要编辑插件源码中的 `renderer.lua`:

```lua
-- 在 ~/.local/share/nvim/lazy/PDFview/lua/pdfview/renderer.lua
local lines_per_page = 50  -- 修改为你想要的值
```

> ⚠️ **警告**: 直接修改插件源码可能在插件更新后丢失,建议等待插件支持配置选项。

### 自定义快捷键

如果你想修改快捷键,编辑 [`lua/plugins/pdfview.lua`](file:///home/yyt/Downloads/lazyvim-linux/lua/plugins/pdfview.lua):

```lua
keys = {
  -- 修改打开 PDF 的快捷键为 <leader>pf
  {
    "<leader>pf",
    function()
      require("pdfview").open()
    end,
    desc = "PDFview: Open PDF",
  },
  -- 其他快捷键...
}
```

## 🔍 功能对比 (Comparison)

### PDFview vs 外部 PDF 查看器

| 功能 | PDFview | 外部查看器 (Evince/Zathura) |
|------|---------|----------------------------|
| Neovim 内部查看 | ✅ | ❌ |
| 文本提取和搜索 | ✅ | ✅ |
| 图片和格式显示 | ❌ (仅文本) | ✅ |
| 键盘导航 | ✅ | ✅ |
| LaTeX 同步跳转 | ❌ | ✅ (VimTeX + Zathura) |

### 使用建议

- **文献阅读/记笔记**: 使用 PDFview 在 Neovim 内查看,方便复制文本
- **LaTeX 写作**: 使用外部查看器 (Zathura + VimTeX),支持正反向搜索
- **快速预览**: 使用现有的文件预览功能 (`<leader>fp`)

## 🧰 故障排除 (Troubleshooting)

### 问题 1: 打开 PDF 没有反应

**原因**: 缺少 `pdftotext` 工具

**解决方案**:

```bash
sudo dnf install poppler-utils
```

### 问题 2: PDF 显示乱码

**原因**: PDF 可能有特殊编码或是扫描版

**解决方案**: 使用外部查看器打开:

```vim
" 使用 Zathura 打开
<leader>fpz
```

### 问题 3: 快捷键冲突

**原因**: 快捷键与其他插件冲突

**解决方案**: 修改 [`lua/plugins/pdfview.lua`](file:///home/yyt/Downloads/lazyvim-linux/lua/plugins/pdfview.lua) 中的 `keys` 配置

## 📚 相关文档 (Related Documentation)

- [PDFview GitHub](https://github.com/basola21/PDFview)
- [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [LazyVim Keymaps](file:///home/yyt/Downloads/lazyvim-linux/lua/config/keymaps.lua)
- [文件预览功能文档](file:///home/yyt/Downloads/lazyvim-linux/docs/FILE_PREVIEW.md)

## 🔄 更新日志 (Changelog)

### 2026-01-20

- ✅ 初始配置 PDFview.nvim
- ✅ 添加快捷键映射 (`<leader>po`, `<leader>pn/pp`, `<leader>jj/kk`)
- ✅ 配置自动命令自动打开 PDF 文件
- ✅ 集成到 LazyVim 插件系统

---

**维护者**: SMLYFM  
**最后更新**: 2026-01-20
