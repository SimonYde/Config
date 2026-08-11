{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.services.samba;

  inherit (config.syde) server;

  inherit (server) samba;
in
{
  options.syde.server.samba = {
    commonSettings = lib.mkOption {
      description = "Parameters applied to each share";
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        "security" = "user";
        "invalid users" = [ "root" ];
      };
      apply =
        old:
        lib.attrsets.mergeAttrsList [
          {
            "preserve case" = "yes";
            "short preserve case" = "yes";
            "browseable" = "yes";
            "writeable" = "yes";
            "read only" = "no";
            "guest ok" = "no";
            "create mask" = "0644";
            "directory mask" = "0755";
            "valid users" = server.user;
            "fruit:aapl" = "yes";
            "vfs objects" = "catia fruit streams_xattr";
          }
          old
        ];
    };

    shares = lib.mkOption {
      type = lib.types.attrs;
      example = lib.literalExpression ''
        CoolShare = {
          path = "/mnt/CoolShare";
          "fruit:aapl" = "yes";
        };
      '';
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services = {

      samba = {
        openFirewall = true;

        settings = {
          global = {
            workgroup = lib.mkDefault "WORKGROUP";
            "server string" = lib.mkDefault config.networking.hostName;
            "netbios name" = lib.mkDefault config.networking.hostName;
            "security" = lib.mkDefault "user";
            "invalid users" = [ "root" ];
            "hosts allow" = lib.mkDefault "192.168.2.1/24 100.64.0.0/10";
            "guest account" = lib.mkDefault "nobody";
            "map to guest" = lib.mkDefault "bad user";
            "passdb backend" = lib.mkDefault "tdbsam";
          };
        }
        // builtins.mapAttrs (_name: value: value // samba.commonSettings) samba.shares;

      };

      samba-wsdd.enable = true; # make shares visible for windows clients

      # mDNS
      #
      # This part may be optional for your needs, but I find it makes browsing in Dolphin easier,
      # and it makes connecting from a local Mac possible.
      avahi = {
        enable = true;
        nssmdns4 = true;
        publish = {
          enable = true;
          addresses = true;
          domain = true;
          hinfo = true;
          userServices = true;
          workstation = true;
        };
        extraServiceFiles = {
          smb = ''
            <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
            <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
            <service-group>
              <name replace-wildcards="yes">%h</name>
              <service>
                <type>_smb._tcp</type>
                <port>445</port>
              </service>
            </service-group>
          '';
        };
      };
    };

    systemd.tmpfiles.rules = map (x: "d ${x.path} 0775 ${server.user} ${server.group} - -") (
      lib.attrValues samba.shares
    );

    system.activationScripts.samba_user_create = ''
      smb_password=$(cat "${config.age.secrets.sambaPassword.path}")
      echo -e "$smb_password\n$smb_password\n" | ${lib.getExe' pkgs.samba "smbpasswd"} -a -s ${server.user}
    '';

    networking.firewall = {
      allowedTCPPorts = [ 5357 ];
      allowedUDPPorts = [ 3702 ];
    };
  };
}
