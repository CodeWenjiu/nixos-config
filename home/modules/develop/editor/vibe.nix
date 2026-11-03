{
  config,
  pkgs,
  ...
}:
let
  # The Web UI is published on the tailnet by modules/tailscale.nix (a root
  # oneshot running `tailscale serve`); dsh itself only needs to know which
  # authority the remote browser will use, or every /api call is rejected by
  # the browser-trust fence.
  dshWebHost = "wenjiu.tail7b861.ts.net";
  dshWebPort = 8080;
in
{
  home.packages = with pkgs; [
    # gemini-cli
    # cursor-cli
    # codex
    # claude-code
    opencode
    deepseek-harness
  ];

  # Long-running Web UI with the tailnet flags baked in. The launch URL carries
  # a one-shot token; read it with:
  #   journalctl --user -u dsh-web -n 40 --no-pager | grep -o 'http[^ ]*'
  systemd.user.services.dsh-web = {
    Unit = {
      Description = "DeepSeek Harness Web UI (tailnet)";
    };
    Service = {
      ExecStart = "${pkgs.deepseek-harness}/bin/dsh web --no-open --port 3080 --public-url http://${dshWebHost}:${toString dshWebPort}/ --trusted-host ${dshWebHost}";
      WorkingDirectory = config.home.homeDirectory;
      Restart = "on-failure";
      RestartSec = 15;
    };
    Install.WantedBy = [ "default.target" ];
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.cache/.bun/bin"
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
