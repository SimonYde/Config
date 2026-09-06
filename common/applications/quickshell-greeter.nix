{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  inherit (lib) mkIf;
  colors = config.lib.stylix.colors.withHashtag;

  greeterConfig = pkgs.runCommand "quickshell-greeter-config" { } ''
    mkdir -p $out
    cp ${../quickshell-greeter/shell.qml} $out/shell.qml
    cp ${../quickshell-greeter/Greeter.qml} $out/Greeter.qml
    cat > $out/Theme.qml <<EOF
    pragma Singleton
    import QtQuick

    QtObject {
        readonly property color background: "${colors.base00}"
        readonly property color base: "${colors.base01}"
        readonly property color muted: "${colors.base04}"
        readonly property color text: "${colors.base05}"
        readonly property color accent: "${colors.base0D}"
    }
    EOF
  '';
in
{
  config = mkIf config.programs.hyprland.enable {
    services.greetd.settings.default_session = {
      command = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.cage}/bin/cage -s -d -- ${pkgs.quickshell}/bin/quickshell --path ${greeterConfig}";
      user = "greeter";
    };
    security.pam.services.greetd.fprintAuth = config.services.fprintd.enable;

    environment.systemPackages = [
      pkgs.quickshell
    ];

    services.accounts-daemon.enable = true;

    # The greeter user needs a writable home for quickshell.
    users.users.greeter = {
      home = "/var/lib/greeter";
      createHome = true;
    };

    # World-readable dir for the greeter wallpaper, published by the user's awww script.
    systemd.tmpfiles.rules = [
      "d '/var/lib/quickshell-greeter' ${username} users 0755 - -"
    ];
  };
}
