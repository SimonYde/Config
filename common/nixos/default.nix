{
  lib,
  pkgs,
  config,
  inputs,
  username,
  ...
}:

let
  inherit (lib)
    getExe
    mkDefault
    mkIf
    mapAttrs
    ;
  keys = import ../../keys.nix;
in
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.home-manager.nixosModules.default
    ../base/nix-settings.nix

    ./syncthing.nix

    ./amd.nix
    ./nvidia.nix
  ];

  system.stateVersion = "24.11";

  i18n.defaultLocale = "en_GB.UTF-8";

  time.timeZone = mkDefault "Europe/Copenhagen";

  documentation.nixos.enable = false;

  boot = {
    tmp = {
      useTmpfs = true;
      tmpfsSize = "100%";
    };

    initrd.systemd = {
      enable = true;
      emergencyAccess = true;
    };

    # enable TCP BBR for hopefully better utilization
    kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
  };

  zramSwap = {
    enable = true;
    swapDevices = 1;
    algorithm = "zstd";
  };

  nixpkgs.flake.setNixPath = true;

  nix = {
    package = pkgs.lix;
    channel.enable = false;
    settings.trusted-users = [ username ];
  };

  programs = {
    command-not-found.enable = false;

    ssh.knownHosts = mapAttrs (_: key: { publicKey = key; }) keys;

    nh = {
      enable = true;

      flake = "/home/${username}/Config";

      clean = {
        enable = true;
        extraArgs = "--keep 2 --nogcroots";
        dates = "daily";
      };
    };
  };

  networking.wg-quick.interfaces = mkIf config.networking.wireguard.enable {
    proton = {
      autostart = false;
      address = [ "10.2.0.2/32" ];
      dns = [ "10.2.0.1" ];
      privateKeyFile = config.age.secrets.wireguard.path;

      peers = [
        {
          publicKey = "XPVCz7LndzqWe7y3+WSo51hvNOX8nX5CTwVTWhzg8g8=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "149.88.27.234:51820";
        }
      ];
    };
  };

  # Use Rust implementation of `sudo`
  security = {
    sudo.enable = false;
    sudo-rs.enable = true;
  };

  services = {
    openssh = {
      enable = true;

      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
    };

    dbus.implementation = "broker";

    journald.extraConfig = "SystemMaxUse=100M";

    tailscale = {
      openFirewall = true;
      useRoutingFeatures = "both";

      extraUpFlags = [
        "--ssh"
        "--operator=${username}"
      ];

      extraDaemonFlags = [ "--no-logs-no-support" ];
    };
  };

  environment.shells = [ pkgs.nushell-wrapped ];

  users = {
    mutableUsers = false;

    users = {
      root = {
        shell = pkgs.nushell-wrapped;

        openssh.authorizedKeys.keys = [
          keys.icarus
          keys.perdix
        ];
      };

      ${username} = {
        isNormalUser = true;
        shell = pkgs.nushell-wrapped;
        hashedPasswordFile = config.age.secrets.pc-password.path;
        description = "Simon Yde";

        extraGroups = [
          "wheel"

          (mkIf config.services.syncthing.enable "syncthing")
        ];

        openssh.authorizedKeys.keys = [
          keys.icarus
          keys.perdix
        ];
      };
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = { inherit inputs; };

    users.${username}.imports = [ ../home-manager ];
    users.root.imports = [ ../home-manager ];
  };

  age = {
    identityPaths = [ "/home/${username}/.ssh/id_ed25519" ];
    ageBin = getExe pkgs.rage;

    secrets = {
      wireguard.file = ../../secrets/wireguard.age;
      pc-password.file = ../../secrets/pc-password.age;
      tailscale.file = ../../secrets/tailscale.age;
    };
  };

  systemd = {
    oomd = {
      enableUserSlices = true;
      enableRootSlice = true;
    };

    services.sshd.serviceConfig.MemoryMin = "100M";
  };

  system = {
    nixos =
      let
        meta = inputs.nixpkgs;
      in
      {
        versionSuffix = ".${
          lib.substring 0 8 (meta.lastModifiedDate or meta.nixpkgs.lastModified or "19700101")
        }.${meta.shortRev or "dirty"}";
        revision = meta.rev or "dirty";
      };
    configurationRevision = inputs.self.rev or "dirty";

    # Disable some unnecessary tools
    tools = {
      nixos-build-vms.enable = false;
      nixos-enter.enable = false;
      nixos-generate-config.enable = false;
      nixos-install.enable = false;
      nixos-option.enable = false;
    };
  };
}
