#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_mouse;
uniform vec2 u_resolution;

#define PI 3.14159265359
#define TWO_PI 6.28318530718

float polygon(vec2 _st, vec2 _position, float _sides, float _scale){
    vec2 l = _st * _scale;
    l -= _position*_scale;
    float a = atan(l.x,l.y)+PI;
    float r = TWO_PI/_sides;
    return cos(floor(.5+a/r)*r-a)*length(l);
}

void main(void){
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st *= 4.0;
  	st -= 2.0;
    vec3 color = vec3(0.0);
    float d = 0.0;
    color += vec3(1.0-smoothstep(.4,.41,polygon(st, vec2(sin(u_time),cos(u_time)), 5.0 + (1.0-abs(sin(u_time*3.0)))*10.0, 1.0+abs(sin(u_time*3.0)))));

    gl_FragColor = vec4(color,1.0);
}
