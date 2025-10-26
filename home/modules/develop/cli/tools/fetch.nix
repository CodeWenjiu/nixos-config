{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    macchina
    onefetch
    bottom
  ];

  xdg.configFile."macchina/themes/myt.toml".text = ''
    hide_ascii = false
    spacing = 2
    padding = 0
    separator = ">"
    key_color = "Yellow"
    separator_color = "Blue"

    [bar]
    glyph = "●"
    symbol_open = "("
    symbol_close = ")"
    hide_delimiters = true
    visible = true

    [box]
    border = "rounded"
    visible = true

    [palette]
    type            = "Light"
    glyph           = "●"
    spacing         = 2
    visible         = true

    [box.inner_margin]
    x = 2
    y = 1

    [randomize]
    key_color = false
    separator_color = false

    [keys]
    host = "Host"
    kernel = "Kernel"
    battery = "Battery"
    os = "OS"
    de = "DE"
    wm = "WM"
    distro = "Distro"
    terminal = "Terminal"
    shell = "Shell"
    packages = "Packages"
    uptime = "Uptime"
    memory = "Memory"
    machine = "Machine"
    local_ip = "IP"
    backlight = "Brightness"
    resolution = "Resolution"
    cpu_load = "CPU Load"
    cpu = "CPU"
    gpu = "GPU"
    disk_space = "Disk Space"
  '';

  xdg.configFile."macchina/macchina.toml".text = ''
    theme = "myt"
  '';

  programs.nushell.shellAliases = {
    sysfetch = "macchina";
    gitfetch = "onefetch";
    systop = "btm";
  };
}
