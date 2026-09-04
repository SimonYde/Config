ARCANA_FLAGS := x"--nix-option max-jobs 4 --nix-option cores ${NIX_BUILD_CORES} --show-trace --verbose --keep-result --no-gzip"

alias l := local
alias b := build-all
alias d := deploy
alias up := update

default: update deploy

local:
    @arcana apply-local --sudo

deploy TARGETS="$(hostname),perdix,hestia,eunomia" +ARGS="":
    @arcana apply --on {{TARGETS}} {{ARCANA_FLAGS}} {{ARGS}}

update:
    @nix flake update --commit-lock-file

diff TARGET:
    @ssh {{TARGET}} nix profile diff-closures --profile /nix/var/nix/profiles/system

wat OPTION HOST="$(hostname)":
    @nix eval ".#nixosConfigurations.{{HOST}}.config.{{OPTION}}"

build-all +ARGS="":
    @arcana build {{ARCANA_FLAGS}} {{ARGS}}

push +ARGS="": (build-all ARGS)
    @cachix push simonyde .gcroots/* .direnv/flake-profile-*

sd TARGET:
    @nom build ".#nixosConfigurations.{{TARGET}}.config.system.build.sdImage" --verbose -j4 --show-trace -L

provision:
    sudo ln -s {{justfile_directory()}}/flake.nix /etc/nixos/flake.nix

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

os:
	@nh os switch . --ask --cores ${NIX_BUILD_CORES} --no-specialisation

host HOST:
	@nh os switch --ask --cores ${NIX_BUILD_CORES} --hostname {{HOST}} --target-host {{HOST}} --no-specialisation

boot:
	@nh os boot . --ask --cores ${NIX_BUILD_CORES} --no-specialisation

iso:
	nix build .#nixosConfigurations.iso.config.system.build.isoImage

light:
	@nh os switch -s light-theme

gaming:
	@nh os switch -s gaming
