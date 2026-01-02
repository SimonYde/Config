# For available options run:
#   config nu --doc | nu-highlight | bat

def banner [] {
    fastfetch --logo nixos_small
}

$env.config = {
    show_banner: false
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

    table: {
        header_on_separator: true

        trim: {
            methodology: truncating
            truncating_suffix: "…"
        }
    }

    history: {
        max_size: 1_000_000
        sync_on_enter: true
        file_format: "plaintext"
        isolation: false
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

use std/clip

try {
    if ("~/.config/rbw/config.json" | path exists) {
        rbw unlock

        if not (try { ssh-add -l | str contains "stdin" } catch { false }) {
            rbw get 'SSH syde' | ssh-add -
        }

        # $env.CACHIX_AUTH_TOKEN = (rbw get Cachix)
        $env.GITLAB_TOKEN = (rbw get "Gitlab" --field "Token")
        $env.GITHUB_TOKEN = (rbw get "Github" --field "Token")
        $env.NIX_CONFIG = $"access-tokens = github.com=($env.GITHUB_TOKEN) gitlab.com=PAT:($env.GITLAB_TOKEN)"
    }
}
