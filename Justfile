default: os

stow:
	#!/usr/bin/env -S nu -n
	use std/input
	use std/log
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

news:
	nix run nixpkgs#home-manager -- news --flake .#stub

update:
	@nix flake update --commit-lock-file
	@nh os switch . --ask --cores ${NIX_BUILD_CORES}

os:
	@nh os switch . --ask --cores ${NIX_BUILD_CORES}

host HOST:
	@nh os switch --ask --cores ${NIX_BUILD_CORES} --hostname {{HOST}} --target-host {{HOST}}

boot:
	@nh os switch . --ask --cores ${NIX_BUILD_CORES}

light:
	@nh os switch -s light-theme

gaming:
	@nh os switch -s gaming
