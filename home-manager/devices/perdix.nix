{ pkgs, ... }:
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
    i3status-rust.enable = true;
    alacritty.enable = true;
    zathura.enable = true;
  };

  fonts.fontconfig.enable = true;
  xsession.windowManager.i3.enable = true;
  wayland.windowManager.sway.enable = true;

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
  ];


  services.redshift = {
    enable = true;
    temperature = {
      day   = 6500;
      night = 1400;
    };
    provider  = "manual";
    latitude  = 56.3;
    longitude = 9.5;
  };
  imports = [
    ../home.nix
    ../modules/gtk.nix
    ../modules/sway.nix
    ../modules/i3.nix
  ];
}
