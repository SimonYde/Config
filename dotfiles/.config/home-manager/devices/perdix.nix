{ pkgs, ... }:

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

  home.packages = with pkgs; [
    nerdfonts
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
  ];
}
