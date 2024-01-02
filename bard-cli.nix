{pkgs, ...}:
pkgs.buildGoApplication {
  pname = "bard-cli";
  version = "0.1";
  pwd = ./.;
  src = ./.;
  modules = ./gomod2nix.toml;
}


