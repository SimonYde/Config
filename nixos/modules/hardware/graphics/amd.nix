{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.syde.hardware.amdgpu;
in {
  config = lib.mkIf cfg.enable {
    boot.initrd.kernelModules = ["amdgpu"];
    services.xserver.videoDrivers = ["amdgpu"];

    hardware = {
      opengl = {
        enable = true;
        driSupport32Bit = config.hardware.opengl.enable;
        extraPackages = with pkgs; [
          amdvlk
        ];
        extraPackages32 = with pkgs; [
          driversi686Linux.amdvlk
        ];
      };
    };
  };

  options.syde.hardware.amdgpu = {
    enable = lib.mkEnableOption "Enable AMD GPU driver configuration";
  };
}
