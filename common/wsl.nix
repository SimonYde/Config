{
  config,
  pkgs,
  inputs,
  username,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ./.
  ];

  syde.development.enable = true;

  boot.bootspec.enable = false;

  wsl = {
    enable = true;
    defaultUser = username;
    startMenuLaunchers = false;
    useWindowsDriver = true;

    interop.includePath = true;

    wslConf = {
      automount.root = "/mnt";
      network.hostname = config.networking.hostName;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    wl-clipboard
    xdg-utils
    wget
    wslu
  ];

  networking.firewall.enable = false;

  # very shitty OOM killer, to make up for WSL not having PSI
  systemd.services.nix-daemon.serviceConfig.MemoryMax = "95%";
}
