{ pkgs, config, ... }:

let emulator = config.syde.terminal.emulator; in
{
  config = {
    programs = {
      # Browsers
      brave.enable   = true;
      firefox.enable = true;

      # Terminals
      ${emulator}.enable = true;

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
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "FiraCode"
        ];
      })
      font-awesome
      unstable.obsidian
      libqalculate
      # synergy
      libreoffice

      discord
      betterdiscordctl

      r2modman
      handbrake

      rclone

      xfce.thunar
      xfce.exo

      floorp
      keepassxc

      bitwig-studio
      obs-studio
    ];


    syde.unfreePredicates = [
      "discord"
      "bitwig-studio"
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
