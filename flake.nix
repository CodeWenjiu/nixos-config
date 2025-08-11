{
  description = "wenjiu's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      vscode-server,
      home-manager,
      stylix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        wenjiu = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            ./hosts/wenjiu_laptop/hardware-configuration.nix

            { nixpkgs.config.allowUnfree = true; }

            vscode-server.nixosModules.default
            (
              {
                ...
              }:
              {
                services.vscode-server.enable = true;
              }
            )

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.wenjiu = {
                imports = [
                  stylix.homeModules.stylix
                  (import ./home/home.nix)
                ];
              };

              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
        };
      };
    };
}
