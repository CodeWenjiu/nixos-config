// Based on https://gist.github.com/chardskarth/95874c54e29da6b5a36ab7b50ae2d088
float ease(float x) {
    return pow(1.0 - x, 10.0);
}

float sdBox(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// Based on Inigo Quilez's 2D distance functions article: https://iquilezles.org/articles/distfunctions2d/
// Potencially optimized by eliminating conditionals and loops to enhance performance and reduce branching
float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    float segd = dot(p - proj, p - proj);
    d = min(d, segd);

    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float allCond = c0 * c1 * c2;
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    s *= flip;
    return d;
}

float getSdfParallelogram(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3) {
    float s = 1.0;
    float d = dot(p - v0, p - v0);

    d = seg(p, v0, v3, s, d);
    d = seg(p, v1, v0, s, d);
    d = seg(p, v2, v1, s, d);
    d = seg(p, v3, v2, s, d);

    return s * sqrt(d);
}

vec2 normalize(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float blend(float t)
{
    float sqr = t * t;
    return sqr / (2.0 * (sqr - t) + 1.0);
}

float antialising(float distance) {
    return 1. - smoothstep(0., normalize(vec2(2., 2.), 0.).x, distance);
}

float determineStartVertexFactor(vec2 a, vec2 b) {
    // Conditions using step
    float condition1 = step(b.x, a.x) * step(a.y, b.y); // a.x < b.x && a.y > b.y
    float condition2 = step(a.x, b.x) * step(b.y, a.y); // a.x > b.x && a.y < b.y

    // If neither condition is met, return 1 (else case)
    return 1.0 - max(condition1, condition2);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + (rectangle.z / 2.), rectangle.y - (rectangle.w / 2.));
}

// Glow effect sample points
const vec3[24] samples = vec3[24](
        vec3(0.1693761725038636, 0.9855514761735895, 1),
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
        vec3(-3.6548858794907493, -1.6253643308191343, 0.25),
        vec3(1.0130775986052671, -3.9967078676335834, 0.24253562503633297),
        vec3(4.229723673607257, 0.33081361055181563, 0.23570226039551587),
        vec3(0.40107790291173834, 4.340407413572593, 0.22941573387056174),
        vec3(-4.319124570236028, 1.159811599693438, 0.22360679774997896),
        vec3(-1.9209044802827355, -4.160543952132907, 0.2182178902359924),
        vec3(3.8639122286635708, -2.6589814382925123, 0.21320071635561041),
        vec3(3.3486228404946234, 3.4331800232609, 0.20851441405707477),
        vec3(-2.8769733643574344, 3.9652268864187157, 0.20412414523193154)
    );

// Luminance function for glow effect
float lum(vec4 c) {
    return 0.299 * c.r + 0.587 * c.g + 0.114 * c.b;
}

// Apply glow effect to the input color
vec4 applyGlow(vec4 baseColor, vec2 uv) {
    vec4 color = baseColor;
    vec2 step = vec2(1.414) / iResolution.xy;

    for (int i = 0; i < 24; i++) {
        vec3 s = samples[i];
        vec4 c = texture(iChannel0, uv + s.xy * step);
        float l = lum(c);
        if (l > 0.4) {
            color += l * s.z * c * 0.08;
        }
    }

    return color;
}

const vec4 TRAIL_COLOR = vec4(1.0, 1.0, 1.0, 1.0);
const vec4 CURRENT_CURSOR_COLOR = TRAIL_COLOR;
const vec4 PREVIOUS_CURSOR_COLOR = TRAIL_COLOR;
const vec4 TRAIL_COLOR_ACCENT = vec4(0., 0., 0., 1.0);
const float DURATION = .5;
const float OPACITY = .2;
// Don't draw trail within that distance * cursor size.
// This prevents trails from appearing when typing.
const float DRAW_THRESHOLD = 1.5;
// Don't draw trails within the same line: same line jumps are usually where
// people expect them.
const bool HIDE_TRAILS_ON_THE_SAME_LINE = false;

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy / iResolution.xy;

    #if !defined(WEB)
    fragColor = texture(iChannel0, uv);
    #endif

    // Apply glow effect to the base texture
    fragColor = applyGlow(fragColor, uv);

    //Normalization for fragCoord to a space of -1 to 1;
    vec2 vu = normalize(fragCoord, 1.);
    vec2 offsetFactor = vec2(-.5, 0.5);

    //Normalization for cursor position and size;
    //cursor xy has the postion in a space of -1 to 1;
    //zw has the width and height
    vec4 currentCursor = vec4(normalize(iCurrentCursor.xy, 1.), normalize(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(normalize(iPreviousCursor.xy, 1.), normalize(iPreviousCursor.zw, 0.));

    //When drawing a parellelogram between cursors for the trail i need to determine where to start at the top-left or top-right vertex of the cursor
    float vertexFactor = determineStartVertexFactor(currentCursor.xy, previousCursor.xy);
    float invertedVertexFactor = 1.0 - vertexFactor;

    //Set every vertex of my parellogram
    vec2 v0 = vec2(currentCursor.x + currentCursor.z * vertexFactor, currentCursor.y - currentCursor.w);
    vec2 v1 = vec2(currentCursor.x + currentCursor.z * invertedVertexFactor, currentCursor.y);
    vec2 v2 = vec2(previousCursor.x + currentCursor.z * invertedVertexFactor, previousCursor.y);
    vec2 v3 = vec2(previousCursor.x + currentCursor.z * vertexFactor, previousCursor.y - previousCursor.w);

    vec4 newColor = vec4(fragColor);

    float progress = blend(clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1));
    float easedProgress = ease(progress);

    //Distance between cursors determine the total length of the parallelogram;
    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);
    float cursorSize = max(currentCursor.z, currentCursor.w);
    float trailThreshold = DRAW_THRESHOLD * cursorSize;
    float lineLength = distance(centerCC, centerCP);
    //
    bool isFarEnough = lineLength > trailThreshold;
    bool isOnSeparateLine = HIDE_TRAILS_ON_THE_SAME_LINE ? currentCursor.y != previousCursor.y : true;
    if (isFarEnough && isOnSeparateLine) {
        float distanceToEnd = distance(vu.xy, centerCC);
        float alphaModifier = distanceToEnd / (lineLength * (easedProgress));

        if (alphaModifier > 1.0) { // this change fixed it for me.
            alphaModifier = 1.0;
        }

        float sdfCursor = getSdfRectangle(vu, currentCursor.xy - (currentCursor.zw * offsetFactor), currentCursor.zw * 0.5);
        float sdfTrail = getSdfParallelogram(vu, v0, v1, v2, v3);

        newColor = mix(newColor, TRAIL_COLOR_ACCENT, 1.0 - smoothstep(sdfTrail, -0.01, 0.001));
        newColor = mix(newColor, TRAIL_COLOR, antialising(sdfTrail));
        newColor = mix(fragColor, newColor, 1.0 - alphaModifier);
        fragColor = mix(newColor, fragColor, step(sdfCursor, 0));
    }
}
