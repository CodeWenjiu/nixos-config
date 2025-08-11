{ config, pkgs, ... }:
{
    home.packages = with pkgs; [
        ripgrep
        dust

        wget
        nettools
    ];

    programs.kitty = {
        enable = true;
        package = pkgs.kitty;

        extraConfig = ''
        map ctrl+c copy_and_clear_or_interrupt
        map ctrl+v paste_from_clipboard
        '';
    };

    imports = [
        ./editor.nix
        ./shell.nix
        ./vcs.nix
        ./fetch.nix
        ./file_manager.nix
    ];
}
