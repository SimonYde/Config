{
  pkgs,
  lib,
  username,
  config,
  ...
}:
let
  inherit (lib) mkForce mkIf getExe';

  cfg = config.syde.gaming;
in
{
  options.syde.gaming = {
    enable = lib.mkEnableOption "gaming configuration";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username}.imports = [ ../home-manager/gaming.nix ];

    powerManagement.cpuFreqGovernor = mkForce "performance";

    programs = {
      gamemode = {
        enable = true;
        enableRenice = true;

        settings = {
          general = {
            renice = 10;
          };

          custom = {
            start = "${getExe' pkgs.libnotify "notify-send"} --app-name 'GameMode' 'GameMode started'";
            end = "${getExe' pkgs.libnotify "notify-send"} --app-name 'GameMode' 'GameMode ended'";
          };
        };
      };

      steam = {
        enable = true;
        gamescopeSession.enable = true;
        protontricks.enable = true;

        # with Glorious Eggroll Proton
        extraCompatPackages = with pkgs; [ proton-ge-bin ];

        fontPackages = with pkgs; [
          wineWow64Packages.fonts
          source-han-sans
        ];
      };
    };

    users.users.${username}.extraGroups = [ "gamemode" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        vulkan-tools
        vulkan-loader
        mesa
        libva
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        vulkan-tools
        vulkan-loader
        mesa
        libva
      ];
    };
  };
}
