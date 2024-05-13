{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.syde.gaming;
in
{
  config.specialisation."gaming".configuration = lib.mkIf cfg.enable {
    environment.etc."gaming".text = "gaming";
    programs = {
      steam.enable = true;
      gamemode.enable = true;
    };

    hardware = {
      pulseaudio.support32Bit = true;
      opengl = {
        driSupport32Bit = true;
        enable = true;
        extraPackages = with pkgs; [
          rocm-opencl-runtime
          rocm-opencl-icd
        ];
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

      # ---Wine and Wine Dependencies---
      wineWowPackages.staging
      wineWowPackages.fonts
      winetricks

      # ---Graphics Libraries---
      vulkan-tools
      vulkan-loader
      mesa
      mesa_drivers

      # ---32 bit---
      pkgsi686Linux.vulkan-tools
      pkgsi686Linux.vulkan-loader
      pkgsi686Linux.mesa
      pkgsi686Linux.mesa_drivers
    ];

    powerManagement.cpuFreqGovernor = lib.mkForce "performance";
  };
  options.syde.gaming = {
    enable = lib.mkEnableOption "gaming configuration";
  };
}
