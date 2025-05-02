{
  description = "Danielle's System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;

    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;
  };

  outputs = {
    nix-darwin,
    lix-module,
    nix-homebrew,
    home-manager,
    homebrew-core,
    homebrew-cask,
    ...
  }: {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#minnie
    darwinConfigurations."minnie" = nix-darwin.lib.darwinSystem {
      modules = [
        ./darwin.nix
        lix-module.nixosModules.default
        home-manager.darwinModules.home-manager
        {
          users.users.danielle = {
            name = "danielle";
            home = "/Users/danielle";
          };

          home-manager.users.danielle = import ./home.nix;
        }
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;

            user = "danielle";
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            mutableTaps = false;
          };
        }
      ];
    };
  };
}
