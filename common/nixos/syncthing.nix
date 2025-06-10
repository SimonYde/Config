{
  config,
  lib,
  username,
  ...
}:
let
  inherit (lib)
    any
    filter
    filterAttrs
    mapAttrs
    ;

  inherit (config.networking) hostName;

  home = "/home/${username}";

  removeThisDevice = filterAttrs (name: _: name != hostName);

  onlyForThisDevice = filterAttrs (_: v: any (name: name == hostName) v.devices);

  # TODO: 2025-03-17 Simon Yde, figure out if this is actually necessary still
  removeThisDeviceFromFolders = mapAttrs (
    _: attrs:
    attrs
    // {
      devices = filter (name: hostName != name) attrs.devices;
    }
  );
in
{
  users.users.${username}.extraGroups = [ "syncthing" ];

  networking.firewall.allowedTCPPorts = [ 8384 ];

  services.syncthing = {
    user = username;
    openDefaultPorts = true;

    configDir = "${home}/.config/syncthing";
    dataDir = home;

    overrideDevices = true;
    overrideFolders = true;

    settings = {
      options = {
        urAccepted = -1;
      };

      gui = {
        theme = "black";
      };

      devices = removeThisDevice {
        icarus = {
          name = "Icarus";
          id = "ZLF4ATX-FLQ3SOR-XIQ7PUJ-S3PMN7G-IHY6GLG-3LWAVNM-NK6DQOJ-BKT4IAH";
          introducer = false;
        };

        icarus-wsl = {
          name = "Icarus-WSL";
          id = "LNP56LK-BGLHOBR-AQ6YJ4Y-AAWO6D3-NWQ6SEH-IJFBX4J-NROPJYV-GYZEWAN";
          introducer = false;
        };

        perdix = {
          name = "Perdix";
          id = "IVWDHBF-LKMNFOG-3XALMVI-HKF2PFC-PP3IPMB-7MQM6VW-7O3OKLI-L5JQEQZ";
          introducer = false;
        };

        daedelus = {
          name = "Daedelus";
          id = "R2TFFYC-TI5PWMT-V6ZH73Z-U7PM2LG-7BQ4UGF-5BTYA6Y-XOGYJDB-D6FBXAI";
          introducer = true;
        };

        talos = {
          name = "Talos";
          id = "VSU4DLM-AKUKULD-KSG7T3V-I2FUYX5-JMC56UT-E6JFYA2-SQM2F6S-4ZLDXQO";
          introducer = false;
        };

        theseus = {
          name = "Theseus";
          id = "HZGNXLG-6L4D5SC-6N5DSV6-PKFPD5G-V7NWYGD-SG32FK3-LU6KJPZ-SNKM3AR";
          introducer = false;
        };
      };

      folders = removeThisDeviceFromFolders (onlyForThisDevice {
        "Apollo" = {
          path = "${home}/Documents/Apollo";
          devices = [
            "icarus"
            "talos"
            "daedelus"
            "theseus"
            "perdix"
          ];
          versioning = {
            type = "trashcan";
            params.cleanoutDays = "1000";
          };
        };

        "Audiobooks" = {
          path = "${home}/Audiobooks";
          devices = [
            "icarus"
            "talos"
            "daedelus"
            "theseus"
          ];
        };

        "Config" = {
          path = "${home}/Config";
          devices = [
            "icarus"
            "icarus-wsl"
            "perdix"
            "talos"
            "daedelus"
            "theseus"
          ];
        };

        "Pictures" = {
          path = "${home}/Pictures";
          devices = [
            "icarus"
            "talos"
            "daedelus"
            "theseus"
          ];
        };

        "Projects" = {
          path = "${home}/Projects";
          devices = [
            "icarus"
            "icarus-wsl"
            "talos"
            "daedelus"
          ];
        };

        ".secrets" = {
          path = "${home}/.secrets";
          devices = [
            "icarus"
            "icarus-wsl"
            "perdix"
            "talos"
            "daedelus"
            "theseus"
          ];
        };

        "Ebooks" = {
          path = "${home}/Ebooks";
          devices = [
            "icarus"
            "talos"
            "daedelus"
            "theseus"
          ];
        };
      });
    };
  };
}
