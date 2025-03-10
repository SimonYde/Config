{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    # NixOS modules
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        pre-commit-hooks.follows = "pre-commit-hooks";
      };
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "stable";
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

    # home-manager modules
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
    mini-nvim = {
      url = "github:echasnovski/mini.nvim";
      flake = false;
    };
    obsidian-nvim = {
      url = "github:obsidian-nvim/obsidian.nvim";
      flake = false;
    };
    snacks-nvim = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };
    tip-vim = {
      url = "github:SimonYde/tip.vim";
      flake = false;
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
        home-manager.follows = "home-manager";
        tinted-schemes.follows = "tinted-schemes";
        nur.follows = "nur";
      };
    };

    # My flakes
    pix2tex = {
      url = "github:SimonYde/pix2tex.nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
      url = "github:SimonYde/audiobook-dl.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    with import ./utils/mkConfig.nix {
      hostSystem = "x86_64-linux";
      inherit inputs;
    }; {
      legacyPackages = nixpkgsBySystem;

      nixosConfigurations = {
        icarus-wsl = mkWslSystem { hostname = "icarus"; };
        icarus = mkSystem { hostname = "icarus"; };
        perdix = mkSystem { hostname = "perdix"; };
      };

      checks.x86_64-linux = {
        pre-commit-check = inputs.pre-commit-hooks.lib.x86_64-linux.run {
          src = ./.;
          hooks = {
            nixfmt-rfc-style.enable = true;
            stylua.enable = true;
            deadnix.enable = true;
            # statix.enable = true;
          };
        };
      };

      devShells.x86_64-linux.default = pkgs.mkShellNoCC {
        inherit (inputs.self.checks.x86_64-linux.pre-commit-check) shellHook;
        buildInputs = inputs.self.checks.x86_64-linux.pre-commit-check.enabledPackages;
        packages = with pkgs; [
          (inputs.agenix.packages.x86_64-linux.default.override { ageBin = pkgs.lib.getExe pkgs.rage; })
          just
          stow
        ];
      };
    };
}
