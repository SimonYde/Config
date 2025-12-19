$env.config.hooks.command_not_found = {|cmd_name|
    let install = { |pkgs|
        $pkgs | each {|pkg| $"(char tab)nix shell nixpkgs#($pkg)" }
    }
    let single_pkg = { |pkg|
        let lines = [
            $"The program (ansi red)($cmd_name)(ansi reset) is currently not installed."
            (do $install [$pkg] | get 0)
        ]
        $lines | str join "\n"
    }
    let multiple_pkgs = { |pkgs|
        let lines = [
            $"The program (ansi red)($cmd_name)(ansi reset) is currently not installed. It is provided by several packages."
            (do $install $pkgs | str join "\n")
        ]
        $lines | str join "\n"
    }

    if (which nix-locate | is-empty) {
        return null
    }

    let pkgs = (nix-locate --minimal --no-group --type x --type s --whole-name --at-root $"/bin/($cmd_name)" | lines)
    let len = ($pkgs | length)
    let ret = match $len {
        0 => null,
        1 => (do $single_pkg ($pkgs | get 0)),
        _ => (do $multiple_pkgs $pkgs),
    }
    return $ret
}
