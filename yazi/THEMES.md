# Yazi 主题指南

完整的 Yazi 主题切换和自定义指南。

## 📚 可用主题

### 1. Tokyo Night (默认)

- **风格**: 深色主题,平衡的对比度  
- **配色**: 蓝色主调,紫色点缀
- **适用**: 日常使用,眼睛舒适
- **文件**: `theme.toml`

### 2. Tokyo Night Storm  

- **风格**: 更深的背景色,更高对比度
- **配色**: 更鲜艳的青色和蓝色
- **适用**: 低光环境,喜欢高对比度
- **文件**: `themes/tokyo-night-storm.toml`

### 3. Catppuccin Mocha

- **风格**: 柔和温暖的深色主题
- **配色**: 柔和的粉色、紫色和青色  
- **适用**: 长时间工作,减少眼疲劳
- **文件**: `themes/catppuccin-mocha.toml`

### 4. Gruvbox Dark

- **风格**: 复古怀旧配色
- **配色**: 暖黄色、橙色和绿色
- **适用**: 喜欢复古风格
- **文件**: `themes/gruvbox-dark.toml`

### 5. Nord

- **风格**: 极地冷色调主题
- **配色**: 清爽的青色和蓝色
- **适用**: 清新冷静的视觉效果
- **文件**: `themes/nord.toml`

---

## 🔄 主题切换方法

### 方法 1: 快捷键 (推荐)

在 Yazi 中使用以下快捷键:

| 快捷键 | 功能 |
|--------|------|
| `<Space>t` | 显示主题列表提示 |
| `<Space>tn` | 切换到下一个主题 |
| `<Space>tp` | 切换到上一个主题 |

**使用示例**:

1. 在 Yazi 中按 `<Space>` 然后按 `t` 查看主题列表
2. 按 `<Space>` 然后按 `tn` 快速切换到下一个主题
3. 按 `<Space>` 然后按 `tp` 返回上一个主题

---

### 方法 2: Makefile 命令

```bash
# 进入 yazi 配置目录
cd /home/yyt/Documents/Github/resource-fedora/yazi

# 查看所有可用主题
make -f Makefile.themes theme-list

# 应用特定主题
make -f Makefile.themes theme-tokyo         # Tokyo Night
make -f Makefile.themes theme-storm         # Tokyo Night Storm  
make -f Makefile.themes theme-catppuccin    # Catppuccin Mocha
make -f Makefile.themes theme-gruvbox       # Gruvbox Dark
make -f Makefile.themes theme-nord          # Nord

# 查看当前主题
make -f Makefile.themes theme-current

# 备份当前主题
make -f Makefile.themes theme-backup
```

---

### 方法 3: 手动切换

```bash
# 复制主题文件到配置目录
cp ~/Documents/Github/resource-fedora/yazi/themes/catppuccin-mocha.toml \
   ~/.config/yazi/theme.toml

# 重启 Yazi 查看效果
yazi
```

---

## 🎨 主题预览

### Tokyo Night

```
背景: 深蓝黑 #1a1b26
高亮: 蓝色 #7aa2f7
成功: 绿色 #9ece6a
警告: 黄色 #e0af68
错误: 红色 #f7768e
```

### Catppuccin Mocha

```
背景: 深紫 #1e1e2e
高亮: 蓝色 #89b4fa
成功: 绿色 #a6e3a1
警告: 黄色 #f9e2af
错误: 红色 #f38ba8
```

### Gruvbox Dark

```
背景: 深棕 #282828
高亮: 黄色 #fabd2f
成功: 绿色 #b8bb26
警告: 橙色 #fe8019
错误: 红色 #fb4934
```

### Nord

```
背景: 深灰蓝 #2e3440
高亮: 青色 #88c0d0
成功: 绿色 #a3be8c
警告: 黄色 #ebcb8b
错误: 红色 #bf616a
```

---

## 🛠️ 自定义主题

### 创建自定义主题

1. **复制现有主题作为模板**:

```bash
cp ~/.config/yazi/themes/tokyo-night-storm.toml \
   ~/.config/yazi/themes/my-theme.toml
```

1. **编辑主题文件**:

```toml
# 修改 flavor 名称
[flavor]
use = "my-theme"

# 自定义颜色
[manager]
cwd = { fg = "#YOUR_COLOR", bold = true }
```

1. **应用自定义主题**:

```bash
cp ~/.config/yazi/themes/my-theme.toml ~/.config/yazi/theme.toml
```

### 主题配置结构

```toml
[manager]       # 文件管理器主界面
[status]        # 状态栏
[input]         # 输入框
[pick]          # 选择器
[confirm]       # 确认对话框
[tasks]         # 任务管理器
[help]          # 帮助界面
[filetype]      # 文件类型颜色
[icon]          # 文件图标
```

---

## 💡 主题切换提示

1. **首次切换**: 主题切换后需要重启 Yazi 或按 `R` 刷新
2. **快捷键切换**: 使用 `<Space>tn/tp` 可以快速循环切换主题
3. **持久化**: 通过 Makefile 或手动复制的主题会永久保存
4. **备份**: 切换前可使用 `make theme-backup` 备份当前主题

---

## 🔍 故障排除

### 主题未生效

1. 确认主题文件已复制到 `~/.config/yazi/theme.toml`
2. 重启 Yazi 或按 `R` 刷新配置
3. 检查终端是否支持真彩色

### 颜色显示异常

1. 确认终端支持 24-bit 真彩色:

   ```bash
   echo $COLORTERM  # 应该显示 "truecolor" 或 "24bit"
   ```

2. 确认使用的是 Nerd Font 字体

### 快捷键不work

1. 确认已安装主题切换插件
2. 检查 `keymap.toml` 中的快捷键绑定
3. 确认插件路径: `~/.config/yazi/plugins/theme-switcher.yazi/`

---

## 📦 主题文件位置

```
~/.config/yazi/
├── theme.toml                      # 当前使用的主题
├── themes/                         # 主题库
│   ├── tokyo-night-storm.toml
│   ├── catppuccin-mocha.toml
│   ├── gruvbox-dark.toml
│   └── nord.toml
└── plugins/
    └── theme-switcher.yazi/        # 主题切换插件
```

---

## 🌈 推荐主题组合

- **日间工作**: Tokyo Night → Catppuccin Mocha
- **夜间编码**: Tokyo Night Storm → Gruvbox Dark  
- **清新视觉**: Nord → Catppuccin Mocha
- **怀旧风格**: Gruvbox Dark → Tokyo Night

---

## 📚 参考资源

- [Tokyo Night 官方](https://github.com/tokyo-night/tokyo-night-vscode-theme)
- [Catppuccin 官方](https://github.com/catppuccin/catppuccin)
- [Gruvbox 官方](https://github.com/morhetz/gruvbox)
- [Nord 官方](https://www.nordtheme.com/)
- [Yazi 主题文档](https://yazi-rs.github.io/docs/configuration/theme)

---

## 许可证

所有主题遵循其各自的许可证。
