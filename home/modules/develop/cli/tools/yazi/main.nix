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
        # prepend_fetchers = [
        #   {
        #     id = "git";
        #     url = "*";
        #     run = "git";
        #     group = "file";
        #   }
        #   {
        #     id = "git";
        #     url = "*/";
        #     run = "git";
        #     group = "directory";
        #   }
        # ];

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

    };

    # yazi reads keybindings only from keymap.toml
    # (yazi-config/src/keymap/keymap.rs). A `mgr.prepend_keymap` placed inside
    # yazi.toml is silently ignored, which is why the lazygit chord never fired.
    keymap = {
      mgr.prepend_keymap = [
        {
          on = "<C-y>";
          run = [ "plugin wl-clipboard" ];
        }
        {
          on = [
            "g"
            "i"
          ];
          run = "plugin gitui";
          desc = "run gitui";
        }
      ];
    };

    plugins = {
      inherit (pkgs.yaziPlugins)
        full-border
        git
        gitui
        starship
        rich-preview
        wl-clipboard
        ;
    };

    initLua = ./init.lua;
  };
}
