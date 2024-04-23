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
  config = lib.mkIf cfg.enable {
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
          corefonts
          winetricks
        ];
      })
      mangohud

      # ---Wine and Wine Dependencies---
      wineWowPackages.staging
      wineWowPackages.fonts
      winetricks
      corefonts

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
  };

  options.syde.gaming = {
    enable = lib.mkEnableOption "gaming configuration";
  };
}
