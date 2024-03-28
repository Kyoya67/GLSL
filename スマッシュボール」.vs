#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float noise(vec2 pos) {
    return (sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453123 * .00001);
}

vec3 circle(vec2 _center, vec2 _st) {
    return vec3(1. - step(.4,length(_center - _st)));
}

vec3 cross(vec2 _center, vec2 _st, vec2 _width){
	float x = step(_center.x - _width.x, _st.x) - step(_center.x + _width.x, _st.x);
    float y = step(_center.y - _width.y, _st.y) - step(_center.y + _width.y, _st.y);
    return vec3(1. - (x + y));
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution;
    vec2 center = vec2(0.);
   st = st * 2.0 - 1.0; // Normalize space to -1.0 to 1.0
    //st.x *= u_resolution.x / u_resolution.y; // Correct for non-square resolutions
    
    vec2 noiseCenter = vec2(
        noise(vec2(cos(u_time * .005), u_time * .015)),
        noise(vec2(sin(u_time * .005), u_time *.015))
    );


    float radius = length(st);
    float angle = atan(st.y, st.x);

    // Bright core
    float core = smoothstep(0.3, 0.0, radius);

    // Color variation
    vec3 color = vec3(0.7 + 0.3 * cos(angle + u_time*5.),
                      0.7 + 0.3 * cos(angle * 2.0 - u_time*5.),
                      0.7 + 0.3 * cos(angle + u_time*5. / 2.0));
    
   //vec3 clip = circle(center, st);
    vec3 clip = circle(noiseCenter, st);
    
    // 十字架のサイズと幅を定義します。
    vec2 crossWidth = vec2(
       0.05 * abs(noise(vec2(cos(u_time * .005), sin(u_time * .0012)))) + 0.05,
       0.05 * abs(noise(vec2(sin(u_time * .005), cos(u_time *.0012)))) + 0.05
    ); // 十字架の幅

    // 十字架のマスクを作成します。
    vec2 crossCenter = vec2(noiseCenter.x + noise(vec2(cos(u_time * .02))) * .2,
                            noiseCenter.y + noise(vec2(sin(u_time * .02))) * .2);
    
    vec3 maskCross = cross(crossCenter , st, crossWidth);
    
    // Dynamic flares
    //float flare = pow(radius, 3.0) * sin(u_time - radius * 10.0) * 0.05;

    // Combine effects
    color = mix(color, vec3(1.0, 1.0, 1.0), core );
    
    color *= clip;
    color *= maskCross;
    
    gl_FragColor = vec4(color, 1.0);
}



