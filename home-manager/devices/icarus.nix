{ pkgs, ... }:
{
  programs = {
    zellij.settings.mouse_mode = true;
    zathura.enable = true;
  };

  home.packages = with pkgs; [
    libqalculate
  ];

  imports = [
    ../home.nix
    ../standard.nix
  ];
}
