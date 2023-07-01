{ pkgs, ... }:

{
  config = {
    xdg.portal.wlr.enable = true;
    programs.sway = {
      enable = true;
      extraSessionCommands = ''
        export MOZ_ENABLE_WAYLAND=1
        export QT_QPA_PLATFORM=wayland
        export WLR_NO_HARDWARE_CURSORS=1
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      '';
      extraOptions = [ "--unsupported-gpu" ];
        # export GBM_BACKEND=nvidia-drm
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
    ];
  };
  
  imports = [
    ../services/lightdm.nix
  ];
}
