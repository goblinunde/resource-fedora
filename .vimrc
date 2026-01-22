" =============================================================================
" Yyt's Ultimate Vim Configuration (Cross-Platform v4.0)
" =============================================================================
" 作者: SMLYFM <yytcjx@gmail.com>
" 更新: 跨平台适配 + 增强文件模板系统
" 支持: Windows, Linux (Fedora/Ubuntu/Arch), macOS
" =============================================================================

" [跨平台检测] 根据操作系统设置配置目录
if has('win32') || has('win64')
    let g:vim_home_path = '~/vimfiles'  " Windows
    let g:os_type = 'windows'
elseif has('unix')
    if system('uname -s') =~ 'Darwin'
        let g:vim_home_path = '~/.vim'  " macOS
        let g:os_type = 'mac'
    else
        let g:vim_home_path = '~/.vim'  " Linux
        let g:os_type = 'linux'
    endif
else
    let g:vim_home_path = '~/.vim'      " 默认 Unix-like
    let g:os_type = 'unix'
endif

" [自动安装 vim-plug] 跨平台安装插件管理器
let s:plug_file = expand(g:vim_home_path . '/autoload/plug.vim')
if empty(glob(s:plug_file))
    " 根据系统选择下载工具
    if g:os_type == 'windows'
        silent execute '!curl -fLo ' . s:plug_file . ' --create-dirs ' .
            \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    else
        silent execute '!curl -fLo ' . s:plug_file . ' --create-dirs ' .
            \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    endif
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" =============================================================================
" 1. 插件管理 (vim-plug)
" =============================================================================
call plug#begin(g:vim_home_path . '/plugged')

" --- UI & 界面美化 ---
Plug 'gruvbox-community/gruvbox'        " 🎨 Gruvbox 主题 (复古暖色调)
Plug 'vim-airline/vim-airline'          " ✈️ 底部状态栏 (显示模式、Git分支等)
Plug 'vim-airline/vim-airline-themes'   " ✈️ 状态栏配套主题
Plug 'ryanoasis/vim-devicons'           " 💎 文件图标 (必须安装 Nerd Fonts 字体)
Plug 'mhinz/vim-startify'               " 🚀 启动界面 (显示最近打开的文件)
Plug 'airblade/vim-gitgutter'           " 📝 Git 侧边栏 (实时显示增删改状态)
Plug 'Yggdroot/indentLine'              " ┆  缩进对齐线 (看缩进层级很方便)
Plug 'luochen1990/rainbow'              " 🌈 彩虹括号 (不同层级括号不同颜色)

" --- 核心增强工具 ---
Plug 'preservim/nerdtree'               " 🌳 左侧文件资源管理器
Plug 'Xuyuanp/nerdtree-git-plugin'      " 🌳 NERDTree 的 Git 状态显示
Plug 'junegunn/fzf.vim'                 " 🔍 模糊搜索插件 (调用 fzf)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " 🔍 fzf 核心二进制文件
Plug 'preservim/nerdcommenter'          " 💬 快速注释工具 (<C-/>)
Plug 'tpope/vim-surround'               " 🎁 包裹符号处理 (改引号、括号神器)
Plug 'preservim/tagbar'                 " 🏷️ 右侧代码大纲 (需要 ctags 支持)
Plug 'godlygeek/tabular'                " 📊 文本对齐工具 (如按等号对齐)
Plug 'RRethy/vim-illuminate'            " ✨ 自动高亮当前单词的所有出现位置
Plug 'jiangmiao/auto-pairs'             " 📎 自动补全成对的括号/引号

" --- 编程语言深度支持 ---
" [核心] CoC.nvim: 提供类似 VSCode 的智能补全 (LSP Client)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" [LaTeX] 只有打开 .tex 文件时才加载 vimtex (优化启动速度)
Plug 'lervag/vimtex', { 'for': 'tex' }

" [Git] 只有输入 :G 或 :Git 命令时才加载 fugitive
Plug 'tpope/vim-fugitive', { 'on': ['G', 'Git'] }

call plug#end()


" =============================================================================
" 2. 基础编辑器设置
" =============================================================================
syntax on                   " 开启语法高亮
set encoding=utf-8          " 强制使用 UTF-8 编码 (防止中文乱码)
filetype plugin indent on   " 启用文件类型检测和特定缩进

" --- 界面体验 ---
set number                  " 显示行号
set relativenumber          " 显示相对行号 (方便 j/k 跳转)
set cursorline              " 高亮当前行背景
set scrolloff=8             " 光标移动到顶部/底部时保留 8 行距离
set sidescrolloff=8         " 光标移动到左右边缘时保留 8 列距离
set splitright              " vsplit 分屏时在新窗口右侧打开
set splitbelow              " split 分屏时在新窗口下方打开
set noshowmode              " 底部不显示 --INSERT-- (Airline 已经显示了)
set signcolumn=yes          " 强制显示左侧符号栏 (防止 GitGutter 导致屏幕抖动)
set updatetime=100          " 缩短更新时间 (让 Git 状态和高亮反应更快)
set shortmess+=c            " 减少补全菜单底部的啰嗦信息
set hidden                  " 允许在未保存时切换 Buffer (非常重要)

" --- 缩进与排版 (默认 4 空格) ---
set tabstop=4               " Tab 键显示的宽度
set shiftwidth=4            " 自动缩进的宽度
set softtabstop=4           " 编辑模式下 Tab 的宽度
set expandtab               " 自动将 Tab 转为空格 (Python 必备)
set autoindent              " 换行时继承上一行的缩进
set cindent                 " 针对 C 语言风格的智能缩进
set nowrap                  " 禁止自动换行 (代码过长则横向滚动)

" --- 搜索设置 ---
set hlsearch                " 高亮搜索结果
set incsearch               " 边输入边搜索 (实时预览)
set ignorecase              " 搜索时忽略大小写
set smartcase               " 智能大小写 (如果输入了大写字母则开启敏感模式)

" --- 系统行为 ---
set autoread                " 文件在外部被修改时自动重新加载
set undofile                " 开启持久化撤销 (重启 Vim 后还能撤销)
" 跨平台剪贴板设置
if g:os_type == 'linux' || g:os_type == 'mac'
    set clipboard=unnamedplus   " Linux/macOS: 使用 + 寄存器
else
    set clipboard=unnamed       " Windows: 使用 * 寄存器
endif
let mapleader = " "             " 设置空格键 <Space> 为 Leader 键

" [快捷键] 窗口切换 (Ctrl + h/j/k/l)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" [快捷键] 快速取消高亮 (<Leader> + nh)
nnoremap <leader>nh :nohlsearch<CR>


" =============================================================================
" 3. 主题与 UI 细节配置
" =============================================================================
if (has("termguicolors"))
    set termguicolors       " 开启真彩色支持
endif
set background=dark         " 设置为深色背景
try
    colorscheme gruvbox     " 应用 Gruvbox 主题
catch
    " 防止首次安装还没下载主题时报错
endtry

" Gruvbox 增强设置
let g:gruvbox_contrast_dark = 'hard'  " 背景对比度: soft, medium, hard

" Airline 状态栏设置
let g:airline_theme = 'gruvbox'
let g:airline_powerline_fonts = 1           " 开启 Powerline 三角形图标
let g:airline#extensions#tabline#enabled = 1 " 顶部显示打开的 Buffer 列表
let g:airline#extensions#coc#enabled = 1     " 集成 CoC 状态显示

" 彩虹括号与缩进线
let g:rainbow_active = 1
let g:indentLine_char = '¦'
let g:indentLine_enabled = 1


" =============================================================================
" 4. 插件增强配置
" =============================================================================

" --- FZF + Ripgrep (极速搜索) ---
if executable('rg')
  " 使用 ripgrep 作为 FZF 的默认搜索引擎 (忽略 .git 和隐藏文件)
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
endif
nnoremap <C-p> :FZF<CR>       " Ctrl+P 搜索文件名
nnoremap <leader>s :Rg<CR>    " Space+s 全局搜索文件内容

" --- NERDTree (文件树) ---
nnoremap <leader>n :NERDTreeToggle<CR>  " Space+n 开关文件树
" 启动时如果没指定文件，自动打开 NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeShowHidden = 1            " 显示隐藏文件

" --- Tagbar (代码大纲) ---
nnoremap <leader>t :TagbarToggle<CR>    " Space+t 开关大纲
let g:tagbar_width = 30

" --- NERDCommenter (注释) ---
" Ctrl + / 进行注释/反注释 (注意: 某些终端 Ctrl+/ 发送的是 Ctrl+_)
nmap <C-/> <Plug>NERDCommenterToggle
vmap <C-/> <Plug>NERDCommenterToggle

" --- VimTex (LaTeX) ---
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'general'    " Windows 通用预览设置
let g:vimtex_quickfix_mode = 0          " 禁用自动弹出的 Quickfix 窗口


" =============================================================================
" 5. CoC.nvim 深度配置 (LSP 核心)
" =============================================================================

" [核心] 自动安装的扩展列表 (包含了你需要的 C/C++, Rust, Python, Latex)
let g:coc_global_extensions = [
    \ 'coc-json',
    \ 'coc-vimlsp',
    \ 'coc-sh',
    \ 'coc-snippets',
    \ 'coc-pyright',
    \ 'coc-rust-analyzer',
    \ 'coc-texlab',
    \ 'coc-clangd',
    \ 'coc-cmake'
    \ ]

" (1) Tab 键智能逻辑: 选择补全项 OR 跳转 Snippet OR 插入 Tab
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" (2) 回车键: 确认补全
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" (3) 跳转与查看
nmap <silent> gd <Plug>(coc-definition)      " 跳转定义
nmap <silent> gy <Plug>(coc-type-definition) " 跳转类型定义
nmap <silent> gi <Plug>(coc-implementation)  " 跳转实现
nmap <silent> gr <Plug>(coc-references)      " 查看引用
nnoremap <silent> K :call <SID>show_documentation()<CR> " 查看文档悬浮窗

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" (4) 重命名与格式化
nmap <leader>rn <Plug>(coc-rename)           " 变量重命名
nmap <leader>f  <Plug>(coc-format-document)  " 格式化当前文件
nmap <leader>a  <Plug>(coc-codeaction-cursor)" 快速修复 (Quick Fix)


" =============================================================================
" 6. 自动文件模板 (新建文件时自动生成代码)
" =============================================================================
function! s:InsertTemplate()
    if line('$') == 1 && getline(1) == ''
        call append(0, b:autocmd_template)
        " 自动替换占位符
        exe 'silent! %s/__DATE__/\=strftime("%Y-%m-%d %H:%M:%S")/ge'
        exe 'silent! %s/__AUTHOR__/cjx/ge'
        exe 'silent! %s/__EMAIL__/sudocjx@gmail.com/ge'
        " 定位光标位置
        let cursor_pos = searchpos('__CURSOR__', 'nw')
        if cursor_pos[0] > 0
            exe 'silent! %s/__CURSOR__//ge'
            call setpos('.', [0, cursor_pos[0], cursor_pos[1], 0])
        endif
    endif
endfunction

augroup MyFileTemplates
    autocmd!
    
    " --- Python 模板 ---
    autocmd BufNewFile *.py let b:autocmd_template = [
                \ '#!/usr/bin/env python3',
                \ '# -*- coding: utf-8 -*-',
                \ '"""',
                \ '@author: __AUTHOR__',
                \ '@email:  __EMAIL__',
                \ '@created: __DATE__',
                \ '"""',
                \ '',
                \ 'def main():',
                \ '    print("Hello, Python!")',
                \ '',
                \ 'if __name__ == "__main__":',
                \ '    main()',
                \ '    __CURSOR__',
                \ ]
    autocmd BufNewFile *.py call <SID>InsertTemplate()

    " --- Rust 模板 ---
    autocmd BufNewFile *.rs let b:autocmd_template = [
                \ '//! @author: __AUTHOR__',
                \ '//! @created: __DATE__',
                \ '',
                \ 'fn main() {',
                \ '    println!("Hello, Rust!");',
                \ '    __CURSOR__',
                \ '}',
                \ ]
    autocmd BufNewFile *.rs call <SID>InsertTemplate()
    
    " --- LaTeX 模板 ---
    autocmd BufNewFile *.tex let b:autocmd_template = [
                \ '% @author: __AUTHOR__',
                \ '\documentclass[a4paper,12pt]{article}',
                \ '\usepackage{amsmath}',
                \ '\begin{document}',
                \ 'Hello, TeX!',
                \ '__CURSOR__',
                \ '\end{document}',
                \ ]
    autocmd BufNewFile *.tex call <SID>InsertTemplate()

    " --- C 语言模板 (已补全) ---
    autocmd BufNewFile *.[ch] let b:autocmd_template = [
                \ '/*************************************************************************',
                \ ' * @author: __AUTHOR__',
                \ ' * @email:  __EMAIL__',
                \ ' * @created: __DATE__',
                \ ' ************************************************************************/',
                \ '',
                \ '#include <stdio.h>',
                \ '',
                \ 'int main(int argc, char* argv[]) {',
                \ '    printf("Hello, C!\\n");',
                \ '    __CURSOR__',
                \ '    return 0;',
                \ '}',
                \ ]
    autocmd BufNewFile *.[ch] call <SID>InsertTemplate()

    " --- C++ 模板 (已补全) ---
    autocmd BufNewFile *.cpp,*.cxx,*.cc,*.hpp let b:autocmd_template = [
                \ '/*************************************************************************',
                \ ' * @author: __AUTHOR__',
                \ ' * @email:  __EMAIL__',
                \ ' * @created: __DATE__',
                \ ' ************************************************************************/',
                \ '',
                \ '#include <iostream>',
                \ '',
                \ 'int main(int argc, char* argv[]) {',
                \ '    std::cout << "Hello, C++!" << std::endl;',
                \ '    __CURSOR__',
                \ '    return 0;',
                \ '}',
                \ ]
    autocmd BufNewFile *.cpp,*.cxx,*.cc,*.hpp call <SID>InsertTemplate()

    " --- CMake 模板 (已补全) ---
    autocmd BufNewFile CMakeLists.txt let b:autocmd_template = [
                \ '# @author: __AUTHOR__',
                \ '# @created: __DATE__',
                \ '',
                \ 'cmake_minimum_required(VERSION 3.10)',
                \ '',
                \ 'project(MyProject VERSION 0.1.0)',
                \ '',
                \ '# set(CMAKE_CXX_STANDARD 17)',
                \ '',
                \ 'add_executable(my_app main.cpp)',
                \ '__CURSOR__',
                \ ]
    autocmd BufNewFile CMakeLists.txt call <SID>InsertTemplate()

    " --- Bash 脚本模板 ---
    autocmd BufNewFile *.sh let b:autocmd_template = [
                \ '#!/usr/bin/env bash',
                \ '# ============================================================================',
                \ '# @author: __AUTHOR__',
                \ '# @email:  __EMAIL__',
                \ '# @created: __DATE__',
                \ '# ============================================================================',
                \ '',
                \ 'set -euo pipefail  # 💡 严格模式：遇错即停 + 未定义变量报错',
                \ '',
                \ 'main() {',
                \ '    echo "Hello, Bash!"',
                \ '    __CURSOR__',
                \ '}',
                \ '',
                \ 'main "$@"',
                \ ]
    autocmd BufNewFile *.sh call <SID>InsertTemplate()

    " --- Markdown 文档模板 ---
    autocmd BufNewFile *.md let b:autocmd_template = [
                \ '# Title',
                \ '',
                \ '**Author**: __AUTHOR__  ',
                \ '**Created**: __DATE__',
                \ '',
                \ '## 概述',
                \ '',
                \ '__CURSOR__',
                \ '',
                \ '## 安装',
                \ '',
                \ '```bash',
                \ '# 安装命令',
                \ '```',
                \ '',
                \ '## 使用',
                \ '',
                \ '## 参考资料',
                \ ]
    autocmd BufNewFile *.md call <SID>InsertTemplate()

    " --- HTML 模板 ---
    autocmd BufNewFile *.html let b:autocmd_template = [
                \ '<!DOCTYPE html>',
                \ '<html lang="zh-CN">',
                \ '<head>',
                \ '    <meta charset="UTF-8">',
                \ '    <meta name="viewport" content="width=device-width, initial-scale=1.0">',
                \ '    <meta name="author" content="__AUTHOR__">',
                \ '    <title>Document</title>',
                \ '</head>',
                \ '<body>',
                \ '    <h1>Hello, HTML!</h1>',
                \ '    __CURSOR__',
                \ '</body>',
                \ '</html>',
                \ ]
    autocmd BufNewFile *.html call <SID>InsertTemplate()

    " --- JSON 配置模板 ---
    autocmd BufNewFile *.json let b:autocmd_template = [
                \ '{',
                \ '    "name": "project",',
                \ '    "version": "0.1.0",',
                \ '    "author": "__AUTHOR__",',
                \ '    "__CURSOR__": "value"',
                \ '}',
                \ ]
    autocmd BufNewFile *.json call <SID>InsertTemplate()

    " --- Makefile 模板 ---
    autocmd BufNewFile Makefile let b:autocmd_template = [
                \ '# @author: __AUTHOR__',
                \ '# @created: __DATE__',
                \ '',
                \ '.PHONY: all clean install test',
                \ '',
                \ 'all:',
                \ '\t@echo "Building..."',
                \ '\t__CURSOR__',
                \ '',
                \ 'clean:',
                \ '\t@echo "Cleaning..."',
                \ '\trm -rf build/',
                \ '',
                \ 'install:',
                \ '\t@echo "Installing..."',
                \ '',
                \ 'test:',
                \ '\t@echo "Testing..."',
                \ ]
    autocmd BufNewFile Makefile call <SID>InsertTemplate()
augroup END


" =============================================================================
" 7. 持久化撤销与清理
" =============================================================================
if has('persistent_undo')
    let s:undodir = expand(g:vim_home_path . '/undodir')
    if !isdirectory(s:undodir)
        call mkdir(s:undodir, 'p')
    endif
    let &undodir = s:undodir
    set undofile
endif