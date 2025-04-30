#!/usr/bin/env -S nu -n

use std/input

def main [] {
    let config_dir = if XDG_CONFIG_HOME in $env {
        $env.XDG_CONFIG_HOME
    } else {
        input $"(ansi yellow_bold)XDG_CONFIG_HOME(ansi reset) undefined. Directory to use instead: "
    }

    print $"Config directory: ($config_dir)"

    [
        nvim
        hypr
        helix
        nushell
        topiary
        zellij
    ]
    | each {|dir|
        path join $config_dir $dir | mkdir -v $in
    }

    stow -v --target=$"($env.HOME)" dotfiles
}
