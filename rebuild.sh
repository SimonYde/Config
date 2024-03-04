#!/usr/bin/env bash
set -e
git diff -U0 *.nix
echo "NixOS Rebuilding..."
sudo nixos-rebuild --flake .#$HOST --show-trace switch &> nixos-rebuild.log || (cat nixos-rebuild.log | rg error && false)
gen=$(nixos-rebuild --flake .#$HOST list-generations | rg current)
git commit -am "NixOS Rebuild $HOST: $gen"
