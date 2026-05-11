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

  # opencode.jsonc needs to be writable by opencode's plugin manager,
  # so it is NOT managed by xdg.configFile (which creates read-only Nix store symlinks).
  # Instead, let opencode's `plugin -g` command create and manage it at runtime.

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

  home.activation.fixOpencodeConfig = ''
    CFG="$HOME/.config/opencode/opencode.jsonc"
    if [ -f "$CFG" ]; then
      if ! grep -q '"oh-my-opencode"' "$CFG"; then
        echo '{"$schema":"https://opencode.ai/config.json","plugin":["oh-my-opencode"]}' > "$CFG"
      fi
    else
      echo '{"$schema":"https://opencode.ai/config.json","plugin":["oh-my-opencode"]}' > "$CFG"
    fi
  '';

  home.activation.installOhMyOpencode = ''
    run ${pkgs.opencode}/bin/opencode plugin -g oh-my-opencode
  '';
}
