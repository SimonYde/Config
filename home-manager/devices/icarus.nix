{ pkgs, config, ... }:
{
  programs = {
    zellij.settings.mouse_mode = true;
    zathura.enable = true;
  };

  home.packages = with pkgs; [
    libqalculate
    wl-clipboard
  ];

  home.file."${config.home.homeDirectory}/.vscode-server/server-env-setup" = {
    source = (pkgs.fetchFromGitHub {
      owner = "sonowz";
      repo = "vscode-remote-wsl-nixos";
      rev = "6354c9f";
      sha256 = "sha256-3xdLj8UvzUyx3AMjn+wtn5t0MfK+Le6zN3mz+FuRvDo=";
    } + "/server-env-setup");
  };

  imports = [
    ../home.nix
    ../standard.nix
  ];
}
