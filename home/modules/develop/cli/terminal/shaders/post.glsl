// Scanlines, vignette and film grain post-processing
const float SCANLINE_STRENGTH = 0.12;
const float VIGNETTE_STRENGTH = 0.30;
const float GRAIN_STRENGTH = 0.025;

float hash12(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec4 applyPost(vec4 color, vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;

    // Scanlines
    float scanline = 1.0 - SCANLINE_STRENGTH * (1.0 - abs(sin(fragCoord.y * 1.8)));
    color.rgb *= scanline;

    // Vignette
    float dist = length(uv - 0.5) * 1.3;
    float vignette = 1.0 - smoothstep(0.5, 1.0, dist) * VIGNETTE_STRENGTH;
    color.rgb *= vignette;

    // Film grain
    float grain = hash12(uv.yx + fract(iTime * 0.05)) * GRAIN_STRENGTH;
    grain -= GRAIN_STRENGTH * 0.5;
    color.rgb += grain;

    return color;
}
