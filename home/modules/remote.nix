{ config, pkgs, ... }:
{
    home.packages = with pkgs; [
        todesk
    ];
}
