{ config, pkgs, ...}:

{
  config = {
    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelModules = [ "kvm-amd" ];

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

    services.xserver = {
      videoDrivers = [ "amdgpu" ];
      # deviceSection = ''Option "TearFree" "true"'';
    };
  };
}
