#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float rand(in float x) {
    return fract(sin(x)*1e4);
}

// 2D Random
float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}

float noise(float x) {
    float i = floor(x);
    float f = fract(x);
    float y = rand(i);
    y = mix(rand(i), rand(i + 1.), f);
    y = mix(rand(i), rand(i + 1.0), smoothstep(0.,1.,f));
    return y;
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    float width = .05;
    //st = gl_FragCoord.xy*2. - u_resolution.xy/min(u_resolution.x, u_resolution.y);
    st.x *= 4.;

    vec4 color = vec4(1.);
    
    color.rgb = vec3(step(noise(st.x-width),st.y)); 

    gl_FragColor = vec4(color);
}
