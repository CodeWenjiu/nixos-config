{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    gemini-cli
    cursor-cli
    codex
    opencode

    # mcp
    mcp-nixos
    github-mcp-server
    playwright-mcp
    # mcp-server-memory and mcp-server-sequential-thinking share
    # lib/node_modules/@modelcontextprotocol/servers/ -> buildEnv conflict.
    # Referenced by store path in mcp.json below; no need in home.packages.
  ];

  # for omo install, user should install omo in .config/opencode directory and modify package.json as file to index.js
  xdg.configFile."opencode" = {
    source = ./opencode;
    recursive = true;
  };

  home.file.".codex/config.toml".text = ''
    model_provider = "custom"
    model = "gpt-5.5"

    model_reasoning_effort = "xhigh"
    model_reasoning_summary = "detailed"
    model_supports_reasoning_summaries = true
    service_tier = "fast"

    [model_providers.custom]
    name = "custom"
    wire_api = "responses"
    requires_openai_auth = true
    base_url = "https://vip.aipro.love/v1"

    [projects."/home/wenjiu/project/chip-dev/remu"]
    trust_level = "trusted"

    [tui.model_availability_nux]
    "gpt-5.5" = 2

    [notice.model_migrations]
    "gpt-5.3-codex" = "gpt-5.4"

    [mcp_servers.context7]
    command = "npx"
    args = ["-y", "@upstash/context7-mcp"]

    [mcp_servers.github]
    url = "https://api.githubcopilot.com/mcp/"
    bearer_token_env_var = "GITHUB_PAT_TOKEN"

    [mcp_servers.nixos]
    command = "${pkgs.mcp-nixos}/bin/mcp-nixos"

    [mcp_servers.playwright]
    command = "${pkgs.playwright-mcp}/bin/playwright-mcp"
    args = ["--user-data-dir", "/home/wenjiu/.cache/playwright-mcp"]

    [mcp_servers.thinking]
    command = "${pkgs.mcp-server-sequential-thinking}/bin/mcp-server-sequential-thinking"
  '';

  home.file.".deepseek/mcp.json".text = builtins.toJSON {
    timeouts = {
      connect_timeout = 10;
      execute_timeout = 60;
      read_timeout = 120;
    };
    servers = {
      nixos = {
        command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
        args = [ ];
        env = { };
        url = null;
        disabled = false;
      };
      github = {
        command = "${pkgs.github-mcp-server}/bin/github-mcp-server";
        args = [ ];
        env = { };
        url = null;
        disabled = false;
      };
      playwright = {
        command = "${pkgs.playwright-mcp}/bin/playwright-mcp";
        args = [
          "--user-data-dir"
          "/home/wenjiu/.cache/playwright-mcp"
        ];
        env = { };
        url = null;
        disabled = false;
      };
      memory = {
        command = "${pkgs.mcp-server-memory}/bin/mcp-server-memory";
        args = [ ];
        env = {
          MEMORY_FILE_PATH = "/home/wenjiu/.deepseek/mcp-memory.jsonl";
        };
        url = null;
        disabled = false;
      };
      sequential-thinking = {
        command = "${pkgs.mcp-server-sequential-thinking}/bin/mcp-server-sequential-thinking";
        args = [ ];
        env = { };
        url = null;
        disabled = false;
      };
    };
  };
}
