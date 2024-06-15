{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkMerge mkIf;
  cfg = config.syde.hardware.amd;
in
{
  config = mkMerge [
    (mkIf cfg.gpu.enable {
      boot.initrd.kernelModules = [ "amdgpu" ];
      services.xserver.videoDrivers = [ "amdgpu" ];

      hardware = {
        opengl = {
          enable = true;
          driSupport32Bit = true;
          extraPackages = with pkgs; [
            rocm-opencl-runtime
            rocm-opencl-icd
            amdvlk
          ];
          extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
        };
      };
    })
    (mkIf cfg.cpu.enable {
      # Virtualization support
      hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
      boot.kernelModules = [ "kvm-amd" ];
    })
  ];

  options.syde.hardware.amd = {
    gpu = {
      enable = mkEnableOption "AMD GPU driver";
    };
    cpu = {
      enable = mkEnableOption "AMD CPU configuration";
    };
  };
}
