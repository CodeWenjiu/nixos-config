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
