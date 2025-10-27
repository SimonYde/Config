{
  config,
  lib,
  username,
  ...
}:
let
  inherit (lib)
    any
    filterAttrs
    mkIf
    ;

  inherit (config.networking) hostName;

  cfg = config.services.syncthing;

  home = "/home/${username}";

  onlyForThisDevice = filterAttrs (_: v: any (name: name == hostName) v.devices);
in
{
  config = mkIf cfg.enable {
    services.syncthing = {
      user = username;
      group = "users";
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

        devices = {
          icarus = {
            name = "Icarus";
            id = "ZLF4ATX-FLQ3SOR-XIQ7PUJ-S3PMN7G-IHY6GLG-3LWAVNM-NK6DQOJ-BKT4IAH";
            introducer = false;
          };

          icarus-windows = {
            name = "Icarus-Windows";
            id = "OAL3UXY-ZQBHPCJ-NNARFU4-RUCG7YU-SVGAF3Q-H22ZDUB-4DYDVBY-QTZUNQM";
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

        folders = onlyForThisDevice {
          "Apollo" = {
            path = "${home}/Documents/Apollo";
            devices = [
              "icarus"
              "icarus-windows"
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
              "perdix"
              "talos"
            ];
          };

          "Pictures" = {
            path = "${home}/Pictures";
            devices = [
              "daedelus"
              "icarus"
              "talos"
              "theseus"
            ];
          };

          "Projects" = {
            path = "${home}/Projects";
            devices = [
              "icarus"
              "perdix"
              "talos"
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
        };
      };
    };
  };
}
