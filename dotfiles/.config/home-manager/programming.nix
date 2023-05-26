{ pkgs, ... }:
{
  programs = {
    # Editors
    helix.enable = false;
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
    unstable.cargo
    unstable.rustc
    unstable.rust-analyzer
    unstable.rustfmt
    unstable.clippy
  ];

  imports = [
    ./modules/python.nix
    ./modules/helix.nix
    ./modules/neovim.nix
    ./modules/vscode.nix
  ];
}
