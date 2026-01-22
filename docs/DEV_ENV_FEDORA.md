# 🐧 Fedora 43 开发环境配置指南

> **系统版本**: Fedora 43 Workstation Edition (GNOME 49 + Wayland)  
> **硬件架构**: AMD64 (x86_64)  
> **更新日期**: 2026-01-22

本指南提供 Fedora 43 系统上完整的开发工具链安装与配置流程,涵盖系统编译器、现代编程语言、Python 生态系统、科学计算环境和前端开发工具。

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
- [Homebrew 包管理器](#homebrew-包管理器)
- [Nix 包管理器](#nix-包管理器)
- [ROCm 深度学习 (AMD GPU)](#rocm-深度学习-amd-gpu)

---

## 系统基础配置

### DNF 包管理器优化

```bash
# 加速 DNF 下载 (启用并行下载和最快镜像)
echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
echo 'fastestmirror=True' | sudo tee -a /etc/dnf/dnf.conf
echo 'deltarpm=True' | sudo tee -a /etc/dnf/dnf.conf

# 系统更新
sudo dnf upgrade --refresh -y
```

### RPM Fusion 源配置

```bash
# 安装 RPM Fusion Free 和 Nonfree 仓库
sudo dnf install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# 更新仓库缓存
sudo dnf update -y
```

### 必备开发工具

```bash
# 安装基础开发工具组
sudo dnf groupinstall -y "Development Tools" "Development Libraries"

# 安装常用开发工具
sudo dnf install -y \
  git git-lfs \
  wget curl \
  vim neovim \
  tmux \
  htop btop \
  bat lsd fd-find ripgrep \
  tree \
  unzip zip p7zip
```

> [!TIP]
> **现代化 CLI 工具**
>
> - `bat`: 高亮显示的 `cat` 替代品
> - `lsd`: 美化的 `ls` 替代品
> - `fd`: 更快的 `find` 替代品
> - `ripgrep (rg)`: 更快的 `grep` 替代品

---

## C/C++ 开发环境

### GCC/G++ 编译器套件

```bash
# 安装 GCC 和 G++ 编译器
sudo dnf install -y gcc gcc-c++ gdb

# 验证安装
gcc --version      # 应显示 GCC 14.x (Fedora 43)
g++ --version
gdb --version
```

### Clang/LLVM 工具链

```bash
# 安装 Clang 和 LLVM
sudo dnf install -y clang llvm lldb

# 安装 Clang 工具
sudo dnf install -y clang-tools-extra

# 验证安装
clang --version    # 应显示 Clang 18.x
lldb --version
```

### CMake 构建系统

```bash
# 安装 CMake 和 Make
sudo dnf install -y cmake make ninja-build

# 验证安装
cmake --version    # 应显示 CMake 3.28+
ninja --version
```

### 常用库

```bash
# 安装开发库
sudo dnf install -y \
  boost-devel \
  eigen3-devel \
  opencv-devel \
  hdf5-devel \
  libpng-devel \
  libjpeg-turbo-devel
```

> [!NOTE]
> **编译器选择**
>
> - **GCC**: 传统 C/C++ 编译器,兼容性最好
> - **Clang**: 编译速度快,错误提示友好,LSP 支持更好

---

## Rust 开发环境

### rustup 安装

```bash
# 使用官方脚本安装 rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 选择默认安装 (1)
# 安装完成后,重新加载 shell 配置
source $HOME/.cargo/env
```

### 配置环境变量

```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
echo 'export CARGO_HOME="$HOME/.cargo"' >> ~/.bashrc
echo 'export RUSTUP_HOME="$HOME/.rustup"' >> ~/.bashrc
echo 'export PATH="$CARGO_HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 验证安装

```bash
# 检查 Rust 版本
rustc --version    # 应显示最新稳定版 (1.84+)
cargo --version

# 更新工具链
rustup update
```

### 安装常用组件

```bash
# 安装 Rust Analyzer (LSP)
rustup component add rust-analyzer

# 安装格式化工具和 Linter
rustup component add rustfmt clippy

# 验证
cargo fmt --version
cargo clippy --version
```

### Cargo 配置优化

```bash
# 创建 Cargo 配置文件
mkdir -p ~/.cargo
cat > ~/.cargo/config.toml << 'EOF'
# 使用国内镜像加速 (可选)
[source.crates-io]
replace-with = 'ustc'

[source.ustc]
registry = "https://mirrors.ustc.edu.cn/crates.io-index"

# 编译优化
[build]
jobs = 12  # 根据 CPU 核心数调整

# 增量编译
[profile.dev]
incremental = true

[profile.release]
lto = true
codegen-units = 1
EOF
```

> [!IMPORTANT]
> **Rust 开发核心工具**
>
> - `rustup`: 工具链版本管理器
> - `cargo`: 包管理器和构建工具
> - `rust-analyzer`: LSP 语言服务器 (Neovim/VSCode 必需)
> - `rustfmt`: 代码格式化工具
> - `clippy`: 静态分析和 Linter

---

## Java 开发环境

### OpenJDK 安装

```bash
# 安装 OpenJDK 17 (LTS) 和 21 (最新 LTS)
sudo dnf install -y java-17-openjdk java-17-openjdk-devel
sudo dnf install -y java-21-openjdk java-21-openjdk-devel

# 验证安装
java -version
javac -version

# 切换默认 Java 版本
sudo alternatives --config java
sudo alternatives --config javac
```

### 配置 JAVA_HOME

```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
echo 'export JAVA_HOME=/usr/lib/jvm/java-21-openjdk' >> ~/.bashrc
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 验证
echo $JAVA_HOME
```

### Maven 构建工具

```bash
# 安装 Maven
sudo dnf install -y maven

# 验证
mvn --version    # 应显示 Maven 3.9+
```

### Gradle 构建工具

```bash
# 安装 Gradle
sudo dnf install -y gradle

# 验证
gradle --version
```

### SDKMAN 版本管理器 (可选)

```bash
# 安装 SDKMAN
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# 使用 SDKMAN 安装 Java/Maven/Gradle
sdk install java 21.0.1-tem
sdk install maven
sdk install gradle

# 列出可用版本
sdk list java
```

---

## Python 生态系统

### 系统 Python 配置

```bash
# Fedora 43 默认 Python 3.12
python3 --version

# 安装 Python 开发包
sudo dnf install -y python3-devel python3-pip

# 安装 pipx (用于安装 Python 命令行工具)
sudo dnf install -y pipx
pipx ensurepath
```

### uv - 快速包管理器 (推荐 ⭐)

```bash
# 使用 pipx 安装 uv
pipx install uv

# 或使用官方安装脚本
curl -LsSf https://astral.sh/uv/install.sh | sh

# 验证安装
uv --version

# 基础使用
uv venv myenv                    # 创建虚拟环境
source myenv/bin/activate        # 激活环境
uv pip install numpy pandas      # 安装包 (极快!)
uv pip list                      # 列出已安装包

# 运行 Python 脚本 (自动管理依赖)
uv run script.py

# 初始化项目
uv init myproject
cd myproject
uv add requests numpy            # 添加依赖
uv run python main.py            # 运行项目
```

> [!TIP]
> **为什么选择 uv?**
>
> - **速度极快**: 比 pip 快 10-100 倍
> - **现代化**: Rust 编写,类似 Cargo/npm 的体验
> - **零配置**: 开箱即用,无需复杂设置
> - **兼容性好**: 与 pip 命令兼容

### poetry - 依赖管理

```bash
# 使用 pipx 安装 poetry
pipx install poetry

# 验证
poetry --version

# 创建新项目
poetry new myproject
cd myproject

# 添加依赖
poetry add requests numpy

# 安装依赖
poetry install

# 运行脚本
poetry run python main.py

# 进入虚拟环境
poetry shell
```

### pyenv - 多版本管理

```bash
# 安装依赖
sudo dnf install -y make gcc zlib-devel bzip2 bzip2-devel \
  readline-devel sqlite sqlite-devel openssl-devel tk-devel \
  libffi-devel xz-devel

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

# 设置项目本地版本
cd myproject
pyenv local 3.11.7
```

### pixi - 跨平台包管理

```bash
# 安装 pixi
curl -fsSL https://pixi.sh/install.sh | bash

# 验证
pixi --version

# 初始化项目
pixi init myproject
cd myproject

# 添加依赖
pixi add python numpy pandas

# 运行命令
pixi run python script.py

# 进入 shell
pixi shell
```

---

## Go 开发环境

### Go 安装

```bash
# 方法 1: 使用 DNF 安装
sudo dnf install -y golang

# 方法 2: 官方二进制安装 (推荐,版本更新)
GO_VERSION="1.22.0"  # 检查最新版本
wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz

# 验证
go version
```

### 配置环境变量

```bash
# 添加到 ~/.bashrc
cat >> ~/.bashrc << 'EOF'
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct  # 国内镜像加速
EOF

source ~/.bashrc
```

### 安装常用工具

```bash
# Go LSP 服务器
go install golang.org/x/tools/gopls@latest

# Go 工具
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/go-delve/delve/cmd/dlv@latest

# 验证
gopls version
golangci-lint --version
```

---

## Fortran 环境

### gfortran 编译器

```bash
# 安装 gfortran
sudo dnf install -y gcc-gfortran

# 验证
gfortran --version    # 应显示 GCC Fortran 14.x
```

### 科学计算库

```bash
# 安装 BLAS/LAPACK
sudo dnf install -y openblas-devel lapack-devel

# 安装 HDF5
sudo dnf install -y hdf5-devel hdf5-fortran

# 安装 NetCDF
sudo dnf install -y netcdf-fortran-devel
```

### 示例编译

```bash
# 创建测试程序
cat > hello.f90 << 'EOF'
program hello
  print *, "Hello, Fortran!"
end program hello
EOF

# 编译
gfortran hello.f90 -o hello

# 运行
./hello
```

---

## Ruby 开发环境

### rbenv 版本管理

```bash
# 安装依赖
sudo dnf install -y git openssl-devel readline-devel zlib-devel

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

# 安装 Ruby 版本
rbenv install 3.3.0
rbenv global 3.3.0

# 验证
ruby --version
gem --version
```

### Bundler 依赖管理

```bash
# 安装 Bundler
gem install bundler

# 在项目中使用
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

# 方法 2: 使用 DNF
sudo dnf install -y julia

# 验证
julia --version
```

### 包管理器配置

```bash
# 启动 Julia REPL
julia

# 在 Julia 中安装包
using Pkg
Pkg.add("Plots")
Pkg.add("DataFrames")
Pkg.add("DifferentialEquations")
```

### Jupyter 集成

```bash
# 在 Julia 中安装 IJulia
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
# 下载 Miniforge (包含 Mamba)
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh

# 安装
bash Miniforge3-Linux-x86_64.sh

# 按提示操作:
# - 接受许可协议
# - 选择安装路径 (默认 ~/miniforge3)
# - 允许初始化 shell

# 重新加载 shell
source ~/.bashrc

# 验证
conda --version
mamba --version
```

### Mamba 快速包管理器

```bash
# Miniforge 已包含 Mamba,直接使用

# 创建环境 (使用 mamba 比 conda 快 10 倍)
mamba create -n myenv python=3.11 numpy pandas matplotlib

# 激活环境
conda activate myenv

# 安装包
mamba install scipy scikit-learn

# 列出环境
conda env list
```

### Micromamba 轻量级版本

```bash
# 安装 Micromamba
curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba

# 移动到系统路径
sudo mv bin/micromamba /usr/local/bin/
rm -rf bin

# 初始化
micromamba shell init -s bash -p ~/micromamba
source ~/.bashrc

# 使用 (命令与 conda 相同)
micromamba create -n myenv python=3.11
micromamba activate myenv
micromamba install numpy
```

### .condarc 配置优化

```bash
# 创建配置文件
cat > ~/.condarc << 'EOF'
channels:
  - conda-forge
  - defaults

show_channel_urls: true
auto_activate_base: false

# 国内镜像加速 (可选)
channel_alias: https://mirrors.tuna.tsinghua.edu.cn/anaconda
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
EOF
```

> [!NOTE]
> **Conda 系列工具对比**
>
> - **Conda**: 传统包管理器,功能完整但较慢
> - **Mamba**: C++ 重写,速度快 10 倍,推荐日常使用
> - **Micromamba**: 单文件可执行,适合 CI/CD 和轻量环境

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
# 安装最新 LTS 版本
nvm install --lts

# 安装特定版本
nvm install 20
nvm install 18

# 列出已安装版本
nvm list

# 切换版本
nvm use 20

# 设置默认版本
nvm alias default 20

# 验证
node --version
npm --version
```

### 配置 npm 镜像

```bash
# 使用国内镜像加速
npm config set registry https://registry.npmmirror.com

# 验证
npm config get registry
```

### 安装全局工具

```bash
# 安装常用全局工具
npm install -g yarn pnpm
npm install -g typescript ts-node
npm install -g @vue/cli create-react-app

# 验证
yarn --version
pnpm --version
tsc --version
```

---

## Homebrew 包管理器

> [!NOTE]
> **Homebrew on Linux** (又称 Linuxbrew)
>
> Homebrew 是 macOS 上最流行的包管理器,也支持 Linux。它提供了一个独立于系统包管理器的包生态,特别适合:
>
> - 安装最新版本的工具 (不受系统仓库限制)
> - 多版本共存
> - 用户级安装 (无需 sudo)

### Homebrew 安装

```bash
# 安装 Homebrew (官方脚本)
/bin/bash -c "$(curl -fsS L https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装过程会自动:
# 1. 安装必要的依赖 (如 git, curl)
# 2. 创建 /home/linuxbrew/.linuxbrew 目录
# 3. 克隆 Homebrew 仓库
```

### 配置环境变量

```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
cat >> ~/.bashrc << 'EOF'
# Homebrew 配置
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
EOF

source ~/.bashrc

# 验证安装
brew --version
```

### 配置国内镜像 (可选)

```bash
# 使用清华镜像加速 (中国大陆用户)
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"

# 将上述配置添加到 ~/.bashrc
cat >> ~/.bashrc << 'EOF'
# Homebrew 镜像加速
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
EOF
```

### 基本使用

```bash
# 搜索软件包
brew search <package>

# 安装软件包
brew install <package>
brew install gcc              # 安装 GCC
brew install ripgrep          # 安装 ripgrep

# 列出已安装的包
brew list

# 更新 Homebrew 和所有包
brew update                   # 更新 Homebrew 本身
brew upgrade                  # 更新所有已安装的包
brew upgrade <package>        # 更新特定包

# 查看包信息
brew info <package>

# 卸载软件包
brew uninstall <package>

# 清理旧版本
brew cleanup
```

### 常用工具安装示例

```bash
# 开发工具
brew install neovim bat fd ripgrep fzf

# 编程语言 (可用于多版本管理)
brew install python@3.11 python@3.12
brew install node@18 node@20

# 数据库
brew install postgresql mysql redis

# 其他工具
brew install tmux htop tree jq
```

### 与系统包管理器共存

> [!TIP]
> **最佳实践**
>
> 1. **系统核心工具**: 使用 DNF 安装 (如 gcc, make, git)
> 2. **最新版本工具**: 使用 Homebrew 安装
> 3. **开发工具**: 优先使用语言专用管理器 (rustup, nvm, pyenv)
> 4. **PATH 优先级**: Homebrew 路径一般放在系统路径之前

```bash
# Homebrew 安装的工具默认在:
/home/linuxbrew/.linuxbrew/bin

# 检查命令来源
which python3              # 查看使用的是哪个 python3
type -a python3            # 列出所有可用的 python3
```

---

## Nix 包管理器

> [!NOTE]
> **Nix 包管理器**
>
> Nix 是一个功能强大的跨平台包管理器,特点:
>
> - **声明式配置**: 所有包和配置用 Nix 表达式描述
> - **可复现构建**: 相同配置在任何机器上产生相同结果
> - **原子性更新**: 升级/回滚系统时不会破坏
> - **多版本共存**: 不同版本的包可以同时安装
> - **用户级安装**: 无需 root 权限

### Nix 安装

#### 单用户模式 (推荐)

```bash
# 单用户安装 (所有内容在 ~/.nix-profile)
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# 重新加载 shell
source ~/.nix-profile/etc/profile.d/nix.sh
```

#### 多用户模式

```bash
# 多用户安装 (系统级,需要 sudo)
sh <(curl -L https://nixos.org/nix/install) --daemon

# 安装后会创建 nix-daemon 服务
sudo systemctl enable nix-daemon
sudo systemctl start nix-daemon
```

### 配置环境变量

```bash
# Nix 会自动添加配置到 ~/.bashrc 或 ~/.zshrc
# 单用户模式:
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
  . ~/.nix-profile/etc/profile.d/nix.sh
fi

# 多用户模式:
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
```

### 配置国内镜像 (可选)

```bash
# 使用清华镜像
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << 'EOF'
substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org/
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
EOF
```

### 基本使用

```bash
# 搜索软件包
nix search nixpkgs <package>
nix search nixpkgs python

# 安装软件包 (临时,当前 shell 有效)
nix-shell -p <package>
nix-shell -p python3 nodejs

# 安装软件包 (持久到用户环境)
nix-env -iA nixpkgs.<package>
nix-env -iA nixpkgs.ripgrep
nix-env -iA nixpkgs.neovim

# 列出已安装的包
nix-env -q

# 卸载软件包
nix-env -e <package>

# 更新所有包
nix-env -u

# 垃圾回收 (清理未使用的包)
nix-collect-garbage
nix-collect-garbage -d        # 删除所有旧版本
```

### Nix Flakes (现代化 Nix)

```bash
# 启用 Flakes (实验性功能)
mkdir -p ~/.config/nix
cat >> ~/.config/nix/nix.conf << 'EOF'
experimental-features = nix-command flakes
EOF

# 使用 flake 运行程序 (无需安装)
nix run nixpkgs#hello
nix run nixpkgs#python3

# 创建开发环境 (flake.nix)
mkdir myproject && cd myproject
cat > flake.nix << 'EOF'
{
  description = "My development environment";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs }: {
    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
      buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
        python3
        nodejs
        go
      ];
    };
  };
}
EOF

# 进入开发环境
nix develop
```

### Home Manager (用户环境管理)

```bash
# Home Manager 用于声明式管理用户环境和dotfiles

# 安装 Home Manager (使用 Flakes)
nix run home-manager/master -- init

# 编辑配置 ~/.config/home-manager/home.nix
# 示例配置:
{ config, pkgs, ... }:
{
  home.username = "yyt";
  home.homeDirectory = "/home/yyt";
  home.stateVersion = "23.11";
  
  home.packages = with pkgs; [
    bat
    ripgrep
    fd
    htop
    neovim
  ];
  
  programs.git = {
    enable = true;
    userName = "SMLYFM";
    userEmail = "yytcjx@gmail.com";
  };
  
  programs.bash.enable = true;
}

# 应用配置
home-manager switch
```

### Nix 常用场景

#### 1. 临时测试工具

```bash
# 临时使用工具而不安装
nix-shell -p imagemagick
convert input.png output.jpg
exit  # 退出后 imagemagick 不再可用
```

#### 2. 项目特定开发环境

```bash
# 创建 shell.nix
cat > shell.nix << 'EOF'
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    python311
    python311Packages.numpy
    python311Packages.pandas
  ];
  
  shellHook = ''
    echo "Python development environment loaded"
    python --version
  '';
}
EOF

# 进入环境
nix-shell
```

#### 3. 多版本共存

```bash
# 同时使用不同版本的工具
nix-shell -p python38
nix-shell -p python311
nix-shell -p python312
```

> [!WARNING]
> **Nix 学习曲线**
>
> Nix 的声明式配置和函数式语言有一定学习曲线,建议:
>
> 1. 先用 `nix-shell` 熟悉临时环境
> 2. 再尝试 `nix-env` 安装持久包
> 3. 最后学习 Flakes 和 Home Manager

> [!TIP]
> **Nix vs Homebrew 选择**
>
> - **Homebrew**: 简单易用,类似 apt/dnf,适合日常使用
> - **Nix**: 声明式配置,可复现环境,适合高级用户和 CI/CD
> - 两者可以共存,但注意 PATH 优先级

---

## ROCm 深度学习 (AMD GPU)

> [!WARNING]
> **仅适用于 AMD GPU 用户**
> 本章节适用于 AMD Radeon 显卡 (如 Radeon 680M),用于深度学习加速。  
> **NVIDIA GPU 用户请跳过此章节**,使用 CUDA 工具链。

### ROCm 安装

```bash
# 添加 ROCm 仓库 (AMD 官方)
sudo tee /etc/yum.repos.d/amdgpu.repo << 'EOF'
[amdgpu]
name=amdgpu
baseurl=https://repo.radeon.com/amdgpu/latest/rhel/9.3/main/x86_64/
enabled=1
gpgcheck=1
gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
EOF

# 安装 ROCm
sudo dnf install -y rocm-hip-sdk rocm-opencl rocm-smi

# 添加用户到 video 和 render 组
sudo usermod -a -G video,render $USER

# 重新登录以使组权限生效
newgrp render

# 验证
rocm-smi  # 应显示 GPU 信息
```

### PyTorch ROCm 版本

```bash
# 使用 uv 创建环境并安装 PyTorch ROCm 版本
uv venv torch-rocm
source torch-rocm/bin/activate

# 安装 PyTorch for ROCm 6.0
uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.0

# 验证 GPU 可用性
python -c "import torch; print(f'CUDA Available: {torch.cuda.is_available()}'); print(f'Device: {torch.cuda.get_device_name(0) if torch.cuda.is_available() else \"CPU\"}')"
```

### TensorFlow ROCm 配置

```bash
# 安装 TensorFlow ROCm 版本
uv pip install tensorflow-rocm

# 验证
python -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
```

> [!TIP]
> **ROCm 注意事项**
>
> - PyTorch 在 ROCm 上使用 `torch.cuda.*` API (保持兼容性)
> - 检测代码: `device = torch.device("cuda" if torch.cuda.is_available() else "cpu")`
> - 实际底层使用 ROCm 而非 CUDA
> - AMD APU (集成显卡) 支持有限,性能不如独立显卡

---

## 📚 相关文档

- [Ubuntu 开发环境配置](DEV_ENV_UBUNTU.md)
- [环境变量配置指南](ENV_VARS.md)
- [常用命令速查表](COMMON_COMMANDS.md)
- [主配置说明](../README.md)

---

## 🤝 反馈与贡献

发现问题或有改进建议? 欢迎提交 Issue 或 Pull Request!

**仓库**: [goblinunde/resource-fedora](https://github.com/goblinunde/resource-fedora)

---

**⭐ 如果本指南对你有帮助,请给仓库一个 Star!**
