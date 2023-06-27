{ pkgs, ... }:
let helix-master = 
  pkgs.callPackage ../packages/helix-master.nix {};

in 
{
  programs.helix = {
    # package = unstable.helix;
    package = helix-master;
  };
}

