{
  description = "wenjiu's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      home-manager,
      rust-overlay,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      overlays = [
        (import rust-overlay)
      ];
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

            nixos-wsl.nixosModules.default

            (
              { pkgs, ... }:
              {
                system.stateVersion = "25.05";
                wsl = {
                  enable = true;
                  useWindowsDriver = true;
                  defaultUser = "wenjiu";

                  usbip.enable = true;
                  interop.includePath = true;

                  # see https://github.com/zed-industries/zed/issues/39710
                  extraBin = [
                    { src = "${pkgs.coreutils}/bin/uname"; }
                    { src = "${pkgs.coreutils}/bin/mkdir"; }
                    { src = "${pkgs.coreutils}/bin/cp"; }
                  ];
                };
                hardware.graphics = {
                  enable = true;
                  enable32Bit = true;
                };
              }
            )

            {
              nixpkgs = {
                config = {
                  allowUnfree = true;
                };
                overlays = overlays;
              };
            }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = {
                inherit inputs overlays;
              };

              home-manager.users.wenjiu =
                { ... }:
                {
                  nixpkgs = {
                    config.allowUnfree = true;
                    overlays = overlays;
                  };
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
