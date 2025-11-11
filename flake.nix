{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    flake-compat.url = "github:edolstra/flake-compat";
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS modules
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        systems.follows = "systems";
      };
    };

    secrets = {
      url = "git+ssh://git@github.com/SimonYde/secrets.git";
      flake = false;
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks-nix.follows = "pre-commit-hooks";
        flake-compat.follows = "flake-compat";
        rust-overlay.follows = "rust-overlay";
      };
    };

    # home-manager modules
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    mini-nvim = {
      url = "github:echasnovski/mini.nvim";
      flake = false;
    };
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    rainbow-delimiters-nvim = {
      url = "gitlab:HiPhish/rainbow-delimiters.nvim";
      flake = false;
    };
    tip-vim = {
      url = "github:SimonYde/tip.vim";
      flake = false;
    };
    wezterm-types = {
      url = "github:gonstoll/wezterm-types";
      flake = false;
    };
    trouble-nvim = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };
    vim-alloy = {
      url = "github:grafana/vim-alloy";
      flake = false;
    };
    rustaceanvim = {
      url = "github:mrcjkb/rustaceanvim/v6.9.7";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-treesitter-main = {
      url = "github:iofq/nvim-treesitter-main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    topiary-nushell = {
      url = "github:blindFS/topiary-nushell";
      flake = false;
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-csshacks = {
      url = "github:MrOtherGuy/firefox-csshacks";
      flake = false;
    };
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };

    tinted-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        tinted-schemes.follows = "tinted-schemes";
      };
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    # My flakes
    etilbudsavis-cli = {
      url = "github:SimonYde/etilbudsavis-cli";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    typst-languagetool = {
      url = "gitlab:SimonYde/typst-languagetool.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    kattis-cli = {
      url = "github:SimonYde/kattis-cli.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grawlix = {
      url = "github:SimonYde/grawlix.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    audiobook-dl = {
      url = "github:jo1gi/audiobook-dl";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs =
    inputs: with import ./utils/mkConfig.nix { inherit inputs; }; {
      legacyPackages.x86_64-linux = pkgs;

      checks.x86_64-linux = {
        pre-commit-check = inputs.pre-commit-hooks.lib.x86_64-linux.run {
          src = ./.;
          hooks = {
            # nixfmt-rfc-style.enable = true;
            # stylua.enable = true;
            # deadnix.enable = true;
            # statix.enable = true;
          };
        };
      };

      devShells.x86_64-linux.default = pkgs.mkShellNoCC {
        inherit (inputs.self.checks.x86_64-linux.pre-commit-check) shellHook;
        buildInputs = inputs.self.checks.x86_64-linux.pre-commit-check.enabledPackages;
        packages = with pkgs; [
          ragenix
          grafana-alloy
          just
          stow
        ];
      };

      nixosConfigurations = {
        hestia = mkSystem { hostname = "hestia"; };
        icarus = mkSystem { hostname = "icarus"; };
        icarus-wsl = mkWslSystem { hostname = "icarus"; };
        iso = mkSystem { hostname = "iso"; };
        perdix = mkSystem { hostname = "perdix"; };
        talos = mkSystem { hostname = "talos"; };
      };

      homeConfigurations = {
        stub = mkHome { username = "syde"; };
      };
    };
}
