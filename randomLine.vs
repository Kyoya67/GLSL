// Author @patriciogv - 2015
// Title: Truchet - 10 print

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265358979323846

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

// vec2 truchetPattern(in vec2 _st, in float _index){
//     float timeFactor = sin(u_time * 0.2) * 0.5 + 0.5; // 0から1まで滑らかに変化
//     _index = fract(timeFactor * _index);

//     if (_index > 0.75) {
//         _st = vec2(1.0) - _st;
//     } else if (_index > 0.5) {
//         _st = vec2(1.0-_st.x,_st.y);
//     } else if (_index > 0.25) {
//         _st = 1.0-vec2(1.0-_st.x,_st.y);
//     }
//     return _st;
// }

vec2 truchetPattern1(in vec2 _st, in float _index){
    _index = fract(((_index-0.5)*2.0)*u_time);
    if (_index > 0.75) {
        _st = vec2(1.0) - _st;
    } else if (_index > 0.5) {
        _st = vec2(1.0-_st.x,_st.y);
    } else if (_index > 0.25) {
        _st = 1.0-vec2(1.0-_st.x,_st.y);
    }
    return _st;
}


vec2 truchetPattern2(in vec2 _st, float _time){
    float transition = smoothstep(0.0, 1.0, sin(u_time * PI * 0.2));

    // パターンの滑らかな遷移を計算
    vec2 pattern1 = vec2(_st.x, _st.y); // 初期パターン
    vec2 pattern2 = vec2(1.0 - _st.x, 1.0 - _st.y); // 反転パターン

    // 2つのパターン間で滑らかに補間
    vec2 result = mix(pattern1, pattern2, transition);

    return result;
}

vec2 scale(in vec2 _st, float n){
    return vec2(_st.x * n, _st.y * n);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st *= 10.0;
    st.x += 1.*u_time;
    st = scale(st, 2.*sin(u_time*.5));
    // st = (st-vec2(5.0))*(abs(sin(u_time*0.2))*5.);
    //st.x += u_time*1.0;

    vec2 ipos = floor(st);  // integer
    vec2 fpos = fract(st);  // fraction

    vec2 tile = truchetPattern1(fpos, random( ipos ));
    //vec2 tile = truchetPattern2(fpos, random( ipos ));

    float color = 0.0;

    // Maze
    // color = smoothstep(tile.x-0.3,tile.x,tile.y)-
    //         smoothstep(tile.x,tile.x+0.3,tile.y);

    color = step(tile.x-.05,tile.y) - step(tile.x+.05,tile.y);

    // Circles
    float weight = sin(u_time)*.5 + .5;
    weight = 1.;

    color = (step(length(tile),0.6 * weight) -
             step(length(tile),0.4 * weight) ) +
            (step(length(tile-vec2(1.)),0.6 * weight) -
             step(length(tile-vec2(1.)),0.4 * weight) );

    // Truchet (2 triangles)
    //color = step(tile.x,tile.y);

    gl_FragColor = vec4(vec3(color,0,color*.3),1.0);
}
