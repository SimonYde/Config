{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:

let
  ipFromCidr = cidr: builtins.head (builtins.split "/" cidr);
  inherit (import "${inputs.secrets}/networks.nix") netcup;

  inherit (config.syde) server;
in
{
  imports = [
    ./netcup.nix

    ./headscale.nix
    ./kanidm

    ./turn.nix
    ./netbird

    ../../common/server.nix
  ];

  system.stateVersion = "26.11";

  age.secrets.emailPassword = {
    file = "${inputs.secrets}/oneEmailPassword.age";
    owner = server.user;
    group = server.group;
    mode = "0440";
  };

  age.secrets.kanidmMailToken = {
    file = "${inputs.secrets}/kanidmMailToken.age";
  };

  # Personal configurations
  syde = {
    email = {
      enable = true;
      fromAddress = "services@tmcs.dk";
      toAddress = "services@tmcs.dk";
      smtpServer = "send.one.com";
      smtpUsername = "services@tmcs.dk";
      smtpPasswordPath = config.age.secrets.emailPassword.path;
    };

    server = {
      baseDomain = "simonyde.com";
      addrs = {
        v4 = ipFromCidr netcup.ipv4.cidr;
        v6 = ipFromCidr netcup.ipv6.cidr;
      };
    };

    acme.enable = true;

    monitoring.enable = true;
  };

  networking.nameservers = [
    "9.9.9.9"
    "149.112.112.112"
  ];

  services = {
    nginx = {
      enable = true;
    };

    kanidm = {
      server.enable = true;
      mailSender = {
        enable = true;
        mailTokenFile = config.age.secrets.kanidmMailToken.path;
      };
    };

    syncthing.enable = true;
    postgresql.package = lib.mkForce pkgs.postgresql_18;

    networkd-dispatcher = {
      enable = true;
      rules.tailscale-perf = {
        onState = [ "routable" ];
        script = ''
          #!${pkgs.runtimeShell}
          ${lib.getExe pkgs.ethtool} -K ens3 rx-udp-gro-forwarding on rx-gro-list off
        '';
      };
    };
  };

  systemd = {
    network.networks.netcup = {
      address = [
        netcup.ipv4.cidr
        netcup.ipv6.cidr
      ];
      routes = [
        { Gateway = netcup.ipv4.gateway; }
        { Gateway = netcup.ipv6.gateway; }
      ];
    };

    # FIXME: stupid bcachefs memory leak (?) nonsense
    services.drop-caches = {
      startAt = "daily";
      script = "${pkgs.procps}/bin/sysctl vm.drop_caches=3";
    };
  };
}
