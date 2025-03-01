{ pkgs, config, ... }:

let
  icon_path = "${pkgs.wlogout}/share/wlogout/icons";
  colors = config.lib.stylix.colors.withHashtag;
  font = config.stylix.fonts.sansSerif;
in
{
  programs.wlogout = {
    style =
      with colors; # css
      ''
        window {
          font-family: ${font.name} Medium;
          background-color: transparent;
          color: ${base05};
        }

        button {
          background-repeat: no-repeat;
          background-position: center;
          background-size: 20%;
          box-shadow: 0 0 0 0;
          background-color: transparent;
          border-color: transparent;
        	text-decoration-color: ${base05};
          color: ${base05};
          border-radius: 36px;
        }

        button:focus, button:active, button:hover {
          background-size: 50%;
          box-shadow: 0 0 10px 3px rgba(0,0,0,.4);
        	background-color: ${base0D};
          color: transparent;
          transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.5s ease-in;
        }

        #lock {
            background-image: image(url("${icon_path}/lock.png"));
        }

        #logout {
            background-image: image(url("${icon_path}/logout.png"));
        }

        #suspend {
            background-image: image(url("${icon_path}/suspend.png"));
        }

        #hibernate {
            background-image: image(url("${icon_path}/hibernate.png"));
        }

        #poweroff {
            background-image: image(url("${icon_path}/shutdown.png"));
        }

        #reboot {
            background-image: image(url("${icon_path}/reboot.png"));
        }
      '';

    layout = [
      {
        label = "lock";
        action = "loginctl lock-session";
        text = "Lock";
        keybind = "l";
      }

      {
        label = "logout";
        action = "hyprctl dispatch exit 0";
        text = "Logout";
        keybind = "e";
      }

      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "s";
      }

      {
        label = "poweroff";
        action = "systemctl poweroff";
        text = "Poweroff";
        keybind = "p";
      }

      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }

      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
  };
}
