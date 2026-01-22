# 🐧 Ubuntu 开发环境配置指南

> **支持系统**: Ubuntu 22.04 LTS / Ubuntu 24.04 LTS  
> **硬件架构**: AMD64 (x86_64)  
> **更新日期**: 2026-01-22

本指南提供 Ubuntu 系统上完整的开发工具链安装与配置流程,涵盖系统编译器、现代编程语言、Python 生态系统、科学计算环境和前端开发工具。

---

## 📋 目录

- [系统基础配置](#系统基础配置)
- [C/C++ 开发环境](#cc-开发环境)
- [Rust 开发环境](#rust-开发环境)
- [Java 开发环境](#java-开发环境)
- [Python 生态系统](#python-生态系统)
- [Go 开发环境](#go-开发环境)
- [Fortran 环境](#fortran-环境)
- [Ruby 开发环境](#ruby-开发环境)
- [Julia 科学计算](#julia-科学计算)
- [Conda 生态系统](#conda-生态系统)
- [Node.js 环境](#nodejs-环境)
- [CUDA 深度学习 (NVIDIA GPU)](#cuda-深度学习-nvidia-gpu)

---

## 系统基础配置

### APT 包管理器优化

```bash
# 系统更新
sudo apt update && sudo apt upgrade -y

# 安装软件属性管理工具
sudo apt install -y software-properties-common apt-transport-https
```

### Ubuntu 镜像源配置 (国内用户)

```bash
# 备份原始源
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

# Ubuntu 22.04 LTS 使用清华源
sudo tee /etc/apt/sources.list << 'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
EOF

# Ubuntu 24.04 LTS 使用清华源
sudo tee /etc/apt/sources.list << 'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-security main restricted universe multiverse
EOF

# 更新源
sudo apt update
```

### 必备开发工具

```bash
# 安装 build-essential (包含 GCC、Make 等)
sudo apt install -y build-essential

# 安装常用工具
sudo apt install -y \
  git git-lfs \
  wget curl \
  vim neovim \
  tmux \
  htop \
  tree \
  unzip zip p7zip-full
```

### 现代化 CLI 工具

```bash
# bat - 高亮显示的 cat
sudo apt install -y bat
# Ubuntu 上 bat 命令为 batcat,创建别名
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat

# lsd - 美化的 ls
wget https://github.com/lsd-rs/lsd/releases/download/v1.1.2/lsd_1.1.2_amd64.deb
sudo dpkg -i lsd_1.1.2_amd64.deb
rm lsd_1.1.2_amd64.deb

# fd - 更快的 find
sudo apt install -y fd-find
ln -s $(which fdfind) ~/.local/bin/fd

# ripgrep - 更快的 grep
sudo apt install -y ripgrep
```

---

## C/C++ 开发环境

### GCC/G++ 编译器套件

```bash
# build-essential 已包含 GCC
gcc --version      # Ubuntu 22.04: GCC 11.x, Ubuntu 24.04: GCC 13.x
g++ --version

# 安装 GDB 调试器
sudo apt install -y gdb

# 验证
gdb --version
```

### Clang/LLVM 工具链

```bash
# 安装 Clang 和 LLVM
sudo apt install -y clang llvm lldb

# 安装 Clang 工具
sudo apt install -y clang-format clang-tidy

# 验证
clang --version    # Ubuntu 22.04: Clang 14.x, Ubuntu 24.04: Clang 18.x
lldb --version
```

### CMake 构建系统

```bash
# Ubuntu 仓库版本
sudo apt install -y cmake

# 或安装最新版本 (推荐)
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
sudo apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
sudo apt update
sudo apt install -y cmake

# 验证
cmake --version    # 应显示 3.28+
```

### 常用开发库

```bash
# 安装开发库
sudo apt install -y \
  libboost-all-dev \
  libeigen3-dev \
  libopencv-dev \
  libhdf5-dev \
  libpng-dev \
  libjpeg-dev
```

---

## Rust 开发环境

### rustup 安装

```bash
# 使用官方脚本安装 rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 选择默认安装 (1)
# 重新加载 shell 配置
source $HOME/.cargo/env
```

### 配置环境变量

```bash
# 添加到 ~/.bashrc
echo 'export CARGO_HOME="$HOME/.cargo"' >> ~/.bashrc
echo 'export RUSTUP_HOME="$HOME/.rustup"' >> ~/.bashrc
echo 'export PATH="$CARGO_HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 验证安装

```bash
# 检查版本
rustc --version    # 应显示最新稳定版
cargo --version

# 更新工具链
rustup update
```

### 安装常用组件

```bash
# Rust Analyzer LSP
rustup component add rust-analyzer

# 格式化和 Linter
rustup component add rustfmt clippy

# 验证
cargo fmt --version
cargo clippy --version
```

### Cargo 配置优化

```bash
# 创建配置文件
mkdir -p ~/.cargo
cat > ~/.cargo/config.toml << 'EOF'
# 使用国内镜像 (可选)
[source.crates-io]
replace-with = 'ustc'

[source.ustc]
registry = "https://mirrors.ustc.edu.cn/crates.io-index"

# 编译优化
[build]
jobs = 8  # 根据 CPU 核心数调整

[profile.dev]
incremental = true

[profile.release]
lto = true
codegen-units = 1
EOF
```

---

## Java 开发环境

### OpenJDK 安装

```bash
# 安装 OpenJDK 17 (LTS)
sudo apt install -y openjdk-17-jdk

# 安装 OpenJDK 21 (最新 LTS, Ubuntu 24.04+)
sudo apt install -y openjdk-21-jdk

# 验证
java -version
javac -version

# 切换 Java 版本
sudo update-alternatives --config java
sudo update-alternatives --config javac
```

### SDKMAN 版本管理器 (推荐 ⭐)

```bash
# 安装 SDKMAN
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# 列出可用 Java 版本
sdk list java

# 安装 Java (多种发行版)
sdk install java 21.0.1-tem      # Temurin (Eclipse)
sdk install java 21.0.1-graal    # GraalVM
sdk install java 17.0.9-zulu     # Azul Zulu

# 切换版本
sdk use java 21.0.1-tem

# 设置默认版本
sdk default java 21.0.1-tem

# 验证
java -version
```

### 配置 JAVA_HOME

```bash
# 添加到 ~/.bashrc
echo 'export JAVA_HOME="$HOME/.sdkman/candidates/java/current"' >> ~/.bashrc
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Maven 和 Gradle

```bash
# 使用 SDKMAN 安装 (推荐)
sdk install maven
sdk install gradle

# 或使用 APT
sudo apt install -y maven gradle

# 验证
mvn --version
gradle --version
```

---

## Python 生态系统

### 系统 Python 配置

```bash
# Ubuntu 22.04: Python 3.10, Ubuntu 24.04: Python 3.12
python3 --version

# 安装 Python 开发包
sudo apt install -y python3-dev python3-pip python3-venv

# 安装 pipx
sudo apt install -y pipx
pipx ensurepath
```

### uv - 快速包管理器 (推荐 ⭐)

```bash
# 使用 pipx 安装
pipx install uv

# 或使用官方脚本
curl -LsSf https://astral.sh/uv/install.sh | sh

# 验证
uv --version

# 基础使用
uv venv myenv                    # 创建虚拟环境
source myenv/bin/activate        # 激活环境
uv pip install numpy pandas      # 极速安装包
uv pip list                      # 列出包

# 项目管理
uv init myproject
cd myproject
uv add requests numpy            # 添加依赖
uv run python main.py            # 运行项目
```

> [!TIP]
> **uv 优势**
>
> - **速度**: 比 pip 快 10-100 倍
> - **现代化**: 类似 npm/cargo 的体验
> - **兼容性**: 与 pip 命令完全兼容

### poetry - 依赖管理

```bash
# 使用 pipx 安装
pipx install poetry

# 验证
poetry --version

# 使用
poetry new myproject
cd myproject
poetry add requests
poetry install
poetry run python main.py
```

### pyenv - Python 多版本管理

```bash
# 安装依赖
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
  libffi-dev liblzma-dev

# 安装 pyenv
curl https://pyenv.run | bash

# 添加到 ~/.bashrc
cat >> ~/.bashrc << 'EOF'
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
EOF

source ~/.bashrc

# 安装 Python 版本
pyenv install 3.11.7
pyenv install 3.12.1

# 设置全局版本
pyenv global 3.12.1

# 项目本地版本
cd myproject
pyenv local 3.11.7
```

### pixi - 跨平台包管理

```bash
# 安装 pixi
curl -fsSL https://pixi.sh/install.sh | bash

# 验证
pixi --version

# 使用
pixi init myproject
cd myproject
pixi add python numpy pandas
pixi run python script.py
```

---

## Go 开发环境

### Go 安装

```bash
# 下载最新版本 (检查 https://go.dev/dl/)
GO_VERSION="1.22.0"
wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz

# 安装
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz

# 验证
/usr/local/go/bin/go version
```

### 配置环境变量

```bash
# 添加到 ~/.bashrc
cat >> ~/.bashrc << 'EOF'
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct  # 国内加速
EOF

source ~/.bashrc

# 验证
go version
go env
```

### 安装 Go 工具

```bash
# LSP 服务器
go install golang.org/x/tools/gopls@latest

# Linter
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# 调试器
go install github.com/go-delve/delve/cmd/dlv@latest

# 验证
gopls version
golangci-lint --version
dlv version
```

---

## Fortran 环境

### gfortran 编译器

```bash
# 安装 gfortran
sudo apt install -y gfortran

# 验证
gfortran --version
```

### 科学计算库

```bash
# BLAS/LAPACK
sudo apt install -y libopenblas-dev liblapack-dev

# HDF5
sudo apt install -y libhdf5-dev

# NetCDF
sudo apt install -y libnetcdf-dev libnetcdff-dev
```

---

## Ruby 开发环境

### rbenv 版本管理

```bash
# 安装依赖
sudo apt install -y git libssl-dev libreadline-dev zlib1g-dev \
  autoconf bison build-essential libyaml-dev libreadline-dev \
  libncurses5-dev libffi-dev libgdbm-dev

# 安装 rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# 添加到 ~/.bashrc
cat >> ~/.bashrc << 'EOF'
export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init - bash)"
EOF

source ~/.bashrc

# 安装 Ruby
rbenv install 3.3.0
rbenv global 3.3.0

# 验证
ruby --version
gem --version
```

### Bundler

```bash
# 安装
gem install bundler

# 使用
bundle init
bundle add rails
bundle install
```

---

## Julia 科学计算

### Julia 安装

```bash
# 方法 1: 官方二进制 (推荐)
JULIA_VERSION="1.10.0"
wget https://julialang-s3.julialang.org/bin/linux/x64/1.10/julia-${JULIA_VERSION}-linux-x86_64.tar.gz
tar xzf julia-${JULIA_VERSION}-linux-x86_64.tar.gz
sudo mv julia-${JULIA_VERSION} /opt/julia
sudo ln -s /opt/julia/bin/julia /usr/local/bin/julia
rm julia-${JULIA_VERSION}-linux-x86_64.tar.gz

# 方法 2: Juliaup 版本管理器
curl -fsSL https://install.julialang.org | sh

# 验证
julia --version
```

### 包管理

```bash
# 启动 Julia REPL
julia

# 安装常用包
using Pkg
Pkg.add("Plots")
Pkg.add("DataFrames")
Pkg.add("DifferentialEquations")
```

### Jupyter 集成

```bash
# 在 Julia 中
using Pkg
Pkg.add("IJulia")

# 启动 Jupyter
using IJulia
notebook()
```

---

## Conda 生态系统

### Miniforge 安装 (推荐 ⭐)

```bash
# 下载 Miniforge
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh

# 安装
bash Miniforge3-Linux-x86_64.sh

# 按提示操作并初始化 shell
source ~/.bashrc

# 验证
conda --version
mamba --version
```

### Mamba 使用

```bash
# 创建环境 (使用 mamba 速度更快)
mamba create -n myenv python=3.11 numpy pandas matplotlib

# 激活环境
conda activate myenv

# 安装包
mamba install scipy scikit-learn pytorch

# 列出环境
conda env list
```

### Micromamba

```bash
# 安装
curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
sudo mv bin/micromamba /usr/local/bin/
rm -rf bin

# 初始化
micromamba shell init -s bash -p ~/micromamba
source ~/.bashrc

# 使用
micromamba create -n myenv python=3.11
micromamba activate myenv
micromamba install numpy
```

### .condarc 配置

```bash
# 创建配置文件
cat > ~/.condarc << 'EOF'
channels:
  - conda-forge
  - defaults

show_channel_urls: true
auto_activate_base: false

# 清华镜像 (可选)
channel_alias: https://mirrors.tuna.tsinghua.edu.cn/anaconda
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
EOF
```

---

## Node.js 环境

### NVM 安装

```bash
# 安装 NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# 重新加载 shell
source ~/.bashrc

# 验证
nvm --version
```

### Node.js 安装与管理

```bash
# 安装最新 LTS
nvm install --lts

# 安装特定版本
nvm install 20
nvm install 18

# 列出版本
nvm list

# 切换版本
nvm use 20

# 设置默认
nvm alias default 20

# 验证
node --version
npm --version
```

### npm 配置

```bash
# 国内镜像
npm config set registry https://registry.npmmirror.com

# 验证
npm config get registry
```

### 全局工具

```bash
# 安装
npm install -g yarn pnpm
npm install -g typescript ts-node
npm install -g @vue/cli create-react-app

# 验证
yarn --version
pnpm --version
tsc --version
```

---

## CUDA 深度学习 (NVIDIA GPU)

> [!WARNING]
> **仅适用于 NVIDIA GPU 用户**
> AMD GPU 用户请参考 [Fedora 开发环境配置](DEV_ENV_FEDORA.md#rocm-深度学习-amd-gpu) 的 ROCm 部分。

### CUDA Toolkit 安装

```bash
# 添加 NVIDIA 官方仓库
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
rm cuda-keyring_1.1-1_all.deb

# 安装 CUDA Toolkit
sudo apt update
sudo apt install -y cuda-toolkit-12-3

# 配置环境变量
echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc

# 验证
nvcc --version
nvidia-smi
```

### cuDNN 安装

```bash
# 下载 cuDNN (需注册 NVIDIA 账号)
# https://developer.nvidia.com/cudnn

# 安装
sudo dpkg -i cudnn-local-repo-ubuntu2204-8.9.7.29_1.0-1_amd64.deb
sudo cp /var/cudnn-local-repo-ubuntu2204-8.9.7.29/cudnn-*-keyring.gpg /usr/share/keyrings/
sudo apt update
sudo apt install -y libcudnn8 libcudnn8-dev
```

### PyTorch CUDA 版本

```bash
# 使用 uv 安装
uv venv torch-cuda
source torch-cuda/bin/activate

# 安装 PyTorch with CUDA 12.1
uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# 验证
python -c "import torch; print(f'CUDA Available: {torch.cuda.is_available()}'); print(f'Device: {torch.cuda.get_device_name(0) if torch.cuda.is_available() else \"CPU\"}')"
```

### TensorFlow GPU

```bash
# 安装 TensorFlow GPU 版本
uv pip install tensorflow[and-cuda]

# 验证
python -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
```

---

## 📚 相关文档

- [Fedora 开发环境配置](DEV_ENV_FEDORA.md)
- [环境变量配置指南](ENV_VARS.md)
- [常用命令速查表](COMMON_COMMANDS.md)
- [主配置说明](../README.md)

---

## 🤝 反馈与贡献

发现问题或有改进建议? 欢迎提交 Issue 或 Pull Request!

**仓库**: [goblinunde/resource-fedora](https://github.com/goblinunde/resource-fedora)

---

**⭐ 如果本指南对你有帮助,请给仓库一个 Star!**
