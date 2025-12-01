{
  description = "wenjiu's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # boot
    minegrub-theme.url = "github:Lxtharia/minegrub-theme";

    # nur.url = "github:nix-community/NUR";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,

      minegrub-theme,

      nixpkgs,
      # nur,
      vscode-server,
      home-manager,

      niri,
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
            minegrub-theme.nixosModules.default

            ./configuration.nix
            ./hosts/wenjiu_laptop/hardware-configuration.nix

            {
              nixpkgs.config = {
                allowUnfree = true;
              };
            }

            inputs.noctalia.nixosModules.default
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
              home-manager.useGlobalPkgs = false;
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
