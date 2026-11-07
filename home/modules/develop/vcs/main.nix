{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    git
    gh
    gitui

    jujutsu
    jjui
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "wenjiu";
        email = "2784307979@qq.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  xdg.configFile."jj".source = ./jj;

  # gitui reads these from $XDG_CONFIG_HOME/gitui unconditionally; there is no
  # flag needed. Manage the files rather than the directory so an existing
  # ~/.config/gitui keeps whatever else is in it.
  xdg.configFile."gitui/key_bindings.ron".source = ./gitui/key_bindings.ron;
  xdg.configFile."gitui/theme.ron".source = ./gitui/theme.ron;
}
