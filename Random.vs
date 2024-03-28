// Author:
// Title:

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.141592;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float rand1(float x) {
    return fract(sin(x)*1.);
    // return fract(x*1.);
}

float rand2(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233)))*43758.5453123);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec3 color;
    
    // スクリーンの座標を調整
    st *= 2.;
    st.x *= 20.;
    st.y = floor(st.y);
    st.x = floor(st.x);

    // 画面の上半分が右に、下半分が左に動くように調整
    if (st.y >= 1.0) {
        // 画面の上半分
        st.x += (u_time*.000005)*.5; // ここでの動きの速度や方向を調整します。
    } else {
        // 画面の下半分
        st.x -= (u_time*.000005)*.5; // ここでの動きの速度や方向を調整します。
    }

    color.rgb = vec3(step(.5, rand2(vec2(st.x, st.y))));

    gl_FragColor = vec4(color, 1);
}
