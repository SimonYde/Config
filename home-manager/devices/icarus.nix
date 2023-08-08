{ pkgs, config, ... }:
{
  programs = {
    zellij.settings.mouse_mode = true;
    zathura.enable = true;
  };

  home.packages = with pkgs; [
    libqalculate
    wl-clipboard
  ];

  imports = [
    ../home.nix
    ../standard.nix
  ];
}
