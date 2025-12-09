{
  config,
  pkgs,
  ...
}:
{
  home.sessionPath = [
    "/run/wrappers/bin"
    "/home/${config.home.username}/.nix-profile/bin"
    "/nix/var/nix/profiles/default/bin"
    "/run/current-system/sw/bin"
  ];

  programs = {
    bash = {
      enable = true;
    };

    nushell = {
      enable = true;

      plugins = with pkgs.nushellPlugins; [
        gstat
        polars
      ];

      extraConfig = ''
        mkdir ($nu.data-dir | path join "vendor/autoload")
        starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

        let carapace_completer = {|spans|
            carapace $spans.0 nushell ...$spans | from json
        }

        $env.config = {
            show_banner: false,
            completions: {
                case_sensitive: false # case-sensitive completions
                quick: true    # set to false to prevent auto-selecting completions
                partial: true    # set to false to prevent partial filling of the prompt
                algorithm: "fuzzy"    # prefix or fuzzy
                external: {
                    # set to false to prevent nushell looking into $env.PATH to find more suggestions
                    enable: true
                    # set to lower can improve completion performance at the cost of omitting some options
                    max_results: 100
                    completer: $carapace_completer # check 'carapace_completer'
                }
            }
        }

        let nixos_paths = [
          "/run/wrappers/bin",
          "/home/${config.home.username}/.nix-profile/bin",
          "/etc/profiles/per-user/${config.home.username}/bin",
          "/nix/var/nix/profiles/default/bin",
          "/run/current-system/sw/bin"
        ]

        $env.PATH = ($env.PATH | split row (char esep) | uniq)

        def --env sysrebuild [name] {
          sudo nixos-rebuild switch --flake .#($name);
        }

        $env.config.show_banner = false

        pay-respects nushell --alias ...[fuck] | save -f ~/.config/pay-respects.nu
        source ~/.config/pay-respects.nu

        # where this f**k come from???
        hide-env http_proxy
        hide-env https_proxy
        hide-env HTTP_PROXY
        hide-env HTTPS_PROXY
      '';
      shellAliases = {
        c = "clear";
        "cd.." = "cd ..";
        rg = "rg --no-heading --line-number";
      };
    };
    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    # see https://starship.rs/config/#prompt
    starship = {
      enable = true;
      settings = {
        scan_timeout = 300;
        command_timeout = 1000;
      };
    };
  };
}
