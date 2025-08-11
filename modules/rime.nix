{ pkgs, ... }:

let
  # Catppuccin Mocha colors in BGR format (for rime)
  # Convert from RGB hex to BGR hex by reversing the color order
  colors = {
    # Base colors
    crust = "0x1b1111"; # #11111b -> BGR
    mantle = "0x251818"; # #181825 -> BGR
    base = "0x2e1e1e"; # #1e1e2e -> BGR
    surface0 = "0x443132"; # #313244 -> BGR
    surface1 = "0x5a4745"; # #45475a -> BGR
    surface2 = "0x705b58"; # #585b70 -> BGR

    # Text colors
    text = "0xf4d6cd"; # #cdd6f4 -> BGR
    subtext1 = "0xdec2ba"; # #bac2de -> BGR
    subtext0 = "0xc8ada6"; # #a6adc8 -> BGR
    overlay2 = "0xb29993"; # #9399b2 -> BGR
    overlay1 = "0x9c847f"; # #7f849c -> BGR
    overlay0 = "0x86706c"; # #6c7086 -> BGR

    # Accent colors
    lavender = "0xfebeb4"; # #b4befe -> BGR
    blue = "0xfab489"; # #89b4fa -> BGR
    sapphire = "0xecc774"; # #74c7ec -> BGR
    sky = "0xebdc89"; # #89dceb -> BGR
    teal = "0xd5e294"; # #94e2d5 -> BGR
    green = "0xa1e3a6"; # #a6e3a1 -> BGR
    yellow = "0xafe2f9"; # #f9e2af -> BGR
    peach = "0x87b3fa"; # #fab387 -> BGR
    maroon = "0xaca0eb"; # #eba0ac -> BGR
    red = "0xa8b8f3"; # #f38ba8 -> BGR
    mauve = "0xf7a6cb"; # #cba6f7 -> BGR
    pink = "0xe7c2f5"; # #f5c2e7 -> BGR
    flamingo = "0xcdc2f2"; # #f2cdcd -> BGR
    rosewater = "0xdce0f5"; # #f5e0dc -> BGR
  };

  rimeColorScheme = ''
    patch:
      "preset_color_schemes/catppuccin_mocha":
        name: "Catppuccin Mocha"
        author: "Generated from Stylix"

        # Background and borders
        back_color: ${colors.base}
        border_color: ${colors.surface0}

        # Text colors
        text_color: ${colors.text}
        candidate_text_color: ${colors.text}
        comment_text_color: ${colors.subtext0}
        label_color: ${colors.overlay1}

        # Highlighted/selected item colors
        hilited_back_color: ${colors.surface1}
        hilited_candidate_back_color: ${colors.blue}
        hilited_candidate_text_color: ${colors.base}
        hilited_candidate_label_color: ${colors.base}
        hilited_comment_text_color: ${colors.subtext1}
        hilited_text_color: ${colors.blue}

        # Layout settings
        horizontal: true
        inline_preedit: true
        candidate_format: "%c %@"

        # Visual settings
        corner_radius: 8
        hilited_corner_radius: 6
        border_height: 4
        border_width: 4
        line_spacing: 6
        spacing: 8

        # Font settings (use system fonts configured by stylix)
        font_face: "CaskaydiaCove Nerd Font Mono"
        font_point: 14
        label_font_point: 12

      "style/color_scheme": "catppuccin_mocha"
  '';
in
{
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-chinese-addons
      rime-data
      fcitx5-gtk
    ];
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  # Font configuration with fallback support
  fonts = {
    packages = with pkgs; [
      # Already included by Stylix, but explicitly listed for clarity
      nerd-fonts.caskaydia-cove
      source-han-sans
      source-han-serif
      noto-fonts-color-emoji
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [
          "CaskaydiaCove Nerd Font Mono"
          "Source Han Sans SC"
        ];
        sansSerif = [
          "Source Han Sans SC"
          "Noto Sans"
        ];
        serif = [
          "Source Han Serif SC"
          "Noto Serif"
        ];
      };
    };
  };

  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  # Create user-level rime configuration
  # This configuration will be available for all users
  environment.etc."skel/.local/share/fcitx5/rime/default.custom.yaml" = {
    text = rimeColorScheme;
    mode = "0644";
  };

  # Ensure the rime user directory exists and copy configuration for existing users
  system.activationScripts.setupRimeConfig = ''
        for user_home in /home/*; do
          if [ -d "$user_home" ] && [ -d "$user_home/.config" ]; then
            user=$(basename "$user_home")
            rime_dir="$user_home/.local/share/fcitx5/rime"

            # Create directory structure
            mkdir -p "$rime_dir"

            # Copy configuration
            cat > "$rime_dir/default.custom.yaml" << 'EOF'
    ${rimeColorScheme}
    EOF

            # Set proper ownership
            chown -R "$user:users" "$user_home/.local/share/fcitx5" 2>/dev/null || true
          fi
        done
  '';

  # Also create a squirrel.custom.yaml for macOS-style rime configurations
  # that might be used by fcitx5-rime
  system.activationScripts.setupRimeSquirrelConfig = ''
        for user_home in /home/*; do
          if [ -d "$user_home" ] && [ -d "$user_home/.config" ]; then
            user=$(basename "$user_home")
            rime_dir="$user_home/.local/share/fcitx5/rime"

            # Create squirrel configuration for better compatibility
            cat > "$rime_dir/squirrel.custom.yaml" << 'EOF'
    ${rimeColorScheme}
    EOF

            chown -R "$user:users" "$user_home/.local/share/fcitx5" 2>/dev/null || true
          fi
        done
  '';
}
