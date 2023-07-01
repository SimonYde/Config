{ ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.deviceSection = ''Option "TearFree" "true"'';
  nixpkgs.config.allowUnfree = true;
  hardware.opengl.enable = true;
}
