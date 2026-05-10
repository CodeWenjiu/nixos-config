{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.sessionPath = [
    "/run/wrappers/bin"
    "/home/${config.home.username}/.nix-profile/bin"
    "/nix/var/nix/profiles/default/bin"
    "/run/current-system/sw/bin"
  ];

  home.activation = {
    pay-respects-init = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${lib.getExe pkgs.pay-respects} nushell --alias ...[fuck] > $HOME/.config/pay-respects.nu
    '';
  };

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

        $env.config.show_banner = false
        $env.config.completions = {
            case_sensitive: false
            quick: true
            partial: true
            algorithm: "fuzzy"
            external: {
                enable: true
                max_results: 100
                completer: $carapace_completer
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

        source ~/.config/pay-respects.nu
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
