// Cursor spotlight - brightens area around cursor
const float SPOTLIGHT_RADIUS = 0.25;
const float SPOTLIGHT_STRENGTH = 0.18;
const float SPOTLIGHT_AMBIENT = 0.80;

vec4 applySpotlight(vec4 color, vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 cursorUV = iCurrentCursor.xy / iResolution.xy;
    float dist = length(uv - cursorUV);
    float brightness = SPOTLIGHT_AMBIENT + SPOTLIGHT_STRENGTH * (1.0 - smoothstep(0.0, SPOTLIGHT_RADIUS, dist));
    color.rgb *= brightness;
    return color;
}
