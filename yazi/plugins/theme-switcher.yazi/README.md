# Theme Switcher Plugin

一个用于 Yazi 文件管理器的主题切换插件。

## 功能

- 支持多个精美主题快速切换
- 提供快捷键绑定
- 实时应用主题无需重启

## 使用方法

### 快捷键

- `<Space>t` - 显示主题列表
- `<Space>tn` - 切换到下一个主题
- `<Space>tp` - 切换到上一个主题

### 手动调用

```bash
# 在 Yazi 中按 : 进入命令模式
:plugin theme-switcher

# 切换到下一个主题
:plugin theme-switcher --args=next

# 切换到上一个主题
:plugin theme-switcher --args=prev
```

## 可用主题

1. Tokyo Night (默认)
2. Tokyo Night Storm
3. Catppuccin Mocha
4. Gruvbox Dark
5. Nord

## 许可证

MIT
