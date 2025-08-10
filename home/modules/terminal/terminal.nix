{ config, pkgs, ... }:
{
    home.packages = with pkgs; [
	    kitty
    ];

    imports = [
        ./editor.nix
        ./shell.nix
        ./vcs.nix
        ./tools.nix
    ];
}
