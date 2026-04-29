// CRT barrel distortion - warps UV to simulate curved screen
const float CRT_CURVATURE = 0.06;

vec2 applyCRT(vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 centered = uv - 0.5;
    float r2 = dot(centered, centered);
    return uv + centered * CRT_CURVATURE * r2;
}
