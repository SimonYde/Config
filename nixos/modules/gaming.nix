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
        # glorious eggroll
        proton-ge-bin
      ];
      gamescopeSession.enable = true;
      fontPackages = with pkgs; [
        wineWowPackages.fonts
        source-han-sans
      ];
    };

    programs.nix-ld = {
      enable = true;
      # libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs;
    };

    hardware = {
      pulseaudio.support32Bit = true;
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

    environment.systemPackages = with pkgs; [
      # Applications
      (lutris.override {
        extraPkgs = pkgs: [
          wineWowPackages.staging
          wineWowPackages.fonts
          winetricks
        ];
      })
      mangohud
      r2modman
      heroic
      bottles
      prismlauncher

      # ---Wine and Wine Dependencies---
      wineWowPackages.staging
      wineWowPackages.fonts
      winetricks
    ];

    powerManagement.cpuFreqGovernor = mkForce "performance";
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
