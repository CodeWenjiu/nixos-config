{ pkgs, ... }:
{
  programs.nushell.extraConfig = ''
    $env.config.buffer_editor = "zed"
  '';

  home.packages = with pkgs; [
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

    ruff
  ];
}
