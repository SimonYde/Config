{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption optionalAttrs;
  cfg = config.syde.hardware.amd;
in
{
  config =
    optionalAttrs (cfg.gpu.enable) {
      boot.initrd.kernelModules = [ "amdgpu" ];
      services.xserver.videoDrivers = [ "amdgpu" ];

      hardware = {
        opengl = {
          enable = true;
          driSupport32Bit = true;
          extraPackages = with pkgs; [ amdvlk ];
          extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
        };
      };
    }
    // optionalAttrs (cfg.cpu.enable) {
      # Virtualization support
      boot.kernelModules = [ "kvm-amd" ];
    };

  options.syde.hardware.amd = {
    gpu = {
      enable = mkEnableOption "AMD GPU driver";
    };
    cpu = {
      enable = mkEnableOption "AMD CPU configuration";
    };
  };
}
