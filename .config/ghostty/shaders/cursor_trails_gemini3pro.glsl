// Constant optimizations
const float OPACITY = 0.6;
const float DURATION = 0.05; // Reduced for snappiness
const float THICKNESS = 0.0; // Adjust if you want a thicker stroke

// Branchless segment distance
float udSegment(in vec2 p, in vec2 a, in vec2 b) {
    vec2 ba = b - a;
    vec2 pa = p - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

// Optimized Parallelogram SDF using Barycentric coordinates for interior check
// and standard segment distance for edges.
float getSdfParallelogram(vec2 p, vec2 v0, vec2 v1, vec2 v2, vec2 v3) {
    // 1. Edge Distances (Unsigned)
    float d = min(udSegment(p, v0, v1), udSegment(p, v1, v2));
    d = min(d, min(udSegment(p, v2, v3), udSegment(p, v3, v0)));

    // 2. Interior Check (Barycentric)
    // Using v0 as origin, v1 and v3 as basis vectors
    vec2 b1 = v1 - v0;
    vec2 b2 = v3 - v0;
    vec2 p0 = p - v0;
    
    // 2D Determinant
    float det = b1.x * b2.y - b1.y * b2.x;
    
    // Solve p0 = s * b1 + t * b2
    float s = (p0.x * b2.y - p0.y * b2.x) / det;
    float t = (b1.x * p0.y - b1.y * p0.x) / det;

    // If s and t are in [0,1], we are inside
    float isInside = step(0.0, s) * step(s, 1.0) * step(0.0, t) * step(t, 1.0);
    
    // Flip sign if inside
    return mix(d, -d, isInside);
}

float getSdfRectangle(vec2 p, vec2 center, vec2 extents) {
    vec2 d = abs(p - center) - extents;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Precompute inverse Y for normalization
    float invResY = 1.0 / iResolution.y;
    vec2 uv = fragCoord * invResY;
    vec4 texColor = texture(iChannel0, fragCoord / iResolution.xy);

    // Normalize coords to -1..1 space based on height
    vec2 vu = uv * 2.0 - vec2(iResolution.x * invResY, 1.0);

    // Normalize Cursors
    // xy = pos, zw = size
    vec4 cur = iCurrentCursor;
    vec4 prev = iPreviousCursor;
    
    vec4 cNorm = vec4(
        (cur.xy * 2.0 - iResolution.xy) * invResY, 
        cur.zw * invResY
    );
    vec4 pNorm = vec4(
        (prev.xy * 2.0 - iResolution.xy) * invResY, 
        prev.zw * invResY
    );

    // Vertex Factor Logic (Simplified)
    // Determine connection points based on relative position
    // If moving right/down or left/up, we connect different corners.
    vec2 delta = cNorm.xy - pNorm.xy;
    float vf = 1.0 - step(0.0, delta.x * delta.y); // XOR logic for diagonal selection
    float invVf = 1.0 - vf;

    // Vertices
    vec2 v0 = vec2(cNorm.x + cNorm.z * vf, cNorm.y - cNorm.w);
    vec2 v1 = vec2(cNorm.x + cNorm.z * invVf, cNorm.y);
    vec2 v2 = vec2(pNorm.x + cNorm.z * invVf, pNorm.y);
    vec2 v3 = vec2(pNorm.x + cNorm.z * vf, pNorm.y - pNorm.w);

    // SDF Calculations
    // Center alignment adjustment for rectangle
    vec2 rectCenter = cNorm.xy + vec2(cNorm.z, -cNorm.w) * 0.5;
    float sdfRect = getSdfRectangle(vu, rectCenter, cNorm.zw * 0.5);
    float sdfTrail = getSdfParallelogram(vu, v0, v1, v2, v3);

    // Animation / Saturation
    float progress = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    float alpha = pow(1.0 - progress, 3.0); // Cubic ease inline

    // Color mixing
    vec4 trailColor = iCurrentCursorColor;
    float gray = dot(trailColor.rgb, vec3(0.299, 0.587, 0.114));
    trailColor = mix(vec4(gray), trailColor, 2.5); // Saturate inline

    // Antialiasing factor
    float aa = 2.0 * invResY; // Approx 2 pixels width

    // Composition
    vec4 finalColor = texColor;
    
    // Mix Trail
    float trailAlpha = smoothstep(aa, 0.0, sdfTrail);
    finalColor = mix(finalColor, trailColor, trailAlpha * alpha * OPACITY);

    // Mix Cursor
    float cursorAlpha = smoothstep(aa, 0.0, sdfRect);
    finalColor = mix(finalColor, trailColor, cursorAlpha);
    
    // Optional: Fill cursor interior strictly if requested, 
    // but the SDF mix above handles edges + interior cleanly.

    fragColor = finalColor;
}
