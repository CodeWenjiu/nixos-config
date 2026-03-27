{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    cursor-cli
    claude-code
    gemini-cli
    # aider-chat-full
    # universal-ctags
  ];
}
