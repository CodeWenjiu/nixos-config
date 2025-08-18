{ pkgs, ... }:
{
  # Bootloader.
  # systemd
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # grub
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      # theme = (
      #   pkgs.sleek-grub-theme.override {
      #     withStyle = "dark";
      #     withBanner = "Hello WenJiu!";
      #   }
      # );
      minegrub-theme = {
        enable = true;
        splash = "Hello Wenjiu!";
        background = "background_options/1.8  - [Classic Minecraft].png";
        boot-options-count = 4;
      };
    };
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 10; # Reduce swappiness to avoid excessive swapping.
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelModules = [ "uvcvideo" ];
}
