{ pkgs, ... }:
{
  programs.nix-ld = {
    package = pkgs.nix-ld-rs;
    libraries = with pkgs; [
      ncurses
      libz
      libstdcxx5
    ];
  };
}
