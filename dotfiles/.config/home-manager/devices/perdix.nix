{ config, pkgs, ... }:

{
  programs = {
    brave.enable   = true;
    firefox.enable = true;
    vscode.enable  = true;
  	zellij.settings = {
      mouse_mode = false;
		};
    i3status-rust.enable = true;
  };

  fonts.fontconfig.enable = true;

  # xsession.windowManager.i3.enable = true;
  home.file = {
    "${config.xdg.configHome}/i3/config".source = ../../i3/config;
  };

  home.packages = with pkgs; [
    nerdfonts
    font-awesome
    unstable.obsidian
    nix
    synergy
    #gaming
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
    ../modules/gtk.nix
    ../modules/i3.nix
  ];
}
