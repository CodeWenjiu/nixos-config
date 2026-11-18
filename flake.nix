{
  description = "wenjiu's NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://niri-epireyn.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri-epireyn.cachix.org-1:tlVyFN7CtsDT+ZcLPS+ekFWeT1X6X4OqvWqbBMyIzFA="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Second, independently-locked nixpkgs pool for slow-moving, non-critical
    # packages. Main nixpkgs rolls fast; this pool is updated lazily via
    # `nix flake update nixpkgs-lazy` (see sysup-extra in shell.nix).
    nixpkgs-lazy.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Craft 系列（DeckCraft 等）的社区打包，直接跟上游 release。
    nix-craftapps = {
      url = "github:olafkfreund/nix-craftapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # boot
    minegrub-theme.url = "github:Lxtharia/minegrub-theme";

    # nur.url = "github:nix-community/NUR";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Actively maintained fork of sodiboo/niri-flake: its niri-unstable
    # follows the niri main branch and has a binary cache. The original's
    # overlay has been broken since 25.05 (sodiboo/niri-flake#1365).
    niri = {
      url = "github:epireyn/niri-flake";
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
      nixpkgs-lazy,
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
            inherit inputs nixpkgs-lazy;
          };
          modules = [
            minegrub-theme.nixosModules.default

            ./hosts/wenjiu_laptop/default.nix

            {
              nixpkgs.config = {
                allowUnfree = true;
              };
              # Provides pkgs.niri-unstable from the niri flake input.
              nixpkgs.overlays = [ inputs.niri.overlays.niri ];
            }

            # nixpkgs and home-manager both define programs.noctalia — keep flake's
            { disabledModules = [ "programs/wayland/noctalia.nix" ]; }

            inputs.noctalia.nixosModules.default

            # Craft 系列：系统层只负责 /usr/share/fonts 链接；
            # 具体启用哪些 app 在 Home Manager 的 doc.nix 里选。
            inputs.nix-craftapps.nixosModules.default
            {
              programs.craftapps.enable = true;
            }

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
              # Apps (zed, etc.) rewrite their HM-managed files in place;
              # clobber stale .backup files instead of aborting activation.
              home-manager.overwriteBackup = true;

              home-manager.extraSpecialArgs = {
                inherit inputs;
              };

              home-manager.sharedModules = [
                inputs.nix-craftapps.homeManagerModules.default
              ];

              home-manager.users.wenjiu =
                { ... }:
                {
                  nixpkgs.config.allowUnfree = true;
                  # home-manager.useGlobalPkgs = false, so the overlay needs to
                  # be applied to the home-manager pkgs as well.
                  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
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
