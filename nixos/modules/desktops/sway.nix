{ pkgs, ... }:

{
  config = {
    xdg.portal = {
      enable = true;
      wlr.enable = true;
    };
    programs.sway = {
      enable = true;
      /* extraSessionCommands = ''
        export WLR_NO_HARDWARE_CURSORS=1
      ''; */
      extraOptions = [ "--debug" "--verbose" "--unsupported-gpu" ];
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
  };
  
  imports = [
    ../services/lightdm.nix
  ];
}
