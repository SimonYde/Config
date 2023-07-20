{ lib, pkgs, ... }:
/* let obsidian = 
    pkgs.writeShellScriptBin "obsidian" '' 
      #!/bin/sh
      ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.unstable.obsidian}/bin/obsidian "$@"
    '';
in */
{
  programs = {
    brave.enable   = true;
    firefox.enable = true;
    vscode.enable  = true;
  	zellij.settings.mouse_mode = false;
    alacritty.enable = true;
    zathura.enable = true;
  };

  services = {
    redshift.enable = true;
  };

  fonts.fontconfig.enable = true;
  xsession.windowManager.i3.enable = true;
  wayland.windowManager.sway.enable = false;

  home.packages = with pkgs; [
    nerdfonts
    font-awesome
    unstable.obsidian
    libqalculate
    synergy
    # gaming
    wine
    discord
    # texlive.combined.scheme-full
    rclone
    gnome.nautilus
  ];

  home.pointerCursor = {
    name = "Catppuccin-Mocha-Dark-Cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
    gtk.enable = true;
  };

  imports = [
    ../home.nix
    ../standard.nix
    ../modules/services/redshift.nix
    ../modules/gtk.nix
    ../modules/sway.nix
    ../modules/i3.nix
  ];
}
