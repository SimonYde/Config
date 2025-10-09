# For available options run:
#   config nu --doc | nu-highlight | bat

export def banner [] {
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

    hooks: {
        command_not_found: {|cmd|
            try {
                if (which nix-locate | is-empty) {
                    return null
                }

                let pkgs = nix-locate $"/bin/($cmd)" --whole-name --at-root --minimal

                if ($pkgs | is-empty) {
                    return null
                }

                return $"(ansi red)($cmd)(ansi reset) may be found in the following packages:\n($pkgs)"
            }
        }
    }
}

$env.config.keybindings ++= [{
    name: open_projects
    modifier: CONTROL
    keycode: Char_t
    mode: [emacs vi_insert vi_normal]
    event: [
        { edit: Clear }
        {
          edit: InsertString,
          value: "cd ~/Projects; interleave { ls ./UNI } { ls ./personal } { ls ./external } | get name | str join (char newline) | tv | cd $in"
        }
        { send: Enter }
    ]
}]

alias fg = job unfreeze

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
    # $env.GITLAB_TOKEN = (rbw get "Gitlab token")
    # $env.GITHUB_TOKEN = (rbw get "Github token")
    # $env.NIX_CONFIG = $"access-tokens = github.com=($env.GITHUB_TOKEN) gitlab.com=PAT:($env.GITLAB_TOKEN)"
  }
}
