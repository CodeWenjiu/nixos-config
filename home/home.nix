{ config, pkgs, ... }:
{
  home.username = "wenjiu";
  home.homeDirectory = "/home/wenjiu";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    zip
  ];

  imports = [
    ./modules/editor.nix
    ./modules/vcs.nix
  ];

  programs = {
    firefox = {
      enable = true;
      profiles.default = {
        settings = {
          "browser.startup.homepage" = "https://www.google.com";
          "browser.search.defaultenginename" = "Google";
        };
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
  };
}