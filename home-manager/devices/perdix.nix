{ pkgs, ... }:

{
  programs = {
    # Browsers
    brave.enable = true;
    firefox.enable = true;

    # Terminals
    alacritty.enable = true;
    wezterm.enable = false;
    kitty.enable = false;

    thunderbird.enable = false;
    zathura.enable = true;
    zellij.settings.mouse_mode = true;
    nix-index.enable = true;
    vscode.enable = false;
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
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
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
    libsForQt5.dolphin
  ];

  syde.unfreePredicates = [
    "discord"
    "obsidian"
  ];

  home.pointerCursor = {
    name = "Catppuccin-Mocha-Dark-Cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
    gtk.enable = true;
  };

  imports = [
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
