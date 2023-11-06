{ pkgs, config, ... }:

{
  config = {
    programs = {
      # Browsers
      brave.enable   = true;
      firefox.enable = true;

      # Terminals
      alacritty.enable = true;
      wezterm.enable   = false;
      kitty.enable     = false;

      thunderbird.enable = false;
      zathura.enable     = true;
      nix-index.enable   = true;
      vscode.enable      = false;
    };

    services = {
      redshift.enable  = false;
      gammastep.enable = true;
    };

    fonts.fontconfig.enable = true;
    xdg.enable = true;
    gtk.enable = true;
    qt.enable  = true;

    syde = {
      email.enable = false;
      ssh.enable   = true;
    };

    xsession.enable = false;
    xsession.windowManager.i3.enable  = false;
    wayland.windowManager.sway.enable = true;

    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
      unstable.obsidian
      libqalculate
      wl-clipboard
      # synergy
      libreoffice
      discord
      rclone
      gnome.nautilus
      keepassxc
    ];


    syde.unfreePredicates = [
      "discord"
      "obsidian"
    ];

    home.pointerCursor = {
      name    = config.themes.cursorTheme.name;
      package = config.themes.cursorTheme.package;
      size    = 24;
      gtk.enable = config.gtk.enable;
    };
  };

  imports = [
    ../standard.nix
  ];
}
