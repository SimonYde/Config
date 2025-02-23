{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.swaync;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ libnotify ];
    services.swaync = {
      settings = {
        positionX = "right";
        positionY = "top";

        control-center-width = 380;
        control-center-height = 860;
        control-center-margin-top = 2;
        control-center-margin-bottom = 2;
        control-center-margin-right = 0;
        control-center-margin-left = 20;

        notification-window-width = 400;
        notification-icon-size = 48;
        notification-body-image-height = 160;
        notification-body-image-width = 200;

        timeout = 4;
        timeout-low = 2;
        timeout-critical = 6;

        fit-to-screen = true;
        keyboard-shortcuts = true;
        image-visibility = "when-available";
        transition-time = 200;
        hide-on-clear = true;
        hide-on-action = false;
        script-fail-notify = true;
        scripts = {
          example-script = {
            exec = "echo 'Do something...'";
            urgency = "Normal";
          };
        };
        notification-visibility = {
          example-name = {
            state = "muted";
            urgency = "Low";
            app-name = "Spotify";
          };
        };
        widgets = [
          "label"
          "buttons-grid"
          "mpris"
          "title"
          "dnd"
          "notifications"
        ];
        widget-config = {
          title = {
            text = "Notifications";
            clear-all-button = true;
            button-text = " 󰎟 ";
          };
          dnd = {
            text = "Do not disturb";
          };
          label = {
            max-lines = 1;
            text = " ";
          };
          mpris = {
            image-size = 96;
            image-radius = 12;
          };
          volume = {
            label = "󰕾";
            show-per-app = true;
          };
          buttons-grid = {
            actions = [
              {
                label = "";
                command = "swayosd-client --output-volume mute-toggle --max-volume 200";
              }
              {
                label = "";
                command = "swayosd-client --input-volume mute-toggle";
              }
              {
                label = "";
                command = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
              }
              {
                label = "";
                command = "blueman-manager";
              }
              {
                label = "";
                command = "random-bg";
              }
            ];
          };
        };
      };
    };
  };
}
