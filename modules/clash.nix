{ config, pkgs, ... }:
{
  # environment.variables = {
  #   # proxy settings
  #   HTTPS_PROCY = "http://127.0.0.1:7897";
  #   HTTP_PROXY = "http://127.0.0.1:7897";
  #   http_procy = "http://127.0.0.1:7897";
  #   https_procy = "http://127.0.0.1:7897";
  # };

  environment.systemPackages = with pkgs; [
    clash-verge-rev
  ];

  programs.clash-verge = {
    enable = true;
    autoStart = true;
    serviceMode = true;
    tunMode = true;
  };
}
