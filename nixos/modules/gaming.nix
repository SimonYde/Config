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
      gamescopeSession.enable = true;
    };

    programs.nix-ld = {
      enable = true;
      libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs;
    };

    hardware = {
      pulseaudio.support32Bit = true;
      graphics = {
        enable32Bit = true;
        enable = true;
        extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
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

      # ---Graphics Libraries---
      vulkan-tools
      vulkan-loader
      mesa
      mesa.drivers

      # ---32 bit---
      pkgsi686Linux.vulkan-tools
      pkgsi686Linux.vulkan-loader
      pkgsi686Linux.mesa
      pkgsi686Linux.mesa.drivers
    ];

    powerManagement.cpuFreqGovernor = mkForce "performance";
  };
in
{
  config = mkMerge [
    (mkIf cfg.specialisation {
      specialisation."gaming".configuration = mkIf (cfg.enable && cfg.specialisation) (mkMerge [
        { environment.etc."gaming".text = "gaming"; }
        gamingConfig
      ]);
    })
    (mkIf (cfg.enable && !cfg.specialisation) gamingConfig)
  ];

  options.syde.gaming = {
    enable = mkEnableOption "gaming configuration";
    specialisation = mkEnableOption "whether gaming configuration should be specialisation";
  };
}
