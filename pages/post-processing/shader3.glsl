#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform float u_time;
uniform vec2 u_resolution;
uniform sampler2D u_texture;
varying vec2 v_texcoord;

void main( void ) {     
    vec2 cntr = v_texcoord - 0.5;
    vec2 uv = v_texcoord - (cntr/0.5)*tan(length(cntr)-u_time)*0.05;
    vec3 col = texture2D(u_texture,uv).xyz;
    gl_FragColor = vec4(col,1.0);  
}