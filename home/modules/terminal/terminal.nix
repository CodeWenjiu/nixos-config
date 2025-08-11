{ config, pkgs, ... }:
{
    home.packages = with pkgs; [
        ripgrep
        dust

        wget
        nettools
    ];

    # see also https://discourse.nixos.org/t/configure-kitty-with-home-manager/57505/2
    programs.kitty = {
        enable = true;
        package = pkgs.kitty;

        settings = {
            background_opacity = "0.7";
            confirm_os_window_close = 0;
            background_blur = "1";
        };
        
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
