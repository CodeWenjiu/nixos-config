{
  ...
}:

{
  # Create embedded development group access
  users.groups.embedded = { };

  # udev rules for embedded development probes and boards
  services.udev.extraRules = ''
    # SEGGER J-Link devices
    SUBSYSTEM=="usb", ATTR{idVendor}=="1366", ATTR{idProduct}=="0101", MODE="0660", GROUP="embedded"
    SUBSYSTEM=="usb", ATTR{idVendor}=="1366", ATTR{idProduct}=="0105", MODE="0660", GROUP="embedded"
    SUBSYSTEM=="usb", ATTR{idVendor}=="1366", ATTR{idProduct}=="1015", MODE="0660", GROUP="embedded"
    SUBSYSTEM=="usb", ATTR{idVendor}=="1366", ATTR{idProduct}=="1051", MODE="0660", GROUP="embedded"

    # Raspberry Pi Pico / RP2040 / RP2350 devices
    SUBSYSTEM=="usb", ATTR{idVendor}=="2e8a", ATTR{idProduct}=="0003", MODE="0660", GROUP="embedded"
    SUBSYSTEM=="usb", ATTR{idVendor}=="2e8a", ATTR{idProduct}=="0004", MODE="0660", GROUP="embedded"
    SUBSYSTEM=="usb", ATTR{idVendor}=="2e8a", ATTR{idProduct}=="000a", MODE="0660", GROUP="embedded"
    SUBSYSTEM=="usb", ATTR{idVendor}=="2e8a", ATTR{idProduct}=="000c", MODE="0660", GROUP="embedded"

    # CMSIS-DAP compatible devices (ARM Debug Interface)
    SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", ATTR{idProduct}=="0204", MODE="0660", GROUP="embedded"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", ATTR{idProduct}=="0209", MODE="0660", GROUP="embedded"

    # STMicroelectronics ST-Link devices
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3748", MODE="0660", GROUP="embedded"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374b", MODE="0660", GROUP="embedded"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374e", MODE="0660", GROUP="embedded"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374f", MODE="0660", GROUP="embedded"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3752", MODE="0660", GROUP="embedded"

    # Atmel/Microchip devices
    SUBSYSTEM=="usb", ATTR{idVendor}=="03eb", ATTR{idProduct}=="2111", MODE="0660", GROUP="embedded"
    SUBSYSTEM=="usb", ATTR{idVendor}=="03eb", ATTR{idProduct}=="2140", MODE="0660", GROUP="embedded"

    # FTDI-based debuggers
    SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6010", MODE="0660", GROUP="embedded"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6014", MODE="0660", GROUP="embedded"

    # Black Magic Probe
    SUBSYSTEM=="usb", ATTR{idVendor}=="1d50", ATTR{idProduct}=="6018", MODE="0660", GROUP="embedded"

    # OpenOCD compatible devices
    SUBSYSTEM=="usb", ATTR{idVendor}=="15ba", ATTR{idProduct}=="002a", MODE="0660", GROUP="embedded"
    SUBSYSTEM=="usb", ATTR{idVendor}=="15ba", ATTR{idProduct}=="002b", MODE="0660", GROUP="embedded"

    # ESP32 development boards (USB-to-UART bridges)
    SUBSYSTEM=="usb", ATTR{idVendor}=="10c4", ATTR{idProduct}=="ea60", MODE="0660", GROUP="dialout"
    SUBSYSTEM=="usb", ATTR{idVendor}=="1a86", ATTR{idProduct}=="7523", MODE="0660", GROUP="dialout"

    # Additional common USB-UART bridges
    SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6001", MODE="0660", GROUP="dialout"
    SUBSYSTEM=="usb", ATTR{idVendor}=="067b", ATTR{idProduct}=="2303", MODE="0660", GROUP="dialout"
  '';

  # Enable access to USB devices without root
  security.polkit.enable = true;

  # Allow users in embedded group to access USB devices
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
             action.id == "org.freedesktop.udisks2.encrypted-unlock-system" ||
             action.id == "org.freedesktop.udisks2.eject-media-system" ||
             action.id == "org.freedesktop.udisks2.power-off-drive-system") &&
            subject.isInGroup("embedded")) {
            return polkit.Result.YES;
        }
    });
  '';
}
