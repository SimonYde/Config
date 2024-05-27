{ pkgs, config, ... }:

let
  lock = "${pkgs.swaylock-effects}/bin/swaylock";
  icon_path = "${pkgs.wlogout}/share/wlogout/icons";
  palette = config.syde.theming.palette-hex;
in
{
  programs.wlogout = {

    style = with palette; ''
      * {
      	background-image: none;
      	box-shadow: none;
      }

      window {
      	background-color: rgba(12, 12, 12, 0.9);
      }

      button {
          border-radius: 0;
          border-color: black;
      	text-decoration-color: ${base05}; color: ${base05};
      	background-color: ${base00};
      	border-style: solid;
      	border-width: 1px;
      	background-repeat: no-repeat;
      	background-position: center;
      	background-size: 25%;
      }

      button:focus, button:active, button:hover {
      	background-color: ${base0D};
      	outline-style: none;
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

      #shutdown {
          background-image: image(url("${icon_path}/shutdown.png"));
      }

      #reboot {
          background-image: image(url("${icon_path}/reboot.png"));
      }
    '';

    layout = [
      {
        "label" = "lock";
        "action" = "${lock}";
        "text" = "Lock";
        "keybind" = "l";
      }

      {
        "label" = "logout";
        "action" = "hyprctl dispatch exit 0";
        "text" = "Logout";
        "keybind" = "e";
      }

      {
        "label" = "suspend";
        "action" = "${lock} -f && systemctl suspend";
        "text" = "Suspend";
        "keybind" = "u";
      }

      {
        "label" = "shutdown";
        "action" = "systemctl poweroff";
        "text" = "Shutdown";
        "keybind" = "s";
      }

      {
        "label" = "hibernate";
        "action" = "systemctl hibernate";
        "text" = "Hibernate";
        "keybind" = "h";
      }

      {
        "label" = "reboot";
        "action" = "systemctl reboot";
        "text" = "Reboot";
        "keybind" = "r";
      }
    ];
  };
}
