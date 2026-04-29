{
  ...
}:
let
  crtSrc = builtins.readFile ./shaders/crt.glsl;
  caSrc = builtins.readFile ./shaders/ca.glsl;
  glowSrc = builtins.readFile ./shaders/glow.glsl;
  trailSrc = builtins.readFile ./shaders/trail.glsl;
  edgeglowSrc = builtins.readFile ./shaders/edgeglow.glsl;
  spotlightSrc = builtins.readFile ./shaders/spotlight.glsl;
  postSrc = builtins.readFile ./shaders/post.glsl;
in
{
  programs.ghostty = {
    enable = true;
  };

  programs.kitty.enable = true; # for instead

  xdg.configFile."ghostty/config".text = ''
    window-decoration = none
    cursor-style-blink = false
    background-opacity = 0.7
    background-opacity-cells = true
    background-blur = true

    keybind = ctrl+backspace=text:\x17

    theme = matugen
    custom-shader = ~/.config/ghostty/shaders/shader.glsl
    custom-shader-animation = true
  '';

  xdg.configFile."ghostty/shaders/crt.glsl".source = ./shaders/crt.glsl;
  xdg.configFile."ghostty/shaders/ca.glsl".source = ./shaders/ca.glsl;
  xdg.configFile."ghostty/shaders/glow.glsl".source = ./shaders/glow.glsl;
  xdg.configFile."ghostty/shaders/trail.glsl".source = ./shaders/trail.glsl;
  xdg.configFile."ghostty/shaders/edgeglow.glsl".source = ./shaders/edgeglow.glsl;
  xdg.configFile."ghostty/shaders/spotlight.glsl".source = ./shaders/spotlight.glsl;
  xdg.configFile."ghostty/shaders/post.glsl".source = ./shaders/post.glsl;
  xdg.configFile."ghostty/shaders/shader.glsl".text = ''
    // based on https://gist.github.com/chardskarth/95874c54e29da6b5a36ab7b50ae2d088
    ${crtSrc}

    ${caSrc}

    ${glowSrc}

    ${trailSrc}

    ${edgeglowSrc}

    ${spotlightSrc}

    ${postSrc}

    void mainImage(out vec4 fragColor, in vec2 fragCoord) {
        vec2 uv = fragCoord / iResolution.xy;
        vec2 warpedUV = applyCRT(fragCoord);

        fragColor = applyCA(warpedUV);
        fragColor = applyGlow(fragColor, warpedUV);
        fragColor = applyTrail(fragColor, fragCoord);
        fragColor = applyEdgeGlow(fragColor, warpedUV);
        fragColor = applySpotlight(fragColor, fragCoord);
        fragColor = applyPost(fragColor, fragCoord);
    }
  '';
}
