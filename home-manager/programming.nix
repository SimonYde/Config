{ pkgs, inputs, config, ... }:
{
  programs = {
    # Editors
    helix.enable = false;
    neovim.enable = true;
    opam.enable = true;
  };

  # home.file = {
  #   "${config.xdg.configHome}/nvim" = {
  #     source = ../dotfiles/.config/nvim;
  #     enable = config.programs.neovim.enable;
  #     recursive = true;
  #   };
  # }; 

  home.packages = with pkgs; [
    # Latex
    texlab
    tectonic
    pandoc
    ltex-ls

    # Other LSPs
    # metals
    inputs.nil.packages.x86_64-linux.nil
    nixpkgs-fmt
    nodejs-slim_20 # for copilot.lua

    # Rust
    unstable.cargo
    unstable.rustc
    unstable.rust-analyzer
    unstable.rustfmt
    unstable.clippy
  ];

  home.sessionVariables = {
    GOPATH = "${config.xdg.dataHome}/go";
    CARGO_HOME = "${config.xdg.configHome}/cargo";
  };

  home.file =
    let
      kattis-cli = (pkgs.fetchFromGitHub {
        owner = "kattis";
        repo = "kattis-cli";
        rev = "be7fee7";
        sha256 = "sha256-R9wuxsVhNGkSVgTze6mR1mXYKXo5rj8LVVU3lTm2jTg=";
      });
    in
    {
      "${config.home.homeDirectory}/.local/bin/kattis" = {
        source = kattis-cli + "/kattis";
      };
      "${config.home.homeDirectory}/.local/bin/submit.py" = {
        source = kattis-cli + "/submit.py";
      };
    };

  imports = [
    ./modules/zathura.nix
    ./modules/python.nix
    ./modules/helix.nix
    ./modules/neovim.nix
    ./modules/vscode.nix
  ];
}
