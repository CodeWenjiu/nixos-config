{ pkgs, ... }:
{
  programs.nushell.extraConfig = ''
    $env.config.buffer_editor = "zed"
  '';
}
