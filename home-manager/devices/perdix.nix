{ pkgs, lib, ... }:
{
  programs = {
    nix-index.enable = true;
    brave.enable = true;
    firefox.enable = true;
    vscode.enable = false;
    alacritty.enable = true;
    wezterm.enable = false;
    thunderbird.enable = false;
    zathura.enable = true;
    zellij.settings.mouse_mode = true;
  };

  services = {
    redshift.enable = false;
    gammastep.enable = true;
  };

  fonts.fontconfig.enable = true;
  xsession.windowManager.i3.enable = false;
  xsession.enable = false;
  wayland.windowManager.sway.enable = true;
  xdg.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    # nerdfonts
    font-awesome
    unstable.obsidian
    libqalculate
    wl-clipboard
    # synergy
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
    ../modules/services/gammastep.nix
    ../modules/gtk.nix
    ../modules/qt.nix
    ../modules/sway.nix
    ../modules/themes.nix
    ../modules/i3.nix
    ../modules/email.nix
  ];
}
