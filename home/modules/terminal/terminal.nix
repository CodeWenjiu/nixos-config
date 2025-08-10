{ config, pkgs, ... }:
{
    home.packages = with pkgs; [
	    kitty
    
        ripgrep
        dust

        wget
        nettools
    ];

    imports = [
        ./editor.nix
        ./shell.nix
        ./vcs.nix
        ./fetch.nix
        ./file_manager.nix
    ];
}
