{ pkgs, config, ... }:
{
  programs = {
    zathura.enable = true;
    nix-index.enable = true;
  };

  syde.ssh.enable = true;

  gtk.enable = true;
  qt.enable = true;

  home.packages = with pkgs; [
    libqalculate
    rclone
    keepassxc
    wl-clipboard
  ];

  # home.file."${config.home.homeDirectory}/.vscode-server/server-env-setup" = {
  #   source = (pkgs.fetchFromGitHub
  #     {
  #       owner = "sonowz";
  #       repo = "vscode-remote-wsl-nixos";
  #       rev = "6354c9f";
  #       sha256 = "sha256-3xdLj8UvzUyx3AMjn+wtn5t0MfK+Le6zN3mz+FuRvDo=";
  #     } + "/server-env-setup");
  # };

  imports = [
    ../standard.nix
  ];
}
