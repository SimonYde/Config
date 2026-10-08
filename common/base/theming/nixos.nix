{
  username,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  # Runs as root via theme-switch@<name>.service. The base system is addressed
  # with the sentinel instance name "base"; everything else is treated as a
  # specialisation name.
  themeSwitch = pkgs.writeShellScript "nixos-theme-switch" ''
    set -eu
    case "''${1:-}" in
      "")
        echo "usage: $0 <specialisation|base>" >&2
        exit 2
        ;;
      base)
        exec /nix/var/nix/profiles/system/bin/switch-to-configuration switch
        ;;
      *)
        exec "/nix/var/nix/profiles/system/specialisation/$1/bin/switch-to-configuration" switch
        ;;
    esac
  '';
in
{
  imports = [
    inputs.stylix.nixosModules.stylix
    ./shared.nix
  ];

  # Let the unprivileged user trigger a theme switch without a password prompt.
  # The privileged work still runs as root; only this single unit/action is
  # delegated through polkit.
  systemd.services."theme-switch@" = {
    description = "Switch NixOS theme specialisation (%i)";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${themeSwitch} %i";
    };
    # Mirrors nixos-upgrade.service: a nested switch-to-configuration must not
    # restart or remove the unit that is currently running it.
    restartIfChanged = false;
    unitConfig.X-StopOnRemoval = false;
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      var unit = action.lookup("unit");
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          subject.user == "${username}" &&
          action.lookup("verb") == "start" &&
          unit && unit.indexOf("theme-switch@") === 0) {
        return polkit.Result.YES;
      }
    });
  '';

  stylix.targets = {
    nixos-icons.enable = true;
    gnome-text-editor.enable = false;
    gnome.enable = false;
  };

  fonts.packages = with pkgs; [
    atkinson-hyperlegible-next
    atkinson-monolegible
    corefonts
    font-awesome
    gentium
    libertinus
    newcomputermodern
    roboto
    source-sans
  ];

  # Don't mess with brave settings
  programs.chromium.enable = lib.mkForce false;

  specialisation."light-theme".configuration = {
    environment.etc."specialisation".text = "light-theme";
    stylix = {
      base16Scheme = lib.mkForce "${inputs.tinted-schemes}/base24/catppuccin-latte.yaml";
      override = lib.mkForce { };
    };
    home-manager.users.${username} = {
      xdg.dataFile."home-manager/specialisation".text = "light-theme";
    };
  };

  home-manager.users.${username}.imports = [ ./home.nix ];
  home-manager.users.root.stylix.enable = false;
}
