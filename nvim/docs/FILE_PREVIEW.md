# 文件预览功能使用指南

## 📖 功能概述

在 Neovim 中快速预览和打开 PDF、图片、视频等常见文件格式，使用 Fedora 系统默认程序，无需离开编辑器。

---

## 🎯 支持的文件格式

| 类型 | 扩展名 | 默认程序 |
|------|--------|---------|
| **PDF** | `.pdf` | Evince / Zathura |
| **图片** | `.png`, `.jpg`, `.jpeg`, `.gif`, `.svg`, `.webp`, `.bmp` | Eye of GNOME (eog) |
| **视频** | `.mp4`, `.mkv`, `.avi`, `.mov`, `.webm`, `.flv` | MPV / Totem |
| **音频** | `.mp3`, `.wav`, `.flac`, `.ogg`, `.m4a` | MPV |
| **Office** | `.docx`, `.xlsx`, `.pptx`, `.odt`, `.ods`, `.odp` | LibreOffice |
| **其他** | 所有格式 | xdg-open（系统默认） |

---

## ⌨️ 快捷键

### 基础快捷键

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `Space + f + p` | **Preview** 预览当前文件 | 用系统默认程序打开文件 |
| `Space + f + o` | **Open** 打开文件夹 | 在文件管理器中显示当前文件 |
| `Space + f + x` | **eXecute** 执行打开 | 用系统默认程序打开（同 fp） |

### 高级快捷键（指定程序）

| 快捷键 | 程序 | 适用格式 |
|--------|------|---------|
| `Space + f + p + e` | **Evince** | PDF |
| `Space + f + p + z` | **Zathura** | PDF |
| `Space + f + p + i` | **Eye of GNOME** | 图片 |
| `Space + f + p + v` | **MPV** | 视频/音频 |

---

## 📋 使用示例

### 示例 1：预览 PDF 文件

```vim
" 1. 在 Neovim 中打开 PDF 文件
:e ~/Documents/report.pdf

" 2. 按快捷键预览
Space + f + p

" 结果：Evince 或 Zathura 打开 PDF，Neovim 继续编辑
```

### 示例 2：查看图片

```vim
" 1. 打开图片文件
:e ~/Pictures/screenshot.png

" 2. 预览图片
Space + f + p

" 结果：Eye of GNOME 显示图片
```

### 示例 3：在文件管理器中定位文件

```vim
" 在任何文件中
Space + f + o

" 结果：Nautilus 文件管理器打开当前文件所在文件夹
```

---

## 💡 快捷键记忆技巧

- **f** = **F**ile（文件）
- **p** = **P**review（预览）
- **o** = **O**pen in folder（打开文件夹）
- **x** = e**X**ecute（执行）

---

## 📌 常见问题

### Q: 为什么预览没有反应？

**A**: 检查以下几点：

1. 文件是否存在且可读
2. 是否安装了对应的预览程序
3. 查看 Neovim 通知消息（底部状态栏）

### Q: 如何更改默认 PDF 查看器？

**A**: 修改系统默认程序：

```bash
# 设置默认 PDF 查看器为 Zathura
xdg-mime default org.pwmt.zathura.desktop application/pdf
```

### Q: 可以添加其他预览程序吗？

**A**: 可以！在 `lua/plugins/file-preview.lua` 中添加自定义快捷键。

### Q: 预览大文件会卡住 Neovim 吗？

**A**: 不会！所有预览操作都是**异步**的，打开文件后 Neovim 可以立即继续编辑。

---

**提示**: 重启 Neovim 后，文件预览功能自动生效！🎉
