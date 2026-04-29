// Text edge glow - highlights character contours
const float EDGE_STRENGTH = 0.06;
const vec3 EDGE_COLOR = vec3(0.2, 0.7, 0.4);

vec4 applyEdgeGlow(vec4 color, vec2 uv) {
    vec2 texel = 1.0 / iResolution.xy;
    float c = texture(iChannel0, uv).g;
    float l = texture(iChannel0, uv - vec2(texel.x, 0.0)).g;
    float r = texture(iChannel0, uv + vec2(texel.x, 0.0)).g;
    float t = texture(iChannel0, uv + vec2(0.0, texel.y)).g;
    float b = texture(iChannel0, uv - vec2(0.0, texel.y)).g;
    float edge = (abs(c - l) + abs(c - r) + abs(c - t) + abs(c - b)) * 0.25;
    color.rgb += EDGE_COLOR * edge * EDGE_STRENGTH;
    return color;
}
