{
  description = "wenjiu's NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://fcitx5-vinput.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "fcitx5-vinput.cachix.org-1:XpX3AA6+dDIX4qJhb1QM7sbTwX6/qSlGvW8Z5NK6XdU="
    ];
  };

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
      url = "github:sodiboo/niri-flake"; # wait for https://github.com/sodiboo/niri-flake/issues/1365 fixed
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fcitx5-vinput = {
      url = "github:xifan2333/fcitx5-vinput";
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
      checks.${system}.wenjiu = self.nixosConfigurations.wenjiu.config.system.build.toplevel;

      nixosConfigurations = {
        wenjiu = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            minegrub-theme.nixosModules.default

            ./hosts/wenjiu_laptop/default.nix

            {
              nixpkgs.config = {
                allowUnfree = true;
              };
            }

            # nixpkgs and home-manager both define programs.noctalia — keep flake's
            { disabledModules = [ "programs/wayland/noctalia.nix" ]; }

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

            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";

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

            # Ensure home-manager service restarts on rebuild
            (
              { config, ... }:
              {
                systemd.services.home-manager-wenjiu.restartTriggers = [
                  config.home-manager.users.wenjiu.home.activationPackage
                ];
              }
            )
          ];
        };
      };
    };
}
