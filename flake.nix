{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, vscode-server, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        wenjiu = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix

            vscode-server.nixosModules.default
            ({ config, pkgs, ... }: {
              services.vscode-server.enable = true;
            })
          ];
        };
      };

      hmConfig = {
        wenjiu = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs;
          username = "wenjiu";
          homeDirectory = "/home/wenjiu";
          configuration = {
            imports = [
              ./home.nix 
            ];
          };
        };
      };
    };
}
