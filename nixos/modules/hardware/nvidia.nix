{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.syde.hardware.nvidia;
in
{
  config = mkIf cfg.enable {
    # boot.initrd.kernelModules = [ "nvidia" ];
    # boot.blacklistedKernelModules = [ "nouveau" ];
    services.xserver.videoDrivers = [ "nvidia" ];
    boot.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
    ];

    boot.kernelParams = [
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia_drm.modeset-1"
      "nvidia_drm.fbdev=1"
    ];

    hardware.nvidia = {
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      modesetting.enable = true;
      open = mkDefault true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver ];
    };

    environment.sessionVariables = mkIf cfg.dedicated {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_VRR_ALLOWED = "1";
    };
  };

  options.syde.hardware.nvidia = {
    enable = mkEnableOption "Enable Nvidia driver configuration";
    dedicated = mkEnableOption "Nvidia GPU only configuration";
  };
}
