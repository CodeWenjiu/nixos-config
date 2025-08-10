{ config, pkgs, ... }:
{
    home.packages = with pkgs; [
        readest
	obsidian
    ];
}
