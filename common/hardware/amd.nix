{
  config,
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
      # services.xserver.videoDrivers = [ "amdgpu" ];
      hardware.amdgpu = {
        opencl.enable = true;
        initrd.enable = false;
        amdvlk = {
          enable = true;
          support32Bit.enable = true;
          settings = { };
        };
      };

      hardware.graphics.enable = true;
    })

    (mkIf cfg.cpu.enable {
      # Virtualization support
      hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
      boot.kernelModules = [ "kvm-amd" ];
    })
  ];

  options.syde.hardware.amd = {
    gpu.enable = mkEnableOption "AMD GPU driver";

    cpu.enable = mkEnableOption "AMD CPU configuration";
  };
}
