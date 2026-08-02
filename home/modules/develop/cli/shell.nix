{
  pkgs,
  config,
  ...
}:
{
  programs = {
    nushell = {
      enable = true;

      plugins = with pkgs.nushellPlugins; [
        gstat
        # polars
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

        $env.PATH = ($env.PATH |
            split row (char esep) |
            prepend ${config.home.homeDirectory}/.apps |
            append /usr/bin/env
        )

        def --env sysrebuild [name] {
          let cpu_count = (sys cpu | length);
          let is_laptop = ((ls /sys/class/power_supply/ | where name =~ "BAT" | length) > 0);
          let cores = if $is_laptop { ($cpu_count // 2) } else { $cpu_count };
          sudo nixos-rebuild switch --flake .#($name) --cores $cores --max-jobs 2;
        }

        # Two-tier flake update: core inputs first, peripheral inputs separately.
        # Each input is updated individually so one broken input never blocks the rest.
        def --env sysup-core [] {
          let tier = [nixpkgs home-manager niri noctalia];
          mut failed: list<string> = [];
          for input in $tier {
            nix flake update $input
            if $env.LAST_EXIT_CODE != 0 {
              $failed = ($failed | append $input)
            }
          }
          if ($failed | length) > 0 {
            print -e $"sysup-core: failed to update: ($failed | str join ', ')"
          } else {
            print $"sysup-core: updated ($tier | str join ', ')"
          }
        }

        def --env sysup-extra [] {
          # nixpkgs-lazy: slow-moving pool for non-critical packages
          let tier = [nixpkgs-lazy minegrub-theme vscode-server fcitx5-vinput];
          mut failed: list<string> = [];
          for input in $tier {
            nix flake update $input
            if $env.LAST_EXIT_CODE != 0 {
              $failed = ($failed | append $input)
            }
          }
          if ($failed | length) > 0 {
            print -e $"sysup-extra: failed to update: ($failed | str join ', ')"
          } else {
            print $"sysup-extra: updated ($tier | str join ', ')"
          }
        }

        def --env sysup-all [] {
          nix flake update
        }

        pay-respects nushell --alias ...[fuck] | save -f ~/.config/pay-respects.nu
        source ~/.config/pay-respects.nu
      '';
      shellAliases = {
        c = "clear";
        "cd.." = "cd ..";
        rg = "rg --no-heading --line-number";
        zed = "zeditor";
      };
    };
    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    # see https://starship.rs/config/#prompt
    starship = {
      enable = true;
    };
  };
}
