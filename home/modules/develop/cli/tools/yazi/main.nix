{
  pkgs,
  ...
}:
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";

    settings = {
      preview = {
        image_quality = 90;
      };

      tasks = {
        image_alloc = 0;
      };

      plugin = {
        prepend_fetchers = [
          {
            id = "git";
            url = "*";
            run = "git";
            group = "file";
          }
          {
            id = "git";
            url = "*/";
            run = "git";
            group = "directory";
          }
        ];

        prepend_previewers = [
          {
            url = "*.csv";
            run = "rich-preview";
          }

          {
            url = "*.md";
            run = "rich-preview";
          }

          {
            url = "*.rst";
            run = "rich-preview";
          }

          {
            url = "*.ipynb";
            run = "rich-preview";
          }

          {
            url = "*.json";
            run = "rich-preview";
          }
        ];
      };

      mgr = {
        prepend_keymap = [
          {
            on = "<C-y>";
            run = [ "plugin wl-clipboard" ];
          }
          {
            on = [
              "g"
              "i"
            ];
            run = "plugin lazygit";
            desc = "run lazygit";
          }
        ];
      };
    };

    plugins = {
      inherit (pkgs.yaziPlugins)
        full-border
        git
        lazygit
        starship
        rich-preview
        wl-clipboard
        ;
    };

    initLua = ./init.lua;
  };
}
