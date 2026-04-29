{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    gemini-cli
    cursor-cli
    codex
    opencode
    claude-code
  ];
}
