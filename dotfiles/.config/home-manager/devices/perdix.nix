{ config, pkgs, ... }:
let obsidian = 
    pkgs.writeShellScriptBin "obsidian" '' 
      #!/bin/sh
      ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.unstable.obsidian}/bin/obsidian "$@"
    '';
in
{
  programs = {
    brave.enable   = true;
    firefox.enable = true;
    vscode.enable  = true;
  	zellij.settings.mouse_mode = false;
    i3status-rust.enable = true;
    alacritty.enable = true;
  };

  fonts.fontconfig.enable = true;

  xsession.windowManager.i3.enable = true;
  wayland.windowManager.sway.enable = false;

  home.packages = with pkgs; [
    flameshot
    nerdfonts
    font-awesome
    obsidian
    libqalculate
    synergy
    # gaming
    wine
    discord
    texlive.combined.scheme-full
    rclone
  ];


  services.redshift = {
    enable = true;
    temperature = {
      day   = 6500;
      night = 1600;
    };
    provider  = "manual";
    latitude  = 56.3;
    longitude = 9.5;
  };
  imports = [
    ../home.nix
    ../modules/gtk.nix
    ../modules/i3.nix
  ];
}
