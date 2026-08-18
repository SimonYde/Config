{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./netcup.nix

    ./acme.nix
    ./kanidm.nix

    ../../common/server.nix
  ];

  system.stateVersion = "26.11";

  # Personal configurations
  syde = {
    server.baseDomain = "simonyde.com";

    monitoring.enable = true;
  };

  services = {
    nginx = {
      enable = true;
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
    network.networks.netcup =
      let
        netcup = (import "${inputs.secrets}/networks.nix").netcup;
      in
      {
        address = [ netcup.ipv4.cidr ];
        routes = [
          { Gateway = netcup.ipv4.gateway; }
        ];
      };

    # FIXME: stupid bcachefs memory leak (?) nonsense
    services.drop-caches = {
      startAt = "daily";
      script = "${pkgs.procps}/bin/sysctl vm.drop_caches=3";
    };
  };
}
