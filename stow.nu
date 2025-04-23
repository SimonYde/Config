#!/usr/bin/env -S nu -n

use std/input

def main [] {
    let config_dir = match $env.XDG_CONFIG_HOME? {
        null => {
            input $"(ansi yellow_bold)XDG_CONFIG_HOME(ansi reset) undefined. Directory to use instead: "
        }
        _ => {
            $env.XDG_CONFIG_HOME
        }
    }

    print $"Config directory: ($config_dir)"

    mkdir -v ([$config_dir nvim] | path join)
    mkdir -v ([$config_dir hypr] | path join)
    mkdir -v ([$config_dir helix] | path join)
    mkdir -v ([$config_dir nushell] | path join)
    mkdir -v ([$config_dir BetterDiscord] | path join)
    mkdir -v ([$config_dir topiary] | path join)
    mkdir -v ([$config_dir zellij] | path join)

    stow -v --target=$"($env.HOME)" dotfiles
}
