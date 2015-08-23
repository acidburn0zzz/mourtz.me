#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;

float rounded_rect(vec2 _position, vec2 _scale, float _rounding){
	float r = 0.5*_scale.y*(1.0+_rounding);  // animate rounding
	vec2  b = _scale-r;
  	float d = length(max(abs(_position)-b, 0.0))-r;
	return 1.0-smoothstep(0.0,0.003,d);
}

void main( void ) 
{
  vec2 surfacePosition = gl_FragCoord.xy/u_resolution.xy;	
  vec2  p = 2.0*(surfacePosition-0.5);	
    
  vec3 c = vec3(rounded_rect(vec2(p.x,p.y),vec2(0.8*max(0.4,abs(sin(u_time)))),abs(cos(u_time))));
  gl_FragColor = vec4(c, 1.0);
}
