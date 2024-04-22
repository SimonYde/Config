{ pkgs, config, ... }:

let emulator = config.syde.terminal.emulator; in
{
  config = {
    programs = {
      # Browsers
      brave.enable   = true;
      firefox.enable = false;

      # Terminal emulators
      ${emulator}.enable = true;

      # other GUI programs
      vscode.enable  = false;
      zathura.enable = true;
    };

    # personal program configurations
    syde.programs = {
      thunar.enable = true;
    };

    services = {
      kdeconnect.enable = true;
      gammastep.enable = true;
      redshift.enable  = false;
      udiskie.enable   = true;
    };

    xdg.enable = true;
    gtk.enable = true;
    qt.enable  = true;

    # Personal modules
    syde = {
      email.enable = false;
      ssh.enable   = true;
      fonts.enable = true;
    };

    xsession.windowManager.i3.enable  = false;
    wayland.windowManager.sway.enable = false;
    wayland.windowManager.hyprland.enable = true;

    home.packages = with pkgs; [
      obsidian
      libqalculate
      # synergy
      libreoffice

      discord
      betterdiscordctl

      r2modman

      rclone

      floorp
      keepassxc
    ];

    home.sessionVariables = {
      OBSIDIAN_USE_WAYLAND = "0";
    };

    syde.unfreePredicates = [
      "discord"
      "obsidian"
      "bitwig-studio"
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
