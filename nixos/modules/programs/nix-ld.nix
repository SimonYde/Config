{ pkgs, ... }:
{
  programs.nix-ld = {
    libraries = with pkgs; [
      ncurses
      libz
      libstdcxx5
    ];
  };
}
