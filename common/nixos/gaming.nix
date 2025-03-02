{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkForce
    mkIf
    mkMerge
    ;
  cfg = config.syde.gaming;
  gamingConfig = {
    programs = {
      steam.enable = true;
      gamemode.enable = true;
    };

    programs.steam = {
      extraCompatPackages = with pkgs; [
        proton-ge-bin # glorious eggroll
      ];
      gamescopeSession.enable = true;
      fontPackages = with pkgs; [
        wineWowPackages.fonts
        source-han-sans
      ];
    };

    programs.gamemode = {
      settings = {
        general = {
          renice = 10;
        };

        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started' && hyprland-gamemode";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended' && hyprland-gamemode";
        };
      };
      enableRenice = true;
    };

    services.pulseaudio.support32Bit = true;

    hardware = {
      graphics = {
        enable32Bit = true;
        enable = true;
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

    powerManagement.cpuFreqGovernor = mkForce "performance";

    home-manager.users.${config.syde.user}.imports = [ ../home-manager/gaming.nix ];
  };
in
{
  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.specialisation {
      specialisation."gaming".configuration = mkMerge [
        { environment.etc."gaming".text = "gaming"; }
        gamingConfig
      ];
    })
    (mkIf (!cfg.specialisation) gamingConfig)
  ]);

  options.syde.gaming = {
    enable = mkEnableOption "gaming configuration";
    specialisation = mkEnableOption "whether gaming configuration should be specialisation";
  };
}
