{ pkgs, lib, config, ... }:

{
  config = lib.mkIf config.programs.sway.enable {
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };

    programs.sway = {
      wrapperFeatures.gtk = true;
      wrapperFeatures.base = true;

      extraSessionCommands = ''
        export WLR_NO_HARDWARE_CURSORS=1
        export MOZ_ENABLE_WAYLAND=1
      '';
      extraOptions = [ "--unsupported-gpu" ];
    };

    services.xserver = {
      enable = true;
      displayManager = {
        defaultSession = "sway";
        lightdm.enable = true;
        # gdm.enable = true;
      };
    };

    users.users.syde.packages = with pkgs; [
      networkmanagerapplet
    ];

  };
  imports = [
    ../services/lightdm.nix
    ../services/gdm.nix
  ];
}
