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
      buffer_font_size = 12;

      buffer_font_fallbacks = [
        "JetBrainsMono Nerd Font"
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
  ];
}
