{
  lib,
  username,
  config,
  pkgs,
  options,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.syde.development;
in
{
  options.syde.development = {
    enable = lib.mkEnableOption "development environment";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username}.imports = [ ../home-manager/development.nix ];

    systemd = {
      services = {
        # shared ssh-agent
        ssh-agent = {
          wantedBy = [ "multi-user.target" ];
          environment.SSH_AUTH_SOCK = config.environment.variables.SSH_AUTH_SOCK;
          serviceConfig = {
            ExecStartPre = "${pkgs.coreutils}/bin/rm -f $SSH_AUTH_SOCK";
            ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
            User = username;
          };
        };

        nix-daemon.environment = {
          inherit (config.environment.variables) SSH_AUTH_SOCK;
          # avoid random magic connection resets
          NIX_SSHOPTS = "-oServerAliveInterval=30";
        };
      };
    };

    virtualisation = {
      podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
        dockerCompat = true;
        dockerSocket.enable = true;
      };

      libvirtd.enable = lib.mkDefault config.programs.virt-manager.enable;
    };

    environment.variables = {
      SSH_AUTH_SOCK = "/tmp/ssh-agent.socket";
    };

    programs = {
      adb.enable = true;
      nix-ld = {
        enable = true;
        libraries = options.programs.nix-ld.libraries.default ++ [
          pkgs.fontconfig
          pkgs.freetype
          pkgs.libgbm
          pkgs.libinput
          pkgs.libxkbcommon
          pkgs.udev
        ];
      };

    };

    users.users.${username}.extraGroups = [
      "adbusers"
      "podman"
    ]
    ++ lib.optional config.virtualisation.libvirtd.enable "libvirtd";
  };
}
