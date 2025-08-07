{ config, pkgs, ... }:
{
    home.packages = with pkgs; [
        yazi-unwrapped

        # fetch
        macchina
        onefetch
        
        ripgrep

        wget
        nettools
    ];

    # 可选：如果你想在这里设置工具相关的环境变量
    # 但建议在主 home.nix 中统一管理
    # home.sessionVariables = {
    #   sysfetch = "macchina";
    # };
}