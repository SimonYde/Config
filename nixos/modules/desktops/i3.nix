{ pkgs, ...}:

{
  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
  };

  programs.nm-applet.enable = true;
  programs.dconf.enable = true;

  imports = [
    ../services/lightdm.nix
  ];
}
