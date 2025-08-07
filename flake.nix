{
  description = "wenjiu's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, vscode-server, home-manager }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        wenjiu = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            ./hardware-configuration.nix
            ./basic/boot.nix

            ./modules/oh-my-rime.nix
            ./modules/clash.nix
            
            # 允许 unfree 包
            { nixpkgs.config.allowUnfree = true; }
            
            # VSCode 服务器模块
            vscode-server.nixosModules.default
            ({ config, pkgs, ... }: {
              services.vscode-server.enable = true;
            })
            
            # 集成 Home Manager
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.wenjiu = import ./home/home.nix;
              
              # 设置备份扩展名，避免文件冲突
              home-manager.backupFileExtension = "backup";
            }
          ];
        };
      };
    };
}
