{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-ideapad-15arh05
    ../standard.nix
  ];

  # home-manager = {
  #   useUserPackages = true;
  #   useGlobalPkgs = true;
  #   backupFileExtension = "bak";
  #   extraSpecialArgs = {
  #     inherit inputs outputs;
  #   };
  #   users.${config.syde.user} = import ../../home-manager/devices/perdix.nix;
  # };

  # Personal configurations
  syde = {
    ssh.enable = true;
    laptop.enable = true;
    pc.enable = true;
    gaming.enable = true;
    gaming.specialisation = true;
    hardware = {
      nvidia.enable = true;
      amd.cpu.enable = true;
      amd.gpu.enable = true;
    };
  };

  syde.shell = "nushell";

  programs = {
    nix-ld.enable = true;
    nh.enable = true;
    kdeconnect.enable = false;
    sway.enable = false;
    hyprland = {
      enable = true;
    };
  };

  services.desktopManager.cosmic.enable = false;
  services.displayManager.cosmic-greeter.enable = false;

  services = {
    geoclue2.enable = false;
    languagetool.enable = false;
    ollama.enable = false;
    tailscale.enable = true;
    syncthing.enable = true;
    kanata.enable = true;
  };

  services.tailscale.authKeyFile = config.age.secrets.tailscale.path;

  networking.hostName = "perdix";
  networking.wireguard.enable = true;

  virtualisation.docker.enable = false;

  # Filesystems
  boot.initrd.luks.devices."luks-8c2b7981-b3e3-470e-aae7-2834b1352fa5".device = "/dev/disk/by-uuid/8c2b7981-b3e3-470e-aae7-2834b1352fa5";
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/SYSTEM_DRV";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];
}
