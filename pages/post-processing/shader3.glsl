#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform sampler2D u_texture;
varying vec2 v_texcoord;

void main( void ) {     
    vec2 cntr = v_texcoord - u_mouse/u_resolution;
    vec2 uv = v_texcoord + cntr*tan(length(cntr)-u_time)*0.05;
    
    gl_FragColor = texture2D(u_texture,uv);  
}
