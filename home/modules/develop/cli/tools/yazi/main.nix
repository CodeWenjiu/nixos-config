{
  pkgs,
  ...
}:
{
  programs.yazi = {
    enable = true;

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
            name = "*";
            run = "git";
          }
          {
            id = "git";
            name = "*/";
            run = "git";
          }
        ];

        prepend_previewers = [
          {
            name = "*.csv";
            run = "rich-preview";
          }

          {
            name = "*.md";
            run = "rich-preview";
          }

          {
            name = "*.rst";
            run = "rich-preview";
          }

          {
            name = "*.ipynb";
            run = "rich-preview";
          }

          {
            name = "*.json";
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
