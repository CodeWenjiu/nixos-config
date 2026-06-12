{ pkgs, ... }:
{
  # Proper Zed configuration for NixOS
  programs.zed-editor = {
    enable = true;

    # Language servers and tools that Zed needs
    extraPackages = with pkgs; [
      github-mcp-server
    ];

    # Main configuration
    userSettings = {
      # Use nushell as the default terminal shell
      terminal = {
        shell = {
          program = "${pkgs.nushell}/bin/nu";
        };
      };

      colorize_brackets = true;
      always_treat_brackets_as_autoclosed = true;
      show_signature_help_after_edits = true;

      # Agent configuration
      agent = {
        tool_permissions = {
          tools = {
            fetch = {
              default = "allow";
            };
            terminal = {
              default = "allow";
            };
          };
        };
      };

      # Tab settings
      tab_size = 4;
      hard_tabs = false;
      indent_guides = {
        enabled = true;
      };

      # Editor enhancements
      show_whitespaces = "selection";
      cursor_blink = false;
      relative_line_numbers = "disabled";
      scrollbar = {
        show = "auto";
      };
    };

    userKeymaps = [
      {
        context = "Pane";
        unbind = {
          "alt-left" = "pane::GoBack";
          "alt-right" = "pane::GoForward";
        };
      }
      {
        context = "EditPredictionContext > Editor";
        unbind = {
          "alt-left" = "dev::EditPredictionContextGoBack";
          "alt-right" = "dev::EditPredictionContextGoForward";
        };
      }
      {
        context = "Workspace";
        unbind = {
          "ctrl-k ctrl-left" = "workspace::ActivatePaneLeft";
          "ctrl-k ctrl-right" = "workspace::ActivatePaneRight";
          "ctrl-k ctrl-up" = "workspace::ActivatePaneUp";
          "ctrl-k ctrl-down" = "workspace::ActivatePaneDown";
        };
      }
      {
        bindings = {
          "alt-left" = [
            "workspace::ActivatePaneInDirection"
            "Left"
          ];
          "alt-right" = [
            "workspace::ActivatePaneInDirection"
            "Right"
          ];
          "alt-up" = [
            "workspace::ActivatePaneInDirection"
            "Up"
          ];
          "alt-down" = [
            "workspace::ActivatePaneInDirection"
            "Down"
          ];
        };
      }
      {
        context = "Workspace";
        bindings = {
          "alt-shift-h" = "workspace::ActivatePaneLeft";
          "alt-shift-l" = "workspace::ActivatePaneRight";
          "alt-shift-k" = "workspace::ActivatePaneUp";
          "alt-shift-j" = "workspace::ActivatePaneDown";
        };
      }
      {
        context = "Terminal";
        bindings = {
          "alt-shift-h" = "workspace::ActivatePaneLeft";
          "alt-shift-l" = "workspace::ActivatePaneRight";
        };
      }
      {
        context = "Editor && mode == full";
        bindings = {
          "alt-shift-h" = "workspace::ActivatePaneLeft";
          "alt-shift-l" = "workspace::ActivatePaneRight";
        };
      }
    ];
  };

  programs.nushell.extraConfig = ''
    $env.config.buffer_editor = "zeditor";
  '';

  home.packages = with pkgs; [
    package-version-server # which zed required
  ];
}
