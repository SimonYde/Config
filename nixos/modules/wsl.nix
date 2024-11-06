{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  shell = config.syde.shell;
  user = config.syde.user;
  cfg = config.syde.wsl;
in
{
  config = lib.mkIf cfg.enable {
    system.stateVersion = "24.05";
    time.timeZone = "Europe/Copenhagen";

    xdg.portal ={
      enable = true;
      config = {
        common.default = [
          "gtk"
          "*"
        ];
      };
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };

    wsl = {
      enable = true;
      wslConf.automount.root = "/mnt";
      defaultUser = config.syde.user;
      startMenuLaunchers = true;
      nativeSystemd = true;
      useWindowsDriver = true;
    };

    users.users.${user} = {
      isNormalUser = true;
      description = "Simon Yde";
      shell = pkgs.${shell};
      extraGroups = [ "wheel" ];
    };

    environment.systemPackages = with pkgs; [
      git
      wget
    ];

    programs = {
      dconf.enable = true;
      fish.enable = true;
    };
  };

  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  options.syde.wsl = {
    enable = lib.mkEnableOption "WSL2 configuration";
  };
}
