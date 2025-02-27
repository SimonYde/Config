{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  user = config.syde.user;
  cfg = config.syde.wsl;
in
{
  imports = [ inputs.nixos-wsl.nixosModules.default ];

  config = lib.mkIf cfg.enable {
    time.timeZone = "Europe/Copenhagen";

    wsl = {
      enable = true;
      wslConf.automount.root = "/mnt";
      defaultUser = user;
      startMenuLaunchers = false;
      useWindowsDriver = true;
    };

    users.users.${user} = {
      isNormalUser = true;
      description = "Simon Yde";
      shell = pkgs.${config.syde.shell};
      extraGroups = [ "wheel" ];
    };

    environment.systemPackages = with pkgs; [
      git
      wget
      wslu
    ];
  };

  options.syde.wsl = {
    enable = lib.mkEnableOption "WSL2 configuration";
  };
}
