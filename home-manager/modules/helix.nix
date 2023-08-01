{ pkgs, ... }:
let helix-master = 
  pkgs.callPackage ../packages/helix-master.nix {};
in 
{
  programs.helix = {
    # package = helix-master;
  };
}

