// Chromatic aberration - shifts R/B channels at screen edges
const float CA_STRENGTH = 0.0025;

vec4 applyCA(vec2 uv) {
    vec4 color = texture(iChannel0, uv);
    float dist = length(uv - 0.5);
    vec2 dir = normalize(uv - 0.5 + vec2(0.0001));
    vec2 offset = dir * CA_STRENGTH * dist;
    color.r = texture(iChannel0, uv + offset).r;
    color.b = texture(iChannel0, uv - offset).b;
    return color;
}
