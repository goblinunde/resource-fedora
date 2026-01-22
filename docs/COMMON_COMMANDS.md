# 📚 常用命令速查表

> **适用系统**: Fedora / Ubuntu / Linux  
> **更新日期**: 2026-01-22

本速查表汇总了开发环境中各类工具和包管理器的常用命令,便于快速查阅。

---

## 📋 目录

- [系统包管理器](#系统包管理器)
- [语言工具链](#语言工具链)
- [版本管理器](#版本管理器)
- [构建工具](#构建工具)

---

## 系统包管理器

### DNF (Fedora)

#### 基础操作

```bash
# 搜索软件包
sudo dnf search <package>

# 查看包信息
sudo dnf info <package>

# 安装软件包
sudo dnf install <package>
sudo dnf install <package1> <package2>  # 安装多个

# 卸载软件包
sudo dnf remove <package>

# 列出已安装的包
dnf list installed

# 列出可用包
dnf list available
```

#### 系统更新

```bash
# 检查可用更新
sudo dnf check-update

# 更新所有软件包
sudo dnf upgrade
sudo dnf upgrade --refresh  # 刷新元数据

# 更新特定包
sudo dnf upgrade <package>

# 系统版本升级 (如 Fedora 42 → 43)
sudo dnf system-upgrade download --releasever=43
sudo dnf system-upgrade reboot
```

#### 仓库管理

```bash
# 列出启用的仓库
dnf repolist

# 列出所有仓库 (包括禁用的)
dnf repolist --all

# 启用/禁用仓库
sudo dnf config-manager --set-enabled <repo-id>
sudo dnf config-manager --set-disabled <repo-id>

# 添加第三方仓库
sudo dnf config-manager --add-repo <repo-url>
```

#### 历史记录与回滚

```bash
# 查看操作历史
sudo dnf history

# 查看历史详情
sudo dnf history info <transaction-id>

# 回滚操作
sudo dnf history undo <transaction-id>

# 重做操作
sudo dnf history redo <transaction-id>
```

#### 清理与维护

```bash
# 清理缓存
sudo dnf clean all

# 删除孤立包 (无依赖的包)
sudo dnf autoremove

# 查看占用磁盘空间
sudo dnf clean dbcache
```

---

### APT (Ubuntu)

#### 基础操作

```bash
# 更新包列表
sudo apt update

# 搜索软件包
apt search <package>

# 查看包信息
apt show <package>

# 安装软件包
sudo apt install <package>
sudo apt install <package1> <package2>

# 卸载软件包
sudo apt remove <package>          # 保留配置文件
sudo apt purge <package>           # 删除配置文件

# 列出已安装的包
apt list --installed

# 列出可升级的包
apt list --upgradable
```

#### 系统更新

```bash
# 更新系统 (不删除旧包)
sudo apt update && sudo apt upgrade

# 完整升级 (会删除冲突的旧包)
sudo apt update && sudo apt full-upgrade

# 更新特定包
sudo apt install --only-upgrade <package>
```

#### PPA 管理

```bash
# 添加 PPA
sudo add-apt-repository ppa:<repository-name>
sudo apt update

# 删除 PPA
sudo add-apt-repository --remove ppa:<repository-name>

# 列出所有 PPA
ls /etc/apt/sources.list.d/
```

#### 清理与维护

```bash
# 清理下载的包文件
sudo apt clean

# 删除孤立包
sudo apt autoremove

# 删除旧内核 (保留当前和前一个)
sudo apt autoremove --purge
```

#### 锁定包版本

```bash
# 锁定包 (防止升级)
sudo apt-mark hold <package>

# 解锁包
sudo apt-mark unhold <package>

# 查看锁定的包
apt-mark showhold
```

---

## 语言工具链

### Rust (cargo/rustup)

#### Cargo 项目管理

```bash
# 创建新项目
cargo new myproject            # 二进制项目
cargo new --lib mylib          # 库项目

# 初始化现有目录
cargo init

# 构建项目
cargo build                    # Debug 模式
cargo build --release          # Release 模式

# 运行项目
cargo run
cargo run --release

# 检查代码 (不生成二进制)
cargo check
```

#### 依赖管理

```bash
# 添加依赖 (修改 Cargo.toml)
# 或使用 cargo-edit
cargo install cargo-edit
cargo add serde
cargo add tokio --features full

# 更新依赖
cargo update

# 列出依赖树
cargo tree

# 移除未使用的依赖
cargo install cargo-udeps
cargo udeps
```

#### 测试与基准

```bash
# 运行测试
cargo test
cargo test <test-name>         # 运行特定测试

# 运行基准测试
cargo bench

# 生成文档
cargo doc --open
```

#### 工具链管理 (rustup)

```bash
# 更新 Rust
rustup update

# 安装工具链
rustup install stable
rustup install nightly

# 设置默认工具链
rustup default stable

# 为项目设置工具链
rustup override set nightly

# 安装组件
rustup component add rustfmt
rustup component add clippy
rustup component add rust-analyzer

# 列出已安装工具链
rustup show

# 列出可用目标平台
rustup target list
rustup target add x86_64-pc-windows-gnu  # 交叉编译
```

#### 代码格式化与 Linting

```bash
# 格式化代码
cargo fmt

# 检查格式 (CI 中使用)
cargo fmt -- --check

# 运行 Clippy
cargo clippy
cargo clippy -- -D warnings    # 警告视为错误
```

---

### Go

#### 模块管理

```bash
# 初始化模块
go mod init github.com/username/project

# 添加依赖 (自动,运行 go get 或 go build)
go get github.com/gin-gonic/gin@latest

# 整理依赖 (删除未使用的)
go mod tidy

# 查看依赖
go list -m all

# 依赖图
go mod graph

# 下载依赖到本地缓存
go mod download

# 验证依赖
go mod verify
```

#### 构建与运行

```bash
# 运行程序
go run main.go
go run .

# 构建二进制
go build                       # 当前目录
go build -o myapp              # 指定输出名称
go build ./cmd/myapp           # 指定包路径

# 安装到 $GOPATH/bin
go install

# 交叉编译
GOOS=linux GOARCH=amd64 go build
GOOS=windows GOARCH=amd64 go build -o app.exe
```

#### 测试

```bash
# 运行测试
go test
go test ./...                  # 所有子包
go test -v                     # 详细输出
go test -run <TestName>        # 运行特定测试

# 测试覆盖率
go test -cover
go test -coverprofile=coverage.out
go tool cover -html=coverage.out

# 基准测试
go test -bench=.
go test -bench=<BenchmarkName>

# 竞态检测
go test -race
```

#### 代码格式化

```bash
# 格式化代码
go fmt ./...
gofmt -w .

# 导入整理
goimports -w .
```

#### 工具安装

```bash
# 安装 Go 工具
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Linting
golangci-lint run
```

---

### Java (Maven/Gradle)

#### Maven 命令

```bash
# 创建新项目
mvn archetype:generate \
  -DgroupId=com.example \
  -DartifactId=myapp \
  -DarchetypeArtifactId=maven-archetype-quickstart

# 编译
mvn compile                    # 仅编译
mvn test-compile               # 编译测试代码

# 测试
mvn test

# 打包
mvn package                    # 生成 JAR/WAR
mvn package -DskipTests        # 跳过测试

# 安装到本地仓库
mvn install

# 清理
mvn clean

# 常用组合
mvn clean install
mvn clean package
mvn clean test

# 运行应用 (Spring Boot)
mvn spring-boot:run

# 依赖管理
mvn dependency:tree            # 依赖树
mvn dependency:analyze         # 分析未使用依赖
mvn versions:display-dependency-updates  # 检查更新
```

#### Gradle 命令

```bash
# 初始化项目
gradle init

# 构建
gradle build
gradle build -x test           # 跳过测试

# 清理
gradle clean

# 测试
gradle test

# 运行应用
gradle run
gradle bootRun                 # Spring Boot

# 依赖管理
gradle dependencies            # 依赖树
gradle dependencyInsight       # 依赖分析

# 列出任务
gradle tasks
gradle tasks --all

# 常用组合
gradle clean build
gradle clean test
```

---

### Python (uv/poetry/pyenv)

#### uv 命令 (推荐 ⭐)

```bash
# 创建虚拟环境
uv venv myenv
uv venv --python 3.11 myenv

# 激活环境 (同标准 venv)
source myenv/bin/activate

# 安装包 (极速!)
uv pip install numpy
uv pip install pandas matplotlib scipy
uv pip install -r requirements.txt

# 列出已安装包
uv pip list

# 冻结依赖
uv pip freeze > requirements.txt

# 卸载包
uv pip uninstall numpy

# 项目管理 (类似 npm/cargo)
uv init myproject
cd myproject
uv add requests numpy          # 添加依赖
uv remove requests             # 移除依赖
uv run python main.py          # 运行脚本
uv run pytest                  # 运行测试

# 锁定依赖
uv lock

# 同步依赖
uv sync
```

#### poetry 命令

```bash
# 创建新项目
poetry new myproject
cd myproject

# 初始化现有项目
poetry init

# 添加依赖
poetry add requests
poetry add pytest --group dev  # 开发依赖

# 安装依赖
poetry install

# 更新依赖
poetry update
poetry update requests         # 更新特定包

# 移除依赖
poetry remove requests

# 运行脚本
poetry run python main.py
poetry run pytest

# 进入虚拟环境
poetry shell

# 导出依赖
poetry export -f requirements.txt --output requirements.txt
```

#### pyenv 命令

```bash
# 列出可安装版本
pyenv install --list

# 安装 Python 版本
pyenv install 3.11.7
pyenv install 3.12.1

# 列出已安装版本
pyenv versions

# 设置全局版本
pyenv global 3.12.1

# 设置本地版本 (当前目录)
pyenv local 3.11.7

# 设置 shell 版本 (当前会话)
pyenv shell 3.10.5

# 卸载版本
pyenv uninstall 3.11.7

# 更新 pyenv
cd ~/.pyenv && git pull
```

---

### Julia

#### 包管理 (Pkg)

```julia
# 进入包管理模式 (REPL 中按 ])
]

# 添加包
add Plots
add DataFrames@1.4  # 指定版本

# 更新包
update
update Plots

# 移除包
remove Plots

# 列出已安装包
status

# 固定包版本 (防止更新)
pin Plots@1.6.0

# 解除固定
free Plots

# 环境管理
activate .                    # 激活当前目录环境
activate @myenv               # 激活命名环境
instantiate                   # 从 Project.toml 安装依赖
```

#### 运行与测试

```bash
# 运行 Julia 脚本
julia script.jl

# 多线程运行
julia -t 8 script.jl          # 8 个线程

# 运行测试
julia -e 'using Pkg; Pkg.test("MyPackage")'
```

---

### Ruby (gem/bundler/rbenv)

#### Gem 包管理

```bash
# 搜索 Gem
gem search <gem-name>

# 安装 Gem
gem install rails
gem install nokogiri -v 1.13.0  # 指定版本

# 列出已安装 Gem
gem list

# 更新 Gem
gem update
gem update rails

# 卸载 Gem
gem uninstall rails

# 清理旧版本
gem cleanup
```

#### Bundler 依赖管理

```bash
# 初始化 Gemfile
bundle init

# 安装依赖
bundle install

# 添加 Gem (手动编辑 Gemfile 后)
bundle add rails
bundle add rspec --group development

# 更新依赖
bundle update
bundle update rails

# 执行命令在 bundle 环境中
bundle exec rails server
bundle exec rspec

# 查看依赖树
bundle viz

# 检查安全漏洞
bundle audit
```

#### rbenv 版本管理

```bash
# 列出可安装版本
rbenv install --list

# 安装 Ruby 版本
rbenv install 3.3.0

# 列出已安装版本
rbenv versions

# 设置全局版本
rbenv global 3.3.0

# 设置本地版本
rbenv local 3.2.2

# 重新生成 shims
rbenv rehash

# 查看当前版本
rbenv version
```

---

## 版本管理器

### Homebrew

```bash
# 搜索包
brew search <package>
brew search python

# 安装包
brew install <package>
brew install neovim ripgrep bat

# 列出已安装包
brew list

# 查看包信息
brew info <package>

# 更新 Homebrew 和所有包
brew update                   # 更新 Homebrew 本身和仓库列表
brew upgrade                  # 升级所有已安装的包
brew upgrade <package>        # 升级特定包

# 卸载包
brew uninstall <package>

# 清理旧版本
brew cleanup                  # 清理所有旧版本
brew cleanup <package>        # 清理特定包的旧版本

# 查看过期包
brew outdated

# 固定版本 (防止自动更新)
brew pin <package>
brew unpin <package>

# 查看服务
brew services list
brew services start <service>
brew services stop <service>

# 诊断问题
brew doctor
brew config
```

---

### Nix

```bash
# 搜索包
nix search nixpkgs <package>
nix search nixpkgs python

# 临时使用 (不安装)
nix-shell -p <package>
nix-shell -p python3 nodejs

# 安装包到用户环境
nix-env -iA nixpkgs.<package>
nix-env -iA nixpkgs.ripgrep
nix-env -iA nixpkgs.neovim

# 列出已安装包
nix-env -q

# 查看包信息
nix-env -qa <package>

# 更新所有包
nix-env -u

# 卸载包
nix-env -e <package>

# 垃圾回收
nix-collect-garbage
nix-collect-garbage -d        # 删除所有旧生成

# 列出生成历史
nix-env --list-generations

# 回滚到上一个生成
nix-env --rollback

# 切换到特定生成
nix-env --switch-generation <generation-number>

# 删除旧生成
nix-env --delete-generations old
nix-env --delete-generations 10 11 12

# 使用 Flakes (现代化)
nix run nixpkgs#hello          # 运行包
nix shell nixpkgs#python3      # 临时 shell
nix develop                    # 进入开发环境 (需要 flake.nix)

# 查看 Nix store 使用情况
nix path-info --size --closure-size <store-path>
nix-store --gc                 # 垃圾回收

# 优化 store
nix-store --optimise

# 修复 store
nix-store --verify --check-contents
```

---

### NVM (Node.js)

```bash
# 列出远程可用版本
nvm ls-remote
nvm ls-remote --lts            # 仅 LTS 版本

# 安装 Node.js
nvm install node               # 最新版本
nvm install --lts              # 最新 LTS
nvm install 20                 # 安装 v20.x
nvm install 20.10.0            # 指定版本

# 列出已安装版本
nvm list
nvm ls

# 切换版本
nvm use 20
nvm use --lts
nvm use system                 # 使用系统 Node.js

# 设置默认版本
nvm alias default 20
nvm alias default node

# 卸载版本
nvm uninstall 18

# 查看当前版本
nvm current

# 运行特定版本
nvm run 20 app.js
nvm exec 20 node app.js
```

---

### Conda/Mamba

```bash
# 创建环境
conda create -n myenv python=3.11
mamba create -n myenv python=3.11 numpy pandas  # 使用 mamba 更快

# 激活环境
conda activate myenv

# 退出环境
conda deactivate

# 列出环境
conda env list
conda info --envs

# 删除环境
conda env remove -n myenv

# 安装包
conda install numpy
mamba install pytorch torchvision  # 使用 mamba 更快

# 更新包
conda update numpy
conda update --all                  # 更新所有包

# 搜索包
conda search pytorch

# 列出已安装包
conda list

# 导出环境
conda env export > environment.yml
conda list --export > requirements.txt

# 从文件创建环境
conda env create -f environment.yml
conda create -n myenv --file requirements.txt

# 克隆环境
conda create -n newenv --clone myenv

# 清理缓存
conda clean --all
```

---

## 构建工具

### CMake

```bash
# 配置项目
cmake -B build                  # 生成构建文件到 build 目录
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake -B build -G Ninja         # 使用 Ninja 生成器

# 构建项目
cmake --build build
cmake --build build --config Release
cmake --build build -j 8        # 8 个并行任务

# 安装
cmake --install build
cmake --install build --prefix /usr/local

# 测试
cd build && ctest
ctest --output-on-failure

# 清理
cmake --build build --target clean
rm -rf build
```

### Make

```bash
# 构建
make                            # 默认目标
make all
make -j8                        # 8 个并行任务

# 清理
make clean

# 安装
sudo make install

# 卸载
sudo make uninstall

# 查看变量
make -p

# 干运行 (显示命令但不执行)
make -n
```

---

## 📚 相关文档

- [Fedora 开发环境配置](DEV_ENV_FEDORA.md)
- [Ubuntu 开发环境配置](DEV_ENV_UBUNTU.md)
- [环境变量配置指南](ENV_VARS.md)
- [主配置说明](../README.md)

---

## 💡 提示

> [!TIP]
> **快速查找命令**
>
> - 使用 `Ctrl+F` 在浏览器中搜索关键词
> - 大多数工具支持 `<command> --help` 查看帮助
> - 使用 `man <command>` 查看完整手册页

> [!NOTE]
> **命令别名**
>
> - 许多工具支持简写,如 `dnf` 的 `in` (install)、`rm` (remove)
> - 可在 shell 配置文件中创建自定义别名,如 `alias gst='git status'`

---

**⭐ 如果本速查表对你有帮助,请给仓库一个 Star!**
