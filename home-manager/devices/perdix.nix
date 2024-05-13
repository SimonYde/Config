{ pkgs, config, ... }:
let
  emulator = config.syde.terminal.emulator;
in
{
  config = {
    programs = {
      # Browsers
      brave.enable = true;
      firefox.enable = false;

      # Terminal emulators
      ${emulator}.enable = true;

      # other GUI programs
      vscode.enable = false;
      zathura.enable = true;
    };

    # personal program configurations
    syde.programs = {
      thunar.enable = true;
    };

    services = {
      kdeconnect.enable = true;
      gammastep.enable = true;
      redshift.enable = false;
      udiskie.enable = true;
    };

    # Personal modules
    syde = {
      email.enable = false;
      fonts.enable = true;
      programming.enable = true;
      terminal.enable = true;
      ssh.enable = true;
      theming.enable = true;
    };

    wayland.windowManager = {
      sway.enable = false;
      hyprland.enable = true;
    };

    home.packages = with pkgs; [
      obsidian
      libqalculate
      # synergy
      libreoffice

      discord
      betterdiscordctl

      rclone

      floorp
    ];

    syde.unfreePredicates = [
      "discord"
      "obsidian"
      "bitwig-studio"
    ];
  };

  imports = [ ../standard.nix ];
}
