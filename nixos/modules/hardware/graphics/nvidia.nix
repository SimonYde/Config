{ config, ... }:

{
  boot.initrd.kernelModules = [ "nvidia" ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  hardware.nvidia = {
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    modesetting.enable = true;
    open = true;
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    # deviceSection = ''Option "TearFree" "true"'';
  };
  nixpkgs.config.allowUnfree = true;
  hardware.opengl.enable = true;
}
