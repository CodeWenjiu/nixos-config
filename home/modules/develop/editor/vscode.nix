{
  pkgs,
  ...
}:{
    wenjiu.lazyPackages = [ "vscode" ];

    home.packages = with pkgs; [
      vscode
    ];
  }
