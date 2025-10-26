{
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins =
      let
        nvim-treesitter-with-plugins = pkgs.vimPlugins.nvim-treesitter.withPlugins (
          treesitter-plugins: with treesitter-plugins; [
            bash
            c
            cpp
            lua
            nix
            python
            rust
          ]
        );
      in
      with pkgs.vimPlugins;
      [
        nvim-treesitter-with-plugins
        nvim-treesitter.withAllGrammars

        nvim-lspconfig
        plenary-nvim
        gruvbox-material
        mini-nvim
      ];
  };

  programs.nushell.extraConfig = ''
    $env.EDITOR = "nvim";
  '';
}
