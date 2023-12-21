{ pkgs, config, ... }:

let emulator = config.syde.terminal.emulator; in
{
  config = {
    programs = {
      # Browsers
      brave.enable   = true;
      firefox.enable = true;

      # Terminals
      alacritty.enable = emulator == "alacritty";
      wezterm.enable   = emulator == "wezterm";
      kitty.enable     = emulator == "kitty";

      nix-index.enable = true;
      vscode.enable    = false;
      zathura.enable   = true;
    };

    services = {
      gammastep.enable = true;
      redshift.enable  = false;
    };

    fonts.fontconfig.enable = true;
    xdg.enable = true;
    gtk.enable = true;
    qt.enable  = true;

    syde = {
      email.enable = false;
      ssh.enable   = true;
    };

    xsession.enable = false;
    xsession.windowManager.i3.enable  = false;
    wayland.windowManager.sway.enable = false;
    wayland.windowManager.hyprland.enable = true;

    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
      font-awesome
      unstable.obsidian
      libqalculate
      wl-clipboard
      # synergy
      libreoffice

      discord
      betterdiscordctl

      rclone
      gnome.nautilus
      xfce.thunar

      floorp
      keepassxc
    ];


    syde.unfreePredicates = [
      "discord"
      "obsidian"
    ];

    home.pointerCursor = let cursorTheme = config.syde.theming.cursorTheme; in {
      name    = cursorTheme.name;
      package = cursorTheme.package;
      size    = 24;
      gtk.enable = config.gtk.enable;
    };
  };

  imports = [
    ../standard.nix
  ];
}
