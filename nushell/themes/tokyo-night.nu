# Tokyo Night Theme for Nushell
# Based on the official Tokyo Night color scheme
# https://github.com/tokyo-night/tokyo-night-vscode-theme

# Tokyo Night Color Palette
export def tokyo_night_colors [] {
    {
        # Background colors
        bg: "#1a1b26"           # Default background
        bg_dark: "#16161e"      # Darker background
        bg_highlight: "#292e42" # Selection background
        
        # Foreground colors
        fg: "#c0caf5"           # Default foreground
        fg_dark: "#a9b1d6"      # Darker foreground
        fg_gutter: "#3b4261"    # Gutter foreground
        
        # Terminal colors
        black: "#15161e"
        red: "#f7768e"
        green: "#9ece6a"
        yellow: "#e0af68"
        blue: "#7aa2f7"
        magenta: "#bb9af7"
        cyan: "#7dcfff"
        white: "#c0caf5"
        
        # Bright terminal colors
        bright_black: "#414868"
        bright_red: "#f7768e"
        bright_green: "#9ece6a"
        bright_yellow: "#e0af68"
        bright_blue: "#7aa2f7"
        bright_magenta: "#bb9af7"
        bright_cyan: "#7dcfff"
        bright_white: "#c0caf5"
        
        # Syntax highlighting
        comment: "#565f89"
        orange: "#ff9e64"
        purple: "#9d7cd8"
    }
}

# Tokyo Night Theme Configuration
export def tokyo_night_theme [] {
    let colors = (tokyo_night_colors)
    
    {
        # Nushell primitives
        separator: $colors.fg_dark
        leading_trailing_space_bg: { attr: n }
        header: { fg: $colors.green attr: b }
        empty: $colors.blue
        bool: $colors.cyan
        int: $colors.orange
        filesize: $colors.cyan
        duration: $colors.yellow
        date: $colors.purple
        range: $colors.fg
        float: $colors.orange
        string: $colors.green
        nothing: $colors.cyan
        binary: $colors.purple
        cell-path: $colors.fg
        row_index: { fg: $colors.green attr: b }
        record: $colors.fg
        list: $colors.fg
        block: $colors.blue
        hints: $colors.comment
        search_result: { bg: $colors.yellow fg: $colors.bg }
        
        # Shapes (syntax highlighting)
        shape_and: { fg: $colors.magenta attr: b }
        shape_binary: { fg: $colors.magenta attr: b }
        shape_block: { fg: $colors.blue attr: b }
        shape_bool: $colors.cyan
        shape_closure: { fg: $colors.green attr: b }
        shape_custom: $colors.green
        shape_datetime: { fg: $colors.cyan attr: b }
        shape_directory: $colors.cyan
        shape_external: $colors.cyan
        shape_externalarg: { fg: $colors.green attr: b }
        shape_external_resolved: { fg: $colors.yellow attr: b }
        shape_filepath: $colors.cyan
        shape_flag: { fg: $colors.blue attr: b }
        shape_float: { fg: $colors.orange attr: b }
        shape_garbage: { fg: $colors.white bg: $colors.red attr: b }
        shape_glob_interpolation: { fg: $colors.cyan attr: b }
        shape_globpattern: { fg: $colors.cyan attr: b }
        shape_int: { fg: $colors.orange attr: b }
        shape_internalcall: { fg: $colors.cyan attr: b }
        shape_keyword: { fg: $colors.magenta attr: b }
        shape_list: { fg: $colors.cyan attr: b }
        shape_literal: $colors.blue
        shape_match_pattern: $colors.green
        shape_matching_brackets: { attr: u }
        shape_nothing: $colors.cyan
        shape_operator: $colors.yellow
        shape_or: { fg: $colors.magenta attr: b }
        shape_pipe: { fg: $colors.magenta attr: b }
        shape_range: { fg: $colors.yellow attr: b }
        shape_record: { fg: $colors.cyan attr: b }
        shape_redirection: { fg: $colors.magenta attr: b }
        shape_signature: { fg: $colors.green attr: b }
        shape_string: $colors.green
        shape_string_interpolation: { fg: $colors.cyan attr: b }
        shape_table: { fg: $colors.blue attr: b }
        shape_variable: $colors.purple
        shape_vardecl: $colors.purple
        shape_raw_string: { fg: $colors.magenta }
    }
}
