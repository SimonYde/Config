{ pkgs, lib, inputs, config, ... }:
{
  programs = {
    # Editors
    helix.enable  = true;
    neovim.enable = true;
  };

  # home.file = {
  #   "${config.xdg.configHome}/nvim" = {
  #     source = ../dotfiles/.config/nvim;
  #     enable = config.programs.neovim.enable;
  #     recursive = true;
  #   };
  #   "${config.xdg.configHome}/helix" = {
  #     source = ../dotfiles/.config/helix;
  #     enable = config.programs.helix.enable;
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
    metals
    inputs.nil.packages.x86_64-linux.nil
    nixpkgs-fmt
    nodejs_20
     
    # Rust
    unstable.cargo
    unstable.rustc
    unstable.rust-analyzer
    unstable.rustfmt
    unstable.clippy
    # lldb
  ];

  imports = [
    ./modules/zathura.nix
    ./modules/python.nix
    ./modules/helix.nix
    ./modules/neovim.nix
    ./modules/vscode.nix
  ];
}
