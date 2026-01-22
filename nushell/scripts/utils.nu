# Nushell Utility Functions Library
# Collection of commonly used functions for Fedora 43 development environment
# Author: SMLYFM <yytcjx@gmail.com>

# ============================================================================
# System Management Functions
# ============================================================================

# Display comprehensive system information
export def sysinfo [] {
    print $"(ansi cyan_bold)System Information(ansi reset)"
    print $"(ansi cyan)──────────────────────────────────────────────────────────────────(ansi reset)"
    
    # OS Information
    print $"OS:       (sys | get host | get name) (sys | get host | get os_version)"
    print $"Kernel:   (sys | get host | get kernel_version)"
    print $"Hostname: (sys | get host | get hostname)"
    print $"Uptime:   (sys | get host | get uptime | into duration)"
    print ""
    
    # CPU Information
    let cpu_usage = (sys | get cpu | get cpu_usage | math avg | math round)
    print $"CPU:      ($cpu_usage)% usage"
    print ""
    
    # Memory Information
    let mem = (sys | get mem)
    let mem_used = ($mem.used / 1GB | math round -p 2)
    let mem_total = ($mem.total / 1GB | math round -p 2)
    let mem_percent = (($mem.used / $mem.total) * 100 | math round)
    print $"Memory:   ($mem_used)GB / ($mem_total)GB \(($mem_percent)%\)"
    
    # Disk Information
    print ""
    print $"(ansi yellow_bold)Disk Usage:(ansi reset)"
    df -h | from ssv | where Filesystem =~ '^/' | select Filesystem Size Used Avail 'Use%' Mounted
}

# List all listening ports
export def ports [] {
    sudo ss -tuln | from ssv -a | where State == "LISTEN" | select 'Local Address:Port' | rename port
}

# Find process by name
export def proc [name: string] {
    ps | where name =~ $name
}

# ============================================================================
# File Operations Functions
# ============================================================================

# Create directory and change into it
export def mkcd [dir: string] {
    mkdir $dir
    cd $dir
}

# Backup a file by adding .bak extension with timestamp
export def backup [file: path] {
    let timestamp = (date now | format date "%Y%m%d-%H%M%S")
    let backup_name = $"($file).($timestamp).bak"
    cp $file $backup_name
    print $"(ansi green)✓ Backed up to: ($backup_name)(ansi reset)"
}

# Calculate total size of a directory
export def sizeof [dir: path] {
    du -sh $dir | from ssv -n | get column1 | get 0
}

# Smart extract - automatically detect archive type and extract
export def extract [file: path] {
    let ext = ($file | path parse | get extension)
    
    match $ext {
        "tar" => { tar -xf $file },
        "gz" | "tgz" => {
            if ($file | str ends-with ".tar.gz") or ($file | str ends-with ".tgz") {
                tar -xzf $file
            } else {
                gunzip $file
            }
        },
        "bz2" => {
            if ($file | str ends-with ".tar.bz2") {
                tar -xjf $file
            } else {
                bunzip2 $file
            }
        },
        "xz" => {
            if ($file | str ends-with ".tar.xz") {
                tar -xJf $file
            } else {
                unxz $file
            }
        },
        "zip" => { unzip $file },
        "7z" => { 7z x $file },
        "rar" => { unrar x $file },
        _ => { print $"(ansi red)Error: Unknown archive format: ($ext)(ansi reset)" }
    }
}

# ============================================================================
# Git Functions
# ============================================================================

# Git status with simplified output
export def gst [] {
    git status -sb
}

# Pretty git log
export def glog [n: int = 10] {
    git log --oneline --graph --decorate --color --all -n $n
}

# Git add, commit, and push in one command
export def gacp [message: string] {
    git add .
    git commit -m $message
    git push
    print $"(ansi green)✓ Changes committed and pushed: ($message)(ansi reset)"
}

# Show git branches with last commit info
export def gbr [] {
    git branch -vv
}

# Quick commit (add all and commit)
export def gc [message: string] {
    git add .
    git commit -m $message
    print $"(ansi green)✓ Committed: ($message)(ansi reset)"
}

# ============================================================================
# Network Functions
# ============================================================================

# Display local and external IP addresses
export def myip [] {
    print $"(ansi cyan_bold)IP Addresses(ansi reset)"
    print $"(ansi cyan)──────────────────────────────────────────────────────────────────(ansi reset)"
    
    # Local IP
    let local_ip = (ip -4 addr show | lines | find "inet " | first | str trim | split row " " | get 1)
    print $"Local IP:    ($local_ip)"
    
    # External IP
    try {
        let external_ip = (http get https://api.ipify.org)
        print $"External IP: ($external_ip)"
    } catch {
        print $"External IP: (ansi red)Unable to fetch(ansi reset)"
    }
}

# Test download speed
export def speedtest [] {
    print $"(ansi yellow)Testing download speed...(ansi reset)"
    let test_url = "https://speed.cloudflare.com/__down?bytes=10000000"
    
    try {
        let start = (date now)
        http get $test_url | ignore
        let end = (date now)
        let duration = (($end - $start) | into int) / 1_000_000_000
        let speed = (10 / $duration | math round -p 2)
        print $"(ansi green)Download speed: ~($speed) MB/s(ansi reset)"
    } catch {
        print $"(ansi red)Error: Speed test failed(ansi reset)"
    }
}

# ============================================================================
# Development Tools Functions
# ============================================================================

# Activate Python virtual environment (supports uv, poetry, venv)
export def venv-activate [] {
    # Check for uv first
    if ('.venv' | path exists) {
        print $"(ansi green)Activating uv/venv virtual environment...(ansi reset)"
        source .venv/bin/activate.nu
        return
    }
    
    # Check for poetry
    if ('pyproject.toml' | path exists) {
        print $"(ansi green)Using Poetry environment...(ansi reset)"
        poetry shell
        return
    }
    
    # Check for standard venv
    if ('venv' | path exists) {
        print $"(ansi green)Activating venv virtual environment...(ansi reset)"
        source venv/bin/activate.nu
        return
    }
    
    print $"(ansi red)Error: No virtual environment found(ansi reset)"
}

# Start a simple HTTP server
export def serve [port: int = 8000] {
    print $"(ansi cyan)Starting HTTP server on port ($port)...(ansi reset)"
    print $"(ansi yellow)Access at: http://localhost:($port)(ansi reset)"
    
    # Try Python first, then Node.js
    if (which python3 | is-not-empty) {
        python3 -m http.server $port
    } else if (which python | is-not-empty) {
        python -m http.server $port
    } else if (which npx | is-not-empty) {
        npx http-server -p $port
    } else {
        print $"(ansi red)Error: Neither Python nor Node.js found(ansi reset)"
    }
}

# Kill process by port number
export def ports-kill [port: int] {
    let pid = (sudo lsof -ti:$port)
    if ($pid | is-empty) {
        print $"(ansi yellow)No process found on port ($port)(ansi reset)"
    } else {
        sudo kill -9 $pid
        print $"(ansi green)✓ Killed process on port ($port) \(PID: ($pid)\)(ansi reset)"
    }
}

# ============================================================================
# Aliases and Quick Commands
# ============================================================================

# Quick ls with lsd (modern ls)
export def ll [] {
    if (which lsd | is-not-empty) {
        lsd -lah
    } else {
        ls -lah
    }
}

# Quick cat with bat (syntax highlighting)
export def bat-cat [file: path] {
    if (which bat | is-not-empty) {
        bat $file
    } else {
        cat $file
    }
}

# Find large files in current directory
export def large-files [size: string = "100M"] {
    print $"(ansi yellow)Finding files larger than ($size)...(ansi reset)"
    find . -type f -size +$size -exec ls -lh {} \; | from ssv -n
}

# ============================================================================
# System Maintenance Functions
# ============================================================================

# Update system packages (Fedora)
export def sys-update [] {
    print $"(ansi cyan_bold)Updating Fedora packages...(ansi reset)"
    sudo dnf update -y
    print $"(ansi green)✓ System updated(ansi reset)"
}

# Clean package cache
export def sys-clean [] {
    print $"(ansi yellow)Cleaning package cache...(ansi reset)"
    sudo dnf clean all
    print $"(ansi green)✓ Cache cleaned(ansi reset)"
}

# Show disk usage of current directory
export def disk-usage [] {
    du -sh * | from ssv -n | sort-by column2 -r | rename size path
}
