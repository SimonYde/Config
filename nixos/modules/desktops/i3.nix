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

  users.users.syde.packages = with pkgs; [
    bemenu
  ];



  imports = [
    ../services/lightdm.nix
  ];
}
