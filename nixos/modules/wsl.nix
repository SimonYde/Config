{ config, lib, pkgs, inputs, ... }:

let cfg = config.syde.wsl; in

{
  config = lib.mkIf cfg.enable {
    system.stateVersion = "23.11";
    time.timeZone = "Europe/Copenhagen";

    wsl = {
      enable = true;
      wslConf.automount.root = "/mnt";
      defaultUser = config.syde.user;
      startMenuLaunchers = true;
      nativeSystemd = true;
      useWindowsDriver = true;
    };

    users.users.${config.syde.user} = {
      isNormalUser = true;
      description = "Simon Yde";
      shell = pkgs.${config.syde.shell};
      extraGroups = [ "wheel" ];
    };

    environment.systemPackages = with pkgs; [
      git
      wget
    ];

    programs = {
      dconf.enable = true;
      ${config.syde.shell}.enable = true;
    };
  };

  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  options.syde.wsl = {
    enable = lib.mkEnableOption "WSL2 configuration";
  };

}
