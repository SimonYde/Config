{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.swaync;
  theming = config.syde.theming;
  font = theming.fonts.sansSerif;
in
{
  config = lib.mkIf cfg.enable {
    services.swaync = {
      settings = {
        positionX = "right";
        positionY = "top";

        control-center-width = 380;
        control-center-height = 860;
        control-center-margin-top = 2;
        control-center-margin-bottom = 2;
        control-center-margin-right = 1;
        control-center-margin-left = 0;

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
                command = "amixer set Master toggle";
              }
              {
                label = "";
                command = "amixer set Capture toggle";
              }
              {
                label = "";
                command = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
              }
              {
                label = "";
                command = "blueman-manager";
              }
            ];
          };
        };
      };
      style =
        with theming.palette-hex;
        #css
        ''
          @define-color background      ${base00};
          @define-color text            ${base05};
          @define-color background-alt  alpha(${base01}, .4);
          @define-color selected        ${base04};
          @define-color hover           alpha(@selected, .4);
          @define-color urgent          ${base08};

          * {
            color: @text;

            all: unset;
            font-size: 14px;
            font-family: "${font.name} 10";
            transition: 200ms;
          }

          .notification-row {
            outline: none;
            margin: 0;
            padding: 0px;
          }

          .floating-notifications.background .notification-row .notification-background {
            background: alpha(@background, .75);
            box-shadow: 0 0 8px 0 rgba(0,0,0,.6);
            border: 1px solid @selected;
            border-radius: 24px;
            margin: 16px;
            padding: 0;
          }

          .floating-notifications.background .notification-row .notification-background .notification {
            padding: 6px;
            border-radius: 12px;
          }

          .floating-notifications.background .notification-row .notification-background .notification.critical {
            border: 2px solid @urgent;
          }

          .floating-notifications.background .notification-row .notification-background .notification .notification-content {
            margin: 14px;
          }

          .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * {
            min-height: 3.4em;
          }

          .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action {
            border-radius: 8px;
            background-color: @background-alt ;
            margin: 6px;
            border: 1px solid transparent;
          }

          .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
            background-color: @hover;
            border: 1px solid @selected;
          }

          .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
            background-color: @selected;
            color: @background;
          }

          .image {
            margin: 10px 20px 10px 0px;
          }

          .summary {
            font-weight: 800;
            font-size: 1rem;
          }

          .body {
            font-size: 0.8rem;
          }

          .floating-notifications.background .notification-row .notification-background .close-button {
            margin: 6px;
            padding: 2px;
            border-radius: 6px;
            background-color: transparent;
            border: 1px solid transparent;
          }

          .floating-notifications.background .notification-row .notification-background .close-button:hover {
            background-color: @selected;
          }

          .floating-notifications.background .notification-row .notification-background .close-button:active {
            background-color: @selected;
            color: @background;
          }

          .notification.critical progress {
            background-color: @selected;
          }

          .notification.low progress,
          .notification.normal progress {
            background-color: @selected;
          }


          /* Avoid 'annoying' backgroud */
          .blank-window {
            background: transparent;
          }

          /* CONTROL CENTER ------------------------------------------------------------------------ */

          .control-center {
            background: alpha(@background, .75);
            border-radius: 24px;
            border: 1px solid @selected;
            box-shadow: 0 0 10px 0 rgba(0,0,0,.6);
            margin: 18px;
            padding: 12px;
          }

          /* Notifications  */
          .control-center .notification-row .notification-background,
          .control-center .notification-row .notification-background .notification.critical {
            background-color: @background-alt;
            border-radius: 16px;
            margin: 4px 0px;
            padding: 4px;
          }

          .control-center .notification-row .notification-background .notification.critical {
            color: @urgent;
          }

          .control-center .notification-row .notification-background .notification .notification-content {
            margin: 6px;
            padding: 8px 6px 2px 2px;
          }

          .control-center .notification-row .notification-background .notification > *:last-child > * {
            min-height: 3.4em;
          }

          .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action {
            background: alpha(@selected, .6);
            color: @text;
            border-radius: 12px;
            margin: 6px;
          }

          .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
            background: @selected;
          }

          .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
            background-color: @selected;
          }

          /* Buttons */

          .control-center .notification-row .notification-background .close-button {
            background: transparent;
            border-radius: 6px;
            color: @text;
            margin: 0px;
            padding: 6px;
          }

          .control-center .notification-row .notification-background .close-button:hover {
            background-color: @selected;
          }

          .control-center .notification-row .notification-background .close-button:active {
            background-color: @selected;
          }

          progressbar,
          progress,
          trough {
            border-radius: 12px;
          }

          progressbar {
            background-color: rgba(255,255,255,.1);
          }

          /* Notifications expanded-group */

          .notification-group {
            margin: 2px 8px 2px 8px;

          }
          .notification-group-headers {
            font-weight: bold;
            font-size: 1.25rem;
            color: @text;
            letter-spacing: 2px;
          }

          .notification-group-icon {
            color: @text;
          }

          .notification-group-collapse-button,
          .notification-group-close-all-button {
            background: transparent;
            color: @text;
            margin: 4px;
            border-radius: 6px;
            padding: 4px;
          }

          .notification-group-collapse-button:hover,
          .notification-group-close-all-button:hover {
            background: @hover;
          }

          /* WIDGETS --------------------------------------------------------------------------- */

            /* Notification clear button */
          .widget-title {
            font-size: 1.2em;
            margin: 6px;
          }

          .widget-title button {
            background: @background-alt;
            border-radius: 6px;
            padding: 4px 16px;
          }

          .widget-title button:hover {
            background-color: @hover;
          }

          .widget-title button:active {
            background-color: @selected;
          }

            /* Do not disturb */
          .widget-dnd {
            margin: 6px;
            font-size: 1.2rem;
          }

          .widget-dnd > switch {
            background: @background-alt;
            font-size: initial;
            border-radius: 8px;
            box-shadow: none;
            padding: 2px;
          }

          .widget-dnd > switch:hover {
            background: @hover;
          }

          .widget-dnd > switch:checked {
            background: @selected;
          }

          .widget-dnd > switch:checked:hover {
            background: @hover;
          }

          .widget-dnd > switch slider {
            background: @text;
            color: @background;
            border-radius: 6px;
          }

            /* Buttons menu */
          .widget-buttons-grid {
            font-size: xx-large;
            padding: 6px 2px;
            /* margin: 6px; */
            border-radius: 12px;
            background: @background-alt;
          }

          .widget-buttons-grid>flowbox>flowboxchild>button {
            /* margin: 10px 10px; */
            padding: 12px 12px;
            background: transparent;
            border-radius: 8px;
          }

          .widget-buttons-grid>flowbox>flowboxchild>button:hover {
            background: @hover;
          }


            /* Music player */
          .widget-mpris {
              background: @background-alt;
              border-radius: 16px;
              color: @text;
              margin:  20px 6px;
          }

            /* NOTE: Background need *opacity 1* otherwise will turn into the album art blurred  */
          .widget-mpris-player {
              background-color: @background-sec;
              border-radius: 22px;
              padding: 6px 14px;
              margin: 6px;
          }

          .widget-mpris > box > button {
            color: @text;
            border-radius: 20px;
          }

          .widget-mpris button {
            color: alpha(@text, .6);
          }

          .widget-mpris button:hover {
            color: @text;
          }

          .widget-mpris-album-art {
            border-radius: 16px;
          }

          .widget-mpris-title {
              font-weight: 700;
              font-size: 1rem;
          }

          .widget-mpris-subtitle {
              font-weight: 500;
              font-size: 0.8rem;
          }

          /* Volume */
          .widget-volume {
            background: @background-sec;
            color: @background;
            padding: 4px;
            margin: 6px;
            border-radius: 6px;
          }
        '';
    };
  };
}
