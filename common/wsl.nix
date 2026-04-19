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

  wsl = {
    enable = true;
    defaultUser = username;
    startMenuLaunchers = false;
    useWindowsDriver = true;

    interop.includePath = false;

    wslConf = {
      automount.root = "/mnt";
      network.hostname = config.networking.hostName;
    };
  };

  networking.firewall.enable = false;

  # very shitty OOM killer, to make up for WSL not having PSI
  systemd.services."nix-daemon@".serviceConfig.MemoryMax = "95%";
  systemd.services."nix-daemon".serviceConfig.MemoryMax = "95%";

  home-manager.users.${username} = {
    programs.nushell.shellAliases = {
      ex = "win FPilot.exe";
      poweroff = "win wsl.exe --shutdown NixOS";
    };
  };
}
