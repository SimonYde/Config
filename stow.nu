def main [] {
    let config_dir = $env.XDG_CONFIG_HOME? | default ~/.config
    mkdir -v ([$config_dir, nvim] | path join)
    mkdir -v ([$config_dir, hypr] | path join)
    mkdir -v ([$config_dir, helix] | path join)
    mkdir -v ([$config_dir, nushell] | path join)
    mkdir -v ([$config_dir, BetterDiscord] | path join)
    mkdir -v ([$config_dir, topiary] | path join)
    mkdir -v ([$config_dir, zellij] | path join)

    stow -v dotfiles
}
