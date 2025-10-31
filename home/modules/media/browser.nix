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

      search.engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
        "Nix Options" = {
          definedAliases = [ "@no" ];
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
        };
      };
    };
  };

  home.sessionVariables = {
    BROWSER = "firefox";
  };
}
