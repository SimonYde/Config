{ pkgs, ... }:

let 
  extraEnv = { WLR_NO_HARDWARE_CURSORS = "1"; };
in
{
  config = {
    xdg.portal.wlr.enable = true;
    programs.sway = {
      enable = true;
      extraOptions = [ "--debug" "--verbose" "--unsupported-gpu" ];
    };
    services.xserver = {
      enable = true;
      displayManager = {
        defaultSession = "sway";
        lightdm.enable = true;
      };
    };
    environment.systemPackages = with pkgs; [
      qt6.qtwayland
      shotman
    ];
    environment.sessionVariables = extraEnv;
    environment.variables = extraEnv;
  };
  
  imports = [
    ../services/lightdm.nix
  ];
}
