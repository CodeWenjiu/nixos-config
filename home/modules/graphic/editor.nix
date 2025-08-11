{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
      ];

      keybindings = [
        {
          "key" = "ctrl+c";
          "command" = "workbench.action.terminal.copySelection";
          "when" = "terminalFocus && terminalTextSelected";
        }

        {
          "key" = "ctrl+v";
          "command" = "workbench.action.terminal.paste";
          "when" = "terminalFocus";
        }

        # not work :(
        {
          "key" = "ctrl+shift+c";
          "command" = "-";
          "when" = "terminalFocus && terminalTextSelected";
        }

        {
          "key" = "ctrl+shift+v";
          "command" = "-";
          "when" = "terminalFocus";
        }

        {
          "key" = "ctrl+space";
          "command" = "-";
          "when" = "editorTextFocus";
        }
      ];
    };
  };

  # Proper Zed configuration for NixOS
  programs.zed-editor = {
    enable = true;

    # Language servers and tools that Zed needs
    extraPackages = with pkgs; [
      # Language servers
      nixd # Nix LSP
      rust-analyzer # Rust LSP

      # Formatters
      nixpkgs-fmt # Nix formatter
      prettierd # JavaScript/TypeScript formatter

      # Other tools
      git # Version control
    ];

    # Main configuration
    userSettings = {
      # Agent configuration
      agent = {
        default_model = {
          provider = "zed.dev";
          model = "claude-sonnet-4";
        };
        always_allow_tool_actions = true;
      };

      # Font fallbacks for Chinese support
      buffer_font_fallbacks = [
        "CaskaydiaCove Nerd Font Mono"
        "Source Han Sans SC"
      ];

      # Text processing
      preferred_line_length = 100;
      soft_wrap = "preferred_line_length";

      # Tab settings
      tab_size = 4;
      hard_tabs = false;
      indent_guides = {
        enabled = true;
      };

      # Editor enhancements
      show_whitespaces = "selection";
      cursor_blink = false;
      relative_line_numbers = false;
      scrollbar = {
        show = "auto";
      };
    };
  };
}
