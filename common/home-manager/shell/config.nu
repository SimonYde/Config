# For available options run:
#   config nu --doc | nu-highlight | bat

export def banner [] {
    fastfetch
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
        command_not_found: [
            {|cmd|
                if (which nix-locate | is-empty) {
                    return null
                }

                let pkgs = (nix-locate $"/bin/($cmd)" --whole-name --at-root --top-level --minimal)
                if ($pkgs | is-empty) {
                    return null
                }

                return (
                    $"(ansi $env.config.color_config.shape_external)($cmd)(ansi reset) " +
                    $"may be found in the following packages:\n($pkgs)"
                )
            }
        ]
    }
}

alias fg = job unfreeze

$env.NIXPKGS_ALLOW_UNFREE = 1
$env.NH_NO_CHECKS = 1

let prompt = {||
    if $env.LAST_EXIT_CODE != 0 {
        $"(ansi red)⟩ (ansi reset)"
    } else {
        $"(ansi white)⟩ (ansi reset)"
    }
}
$env.PROMPT_INDICATOR = $prompt
$env.PROMPT_INDICATOR_VI_INSERT = $prompt
$env.PROMPT_INDICATOR_VI_NORMAL = ": ";
$env.PROMPT_MULTILINE_INDICATOR = "::: ";

let fish_completer = {|spans: list<string>|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | from tsv --flexible --noheaders --no-infer
    | rename value description
}

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

let zoxide_completer = {|spans: list<string>|
    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD }
}

# This completer will use carapace by default
let external_completer = {|spans: list<string>|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        # use zoxide completions for zoxide commands
        __zoxide_z|__zoxide_zi => $zoxide_completer
        z|zi => $zoxide_completer
        hyprctl => $fish_completer
        ncspot => $fish_completer
        tailscale => $fish_completer
        topiary => $fish_completer
        trash => $fish_completer
        typst => $fish_completer
        _ => $carapace_completer
    } | do $in $spans
}

$env.config.completions.external.completer = $external_completer

use std-rfc/tables [ aggregate ]
