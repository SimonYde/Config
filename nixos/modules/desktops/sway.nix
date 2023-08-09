{ inputs, pkgs, ... }:

{
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
  programs.sway = {
    # package = inputs.nixpkgs-wayland.packages."x86_64-linux".sway-unwrapped;
    enable = true;
    # wrapperFeatures.gtk = true;
    # wrapperFeatures.base = true;

    extraSessionCommands = ''
      export WLR_NO_HARDWARE_CURSORS=1
    '';
    extraOptions = [ "--unsupported-gpu" ];
  };
  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "sway";
      lightdm.enable = true;
    };
  };
  # environment.systemPackages = with pkgs; [
  #   qt6.qtwayland
  # ];
  # programs.nm-applet.enable = true;

  
  imports = [
    ../services/lightdm.nix
  ];
}
