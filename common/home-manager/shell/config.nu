# For available options run:
#   config nu --doc | nu-highlight | bat

def banner [] {
    fastfetch --logo nixos_small
}

$env.config = {
    show_banner: true
    edit_mode: vi
    footer_mode: auto
    use_kitty_protocol: true

    cursor_shape: {
        vi_insert: line
        vi_normal: block
    }

    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
        sort: "smart"
    }

    history: {
        max_size: 1_000_000
        sync_on_enter: true
        file_format: "plaintext"
        isolation: false
    }

    table: {
        mode: "frameless"
        header_on_separator: true

        trim: {
            methodology: truncating
            truncating_suffix: "…"
        }
    }
}

alias fg = job unfreeze
alias cat = bat

@complete external
def --wrapped nix-shell [...args] {
    let use_nom = if (which nom | is-not-empty) { ["--nom"] } else { [ ] }
    nix-your-shell ...$use_nom nu nix-shell -- ...$args
}

@complete external
def --wrapped nix [...args] {
    let use_nom = if (which nom | is-not-empty) { ["--nom"] } else { [ ] }
    nix-your-shell ...$use_nom nu nix -- ...$args
}

$env.NIXPKGS_ALLOW_UNFREE = 1

$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = $"(ansi green)I (ansi reset)"
$env.PROMPT_INDICATOR_VI_NORMAL = $"(ansi magenta)N (ansi reset)";
$env.PROMPT_MULTILINE_INDICATOR = $"(ansi blue)M (ansi reset)";

$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "WSLPATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

def --wrapped win [cmd, ...rest] {
    let input = $in
    if "WSLPATH" in $env {
        $env.PATH = ($env.PATH | append $env.WSLPATH)
    }
    $input | run-external $cmd ...$rest
}

def --env tokens [] {
    $env.GITLAB_TOKEN = (rbw get "Gitlab Token")
    $env.GITHUB_TOKEN = (rbw get "Github Token")
    $env.NIX_CONFIG = $"access-tokens = github.com=($env.GITHUB_TOKEN) gitlab.com=PAT:($env.GITLAB_TOKEN)"
}

try {
    if ("~/.config/rbw/config.json" | path exists) {
        rbw unlock

        if not (try { ssh-add -l | str contains "stdin" } catch { false }) {
            rbw get 'SSH syde' | ssh-add -
        }
    }
}
