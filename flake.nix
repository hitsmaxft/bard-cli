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
      version = "0.1";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ gomod2nix.overlays.default ];
      };

      bard-cli = pkgs.callPackage ./bard-cli.nix { 
        inherit pkgs;
        pversion = version;
      };

      dev-shell = pkgs.callPackage ./shell.nix {
        inherit system;
        inherit pkgs;
      };
      bard-cli-app = {
        type = "app";
        program="${bard-cli}/bin/bard-cli";
      };
    in
    {
      devShells.default = pkgs.callPackage ./shell.nix {
        inherit (gomod2nix.legacyPackages.${system}) mkGoEnv gomod2nix;
      };
      packages.default = pkgs.callPackage ./. {
        inherit (gomod2nix.legacyPackages.${system}) buildGoApplication;
      };

      apps.bard-cli= bard-cli-app;
    });
  }
