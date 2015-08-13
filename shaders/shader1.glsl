// Author @patriciogv ( patriciogonzalezvivo.com ) - 2015

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265358979323846

float rect(in vec2 _st,in vec2 _position,in vec2 _scale,in float _smoothEdges){
    _st -= _position - 0.4;
	_scale /= 2.0;
    vec2 aa = vec2(_smoothEdges*0.5);
    vec2 uv = smoothstep(_scale,_scale+aa,_st);
    uv *= smoothstep(_scale,_scale+aa,vec2(1.0)-_st);
    return uv.x*uv.y;
}

void main(void){
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec3 color = vec3(0.0);
	st += 0.15;
    // Divide the space in 10
    st = fract(st * asin(st.y) *10.0);
    // Draw a square
    color = mix(vec3(rect(st,vec2(0.2),vec2(0.5),0.01)), vec3(abs(sin(u_time))), vec3(rect(st,vec2(0.2)-abs(sin(u_time)),vec2(0.5),0.01)));
    color += mix(vec3(rect(st,vec2(0.7),vec2(0.5),0.01)), vec3(abs(sin(u_time))), vec3(rect(st,vec2(0.7),vec2(0.5),0.01)));

    gl_FragColor = vec4(color,1.0);    
}