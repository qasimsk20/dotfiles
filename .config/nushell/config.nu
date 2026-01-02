# =============================================================================
# Theme & Prompt
# =============================================================================
source ~/.config/nushell/catppuccin/themes/catppuccin_mocha.nu

$env.STARSHIP_CONFIG = ($env.HOME | path join ".config" "starship.toml")
source ~/.cache/starship/init.nu

# Vi Mode Indicators
$env.PROMPT_INDICATOR = {|| "" }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "› " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# =============================================================================
# Environment & Path
# =============================================================================
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.BAT_THEME = "ansi"
$env.MANPAGER = "batman"
$env.PAGER = "bat -p"

# LS_COLORS
$env.LS_COLORS = if (which vivid | is-not-empty) {
    (vivid generate catppuccin-mocha)
}

$env.PATH = (
    $env.PATH
    | prepend "/home/qasimsk20/.radicle/bin"
    | prepend "/home/qasimsk20/.amp/bin"
    | prepend "/home/qasimsk20/.local/share/omarchy/bin"
    | prepend "/home/qasimsk20/.local/bin"
    | uniq
)

# =============================================================================
# Confidential Environment Variables
# =============================================================================
# env.nu is loaded automatically by Nushell before config.nu
# We keep it separate for secrets only.



# =============================================================================
# Tool Integrations
# =============================================================================
source ~/.cache/zoxide/init.nu
if ("($nu.home-path)/.cargo/env.nu" | path exists) {
    source $"($nu.home-path)/.cargo/env.nu"
}


# =============================================================================
# Tmux Config
# =============================================================================


# =============================================================================
# Core Configuration
# =============================================================================
$env.config = {
    show_banner: false
    edit_mode: 'vi'
    
    shell_integration: {
        osc133: true
        osc633: true
        reset_application_mode: true
    }
    
    ls: {
        use_ls_colors: true
        clickable_links: true
    }
    
    table: {
        mode: heavy
        index_mode: always
        show_empty: true
    }
    
    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "sqlite"
    }

    completions: {
        algorithm: "fuzzy"
        case_sensitive: false
        quick: true
        sort: "smart"
        external: {
            enable: true
            max_results: 50
        }
    }

    menus: [
        {
            name: completion_menu
            only_buffer_difference: false
            marker: "| "
            type: {
                layout: columnar
                columns: 4
                col_width: 20
                col_padding: 2
            }
            style: {
                text: cyan
                selected_text: { fg: black bg: magenta attr: b }
                description_text: white
                match_text: { fg: cyan attr: b }
                selected_match_text: { fg: black bg: magenta attr: b }
            }
        }
    ]

    

    keybindings: [
        {
            name: completion_menu
            modifier: none
            keycode: tab
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: menu name: completion_menu }
                    { send: menunext }
                    { edit: complete }
                ]
            }
        }
        
    ]
 }
 
 # =============================================================================
 # Custom Wrappers
 # =============================================================================

# Custom ls with icons
def get-file-style [type: string, name: string] {
    if $type == "dir" {
        {icon: "\u{f07b}", color: "blue"}
    } else {
        let ext = ($name | path parse | get extension | default "")
        match $ext {
            "rs" => {icon: "\u{e7a8}", color: "yellow"}
            "py" => {icon: "\u{e73c}", color: "yellow"}
            "js" => {icon: "\u{e74e}", color: "yellow"}
            "ts" => {icon: "\u{e628}", color: "cyan"}
            "jsx" | "tsx" => {icon: "\u{e7ba}", color: "cyan"}
            "vue" => {icon: "\u{e6a0}", color: "green"}
            "svelte" => {icon: "\u{e697}", color: "red"}
            "html" => {icon: "\u{e736}", color: "red"}
            "css" => {icon: "\u{e749}", color: "cyan"}
            "md" => {icon: "\u{e73e}", color: "white"}
            "json" => {icon: "\u{e60b}", color: "yellow"}
            "lua" => {icon: "\u{e620}", color: "blue"}
            "go" => {icon: "\u{e627}", color: "cyan"}
            "zip" | "tar" | "gz" => {icon: "\u{f1c6}", color: "red"}
            _ => {icon: "\u{f15b}", color: "white"}
        }
    }
}

def --wrapped ls-icons [...args] {
    let cmd = if ($args | is-empty) { "ls" } else { $"ls ($args | str join ' ')" }
    let result = (nu -c $"($cmd) | to nuon" | from nuon)
    $result | each {|row|
        let style = (get-file-style $row.type $row.name)
        {
            name: $"(ansi $style.color)($style.icon) ($row.name)(ansi reset)"
            size: $row.size
            modified: $row.modified
        }
    }
}

# Neovim wrapper
def n [...args: string] {
    if ($args | is-empty) { ^nvim . } else { ^nvim ...$args }
}

# =============================================================================
# Aliases
# =============================================================================
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..
alias ls = ls-icons
alias lsa = ls-icons -a

alias d = docker
alias r = rails
alias cls = clear
alias g = git
alias vim = nvim
alias hx = helix
alias ts = tmux-sessionizer
alias oc = opencode
alias gyr = ~/gglow.sh
alias copilot = copilot --banner

alias gcm = git commit -m
alias gcam = git commit -a -m
alias gcad = git commit -a --amend

if (which eza | is-not-empty) {
    alias lt = ^eza --tree --level=2 --long --icons --git
    alias lta = ^eza --tree --level=2 --long --icons --git -a
} else {
    alias lt = ls
    alias lta = ls -a
}

print $"(ansi { fg: teal, attr: b })Startup Time:(ansi reset) (nu -n --no-std-lib -c 'print $nu.startup-time')"
