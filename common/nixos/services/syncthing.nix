{ config, lib, ... }:
let
  inherit (lib)
    any
    filter
    filterAttrs
    mapAttrs
    mkIf
    ;
  name = config.networking.hostName;
  inherit (config.syde) user;
  home = "/home/${user}";
  # Functions
  filterDevices =
    devicename: name: _:
    devicename != name;
  filterFolders =
    devicename: _: folderAttrs:
    any (name: devicename == name) folderAttrs.devices;
  fixFolderDevices = devicename: _: folderAttrs: {
    inherit (folderAttrs) path;
    devices = filter (name: devicename != name) folderAttrs.devices;
  };
  cfg = config.services.syncthing;
in
{
  config = mkIf cfg.enable {
    users.groups.syncthing.members = [ user ];
    services.syncthing = {
      inherit user;
      openDefaultPorts = true;
      configDir = "${home}/.config/syncthing";
      dataDir = "${home}/.local/share/syncthing";
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        options = {
          urAccepted = -1;
        };
        gui = {
          theme = "black";
        };
        devices =
          let
            devices = {
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
                id = "6PVHCIQ-EY6Z6P5-B7FCY67-F3R6MZM-CSJON5L-QYBMWVY-TY4FQU6-OHDKJQK";
                introducer = false;
              };
              daedelus = {
                name = "Daedelus";
                id = "R2TFFYC-TI5PWMT-V6ZH73Z-U7PM2LG-7BQ4UGF-5BTYA6Y-XOGYJDB-D6FBXAI";
                introducer = true;
              };
              theseus = {
                name = "Theseus";
                id = "HZGNXLG-6L4D5SC-6N5DSV6-PKFPD5G-V7NWYGD-SG32FK3-LU6KJPZ-SNKM3AR";
                introducer = false;
              };
            };
          in
          filterAttrs (filterDevices name) devices;
        folders =
          let
            folders = {
              "Audiobooks" = {
                path = "${home}/Audiobooks";
                devices = [
                  "icarus"
                  "perdix"
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
                  "daedelus"
                  "theseus"
                ];
              };
              "Pictures" = {
                path = "${home}/Pictures";
                devices = [
                  "icarus"
                  "perdix"
                  "daedelus"
                  "theseus"
                ];
              };
              "Projects" = {
                path = "${home}/Projects";
                devices = [
                  "icarus"
                  "icarus-wsl"
                  "perdix"
                  "daedelus"
                  "theseus"
                ];
              };
              ".secrets" = {
                path = "${home}/.secrets";
                devices = [
                  "icarus"
                  "icarus-wsl"
                  "perdix"
                  "daedelus"
                  "theseus"
                ];
              };
              "Ebooks" = {
                path = "${home}/Ebooks";
                devices = [
                  "icarus"
                  "perdix"
                  "daedelus"
                  "theseus"
                ];
              };
            };
          in
          mapAttrs (fixFolderDevices name) (filterAttrs (filterFolders name) folders);
      };
    };
  };
}
