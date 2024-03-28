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
float rand (in vec2 st) {
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

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = rand(i);
    float b = rand(i + vec2(1.,0));
    float c = rand(i + vec2(0.,1));
    float d = rand(i + vec2(1.,1));
    
	vec2 u = smoothstep(0.,1.,f);
    //float u = smoothstep(0.,1.,f.x);
    //vec2 u = step(.5,f);
    
    return (1.-u.x)*(1.-u.y)*a + u.x*(1.-u.y)*b + (1.-u.x)*u.y*c + u.x*u.y*d;
}

float circle(vec2 st, vec2 center, float r) {
    return step(r, length(st-center)) - step(r+.001, length(st-center));
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    float a = 5.;
    st *= a;
	float n = noise(st + u_time);
    // float n = noise(st.x + u_time);
    
    float d = distance(st, vec2( ( floor(st) + ceil(st) ) * .5 )); // 中心からの距離
    float color = smoothstep(0.3, 0.0, d - n * 0.2);

    gl_FragColor = vec4(vec3(color)*3., 1.0);
}
