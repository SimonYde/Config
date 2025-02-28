{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.nixos-wsl.nixosModules.default ];

  time.timeZone = "Europe/Copenhagen";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = config.syde.user;
    startMenuLaunchers = false;
    useWindowsDriver = true;
  };

  environment.systemPackages = with pkgs; [
    git
    wget
    wslu
  ];
}
