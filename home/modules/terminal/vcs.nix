{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    git
    lazygit
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
}
