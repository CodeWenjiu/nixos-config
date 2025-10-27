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

      metals # Scala LSP

      glsl_analyzer # OpenGL Shader Script
    ];

    # Main configuration
    userSettings = {
      # Agent configuration
      agent = {
        default_model = {
          provider = "copilot_chat";
          model = "claude-sonnet-4";
        };
        always_allow_tool_actions = true;
      };

      buffer_font_family = "JetBrains Mono";
      terminal = {
        font_family = "JetBrains Mono";
      };

      buffer_font_fallbacks = [
        # Core programming fonts (already set as main font)
        "JetBrains Mono"
        "Fira Code"
        "Source Code Pro"

        # UI Sans for mixed content
        "Inter"
        "Source Sans 3"

        # CJK coverage (region-specific)
        "Source Han Sans SC"
        "Source Han Sans TC"

        # Broad Unicode coverage
        "Noto Sans"
        "Noto Sans Mono"

        # Script-specific fonts
        "Noto Sans Arabic"
        "Noto Sans Hebrew"
        "Noto Sans Devanagari"
        "Noto Sans Thai"

        # Math symbols
        "STIX Two Math"

        # Color emoji
        "Noto Color Emoji"

        # System fallbacks
        "DejaVu Sans Mono"
        "Liberation Mono"
      ];

      theme = "Ayu Dark";

      "experimental.theme_overrides" = {
        "background.appearance" = "blurred";
        "background" = "#09090bBB";
        "panel.background" = "#11111111";
        "editor.background" = "#00000000";
        "tab_bar.background" = "#00000000";
        "terminal.background" = "#00000000";
        "toolbar.background" = "#00000000";
        "tab.inactive_background" = "#00000000";
        "tab.active_background" = "#3f3f4650";
        "border" = "#00000000";
        "status_bar.background" = "#00000000";
        "title_bar.background" = "#00000000";
        "border.variant" = "#00000000";
        "scrollbar.track.background" = "#52525b20";
        "scrollbar.track.border" = "#00000000";
        "scrollbar.thumb.background" = "#52525b30";
        "scrollbar.thumb.border" = "#00000000";
        "elevated_surface.background" = "#00000090";
        "surface.background" = "#00000090";
        "editor.active_line_number" = "#ffffffcc";
        "editor.gutter.background" = "#00000000";
        "editor.indent_guide" = "#ffffff30";
        "editor.indent_guide_active" = "#ffffff80";
        "editor.line_number" = "#ffffff80";
        "editor.active_line.background" = "#3f3f4640";
      };

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

  programs.nushell.extraConfig = ''
    $env.config.buffer_editor = "zeditor"
  '';

  home.packages = with pkgs; [
    package-version-server # which zed required
    tinymist
  ];
}
