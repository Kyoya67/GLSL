#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// 球体を描画するための関数
float drawCircle(vec2 center, float radius, vec2 position) {
    return smoothstep(radius, radius + 0.01, distance(center, position));
}

void main() {
    vec2 position = gl_FragCoord.xy / u_resolution.xy;
    float aspectRatio = u_resolution.x / u_resolution.y;
    
    // 色とりどりの球体を描画
    float circle = 0.0;
    for (int i = 0; i < 10; i++) {
        vec2 center = vec2(sin(u_time + float(i)), cos(u_time + float(i) * 0.5)) * 0.5 + 0.5;
        center.x *= aspectRatio;
        circle += drawCircle(center, 0.1, position);
    }

    gl_FragColor = vec4(circle, circle * 0.5, circle * 0.8, 1.0);
}
