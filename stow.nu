#!/usr/bin/env -S nu -n

use std/input
use std/log

def main [] {
    let config_dir = if XDG_CONFIG_HOME in $env {
        $env.XDG_CONFIG_HOME
    } else {
        input $"(ansi yellow_bold)XDG_CONFIG_HOME(ansi reset) undefined. Directory to use instead: "
    }

    log info $"Config directory: ($config_dir)"

    ls ./dotfiles/.config | where type == dir | each {
        let name = $in.name | path basename

        $config_dir | path join $name | mkdir -v $in
    }

    stow -v --target=$"($env.HOME)" dotfiles
}
