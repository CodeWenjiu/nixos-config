{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    gemini-cli
    cursor-cli
    codex
    opencode
  ];

  xdg.configFile."opencode/opencode.jsonc".text = ''
    {
      "plugin": ["oh-my-openagent"]
    }
  '';

  xdg.configFile."opencode/oh-my-opencode.jsonc".text = ''
    {
      "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/oh-my-opencode.schema.json",

      "agents": {
        "sisyphus": {
          "model": "deepseek/deepseek-v4-pro",
          "fallback_models": [
            "deepseek/deepseek-chat",
            "opencode/big-pickle"
          ]
        },
        "oracle": {
          "model": "deepseek/deepseek-v4-pro"
        },
        "librarian": {
          "model": "deepseek/deepseek-v4-flash",
          "fallback_models": ["opencode/big-pickle"]
        },
        "explore": {
          "model": "deepseek/deepseek-v4-flash",
          "fallback_models": ["opencode/gpt-5-nano"]
        },
        "hephaestus": {
          "model": "deepseek/deepseek-v4-pro"
        },
        "prometheus": {
          "model": "deepseek/deepseek-v4-pro",
          "prompt_append": "Leverage deep & quick agents heavily, always in parallel."
        }
      },

      "background_task": {
        "providerConcurrency": {
          "deepseek": 5
        }
      },

      "experimental": {
        "aggressive_truncation": true,
        "task_system": true
      }
    }
  '';
}
