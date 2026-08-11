// based on https://gist.github.com/chardskarth/95874c54e29da6b5a36ab7b50ae2d088

// Glow effect constants
const vec2 GLOW_STEP_BASE = vec2(2.0);
const float GLOW_CONTRIBUTION = 0.15;
const float GLOW_THRESHOLD = 0.3;

const vec3[16] samples = vec3[16](
    vec3(0.1693761725038636, 0.9855514761735895, 1.0),
    vec3(-1.333070830962943, 0.4721463328627773, 0.7071067811865475),
    vec3(-0.8464394909806497, -1.51113870578065, 0.5773502691896258),
    vec3(1.554155680728463, -1.2588090085709776, 0.5),
    vec3(1.681364377589461, 1.4741145918052656, 0.4472135954999579),
    vec3(-1.2795157692199817, 2.088741103228784, 0.4082482904638631),
    vec3(-2.4575847530631187, -0.9799373355024756, 0.3779644730092272),
    vec3(0.5874641440200847, -2.7667464429345077, 0.35355339059327373),
    vec3(2.997715703369726, 0.11704939884745152, 0.3333333333333333),
    vec3(0.41360842451688395, 3.1351121305574803, 0.31622776601683794),
    vec3(-3.167149933769243, 0.9844599011770256, 0.30151134457776363),
    vec3(-1.5736713846521535, -3.0860263079123245, 0.2886751345948129),
    vec3(2.888202648340422, -2.1583061557896213, 0.2773500981126146),
    vec3(2.7150778983300325, 2.5745586041105715, 0.2672612419124244),
    vec3(-2.1504069972377464, 3.2211410627650165, 0.2581988897471611),
    vec3(-3.6548858794907493, -1.6253643308191343, 0.25)
);

float lum(vec4 c) {
    return dot(c.rgb, vec3(0.299, 0.587, 0.114));
}

vec4 applyGlow(vec4 baseColor, vec2 uv) {
    vec4 color = baseColor;
    vec2 step_size = GLOW_STEP_BASE / iResolution.xy;

    for (int i = 0; i < 16; i++) {
        vec3 s = samples[i];
        vec4 c = texture(iChannel0, uv + s.xy * step_size);
        float l = lum(c);

        float contribution = step(GLOW_THRESHOLD, l) * l * s.z * GLOW_CONTRIBUTION;
        color += contribution * c;
    }

    return color;
}

// Trail effect constants
const vec2 OFFSET_FACTOR = vec2(-0.5, 0.5);
const float AA_WIDTH = 2.0;
const vec4 TRAIL_COLOR = vec4(1.0, 1.0, 1.0, 1.0);
const vec4 TRAIL_COLOR_ACCENT = vec4(0.0, 0.0, 0.0, 1.0);
const float DURATION = 0.5;
const float OPACITY = 0.2;
const float DRAW_THRESHOLD = 1.5;
const bool HIDE_TRAILS_ON_THE_SAME_LINE = false;

float ease(float x) {
    float inv_x = 1.0 - x;
    float inv_x2 = inv_x * inv_x;
    float inv_x4 = inv_x2 * inv_x2;
    return inv_x4 * inv_x4 * inv_x2;
}

float getSdfRectangle(vec2 p, vec2 center, vec2 halfSize) {
    vec2 d = abs(p - center) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float seg(vec2 p, vec2 a, vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    float dot_ee = dot(e, e);
    vec2 proj = a + e * clamp(dot(w, e) / dot_ee, 0.0, 1.0);
    float segd = dot(p - proj, p - proj);
    d = min(d, segd);

    float cross_product = e.x * w.y - e.y * w.x;
    float c0 = step(0.0, p.y - a.y);
    float c1 = step(p.y, b.y);
    float c2 = step(0.0, cross_product);

    float condition = c0 * c1 * c2;
    float inv_condition = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    s *= mix(1.0, -1.0, step(0.5, condition + inv_condition));

    return d;
}

float getSdfParallelogram(vec2 p, vec2 v0, vec2 v1, vec2 v2, vec2 v3) {
    float s = 1.0;
    float d = dot(p - v0, p - v0);

    d = seg(p, v0, v3, s, d);
    d = seg(p, v1, v0, s, d);
    d = seg(p, v2, v1, s, d);
    d = seg(p, v3, v2, s, d);

    return s * sqrt(d);
}

vec2 normalize_coord(vec2 value, float isPosition) {
    return (value * 2.0 - iResolution.xy * isPosition) / iResolution.y;
}

float blend(float t) {
    float sqr = t * t;
    return sqr / (2.0 * (sqr - t) + 1.0);
}

float antialising(float distance) {
    return 1.0 - smoothstep(0.0, AA_WIDTH / iResolution.y, distance);
}

float determineStartVertexFactor(vec2 a, vec2 b) {
    float condition1 = step(b.x, a.x) * step(a.y, b.y);
    float condition2 = step(a.x, b.x) * step(b.y, a.y);
    return 1.0 - max(condition1, condition2);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return rectangle.xy + vec2(rectangle.z * 0.5, -rectangle.w * 0.5);
}

vec4 applyTrail(vec4 baseColor, vec2 fragCoord) {
    vec2 vu = normalize_coord(fragCoord, 1.0);

    vec4 currentCursor = vec4(normalize_coord(iCurrentCursor.xy, 1.0), normalize_coord(iCurrentCursor.zw, 0.0));
    vec4 previousCursor = vec4(normalize_coord(iPreviousCursor.xy, 1.0), normalize_coord(iPreviousCursor.zw, 0.0));

    float vertexFactor = determineStartVertexFactor(currentCursor.xy, previousCursor.xy);
    float invertedVertexFactor = 1.0 - vertexFactor;

    vec2 v0 = vec2(currentCursor.x + currentCursor.z * vertexFactor, currentCursor.y - currentCursor.w);
    vec2 v1 = vec2(currentCursor.x + currentCursor.z * invertedVertexFactor, currentCursor.y);
    vec2 v2 = vec2(previousCursor.x + currentCursor.z * invertedVertexFactor, previousCursor.y);
    vec2 v3 = vec2(previousCursor.x + currentCursor.z * vertexFactor, previousCursor.y - previousCursor.w);

    float progress = blend(clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0));
    float easedProgress = ease(progress);

    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);
    float cursorSize = max(currentCursor.z, currentCursor.w);
    float trailThreshold = DRAW_THRESHOLD * cursorSize;
    float lineLength = distance(centerCC, centerCP);

    bool isFarEnough = lineLength > trailThreshold;
    bool isOnSeparateLine = HIDE_TRAILS_ON_THE_SAME_LINE ? (currentCursor.y != previousCursor.y) : true;

    if (isFarEnough && isOnSeparateLine) {
        float distanceToEnd = distance(vu, centerCC);
        float alphaModifier = clamp(distanceToEnd / (lineLength * easedProgress), 0.0, 1.0);

        vec2 cursorCenter = currentCursor.xy - currentCursor.zw * OFFSET_FACTOR;
        vec2 cursorHalfSize = currentCursor.zw * 0.5;
        float sdfCursor = getSdfRectangle(vu, cursorCenter, cursorHalfSize);
        float sdfTrail = getSdfParallelogram(vu, v0, v1, v2, v3);

        vec4 newColor = mix(baseColor, TRAIL_COLOR_ACCENT, 1.0 - smoothstep(-0.01, 0.001, sdfTrail));
        newColor = mix(newColor, TRAIL_COLOR, antialising(sdfTrail));
        newColor = mix(baseColor, newColor, 1.0 - alphaModifier);

        return mix(newColor, baseColor, step(sdfCursor, 0.0));
    }

    return baseColor;
}

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

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;

    // Start from the raw terminal frame, then layer effects on top
    vec4 color = texture(iChannel0, uv);
    color = applyGlow(color, uv);
    color = applyTrail(color, fragCoord);
    color = applyEdgeGlow(color, uv);
    color = applySpotlight(color, fragCoord);
    fragColor = color;
}
