# Plugins (BETA)

You can extend Yazi's functionality through Lua plugins, which need to be placed in the `plugins` subdirectory of Yazi's configuration directory, so either:

- `~/.config/yazi/plugins/` on Unix-like systems.
- `%AppData%\yazi\config\plugins\` on Windows.

```text
~/.config/yazi/
├── init.lua
├── plugins/
│   ├── foo.yazi/
│   └── bar.yazi/
└── yazi.toml
```



Each plugin is a directory with a [kebab-case](https://developer.mozilla.org/en-US/docs/Glossary/Kebab_case) name, ending in `.yazi`, and containing at least the following files:

```text
~/.config/yazi/plugins/bar.yazi/
├── main.lua
├── README.md
└── LICENSE
```



Where:

- `main.lua` is the entry point of this plugin.
- `README.md` is the documentation of this plugin.
- `LICENSE` is the license file for this plugin.

## Usage

A plugin has two usages:

- [Functional plugin](https://yazi-rs.github.io/docs/plugins/overview#functional-plugin): Bind the `plugin` command to a key in `keymap.toml`, and activate it by pressing the key.
- [Custom previewers, preloaders](https://yazi-rs.github.io/docs/configuration/yazi#plugin): Configure them as previewers or preloaders under `[plugin]` of your `yazi.toml`.

### Functional plugin

You can bind a `plugin` command to a specific key in your `keymap.toml` with:

| Argument/Option | Description                                           |
| --------------- | ----------------------------------------------------- |
| `[name]`        | Required, the name of the plugin to run.              |
| `[args]`        | Optional, shell-style arguments passed to the plugin. |

For example, `plugin test -- foo --bar --baz=qux` will run the `test` plugin with the arguments `foo --bar --baz=qux` in an async context.

To access the arguments in the plugin, use `job.args`:

```lua
-- ~/.config/yazi/plugins/test.yazi/main.lua
return {
	entry = function(self, job)
		ya.dbg(job.args[1])  -- "foo"
		ya.dbg(job.args.bar) -- true
		ya.dbg(job.args.baz) -- "qux"
	end,
}
```



Note that currently Yazi only supports positional arguments (`foo`) and named arguments (`--bar`), it does not support shorthand arguments like `-a`.

Shorthands will be treated as positional arguments at the moment, but as Yazi adds support for it in the future, their behavior will change. So please avoid using them to prevent any potential conflicts.

## Sync vs Async

The plugin system is designed with an async-first philosophy. Therefore, unless specifically specified, such as the [`@sync` annotation](https://yazi-rs.github.io/docs/plugins/overview#@sync), all plugins run in an async context.

There is one exception: the user's `init.lua` is synchronous, since `init.lua` is often used to initialize plugin configurations:

```lua
-- ~/.config/yazi/init.lua
require("my-plugin"):setup {
	key1 = "value1",
	key2 = "value2",
	-- ...
}
```



```lua
-- ~/.config/yazi/plugins/my-plugin.yazi/main.lua
return {
	setup = function(state, opts)
		-- Save the user configuration to the plugin's state
		state.key1 = opts.key1
		state.key2 = opts.key2
	end,
}
```



### Sync context

The sync context accompanies the entire app lifecycle, which is active during UI rendering (UI plugins), and on executing [sync functional plugins](https://yazi-rs.github.io/docs/plugins/overview#@sync).

For better performance, the sync context is created only at the app's start and remains singular throughout. Thus, plugins running within this context share states, prompting plugin developers to use plugin-specific state persistence for their plugins to prevent global space contamination:

```lua
--- @sync entry
-- ~/.config/yazi/test.yazi/main.lua
return {
  entry = function(state)
    state.i = state.i or 0
    ya.dbg("i = " .. state.i)

    state.i = state.i + 1
  end,
}
```



Yazi initializes the `state` for each *sync* plugin before running, and it exists independently for them throughout the entire lifecycle. Do the `plugin test` three times, and you will see the log output:

```sh
i = 0
i = 1
i = 2
```



### Async context

When a plugin is executed asynchronously, an isolated async context is created for it automatically.

In this context, you can use all the async functions supported by Yazi, and it operates concurrently with the main thread, ensuring that the main thread is not blocked.

You can also obtain [a small amount](https://yazi-rs.github.io/docs/plugins/overview#sendable) of data from the sync context by calling a "sync block":

```lua
-- ~/.config/yazi/plugins/my-async-plugin.yazi/main.lua
local set_state = ya.sync(function(state, a)
	-- You can get/set the state of the plugin through `state` parameter
	-- in the `sync()` block
	state.a = a
end)

local get_state = ya.sync(function(state, b)
	-- You can access all states through the `cx`,
	-- within the `sync()` block, in an async plugin
	local h = cx.active.current.hovered
	return h and state.a .. tostring(h.url) or b
end)

return {
	entry = function()
		set_state("hello from a")
		local h = get_state("hello from b")
		-- Do some time-consuming work, such as reading file, network request, etc.
		-- It will execute concurrently with the main thread
	end,
}
```



Note that `ya.sync()` call must be at the top level:

```lua
-- Wrong !!!
local get_state
if some_condition then
	get_state = ya.sync(function(state)
		-- ...
	end)
end
```



Passing data into and returning data from a `ya.sync()` block involves cross-thread data exchange. If the data contains userdata, it causes [Ownership transfer](https://yazi-rs.github.io/docs/plugins/overview#ownership).

## Annotations

Each plugin can contain zero or more annotations that specify the behavior of the plugin during runtime.

Each annotation starts with `---`, followed by `@` and the annotation name, and ends with the annotation's value.

These annotations *must* be at the very top of the file, with no content before them, and no non-annotation content should appear between annotations.

### `@sync`

Specifies that a method in the plugin runs in a sync context instead of the default async context. Available values:

- `entry`: Run the `entry` method in a sync context.
- `peek`: Run the `peek` method in a sync context.

For example:

```lua
--- @sync entry
return {
	entry = function() end
}
```



### `@since`

Specifies the minimum Yazi version that the plugin supports.

If specified, and the user's Yazi version is lower than the specified one, an error will be triggered to prompt the user to upgrade their Yazi version, preventing the plugin from being executed accidentally:

```lua
--- @since 25.2.13
return {
	--- ...
}
```



## Interface

### Previewer

A previewer needs to return a table that implements the `peek` and `seek` methods. Both methods take a table parameter `job` and do not return any values:

```lua
local M = {}

function M:peek(job)
	-- ...
end

function M:seek(job)
	-- ...
end

return M
```



When the user presses j or k to switch between hovering files, `peek` is called, with:

| Key    | Description                                                  |
| ------ | ------------------------------------------------------------ |
| `area` | [Rect](https://yazi-rs.github.io/docs/plugins/layout#rect) of the available preview area. |
| `args` | Arguments passed to the previewer.                           |
| `file` | [File](https://yazi-rs.github.io/docs/plugins/types#file) to be previewed. |
| `skip` | Number of units to skip. The units depend on your previewer, such as lines for code and percentages for videos. |

When the user presses J or K to scroll the preview of the file, `seek` is called, with:

| Key     | Description                                                  |
| ------- | ------------------------------------------------------------ |
| `file`  | [File](https://yazi-rs.github.io/docs/plugins/types#file) being scrolled. |
| `area`  | [Rect](https://yazi-rs.github.io/docs/plugins/layout#rect) of the available preview area. |
| `units` | Number of units to scroll.                                   |

The task of `peek` is to draw in the preview area based on the values of `file` and `skip`. This process is asynchronous.

The task of `seek` is to change the value of `skip` based on user behavior and trigger `peek` again. It's synchronous, meaning you can access [the context](https://yazi-rs.github.io/docs/plugins/context).

There are some preset previewers and preloaders you can refer to: [Yazi Preset Plugins](https://github.com/sxyazi/yazi/tree/shipped/yazi-plugin/preset/plugins)

### Preloader

You need to return a table that implements the `preload` method:

```lua
local M = {}

function M:preload(job)
	-- ...
	return false, Err("some error")
end

return M
```



It receives a `job` parameter, which is a table:

| Key    | Description                                                  |
| ------ | ------------------------------------------------------------ |
| `area` | [Rect](https://yazi-rs.github.io/docs/plugins/layout#rect) of the available preview area. |
| `args` | Arguments passed to the preloader.                           |
| `file` | [File](https://yazi-rs.github.io/docs/plugins/types#file) to be preloaded. |
| `skip` | Always `0`                                                   |

And returns a `(complete, err)`:

- ```
  complete
  ```

  : Required, whether the preloading is complete, which is a boolean.

  - `true`: Marks the task as complete, and the task will not be called again.
  - `false`: Marks the task as incomplete, and the task will be retried until it's complete (returns `true`).

- `err`: Optional, the error to be logged.

When `complete = false`, the preloader will be re-triggered at the next time point, such as when the user scrolls leading to a page switch. This is usually done for either:

- Retrying in case of file loading failure
- Refreshing the file status upon successful loading

Yazi will automatically invoke the `preload` concurrently for each file that matches the preload rules on the page.

## Sendable value

Yazi's plugin can run concurrently on multiple threads. For better performance, only the following types of combinations can be used for inter-thread data exchange:

- Nil
- Boolean
- Number
- String
- [Url](https://yazi-rs.github.io/docs/plugins/types#url)
- Table and nested tables, with the above types as values

## Ownership transfer

Yazi's plugin system inherits [Rust's ownership and lifetime](https://doc.rust-lang.org/nomicon/ownership.html) concepts.

All [userdata](https://www.lua.org/pil/28.1.html) are native Rust types that have their own ownership to ensure safe and efficient transfers across different threads, avoiding any memory reallocation overhead. Specifically:

- [Url](https://yazi-rs.github.io/docs/plugins/types#url)

Passing these userdata to a cross-thread function like [`ya.emit()`](https://yazi-rs.github.io/docs/plugins/utils#ya.emit) transfers ownership. After transfer, the original userdata is no longer available, for example:

```lua
local target = Url("/tmp")
ya.emit("cd", { target })  -- Ownership transferred

ya.dbg(tostring(url)) -- Error: userdata has been destructed
```



To keep the original, clone a new userdata and pass that instead, but this allocates extra memory - `Url()` constructor can accept a `Url` userdata and return a new clone of that `Url`:

```diff
- ya.emit("cd", { target })
+ ya.emit("cd", { Url(target) })
```



A smarter way is to reverse the order of execution, use the `target` before it's transferred, to avoid the need for cloning:

```lua
local target = Url("/tmp")
local target_str = tostring(target)

ya.emit("cd", { target })  -- Ownership transferred
ya.dbg(target_str) -- No error
```



## Debugging

Please ensure that your `~/.config/yazi/init.lua` includes valid Lua code with the correct syntax, otherwise will result in Yazi being unable to parse and execute your `init.lua` to initialize.

We recommend installing a Lua plugin in your editor for syntax checking to avoid any syntax errors. For example, install the [Lua plugin](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) for VSCode, and for Neovim, use [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) to configure your Lua LSP.

If you have no experience with Lua, you can quickly get started through https://learnxinyminutes.com/docs/lua/

### Logging

If you want to debug some runtime data, use [`ya.dbg()`](https://yazi-rs.github.io/docs/plugins/utils#ya.dbg) and [`ya.err()`](https://yazi-rs.github.io/docs/plugins/utils#ya.err) to print what you want to debug to either:

- `~/.local/state/yazi/yazi.log` on Unix-like systems.
- `%AppData%\yazi\state\yazi.log` on Windows.

Make sure to set the `YAZI_LOG` environment variable before starting Yazi:

- Unix-like
- PowerShell

```sh
YAZI_LOG=debug yazi
```



otherwise, no logs will be recorded. Its value can be (in descending order of verbosity):

- `debug`
- `info`
- `warn`
- `error`

### Debugging preset plugins

1. Clone the latest source code.
2. Go to the `yazi-plugin/preset` folder and find the plugin you want to debug, make changes, such as [logging certain runtime data](https://yazi-rs.github.io/docs/plugins/overview#logging).
3. [Build in debug mode](https://yazi-rs.github.io/docs/installation#debug) and run the `yazi` binary with an appropriate `YAZI_LOG`.



# plugin

General: 常规：

- [piper.yazi](https://github.com/yazi-rs/plugins/tree/main/piper.yazi) - Pipe any shell command as a previewer.
  [piper.yazi](https://github.com/yazi-rs/plugins/tree/main/piper.yazi) - 作为预览器对任意 shell 命令进行管道传输。
- [mux.yazi](https://github.com/peterfication/mux.yazi) - Plugin multiplexer. Define and cycle through previewers for the same file.
  [mux.yazi](https://github.com/peterfication/mux.yazi) - 插件复用器。定义并循环使用同一个文件的预览器。

Media: 媒体：

- [exifaudio.yazi](https://github.com/Sonico98/exifaudio.yazi) - Preview audio metadata and cover using [exiftool](https://exiftool.org/).
  [exifaudio.yazi](https://github.com/Sonico98/exifaudio.yazi) - 使用 [exiftool](https://exiftool.org/) 预览音频元数据和封面。
- [mediainfo.yazi](https://github.com/boydaihungst/mediainfo.yazi) - Preview image, audio, video, subtitle and many media files using `ffmpeg` and `mediainfo`.
  [mediainfo.yazi](https://github.com/boydaihungst/mediainfo.yazi) - 使用 `ffmpeg` 和 `mediainfo` 预览图片、音频、视频、字幕及多种媒体文件。

Archives: 档案：

- [ouch.yazi](https://github.com/ndtoan96/ouch.yazi) - An [ouch](https://github.com/ouch-org/ouch) plugin for Yazi, supporting preview and compression.
  [ouch.yazi](https://github.com/ndtoan96/ouch.yazi) - Yazi 的 [ouch](https://github.com/ouch-org/ouch) 插件，支持预览和压缩。
- [zless-preview.yazi](https://github.com/vmikk/zless-preview.yazi) - Preview compressed text files using `zless`.
  [zless-preview.yazi](https://github.com/vmikk/zless-preview.yazi) - 使用 `zless` 预览压缩文本文件。
- [comicthumb.yazi](https://github.com/navysky12/comicthumb.yazi) - Preview for comicbook archive files using p7zip on Linux.
  [comicthumb.yazi](https://github.com/navysky12/comicthumb.yazi) - 在 Linux 上使用 p7zip 预览漫画档案文件。

Documents: 文件：

- [djvu-view.yazi](https://github.com/Shallow-Seek/djvu-view.yazi) - Preview Djvu using `ddjvu` from [djvulibre](https://github.com/DjvuNet/DjVuLibre)

Data Files: 数据文件：

- [duckdb.yazi](https://github.com/wylie102/duckdb.yazi) - Preview CSV/TSV, JSON, and Parquet files using [duckdb](https://github.com/duckdb/duckdb). View the raw data, or a summarized view with data-types, min, max, avg etc. for all columns.
  [duckdb.yazi](https://github.com/wylie102/duckdb.yazi) - 使用 [duckdb](https://github.com/duckdb/duckdb) 预览 CSV/TSV、JSON 和 Parquet 文件。查看原始数据，或包含所有列数据类型、最小值、最大值、平均值等的汇总视图。

BitTorrent: BitTorrent：

- [torrent-preview.yazi](https://github.com/kirasok/torrent-preview.yazi) - Preview "*.torrent" files using [transmission-cli](https://github.com/transmission/transmission).
  [torrent-preview.yazi](https://github.com/kirasok/torrent-preview.yazi) - 使用 [transmission-cli](https://github.com/transmission/transmission) 预览“*.torrent”文件。

Jupyter notebooks: Jupyter 笔记本：

- [nbpreview.yazi](https://github.com/AnirudhG07/nbpreview.yazi) - Preview jupyter notebooks(*.ipynb) files using [nbpreview](https://github.com/paw-lu/nbpreview).
  [nbpreview.yazi](https://github.com/AnirudhG07/nbpreview.yazi) - 使用 [nbpreview](https://github.com/paw-lu/nbpreview) 预览 jupyter notebooks（*.ipynb） 文件。

Misc: 其他：

- [rich-preview.yazi](https://github.com/AnirudhG07/rich-preview.yazi) - Preview Markdown, JSON, CSV, etc. using [rich-cli](https://github.com/textualize/rich-cli)
  [rich-preview.yazi](https://github.com/AnirudhG07/rich-preview.yazi) - 使用 [rich-CLI](https://github.com/textualize/rich-cli) 预览 Markdown、JSON、CSV 等

## 🧩 Functional plugins 🧩 功能插件

Jumping: 跳跃：

- [relative-motions.yazi](https://github.com/dedukun/relative-motions.yazi) - A Yazi plugin based about vim motions.
  [relative-motions.yazi](https://github.com/dedukun/relative-motions.yazi) - 基于 vim 动作的 Yazi 插件。
- [jump-to-char.yazi](https://github.com/yazi-rs/plugins/tree/main/jump-to-char.yazi) - Vim-like `f<char>`, jump to the next file whose name starts with `<char>`.
  [jump-to-char.yazi](https://github.com/yazi-rs/plugins/tree/main/jump-to-char.yazi) - 类似 `Vim 的 f<char>`，跳转到名字以 `<char>` 开头的文件。
- [time-travel.yazi](https://github.com/iynaix/time-travel.yazi) - Browse forwards and backwards in time via BTRFS / ZFS snapshots.
  [time-travel.yazi](https://github.com/iynaix/time-travel.yazi) - 通过 BTRFS / ZFS 快照，向前和向后浏览时间。
- [cdhist.yazi](https://github.com/bulletmark/cdhist.yazi) - Use cdhist to fuzzy select and navigate within Yazi from your directory history.
  [cdhist.yazi](https://github.com/bulletmark/cdhist.yazi) - 使用 cdhist 在 Yazi 中模糊选择并导航目录历史。
- [cd-git-root.yazi](https://github.com/ciarandg/cd-git-root.yazi) - Changes directory to the root of the git repository you are currently in.
  [cd-git-root.yazi](https://github.com/ciarandg/cd-git-root.yazi) - 将目录更改为你当前所在 git 仓库的根节点。
- [fazif.yazi](https://github.com/Shallow-Seek/fazif.yazi) - Search over selected item with `fd`, `rg` `rga` and spawn any FZF configurations in Yazi.
  [fazif.yazi](https://github.com/Shallow-Seek/fazif.yazi) - 用 `fd`、`rg``rga` 搜索选中的物品，并在 Yazi 中生成任何 FZF 配置。
- [yafg.yazi](https://github.com/XYenon/yafg.yazi) - Fuzzy find and grep in Yazi with ripgrep and fzf, opening selected matches in your editor at the matched line.
  [yafg.yazi](https://github.com/XYenon/yafg.yazi) - 模糊地在 Yazi 中用 ripgrep 和 fzf 查找并 grep，在编辑器匹配行处打开选定匹配。

Bookmarks: 书签：

- [bookmarks.yazi](https://github.com/dedukun/bookmarks.yazi) - A Yazi plugin that adds the basic functionality of Vi-like marks.
  [bookmarks.yazi](https://github.com/dedukun/bookmarks.yazi) - 一个 Yazi 插件，增加了类似 Vi 标记的基本功能。
- [mactag.yazi](https://github.com/yazi-rs/plugins/tree/main/mactag.yazi) - Bring macOS's awesome tagging feature to Yazi! The plugin is only available for macOS just like the name says.
  [mactag.yazi](https://github.com/yazi-rs/plugins/tree/main/mactag.yazi) - 把 macOS 超棒的标签功能带到 Yazi！这个插件顾名思义只支持 macOS。
- [simple-tag.yazi](https://github.com/boydaihungst/simple-tag.yazi) - Tagging feature for Linux, macOS and Windows!
  [simple-tag.yazi](https://github.com/boydaihungst/simple-tag.yazi) - 适用于 Linux、macOS 和 Windows 的标签功能！
- [yamb.yazi](https://github.com/h-hg/yamb.yazi) - Yet another bookmarks plugins. It supports persistence, jumping by a key, jumping by [fzf](https://github.com/junegunn/fzf).
  [yamb.yazi](https://github.com/h-hg/yamb.yazi)——又一个书签插件。它支持持久化，通过键跳跃，通过 [fzf](https://github.com/junegunn/fzf) 跳转。
- [bunny.yazi](https://github.com/stelcodes/bunny.yazi) - Bookmarks menu with both persistent and ephemeral bookmarks, fuzzy searching, going back to previous directory, and changing to a directory open in another tab.
  bunny.yazi - 书签菜单，包含持久和临时书签，模糊搜索，返回之前的目录，并在另一个标签页中切换到打开的目录。
- [whoosh.yazi](https://gitlab.com/WhoSowSee/whoosh.yazi) - Advanced bookmark manager with persistent/temporary bookmarks, directory history, fzf integration, path truncation, and cross-platform support. Jump between locations instantly with keys or fuzzy search.
  whoosh.yazi - 高级书签管理器，支持持久/临时书签、目录历史、FZF 集成、路径截断和跨平台支持。用快捷键或模糊搜索瞬间切换地点。

Tabs: 标签：

- [projects.yazi](https://github.com/MasouShizuka/projects.yazi) - Save all tabs and their states as a project, and restore them at any time.
  [projects.yazi](https://github.com/MasouShizuka/projects.yazi) - 将所有标签及其状态保存为一个项目，并随时恢复。
- [close-and-restore-tab.yazi](https://github.com/MasouShizuka/close-and-restore-tab.yazi) - Restore closed tabs.
  [关闭并恢复 tab.yazi](https://github.com/MasouShizuka/close-and-restore-tab.yazi) - 恢复关闭标签页。

File actions: 文件作：

- [chmod.yazi](https://github.com/yazi-rs/plugins/tree/main/chmod.yazi) - Execute `chmod` on the selected files to change their mode.
  [chmod.yazi](https://github.com/yazi-rs/plugins/tree/main/chmod.yazi) - 对所选文件执行 `chmod` 以更改其模式。
- [diff.yazi](https://github.com/yazi-rs/plugins/tree/main/diff.yazi) - Diff the selected file with the hovered file, create a living patch, and copy it to the clipboard.
  [diff.yazi](https://github.com/yazi-rs/plugins/tree/main/diff.yazi) - 用悬停文件对所选文件进行 diff，创建一个活音色，然后复制到剪贴板。
- [compress.yazi](https://github.com/KKV9/compress.yazi) - A Yazi plugin that compresses selected files to an archive.
  [compress.yazi](https://github.com/KKV9/compress.yazi) - 一个将选定文件压缩为归档的 Yazi 插件。
- [ouch.yazi](https://github.com/ndtoan96/ouch.yazi) - An [ouch](https://github.com/ouch-org/ouch) plugin for Yazi, supporting preview and compression.
  [ouch.yazi](https://github.com/ndtoan96/ouch.yazi) - Yazi 的 [ouch](https://github.com/ouch-org/ouch) 插件，支持预览和压缩。
- [archivemount.yazi](https://github.com/AnirudhG07/archivemount.yazi) - Mounting and unmounting archives in yazi using [archivemount](https://github.com/cybernoid/archivemount).
  [archivemount.yazi](https://github.com/AnirudhG07/archivemount.yazi) - 使用 [archivemount](https://github.com/cybernoid/archivemount) 在 yazi 中挂载和卸载档案。
- [reflink.yazi](https://github.com/Ape/reflink.yazi) - Create reflinks to files.
  [reflink.yazi](https://github.com/Ape/reflink.yazi) - 创建文件的 reflink。
- [rsync.yazi](https://github.com/GianniBYoung/rsync.yazi) - Simple rsync copying locally and to remote servers.
  [rsync.yazi](https://github.com/GianniBYoung/rsync.yazi) - 简单的 rsync 本地和远程服务器复制。
- [sshfs.yazi](https://github.com/uhs-robert/sshfs.yazi) - Mount and manage remote directories over SSH using SSHFS. Supports hosts from `~/.ssh/config` or custom-defined connections. Includes key/password auth.
  [sshfs.yazi](https://github.com/uhs-robert/sshfs.yazi) - 使用 SSHFS 通过 SSH 挂载和管理远程目录。支持来自 `~/.ssh/config` 或自定义连接的主机。包含密钥/密码认证。
- [what-size.yazi](https://github.com/pirafrank/what-size.yazi) - Calculate total size of current selection or of current working directory.
  [what-size.yazi](https://github.com/pirafrank/what-size.yazi) - 计算当前选择或当前工作目录的总大小。
- [lazygit.yazi](https://github.com/Lil-Dank/lazygit.yazi) - Manage Git directories with [lazygit](https://github.com/jesseduffield/lazygit) with a quick shortcut.
  [lazygit.yazi](https://github.com/Lil-Dank/lazygit.yazi) - 用 [lazygit](https://github.com/jesseduffield/lazygit) 快速管理 Git 目录。
- [open-git-remote.yazi](https://github.com/larry-oates/open-git-remote.yazi) - Shortcut to open a git remote's webpage for the current yazi directory
  [open-git-remote.yazi](https://github.com/larry-oates/open-git-remote.yazi) - 打开当前 yazi 目录 git remote 网页的快捷方式
- [sudo.yazi](https://github.com/TD-Sky/sudo.yazi) - Execute specific file operations with `sudo` privileges.
  [sudo.yazi](https://github.com/TD-Sky/sudo.yazi) - 执行带有 `sudo` 权限的特定文件作。
- [restore.yazi](https://github.com/boydaihungst/restore.yazi) - Restore/recover latest deleted files/folders using `trash-cli`.
  [restore.yazi](https://github.com/boydaihungst/restore.yazi) - 使用 `trash-cli` 恢复/恢复最新删除的文件/文件夹。
- [recycle-bin.yazi](https://github.com/uhs-robert/recycle-bin.yazi) - Manage your Trash from Yazi: browse contents, restore or delete selected items, empty by age, or empty completely using `trash-cli`.
  [recycle-bin.yazi](https://github.com/uhs-robert/recycle-bin.yazi) - 通过 Yazi 管理你的垃圾桶：浏览内容、恢复或删除选定物品、按年龄清空，或使用 `trash-cli` 完全清空。
- [gvfs.yazi](https://github.com/boydaihungst/gvfs.yazi) - Mount and manage MTP, GPhoto2 (PTP) devices (Android, Cameras, etc), SMB, SFTP, NFS, FTP, Google Drive, DNS-SD, DAV (WebDAV), AFP, AFC (Linux only). List of [supported protocals](https://wiki.gnome.org/Projects(2f)gvfs(2f)schemes.html).
  [gvfs.yazi](https://github.com/boydaihungst/gvfs.yazi) - 挂载和管理 MTP、GPhoto2（PTP）设备（Android、摄像头等）、SMB、SFTP、NFS、FTP、Google Drive、DNS-SD、DAV（WebDAV）、AFP、AFC（仅限 Linux）。[ 支持的原语言](https://wiki.gnome.org/Projects(2f)gvfs(2f)schemes.html)列表。
- [kdeconnect-send.yazi](https://github.com/Deepak22903/kdeconnect-send.yazi) - Send selected files to your smartphone or other devices using KDE Connect.
  [kdeconnect-send.yazi](https://github.com/Deepak22903/kdeconnect-send.yazi) - 通过 KDE Connect 将选定文件发送到智能手机或其他设备。
- [zoom.yazi](https://github.com/yazi-rs/plugins/tree/main/zoom.yazi) - Zoom in or out of the preview image.
  [zoom.yazi](https://github.com/yazi-rs/plugins/tree/main/zoom.yazi) - 放大或缩小预览图像。
- [pandoc.yazi](https://github.com/lmnek/pandoc.yazi) - Convert markup files to different formats via Pandoc.
  [pandoc.yazi](https://github.com/lmnek/pandoc.yazi) - 通过 Pandoc 将标记文件转换为不同格式。

Clipboard: 剪贴板：

- [clipboard.yazi](https://github.com/XYenon/clipboard.yazi) - Yank selected files to the system clipboard, with cross-platform support.
  [clipboard.yazi](https://github.com/XYenon/clipboard.yazi) - 将文件拉入系统剪贴板，支持跨平台。
- [copy-file-contents.yazi](https://github.com/AnirudhG07/plugins-yazi/tree/main/copy-file-contents.yazi) - A simple plugin to copy file contents just from Yazi without going into editor.
  [copy-file-contents.yazi](https://github.com/AnirudhG07/plugins-yazi/tree/main/copy-file-contents.yazi) - 一个简单的插件，可以直接从 Yazi 复制文件内容，无需进入编辑器。
- [system-clipboard.yazi](https://github.com/orhnk/system-clipboard.yazi) - Cross platform implementation of a simple system clipboard.
  system-clipboard.yazi - 简单系统剪贴板的跨平台实现。
- [wl-clipboard.yazi](https://github.com/grappas/wl-clipboard.yazi) - Wayland implementation of a simple system clipboard.
  wl-clipboard.yazi - Wayland 实现的简单系统剪贴板。
- [path-from-root.yazi](https://github.com/aresler/path-from-root.yazi) - Copy file path relative to git root
  [path-from-root.yazi](https://github.com/aresler/path-from-root.yazi) - 相对于 git 根复制文件路径
- [clippy.yazi](https://github.com/gallardo994/clippy.yazi) - Copy files to clipboard with Clippy on macOS
  [clippy.yazi](https://github.com/gallardo994/clippy.yazi) - 在 macOS 上用 Clippy 复制文件到剪贴板

`filter` enhancements:
`滤镜`增强：

- [smart-filter.yazi](https://github.com/yazi-rs/plugins/tree/main/smart-filter.yazi) - Makes filters smarter: continuous filtering, automatically enter unique directory, open file on submitting.
  [smart-filter.yazi](https://github.com/yazi-rs/plugins/tree/main/smart-filter.yazi) - 让过滤器更智能：连续筛选，自动进入唯一目录，提交时打开文件。

`enter` enhancements:
`这时，增强功能出现`了：

- [smart-enter.yazi](https://github.com/yazi-rs/plugins/tree/main/smart-enter.yazi) - `Open` files or `enter` directories all in one key!
  [smart-enter.yazi](https://github.com/yazi-rs/plugins/tree/main/smart-enter.yazi) - 一键`打开`文件或`录`入目录！
- [bypass.yazi](https://github.com/Rolv-Apneseth/bypass.yazi) - Yazi plugin for skipping directories with only a single sub-directory.
  [bypass.yazi](https://github.com/Rolv-Apneseth/bypass.yazi) - 用于跳过仅有单个子目录的目录的 Yazi 插件。
- [fast-enter.yazi](https://github.com/ourongxing/fast-enter.yazi) - Auto-decompress archives and enter them, or enter the deepest directory until it's not the only subdirectory.
  [fast-enter.yazi](https://github.com/ourongxing/fast-enter.yazi) - 自动解压压缩并输入，或者进入最深的目录，直到它不再是唯一的子目录。

`shell` enhancements:
`外壳`增强：

- [open-with-cmd.yazi](https://github.com/Ape/open-with-cmd.yazi) - Open files using a prompted command.
  [open-with-cmd.yazi](https://github.com/Ape/open-with-cmd.yazi) - 使用提示命令打开文件。

`search` enhancements:
`搜索`增强：

- [vcs-files.yazi](https://github.com/yazi-rs/plugins/tree/main/vcs-files.yazi) - Show Git file changes.
  [vcs-files.yazi](https://github.com/yazi-rs/plugins/tree/main/vcs-files.yazi) - 显示 Git 文件的更改。
- [git-files.yazi](https://github.com/ktunprasert/git-files.yazi) - Show Git file changes (with untracked, via `git status --porcelain`)
  [git-files.yazi](https://github.com/ktunprasert/git-files.yazi) - 显示 Git 文件更改（通过 `git 状态 --porcelain` 未被追踪）
- [modif.yazi](https://github.com/Shallow-Seek/modif.yazi) - Show recently modified.
  [modif.yazi](https://github.com/Shallow-Seek/modif.yazi) - 最近修改的节目。

`paste` enhancements:
`粘贴`增强：

- [smart-paste.yazi](https://github.com/yazi-rs/plugins/tree/main/smart-paste.yazi) - Paste files into the hovered directory or to the CWD if hovering over a file.
  [smart-paste.yazi](https://github.com/yazi-rs/plugins/tree/main/smart-paste.yazi) - 将文件粘贴到悬停的目录中，或者如果鼠标悬停在文件上，则粘贴到 CWD。

General command enhancements:
通用指挥增强：

- [augment-command.yazi](https://github.com/hankertrix/augment-command.yazi) - Enhances a few Yazi commands with better handling of the choice between selected items and the hovered item.
  [augment-command.yazi](https://github.com/hankertrix/augment-command.yazi) - 通过更好地处理选定物品与悬浮物品之间的选择，增强了部分 Yazi 指令。

UI enhancements: 用户界面增强：

- [full-border.yazi](https://github.com/yazi-rs/plugins/tree/main/full-border.yazi) - Add a full border to Yazi to make it look fancier.
  [full-border.yazi](https://github.com/yazi-rs/plugins/tree/main/full-border.yazi) - 给 Yazi 添加全边框，使其看起来更精致。
- [toggle-pane.yazi](https://github.com/yazi-rs/plugins/tree/main/toggle-pane.yazi) - Toggle the show, hide, and maximize states for different panes: parent, current, and preview.
  toggle-pane.yazi - 切换显示、隐藏和最大化不同面板的状态：父、当前和预览。
- [git.yazi](https://github.com/yazi-rs/plugins/tree/main/git.yazi) - Show the status of Git file changes as linemode in the file list.
  [git.yazi](https://github.com/yazi-rs/plugins/tree/main/git.yazi) - 在文件列表中以行模式显示 Git 文件更改的状态。
- [mount.yazi](https://github.com/yazi-rs/plugins/tree/main/mount.yazi) - A mount manager for Yazi, providing disk mount, unmount, and eject functionality.
  [mount.yazi](https://github.com/yazi-rs/plugins/tree/main/mount.yazi) - Yazi 的挂载管理器，提供磁盘挂载、卸载和弹出功能。
- [starship.yazi](https://github.com/Rolv-Apneseth/starship.yazi) - Starship prompt plugin for Yazi.
  [starship.yazi](https://github.com/Rolv-Apneseth/starship.yazi) - Yazi 的 Starship 提示插件。
- [omp.yazi](https://github.com/saumyajyoti/omp.yazi) - oh-my-posh prompt plugin for Yazi.
  [omp.yazi](https://github.com/saumyajyoti/omp.yazi) - Yazi 的 oh-my-posh 提示插件。
- [yatline.yazi](https://github.com/imsi32/yatline.yazi) - Customize header-line and status-line with an easy configuration.
  [yatline.yazi](https://github.com/imsi32/yatline.yazi) - 通过简便配置自定义标题行和状态行。
- [simple-status.yazi](https://github.com/Ape/simple-status.yazi) - Minimalistic status line with useful file attribute information.
  [simple-status.yazi](https://github.com/Ape/simple-status.yazi) - 极简状态行，带有有用的文件属性信息。
- [no-status.yazi](https://github.com/yazi-rs/plugins/tree/main/no-status.yazi) - Remove the status bar.
  [no-status.yazi](https://github.com/yazi-rs/plugins/tree/main/no-status.yazi) - 移除状态栏。
- [pref-by-location.yazi](https://github.com/boydaihungst/pref-by-location.yazi) - Save and restore linemode/sorting/hidden preferences based on directory location.
  [pref-by-location.yazi](https://github.com/boydaihungst/pref-by-location.yazi) - 根据目录位置保存和恢复行模式/排序/隐藏偏好设置。

## 🚀 Preloaders 🚀 预装器

Images: 图片：

- [allmytoes.yazi](https://github.com/Sonico98/allmytoes.yazi) - Preview freedesktop-compatible thumbnails using [allmytoes](https://gitlab.com/allmytoes/allmytoes).
  [allmytoes.yazi](https://github.com/Sonico98/allmytoes.yazi) - 使用 [allmytoes](https://gitlab.com/allmytoes/allmytoes) 预览免费桌面兼容缩略图。

## 🔍Fetchers 🔍取物者

Mime-type: 哑剧类型：

- [`mime-ext.yazi`](https://github.com/yazi-rs/plugins/tree/main/mime-ext.yazi) - A mime-type provider based on a file extension database, replacing the builtin `file(1)` to speed up mime-type retrieval at the expense of accuracy.
  [`mime-ext.yazi`](https://github.com/yazi-rs/plugins/tree/main/mime-ext.yazi) - 基于文件扩展名数据库的 mime 类型提供者，取代内置`文件（1），` 以加快 mime 类型的检索速度，但牺牲准确性。

## 🧑‍💻 Devtools 🧑 💻 开发工具

[types.yazi](https://github.com/yazi-rs/plugins/tree/main/types.yazi) - Type definitions for Yazi's Lua API, empowering an efficient plugin development experience.
[types.yazi](https://github.com/yazi-rs/plugins/tree/main/types.yazi) - Yazi Lua API 的类型定义，赋能高效的插件开发体验。

## 📝 (Neo)vim plugins 📝 （Neo）vim 插件

Neovim: 新维姆：

- [yazi.nvim](https://github.com/mikavilpas/yazi.nvim) - A Neovim plugin for the yazi terminal file manager.
  [yazi.nvim](https://github.com/mikavilpas/yazi.nvim) - 用于 yazi terminal 文件管理器的 Neovim 插件。
- [tfm.nvim](https://github.com/Rolv-Apneseth/tfm.nvim) - Neovim plugin for terminal file manager integration.
  tfm.nvim - 用于终端文件管理器集成的 Neovim 插件。
- [fm-nvim](https://github.com/Eric-Song-Nop/fm-nvim) - Neovim plugin that lets you use your favorite terminal file managers.
  [fm-nvim](https://github.com/Eric-Song-Nop/fm-nvim) - Neovim 插件，允许你使用你喜欢的终端文件管理器。

Vim: Vim：

- [vim-yazi](https://github.com/yukimura1227/vim-yazi) - Vim plugin integrating Yazi for seamless in-editor file browsing and navigation.
  [vim-yazi](https://github.com/yukimura1227/vim-yazi) - 集成 Yazi 的 Vim 插件，实现无缝编辑器内文件浏览和导航。
- [yazi.vim](https://github.com/chriszarate/yazi.vim) - Vim plugin for Yazi.
  [yazi.vim](https://github.com/chriszarate/yazi.vim) - Yazi 的 Vim 插件。

## 📝 Helix 📝 螺旋

- [Yazelix](https://github.com/luccahuguet/yazelix) - Adding a file tree to Helix & helix-friendly keybindings for Zellij
  [Yazelix](https://github.com/luccahuguet/yazelix) - 为 Zellij 添加文件树及支持螺旋键绑定

## 🐚 Shell plugins 🐚 Shell 插件

- [yazi-prompt.sh](https://github.com/Sonico98/yazi-prompt.sh) - Display an indicator in your prompt when running inside a yazi subshell.
  yazi-prompt.sh - 在 yazi 子壳内运行时，在提示中显示一个指示器。
- [custom-shell.yazi](https://github.com/AnirudhG07/custom-shell.yazi) - Run any commands through your default system shell.
  [custom-shell.yazi](https://github.com/AnirudhG07/custom-shell.yazi) - 通过默认系统壳执行任何命令。
- [command.yazi](https://github.com/KKV9/command.yazi) - Display a prompt for executing yazi commands.
  [command.yazi](https://github.com/KKV9/command.yazi) - 显示执行 yazi 命令的提示。

## 🛠️ Utilities 🛠️ 公用事业

- [icons-brew.yazi](https://github.com/lpnh/icons-brew.yazi) - Make a hot `theme.toml` for your Yazi icons with your favorite color palette.
  [icons-brew.yazi](https://github.com/lpnh/icons-brew.yazi) - 用你最喜欢的色彩搭配为你的 Yazi 图标制作热门`主题.toml`。
- [lsColorsToToml](https://github.com/Mellbourn/lsColorsToToml) - Generate the color rules for the `[filetype]` section in `theme.toml` based on your `$LS_COLORS`.
  [lsColorsToToml](https://github.com/Mellbourn/lsColorsToToml) - 根据你的 `$LS_COLORS` 生成 `theme.toml` 中 `[filetype]` 部分的颜色规则。

## 💖 Add yours 💖 加入你的

We are so happy to add your plugin to this page!
我们很高兴将您的插件添加到本页！

If your plugin meets the following requirements, please click "Edit this page" below to add it:
如果您的插件满足以下要求，请点击下方“编辑此页面”以添加：

- **Functional** - we will install and test it, since we want all links included on this page to be valid. If it's available only on a specific platform, a note should be added in the README.
  **功能性** ——我们将安装并测试它，因为我们希望本页面上的所有链接都有效。如果只在某个平台上有，应该在 README 中添加说明。
- **Follow conventions** - it should be a directory/repository ending with `.yazi`, and include the files listed in the [plugin documentation](https://yazi-rs.github.io/docs/plugins/overview).
  **遵循规范** ——应该是一个以 `.yazi` 结尾的目录/仓库，并包含[插件文档](https://yazi-rs.github.io/docs/plugins/overview)中列出的文件。

If it's a Neovim or shell plugin, appending `.nvim` or `.sh` to the name to make it distinguishable is a best practice, but it's not required.
如果是 Neovim 或 shell 插件，在名称后加上 `.nvim` 或 `.sh` 以使其易于区分是最佳实践，但并非必须。
