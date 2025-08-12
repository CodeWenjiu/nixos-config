{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    git
    lazygit

    jujutsu
    jjui
  ];

  programs.git = {
    enable = true;
    userName = "wenjiu";
    userEmail = "2784307979@qq.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  xdg.configFile."jj".source = ./jj;
}
