// Author:
// Title:

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    //vec2 st = (gl_FragColor.xy*2. - u_resolution) / min(u_resolution.x, u_resolution.y);
    vec4 color = vec4(0.);
    vec2 center = vec2(.5);

    float t = 1. - length(st - center) * (sin(u_time)*.5 + .5)*2.;
    color.rgb = vec3(pow(t, 5.));
    color.rgb = vec3(.1 / length(center - st));
    color.a = 1.;

    gl_FragColor = vec4(color);
}