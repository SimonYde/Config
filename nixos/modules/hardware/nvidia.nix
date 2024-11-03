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
    nixpkgs.config.cudaSupport = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    boot.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
      "nvidia_uvm"
    ];

    hardware.nvidia = {
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      modesetting.enable = true;
      nvidiaSettings = true;
      open = mkDefault true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    environment.systemPackages = with pkgs; [
      cudaPackages.cudatoolkit
    ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver ];
    };

    environment.sessionVariables = mkIf cfg.dedicated {
      NVD_BACKEND = "direct";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "1";
    };
  };

  options.syde.hardware.nvidia = {
    enable = mkEnableOption "Enable Nvidia driver configuration";
    dedicated = mkEnableOption "Nvidia GPU only configuration";
  };
}
