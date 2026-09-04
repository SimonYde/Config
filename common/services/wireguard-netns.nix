{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    literalExpression
    mapAttrs'
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    nameValuePair
    ;
  inherit (lib.types)
    attrsOf
    port
    str
    submodule
    ;

  cfg = config.services.wireguard-netns;

  proxyServiceConfig = name: proxy: {
    enable = true;
    description = "Proxy to ${name} in Network Namespace";
    requires = [
      "${name}.service"
      "${name}-proxy.socket"
    ];
    after = [
      "${name}.service"
      "${name}-proxy.socket"
    ];
    unitConfig.JoinsNamespaceOf = "${name}.service";
    serviceConfig = {
      ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:${toString proxy.port}";
      PrivateNetwork = "yes";
      User = proxy.user;
      Group = proxy.group;
    };
  };

  proxySocketConfig = name: proxy: {
    enable = true;
    description = "Socket for Proxy to ${name}";
    listenStreams = [ (toString proxy.port) ];
    wantedBy = [ "sockets.target" ];
  };
in
{
  options.services.wireguard-netns = {
    enable = mkEnableOption {
      description = "Enable Wireguard client network namespace";
    };
    namespace = mkOption {
      type = str;
      description = "Network namespace to be created";
      default = "wg_client";
    };
    configFile = mkOption {
      type = lib.types.path;
      description = "Path to a file with Wireguard config (not a wg-quick one!)";
      example = literalExpression ''
        pkgs.writeText "wg0.conf" '''
          [Interface]
          PrivateKey = <client's privatekey>

          [Peer]
          PublicKey = <server's publickey>
          Endpoint = <server's ip>:51820
        '''
      '';
    };
    privateIP = mkOption {
      type = str;
    };
    dnsIP = mkOption {
      type = str;
    };
    proxies = mkOption {
      type = attrsOf (
        submodule (
          { name, ... }:
          {
            options = {
              port = mkOption {
                type = port;
                description = "Host port to listen on and forward to the service inside the namespace";
              };
              user = mkOption {
                type = str;
                default = name;
                description = "User to run the proxy service as";
              };
              group = mkOption {
                type = str;
                default = name;
                description = "Group to run the proxy service as";
              };
            };
          }
        )
      );
      default = { };
      description = ''
        Ingress socket proxies into the namespace. For each entry
        a <name>-proxy.socket listening on the host port and
        a systemd-socket-proxyd service forwarding to 127.0.0.1:<port> inside
        the namespace are created. The unit must also set
        systemd.services.<name>.useNetworkNamespace = true, otherwise the proxy
        has no namespace to join.
      '';
    };
  };

  options.systemd.services = mkOption {
    type = attrsOf (
      submodule (
        { name, config, ... }:
        {
          options.useNetworkNamespace = mkEnableOption ''
            running ${name} inside the Wireguard network namespace
            (services.wireguard-netns), with the namespace's
            resolv.conf/nsswitch.conf and DNS leak hardening
          '';

          config = mkIf (config.useNetworkNamespace && cfg.enable) {
            bindsTo = [ "netns@${cfg.namespace}.service" ];
            requires = [
              "network-online.target"
              "${cfg.namespace}.service"
            ];
            after = [
              "netns@${cfg.namespace}.service"
              "${cfg.namespace}.service"
            ];
            serviceConfig = {
              NetworkNamespacePath = [ "/run/netns/${cfg.namespace}" ];
              InaccessiblePaths = [
                "-/run/nscd"
                "-/run/dbus/system_bus_socket"
                "-/var/run/dbus/system_bus_socket"
                "-/run/systemd/resolve/io.systemd.Resolve"
                "-/run/systemd/resolve/io.systemd.Resolve.Monitor"
              ];
              BindReadOnlyPaths = [
                "/etc/netns/${cfg.namespace}/resolv.conf:/etc/resolv.conf:norbind"
                "/etc/netns/${cfg.namespace}/nsswitch.conf:/etc/nsswitch.conf:norbind"
              ];
            };
          };
        }
      )
    );
  };

  config = mkIf cfg.enable (mkMerge [
    {
      systemd.services."netns@" = {
        description = "%I network namespace";
        before = [ "network.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.iproute2}/bin/ip netns add %I";
          ExecStop = "${pkgs.iproute2}/bin/ip netns del %I";
        };
      };

      environment.etc."netns/${cfg.namespace}/resolv.conf".text = "nameserver ${cfg.dnsIP}";
      environment.etc."netns/${cfg.namespace}/nsswitch.conf".text = ''
        passwd:    files systemd
        group:     files [success=merge] systemd
        shadow:    files systemd
        sudoers:   files

        hosts:     files myhostname dns
        networks:  files

        ethers:    files
        services:  files
        protocols: files
        rpc:       files

        subuid:    files
        subgid:    files
      '';

      systemd.services.${cfg.namespace} = {
        description = "${cfg.namespace} network interface";
        bindsTo = [ "netns@${cfg.namespace}.service" ];
        requires = [ "network-online.target" ];
        after = [ "netns@${cfg.namespace}.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart =
            with pkgs;
            writers.writeBash "wg-up" ''
              set -e
              ${iproute2}/bin/ip link add wg0 type wireguard
              ${iproute2}/bin/ip link set wg0 netns ${cfg.namespace}
              ${iproute2}/bin/ip -n ${cfg.namespace} address add ${cfg.privateIP} dev wg0
              ${iproute2}/bin/ip netns exec ${cfg.namespace} \
              ${wireguard-tools}/bin/wg setconf wg0 ${cfg.configFile}
              ${iproute2}/bin/ip -n ${cfg.namespace} link set wg0 up
              ${iproute2}/bin/ip -n ${cfg.namespace} link set lo up
              ${iproute2}/bin/ip -n ${cfg.namespace} route add default dev wg0
            '';
          ExecStop =
            with pkgs;
            writers.writeBash "wg-down" ''
              set -e
              ${iproute2}/bin/ip -n ${cfg.namespace} route del default dev wg0
              ${iproute2}/bin/ip -n ${cfg.namespace} link del wg0
            '';
        };
      };
    }

    {
      systemd = {
        services = mapAttrs' (
          name: proxy: nameValuePair "${name}-proxy" (proxyServiceConfig name proxy)
        ) cfg.proxies;
        sockets = mapAttrs' (
          name: proxy: nameValuePair "${name}-proxy" (proxySocketConfig name proxy)
        ) cfg.proxies;
      };
    }
  ]);
}
