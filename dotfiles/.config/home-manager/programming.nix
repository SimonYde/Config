{ pkgs, ... }:
{
  programs = {
    # Editors
    helix.enable  = true;
    neovim.enable = true;
  };

  home.packages = with pkgs; [    
    # Latex
    zathura
    texlab
    tectonic
    pandoc
    ltex-ls
     
    lldb
    # Other LSPs
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
