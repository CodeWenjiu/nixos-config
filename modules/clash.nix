{ config, pkgs, ... }:
{
  environment.variables = {
    # wayland settings
    NIXOS_OZONE_WL = "1";

    # proxy settings
    HTTPS_PROCY = "http://127.0.0.1:7897";
    HTTP_PROXY = "http://127.0.0.1:7897";
    http_procy = "http://127.0.0.1:7897";
    https_procy = "http://127.0.0.1:7897";
  };

  environment.systemPackages = with pkgs; [
    clash-verge-rev
    # clashtui 
    # clash-nyanpasu
    # gui-for-clash
  ];
}