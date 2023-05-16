{ pkgs, ... }:
{
  programs = {
    # Editors
    helix.enable = true;
    neovim.enable = true;
    
  };

  home.packages = with pkgs; [    
    zathura
    # LSPs
    texlab
    tectonic
    pandoc
    ltex-ls
                
    metals
    nil
    # nixfmt

    # Rust
    cargo
    rustc
    rust-analyzer
    rustfmt
    clippy
  ];

  imports = [
    ./modules/python.nix
    ./modules/helix.nix
    ./modules/neovim.nix
    ./modules/vscode.nix
  ];
}
