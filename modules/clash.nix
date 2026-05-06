{
  pkgs,
  ...
}:
{
  # Uncomment below if you need proxy environment variables
  # environment.variables = {
  #   # proxy settings
  #   HTTPS_PROXY = "http://127.0.0.1:7897";
  #   HTTP_PROXY = "http://127.0.0.1:7897";
  #   http_proxy = "http://127.0.0.1:7897";
  #   https_proxy = "http://127.0.0.1:7897";
  # };

  environment.systemPackages = with pkgs; [
    clash-verge-rev
    keybinder # for global hotkeys
  ];

  programs.clash-verge = {
    enable = true;
    autoStart = true;
    serviceMode = true;
    tunMode = true;
  };
}
