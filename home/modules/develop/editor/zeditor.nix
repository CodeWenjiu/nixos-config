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

      theme = "matugen";

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
