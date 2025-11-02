{
  description = "wenjiu's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        wenjiu = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./configuration.nix
            ./hosts/wenjiu_wsl/hardware-configuration.nix

            nixos-wsl.nixosModules.default {
              system.stateVersion = "25.05";
              wsl = {
                enable = true;
                defaultUser = "wenjiu";
              };
            }

            {
              nixpkgs.config = {
                allowUnfree = true;
              };
            }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = {
                inherit inputs;
              };

              home-manager.users.wenjiu =
                { ... }:
                {
                  nixpkgs.config.allowUnfree = true;
                  imports = [
                    (import ./home/home.nix)
                  ];
                };
            }
          ];
        };
      };
    };
}
