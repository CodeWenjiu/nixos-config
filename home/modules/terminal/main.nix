{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    ripgrep

    wget
    nettools

    tree
  ];

  # see also https://discourse.nixos.org/t/configure-kitty-with-home-manager/57505/2
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;

    settings = {
      confirm_os_window_close = 0;
      cursor_blink_interval = 0;

      background_opacity = "0.7";
    };

    extraConfig = ''
      map ctrl+c copy_and_clear_or_interrupt
      map ctrl+v paste_from_clipboard
    '';
  };

  programs.zsh.initContent = ''
    bindkey "^H" backward-delete-word
    alias rgl='rg --no-heading --line-number'
  '';

  imports = [
    ./editor.nix
    ./shell.nix
    ./fetch.nix
    ./file_manager.nix
  ];
}
