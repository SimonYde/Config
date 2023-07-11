{ ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    powerManagement.enable = false;
    modesetting.enable = true;
  };
  
  services.xserver.deviceSection = ''Option "TearFree" "true"'';
  nixpkgs.config.allowUnfree = true;
  hardware.opengl.enable = true;
}
