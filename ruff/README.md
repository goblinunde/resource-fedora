# Ruff 配置 - 深度学习开发优化

针对 **PyTorch**、**TensorFlow** 和 **JAX** 深度学习开发优化的 Ruff 配置文件。

## 📁 文件说明

- **`ruff.toml`** - 全局 Ruff 配置文件，深度学习项目通用
- **`pyproject.toml.example`** - 项目级配置示例
- **`ruff-receipt.json`** - Ruff 安装信息

## 🚀 快速开始

### 1. 全局配置 (推荐)

将 `ruff.toml` 复制到你的项目根目录或 `~/.config/ruff/ruff.toml`：

```bash
# 项目级使用
cp ruff.toml /path/to/your/project/

# 全局使用
mkdir -p ~/.config/ruff
cp ruff.toml ~/.config/ruff/
```

### 2. 项目配置

在你的 `pyproject.toml` 中添加配置（参考 `pyproject.toml.example`）：

```toml
[tool.ruff]
target-version = "py310"
line-length = 100

[tool.ruff.lint]
select = ["F", "E", "W", "I", "D", "UP", "B", "NPY"]
```

## 📋 配置亮点

### ✨ 深度学习优化

- **行长度**: 100 字符（适合模型定义和数据处理）
- **已知第三方库**: 预配置 PyTorch, TensorFlow, JAX, NumPy 等
- **文档风格**: NumPy docstring 格式
- **忽略规则**: 忽略不适用于科学计算的规则

### 🎯 启用的规则集

- **F** - Pyflakes（基础错误检查）
- **E/W** - pycodestyle（代码风格）
- **I** - isort（导入排序）
- **D** - pydocstyle（文档字符串，NumPy 风格）
- **UP** - pyupgrade（现代化 Python 语法）
- **B** - flake8-bugbear（常见错误模式）
- **SIM** - flake8-simplify（简化代码）
- **NPY** - NumPy 特定规则
- **ANN** - 类型注解检查

### 🚫 忽略的规则

针对深度学习开发特点，忽略以下规则：

- **D100-D107**: 文档字符串（科学计算代码可选）
- **ANN101/102**: self/cls 类型注解
- **S301/403**: pickle 使用（模型保存常用）
- **B008**: 函数调用作为默认参数（PyTorch nn.Module 常用）

### 📦 特定文件规则

```toml
[lint.per-file-ignores]
# 测试文件
"test_*.py" = ["S101", "ANN", "D"]

# Jupyter notebooks
"*.ipynb" = ["D", "E402", "I001"]

# 数据加载器
"**/data/**" = ["S301"]
```

## 🔧 使用方法

### 基本用法

```bash
# 检查代码
ruff check .

# 自动修复
ruff check --fix .

# 格式化代码
ruff format .

# 同时检查和格式化
ruff check --fix . && ruff format .
```

### 针对特定框架

#### PyTorch 项目

```bash
# 检查 PyTorch 项目
ruff check --select NPY,B .

# 忽略模型文件的行长度限制
ruff check --exclude "models/*.py" --ignore E501
```

#### TensorFlow 项目

```bash
# TensorFlow 特定检查
ruff check --select NPY,PD .
```

#### JAX 项目

```bash
# JAX 函数式编程风格
ruff check --select NPY,RET .
```

### 集成到项目

#### Pre-commit Hook

`.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.14.13
    hooks:
      - id: ruff
        args: [--fix, --exit-non-zero-on-fix]
      - id: ruff-format
```

#### VS Code 集成

`.vscode/settings.json`:

```json
{
  "[python]": {
    "editor.defaultFormatter": "charliermarsh.ruff",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.fixAll": "explicit",
      "source.organizeImports": "explicit"
    }
  },
  "ruff.lint.args": ["--config=ruff.toml"]
}
```

## 📚 推荐工作流

### 1. 开发阶段

```bash
# 实时检查（配合编辑器插件）
ruff check --watch .
```

### 2. 提交前

```bash
# 修复所有可自动修复的问题
ruff check --fix .
ruff format .

# 检查剩余问题
ruff check .
```

### 3. CI/CD

```yaml
# GitHub Actions
- name: Lint with Ruff
  run: |
    pip install ruff
    ruff check .
    ruff format --check .
```

## 🎨 NumPy 文档字符串示例

```python
def train_model(
    model: torch.nn.Module,
    dataloader: torch.utils.data.DataLoader,
    epochs: int = 10
) -> dict:
    """
    训练深度学习模型。

    Parameters
    ----------
    model : torch.nn.Module
        要训练的 PyTorch 模型
    dataloader : torch.utils.data.DataLoader
        训练数据加载器
    epochs : int, optional
        训练轮数，默认为 10

    Returns
    -------
    dict
        包含训练历史的字典

    Examples
    --------
    >>> model = MyModel()
    >>> train_history = train_model(model, train_loader, epochs=100)
    """
    pass
```

## 🔗 相关资源

- [Ruff 官方文档](https://docs.astral.sh/ruff/)
- [规则参考](https://docs.astral.sh/ruff/rules/)
- [NumPy 文档风格指南](https://numpydoc.readthedocs.io/)
- [PyTorch 代码风格](https://github.com/pytorch/pytorch/blob/main/CONTRIBUTING.md)

## 💡 提示

1. **渐进式采用**: 从基础规则开始，逐步启用更多规则
2. **项目特定配置**: 使用 `per-file-ignores` 为不同文件设置不同规则
3. **团队协作**: 将配置文件加入版本控制，保持团队一致
4. **定期更新**: Ruff 更新频繁，定期检查新特性和规则

---

**更新日期**: 2026-01-22  
**Ruff 版本**: 0.14.13
