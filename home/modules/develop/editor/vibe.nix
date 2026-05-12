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
  ];

  # for omo install, user should install omo in .config/opencode directory and modify package.json as file to index.js
  xdg.configFile."opencode" = {
    source = ./opencode;
    recursive = true;
  };
}
