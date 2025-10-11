{ pkgs, ... }:
{
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

      github-mcp-server

      tinymist # docs
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

      buffer_font_fallbacks = [
        "JetBrainsMono Nerd Font"
        "Source Han Sans SC"
      ];

      # "experimental.theme_overrides" = {
      #   "background.appearance" = "blurred";
      #   "background" = "#000000bb";
      #   "panel.background" = "#00000000";
      #   "editor.background" = "#00000000";
      #   "tab_bar.background" = "#00000000";
      #   "terminal.background" = "#00000000";
      #   "toolbar.background" = "#00000000";
      #   "tab.inactive_background" = "#00000000";
      #   "tab.active_background" = "#3f3f4650";
      #   "border" = "#00000000";
      #   "status_bar.background" = "#000000BB";
      #   "title_bar.background" = "#000000BB";
      #   "border.variant" = "#00000000";
      #   "scrollbar.track.background" = "#00000000";
      #   "scrollbar.track.border" = "#00000000";
      #   "scrollbar.thumb.border" = "#00000000";
      #   "elevated_surface.background" = "#90";
      #   "surface.background" = "#90";
      #   "editor.active_line_number" = "#ffffffcc";
      #   "editor.gutter.background" = "#00000000";
      #   "editor.indent_guide" = "#ffffff30";
      #   "editor.indent_guide_active" = "#ffffff80";
      #   "editor.line_number" = "#ffffff80";
      #   "editor.active_line.background" = "#3f3f4640";
      # };

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

    userKeymaps = [
      {
        # context = "Terminal";
        # bindings = {
        #   ctrl-c = "terminal::Copy"; # impact signal handler
        # };
      }
    ];
  };

  programs.zsh.initContent = ''
    alias zed='zeditor' # convenient for me
  '';

  home.packages = with pkgs; [
    package-version-server # which zed required
    tinymist
  ];
}
