{
  pkgs,
  ...
}:
{
    home.packages = with pkgs; [
        gemini-cli
        cursor-cli
        opencode
        claude-code
    ];

    xdg.configFile."opencode/opencode.json".text = ''
        {
          "$schema": "https://opencode.ai/config.json",
          "provider": {
            "hajimi": {
              "npm": "@ai-sdk/openai-compatible",
              "name": "hajimi-ai",
              "options": {
                "baseURL": "https://vip.aipro.love/v1",
                "apiKey": "sk-oZhoh4HqIRMK8SeuxNzoLo0Pvd4troN9ut0cVyeBaQUxpXWw",
              },
              "models": {
        "claude-sonnet-4-6": {
                  "name": "Claude Sonnet 4.5 Thinking"
                },
                "claude-opus-4-6": {
                  "name": "Claude Opus 4.6"
                },
                "gemini-2.5-flash": {
                  "name": "Gemini 2.5 Flash"
                },
                "gemini-2.5-pro": {
                  "name": "Gemini 2.5 Pro"
                }
              }
            }
          }
        }
    '';

    # for claude
    programs.nushell.extraConfig = ''
      $env.ANTHROPIC_BASE_URL = "https://vip.aipro.love";
      $env.ANTHROPIC_API_KEY = "sk-oZhoh4HqIRMK8SeuxNzoLo0Pvd4troN9ut0cVyeBaQUxpXWw";
    '';
}
