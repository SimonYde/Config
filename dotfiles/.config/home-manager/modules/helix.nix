{ pkgs, ... }:

{
  programs.helix = {
    package = pkgs.unstable.helix;
  };
}
