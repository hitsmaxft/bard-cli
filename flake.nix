{
  description = "bard cli";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs = {
    gomod2nix.url = "github:nix-community/gomod2nix/master";
  };

  outputs = { self, nixpkgs, flake-utils, gomod2nix }:
  flake-utils.lib.eachDefaultSystem(
    system:

    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ gomod2nix.overlays.default ];
      };

      bard-cli = pkgs.callPackage ./. {
        inherit (gomod2nix.legacyPackages.${system}) buildGoApplication;
      };
    in
    {
      devShells.default = pkgs.callPackage ./shell.nix {
        inherit (gomod2nix.legacyPackages.${system}) mkGoEnv gomod2nix;
      };
      packages.default = bard-cli;
    });
  }
