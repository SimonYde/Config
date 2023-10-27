{ config, pkgs, ... }:

{
  programs.kitty = {
    theme = if config.themes.flavour == "mocha" then "Catppuccin-Mocha" else "Catppuccin-Latte";
    font = {
      name = "JetBrains Mono Nerd Font Mono";
      size = if config.wayland.windowManager.sway.enable then 11.5 else 7;
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
    };
  };

}
