{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    git
    gh
    lazygit

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
}
