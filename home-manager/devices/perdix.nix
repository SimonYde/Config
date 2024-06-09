{
  pkgs,
  config,
  lib,
  ...
} @ args:
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
      thunar = {
        defaultFilemanager = true;
        enable = true;
      };
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
      programming.enable = true;
      terminal.enable = true;
      ssh.enable = true;
      theming.enable = true;
    };

    wayland.windowManager =
      {
        sway.enable = false;
        hyprland.enable = true;
      }
      # NOTE: This is more of a tests than anything else.
      // lib.optionalAttrs (args ? "osConfig") {
        sway.enable = args.osConfig.programs.sway.enable;
        hyprland.enable = args.osConfig.programs.hyprland.enable;
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
