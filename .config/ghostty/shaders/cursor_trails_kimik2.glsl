// cursor_trails.glsl  –  Ghostty cursor-trail shader
// Short, snappy, buttery.  Trail length ~½ s, no motion lag.

float sdBox(in vec2 p, in vec2 half) {
    vec2 q = abs(p) - half;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0);
}

// 2-segment parallelogram SDF (cheap & branch-free)
float sdPara(in vec2 p, vec2 a, vec2 b, vec2 c, vec2 d) {
    // edge normals
    vec2 n0 = normalize(vec2(a.y - b.y, b.x - a.x));
    vec2 n1 = normalize(vec2(b.y - c.y, c.x - b.x));
    vec2 n2 = normalize(vec2(c.y - d.y, d.x - c.x));
    vec2 n3 = normalize(vec2(d.y - a.y, a.x - d.x));

    // distances
    float d0 = dot(p - a, n0);
    float d1 = dot(p - b, n1);
    float d2 = dot(p - c, n2);
    float d3 = dot(p - d, n3);

    // inside test
    float inside = min(min(d0, d1), min(d2, d3));
    return max(inside, -sdBox(p - 0.5 * (a + c), abs(b - a) + abs(d - a) * 0.5));
}

vec2 norm(in vec2 v, bool isPos) {
    return (v * 2.0 - (isPos ? iResolution.xy : 0.0)) / iResolution.y;
}

float aastep(float d) {
    return 1.0 - smoothstep(0.0, 1.5 / iResolution.y, d);
}

const float TRAIL_TIME   = 0.45;   // seconds trail is visible
const float FADE_IN      = 0.08;
const float FADE_OUT     = 0.25;

void mainImage(out vec4 O, in vec2 U) {
    O = texture(iChannel0, U / iResolution.xy);

    vec2 uv = norm(U, true);
    vec4 cur  = vec4(norm(iCurrentCursor.xy, true),  norm(iCurrentCursor.zw, false));
    vec4 prev = vec4(norm(iPreviousCursor.xy, true), norm(iPreviousCursor.zw, false));

    float t = iTime - iTimeCursorChange;
    float moving = step(t, TRAIL_TIME);

    // parallelogram vertices (top-left → clockwise)
    vec2 p0 = cur.xy - cur.zw * 0.5;
    vec2 p1 = cur.xy + vec2(cur.z, -cur.w) * 0.5;
    vec2 p2 = prev.xy + vec2(prev.z, -prev.w) * 0.5;
    vec2 p3 = prev.xy - prev.zw * 0.5;

    float sdT = sdPara(uv, p0, p1, p2, p3);
    float sdC = sdBox(uv - cur.xy, cur.zw * 0.5);

    float alphaT = aastep(sdT) * moving;
    float alphaC = aastep(sdC);

    // fade along trail
    float dist = length(uv - mix(prev.xy, cur.xy, 0.5));
    float maxLen = distance(prev.xy, cur.xy);
    float fade = smoothstep(maxLen, 0.0, dist * 1.5);

    // temporal fade
    float fi = smoothstep(0.0, FADE_IN, t);
    float fo = 1.0 - smoothstep(TRAIL_TIME - FADE_OUT, TRAIL_TIME, t);
    fade *= fi * fo;

    vec4 trail = vec4(iCurrentCursorColor.rgb, 0.75) * fade;
    O = mix(O, trail, alphaT * trail.a);
    O = mix(O, vec4(iCurrentCursorColor.rgb, 1.0), alphaC);
}
