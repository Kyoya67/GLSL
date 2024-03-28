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

float circle(vec2 st, vec2 center, float r) {
    return step(r, length(st-center)) - step(r+.001, length(st-center));
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    float width = .05;
    //st.x *= 4.;
    vec2 center = vec2(.5, .5);
    vec4 color = vec4(1.);
    
    color.rgb = vec3(circle(st, center, noise(st.x+u_time)*.5));
    
    //color.rgb = vec3(step(noise(st.x+u_time),st.y)); 

    gl_FragColor = vec4(color);
}
