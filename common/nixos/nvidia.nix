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
    services.xserver.videoDrivers = [ "nvidia" ];

    # FIXME: 2025-03-10 Simon Yde, currently doesn't get set because of a dependency on `services.xserver`...
    boot.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
      "nvidia_uvm"
    ];

    hardware = {
      nvidia = {
        videoAcceleration = true;
        powerManagement.enable = true;
        modesetting.enable = true;
        nvidiaSettings = mkDefault false;
        open = mkDefault true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
      };

      nvidia-container-toolkit.enable =
        config.virtualisation.docker.enable || config.virtualisation.podman.enable;

      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };

    environment.systemPackages = with pkgs; [
      cudaPackages.cudatoolkit
    ];

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
