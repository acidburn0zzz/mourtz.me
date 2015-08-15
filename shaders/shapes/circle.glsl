#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float circle(vec2 _st, vec2 _position, float _radius){
    vec2 l = _st - _position;
    return 1.-smoothstep(_radius-(_radius*0.01),
                         _radius+(_radius*0.01),
                         dot(l,l)*4.0);
}

void main(){
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st *= 4.0;
  st -= 2.0;
  vec3 color = vec3(0.0);
  color += vec3(circle(st,vec2(sin(u_time),cos(u_time)),abs(sin(u_time*3.0))));

  gl_FragColor = vec4( color, 1.0);
}
