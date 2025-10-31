{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    firefox
  ];

  programs.firefox = {
    enable = true;

    profiles.default = {
      settings = {
        "browser.startup.homepage" = "https://www.google.com";
        "browser.search.defaultenginename" = "Google";
      };
    };
  };

  home.sessionVariables = {
    BROWSER = "firefox";
  };
}
