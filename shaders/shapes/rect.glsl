#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float rect(in vec2 _st,in vec2 _position,in vec2 _scale,in float _smoothEdges){
    _st -= _position - 0.4;
	_scale /= 2.0;
    vec2 aa = vec2(_smoothEdges*0.5);
    vec2 uv = smoothstep(_scale,_scale+aa,_st);
    uv *= smoothstep(_scale,_scale+aa,vec2(1.0)-_st);
    return uv.x*uv.y;
    //return step(vec2(_scale.x),_st).x * step(vec2(_scale.y),_st).y * step(vec2(_scale.x),1.0 - _st).x * step(vec2(_scale.y),1.0 - _st).y;
}

void main(){
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st *= 4.0;
    st -= 2.0;
    vec3 color = vec3(0.0);
    vec3 rect_color = vec3(1.0);
    color += vec3(rect(st, vec2(sin(u_time),cos(u_time)), vec2(abs(sin(u_time*3.0))),0.01)) * rect_color;

    gl_FragColor = vec4(color,1.0);
}
