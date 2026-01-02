// Optimized Ghostty Cursor Shader
// Replaces segment loops with direct convex quad SDF and vectorized logic.

float sdBox(in vec2 p, in vec2 b) {
    vec2 d = abs(p) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float sdQuad(in vec2 p, vec2 a, vec2 b, vec2 c, vec2 d) {
    vec2 ba = b - a, pa = p - a;
    vec2 cb = c - b, pb = p - b;
    vec2 dc = d - c, pc = p - c;
    vec2 ad = a - d, pd = p - d;

    // Distance to edges (squared)
    vec2 w = ba * clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0) - pa;
    float d2 = dot(w, w);
    w = cb * clamp(dot(pb, cb) / dot(cb, cb), 0.0, 1.0) - pb;
    d2 = min(d2, dot(w, w));
    w = dc * clamp(dot(pc, dc) / dot(dc, dc), 0.0, 1.0) - pc;
    d2 = min(d2, dot(w, w));
    w = ad * clamp(dot(pd, ad) / dot(ad, ad), 0.0, 1.0) - pd;
    d2 = min(d2, dot(w, w));

    // Winding number for sign
    float s = sign(ba.x * pa.y - ba.y * pa.x);
    s += sign(cb.x * pb.y - cb.y * pb.x);
    s += sign(dc.x * pc.y - dc.y * pc.x);
    s += sign(ad.x * pd.y - ad.y * pd.x);

    // If inside (abs(s) ~ 4), distance is negative
    return sqrt(d2) * (step(3.5, abs(s)) * -2.0 + 1.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord / iResolution);
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;

    // Normalize cursors
    vec4 cur = vec4((iCurrentCursor.xy * 2.0 - iResolution.xy) / iResolution.y, iCurrentCursor.zw * 2.0 / iResolution.y);
    vec4 prev = vec4((iPreviousCursor.xy * 2.0 - iResolution.xy) / iResolution.y, iPreviousCursor.zw * 2.0 / iResolution.y);

    // Determine winding factor
    float f1 = step(prev.x, cur.x) * step(cur.y, prev.y);
    float f2 = step(cur.x, prev.x) * step(prev.y, cur.y);
    float v = 1.0 - max(f1, f2); 
    float vInv = 1.0 - v;

    // Parallelogram vertices
    vec2 v0 = vec2(cur.x + cur.z * v, cur.y - cur.w);
    vec2 v1 = vec2(cur.x + cur.z * vInv, cur.y);
    vec2 v2 = vec2(prev.x + cur.z * vInv, prev.y);
    vec2 v3 = vec2(prev.x + cur.z * v, prev.y - prev.w);

    // Calculate SDFs
    vec2 boxCenter = cur.xy + cur.zw * vec2(0.5, -0.5);
    float dBox = sdBox(uv - boxCenter, cur.zw * 0.5);
    float dTrail = sdQuad(uv, v0, v1, v2, v3);

    // Animation & Blending
    float progress = clamp((iTime - iTimeCursorChange) / 0.08, 0.0, 1.0);
    progress = pow(1.0 - progress, 3.0);
    float lineLen = distance(boxCenter, prev.xy + prev.zw * vec2(0.5, -0.5));

    vec4 trail = iCurrentCursorColor;
    float lum = dot(trail, vec4(0.299, 0.587, 0.114, 0.0));
    trail.rgb = mix(vec3(lum), trail.rgb, 2.5);

    // AA Width
    float aa = 2.0 / iResolution.y;
    vec4 col = fragColor;

    col = mix(col, trail, 1.0 - smoothstep(0.0, aa, dTrail));
    col = mix(col, trail, 1.0 - smoothstep(0.0, aa, dBox));
    col = mix(col, fragColor, step(dBox, 0.0)); 
    fragColor = mix(fragColor, col, step(dBox, progress * lineLen));
}
